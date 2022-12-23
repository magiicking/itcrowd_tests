﻿#Область Работа_с_ответами_функций

Функция Ответ_СформироватьСтруктуру(ъДопСтруктура = "", ъИмяСобытия = "") Экспорт
	
	Возврат Новый Структура("Успех,Сообщения,ИмяСобытия" + ?(ПустаяСтрока(ъДопСтруктура), "", ",") + ъДопСтруктура, Истина, Новый Массив, ?(ПустаяСтрока(ъИмяСобытия), "ЭСУП", ъИмяСобытия));
	
КонецФункции

Процедура Ответ_ДобавитьСообщение(ъОтвет, ъТекст, ъПоле = Неопределено, ъПутьКДанным = Неопределено, ъКлючДанных = Неопределено) Экспорт
	
	#Если Сервер Тогда
		яС = ъТекст;
	#Иначе
		яС = Новый СообщениеПользователю;
		яС.Текст		= ъТекст;
		Если Неопределено <> ъПоле Тогда
			яС.Поле			= ъПоле;
		КонецЕсли;
		Если Неопределено <> ъПутьКДанным Тогда
			яС.ПутьКДанным	= ъПутьКДанным;
		КонецЕсли;
		Если Неопределено <> ъКлючДанных Тогда
			яС.КлючДанных	= ъКлючДанных;
		КонецЕсли;
	#КонецЕсли
		
	ъОтвет.Сообщения.Добавить(яС);
	
КонецПроцедуры

Функция Ответ_УстановитьСтатус(ъОтвет, ъТекстСообщения = "", ъСтатус = Ложь) Экспорт
	
	ъОтвет.Успех = ъСтатус;
	Если Не ПустаяСтрока(ъТекстСообщения) Тогда
		Ответ_ДобавитьСообщение(ъОтвет, ъТекстСообщения);
	КонецЕсли;
	Возврат ъОтвет;
	
КонецФункции

Функция Ответ_ВернутьСтатус(ъОтвет, ъТекстСообщения = "", ъСтатус = Ложь) Экспорт
	
	ъОтвет.Успех = ъСтатус;
	Если Не ПустаяСтрока(ъТекстСообщения) Тогда
		Ответ_ДобавитьСообщение(ъОтвет, ъТекстСообщения);
	КонецЕсли;
	Возврат ъОтвет;
	
КонецФункции

Функция Ответ_ВывестиСообщенияПользователю(ъОтвет, ъПредупреждение = Ложь, яВремяПредупреждения = 30) Экспорт
	
	Если ъОтвет.Свойство("Сообщения") Тогда
		Для Каждого яС Из ъОтвет.Сообщения Цикл
			Ответ_ВывестиСообщение_Переопределяемый(яС, ъПредупреждение, яВремяПредупреждения);
		КонецЦикла;
	ИначеЕсли ъОтвет.Свойство("Сообщение") Тогда
		Ответ_ВывестиСообщение_Переопределяемый(ъОтвет.Сообщение, ъПредупреждение, яВремяПредупреждения);
	КонецЕсли;
	
	Возврат ъОтвет;
	
КонецФункции

Процедура Ответ_ВывестиСообщение_Переопределяемый(ъСообщение, ъПредупреждение, яВремяПредупреждения)
	
	Если ъПредупреждение Тогда
		#Если ТолстыйКлиент Тогда
			Предупреждение(Ответ_ТекстСообщения(ъСообщение), яВремяПредупреждения);
		#КонецЕсли
	Иначе
		Если ТипЗнч(ъСообщение) = Тип("Строка") Тогда
			Сообщить(ъСообщение);
		Иначе
			ъСообщение.Сообщить();
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры

Функция Ответ_ТекстСообщения(ъСообщение)
	Если ТипЗнч(ъСообщение) = Тип("Строка") Тогда
		Возврат ъСообщение;
	Иначе
		Возврат ъСообщение.Текст;
	КонецЕсли;
КонецФункции

// Процедура - Объединить ответы
// Устанавливает результирующий статус (метод "И") и добавляет сообщения пользователю
//
// Параметры:
//  ъОтветГотовый			 - Структура	 - Куда будет выведен результат объединения
//  ъОбъектПрисоединяемый	 - Структура	 - Объект источник дополнительных сообщений
//
Функция Ответ_ОбъединитьОтветы(ъОтветГотовый, ъОбъектПрисоединяемый) Экспорт
	
	ъОтветГотовый.Успех = ъОтветГотовый.Успех И ъОбъектПрисоединяемый.Успех;
	Для Каждого яС Из ъОбъектПрисоединяемый.Сообщения Цикл
		ъОтветГотовый.Сообщения.Добавить(яС);
	КонецЦикла;
	Возврат ъОтветГотовый;
	
КонецФункции

Функция Ответ_ЛогироватьСообщения(ъОтвет, ъИмяСобытия = "") Экспорт
	
	Если Не ПустаяСтрока(ъИмяСобытия) Тогда ъОтвет.Вставить("ИмяСобытия", ъИмяСобытия) КонецЕсли;
	
	Если ъОтвет.Свойство("Сообщения") Тогда
		Для Каждого яС Из ъОтвет.Сообщения Цикл
			Ответ_ЛогироватьСообщение(яС, ъОтвет);
		КонецЦикла;
	ИначеЕсли ъОтвет.Свойство("Сообщение") Тогда
		Ответ_ЛогироватьСообщение(яС.Сообщение, ъОтвет);
	КонецЕсли;
	
	Возврат ъОтвет;

КонецФункции

Процедура Ответ_ЛогироватьСообщение(ъСообщение, ъОтвет)
	#Если Сервер ИЛИ ТолстыйКлиентОбычноеПриложение Тогда
	яУровень = ?(ъОтвет.Успех, УровеньЖурналаРегистрации.Информация, УровеньЖурналаРегистрации.Ошибка);
	ЗаписьЖурналаРегистрации(щСвойство(ъОтвет, "ИмяСобытия", "ЭСУП"),яУровень,,,Ответ_ТекстСообщения(ъСообщение));
	#КонецЕсли
КонецПроцедуры

#КонецОбласти


#Область Работа_с_ответами_функций

#Область Переопределяемые

Процедура отвВывести_Переопределяемый(ъСообщение, ъПредупреждение)
	
	Если ъПредупреждение Тогда
		яТекст = отвТекстСообщения(ъСообщение);
		#Если Сервер Тогда
		Сообщить(яТекст);
		#Иначе
		ПоказатьПредупреждение(, яТекст);
		#КонецЕсли
	Иначе
		Если ТипЗнч(ъСообщение) = Тип("СообщениеПользователю") Тогда
			ъСообщение.Сообщить();
		Иначе
			Сообщить(ъСообщение);
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры

Процедура отвЛогировать_Переопределяемый(ъСообщение, ъОтвет)
	
	Если Не ъОтвет.Свойство("ИмяСобытия") Тогда
		ъОтвет.Вставить("ИмяСобытия", отвИмяСобытияПоУмолчанию());
	КонецЕсли;
	
	ITC_Сервер.отвЛогировать(ъСообщение, ъОтвет);
	
КонецПроцедуры

Функция отвИмяСобытияПоУмолчанию() Экспорт
	Возврат "ITC";
КонецФункции

#КонецОбласти

Функция отвНовый(ъДопСтруктура = "", яИмяСобытия = "") Экспорт
	
	яО = Новый Структура("Успех,Сообщения" + ?(ПустаяСтрока(ъДопСтруктура), "", ",") + ъДопСтруктура, Истина, Новый Массив);
	Если Не ПустаяСтрока(яИмяСобытия) Тогда
		яО.Вставить("ИмяСобытия", яИмяСобытия);
	КонецЕсли;
	Возврат яО;
	
КонецФункции

Процедура отвДобавить(ъОтвет, ъТекст, ъПоле = Неопределено, ъПутьКДанным = Неопределено, ъКлючДанных = Неопределено) Экспорт
	
	#Если Сервер Тогда
		яС = ъТекст;
	#Иначе
		яС = Новый СообщениеПользователю;
		яС.Текст		= ъТекст;
		Если Неопределено <> ъПоле Тогда
			яС.Поле			= ъПоле;
		КонецЕсли;
		Если Неопределено <> ъПутьКДанным Тогда
			яС.ПутьКДанным	= ъПутьКДанным;
		КонецЕсли;
		Если Неопределено <> ъКлючДанных Тогда
			яС.КлючДанных	= ъКлючДанных;
		КонецЕсли;
	#КонецЕсли
		
	ъОтвет.Сообщения.Добавить(яС);
	
КонецПроцедуры

Функция отвЗадатьСтатус(ъОтвет, ъТекстСообщения = "", ъСтатус = Ложь) Экспорт
	
	ъОтвет.Успех = ъСтатус;
	Если Не ПустаяСтрока(ъТекстСообщения) Тогда
		отвДобавить(ъОтвет, ъТекстСообщения);
	КонецЕсли;
	Возврат ъОтвет;
	
КонецФункции

Функция отвСтатус(ъОтвет, ъТекстСообщения = "", ъСтатус = Ложь) Экспорт
	
	Возврат ъОтвет.Успех;
	
КонецФункции

Процедура отвВывести(ъОтвет, ъПредупреждение = Ложь) Экспорт
	
	Если ъОтвет.Свойство("Сообщения") Тогда
		Для Каждого яС Из ъОтвет.Сообщения Цикл
			отвВывести_Переопределяемый(яС, ъПредупреждение);
		КонецЦикла;
	ИначеЕсли ъОтвет.Свойство("Сообщение") Тогда
		отвВывести_Переопределяемый(ъОтвет.Сообщение, ъПредупреждение);
	КонецЕсли;
	
КонецПроцедуры

Функция отвТекстСообщения(ъСообщение) Экспорт
	Если ТипЗнч(ъСообщение) = Тип("СообщениеПользователю") Тогда
		Возврат ъСообщение.Текст;
	Иначе
		Возврат ъСообщение;
	КонецЕсли;
КонецФункции

// Функция - Объединить ответы
//  Устанавливает результирующий статус (метод "И") и добавляет сообщения пользователю
//
// Параметры:
//  ъОтветГотовый			 - Структура - Куда будет выведен результат объединения
//  ъОбъектПрисоединяемый	 - Структура - Объект источник дополнительных сообщений
// 
// Возвращаемое значение:
//  Структура - Готовый ответ с присоединёнными данным (он так же меняется по ссылке)
//
Функция отвОбъединить(ъОтветГотовый, ъОбъектПрисоединяемый) Экспорт
	
	ъОтветГотовый.Успех = ъОтветГотовый.Успех И ъОбъектПрисоединяемый.Успех;
	Для Каждого яС Из ъОбъектПрисоединяемый.Сообщения Цикл
		ъОтветГотовый.Сообщения.Добавить(яС);
	КонецЦикла;
	Возврат ъОтветГотовый;
	
КонецФункции

Функция отвЛогировать(ъОтвет, ъИмяСобытия = "") Экспорт
	
	Если Не ПустаяСтрока(ъИмяСобытия) Тогда ъОтвет.Вставить("ИмяСобытия", ъИмяСобытия) КонецЕсли;
	
	Если ъОтвет.Свойство("Сообщения") Тогда
		Для Каждого яС Из ъОтвет.Сообщения Цикл
			отвЛогировать_Переопределяемый(яС, ъОтвет);
		КонецЦикла;
	ИначеЕсли ъОтвет.Свойство("Сообщение") Тогда
		отвЛогировать_Переопределяемый(яС.Сообщение, ъОтвет);
	КонецЕсли;
	
	Возврат ъОтвет;

КонецФункции

#КонецОбласти


#Область Библиотека_функций

// Функция - Значение свойства
// Возвращает значение свойства из структуры, производит проверку его наличия
//
// Параметры:
//  ъСтруктура			 - Структура	 - Искомая структура
//  ъСвойство			 - Строка	 - Искомое свойство
//  ъЗначениеПоУмолчанию - Произвольное	 - Значение, используемое, если свойство не найдено
// 
// Возвращаемое значение:
//  Произвольное - Значение свойства или значение по умолчанию
//
Функция щСвойство(ъСтруктура, ъСвойство, ъЗначениеПоУмолчанию = Ложь) Экспорт
	Если ТипЗнч(ъСтруктура) = Тип("Структура") Тогда
		Если ъСтруктура.Свойство(ъСвойство) Тогда
			Возврат ъСтруктура[ъСвойство];
		Иначе
			Возврат ъЗначениеПоУмолчанию;
		КонецЕсли;
	Иначе
		яТест = Новый Структура(ъСвойство, ъЗначениеПоУмолчанию);
		ЗаполнитьЗначенияСвойств(яТест, ъСтруктура);
		Возврат яТест[ъСвойство];
	КонецЕсли;
КонецФункции   

Процедура щДобавить(ъКуда, ъЧто, ъРазделитель = Неопределено) Экспорт
	Если ъРазделитель = Неопределено Тогда
		ъКуда = ъКуда + ъЧто;
	Иначе
		ъКуда = ъКуда + ъРазделитель + ъЧто;
	КонецЕсли;
КонецПроцедуры

#Если Сервер Тогда
	
Процедура щЗаписатьВЖурнал(ъТекст, ъУровень = Неопределено) Экспорт
	ЗаписьЖурналаРегистрации(отвИмяСобытияПоУмолчанию()
	, ?(ъУровень = Неопределено, УровеньЖурналаРегистрации.Ошибка, ъУровень)
	, ,
	, ъТекст);
КонецПроцедуры

#КонецЕсли

Функция щПрочитатьФайлJSON(ъИмяФайла, ъИменаДаты = "", ъВСоответствие = Ложь) Экспорт
	яО = отвНовый("Данные");
	
	Попытка
		яЧ = Новый ЧтениеJSON();
		яЧ.ОткрытьФайл(ъИмяФайла, "UTF-8");
		яО.Данные = ПрочитатьJSON(яЧ, ъВСоответствие, ъИменаДаты, ФорматДатыJSON.ISO);
		яЧ.Закрыть();
	Исключение
		яОшибка = ОписаниеОшибки();
		отвЗадатьСтатус(яО, яОшибка);
		отвЛогировать(яО);
	КонецПопытки;
	
	Возврат яО;
КонецФункции

Функция щЗаписатьФайлJSON(ъДанные, ъИмяФайла) Экспорт
	яО = отвНовый();
	
	Попытка
		яЗапись = Новый ЗаписьJSON();
		яПараметры = Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Unix, Символы.Таб);
		яЗапись.ОткрытьФайл(ъИмяФайла, "UTF-8", Ложь, яПараметры);
		яНастройкиСериализации = Новый НастройкиСериализацииJSON;
		яНастройкиСериализации.ВариантЗаписиДаты = ВариантЗаписиДатыJSON.ЛокальнаяДата;
		яНастройкиСериализации.ФорматСериализацииДаты = ФорматДатыJSON.ISO;
		ЗаписатьJSON(яЗапись, ъДанные, яНастройкиСериализации);
		яЗапись.Закрыть();
	Исключение
		яОшибка = ОписаниеОшибки();
		отвЗадатьСтатус(яО, яОшибка);
		отвЛогировать(яО);
	КонецПопытки;
	
	Возврат яО;	
КонецФункции

Функция щСжатьФайл(ъИмяФайла, ъОтметкаВремени = Ложь)
	яО = отвНовый("ПутьАрхива");
	
	Попытка
		яФайл = Новый Файл(ъИмяФайла);
		яНовыйПуть = яФайл.Путь
		+ ?(ъОтметкаВремени, Формат(ТекущаяДата(), "ДФ=yyyy-MM-dd_HHmmss_"), "")
		+ яФайл.ИмяБезРасширения + ".zip";
		яЗип = Новый ЗаписьZipФайла(яНовыйПуть,,,МетодСжатияZIP.BZIP2,УровеньСжатияZIP.Максимальный);
		яЗип.Добавить(яФайл.ПолноеИмя, РежимСохраненияПутейZIP.НеСохранятьПути);
		яЗип.Записать();
		яО.ПутьАрхива = яНовыйПуть;
	Исключение
		яОшибка = ОписаниеОшибки();
		отвЗадатьСтатус(яО, яОшибка);
		отвЛогировать(яО);
	КонецПопытки;
	
	Возврат яО;
КонецФункции

// Процедура - Заполняет незаполненный параметр
//
// Параметры:
//  ъНастройка	 - Произвольный	 - Что проверяет
//  ъЗначение	 - Произвольный	 - Чем заполнит
//
Процедура щЗапНезап(ъНастройка, ъЗначение)
	Если Не ЗначениеЗаполнено(ъНастройка) Тогда
		ъНастройка = ъЗначение;
	КонецЕсли;
КонецПроцедуры

Процедура щДобавитьИндексДляТаблицы(яТЗВход, яЗначениеИндекса)
	яНадоСоздатьИндекс = Истина;
	яИмя = НРег(яЗначениеИндекса);
	Для Каждого яИндекс Из яТЗВход.Индексы Цикл
		Если НРег(яТЗВход.Индексы[1]) = яИмя Тогда
			яНадоСоздатьИндекс = Ложь;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Если яНадоСоздатьИндекс Тогда
		яТЗВход.Индексы.Добавить(яЗначениеИндекса);
	КонецЕсли;
КонецПроцедуры

Функция щСтрокуВЧисло(ъСтрока)
	яОтвет = 0;
	яС = СтрЗаменить(ъСтрока, " ", "");
	яС = СтрЗаменить(яС, Символы.Таб, "");
	яС = СтрЗаменить(яС, Символы.НПП, ""); 
	яС = СтрЗаменить(яС, ".", ",");
	
	яБезЦифр = яС;
	Для й = 0 По 9 Цикл
		яБезЦифр = СтрЗаменить(яБезЦифр, й, "");
	КонецЦикла;
	яБезЦифр = СтрЗаменить(яБезЦифр, ",", "");
	Для й = 1 По СтрДлина(яБезЦифр) Цикл
		яС = СтрЗаменить(яС, Сред(яБезЦифр, й, 1), "");
	КонецЦикла;		
	Пока СтрНайти(яС, ",,") Цикл
		яС = СтрЗаменить(яС, ",,", ",");
	КонецЦикла;
	яМ = СтрРазделить(яС, ",", Ложь);
	
	Если яМ.Количество() Тогда
		яОтвет = Число(яМ[0]);
	КонецЕсли;
	
	Если яМ.Количество() > 1 Тогда
		яДлина = СтрДлина(яМ[1]);
		яОтвет = яОтвет + Число(яМ[1]) / Pow(10, яДлина);
	КонецЕсли;
	
	Возврат яОтвет;
КонецФункции

#КонецОбласти

