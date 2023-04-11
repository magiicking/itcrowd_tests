﻿&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Объект.ПрограммнаяПроверка Тогда
		ОбновитьКодПроверкиХТМЛ();
	КонецЕсли;
	
	Если Объект.Контекст.Количество() > 0 Тогда
	ИначеЕсли Объект.Условия.Количество() > 0 Тогда
		Элементы.СтраницаУсловия.ТекущаяСтраница = Элементы.СтраницаСодержаниеОбновления;
	ИначеЕсли Объект.ПрограммнаяПроверка Тогда
		Элементы.СтраницаУсловия.ТекущаяСтраница = Элементы.СтраницаПрограммнаяПроверка;
	КонецЕсли;
	
	УстановитьВидимостьДоступность();
	
КонецПроцедуры


&НаКлиенте
Процедура УстановитьВидимостьДоступность()
	
	Элементы.СтраницаПрограммнаяПроверка.Видимость = Объект.ПрограммнаяПроверка;
	Элементы.СтраницаПрограммнаяПроверкаРедактирование.Видимость = Объект.ПрограммнаяПроверка;
	
КонецПроцедуры


&НаКлиенте
Процедура ПрограммнаяПроверкаПриИзменении(Элемент)
	
	УстановитьВидимостьДоступность();
	
КонецПроцедуры


&НаКлиенте
Процедура СтраницаУсловияПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Если ТекущаяСтраница = Элементы.СтраницаПрограммнаяПроверка Тогда
		
		ОбновитьКодПроверкиХТМЛ();
		
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ОбновитьКодПроверкиХТМЛ()
	
	ТелеграмКлиент.ОбновитьКодСборкиОтветаHTML(ЭтаФорма, "КодПроверкиHTML", "КодПроверки");
	КодПроверкиХТМЛДокументСформирован(Элементы.КодПроверкиHTML);
	
КонецПроцедуры


&НаКлиенте
Процедура КодПроверкиХТМЛДокументСформирован(Элемент)
	
	Пока СписокКоманд.Количество() > 0 Цикл
		Если ТипЗнч(Элемент.Документ) = Тип("Неопределено") Тогда
			Возврат;
		КонецЕсли;
		Если Элемент.Документ.readyState <> "complete" Тогда
			Возврат;
		КонецЕсли;
		Команда = СписокКоманд.Получить(0).Значение[0];
		Если Команда = "РаскрашиваемТекст" Тогда
			Элемент.Документ.body.innerHTML = СписокКоманд.Получить(0).Значение[1];
		ИначеЕсли Команда = "ИзменитьСтили" Тогда
			// Получим стили HTML документа
			КоллекцияСтилей = Элемент.Документ.styleSheets;
			// Ситуация, когда стилей больше одного, не обрабатывается
			Если КоллекцияСтилей.length >= 1 Тогда 
				// Изменяем стиль на подготовленный
				Стили = КоллекцияСтилей.item(0);
				Стили.cssText = ТелеграмКлиент.ВернутьСтиль();
			Иначе
				Если КоллекцияСтилей.length = 0 Тогда
					
					НовыйСтиль = Элемент.Документ.createElement("style");
					НовыйСтиль.type = "text/css";
    				НовыйСтиль.innerText = ТелеграмКлиент.ВернутьСтиль();
    				Элемент.Документ.head.appendChild(НовыйСтиль);
					
					//НовыйСтиль = Элемент.Документ.createStyleSheet(, 0);
					//НовыйСтиль.cssText = ТелеграмКлиент.ВернутьСтиль();
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		СписокКоманд.Удалить(0);
	КонецЦикла
	
КонецПроцедуры


&НаКлиенте
Процедура ВставитьКомментарий(Команда)
	
	МаксимальныйКомментарий = 
	"// При формировании сообщения доступна структура НакопленныеДанные
	|// Ключи структуры:
	|// НакопленныеДанные.ДанныеБота.Бот — текущий бот, <СправочникСсылка.ТелеграмБоты>
	|// НакопленныеДанные.ДанныеБота.Жетон — жетон бота, <строка>
	|// НакопленныеДанные.ДанныеБота.Имя — представление бота, <Строка>
	|// НакопленныеДанные.ДанныеБота.Смещение — последний обработанный ботом идентификатор обновления, <Число>
	|// НакопленныеДанные.ИдентификаторОбновления — идентификатор текущего обновления, <число>
	|// НакопленныеДанные.ИдентификаторСообщения — идентификатр сообщения, <число>
	|// НакопленныеДанные.ИдентификаторЧата — идентификатор чата, <число>
	|// НакопленныеДанные.ВидВходящегоОбновления - вид входящего обновления, определямый на основании содержания обновления, <Перечисления.ТелеграмВидыВходящихОбновлений> (чаще всего Сообщение)
	|// НакопленныеДанные.Обновление — обрабатываемое обновление https://core.telegram.org/bots/api#update, <ОбъектXDTO>
	|// НакопленныеДанные.Сообщение — сообщение, https://core.telegram.org/bots/api#message, <ОбъектXDTO> или НЕОПРЕДЕЛЕНО
	|// НакопленныеДанные.ТекстСообщения  — текст сообщения, <строка> или НЕОПРЕДЕЛЕНО
	|// НакопленныеДанные.НастройкиПользователя - структура с настройками пользователя из регистра сведений ТелеграмНастройкиПользователя
	|// НакопленныеДанные.ОтветКонтекстнойКлавиатуры — ответ контекстной клавиатуры, если ВидВходящегоОбновления = Перечисления.ТелеграмВидыВходящихОбновлений.ОтветКонтекстнойКлавиатуры, <строка> или НЕОПРЕДЕЛЕНО
	|// 
	|// 
	|// Результат проверки должен возвращаться в переменную Ответ, <Булево>
	|// 
	|// 
	|";
	
	Объект.КодПроверки = МаксимальныйКомментарий + Объект.КодПроверки;
	
КонецПроцедуры