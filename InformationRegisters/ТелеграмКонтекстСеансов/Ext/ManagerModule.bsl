﻿Процедура ОчиститьКонтекстСеанса(Бот, ИдентификаторЧата) Экспорт
	
	НаборЗаписей = РегистрыСведений.ТелеграмКонтекстСеансов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Бот.Установить(Бот);
	НаборЗаписей.Отбор.ИдентификаторЧата.Установить(ИдентификаторЧата);
	НаборЗаписей.Записать();
	
КонецПроцедуры


Процедура ИзменитьПараметрКонтекстаСеанса(Бот, ИдентификаторЧата, Параметр, Действие, Значение) Экспорт
	
	НаборЗаписей = РегистрыСведений.ТелеграмКонтекстСеансов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Бот.Установить(Бот);
	НаборЗаписей.Отбор.ИдентификаторЧата.Установить(ИдентификаторЧата);
	НаборЗаписей.Отбор.Параметр.Установить(Параметр);
	Если Действие = Перечисления.ТелеграмДействияСКонтекстом.Установить Тогда
		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.Бот = Бот;
		НоваяЗапись.ИдентификаторЧата = ИдентификаторЧата;
		НоваяЗапись.Параметр = Параметр;
		НоваяЗапись.Значение = Значение;
	ИначеЕсли Действие = Перечисления.ТелеграмДействияСКонтекстом.ОчиститьЗначение Тогда
		НаборЗаписей.Очистить();
	КонецЕсли;
	НаборЗаписей.Записать();
	
КонецПроцедуры


Функция ПолучитьКонтекстСеанса(Бот, ИдентификаторЧата) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Бот", Бот);
	Запрос.УстановитьПараметр("ИдентификаторЧата", ИдентификаторЧата);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТелеграмКонтекстСеансов.Параметр КАК Параметр,
	|	ТелеграмКонтекстСеансов.Значение КАК Значение
	|ИЗ
	|	РегистрСведений.ТелеграмКонтекстСеансов КАК ТелеграмКонтекстСеансов
	|ГДЕ
	|	ТелеграмКонтекстСеансов.Бот = &Бот
	|	И ТелеграмКонтекстСеансов.ИдентификаторЧата = &ИдентификаторЧата";
	ТаблицаКонтекста = Запрос.Выполнить().Выгрузить();
	Возврат ТелеграмСервер.ПреобразоватьТаблицуКонтекстаВСоответствие(ТаблицаКонтекста);
	
КонецФункции


Функция ПолучитьЗначение(Бот, ИдентификаторЧата, ИмяПараметра) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Бот", Бот);
	Запрос.УстановитьПараметр("ИдентификаторЧата", ИдентификаторЧата);
	Запрос.УстановитьПараметр("ИмяПараметра", ИмяПараметра);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТелеграмКонтекстСеансов.Значение КАК Значение
	|ИЗ
	|	РегистрСведений.ТелеграмКонтекстСеансов КАК ТелеграмКонтекстСеансов
	|ГДЕ
	|	ТелеграмКонтекстСеансов.Бот = &Бот
	|	И ТелеграмКонтекстСеансов.ИдентификаторЧата = &ИдентификаторЧата
	|	И ТелеграмКонтекстСеансов.Параметр.Наименование = &ИмяПараметра";
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Неопределено;
	Иначе
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.Значение;
	КонецЕсли;
	
КонецФункции


Функция УстановитьЗначение(Бот, ИдентификаторЧата, ИмяПараметра, Значение) Экспорт
	
	Параметр = ПланыВидовХарактеристик.ТелеграмПараметрыКонтекста.НайтиПоНаименованию(ИмяПараметра, Истина);
	Если Параметр = ПланыВидовХарактеристик.ТелеграмПараметрыКонтекста.ПустаяСсылка() Тогда
		ТекстИсключения = СтрШаблон("При установке контекста сеанса не удалось найти параметр контекста %1", ИмяПараметра);
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	МенеджерЗаписи = РегистрыСведений.ТелеграмКонтекстСеансов.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Бот = Бот;
	МенеджерЗаписи.ИдентификаторЧата = ИдентификаторЧата;
	МенеджерЗаписи.Параметр = Параметр;
	МенеджерЗаписи.Значение = Значение;
	МенеджерЗаписи.Записать();
	
КонецФункции
