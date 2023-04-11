﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Параметры = ПолучитьПараметры();
	
	ПроверитьНаличиеКаталога = Ложь;
	
	Если ЗначениеЗаполнено(Параметры.ТекущаяПапкаЛокРеп) Тогда
		Каталог = Параметры.ТекущаяПапкаЛокРеп;	
	ИначеЕсли ИмяКомпьютера() = Параметры.СерверРазработки  и ЗначениеЗаполнено(Параметры.ПолноеИмяПользователя) Тогда 
		Каталог = "E:\" + Параметры.ПолноеИмяПользователя +"\!git_ветки";      
		ПроверитьНаличиеКаталога = Истина;
	Иначе
		Каталог = "";	
	КонецЕсли;

	ДопПарметры = Новый Структура;
	ДопПарметры.Вставить("Каталог",Каталог);
	
	Если ПроверитьНаличиеКаталога Тогда
		КаталогНаДиске = Новый Файл(Каталог);
		Если НЕ КаталогНаДиске.Существует() Тогда
			Оповещение = Новый ОписаниеОповещения("СоздатьКаталогНаЕ", ЭтотОбъект,ДопПарметры);
			ПоказатьВопрос(Оповещение, "Вы работаете на сервере разработки. Рекоментудется использовать каталог " + Каталог +". Создать этот каталог и использовать для сохранения локальных репозиториев с гита и результатов автотестов?", РежимДиалогаВопрос.ДаНет,10,,,КодВозвратаДиалога.Да);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	СоздатьКаталогНаЕ(КодВозвратаДиалога.Нет, ДопПарметры);
	
КонецПроцедуры 


&НаКлиенте
Процедура СоздатьКаталогНаЕ(Результат, ДопПарметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда 
		Режим = РежимДиалогаВыбораФайла.ВыборКаталога; 
		ДиалогОткрытия = Новый ДиалогВыбораФайла(Режим); 
		ДиалогОткрытия.Каталог = ДопПарметры.Каталог; 
		ДиалогОткрытия.МножественныйВыбор = Ложь; 
		ДиалогОткрытия.Заголовок = "Выберите каталог для сохранения локальных репозиториев с гита и результатов автотестов"; 
		
		Если ДиалогОткрытия.Выбрать() Тогда 
			Каталог = ДиалогОткрытия.Каталог;   
		КонецЕсли; 
		Если Каталог = ДопПарметры.Каталог Тогда
			Возврат;
		КонецЕсли;
	Иначе
		Каталог = ДопПарметры.Каталог;   
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Каталог) Тогда
		ВА_ВанессаКлиент.ПроверитьНаличиеКаталогаИлиСоздать(Каталог); 
		УстановитьПапкуТекущегоПользователя(Каталог);	
	КонецЕсли;

КонецПроцедуры // СоздатьКаталогНаЕ()


&НаСервере
Функция ПолучитьПараметры()

	ТекущаяПапкаЛокРеп = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПараметрыСеанса.ТекущийПользователь,"ПапкаЛокальныхРепозиториевГита");
		
	Параметры = Новый Структура;
	Параметры.Вставить("ТекущаяПапкаЛокРеп",ТекущаяПапкаЛокРеп);
	Параметры.Вставить("СерверРазработки",Константы.СерверРазработки.Получить());
	Параметры.Вставить("ПолноеИмяПользователя",ПолучитьИмяПользователяОС(ПолноеИмяПользователя()));           

	Возврат Параметры;    
	
КонецФункции // ПолучитьПараметры()


&НаСервере
Функция ПолучитьИмяПользователяОС(ИмяПользователя) Экспорт

	//#DIP-95 КурцовАИ 2022.10.18 ++ 
	//ПрочитанныеСвойства = Пользователи.СвойстваПользователяИБ(ПолноеИмяПользователя()); // не всегда находит по имени
	//ПолноеИмяПользователяОС = ПрочитанныеСвойства.ПользовательОС;
	ТекПользователь = ПользователиИнформационнойБазы.ТекущийПользователь();
	ПолноеИмяПользователяОС = ТекПользователь.ПользовательОС;	
	//#DIP-95 КурцовАИ 2022.10.18 --
	Если ЗначениеЗаполнено(ПолноеИмяПользователяОС) Тогда
		ПозицияНачалаИмени = СтрНайти(ПолноеИмяПользователяОС ,"\",НаправлениеПоиска.СКонца);
		Если ПозицияНачалаИмени = 0 Тогда
			ПользовательОС = ПолноеИмяПользователяОС;
		Иначе
			ПользовательОС = Прав(ПолноеИмяПользователяОС, СтрДлина(ПолноеИмяПользователяОС) - ПозицияНачалаИмени);		
		КонецЕсли;
	Иначе
		ПользовательОС = "";		
	КонецЕсли;
		
	Возврат ПользовательОС;    
	
КонецФункции // ПолучитьИмяПользователяОС()


&НаСервере
Процедура УстановитьПапкуТекущегоПользователя(ПапкаЛокальныхРепозиториевГита)
	
	ПользовательОбъект = ПараметрыСеанса.ТекущийПользователь.ПолучитьОбъект();
	ПользовательОбъект.ПапкаЛокальныхРепозиториевГита = ПапкаЛокальныхРепозиториевГита;
	ПользовательОбъект.Записать();
	
КонецПроцедуры // УстановитьПапкуПользователя()
 