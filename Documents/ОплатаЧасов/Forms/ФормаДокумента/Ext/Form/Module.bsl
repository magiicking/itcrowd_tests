﻿// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
    ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры
&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
    ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура ОплачиваемыеЗаданияКоличествоПриИзменении(Элемент)
	ТабличныеЧастиКлиент.РассчитатьСуммуСтроки(Элементы.ОплачиваемыеЗадания.ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура ОплачиваемыеЗаданияЦенаПриИзменении(Элемент)
	ТабличныеЧастиКлиент.РассчитатьСуммуСтроки(Элементы.ОплачиваемыеЗадания.ТекущиеДанные);
	УстановитьСуммуДокумента();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОстаткамиЧасовНаСервере()
	яЗ = Новый Запрос(
	"ВЫБРАТЬ
	|	СтавкиСотрудниковСрезПоследних.Сотрудник КАК Сотрудник,
	|	СтавкиСотрудниковСрезПоследних.Ставка КАК Ставка,
	|	СтавкиСотрудниковСрезПоследних.СхемаМотивации КАК СхемаМотивации
	|ПОМЕСТИТЬ ВТ_СМ
	|ИЗ
	|	РегистрСведений.СтавкиСотрудников.СрезПоследних(&Период, ) КАК СтавкиСотрудниковСрезПоследних
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Сотрудник
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РабочееВремяОстатки.Ответственный КАК Ответственный,
	|	РабочееВремяОстатки.Задача КАК Документ,
	|	РабочееВремяОстатки.ОтчетОстаток КАК Количество
	|ПОМЕСТИТЬ ВТ_Остатки
	|ИЗ
	|	РегистрНакопления.Трудозатраты.Остатки(
	|			&Период,
	|			ВЫБОР
	|					КОГДА Задача.Родитель.Релиз ЕСТЬ NULL
	|						ТОГДА ИСТИНА
	|					ИНАЧЕ Задача.Родитель.Статус.Состояние = &Состояние
	|				КОНЕЦ
	|				И Задача.Статус.Состояние = &Состояние) КАК РабочееВремяОстатки
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	РабочееВремяОстатки.Ответственный,
	|	РабочееВремяОстатки.Задача,
	|	РабочееВремяОстатки.ОтчетОстаток
	|ИЗ
	|	РегистрНакопления.Трудозатраты.Остатки(
	|			&Период,
	|			Ответственный В
	|				(ВЫБРАТЬ
	|					ВТ_СМ.Сотрудник КАК Сотрудник
	|				ИЗ
	|					ВТ_СМ КАК ВТ_СМ
	|				ГДЕ
	|					ВТ_СМ.СхемаМотивации = ЗНАЧЕНИЕ(Перечисление.ДВП_СхемаМотивации.ПоФакту))) КАК РабочееВремяОстатки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Остатки.Ответственный КАК Ответственный,
	|	ВТ_Остатки.Документ КАК Документ,
	|	СУММА(ВТ_Остатки.Количество) КАК Количество
	|ПОМЕСТИТЬ ВТ_ОстаткиСгруп
	|ИЗ
	|	ВТ_Остатки КАК ВТ_Остатки
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_Остатки.Ответственный,
	|	ВТ_Остатки.Документ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ОстаткиСгруп.Документ КАК Документ,
	|	ВТ_ОстаткиСгруп.Ответственный КАК Ответственный,
	|	ВТ_ОстаткиСгруп.Количество КАК Количество,
	|	ЕСТЬNULL(ВТ_СМ.Ставка, 0) КАК Цена,
	|	ЕСТЬNULL(ВТ_СМ.Ставка, 0) * ВТ_ОстаткиСгруп.Количество КАК Сумма
	|ИЗ
	|	ВТ_ОстаткиСгруп КАК ВТ_ОстаткиСгруп
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_СМ КАК ВТ_СМ
	|		ПО ВТ_ОстаткиСгруп.Ответственный = ВТ_СМ.Сотрудник
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ответственный,
	|	Документ");
	яДатаОстатков = ?(ЗначениеЗаполнено(Объект.Дата), Объект.Дата, ТекущаяДатаСеанса());
	яЗ.УстановитьПараметр("Период", КонецДня(яДатаОстатков));
	яЗ.УстановитьПараметр("Состояние", Перечисления.ITC_СостоянияЗадач.Завершена);
	яВ = яЗ.Выполнить().Выбрать();
	Объект.ОплачиваемыеЗадания.Очистить();
	Пока яВ.Следующий() Цикл
		яНов = Объект.ОплачиваемыеЗадания.Добавить();
		ЗаполнитьЗначенияСвойств(яНов, яВ);
	КонецЦикла;
	Объект.КоличествоЧасов = Объект.ОплачиваемыеЗадания.Итог("Количество");
	Объект.СуммаДокумента = Объект.ОплачиваемыеЗадания.Итог("Сумма");
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьОстаткамиЧасов(Команда)
	ЗаполнитьОстаткамиЧасовНаСервере();
	
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСуммуДокумента()
	Объект.СуммаДокумента = Объект.ОплачиваемыеЗадания.Итог("Сумма");
	Объект.КоличествоЧасов = Объект.ОплачиваемыеЗадания.Итог("Количество");
КонецПроцедуры

&НаКлиенте
Процедура ОплачиваемыеЗаданияСуммаПриИзменении(Элемент)
	УстановитьСуммуДокумента();
КонецПроцедуры

&НаКлиенте
Процедура ОплачиваемыеЗаданияПриИзменении(Элемент)
	УстановитьСуммуДокумента();
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьИмяФайла(Команда)
	яО = ITC_ФайлыКлиент.ПолучитьИмяФайла(Объект.Ссылка, Ложь);
	
	Если яО.Успех Тогда
		ВывестиВБуферОбмена(яО.Данные);
	Иначе
		ITC.Ответ_ВывестиСообщенияПользователю(яО);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСписокРабот(Команда)
	яМ = Новый Массив;
	яФС = "ЧГ=";
	Для Каждого яС Из Объект.ОплачиваемыеЗадания Цикл
		яМ.Добавить(Строка(яС.Документ) + " - " + Формат(яС.Количество, яФС) + "ч.");
	КонецЦикла;
	ВывестиВБуферОбмена(СтрСоединить(яМ, "; "));
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	Если Не ЗначениеЗаполнено(Объект.Ответственный) Тогда
		Объект.Ответственный = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Дата) Тогда
		Объект.Дата = ТекущаяДатаСеанса();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ЧасыОчистить(Команда)
	Объект.ОплачиваемыеЗадания.Очистить();
КонецПроцедуры

#Область Интеграция_с_К7 

&НаСервере
Функция РаботыК7НаСервере()
	яО = ITC.Ответ_СформироватьСтруктуру();
	
	яЗ = Новый Запрос(
	"ВЫБРАТЬ
	|	ОплатаЧасовОплачиваемыеЗадания.Ответственный КАК Ответственный,
	|	СУММА(ОплатаЧасовОплачиваемыеЗадания.Количество) КАК Количество,
	|	СУММА(ОплатаЧасовОплачиваемыеЗадания.Сумма) КАК Сумма
	|ПОМЕСТИТЬ ВТ_Часы
	|ИЗ
	|	Документ.ОплатаЧасов.ОплачиваемыеЗадания КАК ОплатаЧасовОплачиваемыеЗадания
	|ГДЕ
	|	ОплатаЧасовОплачиваемыеЗадания.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ОплатаЧасовОплачиваемыеЗадания.Ответственный
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПользователиКонтактнаяИнформация.Ссылка КАК Пользователь,
	|	ПользователиКонтактнаяИнформация.АдресЭП КАК АдресЭП
	|ПОМЕСТИТЬ ВТ_КИ
	|ИЗ
	|	Справочник.Пользователи.КонтактнаяИнформация КАК ПользователиКонтактнаяИнформация
	|ГДЕ
	|	ПользователиКонтактнаяИнформация.Тип = &Тип
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Пользователь
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Часы.Количество КАК Количество,
	|	ВЫБОР
	|		КОГДА ВТ_Часы.Количество = 0
	|			ТОГДА 0
	|		ИНАЧЕ ВЫРАЗИТЬ(ВТ_Часы.Сумма / ВТ_Часы.Количество КАК ЧИСЛО(15, 2))
	|	КОНЕЦ КАК Ставка,
	|	ЕСТЬNULL(Пользователи.Наименование, """") КАК Сотрудник,
	|	ЕСТЬNULL(ВТ_КИ.АдресЭП, """") КАК Почта
	|ИЗ
	|	ВТ_Часы КАК ВТ_Часы
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_КИ КАК ВТ_КИ
	|		ПО ВТ_Часы.Ответственный = ВТ_КИ.Пользователь
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Пользователи КАК Пользователи
	|		ПО ВТ_Часы.Ответственный = Пользователи.Ссылка");
	яЗ.УстановитьПараметр("Ссылка", Объект.Ссылка);
	яЗ.УстановитьПараметр("Тип", Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
	яВ = яЗ.Выполнить().Выбрать();
	
	яДанные = Новый Массив;
	яОписаниеСтроки = "Сотрудник,Почта,Количество,Ставка";
	Пока яВ.Следующий() Цикл
		яСтрока = Новый Структура(яОписаниеСтроки);
		ЗаполнитьЗначенияСвойств(яСтрока, яВ);
		яДанные.Добавить(яСтрока);
	КонецЦикла;
	
	яЗаписьJSON = Новый ЗаписьJSON;
	яЗаписьJSON.УстановитьСтроку(Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Windows, Символы.Таб, Истина, ЭкранированиеСимволовJSON.СимволыВнеBMP, Истина));
	ЗаписатьJSON(яЗаписьJSON, яДанные);
	яТекст = яЗаписьJSON.Закрыть();
	яО.Вставить("Данные", яТекст);
	
	Возврат яО;
КонецФункции

&НаКлиенте
Процедура РаботыК7(Команда)
	яРез = РаботыК7НаСервере();
	Если яРез.Успех Тогда
		ВывестиВБуферОбмена(яРез.Данные);
	Иначе
		ITC.Ответ_ВывестиСообщенияПользователю(яРез);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСводныеДанныеНаСервере()
	Если Модифицированность Тогда
		Сообщить("Документ был изменён, необходимо сохранить.");
	КонецЕсли;
	
	яЗ = Новый Запрос;
	яЗ.УстановитьПараметр("Ссылка", Объект.Ссылка);
	яЗ.Текст = 
	"ВЫБРАТЬ
	|	ОплатаЧасовОплачиваемыеЗадания.Документ.Проект КАК Проект,
	|	ОплатаЧасовОплачиваемыеЗадания.Документ.Проект.Представление КАК ПроектИмя,
	|	ОплатаЧасовОплачиваемыеЗадания.Ответственный КАК Ответственный,
	|	ОплатаЧасовОплачиваемыеЗадания.Ответственный.Представление КАК ОтветственныйИмя,
	|	СУММА(ОплатаЧасовОплачиваемыеЗадания.Количество) КАК Количество,
	|	СУММА(ОплатаЧасовОплачиваемыеЗадания.Сумма) КАК Сумма
	|ИЗ
	|	Документ.ОплатаЧасов.ОплачиваемыеЗадания КАК ОплатаЧасовОплачиваемыеЗадания
	|ГДЕ
	|	ОплатаЧасовОплачиваемыеЗадания.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ОплатаЧасовОплачиваемыеЗадания.Документ.Проект,
	|	ОплатаЧасовОплачиваемыеЗадания.Ответственный,
	|	ОплатаЧасовОплачиваемыеЗадания.Документ.Проект.Представление,
	|	ОплатаЧасовОплачиваемыеЗадания.Ответственный.Представление
	|ИТОГИ
	|	СУММА(Количество),
	|	СУММА(Сумма)
	|ПО
	|	ОБЩИЕ,
	|	Проект
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОплатаЧасовОплачиваемыеЗадания.Ответственный КАК Ответственный,
	|	ОплатаЧасовОплачиваемыеЗадания.Ответственный.Представление КАК ОтветственныйИмя,
	|	СУММА(ОплатаЧасовОплачиваемыеЗадания.Количество) КАК Количество,
	|	СУММА(ОплатаЧасовОплачиваемыеЗадания.Сумма) КАК Сумма,
	|	ОплатаЧасовОплачиваемыеЗадания.Документ КАК Документ,
	|	ОплатаЧасовОплачиваемыеЗадания.Документ.Представление КАК ДокументПредставление
	|ИЗ
	|	Документ.ОплатаЧасов.ОплачиваемыеЗадания КАК ОплатаЧасовОплачиваемыеЗадания
	|ГДЕ
	|	ОплатаЧасовОплачиваемыеЗадания.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ОплатаЧасовОплачиваемыеЗадания.Ответственный,
	|	ОплатаЧасовОплачиваемыеЗадания.Ответственный.Представление,
	|	ОплатаЧасовОплачиваемыеЗадания.Документ,
	|	ОплатаЧасовОплачиваемыеЗадания.Документ.Представление
	|ИТОГИ
	|	СУММА(Количество),
	|	СУММА(Сумма)
	|ПО
	|	Ответственный";
	
	яРезЗап = яЗ.ВыполнитьПакет();
	
	
    яМакет = Документы.ОплатаЧасов.ПолучитьМакет("СводноеЗакрытие");
	яОблВсего = яМакет.ПолучитьОбласть("Всего");
	СводныеДанные.Очистить();
	
	яВыбОбщие = яРезЗап[0].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "ОБЩИЕ");
	яОбластьШапка = яМакет.ПолучитьОбласть("Шапка");
	СводныеДанные.Вывести(яОбластьШапка);
	яОблПроект = яМакет.ПолучитьОбласть("Проект");
	яОблСотрудник = яМакет.ПолучитьОбласть("Сотрудник");
	
	Пока яВыбОбщие.Следующий() Цикл
		
		яОблВсего.Параметры.Заполнить(яВыбОбщие);
		яВыбПроект = яВыбОбщие.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Проект");
		Пока яВыбПроект.Следующий() Цикл
			
			яОблПроект.Параметры.Заполнить(яВыбПроект);
			СводныеДанные.Вывести(яОблПроект);
			
			яВ = яВыбПроект.Выбрать();
			Пока яВ.Следующий() Цикл
				яОблСотрудник.Параметры.Заполнить(яВ);
				СводныеДанные.Вывести(яОблСотрудник);
			КонецЦикла;
			
		КонецЦикла;
	КонецЦикла;
	СводныеДанные.Вывести(яОблВсего);
	
	яВыбПроект = яРезЗап[1].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Ответственный");
	яОбластьШапка = яМакет.ПолучитьОбласть("ДеталиШапка");
	СводныеДанные.Вывести(яОбластьШапка);
	яОблПроект = яМакет.ПолучитьОбласть("ДеталиСотрудник");
	яОблСотрудник = яМакет.ПолучитьОбласть("ДеталиЗадача");
	
	Пока яВыбПроект.Следующий() Цикл
		
		яОблПроект.Параметры.Заполнить(яВыбПроект);
		СводныеДанные.Вывести(яОблПроект);
		
		яВ = яВыбПроект.Выбрать();
		Пока яВ.Следующий() Цикл
			яОблСотрудник.Параметры.Заполнить(яВ);
			СводныеДанные.Вывести(яОблСотрудник);
		КонецЦикла;
		
	КонецЦикла;
	СводныеДанные.Вывести(яОблВсего);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСводныеДанные(Команда)
	ЗаполнитьСводныеДанныеНаСервере();
КонецПроцедуры



#КонецОбласти