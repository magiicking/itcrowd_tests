﻿//начало текста модуля

///////////////////////////////////////////////////
//Служебная часть
///////////////////////////////////////////////////

&НаКлиенте
// контекст фреймворка Vanessa-Behavior
Перем Ванесса;
 
&НаКлиенте
// Структура, в которой хранится состояние сценария между выполнением шагов. Очищается перед выполнением каждого сценария.
Перем Контекст Экспорт;
 
&НаКлиенте
// Структура, в которой можно хранить служебные данные между запусками сценариев. Существует, пока открыта форма Vanessa-Behavior.
Перем КонтекстСохраняемый Экспорт;

// Делает отключение модуля
&НаКлиенте
Функция ОтключениеМодуля() Экспорт

	Ванесса = Неопределено;
	Контекст = Неопределено;
	КонтекстСохраняемый = Неопределено;

КонецФункции

&НаКлиенте
// Функция экспортирует список шагов, которые реализованы в данной внешней обработке.
Функция ПолучитьСписокТестов(КонтекстФреймворкаBDD) Экспорт
	Ванесса = КонтекстФреймворкаBDD;
	
	ВсеТесты = Новый Массив;

	//описание параметров
	//ДобавитьШагВМассивТестов(ВсеТесты,Снипет,ИмяПроцедуры,ПредставлениеТеста,Транзакция,Параметр);

	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ИмеетсяМетаданное(Парам01)","ИмеетсяМетаданное","Дано:  Имеется метаданное ""Справочник.Справочник1""");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"СуществуетМакет(Парам01)","СуществуетМакет","и существует макет ""ТысячаЭлементовСправочника1""");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯЗагружаюМакет(Парам01)","ЯЗагружаюМакет","И я загружаю макет ""ТысячаЭлементовСправочника1""");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ВСпискеЭлементовСправочникаСуществуетНеМенееЭлементов(Парам01,Парам02)","ВСпискеЭлементовСправочникаСуществуетНеМенееЭлементов","Тогда В списке элементов справочника ""Справочник1"" существует не менее 1000 элементов");

	Возврат ВсеТесты;
КонецФункции
	
&НаСервере
// Служебная функция.
Функция ПолучитьМакетСервер(ИмяМакета)
	ОбъектСервер = РеквизитФормыВЗначение("Объект");
	Возврат ОбъектСервер.ПолучитьМакет(ИмяМакета);
КонецФункции
	
&НаКлиенте
// Служебная функция для подключения библиотеки создания fixtures.
Функция ПолучитьМакетОбработки(ИмяМакета) Экспорт
	Возврат ПолучитьМакетСервер(ИмяМакета);
КонецФункции



///////////////////////////////////////////////////
//Работа со сценариями
///////////////////////////////////////////////////

&НаКлиенте
// Функция выполняется перед началом каждого сценария
Функция ПередНачаломСценария() Экспорт
	
КонецФункции

&НаКлиенте
// Функция выполняется перед окончанием каждого сценария
Функция ПередОкончаниемСценария() Экспорт
	
КонецФункции



///////////////////////////////////////////////////
//Реализация шагов
///////////////////////////////////////////////////

&НаКлиенте
//Дано:  Имеется метаданное "Справочник.Справочник1"
//@ИмеетсяМетаданное(Парам01)
Функция ИмеетсяМетаданное(ИмяОбъекта) Экспорт
	Ванесса.ПроверитьНеРавенство(ИмеетсяМетаданноеНаСервере(ИмяОбъекта),Ложь);
КонецФункции

&НаСервере
Функция ИмеетсяМетаданноеНаСервере(ИмяОбъекта)
	 Если ТипЗнч(Метаданные.НайтиПоПолномуИмени(ИмяОбъекта))=Тип("Неопределено") Тогда
		 Возврат Ложь;
	 Иначе
		 Возврат Истина;
	 КонецЕсли;	 
КонецФункции

&НаКлиенте
//и существует макет "ТысячаЭлементовСправочника1"
//@СуществуетМакет(Парам01)
Функция СуществуетМакет(ИмяМакета) Экспорт
	Попытка
		Если Ванесса.Объект.ВерсияПоставки = "standart" Тогда
		Иначе	
			ИмяМакета = "МакетОбработки_Load1000ItemsfromMxl_" + ИмяМакета;
		КонецЕсли;	 
		
		Макет = ПолучитьМакетСервер(ИмяМакета);
	Исключение
		ТекстСообщения = Ванесса.ПолучитьТекстСообщенияПользователю("Не найден макет %1 ошибка: %2");
		ТекстСообщения = СтрЗаменить(ТекстСообщения,"%1",ИмяМакета);
		ТекстСообщения = СтрЗаменить(ТекстСообщения,"%2",ОписаниеОшибки());
		ВызватьИсключение ТекстСообщения;
	КонецПопытки;
КонецФункции

&НаКлиенте
//И я загружаю макет "ТысячаЭлементовСправочника1"
//@ЯЗагружаюМакет(Парам01)
Функция ЯЗагружаюМакет(ИмяМакета) Экспорт
	Ошибка = """";
	Попытка
		Макет 								= Ванесса.ПолучитьМакетОбработки(ИмяМакета);
		СтруктураДанных 					= Ванесса.СоздатьДанныеПоТабличномуДокументу(Макет);
		Ванесса.ПроверитьНеРавенство(СтруктураДанных,Неопределено,"Получили структуру данных.");
	Исключение
		Ошибка = СокрЛП(ОписаниеОшибки());  		
		ТекстСообщения = Ванесса.ПолучитьТекстСообщенияПользователю("Шаг выполнен с ошибкой: %1");
		ТекстСообщения = СтрЗаменить(ТекстСообщения,"%1",Ошибка);
		ВызватьИсключение ТекстСообщения;
	КонецПопытки;  
КонецФункции

&НаКлиенте
//Тогда В списке элементов справочника "Справочник1" существует не менее 1000 элементов
//@ВСпискеЭлементовСправочникаСуществуетНеМенееЭлементов(Парам01,Парам02)
Функция ВСпискеЭлементовСправочникаСуществуетНеМенееЭлементов(ИмяСправочника,Количество) Экспорт
	СуществуетЭлементов = ПолучитьКоличествоЭлементовСправочника(ИмяСправочника);
	Ванесса.ПроверитьРавенство(СуществуетЭлементов>Количество, Истина);
КонецФункции

Функция ПолучитьКоличествоЭлементовСправочника(ИмяСправочника)
	
	СуществуетЭлементов = 0;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(*) КАК Счетчик
	|ИЗ
	|	Справочник."+ИмяСправочника+" КАК ИмяСправочника";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда;
	
		СуществуетЭлементов = ВыборкаДетальныеЗаписи.Счетчик;
		
	КонецЕсли;	
	
	Возврат СуществуетЭлементов;
КонецФункции	
