﻿
Процедура ПередЗаписью(Отказ)
	
	Если НЕ ЭтоГруппа Тогда
		ВидыКлавиатуры = Перечисления.ТелеграмВидыКлавиатуры;
		Если ВидКлавиатуры = ВидыКлавиатуры.Контекстная Тогда
			Для Каждого СтрокаКнопка Из Кнопки Цикл
				Если НЕ ЗначениеЗаполнено(СтрокаКнопка.ДанныеОтправки) И НЕ ЗначениеЗаполнено(СтрокаКнопка.URL) Тогда
					Сообщить("В строке " + СтрокаКнопка.НомерСтроки + " табличной части ""Кнопки"" не заполнены ни данные отправки, ни URL");
					Отказ = Истина;
				ИначеЕсли ЗначениеЗаполнено(СтрокаКнопка.ДанныеОтправки) И ЗначениеЗаполнено(СтрокаКнопка.URL) Тогда
					Сообщить("В строке " + СтрокаКнопка.НомерСтроки + " табличной части ""Кнопки"" заполнены и данные отправки, и URL (нужно что-то одно)");
					Отказ = Истина;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры
