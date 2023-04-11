﻿#Область ПрограммныйИнтерфейс
// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати – ТаблицаЗначений – состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
КонецПроцедуры
#КонецОбласти

Функция НачатьРаботыПоНаряду(Номер, Пользователь) Экспорт
	
	Результат = новый Структура;
	Результат.Вставить("Успешно", Истина);
	Результат.Вставить("Причина","");
	
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Наряд.Ссылка КАК Ссылка,
	|	Наряд.ДокументОснование.Клиент КАК Клиент,
	|	Наряд.ДокументОснование.Тема КАК Тема,
	|   Наряд.ФактическоеНачало
	|ИЗ
	|	Документ.Наряд КАК Наряд
	|ГДЕ
	|	Наряд.Ответственный = &Пользователь
	|	И Наряд.ФактическоеНачало <> &ПустаяДата
	|	И Наряд.ФактическоеОкончание = &ПустаяДата";
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	Запрос.УстановитьПараметр("ПустаяДата",'00010101');
	АктивныеНаряды = Запрос.Выполнить().выгрузить();
	Если АктивныеНаряды.Количество() > 0 Тогда
		Результат.Успешно = Ложь;
		Результат.Причина = "Нельзя начинать работу над новым нарядом, если не завершена работа по предыдущему
		|В работе на данный момент наряд по клиенту: "+АктивныеНаряды[0].Клиент+"
		|По задаче: "+АктивныеНаряды[0].Тема+"
		|Начат: "+АктивныеНаряды[0].ФактическоеНачало+"";
		Возврат Результат;
	КонецЕсли;
	
	Наряд = Документы.РегистрацияВремени.НайтиПоНомеру(Номер);
	
	Если Наряд.Пустая() Тогда
		Результат.Успешно = Ложь;
		Результат.Причина = "Наряда с номером "+Номер+" найти в базе не удалось";
		Возврат Результат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Наряд.ФактическоеНачало) Тогда
		Результат.Успешно = Ложь;
		Результат.Причина = "Наряд № "+Номер+" был начат в раньше: "+Наряд.ФактическоеНачало;
		Возврат Результат;
	КонецЕсли;
	
	
	НарядОбъект = Наряд.ПолучитьОбъект();	
	НарядОбъект.ФактическоеНачало = ТекущаяДата();
	НарядОбъект.Записать();
	Возврат Результат;
	
КонецФункции

Функция ЗакрытьНаряд(Данные) Экспорт
	
	ЧтоСделано = Данные.КонтекстСеанса[ПланыВидовХарактеристик.ТелеграмПараметрыКонтекста.Наряд_ЧтоСделано];
	НомерНаряда = Данные.КонтекстСеанса[ПланыВидовХарактеристик.ТелеграмПараметрыКонтекста.Наряд_Номер];
	ЧасыКЗакрытию = Данные.КонтекстСеанса[ПланыВидовХарактеристик.ТелеграмПараметрыКонтекста.Наряд_ЧасыКЗакрытию];
	
	Результат = Новый Структура;
	Результат.Вставить("Успешно",Истина);
	Результат.Вставить("Описание","");
	
	Наряд = Документы.РегистрацияВремени.НайтиПоНомеру(НомерНаряда);
	Если Наряд.Пустая() Тогда
		Результат.Успешно = Ложь;
		Результат.Описание = "Наряд с номером "+НомерНаряда+" найти не удалоось";
		
		Возврат Результат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Наряд.ФактическоеОкончание) тогда
		Результат.Успешно = Ложь;
		Результат.Описание = "Наряд "+НомерНаряда+" уже был завершен ранее: "+Наряд.ФактическоеОкончание;
		Возврат Результат;
	КонецЕсли;
	
	ОбъектНаряд = Наряд.ПолучитьОбъект();
	ЗаписьВремени = ОбъектНаряд.РабочееВремя.Добавить();
	ЗаписьВремени.Дата = ТекущаяДата();
	ЗаписьВремени.Комментарий =   ЧтоСделано;
	ЗаписьВремени.Отчет = Число(ЧасыКЗакрытию);
	
	ОбъектНаряд.ФактическоеОкончание = ТекущаяДата();
	ОбъектНаряд.Записать();
	
	Задача = ОбъектНаряд.ДокументОснование;
	ИнформацияОФайле = Новый Структура();
	ИнформацияОФайле.Вставить("Автор", Данные.Пользователь);
	ИнформацияОФайле.Вставить("ВладелецФайлов", Задача);
	ФайлНаДиске = Новый Файл(Данные.ЗагруженныйФайл);
	ИнформацияОФайле.Вставить("ИмяБезРасширения", ФайлНаДиске.ИмяБезРасширения);
	ИнформацияОФайле.Вставить("РасширениеБезТочки", ФайлНаДиске.Расширение);
	ИнформацияОФайле.Вставить("ВремяИзмененияУниверсальное", ОбъектНаряд.ФактическоеОкончание);	
	
	ДвоичныеДанные = Новый ДвоичныеДанные(Данные.ЗагруженныйФайл);
	АдресФайлаВоВременномХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанные);
	РаботаСФайлами.ДобавитьФайл(ИнформацияОФайле,АдресФайлаВоВременномХранилище);
	
	
	Возврат Результат;
	
КонецФункции