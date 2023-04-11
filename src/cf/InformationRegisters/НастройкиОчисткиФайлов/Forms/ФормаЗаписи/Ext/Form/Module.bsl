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
	
	Заголовок = НСтр("ru = 'Настройка очистки файлов:'")
		+ " " + Запись.ВладелецФайла;
	
	Если МассивРеквизитовСТипомДата.Количество() = 0 Тогда
		Элементы.ДобавитьУсловиеПоДате.Доступность = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		Элементы.ПравилоНастройкиОтборГруппаКолонокПрименение.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ТекущийОбъект.ПравилоОтбора = Новый ХранилищеЗначения(Правило.ПолучитьНастройки());
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Если ЗначениеЗаполнено(ТекущийОбъект.ВладелецФайла) Тогда
		ИнициализироватьКомпоновщик();
	КонецЕсли;
	Если ТекущийОбъект.ПравилоОтбора.Получить() <> Неопределено Тогда
		Правило.ЗагрузитьНастройки(ТекущийОбъект.ПравилоОтбора.Получить());
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "РегистрСведений.НастройкиОчисткиФайлов.Форма.ФормаДобавленияУсловияПоДате" Тогда
		ДобавитьВОтборИнтервалИсключение(ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ИнициализироватьКомпоновщик()
	
	Если Не ЗначениеЗаполнено(Запись.ВладелецФайла) Тогда
		Возврат;
	КонецЕсли;
	
	Правило.Настройки.Отбор.Элементы.Очистить();
	
	СКД = Новый СхемаКомпоновкиДанных;
	ИсточникДанных = СКД.ИсточникиДанных.Добавить();
	ИсточникДанных.Имя = "ИсточникДанных1";
	ИсточникДанных.ТипИсточникаДанных = "Local";
	
	НаборДанных = СКД.НаборыДанных.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));
	НаборДанных.Имя = "НаборДанных1";
	НаборДанных.ИсточникДанных = ИсточникДанных.Имя;
	
	СКД.ПоляИтога.Очистить();
	
	СКД.НаборыДанных[0].Запрос = ПолучитьТекстЗапроса();
	
	СхемаКомпоновкиДанных = ПоместитьВоВременноеХранилище(СКД, УникальныйИдентификатор);
	
	Правило.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	
	Правило.Восстановить(); 
	Правило.Настройки.Структура.Очистить();
	
КонецПроцедуры

&НаСервере
Функция ПолучитьТекстЗапроса()
	
	МассивРеквизитовСТипомДата.Очистить();
	Если ТипЗнч(Запись.ВладелецФайла) = Тип("СправочникСсылка.ИдентификаторыОбъектовМетаданных") Тогда
		ТипОбъекта = Запись.ВладелецФайла;
	Иначе
		ТипОбъекта = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ТипЗнч(Запись.ВладелецФайла));
	КонецЕсли;
	ВсеСправочники = Справочники.ТипВсеСсылки();
	ВсеДокументы = Документы.ТипВсеСсылки();
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	" + ТипОбъекта.Имя + ".Ссылка,";
	Если ВсеСправочники.СодержитТип(ТипЗнч(ТипОбъекта.ЗначениеПустойСсылки)) Тогда
		Справочник = Метаданные.Справочники[ТипОбъекта.Имя];
		Для Каждого Реквизит Из Справочник.Реквизиты Цикл
			ТекстЗапроса = ТекстЗапроса + Символы.ПС + ТипОбъекта.Имя + "." + Реквизит.Имя + ",";
		КонецЦикла;
	ИначеЕсли
		ВсеДокументы.СодержитТип(ТипЗнч(ТипОбъекта.ЗначениеПустойСсылки)) Тогда
		Документ = Метаданные.Документы[ТипОбъекта.Имя];
		Для Каждого Реквизит Из Документ.Реквизиты Цикл
			ТекстЗапроса = ТекстЗапроса + Символы.ПС + ТипОбъекта.Имя + "." + Реквизит.Имя + ",";
			Если Реквизит.Тип.СодержитТип(Тип("Дата")) Тогда
				МассивРеквизитовСТипомДата.Добавить(Реквизит.Имя, Реквизит.Синоним);
				ТекстЗапроса = ТекстЗапроса + Символы.ПС + "РАЗНОСТЬДАТ(" + Реквизит.Имя + ", &ТекущаяДата, ДЕНЬ) Как ДнейДоУдаленияОт" + Реквизит.Имя + ",";
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Удаляем лишнюю запятую
	ТекстЗапроса= Лев(ТекстЗапроса, СтрДлина(ТекстЗапроса) - 1);
	ТекстЗапроса = ТекстЗапроса + "
	               |ИЗ
	               |	" + ТипОбъекта.ПолноеИмя+ " КАК " + ТипОбъекта.Имя;
	
	Возврат ТекстЗапроса;
	
КонецФункции

&НаКлиенте
Процедура ДобавитьУсловиеПоДате(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("МассивЗначений", МассивРеквизитовСТипомДата);
	ОткрытьФорму("РегистрСведений.НастройкиОчисткиФайлов.Форма.ФормаДобавленияУсловияПоДате", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьВОтборИнтервалИсключение(ВыбранноеЗначение)
	
	ОтборПоИнтервалу = Правило.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборПоИнтервалу.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДнейДоУдаленияОт" + ВыбранноеЗначение.РеквизитСТипомДата);
	ОтборПоИнтервалу.ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
	ОтборПоИнтервалу.ПравоеЗначение = ВыбранноеЗначение.ИнтервалИсключение;
	ПредставлениеРеквизитаСТипомДата = МассивРеквизитовСТипомДата.НайтиПоЗначению(ВыбранноеЗначение.РеквизитСТипомДата).Представление;
	ТекстПредставления = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Очищать спустя %1 дней относительно даты (%2)'"), 
		ВыбранноеЗначение.ИнтервалИсключение, ПредставлениеРеквизитаСТипомДата);
	ОтборПоИнтервалу.Представление = ТекстПредставления;

КонецПроцедуры

#КонецОбласти