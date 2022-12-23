﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ПараметрыВыполненияКоманды.Источник.Модифицированность Тогда
		  ОбщегоНазначенияКлиент.СообщитьПользователю("Открыть Ванессу возможно только после записи данных. Запишите, пожалуйста, и повторите открытие.");
		  Возврат;
	КонецЕсли;
	
	ДопПарметры = Новый Структура;
	ДопПарметры.Вставить("База",ПараметрКоманды);
	
	ВА_ВанессаСервер.ЗаполнитьПараметрыЗапускаТестовПоБазе(ДопПарметры); 
	
	Отказ = Ложь;	
	Если НЕ ЗначениеЗаполнено(ДопПарметры.ПапкаЛокальныхРепозиториевГита) Тогда 
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Выполнение остановлено. Установите, пожалуйста, папку локальных репозиториев гита и повторите операцию.";
		Сообщение.Сообщить();	
		Отказ = Истина;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(ДопПарметры.ВанессаДопПараметры) Тогда 
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Выполнение остановлено. Установите, пожалуйста, заполните, пожалуйста, константу Параметры запуска клиента тестирвоания базовые.";
		Сообщение.Сообщить();
		Отказ = Истина;
	КонецЕсли;	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ВА_ВанессаКлиент.ПроверитьНаличиеКаталогаИлиСоздать(ДопПарметры.ПапкаЛокальныхРепозиториевГита);
	ВА_ВанессаКлиент.ПроверитьНаличиеКаталогаИлиСоздать(ДопПарметры.БазовыйКаталогРезультатовТестов);
	
	ФормаВанессы = ПолучитьФорму("Обработка.VanessaAutomationsingle.Форма.УправляемаяФорма");
	
	СлужебныеПараметры = ФормаВанессы.Объект.СлужебныеПараметры;
	СлужебныеПараметры.Вставить("ЗагрузитьНастройкиВанессыДляБазы_ITC", Истина);
	
	Для Каждого ЭлементСтруктуры Из ДопПарметры Цикл
		СлужебныеПараметры.Вставить(ЭлементСтруктуры.Ключ, ЭлементСтруктуры.Значение);
	КонецЦикла;	
	
	ФормаВанессы.Открыть();
	
	Если СтрНайти(ФормаВанессы.Заголовок,"ver") <> 0 Тогда
		//Форма открыта   
        ВА_ВанессаКлиент.ОбработатьЗапускВанессыиИзСпрБазаОтложено();		
	КонецЕсли;
	
	Возврат;
	
КонецПроцедуры
