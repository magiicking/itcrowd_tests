﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

// СтандартныеПодсистемы.УправлениеДоступом
Перем ИзмененныеГруппыИсполнителей; // Массив из СправочникСсылка.ГруппыИсполнителейЗадач -
                                    // группы исполнителей, состав которых был изменен.
// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	//Если Количество() > 0 Тогда
	//	НовыеИсполнителиЗадач = Выгрузить();
	//	УстановитьПривилегированныйРежим(Истина);
	//	ГруппыИсполнителейЗадач = БизнесПроцессыИЗадачиСервер.ГруппыИсполнителейЗадач(НовыеИсполнителиЗадач);
	//	УстановитьПривилегированныйРежим(Ложь);
	//	Индекс = 0;
	//	Для каждого Запись Из ЭтотОбъект Цикл
	//		Запись.ГруппаИсполнителейЗадач = ГруппыИсполнителейЗадач[Индекс];
	//		Индекс = Индекс + 1;
	//	КонецЦикла
	//КонецЕсли;
		
	// СтандартныеПодсистемы.УправлениеДоступом
	//ЗаполнитьИзмененныеГруппыИсполнителейЗадач();
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

// СтандартныеПодсистемы.УправлениеДоступом

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	МодульУправлениеДоступомСлужебный = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступомСлужебный");
	МодульУправлениеДоступомСлужебный.ОбновитьПользователейГруппИсполнителей(ИзмененныеГруппыИсполнителей);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьИзмененныеГруппыИсполнителейЗадач()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НовыеЗаписи", Выгрузить());
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НовыеЗаписи.РольИсполнителя,
	|	НовыеЗаписи.Исполнитель,
	|	НовыеЗаписи.ОсновнойОбъектАдресации,
	|	НовыеЗаписи.ДополнительныйОбъектАдресации,
	|	НовыеЗаписи.ГруппаИсполнителейЗадач
	|ПОМЕСТИТЬ НовыеЗаписи
	|ИЗ
	|	&НовыеЗаписи КАК НовыеЗаписи
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Итог.ГруппаИсполнителейЗадач
	|ИЗ
	|	(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		Различия.ГруппаИсполнителейЗадач КАК ГруппаИсполнителейЗадач
	|	ИЗ
	|		(ВЫБРАТЬ
	|			ИсполнителиЗадач.РольИсполнителя КАК РольИсполнителя,
	|			ИсполнителиЗадач.Исполнитель КАК Исполнитель,
	|			ИсполнителиЗадач.ОсновнойОбъектАдресации КАК ОсновнойОбъектАдресации,
	|			ИсполнителиЗадач.ДополнительныйОбъектАдресации КАК ДополнительныйОбъектАдресации,
	|			ИсполнителиЗадач.ГруппаИсполнителейЗадач КАК ГруппаИсполнителейЗадач,
	|			-1 КАК ВидИзмененияСтроки
	|		ИЗ
	|			РегистрСведений.ИсполнителиЗадач КАК ИсполнителиЗадач
	|		ГДЕ
	|			&УсловияОтбора
	|		
	|		ОБЪЕДИНИТЬ ВСЕ
	|		
	|		ВЫБРАТЬ
	|			НовыеЗаписи.РольИсполнителя,
	|			НовыеЗаписи.Исполнитель,
	|			НовыеЗаписи.ОсновнойОбъектАдресации,
	|			НовыеЗаписи.ДополнительныйОбъектАдресации,
	|			НовыеЗаписи.ГруппаИсполнителейЗадач,
	|			1
	|		ИЗ
	|			НовыеЗаписи КАК НовыеЗаписи) КАК Различия
	|	
	|	СГРУППИРОВАТЬ ПО
	|		Различия.РольИсполнителя,
	|		Различия.Исполнитель,
	|		Различия.ОсновнойОбъектАдресации,
	|		Различия.ДополнительныйОбъектАдресации,
	|		Различия.ГруппаИсполнителейЗадач
	|	
	|	ИМЕЮЩИЕ
	|		СУММА(Различия.ВидИзмененияСтроки) <> 0) КАК Итог
	|ГДЕ
	|	Итог.ГруппаИсполнителейЗадач <> ЗНАЧЕНИЕ(Справочник.ГруппыИсполнителейЗадач.ПустаяСсылка)";
	
	УсловияОтбора = "Истина";
	Для каждого ЭлементОтбора Из Отбор Цикл
		Если ЭлементОтбора.Использование Тогда
			УсловияОтбора = УсловияОтбора + "
			|И ИсполнителиЗадач." + ЭлементОтбора.Имя + " = &" + ЭлементОтбора.Имя;
			Запрос.УстановитьПараметр(ЭлементОтбора.Имя, ЭлементОтбора.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловияОтбора", УсловияОтбора);
	ИзмененныеГруппыИсполнителей = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ГруппаИсполнителейЗадач");
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли