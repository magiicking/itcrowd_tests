﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Начинает интерактивное удаление помеченных объектов.
// 
// Параметры:
// 	УдаляемыеОбъекты - Массив из ЛюбаяСсылка - перечень удаляемых объектов.
// 	ПараметрыУдаления - см. ПараметрыИнтерактивногоУдаления
// 		
// 	Владелец - ФормаКлиентскогоПриложения
// 	         - Неопределено - форма, из которой начата операция удаления.
// 														  Если не указан, то в обработку оповещения о закрытии
// 														  не будет передана подробная информация об итогах удаления.
// 														   
// 	ОписаниеОповещенияОЗакрытии - ОписаниеОповещения - если указано, то при окончании удаления или
//														  при закрытии формы в обработку оповещения будет передан результат
//														  с полями:
//														  * Успешно - Булево - Истина, если все объекты удалены успешно.
//														  * УдаленныеКоличество - Число - количество удаленных объектов.
//														  * НеУдаленныеКоличество - Число - количество неудаленных объектов.
//														  * АдресРезультата - Строка - адрес временного хранилища.
//								- Неопределено - значение по умолчанию.
//
Процедура НачатьУдалениеПомеченных(УдаляемыеОбъекты, ПараметрыУдаления = Неопределено, Владелец = Неопределено,
	ОписаниеОповещенияОЗакрытии = Неопределено) Экспорт

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("УдаляемыеОбъекты", УдаляемыеОбъекты);
	ПараметрыФормы.Вставить("РежимУдаления", "Стандартный");
	Если ПараметрыУдаления <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ПараметрыФормы, ПараметрыУдаления);
	КонецЕсли;
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("НачатьУдалениеПомеченныхЗавершение"
		, ЭтотОбъект, Новый Структура("ОповещениеОЗакрытии", ОписаниеОповещенияОЗакрытии));
		
	ОткрытьФорму("Обработка.УдалениеПомеченныхОбъектов.Форма", ПараметрыФормы, Владелец, , , , ОповещениеОЗакрытии,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

// Настройки интерактивного удаления.
// 
// Возвращаемое значение:
// 	Структура:
// 	* Режим - Строка -  способ удаления, может принимать значения:
//		"Стандартный" - удаление объектов с контролем ссылочной целостности и сохранением возможности 
//					  многопользовательской работы.
//		"Монопольный" - удаление объектов с контролем ссылочной целостности с установкой монопольного режима.
//		"Упрощенный"  - удаление объектов, при котором контроль ссылочной целостности выполняется только в непомеченных
//					  на удаление объектах. В помеченных на удаление объектах ссылки на удаляемые объекты 
//					  будут очищены.
//
Функция ПараметрыИнтерактивногоУдаления() Экспорт
	Параметры = Новый Структура;
	Параметры.Вставить("Режим", "Стандартный");
	Возврат Параметры;
КонецФункции

#Область ПрограммныйИнтерфейсФорм

// Открывает рабочее место Удаление помеченных.
//  
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения
// 	ТаблицаФормы - ТаблицаФормы
// 	             - ДанныеФормыСтруктура
// 	             - Неопределено - таблица формы, связанная с динамическим списком
//
Процедура ПерейтиКПомеченнымНаУдаление(Форма, ТаблицаФормы = Неопределено) Экспорт
	
	Если ТаблицаФормы <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.ПроверитьПараметр("ПерейтиКПомеченнымНаУдаление", "ТаблицаФормы", ТаблицаФормы, Новый ОписаниеТипов("ТаблицаФормы"));
		
		ТипыМетаданных = Форма.ПараметрыУдаленияПомеченных[ТаблицаФормы.Имя].ТипыМетаданных;
		ПараметрыОткрытия = Новый Структура();
		ПараметрыОткрытия.Вставить("ОтборМетаданных", ТипыМетаданных);
	КонецЕсли;
	
	ОткрытьФорму("Обработка.УдалениеПомеченныхОбъектов.Форма.ОсновнаяФорма", ПараметрыОткрытия, Форма);
КонецПроцедуры

// Изменяет видимость помеченных на удаление и сохраняет настройку пользователя.
// 
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения
// 	ТаблицаФормы - ТаблицаФормы - таблица формы, связанная с динамическим списком.
// 	КнопкаФормы - КнопкаФормы - кнопка формы, связанная с командой Показать помеченные на удаление.
//
Процедура ПоказатьПомеченныеНаУдаление(Форма, ТаблицаФормы, КнопкаФормы) Экспорт
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр("ПоказатьПомеченныеНаУдаление", "ТаблицаФормы", ТаблицаФормы, Новый ОписаниеТипов("ТаблицаФормы"));
	НовоеЗначениеОтбора = ИзменитьОтборПомеченныхНаУдаление(Форма, ТаблицаФормы);
	КнопкаФормы.Пометка = НЕ НовоеЗначениеОтбора;
КонецПроцедуры

// Открывает форму для изменения расписания регламентного задания.
// Если расписание задано, то будет включено регламентное задание с установленным расписанием. 
// 
// Не поддерживается на мобильном платформе.
// 
// Параметры:
// 	ОповещениеОбИзменении - ОписаниеОповещения - обработчик изменения расписания регламентного задания.
//
Процедура НачатьИзменениеРасписанияРегламентногоЗадания(ОповещениеОбИзменении = Неопределено) Экспорт
	СведенияОРегламентномЗаданииУдаленияПомеченных = УдалениеПомеченныхОбъектовСлужебныйВызовСервера.РежимУдалятьПоРасписанию();
	Обработчик = Новый ОписаниеОповещения("РегламентныеЗаданияПослеИзмененияРасписания", ЭтотОбъект,
			Новый Структура("ОповещениеОбИзменении, СтароеРасписание", ОповещениеОбИзменении, СведенияОРегламентномЗаданииУдаленияПомеченных.Расписание));
	
	Если СведенияОРегламентномЗаданииУдаленияПомеченных.РазделениеВключено Тогда
		Результат = Новый Структура("Использование,Расписание");
		ЗаполнитьЗначенияСвойств(Результат, СведенияОРегламентномЗаданииУдаленияПомеченных);
		ВыполнитьОбработкуОповещения(Обработчик, СведенияОРегламентномЗаданииУдаленияПомеченных.Расписание);
	Иначе		
		ОписаниеРегламентногоЗадания = СведенияОРегламентномЗаданииУдаленияПомеченных.Расписание;
		Расписание = Новый РасписаниеРегламентногоЗадания;
		ЗаполнитьЗначенияСвойств(Расписание, ОписаниеРегламентногоЗадания);
		// АПК: 574 - выкл Процедура не поддерживается на мобильном клиенте.
		Диалог = Новый ДиалогРасписанияРегламентногоЗадания(Расписание);
		// АПК: 574 - вкл
		Диалог.Показать(Обработчик);
	КонецЕсли;
КонецПроцедуры

// Обработчик события ПриИзменении для флажка, выполняющего переключение режима автоматического удаления объектов.
// 
// Параметры:
//   АвтоматическиУдалятьПомеченныеОбъекты  - Булево - новое значение флажка, которое требуется обработать.
//   ОповещениеОбИзменении - ОписаниеОповещения - если ЗначениеФлажкаАвтоматическиУдалятьПомеченныеОбъекты = Истина, то процедура
//   											  будет вызвана после выбора расписания регламентного задания.
//   											  Если ЗначениеФлажкаАвтоматическиУдалятьПомеченныеОбъекты = Ложь, то процедура будет 
//   											  вызвана сразу же. 
// 
// Пример:
//	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.УдалениеПомеченныхОбъектов") Тогда
//		МодульУдалениеПомеченныхОбъектовКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УдалениеПомеченныхОбъектовКлиент");
//		МодульУдалениеПомеченныхОбъектовКлиент.ПриИзмененииФлажкаУдалятьПоРасписанию(АвтоматическиУдалятьПомеченныеОбъекты);
//	КонецЕсли;
//
Процедура ПриИзмененииФлажкаУдалятьПоРасписанию(АвтоматическиУдалятьПомеченныеОбъекты, ОповещениеОбИзменении = Неопределено) Экспорт
	ТекущиеПараметрыРегламентногоЗадания = УдалениеПомеченныхОбъектовСлужебныйВызовСервера.РежимУдалятьПоРасписанию();
	Изменения = Новый Структура("Расписание", ТекущиеПараметрыРегламентногоЗадания.Расписание);
	Изменения.Вставить("Использование", АвтоматическиУдалятьПомеченныеОбъекты);
	УдалениеПомеченныхОбъектовСлужебныйВызовСервера.УстановитьРежимУдалятьПоРасписанию(Изменения);

	Если ОповещениеОбИзменении <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ОповещениеОбИзменении, Изменения);
	КонецЕсли;
	
	// Сохранение обратной совместимости с 3.1.2
	Оповестить("ИзменилсяРежимАвтоматическиУдалятьПомеченныеОбъекты");
КонецПроцедуры

#КонецОбласти

// Обработчик события ОбработкаОповещения для формы, на которой требуется отобразить флажок удаления по расписанию.
//
// Параметры:
//   ИмяСобытия - Строка - имя события, которое было получено обработчиком события на форме.
//   АвтоматическиУдалятьПомеченныеОбъекты - Булево - реквизит, в которое будет помещено значение.
// 
// Пример:
//	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.УдалениеПомеченныхОбъектов") Тогда
//		МодульУдалениеПомеченныхОбъектовКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УдалениеПомеченныхОбъектовКлиент");
//		МодульУдалениеПомеченныхОбъектовКлиент.ОбработкаОповещенияИзмененияФлажкаУдалятьПоРасписанию(
//			ИмяСобытия, 
//			АвтоматическиУдалятьПомеченныеОбъекты);
//	КонецЕсли;
//
Процедура ОбработкаОповещенияИзмененияФлажкаУдалятьПоРасписанию(Знач ИмяСобытия,
		АвтоматическиУдалятьПомеченныеОбъекты) Экспорт

	Если ИмяСобытия = "ИзменилсяРежимАвтоматическиУдалятьПомеченныеОбъекты" Тогда
		АвтоматическиУдалятьПомеченныеОбъекты = УдалениеПомеченныхОбъектовСлужебныйВызовСервера.ЗначениеФлажкаУдалятьПоРасписанию();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Обработчик подключенной команды.
//
// Параметры:
//   МассивСсылок - Массив Из ЛюбаяСсылка - ссылки выбранных объектов, для которых выполняется команда.
//   ПараметрыКоманды - см. ПодключаемыеКомандыКлиент.ПараметрыВыполненияКоманды
//
Процедура ВыполнитьПодключаемуюКомандуПоказатьПомеченныеНаУдаление(Знач МассивСсылок,
		ПараметрыКоманды) Экспорт
	НовоеЗначениеОтбора = ИзменитьОтборПомеченныхНаУдаление(ПараметрыКоманды.Форма, ПараметрыКоманды.Источник);
	УдалениеПомеченныхОбъектовСлужебныйВызовСервера.СохранитьНастройкуОтображенияПомеченныхНаУдаления(ПараметрыКоманды.Форма.ИмяФормы, ПараметрыКоманды.Источник.Имя, НовоеЗначениеОтбора);
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиентСервер = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиентСервер");
		МодульПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ПараметрыКоманды.Форма, ПараметрыКоманды.Источник);
	КонецЕсли;
КонецПроцедуры

// Обработчик подключенной команды.
//
// Параметры:
//   МассивСсылок - Массив Из ЛюбаяСсылка - ссылки выбранных объектов, для которых выполняется команда.
//   ПараметрыВыполнения - см. ПодключаемыеКомандыКлиент.ПараметрыВыполненияКоманды
//
Процедура ВыполнитьПодключаемуюКомандуПерейтиКПомеченным(МассивСсылок, ПараметрыВыполнения) Экспорт
	ПерейтиКПомеченнымНаУдаление(ПараметрыВыполнения.Форма, ПараметрыВыполнения.Источник);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура НачатьУдалениеПомеченныхЗавершение(Знач РезультатУдаления, ДополнительныеПараметры) Экспорт
	Если РезультатУдаления = Неопределено И НЕ ДополнительныеПараметры.Свойство("РезультатЗакрытия") Тогда
		Возврат;
	КонецЕсли;
		
	Если РезультатУдаления = Неопределено Тогда
		РезультатУдаления = ДополнительныеПараметры.РезультатЗакрытия;
	КонецЕсли;	
		
	Если ДополнительныеПараметры.ОповещениеОЗакрытии <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеОЗакрытии, РезультатУдаления);
	КонецЕсли;
КонецПроцедуры

Процедура РегламентныеЗаданияПослеИзмененияРасписания(Расписание, ПараметрыВыполнения) Экспорт
	Если Расписание = Неопределено Тогда
		Расписание = ПараметрыВыполнения.СтароеРасписание;
		УдалениеПомеченныхИспользование = Ложь;
	Иначе
		УдалениеПомеченныхИспользование = Истина;
		Изменения = Новый Структура("Расписание", Расписание);
		Изменения.Вставить("Использование", Истина);
		УдалениеПомеченныхОбъектовСлужебныйВызовСервера.УстановитьРежимУдалятьПоРасписанию(Изменения);
	КонецЕсли;
	
	Оповестить("ИзменилсяРежимАвтоматическиУдалятьПомеченныеОбъекты");
	
	Если ПараметрыВыполнения.Свойство("ОповещениеОбИзменении") И ПараметрыВыполнения.ОповещениеОбИзменении <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ПараметрыВыполнения.ОповещениеОбИзменении,
			Новый Структура("Использование, Расписание", УдалениеПомеченныхИспользование, Расписание));
	КонецЕсли;
КонецПроцедуры

// Изменяет видимость помеченных на удаление в списке
// 
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения
// 	ТаблицаФормы - ТаблицаФормы
// Возвращаемое значение:
// 	Булево - установленное значение отбора
//
Функция ИзменитьОтборПомеченныхНаУдаление(Форма, ТаблицаФормы)
	
	Настройка = Форма.ПараметрыУдаленияПомеченных[ТаблицаФормы.Имя];
	НовоеЗначениеОтбора = НЕ Настройка.ЗначениеОтбора;
	УдалениеПомеченныхОбъектовСлужебныйКлиентСервер.УстановитьОтборПоПометкеУдаления(Форма[Настройка.ИмяСписка], НовоеЗначениеОтбора);
	Настройка.ЗначениеОтбора = НовоеЗначениеОтбора;
	Настройка.ЗначениеПометки = НЕ НовоеЗначениеОтбора;
	УдалениеПомеченныхОбъектовСлужебныйВызовСервера.СохранитьНастройкуОтображенияПомеченныхНаУдаления(Форма.ИмяФормы, ТаблицаФормы.Имя, НовоеЗначениеОтбора);
	Возврат НовоеЗначениеОтбора;
	
КонецФункции

#КонецОбласти

