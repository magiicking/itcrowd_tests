﻿
&НаСервере
Процедура ЗагрузитьСтатусыНаСервере()
	яЗ = Новый Запрос;
	яЗ.Текст = 
	"ВЫБРАТЬ
	|	МИНИМУМ(ITC_СтатусыЗадач.Дата) КАК Период,
	|	ITC_СтатусыЗадач.Задача КАК Задача
	|ПОМЕСТИТЬ ВТ_ЗагруженныеСтатусы
	|ИЗ
	|	РегистрСведений.ITC_СтатусыЗадач КАК ITC_СтатусыЗадач
	|
	|СГРУППИРОВАТЬ ПО
	|	ITC_СтатусыЗадач.Задача
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Задача
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ITC_Задача.JIRA_ID КАК JIRA_ID,
	|	ITC_Задача.JIRA КАК JIRA,
	|	ITC_Задача.Ссылка КАК Ссылка,
	|	ITC_Задача.ДатаСоздания КАК ДатаСоздания,
	|	ITC_Задача.Статус КАК Статус
	|ИЗ
	|	Справочник.ITC_Задача КАК ITC_Задача
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ЗагруженныеСтатусы КАК ВТ_ЗагруженныеСтатусы
	|		ПО ITC_Задача.Ссылка = ВТ_ЗагруженныеСтатусы.Задача
	|ГДЕ
	|	НЕ ITC_Задача.JIRA.Код ЕСТЬ NULL
	|	И ITC_Задача.ДатаСоздания > ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|	И ВТ_ЗагруженныеСтатусы.Задача ЕСТЬ NULL
	|
	|УПОРЯДОЧИТЬ ПО
	|	JIRA,
	|	JIRA_ID
	|ИТОГИ ПО
	|	JIRA";
	
	яКешСтруктура = Новый Структура;
	
	яРезЗап = яЗ.Выполнить();
	яВыбСервер = яРезЗап.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "JIRA");
	// Отбираем сервера JIRA
	Пока яВыбСервер.Следующий() Цикл
		яПодключение = ITC_JIRA.ДанныеПодключения(яВыбСервер.JIRA);
		
		// Отбираем задачи для этого сервера
		яВыбЗадача = яВыбСервер.Выбрать();
		Пока яВыбЗадача.Следующий() Цикл
			яКоннект = ITC_JIRA.СоздатьЗапросИПодключение(яПодключение, "/issue/" + яВыбЗадача.JIRA_ID + "?expand=changelog&maxresult=500");
			
			// Получаем данные по задаче с учётом изменений
			Попытка
				HTTPОтвет = яКоннект.Соединение.Получить(яКоннект.Запрос); //GET запрос
				яСтрокаОтвет = HTTPОтвет.ПолучитьТелоКакСтроку();
				
				Если HTTPОтвет.КодСостояния > 299 Тогда
					яОписаниеОшибки = "Код состояния: " + HTTPОтвет.КодСостояния + ". Данные не получены!";
				КонецЕсли;
			Исключение
				яОписаниеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
				яОписаниеОшибки = "Ошибка при выполнении HTTP запроса: " + яОписаниеОшибки;
			КонецПопытки;

			// Парсим данные
			Чтение = Новый ЧтениеJSON;
			Чтение.УстановитьСтроку(яСтрокаОтвет);
			ПолученныеДанные = ПрочитатьJSON(Чтение, Истина);
			Чтение.Закрыть();
			
			яПервоеИзменение = Истина;
			яНачальныйСтатус = яВыбЗадача.Статус;
			
			яЛог = ПолученныеДанные["changelog"];
			Если яЛог <> Неопределено Тогда
				яИстория = яЛог["histories"];				
				
				// Перебираем историю изменений и ищем события изменения статуса
				Для Каждого яСобытие Из яИстория Цикл
					яМенялсяСтатус = Ложь;
					Для Каждого яПоле Из яСобытие["items"] Цикл
						Если яПоле["field"] = "status" Тогда
							яМенялсяСтатус = Истина;
							Прервать;
						КонецЕсли;
					КонецЦикла;
					Если яМенялсяСтатус Тогда
						Если яПервоеИзменение Тогда
							яПервоеИзменение = Ложь;
							яНачальныйСтатус = ITC_JIRA.ПолучитьОбъектJIRA(яВыбСервер.JIRA, яПоле["from"], "ITC_СтатусыЗадач", Ложь);
							ITC_JIRA.ОбновитьИсториюСтатуса(яВыбЗадача.Ссылка
							, яНачальныйСтатус
							, яВыбЗадача.ДатаСоздания);
						КонецЕсли;
						
						яДатаСтатуса = ITC_JIRA.ПолучитьДату(яСобытие["created"]);
						яСтатус = ITC_JIRA.ПолучитьОбъектJIRA(яВыбСервер.JIRA, яПоле["to"], "ITC_СтатусыЗадач", Ложь);
						
						ITC_JIRA.ОбновитьИсториюСтатуса(яВыбЗадача.Ссылка
						, яСтатус
						, яДатаСтатуса);
						
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
			
			//Если изменений статуса не было, создаём запись в регистре всё равно
			Если яПервоеИзменение Тогда
				ITC_JIRA.ОбновитьИсториюСтатуса(яВыбЗадача.Ссылка
				, яНачальныйСтатус
				, яВыбЗадача.ДатаСоздания);				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьСтатусы(Команда)
	ЗагрузитьСтатусыНаСервере();
КонецПроцедуры
