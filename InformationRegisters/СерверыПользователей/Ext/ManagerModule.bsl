﻿Функция ПолучитьСерверПользователя() Экспорт
	СисИнф = Новый СистемнаяИнформация;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СерверыПользователей.Сервер КАК Сервер
		|ИЗ
		|	РегистрСведений.СерверыПользователей КАК СерверыПользователей
		|ГДЕ
		|	СерверыПользователей.Пользователь = &Пользователь
		|	И СерверыПользователей.ИдентификаторКлиента = &ИдентификаторКлиента";
	
	Запрос.УстановитьПараметр("ИдентификаторКлиента", СисИнф.ИдентификаторКлиента);
	Запрос.УстановитьПараметр("Пользователь", ПараметрыСеанса.ТекущийПользователь);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	Иначе
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	    ВыборкаДетальныеЗаписи.Следующий();
	    Возврат ВыборкаДетальныеЗаписи.Сервер;
	КонецЕсли;
	
КонецФункции  

Процедура УстановитьСерверПользователя(Сервер) Экспорт
	СисИнф = Новый СистемнаяИнформация;
	
	МенЗап = РегистрыСведений.СерверыПользователей.СоздатьМенеджерЗаписи();
	МенЗап.Пользователь = ПараметрыСеанса.ТекущийПользователь;
	МенЗап.ИдентификаторКлиента = СисИнф.ИдентификаторКлиента;
	МенЗап.Сервер = Сервер;
	
	МенЗап.Записать();
КонецПроцедуры