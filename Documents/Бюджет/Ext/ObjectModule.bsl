
Процедура ОбработкаПроведения(Отказ, Режим)
	
	Движения.Бюджет.Записывать = Истина;
	Для Каждого ТекСтрокаСтатьиБюджета Из СтатьиБюджета Цикл
		Движение = Движения.Бюджет.Добавить();
		Движение.Период = Дата;
		Движение.Проект = Проект;
		Движение.Статья = ТекСтрокаСтатьиБюджета.Статья;
		Движение.СтатусСогласования = ТекСтрокаСтатьиБюджета.СтатусСогласования;
		Движение.РежимСогласования = ТекСтрокаСтатьиБюджета.РежимСогласования;
		Движение.Этап = ТекСтрокаСтатьиБюджета.Этап;
		Движение.Сумма = ТекСтрокаСтатьиБюджета.Сумма;
		Движение.Часы = ТекСтрокаСтатьиБюджета.Часы;
	КонецЦикла;
	
КонецПроцедуры
