﻿Функция Main(яЗапросHTTP, яОтветHTTP) Экспорт
	яКоманда = яЗапросHTTP.ПараметрыЗапроса.Получить("command");
	яПараметры = Новый Структура;
	яПараметры.Вставить("user", яЗапросHTTP.ПараметрыЗапроса.Получить("user"));
	яПараметры.Вставить("key", яЗапросHTTP.ПараметрыЗапроса.Получить("key"));
	яПараметры.Вставить("session", яЗапросHTTP.ПараметрыЗапроса.Получить("session"));
	яПараметры.Вставить("salt", яЗапросHTTP.ПараметрыЗапроса.Получить("salt"));
	
	яПараметры.Вставить("conf", яЗапросHTTP.ПараметрыЗапроса.Получить("conf"));
	яПараметры.Вставить("ver", яЗапросHTTP.ПараметрыЗапроса.Получить("ver"));
	
	
	Если яКоманда = "auth" Тогда
	    Команда_ЗапросАвторизации_start(яОтветHTTP, яПараметры);
		Возврат яОтветHTTP;
	ИначеЕсли яКоманда = "auth_finish" Тогда
	    Команда_ЗапросАвторизации_finish(яОтветHTTP, яПараметры);
		Возврат яОтветHTTP;
	ИначеЕсли НЕ ДанныеСессии(яПараметры).Успех Тогда
		яДанные = Новый Структура("description"
		, "Время сессии истекло, необходима авторизация.");
		ITC_HTTPСервер.УстановитьТелоОтветаJSON(яОтветHTTP, яДанные, 408);
		Возврат яОтветHTTP;
	КонецЕсли;	
	
	
	Если яКоманда = "get_packets_list" Тогда //список пакетов
		Команда_ЗапросСпискаПакетов(яОтветHTTP, яПараметры);
	ИначеЕсли яКоманда = "get_packet" Тогда //список детальных данных по пакету (поддерживаемые конфигурации и версии)
		яПараметры.Вставить("id", яЗапросHTTP.ПараметрыЗапроса.Получить("id"));
		Команда_ЗапросОписанияПакета(яОтветHTTP, яПараметры);
	ИначеЕсли яКоманда = "get_packet_data" Тогда //список детальных данных по пакету (поддерживаемые конфигурации и версии)
		яПараметры.Вставить("id", яЗапросHTTP.ПараметрыЗапроса.Получить("id"));
		яПараметры.Вставить("ver_id", яЗапросHTTP.ПараметрыЗапроса.Получить("ver_id"));
		Команда_ЗапросДанныхПакета(яОтветHTTP, яПараметры);
	Иначе
		яДанные = Новый Структура("description"
		, "Команда не распознана.");
		ITC_HTTPСервер.УстановитьТелоОтветаJSON(яОтветHTTP, яДанные, 405);
	КонецЕсли;	
	
	
	Возврат яОтветHTTP;
КонецФункции

Функция ДанныеСессии(яПараметры)
	яО = ITC.Ответ_СформироватьСтруктуру();
	
	яЗ = Новый Запрос(
	"ВЫБРАТЬ
	|	ICMP_УдалённыеСессии.Пользователь КАК Пользователь
	|ИЗ
	|	РегистрСведений.ICMP_УдалённыеСессии КАК ICMP_УдалённыеСессии
	|ГДЕ
	|	ICMP_УдалённыеСессии.Идентификатор = &Идентификатор
	|	И ICMP_УдалённыеСессии.СрокЖизни > &СрокЖизни");
	яЗ.УстановитьПараметр("Идентификатор", Строка(яПараметры.session));
	яЗ.УстановитьПараметр("СрокЖизни", ТекущаяДата());
	яРезЗап = яЗ.Выполнить();
	яВ = яРезЗап.Выбрать();
	Если яВ.Следующий() Тогда
		яПараметры.Вставить("Пользователь", яВ.Пользователь);
	Иначе
		ITC.Ответ_УстановитьСтатус(яО);
	КонецЕсли;
	
	Возврат яО;
КонецФункции

Функция Команда_ЗапросАвторизации_НайтиПользователя(user)
	яО = ITC.Ответ_СформироватьСтруктуру("Пароль,Ссылка,Наименование");
	
	яЗ = Новый Запрос(
	"ВЫБРАТЬ
	|	ICMP_Пользователь.Пароль КАК Пароль,
	|	ICMP_Пользователь.Наименование КАК Наименование,
	|	ICMP_Пользователь.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ICMP_Пользователь КАК ICMP_Пользователь
	|ГДЕ
	|	ICMP_Пользователь.Логин = &Логин");
	яЗ.УстановитьПараметр("Логин", user);
	яРезЗап = яЗ.Выполнить();
	яВ = яРезЗап.Выбрать();
	Если яВ.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(яО, яВ);
	Иначе
		ITC.Ответ_УстановитьСтатус(яО);
	КонецЕсли;
	
	Возврат яО;
КонецФункции

Процедура Команда_ЗапросАвторизации_start(яОтветHTTP, яПараметры)
	яДанныеПользователя = Команда_ЗапросАвторизации_НайтиПользователя(яПараметры.user);
	яОшибкаАвторизации = "Такой пользователь не найден или пароль неверный.";
	Если НЕ яДанныеПользователя.Успех Тогда
		яДанные = Новый Структура("description"
		, яОшибкаАвторизации);
		ITC_HTTPСервер.УстановитьТелоОтветаJSON(яОтветHTTP, яДанные, 401);
		Возврат;
	КонецЕсли;
	
	яДанные = Новый Структура("salt",
	Строка(Новый УникальныйИдентификатор));
	
	яМЗ = РегистрыСведений.ICMP_УдалённыеСессии.СоздатьМенеджерЗаписи();
	яМЗ.Пользователь = яДанныеПользователя.Ссылка;
	яМЗ.Соль = яДанные.salt;
	яМЗ.СрокЖизни = ТекущаяДата() + 3600;
	яМЗ.Записать(Истина);
	
	ITC_HTTPСервер.УстановитьТелоОтветаJSON(яОтветHTTP, яДанные, 200);
КонецПроцедуры

Процедура Команда_ЗапросАвторизации_finish(яОтветHTTP, яПараметры)
	Если яПараметры.salt = Неопределено ИЛИ ПустаяСтрока(яПараметры.salt) Тогда
		яДанные = Новый Структура("description",
		"Не указана соль пароля.");
		ITC_HTTPСервер.УстановитьТелоОтветаJSON(яОтветHTTP, яДанные, 400);
		Возврат;
	КонецЕсли;
	
	яДанныеПользователя = Команда_ЗапросАвторизации_НайтиПользователя(яПараметры.user);
	яОшибкаАвторизации = "Такой пользователь не найден или пароль неверный.";
	Если НЕ яДанныеПользователя.Успех Тогда
		яДанные = Новый Структура("description"
		, яОшибкаАвторизации);
		ITC_HTTPСервер.УстановитьТелоОтветаJSON(яОтветHTTP, яДанные, 401);
		Возврат;
	КонецЕсли;
	
	яМЗ = РегистрыСведений.ICMP_УдалённыеСессии.СоздатьМенеджерЗаписи();
	яМЗ.Пользователь = яДанныеПользователя.Ссылка;
	яМЗ.Соль = яПараметры.salt;
	яМЗ.Прочитать();
	Если Не яМЗ.Выбран() Или яМЗ.СрокЖизни < ТекущаяДата() Тогда
		яДанные = Новый Структура("description"
		, "Параметры данной авторизации не актуальны.");
		ITC_HTTPСервер.УстановитьТелоОтветаJSON(яОтветHTTP, яДанные, 401);
		Возврат;
	КонецЕсли;
	
	яХФ = Новый ХешированиеДанных(ХешФункция.SHA256);
	яХФ.Добавить(яДанныеПользователя.Пароль);
	яХФ.Добавить(яПараметры.salt);
	яХешСумма = ПреобразоватьХешКСтроке(яХФ.ХешСумма);
	
	Если яПараметры.key <> яХешСумма Тогда
		яДанные = Новый Структура("description"
		, яОшибкаАвторизации);
		ITC_HTTPСервер.УстановитьТелоОтветаJSON(яОтветHTTP, яДанные, 401);
		Возврат;
	КонецЕсли;
	
	яДанные = Новый Структура("session",
	Строка(Новый УникальныйИдентификатор));
	яМЗ.Идентификатор = яДанные.session;
	яМЗ.Записать(Истина);
	
	ITC_HTTPСервер.УстановитьТелоОтветаJSON(яОтветHTTP, яДанные, 200);
КонецПроцедуры

Функция ВернутьОписаниеОшибки(яОтветHTTP, яОшибка, яКодВозврата = 400)
	яДанныеОшибки = Новый Структура("description"
	, яОшибка);
	
	ITC_HTTPСервер.УстановитьТелоОтветаJSON(яОтветHTTP, яДанныеОшибки, яКодВозврата);
	Возврат Ложь;
КонецФункции

Функция ВернутьОписаниеИсключения(яОтветHTTP, яОшибка, яИмяВЛогах, яКодВозврата = 500)
	яО = ITC.Ответ_СформироватьСтруктуру(, яИмяВЛогах);
	ITC.Ответ_УстановитьСтатус(яО, яОшибка);
	ITC.Ответ_ЛогироватьСообщения(яО);
	
	Возврат ВернутьОписаниеОшибки(яОтветHTTP, яОшибка, яКодВозврата);
	
	Возврат яО;
КонецФункции

#Область Экспортные_функции

Функция ПреобразоватьХешКСтроке(яДвоичныеДанные) Экспорт

	Возврат СтрЗаменить(НРег(яДвоичныеДанные), " ", "");

КонецФункции

#КонецОбласти

#Область Команда_Список_пакетов

Процедура ЗаполнитьПоСоответствию(яЦель, яИсточник, яСоответствие)
	Для Каждого яС Из яСоответствие Цикл
		Если ЗначениеЗаполнено(яС.Значение) Тогда
			яЦель[яС.Ключ] = яИсточник[яС.Значение];
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Функция СоздатьСтруктуруПоКлючам(яСоответствие, яТолькоСоЗначением = Ложь)
	яРез = Новый Массив;
	Для Каждого яС Из яСоответствие Цикл
		Если НЕ яТолькоСоЗначением ИЛИ ЗначениеЗаполнено(яС.Значение) Тогда
			яРез.Добавить(яС.Ключ);
		КонецЕсли;
	КонецЦикла;
	Возврат Новый Структура(СтрСоединить(яРез, ","))
КонецФункции

Функция ТекстЗапроса_ДоступныеПакетыПользователя()
	
	Возврат
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ICMP_ПользовательПрофилиДоступа.Профиль КАК Профиль
	|ПОМЕСТИТЬ ВТ_Профили
	|ИЗ
	|	Справочник.ICMP_Пользователь.ПрофилиДоступа КАК ICMP_ПользовательПрофилиДоступа
	|ГДЕ
	|	ICMP_ПользовательПрофилиДоступа.Ссылка = &Пользователь
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ICMP_ПрофильДоступаДоступныеПакеты.Пакет КАК Пакет,
	|	МАКСИМУМ(ICMP_ПрофильДоступаДоступныеПакеты.Автоустановка) КАК Автоустановка,
	|	МАКСИМУМ(ICMP_ПрофильДоступаДоступныеПакеты.Автообновление) КАК Автообновление
	|ПОМЕСТИТЬ ВТ_Пакеты
	|ИЗ
	|	ВТ_Профили КАК ВТ_Профили
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ICMP_ПрофильДоступа.ДоступныеПакеты КАК ICMP_ПрофильДоступаДоступныеПакеты
	|		ПО ВТ_Профили.Профиль = ICMP_ПрофильДоступаДоступныеПакеты.Ссылка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ICMP_ПрофильДоступа КАК ICMP_ПрофильДоступа
	|		ПО ВТ_Профили.Профиль = ICMP_ПрофильДоступа.Ссылка
	|			И (НЕ ВТ_Профили.Профиль.ПометкаУдаления)
	|
	|СГРУППИРОВАТЬ ПО
	|	ICMP_ПрофильДоступаДоступныеПакеты.Пакет"
	
КонецФункции

Функция ОписаниеСтруктурыПакета()
	Возврат Новый Структура("id,name,description,autoinstall,autoupdate", "Идентификатор", "Наименование", "Описание", "Автоустановка", "Автообновление")
КонецФункции

Процедура Команда_ЗапросСпискаПакетов(яОтветHTTP, яПараметры)
	
	яЗ = Новый Запрос;
	яЗ.Текст = ТекстЗапроса_ДоступныеПакетыПользователя() + ";" +
	"ВЫБРАТЬ
	|	ВТ_Пакеты.Пакет КАК Пакет,
	|	ВТ_Пакеты.Автоустановка КАК Автоустановка,
	|	ВТ_Пакеты.Автообновление КАК Автообновление,
	|	ICMP_Пакет.Наименование КАК Наименование,
	|	ICMP_Пакет.Описание КАК Описание,
	|	ICMP_Пакет.Идентификатор КАК Идентификатор
	|ИЗ
	|	ВТ_Пакеты КАК ВТ_Пакеты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ICMP_Пакет КАК ICMP_Пакет
	|		ПО ВТ_Пакеты.Пакет = ICMP_Пакет.Ссылка";
	яЗ.УстановитьПараметр("Пользователь", яПараметры.Пользователь);
	яРезЗап = яЗ.Выполнить();
	яВ = яРезЗап.Выбрать();
	
	яДанные = Новый Структура("packets", Новый Массив);
	яСтрПакет = ОписаниеСтруктурыПакета();
	Пока яВ.Следующий() Цикл
		яС = СоздатьСтруктуруПоКлючам(яСтрПакет);
		ЗаполнитьПоСоответствию(яС, яВ, яСтрПакет);
		яДанные.packets.Добавить(яС);
	КонецЦикла;
	
	ITC_HTTPСервер.УстановитьТелоОтветаJSON(яОтветHTTP, яДанные);
	
КонецПроцедуры

#КонецОбласти

#Область Команда_Описание_пакета

Функция ОписаниеВерсииПакета()
	Возврат Новый Структура("id,name,configs", "ИДВерсии", "НаименованиеВерсии")
КонецФункции

Функция ОписаниеКонфигурации()
	Возврат Новый Структура("name,version", "НаименованиеКонфигурации", "ВерсияКонфигурации")
КонецФункции

Функция Команда_ЗапросОписанияПакета(яОтветHTTP, яПараметры)
	
	Попытка
	
		Если яПараметры.id = Неопределено Тогда
			Возврат ВернутьОписаниеОшибки(яОтветHTTP, "Не указан идентификатор пакета.")
		КонецЕсли;
		
		яЗ = Новый Запрос;
		яЗ.Текст = ТекстЗапроса_ДоступныеПакетыПользователя() + ";" +
		"ВЫБРАТЬ
		|	ВТ_Пакеты.Пакет КАК Пакет,
		|	ВТ_Пакеты.Автоустановка КАК Автоустановка,
		|	ВТ_Пакеты.Автообновление КАК Автообновление,
		|	ICMP_Пакет.Наименование КАК Наименование,
		|	ICMP_Пакет.Описание КАК Описание,
		|	ICMP_Пакет.Идентификатор КАК Идентификатор,
		|	ICMP_ВерсииПакета.Ссылка КАК Версия,
		|	ICMP_ВерсииПакета.Код КАК Код,
		|	ICMP_ВерсииПакета.Наименование КАК НаименованиеВерсии,
		|	ICMP_ВерсииПакетаКонфигурации.ВерсияКонфигурации КАК ВерсияКонфигурации,
		|	ICMP_ВерсииПакетаКонфигурации.Конфигурация.Наименование КАК НаименованиеКонфигурации,
		|	ICMP_ВерсииПакета.Версия КАК ИДВерсии
		|ИЗ
		|	ВТ_Пакеты КАК ВТ_Пакеты
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ICMP_Пакет КАК ICMP_Пакет
		|		ПО ВТ_Пакеты.Пакет = ICMP_Пакет.Ссылка
		|			И (ICMP_Пакет.Идентификатор = &Идентификатор)
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ICMP_ВерсииПакета КАК ICMP_ВерсииПакета
		|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ICMP_ВерсииПакета.ПредназначенныеКонфигурации КАК ICMP_ВерсииПакетаКонфигурации
		|			ПО ICMP_ВерсииПакета.Ссылка = ICMP_ВерсииПакетаКонфигурации.Ссылка
		|		ПО ВТ_Пакеты.Пакет = ICMP_ВерсииПакета.Владелец
		|			И (НЕ ICMP_ВерсииПакета.ПометкаУдаления)
		|ИТОГИ ПО
		|	Версия";
		яЗ.УстановитьПараметр("Пользователь", яПараметры.Пользователь);
		яЗ.УстановитьПараметр("Идентификатор", яПараметры.id);
		
		яРез = яЗ.Выполнить();
		Если яРез.Пустой() Тогда
			Возврат ВернутьОписаниеОшибки(яОтветHTTP, "Пакет не найден или недоступен пользователю.")
		КонецЕсли;
		
		яВыб = яРез.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Версия");
		
		яПервый = Истина;
		яСтрВерсия = ОписаниеВерсииПакета();
		яСтрКонф = ОписаниеКонфигурации();
		яСтрПакет = ОписаниеСтруктурыПакета();
		яДанные = СоздатьСтруктуруПоКлючам(яСтрПакет);
		яДанные.Вставить("versions", Новый Массив);

		Пока яВыб.Следующий() Цикл
			яВерсия = СоздатьСтруктуруПоКлючам(яСтрВерсия);
			яВерсия.configs = Новый Массив;
			яДанные.versions.Добавить(яВерсия);
			ЗаполнитьПоСоответствию(яВерсия, яВыб, яСтрВерсия);
			
			яВ = яВыб.Выбрать();
			Пока яВ.Следующий() Цикл
				Если яПервый Тогда
					яПервый = Ложь;
					ЗаполнитьПоСоответствию(яДанные, яВ, яСтрПакет);
				КонецЕсли;
				яКонф = СоздатьСтруктуруПоКлючам(яСтрКонф);
				яВерсия.configs.Добавить(яКонф);
				ЗаполнитьПоСоответствию(яКонф, яВ, яСтрКонф);
			КонецЦикла;
		КонецЦикла;
		
		ITC_HTTPСервер.УстановитьТелоОтветаJSON(яОтветHTTP, яДанные);
	Исключение
		Возврат ВернутьОписаниеИсключения(яОтветHTTP, ОписаниеОшибки(), "ICMP.get_packet")
	КонецПопытки
	
КонецФункции

#КонецОбласти

#Область Команда_Данные_пакета

Функция Команда_ЗапросДанныхПакета(яОтветHTTP, яПараметры)
	
	Попытка
		
		Если яПараметры.id = Неопределено Тогда
			Возврат ВернутьОписаниеОшибки(яОтветHTTP, "Не указан идентификатор пакета.");
		КонецЕсли;
		Если яПараметры.ver_id = Неопределено Тогда
			Возврат ВернутьОписаниеОшибки(яОтветHTTP, "Не указан идентификатор версии пакета.");
		КонецЕсли;
		
		яЗ = Новый Запрос;
		яЗ.Текст = ТекстЗапроса_ДоступныеПакетыПользователя() + ";" +
		"ВЫБРАТЬ
		|	ICMP_ВерсииПакета.Ссылка КАК Версия,
		|	ICMP_ВерсииПакета.Код КАК ИДВерсии,
		|	ICMP_ВерсииПакета.Наименование КАК НаименованиеВерсии,
		|	ICMP_ВерсииПакета.Содержимое КАК Содержимое,
		|	ICMP_ВерсииПакета.ИмяФайлаОбработки КАК ИмяФайлаОбработки
		|ИЗ
		|	ВТ_Пакеты КАК ВТ_Пакеты
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ICMP_Пакет КАК ICMP_Пакет
		|		ПО ВТ_Пакеты.Пакет = ICMP_Пакет.Ссылка
		|			И (ICMP_Пакет.Идентификатор = &Идентификатор)
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ICMP_ВерсииПакета КАК ICMP_ВерсииПакета
		|		ПО ВТ_Пакеты.Пакет = ICMP_ВерсииПакета.Владелец
		|			И (НЕ ICMP_ВерсииПакета.ПометкаУдаления)
		|			И (&КодВерсии = ICMP_ВерсииПакета.Версия)";
		яЗ.УстановитьПараметр("Пользователь", яПараметры.Пользователь);
		яЗ.УстановитьПараметр("Идентификатор", яПараметры.id);
		яЗ.УстановитьПараметр("КодВерсии", яПараметры.ver_id);
		
		яРез = яЗ.Выполнить();
		Если яРез.Пустой() Тогда
			Возврат ВернутьОписаниеОшибки(яОтветHTTP, "Версия пакета не найдена или недоступна пользователю.")
		КонецЕсли;
		
		яВыб = яРез.Выбрать();
		
		яСтрВерсия = ОписаниеВерсииПакета();
		яСтрВерсия.Вставить("filename", "ИмяФайлаОбработки");
		яДанные = СоздатьСтруктуруПоКлючам(яСтрВерсия);
		
		Пока яВыб.Следующий() Цикл
			ЗаполнитьПоСоответствию(яДанные, яВыб, яСтрВерсия);
			яДанныеПакета = Base64Строка(яВыб.Содержимое.Получить());
			яДанные.Вставить("filedata", яДанныеПакета);
		КонецЦикла;
		
		ITC_HTTPСервер.УстановитьТелоОтветаJSON(яОтветHTTP, яДанные);
	Исключение
		Возврат ВернутьОписаниеИсключения(яОтветHTTP, ОписаниеОшибки(), "ICMP.get_packet_data")
	КонецПопытки
	
КонецФункции

#КонецОбласти