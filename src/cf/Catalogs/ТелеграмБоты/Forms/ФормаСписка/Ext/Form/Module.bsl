﻿&НаКлиенте
Процедура ПанельПолученияОбновлений(Команда)
	
	Элементы.ФормаПанельПолученияОбновлений.Пометка = НЕ Элементы.ФормаПанельПолученияОбновлений.Пометка;
	УстановитьВидимостьДоступность();
	
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьВидимостьДоступность();
	
КонецПроцедуры


&НаКлиенте
Процедура УстановитьВидимостьДоступность()
	
	Элементы.ГруппаПанельПолученияОбновлений.Видимость = Элементы.ФормаПанельПолученияОбновлений.Пометка;
	
КонецПроцедуры


&НаКлиенте
Процедура ПолучениеОбновленийПриИзменении(Элемент)
	
	ПодключитьОтключитьОбработчикОжидания();
	
КонецПроцедуры


&НаКлиенте
Процедура ПериодичностьПриИзменении(Элемент)
	
	ПодключитьОтключитьОбработчикОжидания();
	
КонецПроцедуры


&НаКлиенте
Процедура ПодключитьОтключитьОбработчикОжидания()
	
	Если ПолучениеОбновлений = Истина Тогда
		Если Периодичность > 0 Тогда
			ПодключитьОбработчикОжидания("ПолучениеОбновлений", Периодичность, Ложь);
		Иначе
			ПолучениеОбновлений = Ложь;
			ОтключитьОбработчикОжидания("ПолучениеОбновлений");
			ПоказатьПредупреждение(, "Не задана периодичность получения обновлений");
		КонецЕсли;
	Иначе
		ОтключитьОбработчикОжидания("ПолучениеОбновлений");
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ПолучениеОбновлений()
	
	ПолучениеОбновленийСервер();
	ПоследнееПолучение = ТекущаяДата();
	
КонецПроцедуры


&НаСервереБезКонтекста
Процедура ПолучениеОбновленийСервер()

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТелеграмБоты.Ссылка
	|ИЗ
	|	Справочник.ТелеграмБоты КАК ТелеграмБоты
	|ГДЕ
	|	ТелеграмБоты.Статус = ЗНАЧЕНИЕ(Перечисление.ТелеграмСтатусыИспользования.Используется)
	|	И ТелеграмБоты.СпособПолученияОбновлений = ЗНАЧЕНИЕ(Перечисление.ТелеграмСпособыПолученияОбновлений.ПериодическийЗапрос)";
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Сообщить("Не найден ни один бот со статусом Используется и со способом получения обновлений Периодический запрос");
		Возврат;
	Иначе
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			ТелеграмСервер.ПолучитьОбновленияБота(Выборка.Ссылка);
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры