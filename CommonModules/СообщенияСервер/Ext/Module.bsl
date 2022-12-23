﻿Процедура ОтметитьСообщенияПрочтенными(пСсылка, пПользователь = Неопределено) Экспорт
	Если Не ЗначениеЗаполнено(пСсылка) Тогда 
		Возврат;
	КонецЕсли;
	яПользователь = ?(пПользователь = Неопределено, ПараметрыСеанса.ТекущийПользователь, пПользователь);
	
	яМЗ = РегистрыСведений.ПрочтенныеСообщения.СоздатьМенеджерЗаписи();
	яМЗ.Документ		= пСсылка;
	яМЗ.Пользователь	= яПользователь;
	яМЗ.Прочитать();
	яМЗ.Документ		= пСсылка;
	яМЗ.Пользователь	= яПользователь;
	яМЗ.Дата			= ТекущаяДата();
	яМЗ.Записать(Истина);
КонецПроцедуры


Функция ПолучитьКоличествоНепрочтенныхСообщений(пСсылка, пПользователь = Неопределено) Экспорт
	Если Не ЗначениеЗаполнено(пСсылка) Тогда 
		Возврат 0;
	КонецЕсли;
	яПользователь = ?(пПользователь = Неопределено, ПараметрыСеанса.ТекущийПользователь, пПользователь);
	
	яЗапрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПрочтенныеСообщения.Документ,
	|	ПрочтенныеСообщения.Пользователь,
	|	ПрочтенныеСообщения.Дата
	|ПОМЕСТИТЬ втНепрочтенные
	|ИЗ
	|	РегистрСведений.ПрочтенныеСообщения КАК ПрочтенныеСообщения
	|ГДЕ
	|	ПрочтенныеСообщения.Документ = &Документ
	|	И ПрочтенныеСообщения.Пользователь = &Пользователь
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СообщенияДокументы.Документ,
	|	СообщенияДокументы.Автор,
	|	СообщенияДокументы.Дата
	|ПОМЕСТИТЬ втСоощения
	|ИЗ
	|	РегистрСведений.СообщенияДокументы КАК СообщенияДокументы
	|ГДЕ
	|	СообщенияДокументы.Документ = &Документ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО(втСоощения.Дата) КАК КоличествоНепрочтенных
	|ИЗ
	|	втНепрочтенные КАК втНепрочтенные
	|		ЛЕВОЕ СОЕДИНЕНИЕ втСоощения КАК втСоощения
	|		ПО (ЕСТЬNULL(втНепрочтенные.Дата, &ДатаНач) < втСоощения.Дата)");
	яЗапрос.УстановитьПараметр("Документ",		пСсылка);
	яЗапрос.УстановитьПараметр("ДатаНач",		Дата("00010101000000"));
	яЗапрос.УстановитьПараметр("Пользователь",	яПользователь);
	яРезультатЗапроса = яЗапрос.Выполнить();
	яВ = яРезультатЗапроса.Выбрать();
	Если яВ.Следующий() Тогда
		Возврат ?(яВ.КоличествоНепрочтенных = NULL, 0, яВ.КоличествоНепрочтенных); 
	КонецЕсли;
	
	Возврат 0;
КонецФункции