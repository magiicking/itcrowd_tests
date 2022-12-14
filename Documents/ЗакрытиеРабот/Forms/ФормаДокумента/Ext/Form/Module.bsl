
&НаСервере
Процедура ЗаполнитьНаСервере()
	// Вставить содержимое обработчика.
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВыполненныеРаботыОстатки.Работа КАК Работа,
	|	ВыполненныеРаботыОстатки.Сотрудник КАК Сотрудник,
	|	ВыполненныеРаботыОстатки.ОбъемОстаток КАК ОбъемОстаток
	|ИЗ
	|	РегистрНакопления.ВыполненныеРаботы.Остатки(, Проект = &Проект) КАК ВыполненныеРаботыОстатки";
	Объект.СписокРабот.Очистить();
	Запрос.УстановитьПараметр("Проект",Объект.Проект);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Строчка = Объект.СписокРабот.Добавить();
		Строчка.Сотрудник = Выборка.Сотрудник;
		Строчка.Работа = Выборка.Работа;
		Строчка.Объем = Выборка.ОбъемОстаток;
		Строчка.КЗакрытию = Выборка.ОбъемОстаток;
	КонецЦикла
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	ЗаполнитьНаСервере();
КонецПроцедуры
