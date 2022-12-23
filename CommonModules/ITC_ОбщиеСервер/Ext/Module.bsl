﻿Процедура УстановитьПараметрыСеанса() Экспорт
	
	//Попытка
	//яЗапрос = Новый Запрос(
	//"ВЫБРАТЬ
	//|	Пользователи.Ссылка КАК ТекущийПользователь,
	//|	Пользователи.РазрешенныеКлиенты.(
	//|		Клиент
	//|	)
	//|ИЗ
	//|	Справочник.Пользователи КАК Пользователи
	//|ГДЕ
	//|	Пользователи.Ссылка = &Ссылка");
	//яЗапрос.УстановитьПараметр("Ссылка", ПараметрыСеанса.ТекущийПользователь);
	//яВ = яЗапрос.Выполнить().Выбрать();
	//яМ = Новый Массив();
	//Если яВ.Следующий() Тогда
	//	//Разрешенные контрагенты
	//	яВКлиенты = яВ.РазрешенныеКлиенты.Выбрать();
	//	Пока яВКлиенты.Следующий() ЦИкл
	//		яМ.Добавить(яВКлиенты.Клиент);
	//	КонецЦикла;
	//КонецЕсли;
	//
	//ПараметрыСеанса.РазрешенныеКлиенты = Новый ФиксированныйМассив(яМ);
	//Исключение
	//
	//КонецПопытки;
КонецПроцедуры


Функция ПолучитьОбщийМакетНаСервере(ъИмя) Экспорт
	
	Возврат ПолучитьОбщийМакет(ъИмя);
	
КонецФункции




Функция УстановитьОтборНаСписок(ъСписок, ъИмяПоля, ъЗначение, ъВидСравнения = Неопределено) Экспорт
	Если ъВидСравнения = Неопределено Тогда
		ъВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	КонецЕсли;
	
	яОтбор = Неопределено;
	яПКД_Владелец = Новый ПолеКомпоновкиДанных(ъИмяПоля);
	Для Каждого яС Из ъСписок.Отбор.Элементы Цикл
		Если яС.ЛевоеЗначение = яПКД_Владелец Тогда
			яОтбор = яС;
		КонецЕсли;
	КонецЦикла;
	Если яОтбор = Неопределено Тогда
		яОтбор = ъСписок.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	КонецЕсли;
	яОтбор.ЛевоеЗначение = яПКД_Владелец;
	яОтбор.ВидСравнения = ъВидСравнения;
	яОтбор.Использование = Истина;
	яОтбор.ПравоеЗначение = ъЗначение;
КонецФункции


Процедура РегистрацияАктивностиДокумент(Источник, Отказ) Экспорт
	
	ЗарегистрироватьАктивность(ПараметрыСеанса.ТекущийПользователь, "ЗаписьДокумента", Источник);
	
КонецПроцедуры


Процедура ЗарегистрироватьАктивность(ъПользователь, ъТипАктивности, ъОписаниеАктивности = "") Экспорт
	
	яМЗ = РегистрыСведений.ITC_АктивностьПользователя.СоздатьМенеджерЗаписи();
	яМЗ.Пользователь = ъПользователь;
	яМЗ.Дата = ТекущаяДата();
	яМЗ.ТипАктивности = ъТипАктивности;
	яМЗ.ОписаниеАктивности = ъОписаниеАктивности;
	яМЗ.Записать(Истина);
	
КонецПроцедуры

Процедура ПроверкаАктивности() Экспорт
	
	Если Не РаботаСПочтовымиСообщениями.ПроверитьСистемнаяУчетнаяЗаписьДоступна() Тогда
		Возврат;
	КонецЕсли;
	
	яТД = ТекущаяДата();
	
	яЗ = Новый Запрос(
	"ВЫБРАТЬ
	|	Пользователи.Ссылка КАК Ссылка,
	|	Пользователи.Наименование КАК Наименование
	|ПОМЕСТИТЬ ВТ_Пользователи
	|ИЗ
	|	Справочник.Пользователи КАК Пользователи
	|ГДЕ
	|	НЕ Пользователи.Недействителен
	|	И НЕ Пользователи.ПометкаУдаления
	|	И Пользователи.РассылатьАктивность
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Пользователи.Ссылка КАК Ссылка,
	|	ПользователиКонтактнаяИнформация.АдресЭП КАК АдресЭП,
	|	ВТ_Пользователи.Наименование КАК Наименование
	|ПОМЕСТИТЬ ВТ_ПользователиСАдресом
	|ИЗ
	|	ВТ_Пользователи КАК ВТ_Пользователи
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Пользователи.КонтактнаяИнформация КАК ПользователиКонтактнаяИнформация
	|		ПО ВТ_Пользователи.Ссылка = ПользователиКонтактнаяИнформация.Ссылка
	|ГДЕ
	|	ПользователиКонтактнаяИнформация.Тип = &Тип
	|	И ПользователиКонтактнаяИнформация.АдресЭП <> """"
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТ_ПользователиСАдресом.Ссылка КАК Ссылка,
	|	ВТ_ПользователиСАдресом.АдресЭП КАК АдресЭП,
	|	ВТ_ПользователиСАдресом.Наименование КАК Наименование
	|ИЗ
	|	ВТ_ПользователиСАдресом КАК ВТ_ПользователиСАдресом
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ITC_АктивностьПользователя КАК ITC_АктивностьПользователя
	|		ПО ВТ_ПользователиСАдресом.Ссылка = ITC_АктивностьПользователя.Пользователь
	|			И (ITC_АктивностьПользователя.Дата >= &Дата)
	|ГДЕ
	|	ITC_АктивностьПользователя.Дата ЕСТЬ NULL");
	
	яЗ.УстановитьПараметр("Дата", НачалоДня(яТД));
	яЗ.УстановитьПараметр("Тип", Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
	
	
	яПараметры = Новый Структура;
	яПараметры.Вставить("Кому", Новый Массив);
	яПараметры.Вставить("ПолучателиСообщения", Новый Массив);
	яПараметры.Вставить("Копии", Новый Массив);
	яПараметры.Вставить("СкрытыеКопии", Новый Массив);
	яПараметры.Вставить("Тема", "Отсутствие активности");
	яПараметры.Вставить("Тело",
	"Привет.
	|Ты сегодня ничего не вносил в базу ОВ АРТ. Ты в отпуске или на больничном?");
	яПараметры.Вставить("Важность", ВажностьИнтернетПочтовогоСообщения.Наивысшая);
	яПараметры.Вставить("Вложения", Новый Массив);
	яПараметры.Вставить("ТипТекста", ТипТекстаПочтовогоСообщения.HTML);
	яПараметры.Вставить("Соединение", Справочники.УчетныеЗаписиЭлектроннойПочты.СистемнаяУчетнаяЗаписьЭлектроннойПочты);
	
	Если Час(яТД) < 17 Тогда
		
		яПараметры.Кому.Очистить();
		яПараметры.Кому.Добавить(Новый Структура("Адрес,Представление", "VKondakov@1cbit.ru", "Кондаков В."));
		яТекст = "";
		
		яНачалоПрошлогоДня = НачалоДня(НачалоДня(яТД) - 1);
		яЗ.УстановитьПараметр("Дата", яНачалоПрошлогоДня);
		яВ = яЗ.Выполнить().Выбрать();
		
		Если Не яВ.Количество() Тогда
			Возврат;
		КонецЕсли;
		
		Пока яВ.Следующий() Цикл
			яТекст = яТекст + яВ.Наименование + Символы.ПС;
		КонецЦикла;
		яТекст =
		"Список тех, кто вчера (" + Формат(яНачалоПрошлогоДня, "ДФ=yyyy-MM-dd") + ") не проявлял активности в БД:
		|" + яТекст + "
		|Вроде бы всех учёл.
		|P.S. Я старался, с Любовью, ИИ.";
		
		яПараметры.Вставить("Тело", яТекст);
		яРез = РаботаСПочтовымиСообщениями.ОтправитьПочтовоеСообщение(Справочники.УчетныеЗаписиЭлектроннойПочты.СистемнаяУчетнаяЗаписьЭлектроннойПочты
		, яПараметры);
		
	Иначе
		яВ = яЗ.Выполнить().Выбрать();
		
		Пока яВ.Следующий() Цикл
			
			яПараметры.Кому.Очистить();
			яПараметры.Кому.Добавить(Новый Структура("Адрес,Представление", яВ.АдресЭП, яВ.Наименование));
			
			яРез = РаботаСПочтовымиСообщениями.ОтправитьПочтовоеСообщение(Справочники.УчетныеЗаписиЭлектроннойПочты.СистемнаяУчетнаяЗаписьЭлектроннойПочты
			, яПараметры);
			
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// Процедура - Распределить на наряды.
// Заменяет часы отчёт на заданные равномерно на указанные наряды пропорционально часам факт.
//
// Параметры:
//  ъМассивНарядов	 - Массив	 - 
//  ъВеличина		 - Число	 - 
//
Процедура РаспределитьНаНаряды(ъМассивНарядов, ъВеличина) Экспорт
	яЗ = Новый Запрос(
	"ВЫБРАТЬ
	|	Наряд.Ссылка КАК Ссылка,
	|	Наряд.ДокументОснование КАК ДокументОснование
	|ПОМЕСТИТЬ ВТ_Наряды
	|ИЗ
	|	Документ.Наряд КАК Наряд
	|ГДЕ
	|	Наряд.Ссылка В(&Ссылка)
	|	И Наряд.Проведен
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Наряды.Ссылка КАК Ссылка
	|ИЗ
	|	ВТ_Наряды КАК ВТ_Наряды
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СУММА(НарядРабочееВремя.Факт) КАК Факт,
	|	НарядРабочееВремя.Ссылка КАК Ссылка,
	|	ВТ_Наряды.ДокументОснование КАК ДокументОснование
	|ИЗ
	|	ВТ_Наряды КАК ВТ_Наряды
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Наряд.РабочееВремя КАК НарядРабочееВремя
	|		ПО ВТ_Наряды.Ссылка = НарядРабочееВремя.Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_Наряды.ДокументОснование,
	|	НарядРабочееВремя.Ссылка
	|ИТОГИ
	|	СУММА(Факт)
	|ПО
	|	ДокументОснование");
	яЗ.УстановитьПараметр("Ссылка", ъМассивНарядов);
	яПакет = яЗ.ВыполнитьПакет();
	яКол = яПакет.Количество();
	яВОбращения = яПакет[яКол - 1].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "ДокументОснование");
	
	НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);
	
	яБлокировка = Новый БлокировкаДанных;
	яЭлемент = яБлокировка.Добавить("Документ.Наряд");
	яЭлемент.ИсточникДанных = яПакет[яКол - 2].Выгрузить();
	яЭлемент.Режим = РежимБлокировкиДанных.Исключительный;
	яЭлемент.ИспользоватьИзИсточникаДанных("Ссылка", "Ссылка");
	яБлокировка.Заблокировать();
	
	Пока яВОбращения.Следующий() Цикл
		Если яВОбращения.Факт = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		
		яОстаток = ъВеличина;
		яКоэффициент = ъВеличина / яВОбращения.Факт;
		яВНаряды = яВОбращения.Выбрать();
		й = 0;
		Пока яВНаряды.Следующий() Цикл
			й = й + 1;
			яНаряд = яВНаряды.Ссылка.ПолучитьОбъект();
			Для Каждого яС Из яНаряд.РабочееВремя Цикл
				яС.Отчет = яС.Факт * яКоэффициент;
				яОстаток = яОстаток - яС.Отчет;
			КонецЦикла;
			Если й = яВНаряды.Количество() И яОстаток <> 0 Тогда
				яС.Отчет = яС.Отчет + яОстаток;
			КонецЕсли;
			яНаряд.Записать(РежимЗаписиДокумента.Проведение);
		КонецЦикла;
	КонецЦикла;
	ЗафиксироватьТранзакцию();
	
	
КонецПроцедуры


Функция СтавкиЧаса(Клиент) Экспорт
	
	Ставки = Новый Структура();
	Ставки.Вставить("Ставка", 0);
	Ставки.Вставить("СтавкаБезНДС", 0);
	
	Если ЗначениеЗаполнено(Клиент) тогда
		Ставки.Ставка = Клиент.СтавкаЧаса;
		Ставки.СтавкаБезНДС = Клиент.СтавкаЧасаБезНДС;
	КонецЕсли;
	
	Возврат Ставки;
КонецФункции

// Процедура - Проверить заполнить автора документа
//
// Параметры:
//  ъРеквизит	 - СправочникСсылка.Пользователи	 - Реквизит документа, где хранится автор
//
Процедура ПроверитьЗаполнитьАвтора(ъРеквизит) Экспорт
	Если Не ЗначениеЗаполнено(ъРеквизит) Тогда
		ъРеквизит = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;
КонецПроцедуры