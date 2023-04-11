﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Процедура ПоказатьПредупреждениеМонопольногоРежимаИзменения() Экспорт
	
	ТекстВопроса = 
		НСтр("ru = 'Для изменения режима полнотекстового поиска требуется 
		           |завершение сеансов всех пользователей, кроме текущего.'");
	
	Кнопки = Новый СписокЗначений;
	Кнопки.Добавить("АктивныеПользователи", НСтр("ru = 'Активные пользователи'"));
	Кнопки.Добавить(КодВозвратаДиалога.Отмена);
	
	Обработчик = Новый ОписаниеОповещения("ПослеОтображениеПредупреждения", ЭтотОбъект);
	ПоказатьВопрос(Обработчик, ТекстВопроса, Кнопки,, "АктивныеПользователи");
	
КонецПроцедуры

Процедура ПослеОтображениеПредупреждения(Ответ, ПараметрыВыполнения) Экспорт
	
	Если Ответ = "АктивныеПользователи" Тогда
		СтандартныеПодсистемыКлиент.ОткрытьСписокАктивныхПользователей();
	КонецЕсли
	
КонецПроцедуры

#КонецОбласти