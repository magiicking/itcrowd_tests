﻿
//&НаСервере
//Процедура ЗаполнитьПоПроектуНаСервере()
//	// Вставить содержимое обработчика.
//	Запрос = Новый Запрос();
//	Запрос.Текст = 
//	"ВЫБРАТЬ
//	|	Работы.Ссылка КАК Ссылка,
//	|	Работы.ОбъемРаботы КАК ОбъемРаботы,
//	|	Работы.ОжидаемаяДлительность КАК ОжидаемаяДлительность,
//	|	Работы.Порядок КАК Порядок
//	|ПОМЕСТИТЬ ВТ_Работы
//	|ИЗ
//	|	Справочник.Работы КАК Работы
//	|ГДЕ
//	|	Работы.Владелец.Владелец = &Проект
//	|	И НЕ Работы.ПометкаУдаления
//	|;
//	|
//	|////////////////////////////////////////////////////////////////////////////////
//	|ВЫБРАТЬ
//	|	ВТ_Работы.Ссылка КАК Работа,
//	|	ВТ_Работы.ОбъемРаботы КАК ОбъемРаботы,
//	|	ВТ_Работы.ОжидаемаяДлительность КАК ОжидаемаяДлительность,
//	|	ВТ_Работы.Порядок КАК Порядок,
//	|	ПланПроектаСрезПоследних.ДатаНачала КАК ДатаНачала,
//	|	ПланПроектаСрезПоследних.ДатаЗавершения КАК ДатаЗавершения,
//	|	ПланПроектаСрезПоследних.БюджетМинимальный КАК БюджетМинимальный,
//	|	ПланПроектаСрезПоследних.БюджетМаксимальный КАК БюджетМаксимальный,
//	|	ПланПроектаСрезПоследних.ТипБюджета КАК ТипБюджета,
//	|	ПланПроектаСрезПоследних.СтоимостьВСметеМинимум КАК СтоимостьВСметеМинимум,
//	|	ПланПроектаСрезПоследних.СтоимостьВСметеМаксимум КАК СтоимостьВСметеМаксимум,
//	|	РАЗНОСТЬДАТ( ПланПроектаСрезПоследних.ДатаНачала,ПланПроектаСрезПоследних.ДатаЗавершения, ДЕНЬ) КАК Длительность
//	|ИЗ
//	|	ВТ_Работы КАК ВТ_Работы
//	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПланПроекта.СрезПоследних КАК ПланПроектаСрезПоследних
//	|		ПО ВТ_Работы.Ссылка = ПланПроектаСрезПоследних.Работа
//	|
//	|УПОРЯДОЧИТЬ ПО
//	|	Порядок,
//	|	ДатаНачала
//	|;
//	|
//	|////////////////////////////////////////////////////////////////////////////////
//	|ВЫБРАТЬ
//	|	ВТ_Работы.Ссылка КАК Работа,
//	|	РаботыТребуемыеЗадачи.Работа КАК Блокер,
//	|	РаботыТребуемыеЗадачи.Задержка КАК Задержка
//	|ИЗ
//	|	ВТ_Работы КАК ВТ_Работы
//	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Работы.ТребуемыеЗадачи КАК РаботыТребуемыеЗадачи
//	|		ПО ВТ_Работы.Ссылка = РаботыТребуемыеЗадачи.Ссылка";
//	Запрос.УстановитьПараметр("Проект", Объект.Проект);
//	Результат = Запрос.ВыполнитьПакет();
//	
//	Объект.Состав.Очистить();
//	Работы = Результат[1].Выбрать();
//	ТочкаОтсчета = ТекущаяДата();
//	
//	Пока Работы.Следующий() Цикл
//		СтрокаРаботы = Объект.Состав.Добавить();
//		СтрокаРаботы.Работа = Работы.Работа;
//		Если ЗначениеЗаполнено(Работы.ДатаНачала) Тогда //Был уже план надо забрать его и дать пользователю его поправить
//			ТочкаОтсчета = Мин(Работы.ДатаНачала, ТочкаОтсчета);
//			СтрокаРаботы.ДатаНачала = Работы.ДатаНачала;
//			СтрокаРаботы.ДатаЗавершения = Работы.ДатаЗавершения ;
//			СтрокаРаботы.БюджетМинимальный = Работы.БюджетМинимальный ;
//			СтрокаРаботы.ТипБюджета = Работы.ТипБюджета ;
//			СтрокаРаботы.БюджетМаксимальный = Работы.БюджетМаксимальный ;
//			СтрокаРаботы.СтоимостьВСметеМинимум = Работы.СтоимостьВСметеМинимум ;
//			СтрокаРаботы.СтоимостьВСметеМаксимум = Работы.СтоимостьВСметеМаксимум ;
//			СтрокаРаботы.Длительность = Работы.Длительность ;
//		Иначе
//			СтрокаРаботы.Длительность = Работы.ОжидаемаяДлительность;
//			СтрокаРаботы.БюджетМинимальный = Работы.ОбъемРаботы ;
//		КонецЕсли;
//	КонецЦикла;
//	
//	//Объект.ТочкаОтсчета = ТочкаОтсчета
//КонецПроцедуры

//&НаКлиенте
//Процедура ЗаполнитьПоПроекту(Команда)
//	ЗаполнитьПоПроектуНаСервере();
//КонецПроцедуры

&НаКлиенте
Процедура РассчитатьСмету(Команда)
	
	Продолжение = Новый ОписаниеОповещения("РассчитатьСмету_Завершение", 
        ЭтотОбъект);
 
	
	ПоказатьВводЧисла(Продолжение, 3150, "По какой ставке необходимо провести расчет", 10,2);
КонецПроцедуры

&НаСервере
Процедура РассчитатьСметуНаСервере(Ставка)
	Для каждого СтрокаСметы ИЗ Объект.Состав Цикл
		СтрокаСметы.СтоимостьВСметеМинимум = Ставка * СтрокаСметы.БюджетМинимальный;
		СтрокаСметы.СтоимостьВСметеМаксимум = Ставка * СтрокаСметы.БюджетМаксимальный;
	КонецЦикла
КонецПроцедуры

Процедура РассчитатьСмету_Завершение(Результат, Параметры) Экспорт
	РассчитатьСметуНаСервере(Результат);	
КонецПроцедуры

&НаСервере
Процедура РассчитатьСрокиНаСервере()
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьСроки(Команда)
	
	
	РассчитатьСрокиНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПроектПриИзменении(Элемент)
	// Вставить содержимое обработчика.
	//ЗаполнитьПоПроектуНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СоставДатаНачалаПриИзменении(Элемент)
	// Вставить содержимое обработчика.
	Элементы.Состав.ТекущиеДанные.ДатаЗавершения = Элементы.Состав.ТекущиеДанные.ДатаНачала + Элементы.Состав.ТекущиеДанные.Длительность*24*3600;
	
КонецПроцедуры

&НаКлиенте
Процедура СоставДатаЗавершенияПриИзменении(Элемент)
	// Вставить содержимое обработчика.
	Элементы.Состав.ТекущиеДанные.ДатаНачала = Элементы.Состав.ТекущиеДанные.ДатаЗавершения - Элементы.Состав.ТекущиеДанные.Длительность*24*3600;
	
КонецПроцедуры

&НаКлиенте
Процедура СоставДлительностьПриИзменении(Элемент)
	// Вставить содержимое обработчика.
	Элементы.Состав.ТекущиеДанные.ДатаЗавершения = Элементы.Состав.ТекущиеДанные.ДатаНачала + Элементы.Состав.ТекущиеДанные.Длительность*24*3600;
КонецПроцедуры
