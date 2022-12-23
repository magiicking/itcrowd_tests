﻿
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Задача") Тогда
		яЗ = Новый Запрос(
		"ВЫБРАТЬ
		|	Задача.Ссылка КАК ДокументОснование,
		|	Задача.Ответственный КАК Ответственный
		|ИЗ
		|	Документ.Задача КАК Задача
		|ГДЕ
		|	Задача.Ссылка = &Ссылка");
		яЗ.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
		яВ = яЗ.Выполнить().Выбрать();
		Если яВ.Следующий() Тогда
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, яВ);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.итк_Задача") Тогда
		  ДокументОснование = ДанныеЗаполнения.Ссылка;
		  Ответственный     = ДанныеЗаполнения.Ответственный;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
	Задача = ITC_УчетВремениСервер.ПолучитьЗадачу(ДокументОснование);
	Если ЗначениеЗаполнено(Задача) тогда
		Клиент = Задача.Клиент;
	Иначе
		Клиент = Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НАЧАЛОПЕРИОДА(НарядРабочееВремя.Дата, ДЕНЬ) КАК День,
	|	СУММА(НарядРабочееВремя.Отчет) КАК Отчет,
	|	СУММА(НарядРабочееВремя.Факт) КАК Факт,
	|	СУММА(НарядРабочееВремя.План) КАК План
	|ИЗ
	|	Документ.РегистрацияВремени.РабочееВремя КАК НарядРабочееВремя
	|ГДЕ
	|	НарядРабочееВремя.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	НАЧАЛОПЕРИОДА(НарядРабочееВремя.Дата, ДЕНЬ)";
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Время = Запрос.Выполнить().Выбрать();
	
	Движения.Время.Записывать = Истина;
	
	Пока Время.Следующий() Цикл
		Движение = Движения.Время.Добавить();
		Движение.Период = Время.День;
		Движение.Ответственный = Ответственный;
		Движение.Задача = Задача;
		Движение.Факт = Время.Факт;
		Движение.План = Время.План;
		
		Если Время.Отчет <> 0 Тогда
			Движения.Трудозатраты.Записывать = Истина;
			
			Движение = Движения.Трудозатраты.ДобавитьПриход();
			Движение.Период = Время.День;
			Движение.Ответственный = Ответственный;
			Движение.Задача = Задача;
			Движение.Отчет = Время.Отчет;
		КонецЕсли;
	КонецЦикла;
					
КонецПроцедуры


