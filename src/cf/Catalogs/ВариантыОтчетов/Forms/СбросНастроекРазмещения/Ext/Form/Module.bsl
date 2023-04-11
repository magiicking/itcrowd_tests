﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Варианты = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "Варианты"); // Массив из СправочникСсылка.ВариантыОтчетов
	Если ТипЗнч(Варианты) <> Тип("Массив") Тогда
		ТекстОшибки = НСтр("ru = 'Не указаны варианты отчетов.'");
		Возврат;
	КонецЕсли;
	
	ОпределитьПоведениеВМобильномКлиенте();
	ИзменяемыеВарианты.ЗагрузитьЗначения(Варианты);
	Отфильтровать();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если Не ПустаяСтрока(ТекстОшибки) Тогда
		Отказ = Истина;
		ПоказатьПредупреждение(, ТекстОшибки);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаСбросить(Команда)
	КоличествоВыбранныхВариантов = ИзменяемыеВарианты.Количество();
	Если КоличествоВыбранныхВариантов = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Не указаны варианты отчетов.'"));
		Возврат;
	КонецЕсли;
	
	КоличествоВариантов = СброситьНастройкиРазмещенияСервер(ИзменяемыеВарианты);
	Если КоличествоВариантов = 1 И КоличествоВыбранныхВариантов = 1 Тогда
		СсылкаВарианта = ИзменяемыеВарианты[0].Значение;
		ОповещениеЗаголовок = НСтр("ru = 'Сброшены настройки размещения варианта отчета'");
		ОповещениеСсылка    = ПолучитьНавигационнуюСсылку(СсылкаВарианта);
		ОповещениеТекст     = Строка(СсылкаВарианта);
		ПоказатьОповещениеПользователя(ОповещениеЗаголовок, ОповещениеСсылка, ОповещениеТекст);
	Иначе
		ОповещениеТекст = НСтр("ru = 'Сброшены настройки размещения
		|вариантов отчетов (%1 шт.).'");
		ОповещениеТекст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ОповещениеТекст, Формат(КоличествоВариантов, "ЧН=0; ЧГ=0"));
		ПоказатьОповещениеПользователя(, , ОповещениеТекст);
	КонецЕсли;
	ВариантыОтчетовКлиент.ОбновитьОткрытыеФормы();
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Вызов сервера

&НаСервереБезКонтекста
Функция СброситьНастройкиРазмещенияСервер(Знач ИзменяемыеВарианты)
	КоличествоВариантов = 0;
	НачатьТранзакцию();
	Попытка
		Блокировка = Новый БлокировкаДанных;
		Для Каждого ЭлементСписка Из ИзменяемыеВарианты Цикл
			ЭлементБлокировки = Блокировка.Добавить(Метаданные.Справочники.ВариантыОтчетов.ПолноеИмя());
			ЭлементБлокировки.УстановитьЗначение("Ссылка", ЭлементСписка.Значение);
		КонецЦикла;
		Блокировка.Заблокировать();
		
		Для Каждого ЭлементСписка Из ИзменяемыеВарианты Цикл
			ВариантОбъект = ЭлементСписка.Значение.ПолучитьОбъект(); // СправочникОбъект.ВариантыОтчетов
			Если ВариантыОтчетов.СброситьНастройкиВариантаОтчета(ВариантОбъект) Тогда
				ВариантОбъект.Записать();
				КоличествоВариантов = КоличествоВариантов + 1;
			КонецЕсли;
		КонецЦикла;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	Возврат КоличествоВариантов;
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Сервер

&НаСервере
Процедура ОпределитьПоведениеВМобильномКлиенте()
	Если Не ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда 
		Возврат;
	КонецЕсли;
	
	ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Авто;
КонецПроцедуры

&НаСервере
Процедура Отфильтровать()
	
	КоличествоДоФильтрации = ИзменяемыеВарианты.Количество();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивВариантов", ИзменяемыеВарианты.ВыгрузитьЗначения());
	Запрос.УстановитьПараметр("ТипВнутренний", Перечисления.ТипыОтчетов.Внутренний);
	Запрос.УстановитьПараметр("ТипРасширение", Перечисления.ТипыОтчетов.Расширение);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВариантыОтчетовРазмещение.Ссылка
	|ИЗ
	|	Справочник.ВариантыОтчетов КАК ВариантыОтчетовРазмещение
	|ГДЕ
	|	ВариантыОтчетовРазмещение.Ссылка В(&МассивВариантов)
	|	И ВариантыОтчетовРазмещение.Пользовательский = ЛОЖЬ
	|	И ВариантыОтчетовРазмещение.ТипОтчета В (&ТипВнутренний, &ТипРасширение)
	|	И ВариантыОтчетовРазмещение.ПометкаУдаления = ЛОЖЬ";
	
	МассивВариантов = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	ИзменяемыеВарианты.ЗагрузитьЗначения(МассивВариантов);
	
	КоличествоПослеФильтрации = ИзменяемыеВарианты.Количество();
	Если КоличествоДоФильтрации <> КоличествоПослеФильтрации Тогда
		Если КоличествоПослеФильтрации = 0 Тогда
			ТекстОшибки = НСтр("ru = 'Сброс настроек размещения выбранных вариантов отчетов не требуется по одной или нескольким причинам:
			|- Выбраны пользовательские варианты отчетов.
			|- Выбраны помеченные на удаление варианты отчетов.
			|- Выбраны варианты дополнительных или внешних отчетов.'");
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
