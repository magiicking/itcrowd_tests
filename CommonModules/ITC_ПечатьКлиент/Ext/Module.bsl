﻿Процедура ВывестиНаПечать(ъТабличныйДокумент) Экспорт
	
	яФ = ПолучитьФорму("ОбщаяФорма.ФормаВыводаНаПечать",,, Новый УникальныйИдентификатор());
	яФ.ДанныеДокумента = ъТабличныйДокумент;
	яФ.Открыть();
	
КонецПроцедуры