

&НаКлиенте
Процедура СгенерироватьПароль(Команда)
	ОткрытьФорму("Обработка.ITC_ГенераторПароля.Форма.Форма",, ЭтаФорма,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	Запись.Пароль = ВыбранноеЗначение;
КонецПроцедуры
