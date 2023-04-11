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
	
	УстановитьУсловноеОформление();
	
	Отбор = Параметры.Отбор;
	
	Если Отбор.Количество() > 0 Тогда
		Элементы.КомандыПечати.НачальноеОтображениеДерева = НачальноеОтображениеДерева.РаскрыватьВсеУровни;
	КонецЕсли;
	
	ЗаполнитьСписокКомандПечати();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемПодтверждениеПолучено", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(ОписаниеОповещения, Отказ, ЗавершениеРаботы,, ТекстПредупреждения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыКомандыПечати

&НаКлиенте
Процедура КомандыПечатиВидимостьПриИзменении(Элемент)
	ПриИзмененииФлажка(Элементы.КомандыПечати, "Видимость");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда = Неопределено)
	Записать();
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьВСписке(Команда)
	
	Если Модифицированность Тогда
		Оповещение = Новый ОписаниеОповещения("ПоказатьВСпискеЗавершение", ЭтотОбъект, Параметры);
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена, ,
			КодВозвратаДиалога.Отмена);
		Возврат;
	КонецЕсли;
	
	ПерейтиКСписку();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	ЗаполнитьЗначениеРеквизитаКоллекции(КомандыПечати, "Видимость", Истина);
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	ЗаполнитьЗначениеРеквизитаКоллекции(КомандыПечати, "Видимость", Ложь);
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьНастройкиПоУмолчанию(Команда)
	ЗаполнитьСписокКомандПечати();
	Модифицированность = Ложь;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьФлажокВладельцаКоманд(ВладелецКоманд)
	ЕстьВыбранныеЭлементы = Ложь;
	ВыбраныВсеЭлементы = Истина;
	Для Каждого КомандаПечати Из ВладелецКоманд.ПолучитьЭлементы() Цикл
		ЕстьВыбранныеЭлементы = ЕстьВыбранныеЭлементы Или КомандаПечати.Видимость;
		ВыбраныВсеЭлементы = ВыбраныВсеЭлементы И КомандаПечати.Видимость;
	КонецЦикла;
	ВладелецКоманд.Видимость = ЕстьВыбранныеЭлементы + ?(ЕстьВыбранныеЭлементы, (Не ВыбраныВсеЭлементы), ЕстьВыбранныеЭлементы);
КонецПроцедуры

&НаКлиенте
Процедура КомандыПечатиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Поле.Имя = Элементы.КомандыПечатиКомментарий.Имя 
		И Не ПустаяСтрока(Элементы.КомандыПечати.ТекущиеДанные.НавигационнаяСсылка) Тогда
			ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(Элементы.КомандыПечати.ТекущиеДанные.НавигационнаяСсылка);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНастройкиКоманд()
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.НастройкиКомандПечати");
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		
		НаборЗаписей = РегистрыСведений.НастройкиКомандПечати.СоздатьНаборЗаписей();
		Для Каждого НаборКоманд Из КомандыПечати.ПолучитьЭлементы() Цикл
			НаборЗаписей.Отбор.Владелец.Установить(НаборКоманд.Владелец);
			НаборЗаписей.Прочитать();
			НаборЗаписей.Очистить();
			ЗаписываемыеНастройки = НаборЗаписей.Выгрузить();
			Для Каждого Настройка Из НаборКоманд.ПолучитьЭлементы() Цикл
				ЗаполнитьЗначенияСвойств(ЗаписываемыеНастройки.Добавить(), Настройка);
			КонецЦикла;
			ЗаписываемыеНастройки.Свернуть("Владелец,УникальныйИдентификатор", "Видимость");
			НаборЗаписей.Загрузить(ЗаписываемыеНастройки);
			НаборЗаписей.Записать();
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииФлажка(ДеревоФормы, ИмяФлажка)
	
	ТекущиеДанные = ДеревоФормы.ТекущиеДанные;
	
	Если ТекущиеДанные[ИмяФлажка] = 2 Тогда
		ТекущиеДанные[ИмяФлажка] = 0;
	КонецЕсли;
	
	Пометка = ТекущиеДанные[ИмяФлажка];
	
	// Обновление подчиненных флажков.
	Для Каждого ПодчиненныйРеквизит Из ТекущиеДанные.ПолучитьЭлементы() Цикл
		ПодчиненныйРеквизит[ИмяФлажка] = Пометка;
	КонецЦикла;
	
	// Обновление родительского флажка.
	Родитель = ТекущиеДанные.ПолучитьРодителя();
	Если Родитель <> Неопределено Тогда
		ЕстьВыбранныеЭлементы = Ложь;
		ВыбраныВсеЭлементы = Истина;
		Для Каждого Элемент Из Родитель.ПолучитьЭлементы() Цикл
			ЕстьВыбранныеЭлементы = ЕстьВыбранныеЭлементы Или Элемент[ИмяФлажка];
			ВыбраныВсеЭлементы = ВыбраныВсеЭлементы И Элемент[ИмяФлажка];
		КонецЦикла;
		Родитель[ИмяФлажка] = ЕстьВыбранныеЭлементы + ?(ЕстьВыбранныеЭлементы, (Не ВыбраныВсеЭлементы), ЕстьВыбранныеЭлементы);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьЗначениеРеквизитаКоллекции(Коллекция, ИмяРеквизита, Значение)
	Для Каждого Элемент Из Коллекция.ПолучитьЭлементы() Цикл
		Элемент[ИмяРеквизита] = Значение;
		ЗаполнитьЗначениеРеквизитаКоллекции(Элемент, ИмяРеквизита, Значение);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокКомандПечати()
	
	УстановитьПривилегированныйРежим(Истина);
	ИсточникиКомандПечати = УправлениеПечатью.ИсточникиКомандПечати();
	
	КомандыПечати.ПолучитьЭлементы().Очистить();
	Для Каждого ИсточникКомандПечати Из ИсточникиКомандПечати Цикл
		ИдентификаторИсточникаКомандПечати = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ИсточникКомандПечати);
		Если Отбор.Количество() > 0 И Отбор.НайтиПоЗначению(ИдентификаторИсточникаКомандПечати) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		КомандыПечатиОбъекта = УправлениеПечатью.КомандыПечатиОбъекта(ИсточникКомандПечати);
		
		КомандыПечатиОбъекта.Колонки.Добавить("Владелец");
		КомандыПечатиОбъекта.ЗаполнитьЗначения(ИдентификаторИсточникаКомандПечати, "Владелец");
		
		КомандыПечатиОбъекта.Колонки.Добавить("ЭтоВнешняяКомандаПечати");
		Для Каждого КомандаПечати Из КомандыПечатиОбъекта Цикл
			КомандаПечати.ЭтоВнешняяКомандаПечати = КомандаПечати.МенеджерПечати = "СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки";
		КонецЦикла;
		
		Если КомандыПечатиОбъекта.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ОписаниеИсточника = КомандыПечати.ПолучитьЭлементы().Добавить();
		ОписаниеИсточника.Владелец = ИдентификаторИсточникаКомандПечати;
		ОписаниеИсточника.Представление = ИсточникКомандПечати.Представление();
		ОписаниеИсточника.Видимость = 2;
		ОписаниеИсточника.НавигационнаяСсылка = "e1cib/list/" + ИдентификаторИсточникаКомандПечати.ПолноеИмя;
		
		Для Каждого КомандаПечати Из КомандыПечатиОбъекта Цикл
			Если КомандаПечати.Картинка.Вид = ВидКартинки.Пустая Тогда
				КомандаПечати.Картинка = БиблиотекаКартинок.Пустая;
			КонецЕсли;
			ОписаниеКомандыПечати = ОписаниеИсточника.ПолучитьЭлементы().Добавить();
			ЗаполнитьЗначенияСвойств(ОписаниеКомандыПечати, КомандаПечати);
			ОписаниеКомандыПечати.Видимость = Не КомандаПечати.Отключена;
			Если ОписаниеКомандыПечати.МенеджерПечати = "СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки" Тогда
				ОписаниеКомандыПечати.Комментарий = Строка(КомандаПечати.ДополнительныеПараметры.Ссылка);
				ОписаниеКомандыПечати.НавигационнаяСсылка = ПолучитьНавигационнуюСсылку(КомандаПечати.ДополнительныеПараметры.Ссылка);
			КонецЕсли;
		КонецЦикла;
		
		ОбновитьФлажокВладельцаКоманд(ОписаниеИсточника);
	КонецЦикла;
	
	ДеревоКоманд = РеквизитФормыВЗначение("КомандыПечати");
	ДеревоКоманд.Строки.Сортировать("Представление", Истина);
	ЗначениеВРеквизитФормы(ДеревоКоманд, "КомандыПечати");
	
КонецПроцедуры

&НаКлиенте
Процедура Записать()
	ЗаписатьНастройкиКоманд();
	ОбновитьПовторноИспользуемыеЗначения();
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьВСпискеЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = Неопределено Или РезультатВопроса = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Записать();
	КонецЕсли;
	
	ПерейтиКСписку();
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКСписку()
	
	ВладелецКоманд = Элементы.КомандыПечати.ТекущиеДанные;
	Если ВладелецКоманд = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Родитель = ВладелецКоманд.ПолучитьРодителя();
	Если Родитель <> Неопределено Тогда
		ВладелецКоманд = Родитель;
	КонецЕсли;
	
	НавигационнаяСсылка = ВладелецКоманд.НавигационнаяСсылка;

	Для Каждого ОкноКлиентскогоПриложения Из ПолучитьОкна() Цикл
		Если ОкноКлиентскогоПриложения.ПолучитьНавигационнуюСсылку() = НавигационнаяСсылка Тогда
			Форма = ОкноКлиентскогоПриложения.Содержимое[0];
			ОписаниеОповещения = Новый ОписаниеОповещения("ПерейтиКСпискуЗавершение", ЭтотОбъект, 
				Новый Структура("Форма, НавигационнаяСсылка", Форма, НавигационнаяСсылка));
			Кнопки = Новый СписокЗначений;
			Кнопки.Добавить("Переоткрыть", НСтр("ru = 'Переоткрыть'"));
			Кнопки.Добавить("Отмена", НСтр("ru = 'Не переоткрывать'"));
			ТекстВопроса = 
				НСтр("ru = 'Список уже открыт. Переоткрыть список, 
				|чтобы увидеть изменения меню печать?'");
			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки, , "Переоткрыть");
			Возврат;
		КонецЕсли;
	КонецЦикла;
	
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(НавигационнаяСсылка);
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКСпискуЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = "Отмена" Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры.Форма.Закрыть();
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(ДополнительныеПараметры.НавигационнаяСсылка);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемПодтверждениеПолучено(РезультатВопроса, ДополнительныеПараметры) Экспорт
	ЗаписатьИЗакрыть();
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.КомандыПечати.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("КомандыПечати.Видимость");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 0;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
КонецПроцедуры

#КонецОбласти

