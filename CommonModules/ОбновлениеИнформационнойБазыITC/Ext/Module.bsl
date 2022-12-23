﻿Процедура ПриДобавленииПодсистемы(Описание) Экспорт

	Описание.Имя = "ITCrowd";
	Описание.Версия = Метаданные.Версия; //#DIP-61 КурцовАИ 2022.10.12  Было: "2.0.0.0";
	// Требуется библиотека стандартных подсистем.
	Описание.ТребуемыеПодсистемы.Добавить("СтандартныеПодсистемы"); 
	
КонецПроцедуры

Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.0.0";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыITC.КонтактнаяИнформацияОбновлениеИБ";
	Обработчик.Приоритет = 0;
	Обработчик.ОбщиеДанные = Истина;
	Обработчик.МонопольныйРежим = Истина;	
	
	#Область ОбновлениеНаРелиз_2_0_0_0002
	    
	//#DIP-80 КурцовАИ 2022.11.02 ++
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "2.0.0.0002";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыITC.ДобавитьРоль_ОткрытьВанессуИзБазы_ВПрофиль_Тестировщик";
	Обработчик.Приоритет = 0;
	Обработчик.ОбщиеДанные = Истина;
	Обработчик.МонопольныйРежим = Истина;  
	//#DIP-80 КурцовАИ 2022.11.02 --
	
	#КонецОбласти

	#Область ОбновлениеНаРелиз_2_0_0_0001
	
	//#DIP-61 КурцовАИ 2022.10.12 ++
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "2.0.0.0001";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыITC.ДобавитьРоль_СозданиеПодключенияКлиентаТестированияДляВА_ВПрофиль_Тестировщик";
	Обработчик.Приоритет = 0;
	Обработчик.ОбщиеДанные = Истина;
	Обработчик.МонопольныйРежим = Истина;  
	//#DIP-61 КурцовАИ 2022.10.12 --
	
	#КонецОбласти
	
КонецПроцедуры

Процедура ПередОбновлениемИнформационнойБазы() Экспорт
КонецПроцедуры

Процедура ПослеОбновленияИнформационнойБазы(Знач ПредыдущаяВерсия, Знач ТекущаяВерсия,
        Знач ВыполненныеОбработчики, ВыводитьОписаниеОбновлений, МонопольныйРежим) Экспорт
КонецПроцедуры
	
Процедура ПриПодготовкеМакетаОписанияОбновлений(Знач Макет) Экспорт
КонецПроцедуры

Процедура ПриДобавленииОбработчиковПереходаСДругойПрограммы(Обработчики) Экспорт
КонецПроцедуры

Процедура ПриОпределенииРежимаОбновленияДанных(РежимОбновленияДанных, СтандартнаяОбработка) Экспорт
КонецПроцедуры 

Процедура ПриЗавершенииПереходаСДругойПрограммы(Знач ПредыдущееИмяКонфигурации, Знач ПредыдущаяВерсияКонфигурации, Параметры) Экспорт
КонецПроцедуры

Процедура КонтактнаяИнформацияОбновлениеИБ(Параметры) Экспорт
	
	// Справочник "Контрагенты"
	яСпрКлиенты = Справочники.ВидыКонтактнойИнформации.СправочникКлиенты.ПолучитьОбъект();
	яСпрКлиенты.Используется = Истина;
	яСпрКлиенты.Записать();

	
    ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(Перечисления.ТипыКонтактнойИнформации.Адрес);
    ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.ПочтовыйАдресКлиента;
    ПараметрыВида.Используется = Истина;
    ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
    ПараметрыВида.Порядок = 2;
    ПараметрыВида.НастройкиПроверки.ТолькоНациональныйАдрес = Истина;
    ПараметрыВида.НастройкиПроверки.ПроверятьКорректность = Ложь;
    ПараметрыВида.НастройкиПроверки.ПроверятьПоФИАС = Ложь; // Только для российской версии библиотеки.
    УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	
	// Справочник "Физические лица"
	яСпр = Справочники.ВидыКонтактнойИнформации.СправочникФизическиеЛица.ПолучитьОбъект();
	яСпр.Используется = Истина;
	яСпр.Записать();
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(Перечисления.ТипыКонтактнойИнформации.Телефон);
    ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.ТелефонФизическогоЛица;
    ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
    ПараметрыВида.Порядок = 1;
	ПараметрыВида.РазрешитьВводНесколькихЗначений = Истина;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
    ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.EMailФизическогоЛица;
    ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
    ПараметрыВида.Порядок = 2;
	ПараметрыВида.РазрешитьВводНесколькихЗначений = Истина;
	ПараметрыВида.НастройкиПроверки.ПроверятьКорректность = Истина;
    УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
КонецПроцедуры

#Область ДобавлениеРолейВПрофили  

Процедура ДобавитьРольВПроифль(НоваяРоль_Имя,ПрофильИмя) //#DIP-80 КурцовАИ 2022.11.0

	ПрофильСсылка = Справочники.ПрофилиГруппДоступа.НайтиПоНаименованию(ПрофильИмя); 
	ПрофильОбъект = ПрофильСсылка.ПолучитьОбъект();

	РодительРоли = Справочники.ИдентификаторыОбъектовМетаданных.НайтиПоНаименованию("Роли");
	
	ИдентификаторНовойРоли = Справочники.ИдентификаторыОбъектовМетаданных.НайтиПоРеквизиту("Имя",НоваяРоль_Имя,РодительРоли);
	Если ЗначениеЗаполнено(ИдентификаторНовойРоли) Тогда
		НайденныйИдентификаторНовойРоли = ПрофильОбъект.Роли.Найти(ИдентификаторНовойРоли );
		Если НайденныйИдентификаторНовойРоли = неопределено тогда
			НовСтрока = ПрофильОбъект.Роли.Добавить();
			НовСтрока.Роль = ИдентификаторНовойРоли;  
			ПрофильОбъект.Записать();
		КонецЕсли;
	КонецЕсли;   	

КонецПроцедуры


Процедура ДобавитьРоль_СозданиеПодключенияКлиентаТестированияДляВА_ВПрофиль_Тестировщик() Экспорт  //#DIP-61 КурцовАИ 2022.10.12
	
	НоваяРоль_Имя = "СозданиеПодключенияКлиентаТестированияДляВА";
	ПрофильИмя = "Тестировщик";
	
	ПрофильСсылка = Справочники.ПрофилиГруппДоступа.НайтиПоНаименованию(ПрофильИмя); 
	ПрофильОбъект = ПрофильСсылка.ПолучитьОбъект();

	РодительРоли = Справочники.ИдентификаторыОбъектовМетаданных.НайтиПоНаименованию("Роли");
	
	ИдентификаторНовойРоли = Справочники.ИдентификаторыОбъектовМетаданных.НайтиПоРеквизиту("Имя",НоваяРоль_Имя,РодительРоли);
	Если ЗначениеЗаполнено(ИдентификаторНовойРоли) Тогда
		НайденныйИдентификаторНовойРоли = ПрофильОбъект.Роли.Найти(ИдентификаторНовойРоли );
		Если НайденныйИдентификаторНовойРоли = неопределено тогда
			НовСтрока = ПрофильОбъект.Роли.Добавить();
			НовСтрока.Роль = ИдентификаторНовойРоли;  
			ПрофильОбъект.Записать();
		КонецЕсли;
	КонецЕсли;   	
	
КонецПроцедуры

Процедура ДобавитьРоль_ОткрытьВанессуИзБазы_ВПрофиль_Тестировщик() Экспорт  //#DIP-80 КурцовАИ 2022.11.02
	
	НоваяРоль_Имя = "ОткрытьВанессуИзБазы";
	ПрофильИмя = "Тестировщик";
	ДобавитьРольВПроифль(НоваяРоль_Имя,ПрофильИмя)
	
КонецПроцедуры



 #КонецОбласти
