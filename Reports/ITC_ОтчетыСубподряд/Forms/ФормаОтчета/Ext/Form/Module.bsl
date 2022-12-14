
&НаСервере
Функция СформироватьНаСервере_ТекстЗапроса()
	Возврат 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТрудозатратыОстатки.Ответственный КАК Ответственный,
	|	ТрудозатратыОстатки.Задача КАК Задача,
	|	ТрудозатратыОстатки.ОтчетОстаток КАК Остаток
	|ПОМЕСТИТЬ ВТ_ОстаткиСырые
	|ИЗ
	|	РегистрНакопления.Трудозатраты.Остатки(&Дата, ) КАК ТрудозатратыОстатки
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Задача,
	|	Ответственный
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТрудозатратыОбороты.Ответственный КАК Ответственный,
	|	ТрудозатратыОбороты.Задача КАК Задача,
	|	ТрудозатратыОбороты.ОтчетРасход КАК ОтчетРасход
	|ПОМЕСТИТЬ ВТ_ОборотыСырые
	|ИЗ
	|	РегистрНакопления.Трудозатраты.Обороты(&ДатаНачала, &ДатаОкончания, Период, ) КАК ТрудозатратыОбороты
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Задача,
	|	Ответственный
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(ВТ_ОстаткиСырые.Задача, ВТ_ОборотыСырые.Задача) КАК Задача,
	|	ЕСТЬNULL(ВТ_ОстаткиСырые.Ответственный, ВТ_ОборотыСырые.Ответственный) КАК Ответственный,
	|	ЕСТЬNULL(ВТ_ОстаткиСырые.Остаток, 0) КАК Остаток,
	|	ЕСТЬNULL(ВТ_ОборотыСырые.ОтчетРасход, 0) КАК Актировано
	|ПОМЕСТИТЬ ВТ_ПредИтог
	|ИЗ
	|	ВТ_ОстаткиСырые КАК ВТ_ОстаткиСырые
	|		ПОЛНОЕ СОЕДИНЕНИЕ ВТ_ОборотыСырые КАК ВТ_ОборотыСырые
	|		ПО ВТ_ОстаткиСырые.Задача = ВТ_ОборотыСырые.Задача
	|			И ВТ_ОстаткиСырые.Ответственный = ВТ_ОборотыСырые.Ответственный
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТрудозатратыОстатки.Ответственный КАК Ответственный,
	|	ТрудозатратыОстатки.Задача КАК Задача,
	|	ВЫБОР
	|		КОГДА ТрудозатратыОстатки.Задача.Родитель = ЗНАЧЕНИЕ(Справочник.ITC_Задача.ПустаяСсылка)
	|			ТОГДА ТрудозатратыОстатки.Задача
	|		ИНАЧЕ ТрудозатратыОстатки.Задача.Родитель
	|	КОНЕЦ КАК ГоловнаяЗадача,
	|	ТрудозатратыОстатки.Остаток КАК Остаток,
	|	ТрудозатратыОстатки.Актировано КАК Актировано
	|ПОМЕСТИТЬ ВТ_Остатки
	|ИЗ
	|	ВТ_ПредИтог КАК ТрудозатратыОстатки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВТ_Остатки.Ответственный КАК Ответственный,
	|	ВТ_Остатки.Ответственный.Наименование КАК ОтветственныйНаименование,
	|	ВТ_Остатки.ГоловнаяЗадача КАК ГоловнаяЗадача,
	|	ВТ_Остатки.ГоловнаяЗадача.JIRA_ID КАК ГоловнойКод,
	|	ВТ_Остатки.ГоловнаяЗадача.Наименование КАК ГоловнойНаименование,
	|	ВТ_Остатки.ГоловнаяЗадача.Статус.Наименование КАК ГоловнойСтатус,
	|	ВТ_Остатки.Задача.JIRA_ID КАК Код,
	|	ВТ_Остатки.Задача.Наименование КАК Наименование,
	|	ВТ_Остатки.Остаток КАК Остаток,
	|	ВТ_Остатки.Актировано КАК Актировано
	|ИЗ
	|	ВТ_Остатки КАК ВТ_Остатки
	|ИТОГИ
	|	СУММА(Остаток),
	|	СУММА(Актировано)
	|ПО
	|	Ответственный,
	|	ГоловнаяЗадача";
	
КонецФункции

&НаСервере
Процедура СформироватьНаСервере()
	яЗ = Новый Запрос;
	яГраница = новый Граница(КонецДня(Отчет.ДатаОтчёта), ВидГраницы.Включая);
	яГраницаНачМесяц = новый Граница(НачалоМесяца(Отчет.ДатаОтчёта), ВидГраницы.Включая);
	яГраницаКонМесяц = новый Граница(КонецМесяца(Отчет.ДатаОтчёта), ВидГраницы.Включая);
	яЗ.УстановитьПараметр("Дата", яГраница);
	яЗ.УстановитьПараметр("ДатаНачала", яГраницаНачМесяц);
	яЗ.УстановитьПараметр("ДатаОкончания", яГраницаКонМесяц);
	яЗ.Текст = СформироватьНаСервере_ТекстЗапроса();
	
	яОтчет = РеквизитФормыВЗначение("Отчет");
	яМакет = яОтчет.ВозвратМакета("НезавершённоеПроизводство");
	
	яОблШапка = яМакет.ПолучитьОбласть("Шапка");
	яОблОтветственный = яМакет.ПолучитьОбласть("Ответственный");
	яОблЗадача = яМакет.ПолучитьОбласть("Задача");
	яОблГоловнаяЗадача = яМакет.ПолучитьОбласть("ГоловнаяЗадача");
		
	РезультатОтчета.Очистить();
	яОблШапка.Параметры.Дата = Формат(Отчет.ДатаОтчёта, "ДФ=yyyy-MM-dd");
	РезультатОтчета.Вывести(яОблШапка);
	
	яРезЗап = яЗ.Выполнить();
	яВыборкаОтветственный = яРезЗап.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Ответственный");
	
	Пока яВыборкаОтветственный.Следующий() Цикл
		яОблОтветственный.Параметры.Заполнить(яВыборкаОтветственный);
		РезультатОтчета.Вывести(яОблОтветственный);
		
		яВыборкаГоловная = яВыборкаОтветственный.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "ГоловнаяЗадача");
		Пока яВыборкаГоловная.Следующий() Цикл
			яОблГоловнаяЗадача.Параметры.Заполнить(яВыборкаГоловная);
			РезультатОтчета.Вывести(яОблГоловнаяЗадача);
			
			яВ = яВыборкаГоловная.Выбрать();
			Пока яВ.Следующий() Цикл
				яОблЗадача.Параметры.Заполнить(яВ);
				РезультатОтчета.Вывести(яОблЗадача);
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
		
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
	СформироватьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Отчет.ДатаОтчёта = ТекущаяДатаСеанса();
КонецПроцедуры
