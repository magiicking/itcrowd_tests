﻿	
#Область Работа_с_задачами_JIRA

Процедура РегламентнаяЗагрузкаЗадачИзJIRA() Экспорт
	
	яКешСтруктура = Новый Структура;
	
	яЗ = Новый Запрос;
	яЗ.Текст = 
	"ВЫБРАТЬ
	|	ITC_JIRA.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ITC_JIRA КАК ITC_JIRA
	|ГДЕ
	|	НЕ ITC_JIRA.ПометкаУдаления
	|	И ITC_JIRA.Адрес <> """"
	|	И ITC_JIRA.Авторизация <> """"";
	
	яРезЗап = яЗ.Выполнить();
	яВ = яРезЗап.Выбрать();
	Пока яВ.Следующий() Цикл
		ПолучитьЗадачи(яВ.Ссылка, яКешСтруктура);
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьЗадачи(яСервер, яКешСтруктура = Неопределено, яЗапросJQL = "") Экспорт
	
	яПоправкаВремениITC_JIRA = 600; //СмещениеСтандартногоВремени() ?
	яО = ITC.отвНовый(, "ITC.ПолучитьЗадачиJIRA");
	яМаксимумРезультатов = 999;
	
	яПодключение = ДанныеПодключения(яСервер);
	Если Не яПодключение.Успех Тогда
		ITC.отвОбъединить(яО, яПодключение);
		Возврат яО;
	КонецЕсли;
	
	яДанные = Новый Соответствие();
	яДанные.Вставить("maxResults", яМаксимумРезультатов);
	яДанные.Вставить("fields", Новый Массив());
	
	// Получим время последнего обмена
	Если ПустаяСтрока(яЗапросJQL) Тогда
		яМЗ = РегистрыСведений.ITC_ДатаОбмена.СоздатьМенеджерЗаписи();
		яМЗ.JIRA = яСервер;
		яМЗ.Прочитать();
		Если яМЗ.Выбран() Тогда
			яДатаЧтения = яМЗ.ВремяОбмена;
		Иначе
			яДатаЧтения = НачалоМинуты(ТекущаяДатаСеанса() - яПоправкаВремениITC_JIRA);
		КонецЕсли;
		яДанные.Вставить("jql", "updated >= '" + Формат(яДатаЧтения, "ДФ='yyyy/MM/dd HH:mm'") + "'");
		яДатаЧтения = НачалоМинуты(ТекущаяДатаСеанса()) - яПоправкаВремениITC_JIRA;
	Иначе
		яДанные.Вставить("jql", яЗапросJQL);
	КонецЕсли;
	
	
	fields = яДанные.Получить("fields");
	fields.Добавить("id");
	fields.Добавить("key");
	fields.Добавить("summary");
	
	яКоннект = СоздатьЗапросИПодключение(яПодключение, "/search");
	
	яНачало = 0;
	яПродолжать = Истина;
	яМассивЗадач = Новый Массив;
	
	Пока яПродолжать Цикл
		яДанные.Вставить("startAt", яНачало);
			
		яСтрJSON = СереализоватьДанные(яДанные);
		
		яКоннект.Запрос.УстановитьТелоИзСтроки(яСтрJSON, КодировкаТекста.UTF8);
		
		яОписаниеОшибки = "";
		Попытка
			HTTPОтвет = яКоннект.Соединение.ОтправитьДляОбработки(яКоннект.Запрос); //POST запрос
			яСтрокаОтвет = HTTPОтвет.ПолучитьТелоКакСтроку();
			
			Если ПустаяСтрока(яЗапросJQL) Тогда
				яДатаСтрока = HTTPОтвет.Заголовки.Получить("Date");
				Если яДатаСтрока <> Неопределено Тогда
					яНомер = СтрНайти(яДатаСтрока, "GMT");
					яМ = СтрРазделить(Сред(яДатаСтрока, яНомер - 9, 8), ":", Ложь);
					Если яМ.Количество() = 3 Тогда
						яДатаЧтения = Мин(яДатаЧтения, НачалоДня(ТекущаяДатаСеанса()) + яМ[0] * 3600 + яМ[1] * 60 + СмещениеСтандартногоВремени() - яПоправкаВремениITC_JIRA);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			
			Если HTTPОтвет.КодСостояния > 299 Тогда
				яОписаниеОшибки = "Код состояния: " + HTTPОтвет.КодСостояния + ". Данные не получены!";
			КонецЕсли;
		Исключение
			яОписаниеОшибки = "Ошибка при выполнении HTTP запроса: " + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		КонецПопытки;
		
		Если Не ПустаяСтрока(яОписаниеОшибки) Тогда
			ITC.отвЗадатьСтатус(яО, яОписаниеОшибки);
			ITC.отвЛогировать(яО);
			Возврат яО;
		КонецЕсли;
		
		Чтение = Новый ЧтениеJSON;
		Чтение.УстановитьСтроку(яСтрокаОтвет);
		ПолученныеДанные = ПрочитатьJSON(Чтение, Истина);
		Чтение.Закрыть();
		
		
		
		issues = ПолученныеДанные.Получить("issues"); 
		Если НЕ issues = Неопределено Тогда
			текПолучено = issues.Количество(); 
			Для Каждого issue ИЗ issues Цикл
				fields = issue.Получить("fields"); 
				Если НЕ fields = Неопределено Тогда
					
					яИД = issue["key"];
					яКод = issue["id"];
					яИмяОбъекта = "ITC_Задача";
					яНаименование = issue["fields"]["summary"];
					
					яЗадача = ПолучитьОбъектJIRA(яСервер, яИД, яИмяОбъекта, Ложь,, яКод);
					Если яЗадача = Неопределено Тогда
						яЗадача = СоздатьОбъектJIRA(яСервер, яИД, яИмяОбъекта, яНаименование, Ложь, яКод);
						яЗадача.Наименование = яНаименование;
						яЗадача.Записать();
					Иначе
						яЗадача = яЗадача.ПолучитьОбъект();
					КонецЕсли;
					
					яМассивЗадач.Добавить(яЗадача);
				КонецЕсли;
			КонецЦикла;
			
			//Зафиксируем время успешного обмена
			Если ПустаяСтрока(яЗапросJQL) Тогда
				яМЗ.JIRA = яСервер;
				яМЗ.ВремяОбмена = яДатаЧтения;
				яМЗ.Записать();
			КонецЕсли;
			
		КонецЕсли;
		
		Если issues.Количество() = яМаксимумРезультатов Тогда
			яНачало = яНачало + яМаксимумРезультатов;
		Иначе
			яПродолжать = Ложь;
		КонецЕсли;
	КонецЦикла;
	
	ОбновитьМассивЗадач(яМассивЗадач, яСервер, яКешСтруктура);

	Возврат яО;
	
КонецФункции

Процедура ОбновитьМассивЗадач(яМассив, яСервер, яКешСтруктура = Неопределено)
	
	яПодключение = Неопределено;
	Для Каждого яЗадача Из яМассив Цикл
		ОбновитьЗадачу(яЗадача, яПодключение, Истина, яКешСтруктура);
	КонецЦикла;
	
КонецПроцедуры

Функция ОбновитьЗадачу(яЗадача, яПодключение = Неопределено, яЗаписывать = Истина, яКешСтруктура = Неопределено) Экспорт
	
	яО = ITC.отвНовый(, "ITC.ОбновитьЗадачуJIRA");
	яСервер = яЗадача.JIRA;
	Если яКешСтруктура = Неопределено Тогда
		яКешСтруктура = Новый Структура;
	КонецЕсли;
	
	Если яПодключение = Неопределено Тогда
		яПодключение = ДанныеПодключения(яСервер);
	КонецЕсли;
	
	яКоннект = СоздатьЗапросИПодключение(яПодключение, "/issue/" + яЗадача.JIRA_ID);
	
	Попытка
		HTTPОтвет = яКоннект.Соединение.Получить(яКоннект.Запрос); //GET запрос
		яСтрокаОтвет = HTTPОтвет.ПолучитьТелоКакСтроку();
		
		Если HTTPОтвет.КодСостояния > 299 Тогда
			яОписаниеОшибки = "Код состояния: " + HTTPОтвет.КодСостояния + ". Данные не получены!";
		КонецЕсли;
	Исключение
		яОписаниеОшибки = "Ошибка при выполнении HTTP запроса: " + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;
	
	Если Не ПустаяСтрока(яОписаниеОшибки) Тогда
		ITC.отвЗадатьСтатус(яО, яОписаниеОшибки);
		ITC.отвЛогировать(яО);
		Возврат яО;
	КонецЕсли;
	
	Чтение = Новый ЧтениеJSON;
	Чтение.УстановитьСтроку(яСтрокаОтвет);
	ПолученныеДанные = ПрочитатьJSON(Чтение, Истина);
	Чтение.Закрыть();
	
	яСекундВЧасе = 3600;
	яПоля = ПолученныеДанные["fields"];
	
	яРодитель = ПолучитьЗадачу(яПоля["parent"], яСервер, яКешСтруктура);
	яЗадача.Родитель = яРодитель;
	
	яЗадача.JIRA_ID = ПолученныеДанные["key"];
	яЗадача.JIRA_CODE = ПолученныеДанные["id"];
	
	яЗадача.ТипЗадачи = ПолучитьТипЗадачи(яПоля["issuetype"], яСервер, яКешСтруктура);
	яЗадача.Приоритет = ПолучитьПриоритет(яПоля["priority"], яСервер, яКешСтруктура);
	яЗадача.Эпик = ПолучитьОбъектJIRA(яСервер, яПоля["customfield_10102"], "ITC_Задача", Ложь);
	
	яЗадача.Наименование = яПоля["summary"];
	яЗадача.Описание = яПоля["description"];
	
	яЗадача.Сущность = ПолучитьПолеСМетками(яПоля["customfield_10600"]);
	яЗадача.Процесс = ПолучитьПолеСМетками(яПоля["customfield_10700"]);
	
	яЗадача.ДатаЗавершения = ПолучитьДату(яПоля["resolutiondate"]);
	яЗадача.ДатаАктирования = ПолучитьДату(яПоля["customfield_10415"]);
	яЗадача.ДатаСоздания = ПолучитьДату(яПоля["created"]);
	
	яЗадача.ПервоначальнаяОценка = ПолучитьЧисло(яПоля["aggregatetimeoriginalestimate"]) / яСекундВЧасе;
	яЗадача.Остаток = ПолучитьЧисло(яПоля["timeestimate"]) / яСекундВЧасе;
	
	яЗадача.Автор = НайтиСоздатьПользователя(яПоля["creator"], яСервер, яКешСтруктура);
	яЗадача.Аналитик = НайтиСоздатьПользователя(яПоля["customfield_10400"], яСервер, яКешСтруктура);
	яЗадача.Куратор = НайтиСоздатьПользователя(яПоля["customfield_10411"], яСервер, яКешСтруктура);
	яЗадача.Ответственный = НайтиСоздатьПользователя(яПоля["assignee"], яСервер, яКешСтруктура);
	яЗадача.Разработчик = НайтиСоздатьПользователя(яПоля["customfield_10401"], яСервер, яКешСтруктура);
	яЗадача.Тестировщик = НайтиСоздатьПользователя(яПоля["customfield_10407"], яСервер, яКешСтруктура);
	
	яЗадача.Проект = ПолучитьПроект(яПоля["project"], яСервер, яКешСтруктура);
	
	яЗадача.Спринт = ПолучитьАктивныйСпринт(яПоля["customfield_10101"], яСервер, яКешСтруктура);
	
	яЗадача.Релиз = ПолучитьРелиз(яПоля["fixVersions"], яСервер, яКешСтруктура);
	
	яЗадача.Статус = ПолучитьСтатус(яПоля["status"], яСервер, яКешСтруктура);
	
	яРез = ПолучитьЧасыПоЗадаче(яЗадача, яСервер, яКешСтруктура, яПодключение);
	Если Не яРез.Успех Тогда
		ITC.отвОбъединить(яО, яРез);
	КонецЕсли;
	
	Если яЗаписывать Тогда
		яЗадача.Записать();
		яДатаИзменения = ПолучитьДату(яПоля["updated"]);
		ОбновитьИсториюСтатуса(яЗадача.Ссылка, яЗадача.Статус, яДатаИзменения);
	КонецЕсли;
	
	Возврат яО;
	
КонецФункции

Процедура ОбновитьИсториюСтатуса(яЗадача, яСтатус, яДатаИзменения) Экспорт
	
	
	яЗ = Новый Запрос;
	яЗ.УстановитьПараметр("Задача", яЗадача);
	яЗ.УстановитьПараметр("Дата", яДатаИзменения);
	яЗ.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ITC_СтатусыЗадач.Задача КАК Задача,
	|	ITC_СтатусыЗадач.Дата КАК Дата,
	|	ITC_СтатусыЗадач.Статус КАК Статус
	|ИЗ
	|	РегистрСведений.ITC_СтатусыЗадач КАК ITC_СтатусыЗадач
	|ГДЕ
	|	ITC_СтатусыЗадач.Задача = &Задача
	|	И ITC_СтатусыЗадач.Дата < &Дата
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата УБЫВ";
	
	яВ = яЗ.Выполнить().Выбрать();
	Если яВ.Следующий() Тогда
		яПрошлыйСтатус = яВ.Статус;
	Иначе
		яПрошлыйСтатус = Неопределено;
	КонецЕсли;

	Если яПрошлыйСтатус <> яСтатус Тогда
		яМЗ = РегистрыСведений.ITC_СтатусыЗадач.СоздатьМенеджерЗаписи();
		яМЗ.Задача = яЗадача;
		яМЗ.Статус = яСтатус;
		яМЗ.Дата = яДатаИзменения;
		яМЗ.Записать(Истина);
		
		Если яПрошлыйСтатус <> Неопределено Тогда
			яМЗ = РегистрыСведений.ITC_СтатусыЗадач.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(яМЗ, яВ);
			яМЗ.ВремяВСтатусе = (яДатаИзменения - яВ.Дата) / 3600; // 3600 - секунд в часе
			яМЗ.Записать(Истина);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#Область Получение_отдельных_типов

Функция ПолучитьЗадачу(яДанные, яСервер, яКешСтруктура)
	
	Если яДанные = Неопределено Тогда
		Возврат Справочники.ITC_Задача.ПустаяСсылка();
	КонецЕсли;
	
	//[ Поиск в кеше
	яИмяВКеше = "ITC_Задача";
	яКлючВКеше = яДанные["id"];
	
	яСсылка = КешПоиск(яКешСтруктура, яИмяВКеше, яКлючВКеше);
	Если яСсылка <> Неопределено Тогда
		Возврат яСсылка;
	КонецЕсли;
	//]
	
	яКлючВКеше = яДанные["key"];
	яКод = яДанные["id"];
	яНаименование = яДанные["fields"]["summary"];
	
	яОбъект = ПолучитьОбъектJIRA(яСервер, яКлючВКеше, яИмяВКеше, Ложь,, яКод);
	Если яОбъект = Неопределено Тогда
		яОбъект = СоздатьОбъектJIRA(яСервер, яКлючВКеше, яИмяВКеше, яНаименование, Истина, яКод); 
		яОбъект = яОбъект.Ссылка;
	КонецЕсли;	
	
	//[ Заполнение Кеша
	Возврат КешЗапись(яОбъект
	, яКешСтруктура, яИмяВКеше, яКлючВКеше);
	//
	
КонецФункции

Функция ПолучитьСтатус(яДанные, яСервер, яКешСтруктура)
	
	Если яДанные = Неопределено Тогда
		Возврат Справочники.ITC_СтатусыЗадач.ПустаяСсылка();
	КонецЕсли;
	
	//[ Поиск в кеше
	яИмяВКеше = "ITC_СтатусыЗадач";
	яКлючВКеше = яДанные["id"];
	
	яСсылка = КешПоиск(яКешСтруктура, яИмяВКеше, яКлючВКеше);
	Если яСсылка <> Неопределено Тогда
		Возврат яСсылка;
	КонецЕсли;
	//]
	
	яНаименование = яДанные["name"];
	
	яОбъект = ПолучитьОбъектJIRA(яСервер, яКлючВКеше, яИмяВКеше, Ложь);
	Если яОбъект = Неопределено Тогда
		яОбъект = СоздатьОбъектJIRA(яСервер, яКлючВКеше, яИмяВКеше, яНаименование); 
	Иначе
		яОбъект = яОбъект.ПолучитьОбъект();
		яОбъект.Наименование = яНаименование;
	КонецЕсли;
	яОбъект.Категория = ПолучитьКатегориюСтатуса(яДанные["statusCategory"], яСервер, яКешСтруктура);
	яОбъект.Записать();
	
	//[ Заполнение Кеша
	Возврат КешЗапись(яОбъект.Ссылка
	, яКешСтруктура, яИмяВКеше, яКлючВКеше);
	//]
	
КонецФункции

Функция ПолучитьКатегориюСтатуса(яДанные, яСервер, яКешСтруктура)
	
	Если яДанные = Неопределено Тогда
		Возврат Справочники.ITC_КатегорияСтатуса.ПустаяСсылка();
	КонецЕсли;
	
	//[ Поиск в кеше
	яИмяВКеше = "ITC_КатегорияСтатуса";
	яКлючВКеше = яДанные["key"];
	
	яСсылка = КешПоиск(яКешСтруктура, яИмяВКеше, яКлючВКеше);
	Если яСсылка <> Неопределено Тогда
		Возврат яСсылка;
	КонецЕсли;
	//]
	
	яНаименование = яДанные["name"];
	
	яОбъект = ПолучитьОбъектJIRA(яСервер, яКлючВКеше, яИмяВКеше, Ложь);
	Если яОбъект = Неопределено Тогда
		яОбъект = СоздатьОбъектJIRA(яСервер, яКлючВКеше, яИмяВКеше, яНаименование);
		яОбъект.Записать();
		яОбъект = яОбъект.Ссылка;
	КонецЕсли;
	
	
	//[ Заполнение Кеша
	Возврат КешЗапись(яОбъект
	, яКешСтруктура, яИмяВКеше, яКлючВКеше);
	//]
	
КонецФункции

Функция ПолучитьПроект(яДанные, яСервер, яКешСтруктура)
	
	Если яДанные = Неопределено Тогда
		Возврат Справочники.ITC_Проекты.ПустаяСсылка();
	КонецЕсли;
	
	//[ Поиск в кеше
	яИмяВКеше = "ITC_Проекты";
	яКлючВКеше = яДанные["key"];
	
	яСсылка = КешПоиск(яКешСтруктура, яИмяВКеше, яКлючВКеше);
	Если яСсылка <> Неопределено Тогда
		Возврат яСсылка;
	КонецЕсли;
	//]
	
	яНаименование = яДанные["name"];
	
	яОбъект = ПолучитьОбъектJIRA(яСервер, яКлючВКеше, яИмяВКеше, Ложь);
	Если яОбъект = Неопределено Тогда
		яОбъект = СоздатьОбъектJIRA(яСервер, яКлючВКеше, яИмяВКеше, яНаименование); 
	Иначе
		яОбъект = яОбъект.ПолучитьОбъект();
		яОбъект.Наименование = яНаименование;
	КонецЕсли;
	яОбъект.Записать();
	
	//[ Заполнение Кеша
	Возврат КешЗапись(яОбъект.Ссылка
	, яКешСтруктура, яИмяВКеше, яКлючВКеше);
	//]
	
КонецФункции

Функция ПолучитьТипЗадачи(яДанные, яСервер, яКешСтруктура)
	
	//[ Поиск в кеше
	яИмяВКеше = "ITC_ТипЗадачи";
	яКлючВКеше = яДанные["id"];
	
	яСсылка = КешПоиск(яКешСтруктура, яИмяВКеше, яКлючВКеше);
	Если яСсылка <> Неопределено Тогда
		Возврат яСсылка;
	КонецЕсли;
	//]
	
	яНаименование = яДанные["name"];
	
	яОбъект = ПолучитьОбъектJIRA(яСервер, яКлючВКеше, яИмяВКеше, Ложь);
	Если яОбъект = Неопределено Тогда
		яОбъект = СоздатьОбъектJIRA(яСервер, яКлючВКеше, яИмяВКеше, яНаименование); 
	Иначе
		яОбъект = яОбъект.ПолучитьОбъект();
		яОбъект.Наименование = яНаименование;
	КонецЕсли;
	яОбъект.Записать();
	
	//[ Заполнение Кеша
	Возврат КешЗапись(яОбъект.Ссылка
	, яКешСтруктура, яИмяВКеше, яКлючВКеше);
	//]
	
КонецФункции

Функция ПолучитьПриоритет(яДанные, яСервер, яКешСтруктура)
	
	//[ Поиск в кеше
	яИмяВКеше = "ITC_Приоритет";
	яКлючВКеше = яДанные["id"];
	
	яСсылка = КешПоиск(яКешСтруктура, яИмяВКеше, яКлючВКеше);
	Если яСсылка <> Неопределено Тогда
		Возврат яСсылка;
	КонецЕсли;
	//]
	
	яНаименование = яДанные["name"];
	
	яОбъект = ПолучитьОбъектJIRA(яСервер, яКлючВКеше, яИмяВКеше, Ложь);
	Если яОбъект = Неопределено Тогда
		яОбъект = СоздатьОбъектJIRA(яСервер, яКлючВКеше, яИмяВКеше, яНаименование); 
	Иначе
		яОбъект = яОбъект.ПолучитьОбъект();
		яОбъект.Наименование = яНаименование;
	КонецЕсли;
	яОбъект.Записать();
	
	//[ Заполнение Кеша
	Возврат КешЗапись(яОбъект.Ссылка
	, яКешСтруктура, яИмяВКеше, яКлючВКеше);
	//]
	
КонецФункции

Функция ПолучитьЧисло(яЗначение)
	Если ТипЗнч(яЗначение) = Тип("Число") Тогда
		Возврат яЗначение;
	КонецЕсли;
	Возврат 0;
КонецФункции

Функция ПолучитьРелиз(яЗначение, яСервер, яКешСтруктура)
	яПС = Справочники.ITC_Релиз.ПустаяСсылка();
	Если ТипЗнч(яЗначение) <> Тип("Массив") ИЛИ яЗначение.Количество() = 0 Тогда
		Возврат яПС;
	КонецЕсли;
	
	яДанные = яЗначение[0];
	
	//[ Поиск в кеше
	яИмяВКеше = "ITC_Релиз";
	яКлючВКеше = яДанные["id"];
	
	яСсылка = КешПоиск(яКешСтруктура, яИмяВКеше, яКлючВКеше);
	Если яСсылка <> Неопределено Тогда
		Возврат яСсылка;
	КонецЕсли;
	//]
	
	яНаименование = яДанные["name"];
	
	яОбъект = ПолучитьОбъектJIRA(яСервер, яКлючВКеше, яИмяВКеше, Ложь);
	Если яОбъект = Неопределено Тогда
		яОбъект = СоздатьОбъектJIRA(яСервер, яКлючВКеше, яИмяВКеше, яНаименование); 
	Иначе
		яОбъект = яОбъект.ПолучитьОбъект();
		яОбъект.Наименование = яНаименование;
	КонецЕсли;
	яОбъект.Активный = НЕ (яДанные["archived"] ИЛИ яДанные["released"]);
	
	яОбъект.ДатаОкончания = ПолучитьДату(яДанные["releaseDate"]);
	яОбъект.Записать();
	
	//[ Заполнение Кеша
	Возврат КешЗапись(яОбъект.Ссылка
	, яКешСтруктура, яИмяВКеше, яКлючВКеше);
	//]
КонецФункции

Функция ПолучитьДату(яЗначение) Экспорт
	Если яЗначение = Неопределено Тогда
		Возврат Дата('00010101');
	Иначе
		яДата = СтрЗаменить(яЗначение, "-", "");
		яДата = СтрЗаменить(яДата, ":", "");
		яДата = СтрЗаменить(яДата, "T", "");
		яДата = СтрЗаменить(яДата, ".", "");
		яДата = СтрЗаменить(яДата, "+", "");
		Возврат Дата(Лев(яДата, 14));
	КонецЕсли;
КонецФункции

Функция ПолучитьПолеСМетками(яЗначение)
	
	Если Не ЗначениеЗаполнено(яЗначение) Тогда
		Возврат "";
	ИначеЕсли ТипЗнч(яЗначение) <> Тип("Массив") Тогда
		Возврат Строка(яЗначение);
	КонецЕсли;

	//Для й = 0 По яЗначение.ВГраница() Цикл
	//	яЗначение[й] = """" + яЗначение[й] + """";
	//КонецЦикла;
	
	Возврат СтрСоединить(яЗначение, ", ");;
	
КонецФункции

Функция ПолучитьАктивныйСпринт(яСпринты, яСервер, яКешСтруктура)
	Если яСпринты = Неопределено Тогда
		Возврат Справочники.ITC_Спринт.ПустаяСсылка();
	КонецЕсли;
	Если Не яКешСтруктура.Свойство("СтатусыАктивныхСпринтов") Тогда
		яМ = Новый Соответствие;
		яМ.Вставить("ACTIVE", Истина);
		яМ.Вставить("FUTURE", Истина);
		яКешСтруктура.Вставить("СтатусыАктивныхСпринтов", яМ);
	КонецЕсли;
	
	Для Каждого яСтрокаСпринта Из яСпринты Цикл
		яНачальныйНомер = СтрНайти(яСтрокаСпринта, "[");
		яКонечныйНомер = СтрНайти(яСтрокаСпринта, "]", НаправлениеПоиска.СКонца);
		яС = Сред(яСтрокаСпринта, яНачальныйНомер + 1, яНачальныйНомер - яКонечныйНомер);
		яМассивПолей = СтрРазделить(яС, ",", Ложь);
		яСпринтСтруктура = Новый Структура;
		Для Каждого яПоле Из яМассивПолей Цикл
			яМ = СтрРазделить(яПоле, "=");
			Если яМ.Количество() > 1 Тогда
				яСпринтСтруктура.Вставить(яМ[0], яМ[1]);
			КонецЕсли;
		КонецЦикла;
		Если яСпринтСтруктура.Свойство("id") И ЗначениеЗаполнено(яСпринтСтруктура.id) И
			яСпринтСтруктура.Свойство("state") И яКешСтруктура.СтатусыАктивныхСпринтов.Получить(ВРег(яСпринтСтруктура.state)) <> Неопределено Тогда
			яСпринт = ПолучитьОбъектJIRA(яСервер
			, яСпринтСтруктура.id
			, "ITC_Спринт"
			, Истина
			, яСпринтСтруктура.name);
			Возврат яСпринт;
		КонецЕсли;
	КонецЦикла;
	
	// Состав спринта
	//"com.atlassian.greenhopper.service.sprint.Sprint@47fb6660[
	//id=114,rapidViewId=78,state=ACTIVE,name=Неделя 7,startDate=2022-02-14T10:04:00.000+03:00,endDate=2022-02-28T10:04:00.000+03:00,completeDate=<null>,activatedDate=2022-02-14T10:04:41.638+03:00,sequence=114,goal=Начало разработки марта / Денис отпуск
	//]"
	
	Возврат Справочники.ITC_Спринт.ПустаяСсылка();
КонецФункции

Функция НайтиСоздатьПользователя(яДанныеJIRA, яСервер, яКешСтруктура);
	Если ТипЗнч(яДанныеJIRA) <> Тип("Соответствие") ИЛИ
		Не ЗначениеЗаполнено(яДанныеJIRA["name"]) Тогда
		Возврат Справочники.Пользователи.ПустаяСсылка();
	КонецЕсли;
	
	яДоменноеИмя = яДанныеJIRA["name"];
	
	//[ Поиск в кеше
	яИмяВКеше = "Пользователи";
	яКлючВКеше = яДоменноеИмя;
	
	яСсылка = КешПоиск(яКешСтруктура, яИмяВКеше, яКлючВКеше);
	Если яСсылка <> Неопределено Тогда
		Возврат яСсылка;
	КонецЕсли;
	//]
	
	яНаименование = яДанныеJIRA["displayName"];
	яПочта = яДанныеJIRA["emailAddress"];
	
	//[ Создание объекта
	яОбъект = ПолучитьОбъектJIRA(яСервер, яКлючВКеше, яИмяВКеше, Ложь);
	Если яОбъект = Неопределено Тогда
		яОбъект = СоздатьОбъектJIRA(яСервер, яКлючВКеше, яИмяВКеше, яНаименование); 
	Иначе
		яОбъект = яОбъект.ПолучитьОбъект();
		яОбъект.Наименование = яНаименование;
	КонецЕсли;
	//]
	
	УправлениеКонтактнойИнформацией.ДобавитьКонтактнуюИнформацию(яОбъект
		, яПочта
		, Справочники.ВидыКонтактнойИнформации.EmailПользователя
		, , Истина);
	яОбъект.Записать();
	
	//[ Заполнение Кеша
	Возврат КешЗапись(яОбъект.Ссылка
	, яКешСтруктура, яИмяВКеше, яКлючВКеше);
	//]
КонецФункции

#КонецОбласти

// Функция - Данные подключения
//
// Параметры:
//  яСервер	 - 	 - 
// 
// Возвращаемое значение:
//   Структура - структура URL:
//     * Схема - Строка - схема обращения к серверу (http, https).
//     * Сервер - Строка - адрес сервера.
//     * Порт - Число - порт сервера.
//     * Путь - Строка - адрес ресурса на сервере.
//     * Авторизация - basic ключ для передачи на сервер
Функция ДанныеПодключения(яСервер) Экспорт
	яО = ITC.отвНовый("Авторизация,Схема,Сервер,Порт,Путь");
	
	яЗ = Новый Запрос;
	яЗ.УстановитьПараметр("Сервер", яСервер);
	яЗ.Текст = 
	"ВЫБРАТЬ
	|	ITC_JIRA.Авторизация КАК Авторизация,
	|	ITC_JIRA.Адрес КАК Адрес
	|ИЗ
	|	Справочник.ITC_JIRA КАК ITC_JIRA
	|ГДЕ
	|	ITC_JIRA.Ссылка = &Сервер";
	
	яРезЗап = яЗ.Выполнить();
	яВ = яРезЗап.Выбрать();
	Если яВ.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(яО, яВ);
		яПодготовленныйАдрес = ITC_Коннектор.РазобратьURL(яВ.Адрес);
		ЗаполнитьЗначенияСвойств(яО, яПодготовленныйАдрес);
		Если яО.Порт = 0 Тогда
			яО.Порт = Неопределено;
		КонецЕсли;
	Иначе
		ITC.отвЗадатьСтатус(яО, "Переданная ссылка на сервер не действительна.");
	КонецЕсли;
	
	Возврат яО;
КонецФункции

Функция СереализоватьДанные(яДанные) Экспорт
	
	яНастройкиСериализации = Новый НастройкиСериализацииJSON;
	яНастройкиСериализации.ВариантЗаписиДаты = ВариантЗаписиДатыJSON.УниверсальнаяДата;
	яНастройкиСериализации.ФорматСериализацииДаты = ФорматДатыJSON.ISO;
	яЗаписьJSON = Новый ЗаписьJSON;
	яЗаписьJSON.УстановитьСтроку();
	ЗаписатьJSON(яЗаписьJSON, яДанные, яНастройкиСериализации);
	Возврат яЗаписьJSON.Закрыть();
	
КонецФункции

Функция СоздатьЗапросИПодключение(яПодключение, яДопПуть) Экспорт
	
	яКоннект = Новый Структура("Запрос,Соединение");
	яЗаголовкиHTTP = Новый Соответствие;
	яЗаголовкиHTTP.Вставить("Authorization", яПодключение.Авторизация);
	яЗаголовкиHTTP.Вставить("Content-Type", "application/json");
	яШифрование = Неопределено;
	Если яПодключение.Схема = "https" Тогда
		яШифрование = Новый ЗащищенноеСоединениеOpenSSL( неопределено, неопределено );
	КонецЕсли;
	яКоннект.Соединение = Новый HTTPСоединение(яПодключение.Сервер, яПодключение.Порт, , , , 60, яШифрование);
	яСсылкаНаРесурс = яПодключение.Путь + яДопПуть;
	яКоннект.Запрос = Новый HTTPЗапрос(яСсылкаНаРесурс, яЗаголовкиHTTP);
	Возврат яКоннект;
	
КонецФункции

Функция ПолучитьОбъектJIRA(яСервер, ИД, яИмя, яСоздать, яНаименование = "", яКод = Неопределено) Экспорт
	яЗ = Новый Запрос(
	"ВЫБРАТЬ
	|	спр.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ITC_Задача КАК спр
	|ГДЕ
	|	спр.JIRA = &JIRA
	|	И спр.JIRA_ID = &JIRA_ID");
	
	Если ЗначениеЗаполнено(яКод) Тогда
		яЗ.Текст =
		"ВЫБРАТЬ
		|	спр.Ссылка КАК Ссылка,
		|	1 КАК Порядок
		|ПОМЕСТИТЬ ВТ
		|ИЗ
		|	Справочник.ITC_Задача КАК спр
		|ГДЕ
		|	спр.JIRA = &JIRA
		|	И спр.JIRA_CODE = &JIRA_CODE
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	спр.Ссылка,
		|	2
		|ИЗ
		|	Справочник.ITC_Задача КАК спр
		|ГДЕ
		|	спр.JIRA = &JIRA
		|	И спр.JIRA_ID = &JIRA_ID
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ.Ссылка КАК Ссылка,
		|	ВТ.Порядок КАК Порядок
		|ИЗ
		|	ВТ КАК ВТ
		|
		|УПОРЯДОЧИТЬ ПО
		|	Порядок";
		яЗ.УстановитьПараметр("JIRA_CODE", яКод);
	КонецЕсли;
	яЗ.Текст = СтрЗаменить(яЗ.Текст, "ITC_Задача", яИмя);
	яЗ.УстановитьПараметр("JIRA", яСервер);
	яЗ.УстановитьПараметр("JIRA_ID", ИД);
	яВ = яЗ.Выполнить().Выбрать();
	Если яВ.Следующий() Тогда
		Возврат яВ.Ссылка;
	ИначеЕсли яСоздать Тогда
		Возврат СоздатьОбъектJIRA(яСервер, ИД, яИмя, яНаименование, яСоздать).Ссылка;
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

Функция СоздатьОбъектJIRA(яСервер, ИД, яИмя, яНаименование, яЗаписать = Ложь, яКод = Неопределено) Экспорт
	яОбъект = Справочники[яИмя].СоздатьЭлемент();
	яОбъект.JIRA = яСервер;
	яОбъект.JIRA_ID = ИД;
	Если ЗначениеЗаполнено(яКод) Тогда
		яОбъект.JIRA_CODE = яКод;
	КонецЕсли;
	Если ЗначениеЗаполнено(яНаименование) Тогда
		яОбъект.Наименование = яНаименование;
	КонецЕсли;
	Если яЗаписать Тогда
		яОбъект.Записать();
	КонецЕсли;
	Возврат яОбъект;
КонецФункции

#Область worklog

Функция ПолучитьЧасыПоЗадаче(яЗадача, яСервер, яКешСтруктура, яПодключение = Неопределено)
	
	яО = ITC.отвНовый(, "ITC.ПолучитьЧасыПоЗадаче");
	яСервер = яЗадача.JIRA;
	
	Если яПодключение = Неопределено Тогда
		яПодключение = ДанныеПодключения(яСервер);
	КонецЕсли;
	
	яКоннект = СоздатьЗапросИПодключение(яПодключение, "/issue/" + яЗадача.JIRA_ID + "/worklog");
	
	Попытка
		HTTPОтвет = яКоннект.Соединение.Получить(яКоннект.Запрос); //GET запрос
		яСтрокаОтвет = HTTPОтвет.ПолучитьТелоКакСтроку();
		
		Если HTTPОтвет.КодСостояния > 299 Тогда
			яОписаниеОшибки = "Код состояния: " + HTTPОтвет.КодСостояния + ". Данные не получены!";
		КонецЕсли;
	Исключение
		яОписаниеОшибки = "Ошибка при выполнении HTTP запроса: " + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;
	
	Если Не ПустаяСтрока(яОписаниеОшибки) Тогда
		ITC.отвЗадатьСтатус(яО, яОписаниеОшибки);
		ITC.отвЛогировать(яО);
		Возврат яО;
	КонецЕсли;
	
	Чтение = Новый ЧтениеJSON;
	Чтение.УстановитьСтроку(яСтрокаОтвет);
	ПолученныеДанные = ПрочитатьJSON(Чтение, Истина);
	Чтение.Закрыть();
	
	яТЗ = Новый ТаблицаЗначений;
	яТЗ.Колонки.Добавить("Ответственный", Новый ОписаниеТипов("СправочникСсылка.Пользователи"));
	яТЗ.Колонки.Добавить("Дата");
	яТЗ.Колонки.Добавить("Факт");
	яТЗ.Колонки.Добавить("Отчет");
	
	яМассивЗаписей = ПолученныеДанные.Получить("worklogs");
	Для Каждого яЗапись Из яМассивЗаписей Цикл
		яНов = яТЗ.Добавить();
		яАвтор = яЗапись["author"];
		яНов.Ответственный = НайтиСоздатьПользователя(яАвтор, яСервер, яКешСтруктура);
		яНов.Факт = ПолучитьЧисло(яЗапись["timeSpentSeconds"]) / 3600;
		яНов.Отчет = яНов.Факт;
		яНов.Дата = ПолучитьДату(яЗапись["started"]);
	КонецЦикла;
	
	яТЗОтв = яТЗ.Скопировать(, "Ответственный");
	яТЗОтв.Свернуть("Ответственный");
	яПоиск = Новый Структура("Ответственный");
	Для Каждого яС Из яТЗОтв Цикл
		ЗаполнитьЗначенияСвойств(яПоиск, яС);
		яВремяРаботы = яТЗ.НайтиСтроки(яПоиск);
		ЗаписатьЧасы(яЗадача.Ссылка, яС.Ответственный, яВремяРаботы);
	КонецЦикла;
	
	ОбнулитьЧасы(яЗадача.Ссылка, яТЗОтв);
	
	Возврат яО;
	
КонецФункции

Процедура ЗаписатьЧасы(яЗадача, яОтветственный, яВремяРаботы)
	
	яИД = "ВремяФакт";
	
	яФакт = 0;
	яОтчет = 0;
	Для Каждого яСтрока Из яВремяРаботы Цикл
		яФакт = яФакт + яСтрока.Факт;
		яОтчет = яОтчет + яСтрока.Отчет;
	КонецЦикла;
	
	яЗ = Новый Запрос;
	яЗ.УстановитьПараметр("ДокументОснование", яЗадача);
	яЗ.УстановитьПараметр("Ответственный", яОтветственный);
	яЗ.УстановитьПараметр("JIRA_ID", яИД);
	яЗ.Текст = 
	"ВЫБРАТЬ
	|	ВремяРабочееВремя.Ссылка КАК Ссылка,
	|	СУММА(ВремяРабочееВремя.Факт) КАК Факт,
	|	СУММА(ВремяРабочееВремя.Отчет) КАК Отчет
	|ИЗ
	|	Документ.РегистрацияВремени.РабочееВремя КАК ВремяРабочееВремя
	|ГДЕ
	|	ВремяРабочееВремя.Ссылка.JIRA_ID = &JIRA_ID
	|	И ВремяРабочееВремя.Ссылка.ДокументОснование = &ДокументОснование
	|	И ВремяРабочееВремя.Ссылка.Ответственный = &Ответственный
	|
	|СГРУППИРОВАТЬ ПО
	|	ВремяРабочееВремя.Ссылка";
	яРезЗап = яЗ.Выполнить();
	яВ = яРезЗап.Выбрать();
	Если яВ.Следующий() Тогда
		Если яВ.Факт = яФакт И яВ.Отчет = яОтчет Тогда
			Возврат;
		КонецЕсли;
		яВремя = яВ.Ссылка.ПолучитьОбъект();
	Иначе
		яВремя = Документы.РегистрацияВремени.СоздатьДокумент();
		яВремя.JIRA_ID = яИД;
		яВремя.ДокументОснование = яЗадача;
		яВремя.Дата = ТекущаяДатаСеанса();
		яВремя.Ответственный = яОтветственный;
	КонецЕсли;
	
	яВремя.РабочееВремя.Очистить();
	Для Каждого яСтрока Из яВремяРаботы Цикл
		яНов = яВремя.РабочееВремя.Добавить();
		ЗаполнитьЗначенияСвойств(яНов, яСтрока);
	КонецЦикла;
	яВремя.Записать(РежимЗаписиДокумента.Проведение, РежимПроведенияДокумента.Неоперативный);
	
КонецПроцедуры

Процедура ОбнулитьЧасы(яЗадача, яТЗОстающихся)
	
	яИД = "ВремяФакт";
	
	яЗ = Новый Запрос;
	яЗ.УстановитьПараметр("ТЗ", яТЗОстающихся);
	яЗ.УстановитьПараметр("ДокументОснование", яЗадача);
	яЗ.УстановитьПараметр("JIRA_ID", яИД);
	яЗ.Текст = 
	"ВЫБРАТЬ
	|	ТЗ.Ответственный КАК Ответственный
	|ПОМЕСТИТЬ ВТ_КогоОставить
	|ИЗ
	|	&ТЗ КАК ТЗ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РегистрацияВремени.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.РегистрацияВремени КАК РегистрацияВремени
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_КогоОставить КАК ВТ_КогоОставить
	|		ПО РегистрацияВремени.Ответственный = ВТ_КогоОставить.Ответственный
	|ГДЕ
	|	РегистрацияВремени.JIRA_ID = &JIRA_ID
	|	И РегистрацияВремени.Проведен
	|	И РегистрацияВремени.ДокументОснование = &ДокументОснование
	|	И ВТ_КогоОставить.Ответственный ЕСТЬ NULL";
	
	яРезЗап = яЗ.Выполнить();
	яВ = яРезЗап.Выбрать();
	Пока яВ.Следующий() Цикл
		яСпр = яВ.Ссылка.ПолучитьОбъект();
		яСпр.Записать(РежимЗаписиДокумента.ОтменаПроведения);
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область Кеш

Функция КешПоиск(яКешСтруктура, яИмяВКеше, яКлючВКеше)
	Если Не яКешСтруктура.Свойство(яИмяВКеше) Тогда
		яКешСтруктура.Вставить(яИмяВКеше, Новый Соответствие);
	КонецЕсли;
	
	Возврат яКешСтруктура[яИмяВКеше][яКлючВКеше];
КонецФункции

Функция КешЗапись(яЗначение, яКешСтруктура, яИмяВКеше, яКлючВКеше)
	яКешСтруктура[яИмяВКеше].Вставить(яКлючВКеше, яЗначение);
	Возврат яЗначение;
КонецФункции

#КонецОбласти


  
