﻿Функция ПолучитьДанныеПодключения(ъКлиент, ъИмя, ъВидПодключения) Экспорт
	
	яЗ = Новый Запрос(
	"ВЫБРАТЬ
	|	ПодключенияККлиенту.ВидПодключения КАК ВидПодключения,
	|	ПодключенияККлиенту.Адрес КАК Адрес,
	|	ПодключенияККлиенту.Логин КАК Логин,
	|	ПодключенияККлиенту.Пароль КАК Пароль,
	|	ПодключенияККлиенту.Название КАК Название
	|ИЗ
	|	РегистрСведений.ПодключенияККлиенту КАК ПодключенияККлиенту
	|ГДЕ
	|	ПодключенияККлиенту.Клиент = &Клиент
	|	И ПодключенияККлиенту.Название = &Название
	|	И ПодключенияККлиенту.ВидПодключения = &ВидПодключения");
	яЗ.УстановитьПараметр("Клиент", ъКлиент);	
	яЗ.УстановитьПараметр("Название", ъИмя);
	яЗ.УстановитьПараметр("ВидПодключения", ъВидПодключения);
	
	яС = Новый Структура("Название,ВидПодключения,Адрес,Логин,Пароль");
	
	яВ = яЗ.Выполнить().Выбрать();
	Если яВ.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(яС, яВ);
	КонецЕсли;
	
	Возврат яС;
	
	
КонецФункции


Функция ВернутьМакет(ъИмя) Экспорт
	
	Возврат ITC_ОбщиеСервер.ПолучитьОбщийМакетНаСервере(ъИмя);
	
КонецФункции



Функция ВернутьПутьИсполняемыйФайл(ъВидПодключения) Экспорт
	
	Возврат ъВидПодключения.ПутьИсполняемыйФайл;
	
КонецФункции