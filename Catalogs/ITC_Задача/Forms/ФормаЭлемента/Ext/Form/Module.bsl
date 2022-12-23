﻿
// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
    ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
    ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
    ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ОбновитьВремя();
	
	Если Не ЗначениеЗаполнено(Объект.JIRA_ID) Тогда
		Если Не ЗначениеЗаполнено(Объект.Ответственный) Тогда
			Объект.Ответственный = ПараметрыСеанса.ТекущийПользователь;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Объект.Статус) Тогда
			Объект.Статус = Справочники.ITC_СтатусыЗадач.Новая;
		КонецЕсли;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
		
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ЗаполнитьВидПоляJIRA();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьВидПоляJIRA()
	
	яЕстьИД = ЗначениеЗаполнено(Объект.JIRA_ID);
	
	Если яЕстьИД Тогда
		Элементы.JIRA_ID.ТолькоПросмотр = Истина;
		Элементы.JIRA_ID.Вид = ВидПоляФормы.ПолеНадписи;
		Элементы.JIRA_ID.Гиперссылка = Истина;
		ЗаполнитьВидПоляJIRA_Сервер(яЕстьИД);
		
		Элементы.Проект.ТолькоПросмотр = яЕстьИД;
		
		Элементы.Аналитик.ТолькоПросмотр = яЕстьИД;
		Элементы.Разработчик.ТолькоПросмотр = яЕстьИД;
		Элементы.Тестировщик.ТолькоПросмотр = яЕстьИД;
		Элементы.Куратор.ТолькоПросмотр = яЕстьИД;
		
		Элементы.Релиз.ТолькоПросмотр = яЕстьИД;
		Элементы.Спринт.ТолькоПросмотр = яЕстьИД;
		Элементы.Эпик.ТолькоПросмотр = яЕстьИД;
		
		Элементы.Описание.ТолькоПросмотр = яЕстьИД;
	КонецЕсли;
	
	Элементы.Клиент.Видимость = Не яЕстьИД;
	Элементы.КонтактноеЛицо.Видимость = Не яЕстьИД;
	
	Элементы.ФормаОбновитьЗадачу.Видимость = яЕстьИД;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВидПоляJIRA_Сервер(яЕстьИД)
	Если яЕстьИД Тогда
		Элементы.JIRA_ID.УстановитьДействие("Нажатие", "JIRA_IDНажатие"); 
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОбновитьВремя()

	яЗ = Новый Запрос;
	яЗ.УстановитьПараметр("Задача", Объект.Ссылка);
	яЗ.Текст = 
	"ВЫБРАТЬ
	|	ВремяОбороты.ФактОборот КАК Затрачено
	|ИЗ
	|	РегистрНакопления.Время.Обороты(, , Период, Задача = &Задача) КАК ВремяОбороты";
	
	яРезЗап = яЗ.Выполнить();
	яВ = яРезЗап.Выбрать();
	Если яВ.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(ЭтаФорма, яВ);
		//Теперь остаток берём только из JIRA		
		//ЭтаФорма.Осталось = Макс(0, Объект.ПервоначальнаяОценка - ЭтаФорма.Затрачено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьТаймер(Команда)
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ITC_ТаймерКлиент.ЗапуститьТаймер(Объект.Ссылка, ЭтаФорма);
	Иначе
		Сообщить("Задача не была сохранена, необходимо сначала сохранить.");
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОстановитьТаймерНаСервере(пСсылка)
	Обработки.ITC_Таймер.ОстановитьТаймер(пСсылка);
КонецПроцедуры

&НаКлиенте
Процедура ОстановитьТаймер(Команда)
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ОстановитьТаймерНаСервере(Объект.Ссылка);
	Иначе
		Сообщить("Задача не была сохранена, необходимо сначала сохранить.");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура JIRA_IDПриИзменении(Элемент)
	ЗаполнитьВидПоляJIRA();
КонецПроцедуры

&НаСервере
Процедура ОбновитьЗадачуИзJIRA_Сервер()
	ITC_JIRA.ОбновитьЗадачу(Объект,, Ложь);
	Модифицированность = Истина;
	ОбновитьВремя();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗадачуИзJIRA(Команда)
	Если ЗначениеЗаполнено(Объект.JIRA) Тогда
		ОбновитьЗадачуИзJIRA_Сервер();
	Иначе
		яС = Новый СообщениеПользователю;
		яС.Поле = "JIRA";
		яС.ПутьКДанным = "Объект";
		яС.Текст = "Не заполнен сервер JIRA";
		яС.Сообщить();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура JIRA_IDНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	яПодключение = JIRA_IDНажатие_Сервер();
	ЗапуститьПриложение(яПодключение.Схема + "://" + яПодключение.Сервер + "/browse/" + Объект.JIRA_ID);
КонецПроцедуры

&НаСервере
Функция JIRA_IDНажатие_Сервер()
	Возврат ITC_JIRA.ДанныеПодключения(Объект.JIRA);
КонецФункции


