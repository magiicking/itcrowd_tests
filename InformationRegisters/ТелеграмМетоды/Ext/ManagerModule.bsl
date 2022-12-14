Процедура ЗагрузитьСлепок(ИмяСлепка, ПредварительноОчиститьРегистр = Истина) Экспорт
	
	Если ПредварительноОчиститьРегистр = Истина Тогда
		НаборЗаписей = РегистрыСведений.ТелеграмМетоды.СоздатьНаборЗаписей();
		НаборЗаписей.Записать();
	КонецЕсли;
	
	СтрокаJSON = РегистрыСведений.ТелеграмМетоды.ПолучитьМакет(ИмяСлепка).ПолучитьТекст();
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(СтрокаJSON);
	Массив = ПрочитатьJSON(ЧтениеJSON);
	Для Каждого Структура Из Массив Цикл
		МенеджерЗаписи = РегистрыСведений.ТелеграмМетоды.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Структура);
		МенеджерЗаписи.Записать();
	КонецЦикла;
	
КонецПроцедуры


Функция ВыгрузитьСлепок() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТелеграмМетоды.Метод КАК Метод,
	|	ТелеграмМетоды.Параметр КАК Параметр,
	|	ТелеграмМетоды.ОсобеннаяСборка КАК ОсобеннаяСборка,
	|	ТелеграмМетоды.Параметр1С КАК Параметр1С,
	|	ТелеграмМетоды.ОбязательныйДляЗаполнения КАК ОбязательныйДляЗаполнения,
	|	ТелеграмМетоды.ОбязательныйДляПередачи КАК ОбязательныйДляПередачи,
	|	ТелеграмМетоды.Сортировка КАК Сортировка,
	|	ТелеграмМетоды.Тип КАК Тип,
	|	ТелеграмМетоды.Описание КАК Описание
	|ИЗ
	|	РегистрСведений.ТелеграмМетоды КАК ТелеграмМетоды
	|
	|УПОРЯДОЧИТЬ ПО
	|	Метод,
	|	Сортировка";
	
	Массив = Новый Массив;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Структура = Новый Структура(
			"Метод,Параметр,ОсобеннаяСборка,Параметр1С,
			|ОбязательныйДляЗаполнения,ОбязательныйДляПередачи,Сортировка,
			|Тип,Описание");
		ЗаполнитьЗначенияСвойств(Структура, Выборка);	
		Массив.Добавить(Структура);
	КонецЦикла;
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку(ТелеграмСервер.ПараметрыЗаписиJSON());
	ЗаписатьJSON(ЗаписьJSON, Массив);
	Возврат ЗаписьJSON.Закрыть();
	
КонецФункции
