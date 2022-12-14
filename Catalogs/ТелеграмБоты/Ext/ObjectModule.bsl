
Процедура ПередЗаписью(Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если НЕ ЭтоГруппа Тогда
		
		// Проверка уникальности ключа
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Запрос.УстановитьПараметр("ВебхукКлюч", ВебхукКлюч);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ТелеграмБоты.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ТелеграмБоты КАК ТелеграмБоты
		|ГДЕ
		|	ТелеграмБоты.Ссылка <> &Ссылка
		|	И ТелеграмБоты.ВебхукКлюч = &ВебхукКлюч
		|	И ТелеграмБоты.Статус = ЗНАЧЕНИЕ(Перечисление.ТелеграмСтатусыИспользования.Используется)
		|	И ТелеграмБоты.СпособПолученияОбновлений = ЗНАЧЕНИЕ(Перечисление.ТелеграмСпособыПолученияОбновлений.Вебхуки)";
		
		Результат = Запрос.Выполнить();
		Если НЕ Результат.Пустой() Тогда
			Отказ = Истина;
			Выборка = Результат.Выбрать();
			Выборка.Следующий();
			ТекстСообщения = СтрШаблон("Используемый бот с ключом %1 уже есть — %2, задайте другой ключ", ВебхукКлюч, Выборка.Ссылка);
			Сообщить(ТекстСообщения);
			Возврат;
		КонецЕсли;
	
		Если ПометкаУдаления Тогда
			Статус = Перечисления.ТелеграмСтатусыИспользования.Выключен;
		КонецЕсли;
	
		Если Статус = Перечисления.ТелеграмСтатусыИспользования.Используется Тогда
			Если СпособПолученияОбновлений = Перечисления.ТелеграмСпособыПолученияОбновлений.ПериодическийЗапрос Тогда
				Если НЕ ЗначениеЗаполнено(ИдентификаторРегламентногоЗадания) Тогда
					РегламентноеЗадание = РегламентныеЗадания.СоздатьРегламентноеЗадание(Метаданные.РегламентныеЗадания.ТелеграмПолучитьОбновленияБота);
				Иначе
					РегламентноеЗадание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторРегламентногоЗадания);
					Если РегламентноеЗадание = Неопределено Тогда
						РегламентноеЗадание = РегламентныеЗадания.СоздатьРегламентноеЗадание(Метаданные.РегламентныеЗадания.ТелеграмПолучитьОбновленияБота);
					КонецЕсли;
				КонецЕсли;
				РегламентноеЗадание.Наименование = СтрШаблон("Телеграм бот %1, получение обновлений", Лев(Наименование, 25));
				РегламентноеЗадание.ИмяПользователя = ИмяПользователяРегламентногоЗадания;
				РегламентноеЗадание.Использование = Ложь;
				РегламентноеЗадание.Записать();
				ИдентификаторРегламентногоЗадания = РегламентноеЗадание.УникальныйИдентификатор;
			Иначе
				Если ЗначениеЗаполнено(ИдентификаторРегламентногоЗадания) Тогда
					РегламентноеЗадание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторРегламентногоЗадания);
					Если РегламентноеЗадание <> Неопределено Тогда
						РегламентноеЗадание.Удалить();
					КонецЕсли;
					ИдентификаторРегламентногоЗадания = Неопределено;
				КонецЕсли;
			КонецЕсли;
		Иначе
			Если ЗначениеЗаполнено(ИдентификаторРегламентногоЗадания) Тогда
				РегламентноеЗадание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторРегламентногоЗадания);
				Если РегламентноеЗадание <> Неопределено Тогда
					РегламентноеЗадание.Удалить();
					ИдентификаторРегламентногоЗадания = Неопределено;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Если Прав(КаталогСохраненияФайлов, 1) = "\" Тогда
			КаталогСохраненияФайлов = Лев(КаталогСохраненияФайлов, СтрДлина(КаталогСохраненияФайлов) - 1);
		КонецЕсли;
		
		Если ДополнительныеСвойства.Свойство("НовоеРасписание") И ЗначениеЗаполнено(ИдентификаторРегламентногоЗадания) Тогда
			РегламентноеЗадание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторРегламентногоЗадания);
			Если РегламентноеЗадание <> Неопределено Тогда
				ЧтениеJSON = Новый ЧтениеJSON;
				ЧтениеJSON.УстановитьСтроку(ДополнительныеСвойства.НовоеРасписание);
				Расписание = СериализаторXDTO.ПрочитатьJSON(ЧтениеJSON, Тип("РасписаниеРегламентногоЗадания"));
				РегламентноеЗадание.Расписание = Расписание;
				РегламентноеЗадание.Записать();
			КонецЕсли;
		КонецЕсли;
	
		Если ДополнительныеСвойства.Свойство("СодержимоеСертификата") Тогда
			СодержимоеСертификата = Base64Значение(ДополнительныеСвойства.СодержимоеСертификата);
			PEM = Новый ХранилищеЗначения(СодержимоеСертификата);
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры


Процедура ПриЗаписи(Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Статус = Перечисления.ТелеграмСтатусыИспользования.Используется
		И СпособПолученияОбновлений = Перечисления.ТелеграмСпособыПолученияОбновлений.ПериодическийЗапрос Тогда
		РегламентноеЗадание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторРегламентногоЗадания);
		Если РегламентноеЗадание <> Неопределено Тогда
			РегламентноеЗадание.Использование = Истина;
			РегламентноеЗадание.Параметры.Очистить();
			РегламентноеЗадание.Параметры.Добавить(Ссылка);
			РегламентноеЗадание.Записать();
		КонецЕсли;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры