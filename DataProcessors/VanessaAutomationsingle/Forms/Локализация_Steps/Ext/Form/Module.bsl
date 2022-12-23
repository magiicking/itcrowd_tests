﻿
&НаСервере
Функция ПолучитьМакетОбработкиСервер(ИмяМакета)
	ОбъектСервер = РеквизитФормыВЗначение("Объект");
	Возврат ОбъектСервер.ПолучитьМакет(ИмяМакета); 
КонецФункции	 

&НаКлиенте
Функция ПолучитьМакетОбработки(Знач ИмяМакета,ВерсияПоставки) Экспорт
	Если ВерсияПоставки = "single" Тогда
		ИмяМакета = "Локализация_Steps_" + ИмяМакета;
	КонецЕсли;	 
	
	Возврат ПолучитьМакетОбработкиСервер(ИмяМакета); 
КонецФункции	 

&НаСервере
Функция ДанныеМакетовШаговСервер(МассивЯзыков,ВерсияПоставки)
	ОбъектСервер = РеквизитФормыВЗначение("Объект");
	
	ДанныеМакетовШагов = Новый Структура;
	Для Каждого ТекЯзык Из МассивЯзыков Цикл
		ИмяМакета = ТекЯзык;
		Если ВерсияПоставки = "single" Тогда
			ИмяМакета = "Локализация_Steps_" + ИмяМакета;
		КонецЕсли;	 
		ДанныеМакетовШагов.Вставить(ТекЯзык,ОбъектСервер.ПолучитьМакет(ИмяМакета));
	КонецЦикла;	
	
	Возврат ДанныеМакетовШагов; 
КонецФункции	 

&НаКлиенте
Функция ДанныеМакетовШагов(МассивЯзыков,ВерсияПоставки) Экспорт
	Возврат ДанныеМакетовШаговСервер(МассивЯзыков,ВерсияПоставки); 
КонецФункции	 