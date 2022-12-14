
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЭтап()
	ТекущаяЗапись = Элементы.Этапы.ТекущиеДанные;
	Если ТекущаяЗапись.Свойство("ГруппировкаСтроки") Тогда
		Если ТекущаяЗапись.ГруппировкаСтроки.ИмяГруппировки = "Проект" Тогда
			Если Проект = ТекущаяЗапись.ГруппировкаСтроки.Ключ Тогда
				Возврат;
			КонецЕсли;
			Проект = ТекущаяЗапись.ГруппировкаСтроки.Ключ;
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Работы, "Проект", Проект, ВидСравненияКомпоновкиДанных.Равно);
			ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Работы, "Этап");
		КонецЕсли;
	Иначе //мы на самом деле на строке соответствующей этапу
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Работы, "Этап", ТекущаяЗапись.Ссылка, ВидСравненияКомпоновкиДанных.Равно);
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Работы, "Проект");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыПриАктивизацииСтроки(Элемент)
	// Вставить содержимое обработчика.
	ПодключитьОбработчикОжидания("ОбновитьЭтап",0.1, Истина);
КонецПроцедуры
