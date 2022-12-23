﻿Функция ПолучитьИмяФайла(ъСсылка, ъУбиратьЛидирующиеНули = Истина) Экспорт
	яО = ITC.Ответ_СформироватьСтруктуру("Данные");
	
	яТекст = "ЛТ";
	яЗ = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Док.Номер КАК Номер,
	|	Док.Дата КАК Дата
	|ИЗ
	|	Документ.ЛистТребований КАК Док
	|ГДЕ
	|	Док.Ссылка = &Ссылка");
	яЗ.УстановитьПараметр("Ссылка", ъСсылка);
	яТип = ТипЗнч(ъСсылка);
	Если яТип = Тип("ДокументСсылка.Задача") Тогда
		яЗ.Текст = СтрЗаменить(яЗ.Текст, "ЛистТребований", "Задача");
		яТекст = "ЛУРВ";
	ИначеЕсли яТип = Тип("ДокументСсылка.ОплатаЧасов") Тогда
		яЗ.Текст = СтрЗаменить(яЗ.Текст, "ЛистТребований", "ОплатаЧасов");
		яЗ.Текст = СтрЗаменить(яЗ.Текст, ".Дата", ".ДатаДокумента");
		яТекст = "Акт "; //здесь специально пробел
	ИначеЕсли яТип = Тип("ДокументСсылка.Наряд") Тогда
		яЗ.Текст = СтрЗаменить(яЗ.Текст, "ЛистТребований", "Наряд");
		яТекст = "ЛУРВ";
	//++Волкова для отправки из справочника задачи
	ИначеЕсли яТип = Тип("СправочникСсылка.итк_Задача") Тогда
		яЗ.Текст = СтрЗаменить(яЗ.Текст, "Документ.ЛистТребований", "Справочник.итк_Задача");
		яЗ.Текст = СтрЗаменить(яЗ.Текст, "Док.Номер", "Док.НомерЗадачи");	
		яЗ.Текст = СтрЗаменить(яЗ.Текст, "Док.Дата", "Док.НачатьНеРанее");			
		яТекст = "ЛУРВ";
    //--
	КонецЕсли;
	яВ = яЗ.Выполнить().Выбрать();
	Если яВ.Следующий() Тогда
		яНомер = СтрЗаменить(яВ.Номер, "\", "");
		яНомер = СтрЗаменить(яНомер, "/", "");
		яНомер = СтрЗаменить(яНомер, " ", "");
		//Уберём лидирующие нули
		Если ъУбиратьЛидирующиеНули Тогда
			Для й = 1 По СтрДлина(яНомер) Цикл
				Если Сред(яНомер, й, 1) <> "0" Тогда
					Прервать;
				КонецЕсли;
			КонецЦикла;
			яНомер = Сред(яНомер, й);
		КонецЕсли;
		яТекст = Формат(яВ.Дата, "ДФ=yyyy-MM-dd") + " " + яТекст + яНомер;
		яО.Данные = яТекст;
	Иначе
		ITC.Ответ_УстановитьСтатус(яО, "Не удалось найти документ " + Строка(ъСсылка));
	КонецЕсли;
	
	Возврат яО;
КонецФункции