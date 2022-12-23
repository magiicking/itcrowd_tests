﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Устанавливает режим автоматического удаления помеченных объектов
//
// Параметры:
// 	Изменения - Структура:
// 	* Использование - Булево - флаг использования регламентного задания
// 	* Расписание - РасписаниеРегламентногоЗадания - устанавливаемое расписание регламентного задания.
//
// Возвращаемое значение:
// 	Булево
//
Функция УстановитьРежимУдалятьПоРасписанию(Изменения) Экспорт
	
	Если Не Пользователи.ЭтоПолноправныйПользователь(,, Ложь) Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав для совершения операции.'");
	КонецЕсли;
	
	УдалятьПомеченныеОбъекты = Изменения.Использование;
	
	Отбор = Новый Структура;
	Отбор.Вставить("Метаданные", Метаданные.РегламентныеЗадания.УдалениеПомеченных);
	Задания = РегламентныеЗаданияСервер.НайтиЗадания(Отбор);
	
	Для Каждого Задание Из Задания Цикл 
		
		Параметры = Новый Структура;
		Параметры.Вставить("Использование", УдалятьПомеченныеОбъекты);
		Параметры.Вставить("Расписание", Изменения.Расписание);
		РегламентныеЗаданияСервер.ИзменитьЗадание(Задание, Параметры);
		
		Возврат Истина;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

// Возвращает расписание регламентного задания.
//
// Возвращаемое значение:
// 	Структура:
//   * ДетальныеРасписанияДня - Массив
//   * Использование - Булево
//   * РазделениеВключено - Булево
//
Функция РежимУдалятьПоРасписанию() Экспорт
	Результат = Новый Структура;
	Результат.Вставить("Использование", Ложь);
	Результат.Вставить("Расписание", ОбщегоНазначенияКлиентСервер.РасписаниеВСтруктуру(Новый РасписаниеРегламентногоЗадания()));
	Результат.Вставить("РазделениеВключено", ОбщегоНазначения.РазделениеВключено());
	
	Отбор = Новый Структура;
	Отбор.Вставить("Метаданные", Метаданные.РегламентныеЗадания.УдалениеПомеченных);
	Задания = РегламентныеЗаданияСервер.НайтиЗадания(Отбор);
	Если Задания.Количество() > 0 Тогда
		Задания = Задания[0];
		Результат.Использование = Задания.Использование;
		Если Результат.РазделениеВключено Тогда
		     Результат.Расписание = Задания.Расписание;
		Иначе	
			Результат.Расписание = РегламентныеЗаданияСервер.РасписаниеРегламентногоЗадания(Задания.УникальныйИдентификатор, Истина);
		КонецЕсли;
	КонецЕсли;
		
	Возврат Результат;

КонецФункции

// См. УдалениеПомеченныхОбъектов.ЗначениеФлажкаУдалятьПоРасписанию
// 
// Возвращаемое значение:
//   см. УдалениеПомеченныхОбъектов.ЗначениеФлажкаУдалятьПоРасписанию
//
Функция ЗначениеФлажкаУдалятьПоРасписанию() Экспорт
	Возврат УдалениеПомеченныхОбъектов.ЗначениеФлажкаУдалятьПоРасписанию();
КонецФункции

Процедура СохранитьНастройкуОтображенияПомеченныхНаУдаления(ИмяФормы, ИмяСписка, ЗначениеПометки) Экспорт
	КлючНастроек = УдалениеПомеченныхОбъектовСлужебный.КлючНастроек(ИмяФормы, ИмяСписка);
	ОбщегоНазначения.ХранилищеНастроекДанныхФормСохранить(ИмяФормы, КлючНастроек, ЗначениеПометки);
КонецПроцедуры

#КонецОбласти