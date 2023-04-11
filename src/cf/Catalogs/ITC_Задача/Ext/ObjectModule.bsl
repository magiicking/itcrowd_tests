﻿
Процедура ПриЗаписи(Отказ)
	ЗаписатьЧасыПлан();
КонецПроцедуры



Процедура ЗаписатьЧасыПлан()
	
	яЗ = Новый Запрос;
	яЗ.УстановитьПараметр("ДокументОснование", ЭтотОбъект.Ссылка);
	яЗ.УстановитьПараметр("JIRA_ID", "ВремяПлан");
	яЗ.Текст = 
	"ВЫБРАТЬ
	|	СУММА(ВремяРабочееВремя.План) КАК План,
	|	ВремяРабочееВремя.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.РегистрацияВремени.РабочееВремя КАК ВремяРабочееВремя
	|ГДЕ
	|	ВремяРабочееВремя.Ссылка.JIRA_ID = &JIRA_ID
	|	И ВремяРабочееВремя.Ссылка.ДокументОснование = &ДокументОснование
	|
	|СГРУППИРОВАТЬ ПО
	|	ВремяРабочееВремя.Ссылка";
	яРезЗап = яЗ.Выполнить();
	яВ = яРезЗап.Выбрать();
	Если яВ.Следующий() Тогда
		Если яВ.План = ЭтотОбъект.ПервоначальнаяОценка Тогда
			Возврат;
		КонецЕсли;
		яВремя = яВ.Ссылка.ПолучитьОбъект();
	ИначеЕсли ЭтотОбъект.ПервоначальнаяОценка = 0 Тогда
		Возврат;
	Иначе
		яВремя = Документы.РегистрацияВремени.СоздатьДокумент();
		яВремя.JIRA_ID = "ВремяПлан";
		яВремя.ДокументОснование = ЭтотОбъект.Ссылка;
		яВремя.Дата = ТекущаяДатаСеанса();
	КонецЕсли;
	яВремя.РабочееВремя.Очистить();
	яСтрока = яВремя.РабочееВремя.Добавить();
	яСтрока.План = ЭтотОбъект.ПервоначальнаяОценка;
	яСтрока.Дата = яВремя.Дата;
	яВремя.Записать(РежимЗаписиДокумента.Проведение, РежимПроведенияДокумента.Неоперативный);
	
КонецПроцедуры
