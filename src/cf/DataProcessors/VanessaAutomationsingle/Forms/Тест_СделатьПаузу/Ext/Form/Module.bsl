﻿//начало текста модуля

///////////////////////////////////////////////////
//Служебные функции и процедуры
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

	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯДелаюПаузуСекунды(Парам01)","ЯДелаюПаузуСекунды","Когда Я делаю паузу 2 секунды");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"Пауза(Парам01)","Пауза","И Пауза 1","Позволяет сделать паузу нужной длительности.","Прочее.Сделать паузу");

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
Функция ОбработчикОжидания()
	ИмяОбработчика = "ОбработчикОжидания";
	
	Если НЕ Ванесса.ИдетВыполнениеСценариев() Тогда
		ОтключитьОбработчикОжидания(ИмяОбработчика);
		Возврат Неопределено;
	КонецЕсли;	 
	
	Если (ТекущаяДата() - ДатаНачалаОбработкиОжидания) >= КоличествоСекундОбработкаОжидания Тогда
		ОтключитьОбработчикОжидания(ИмяОбработчика);
		Ванесса.ПродолжитьВыполнениеШагов();
		Возврат Неопределено;
	КонецЕсли;	 
КонецФункции

&НаКлиенте
Функция ОднократныйОбработчикОжидания()
	Ванесса.ПродолжитьВыполнениеШагов();
КонецФункции

&НаКлиенте
//Когда Я делаю паузу 2 секунды
//@ЯДелаюПаузуСекунды(Парам01)
Функция ЯДелаюПаузуСекунды(КолСекунд) Экспорт
	Пауза(КолСекунд);
КонецФункции

&НаКлиенте
//И Пауза 1
//@Пауза(Парам01)
Функция Пауза(КолСекунд) Экспорт
	Ванесса.ЗапретитьВыполнениеШагов();

	ТипЧисло = Новый ОписаниеТипов("Число");
	Результат = ТипЧисло.ПривестиЗначение(КолСекунд);
	//Если Ванесса.Объект.ИспользоватьКомпонентуVanessaExt Тогда
	//	ОписаниеОповещения = Новый ОписаниеОповещения("ОкончаниеВызоваПауза", ЭтаФорма);
	//	Сообщить("Начало пауза " + ТекущаяДата());
	//	Ванесса.ВнешняяКомпонентаДляСкриншотов.НачатьВызовПауза(ОписаниеОповещения, Результат*1000);
	//	Возврат Неопределено;
	//КонецЕсли;	 

	Если ТипЗнч(Результат) = Тип("Число") И Результат > 0 И Результат < 1 Тогда
		ПодключитьОбработчикОжидания("ОднократныйОбработчикОжидания",Результат,Истина);
		Возврат Неопределено;
	КонецЕсли;	 
	
	КоличествоСекундОбработкаОжидания = КолСекунд;
	ДатаНачалаОбработкиОжидания       = ТекущаяДата();
	
	ПодключитьОбработчикОжидания("ОбработчикОжидания",1,Ложь);
КонецФункции

&НаКлиенте
Функция ОкончаниеВызоваПауза(Результат, ПараметрыВызова, ДополнительныеПараметры) Экспорт
	//Сообщить("Конец пауза " + ТекущаяДата());

	Ванесса.ПродолжитьВыполнениеШагов();
	
КонецФункции

//окончание текста модуля