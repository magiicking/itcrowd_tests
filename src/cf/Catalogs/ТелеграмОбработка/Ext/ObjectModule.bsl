﻿
Процедура ПередЗаписью(Отказ)
	
	Если НЕ ЭтоГруппа Тогда
		ДействияНадКонтекстомАвто = ДействияНадКонтекстом.Количество();
		Если ПометкаУдаления Тогда
			Статус = Перечисления.ТелеграмСтатусыИспользования.Выключен;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры
