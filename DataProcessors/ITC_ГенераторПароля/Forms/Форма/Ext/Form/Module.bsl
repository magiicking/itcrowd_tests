﻿
&НаСервере
Процедура СгенерироватьНаСервере()
	яОб = РеквизитФормыВЗначение("Объект");
	яОб.Генерация();
	ЗначениеВРеквизитФормы(яОб, "Объект");
КонецПроцедуры

&НаКлиенте
Процедура Сгенерировать(Команда)
	СгенерироватьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура Применить(Команда)
	ОповеститьОВыборе(Объект.Результат);
КонецПроцедуры
