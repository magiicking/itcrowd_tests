﻿
Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Параметры.Свойство("Назначение") = Истина Тогда
		Назначение = Параметры.Назначение;
	Иначе
		Назначение = Неопределено;
	КонецЕсли;
	
	ВидыСравнения = Перечисления.ТелеграмВидыСравнения;
	ДанныеВыбора = Новый СписокЗначений;
	
	Если Назначение = "Условия" Тогда
		ДанныеВыбора.Добавить(ВидыСравнения.НачинаетсяС);
		ДанныеВыбора.Добавить(ВидыСравнения.НеНачинаетсяС);
		ДанныеВыбора.Добавить(ВидыСравнения.НеРавно);
		ДанныеВыбора.Добавить(ВидыСравнения.НеСодержит);
		ДанныеВыбора.Добавить(ВидыСравнения.Равно);
		ДанныеВыбора.Добавить(ВидыСравнения.Содержит);
	ИначеЕсли Назначение = "ВходящийТекст" ИЛИ Назначение = "ВходящиеДанные" Тогда
		ДанныеВыбора.Добавить(ВидыСравнения.Заполнено);
		ДанныеВыбора.Добавить(ВидыСравнения.НеЗаполнено);
		ДанныеВыбора.Добавить(ВидыСравнения.НачинаетсяС);
		ДанныеВыбора.Добавить(ВидыСравнения.НеНачинаетсяС);
		ДанныеВыбора.Добавить(ВидыСравнения.НеРавно);
		ДанныеВыбора.Добавить(ВидыСравнения.НеСодержит);
		ДанныеВыбора.Добавить(ВидыСравнения.Равно);
		ДанныеВыбора.Добавить(ВидыСравнения.Содержит);
	Иначе // Контекст, ВходящийТекст, НЕОПРЕДЕЛЕНО
		ДанныеВыбора.Добавить(ВидыСравнения.Больше);
		ДанныеВыбора.Добавить(ВидыСравнения.БольшеИлиРавно);
		ДанныеВыбора.Добавить(ВидыСравнения.Заполнено);
		ДанныеВыбора.Добавить(ВидыСравнения.Меньше);
		ДанныеВыбора.Добавить(ВидыСравнения.МеньшеИлиРавно);
		ДанныеВыбора.Добавить(ВидыСравнения.НачинаетсяС);
		ДанныеВыбора.Добавить(ВидыСравнения.НеЗаполнено);
		ДанныеВыбора.Добавить(ВидыСравнения.НеНачинаетсяС);
		ДанныеВыбора.Добавить(ВидыСравнения.НеРавно);
		ДанныеВыбора.Добавить(ВидыСравнения.НеСодержит);
		ДанныеВыбора.Добавить(ВидыСравнения.Равно);
		ДанныеВыбора.Добавить(ВидыСравнения.Содержит);
	КонецЕсли;
	
КонецПроцедуры