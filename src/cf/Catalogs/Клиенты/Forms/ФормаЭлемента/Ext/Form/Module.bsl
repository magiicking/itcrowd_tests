﻿
#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    // СтандартныеПодсистемы.КонтактнаяИнформация
    ДополнительныеПараметры = УправлениеКонтактнойИнформацией.ПараметрыКонтактнойИнформации();
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаКонтактнаяИнформация");
	УправлениеКонтактнойИнформацией.ПриСозданииНаСервере(ЭтотОбъект, Объект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	 // Обработчик подсистемы "Свойства"
    ДополнительныеПараметры = Новый Структура;
    ДополнительныеПараметры.Вставить("Объект", Объект);
    ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
    УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
    // Конец СтандартныеПодсистемы.Свойства
	 

КонецПроцедуры
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
    // СтандартныеПодсистемы.КонтактнаяИнформация
    УправлениеКонтактнойИнформацией.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
    // Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	// СтандартныеПодсистемы.Свойства
    УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);    
    // Конец СтандартныеПодсистемы.Свойства 
	
КонецПроцедуры
&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
    // СтандартныеПодсистемы.КонтактнаяИнформация
    УправлениеКонтактнойИнформацией.ОбработкаПроверкиЗаполненияНаСервере(ЭтотОбъект, Объект, Отказ);
    // Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	// СтандартныеПодсистемы.Свойства
    УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты, Объект);
    // Конец СтандартныеПодсистемы.Свойства
КонецПроцедуры
&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
    // СтандартныеПодсистемы.КонтактнаяИнформация
    УправлениеКонтактнойИнформацией.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
    // Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	// СтандартныеПодсистемы.Свойства
    УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
    // Конец СтандартныеПодсистемы.Свойства
КонецПроцедуры
&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
    // СтандартныеПодсистемы.КонтактнаяИнформация
    УправлениеКонтактнойИнформацией.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект);
    // Конец СтандартныеПодсистемы.КонтактнаяИнформация
КонецПроцедуры
#КонецОбласти

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	Если ПустаяСтрока(Объект.НаименованиеПолное) Тогда
		Объект.НаименованиеПолное = Объект.Наименование;
	КонецЕсли;
КонецПроцедуры

 // ПРОЦЕДУРЫ ПОДСИСТЕМЫ "СВОЙСТВ"
    &НаКлиенте
    Процедура Подключаемый_РедактироватьСоставСвойств()
        УправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтаФорма, Объект.Ссылка);
    КонецПроцедуры
    &НаСервере
    Процедура ОбновитьЭлементыДополнительныхРеквизитов()
        УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма, РеквизитФормыВЗначение("Объект"));
    КонецПроцедуры


#Область СлужебныеПроцедурыИФункции
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ПОДСИСТЕМЫ "КОНТАКТНАЯ ИНФОРМАЦИЯ"

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриИзменении(Элемент)
	УправлениеКонтактнойИнформациейКлиент.ПриИзменении(ЭтотОбъект, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент, ,СтандартнаяОбработка);	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриНажатии(Элемент, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент, ,СтандартнаяОбработка);	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОчистка(Элемент, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.Очистка(ЭтотОбъект, Элемент, ,СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияВыполнитьКоманду(Команда)
	УправлениеКонтактнойИнформациейКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда.Имя);	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.АвтоПодбор(Текст, ДанныеВыбора, СтандартнаяОбработка);	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.ОбработкаВыбора(ЭтотОбъект, ВыбранноеЗначение, Элемент.Имя, СтандартнаяОбработка);	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОбновитьКонтактнуюИнформацию(Результат) ЭКСПОРТ
	УправлениеКонтактнойИнформацией.ОбновитьКонтактнуюИнформацию(ЭтотОбъект, Объект, Результат);	
КонецПроцедуры

&НаСервере
Процедура КонтактнаяИнформацияПриСменеСтраницы()
	УправлениеКонтактнойИнформацией.ВыполнитьОтложеннуюИнициализацию(ЭтотОбъект, Объект);
КонецПроцедуры


#КонецОбласти

// -- БИТ МИС 09022021



