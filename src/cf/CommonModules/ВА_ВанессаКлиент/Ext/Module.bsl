﻿  
//Возвращает  
//Истина - ошибка при выполнении подготовительных действий
//Ложь - ошибок нет, тест выполняется дальше
Процедура ДействияПередЗапускомТестов(ВанессаФорма, МассивСценариев, ИмяФайлаДляСохраненияНастроек, Отказ) Экспорт
	
	Отказ = Ложь; 
	
	ДанныеКлиентаТестирования = Новый Структура;
	ТекущийПрофильTestClient = ВанессаФорма.ОбъектКонтекстСохраняемый.ТекущийПрофильTestClient;
		
	Для Каждого ПрофильКлиентаТестирования Из ВанессаФорма.ДанныеКлиентовТестирования Цикл
		Если ПрофильКлиентаТестирования.Имя = ТекущийПрофильTestClient Тогда
			ДанныеКлиентаТестирования.Вставить("ПрофильКлиентаТестирования",ТекущийПрофильTestClient); 
			ДанныеКлиентаТестирования.Вставить("ПутьКИнфобазе",ПрофильКлиентаТестирования.ПутьКИнфобазе); 
			ДанныеКлиентаТестирования.Вставить("ДопПараметры",ПрофильКлиентаТестирования.ДопПараметры); 
			Прервать;
		КонецЕсли; 
	КонецЦикла;
	
	ДанныеСпрЗапускТеста = ВА_ВанессаСервер.ПолучитьДанныеСпрЗапускТеста(МассивСценариев, ДанныеКлиентаТестирования);
	
	Если ДанныеСпрЗапускТеста.Свойство("Отказ") И ДанныеСпрЗапускТеста.Отказ Тогда
		Отказ = Истина; 
		Сообщить("Ошибка запуска теста");
		Возврат;	
	КонецЕсли; 
	
	ПутьКаталогаТеста = ДанныеСпрЗапускТеста.ПутьКаталогаТеста;
	ВанессаФорма.Объект.ЗапускТеста = ДанныеСпрЗапускТеста.ЗапускТестаСсылка;
	ПроверитьНаличиеКаталогаИлиСоздать(ДанныеСпрЗапускТеста.БазовыйКаталогРезультатовТестов);
	СоздатьКаталогиРезультатовТестов(ВанессаФорма.Объект, ПутьКаталогаТеста);
	ИмяФайлаДляСохраненияНастроек = ПутьКаталогаТеста + "\VAParams_" + Формат(ДанныеСпрЗапускТеста.ВремяЗапуска,"ДФ=yyyy.MM.dd") + ".json"; 
	
КонецПроцедуры   

Процедура ПроверитьНаличиеКаталогаИлиСоздать(ПутьКаталога) Экспорт

	Каталог = Новый Файл(ПутьКаталога);
	Если Каталог.Существует() = Ложь Тогда 
		СоздатьКаталог(ПутьКаталога);
	КонецЕсли;       
	
КонецПроцедуры

Процедура СоздатьКаталогиРезультатовТестов(ВанессаНаКлиенте, ПутьКаталогаТеста)

	//БазовыйКаталогРезультатовТестов = ВанессаСервер.ПолучитьЗначениеКонстанты("БазовыйКаталогРезультатовТестов");
	
	//Если БазовыйКаталогРезультатовТестов = "" Тогда
	//	Сообщить("Выполнение теста отменено. Необходимо заполнить константу БазовыйКаталогРезультатовТестов, чтобы результаты тестов помещались в подкаталог");
	//	Отказ = Истина;
	//	Возврат;
	//КонецЕсли;
	
	//БазовыйКаталог = Новый Файл(БазовыйКаталогРезультатовТестов);
	//Если БазовыйКаталог.Существует() = Ложь Тогда 
	//	СоздатьКаталог(БазовыйКаталогРезультатовТестов);
	//	БазовыйКаталог = Новый Файл(БазовыйКаталогРезультатовТестов);
	//КонецЕсли;	
	//
	//Если БазовыйКаталог.Существует() Тогда 	
		//КаталогаТеста = Новый Файл(ПутьКаталогаТеста);
		//Если КаталогаТеста.Существует() Тогда 
		//	//Когда станет актуально надо будет вернуться к этому вопросу чтобы определить в каких случаях возникает
		//	//и какой содержательный постфикс надо добавить 
		//	Сообщить("Выполнение теста отменено. Имя подкаталога резльутата тестов не уникально. Попробуйте еще раз"); 
		//	Отказ = Истина;
		//	Возврат;
		//Иначе
			
			СоздатьКаталог(ПутьКаталогаТеста); 
			ВанессаНаКлиенте.КаталогВыгрузкиСкриншотов = ПутьКаталогаТеста;
			ВанессаНаКлиенте.ДелатьСкриншотПриВозникновенииОшибки = Истина;
			
			ПутьКаталогаТеста_Json = ПутьКаталогаТеста + "\" + "Json";
			СоздатьКаталог(ПутьКаталогаТеста_Json);
			ВанессаНаКлиенте.КаталогВыгрузкиCucumberJson = ПутьКаталогаТеста_Json;
			ВанессаНаКлиенте.ДелатьОтчетВФорматеCucumberJson = Истина;
			
			ПутьКаталогаТеста_СППР = ПутьКаталогаТеста + "\" + "СППР";
			СоздатьКаталог(ПутьКаталогаТеста_СППР);
			ВанессаНаКлиенте.КаталогВыгрузкиСППР = ПутьКаталогаТеста_СППР;
			ВанессаНаКлиенте.ДелатьОтчетВФорматеСППР = Истина;		
			
			ВанессаНаКлиенте.ДелатьОтчетВоВнутреннемФормате = Истина;
			
		//КонецЕсли;	
	//Иначе
	//	Сообщить("Выполнение теста отменено. Ошибка определения каталога из константы БазовыйКаталогРезультатовТестов."); 
	//	Отказ = Истина;
	//	Возврат;
	//КонецЕсли;		
	
КонецПроцедуры	

Процедура ЗафиксироватьПодключенияКлиентовТестирования_НаКлиенте(ЗапускТеста,ДанныеЗапускаКлиентаТестирования) Экспорт

	Данные = Новый Структура;
	Данные.Вставить("Имя",ДанныеЗапускаКлиентаТестирования.Имя); 
	Данные.Вставить("ИмяКомпьютера",ДанныеЗапускаКлиентаТестирования.ИмяКомпьютера); 
	Данные.Вставить("ПутьКИнфобазе",ДанныеЗапускаКлиентаТестирования.ПутьКИнфобазе); 
	Данные.Вставить("ДопПараметры",ДанныеЗапускаКлиентаТестирования.ДопПараметры); 
	Данные.Вставить("ТипКлиента",ДанныеЗапускаКлиентаТестирования.ТипКлиента); 
	Данные.Вставить("ПортЗапускаТестКлиента",ДанныеЗапускаКлиентаТестирования.ПортЗапускаТестКлиента); 
	Данные.Вставить("ЭтотКлиент",ДанныеЗапускаКлиентаТестирования.ЭтотКлиент); 
	
	ВА_ВанессаСервер.ЗафиксироватьПодключенияКлиентовТестирования(ЗапускТеста,Данные);	

КонецПроцедуры

#Область ЗапускВанессыИзСпрБаза

Процедура ОбработатьЗапускВанессыиИзСпрБазаОтложено(Таймаут = 5)Экспорт
	
	ПодключитьОбработчикОжидания("ОбработатьЗапускВанессыиИзСпрБаза_Глобальный", Таймаут, Истина); 	

КонецПроцедуры

Процедура ОбработатьЗапускВанессыиИзСпрБаза() Экспорт // #DIP-92
		
	ВанессаУправляемаяФорма = ПолучитьФорму("Обработка.VanessaAutomationsingle.Форма.УправляемаяФорма");

	
	СлужебныеПараметры = ВанессаУправляемаяФорма.Объект.СлужебныеПараметры;
    Отказ = Ложь;
	
	Если СлужебныеПараметры.Свойство("ЗагрузитьНастройкиВанессыДляБазы_ITC")
	   И ВанессаУправляемаяФорма.ФормаVanessaAutomationОткрылась  // можно
		И СлужебныеПараметры.ЗагрузитьНастройкиВанессыДляБазы_ITC Тогда
		ПоказатьОповещениеПользователя ("Загрузка настроек Ванессы");
		ЗагрузитьНастройкиВанессыДляБазы(ВанессаУправляемаяФорма, СлужебныеПараметры, Отказ);
		ВанессаУправляемаяФорма.Объект.СлужебныеПараметры.Вставить("ЗагрузитьНастройкиВанессыДляБазы_ITC", Ложь); 
		Отказ = Истина;
	КонецЕсли;		
	
	Если СлужебныеПараметры.Свойство("ЗагрузитьФичиДляБазы_ITC")
	   И ВанессаУправляемаяФорма.ФормаVanessaAutomationОткрылась  // можно
	   И СлужебныеПараметры.ЗагрузитьФичиДляБазы_ITC
	   И Отказ = Ложь Тогда
		ПоказатьОповещениеПользователя ("Загрузка тестов Ванессы");
		ЗагрузитьВсеФичиДляБазы(ВанессаУправляемаяФорма, СлужебныеПараметры, Отказ);
		ВанессаУправляемаяФорма.Объект.СлужебныеПараметры.Вставить("ЗагрузитьФичиДляБазы_ITC", Ложь);
		Отказ = Истина;
	КонецЕсли;	 
	
	Если СлужебныеПараметры.Свойство("ПодключитьКлиентаТестирования_ITC")
	   И СлужебныеПараметры.ПодключитьКлиентаТестирования_ITC
	   И ВанессаУправляемаяФорма.ФлагСценарииЗагружены  // можно
	   И Отказ = Ложь Тогда
		ПоказатьОповещениеПользователя ("Подключение клиента тестирования");
		ПодключитьКлиентаТестирования(ВанессаУправляемаяФорма, СлужебныеПараметры, Отказ);
		ВанессаУправляемаяФорма.Объект.СлужебныеПараметры.Вставить("ПодключитьКлиентаТестирования_ITC", Ложь); 
		Отказ = Истина;
	КонецЕсли;		
	
	Если СлужебныеПараметры.Свойство("ЗапуститьВыполнениеФичАвтоматичести_ITC")
		И СлужебныеПараметры.ЗапуститьВыполнениеФичАвтоматичести_ITC
		И ВанессаУправляемаяФорма.ФлагСценарииЗагружены
		//И ВанессаУправляемаяФорма.КоличествоЗапущенныхКлиентовТестирования <> 0  // не видит переменные
		//И (НЕ ВанессаУправляемаяФорма.ВозниклаОшибкаПодключенияTestClient)   // не видит переменные  
		И ВанессаУправляемаяФорма.ОбъектКонтекстСохраняемый.Свойство("ПодключенныеTestClient") // можно  
		И ВанессаУправляемаяФорма.ОбъектКонтекстСохраняемый.ПодключенныеTestClient.Количество()> 0 // можно  
		И Отказ = Ложь Тогда
		ПоказатьОповещениеПользователя ("Запуск тестирования");
		ВанессаУправляемаяФорма.Объект.СлужебныеПараметры.Вставить("ЗапуститьВыполнениеФичАвтоматичести_ITC", Ложь); 
		ВанессаУправляемаяФорма.КомандаВыполнитьСценарии();
		Отказ = Истина;
	КонецЕсли;		
	
	Если (СлужебныеПараметры.Свойство("ЗагрузитьНастройкиВанессыДляБазы_ITC") И СлужебныеПараметры.ЗагрузитьНастройкиВанессыДляБазы_ITC) 
		ИЛИ (СлужебныеПараметры.Свойство("ЗагрузитьФичиДляБазы_ITC") И СлужебныеПараметры.ЗагрузитьФичиДляБазы_ITC)
		ИЛИ (СлужебныеПараметры.Свойство("ПодключитьКлиентаТестирования_ITC") И СлужебныеПараметры.ПодключитьКлиентаТестирования_ITC)
		ИЛИ (СлужебныеПараметры.Свойство("ЗапуститьВыполнениеФичАвтоматичести_ITC") И СлужебныеПараметры.ЗапуститьВыполнениеФичАвтоматичести_ITC) Тогда
		
		ОбработатьЗапускВанессыиИзСпрБазаОтложено();
		
	КонецЕсли; 
	
КонецПроцедуры

Процедура ЗагрузитьНастройкиВанессыДляБазы(ВанессаУправляемаяФорма, СлужебныеПараметры, Отказ) // #DIP-92
	
	
	Если СлужебныеПараметры.Свойство("ФайлНастроек") Тогда
		Если СлужебныеПараметры.ФайлНастроек = "" Тогда 
			Отказ = Истина;
		КонецЕсли;
	Иначе
		Отказ = Истина;
	КонецЕсли;
	
	Если Отказ Тогда
		Сообщить("Не найден файл настроек или не указан путь к файлу. Проперьте заполнение справочника База и наличие файла."); 
	Иначе
		ДопПараметрыЗагрузки = Новый Структура;
		ВернутьНастройки = Новый Структура;
		ВернутьНастройки.Вставить("КаталогФич", ВанессаУправляемаяФорма.Объект.КаталогФич);
		ДопПараметрыЗагрузки.Вставить("ВернутьНастройки", ВернутьНастройки);
		ВыбранныеФайлы = Новый Массив;
		ВыбранныеФайлы.Добавить(СлужебныеПараметры.ФайлНастроек);  
		ВанессаУправляемаяФорма.ДанныеКлиентовТестирования.Очистить();		
		ВанессаУправляемаяФорма.ЗагрузитьНастройкиИзФайлаЗавершение(ВыбранныеФайлы, ДопПараметрыЗагрузки);
	КонецЕсли;
	
КонецПроцедуры   

Процедура ЗагрузитьВсеФичиДляБазы(ВанессаУправляемаяФорма, СлужебныеПараметры, Отказ) // #DIP-92
	
	Если ВанессаУправляемаяФорма.Объект.КаталогФич = "" Тогда
		Если СлужебныеПараметры.КаталогФич = "" Тогда 		
			Отказ = Истина;
			Сообщить("Необходимо указать каталог фич по умолчанию в справочника База");
		Иначе
			ВанессаУправляемаяФорма.Объект.КаталогФич = СлужебныеПараметры.КаталогФич;
			ВанессаУправляемаяФорма.ЗагрузитьФичи();
		КонецЕсли;
	Иначе 
		ВанессаУправляемаяФорма.ЗагрузитьФичи();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПодключитьКлиентаТестирования(ВанессаУправляемаяФорма, СлужебныеПараметры, Отказ) // #DIP-92
		
	Если СлужебныеПараметры.Свойство("ИмяКлиентаТестирования") Тогда
		Если СлужебныеПараметры.ИмяКлиентаТестирования = "" Тогда 
			Отказ = Истина;
		КонецЕсли;
	Иначе
		Отказ = Истина;
	КонецЕсли;
	
	Если Отказ Тогда
		Сообщить("Необходимо указать имя клиента тестирования по умолчанию");
	Иначе
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("Имя", СлужебныеПараметры.ИмяКлиентаТестирования);
		НайденныеСтроки = ВанессаУправляемаяФорма.ДанныеКлиентовТестирования.НайтиСтроки(ПараметрыОтбора);
		Если НайденныеСтроки.Количество() = 0 Тогда
			Сообщить("Не найден профиль клиента тестирования.");
			Отказ = Истина;
		Иначе
			ВанессаУправляемаяФорма.ПодключитьПрофильTestClientПоИмени(СлужебныеПараметры.ИмяКлиентаТестирования); 
		КонецЕсли;	 
	КонецЕсли;		
		
КонецПроцедуры

#КонецОбласти

 