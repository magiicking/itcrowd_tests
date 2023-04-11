﻿
&НаКлиенте
Процедура Отменить(Команда)
	Закрыть();
КонецПроцедуры

&НаСервере
Процедура ДобавитьНаСервере()
	яМЗ = РегистрыСведений.СообщенияДокументы.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(яМЗ, ЭтаФорма);
	яМЗ.Автор		= ПараметрыСеанса.ТекущийПользователь;
	яМЗ.Дата		= ТекущаяДата();
	яМЗ.Записать();
КонецПроцедуры

&НаКлиенте
Процедура Добавить(Команда)
	ДобавитьНаСервере();
	ОповеститьОВыборе(Неопределено);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры, "Документ");
КонецПроцедуры
