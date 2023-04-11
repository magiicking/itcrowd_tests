﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "Работа с файлами".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Проверяет установлена ли компонента сканирования и есть ли хоть один сканер.
Функция ДоступнаКомандаСканировать() Экспорт
	
	Возврат РаботаСФайламиСлужебныйКлиент.ДоступнаКомандаСканировать();
	
КонецФункции

// Возвращает параметр сеанса ПутьКРабочемуКаталогуПользователя.
Функция РабочийКаталогПользователя() Экспорт
	
	ИмяПараметра = "СтандартныеПодсистемы.ПроверкаДоступаКРабочемуКаталогуВыполнена";
	Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
		ПараметрыПриложения.Вставить(ИмяПараметра, Ложь);
	КонецЕсли;
	
	ИмяКаталога =
		СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().ПерсональныеНастройкиРаботыСФайлами.ПутьКЛокальномуКэшуФайлов;
	
	// Уже установлен.
	Если ИмяКаталога <> Неопределено
		И НЕ ПустаяСтрока(ИмяКаталога)
		И ПараметрыПриложения["СтандартныеПодсистемы.ПроверкаДоступаКРабочемуКаталогуВыполнена"] Тогда
		
		Возврат ИмяКаталога;
	КонецЕсли;
	
	Если ИмяКаталога = Неопределено Тогда
		ИмяКаталога = РаботаСФайламиСлужебныйКлиент.ВыбратьПутьККаталогуДанныхПользователя();
		Если НЕ ПустаяСтрока(ИмяКаталога) Тогда
			РаботаСФайламиСлужебныйКлиент.УстановитьРабочийКаталогПользователя(ИмяКаталога);
		Иначе
			ПараметрыПриложения["СтандартныеПодсистемы.ПроверкаДоступаКРабочемуКаталогуВыполнена"] = Истина;
			Возврат ""; // Веб клиент без расширения работы с файлами.
		КонецЕсли;
	КонецЕсли;
	
#Если НЕ ВебКлиент Тогда
	
	// Создать каталог для файлов.
	Попытка
		СоздатьКаталог(ИмяКаталога);
		ИмяКаталогаТестовое = ИмяКаталога + "ПроверкаДоступа\";
		СоздатьКаталог(ИмяКаталогаТестовое);
		УдалитьФайлы(ИмяКаталогаТестовое);
	Исключение
		// Нет прав на создание каталога, или такой путь отсутствует,
		// тогда установка настроек по умолчанию.
		ИмяКаталога = РаботаСФайламиСлужебныйКлиент.ВыбратьПутьККаталогуДанныхПользователя();
		РаботаСФайламиСлужебныйКлиент.УстановитьРабочийКаталогПользователя(ИмяКаталога);
	КонецПопытки;
	
#КонецЕсли
	
	ПараметрыПриложения["СтандартныеПодсистемы.ПроверкаДоступаКРабочемуКаталогуВыполнена"] = Истина;
	
	Возврат ИмяКаталога;
	
КонецФункции

Функция ЭтоСправочникФайлы(ВладелецФайлов) Экспорт
	
	Возврат РаботаСФайламиСлужебныйВызовСервера.ЭтоСправочникФайлы(ВладелецФайлов);
	
КонецФункции

#КонецОбласти
