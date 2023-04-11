﻿//начало текста модуля
#Область Служебные_функции_и_процедуры

&НаКлиенте
// контекст фреймворка Vanessa-Behavior
Перем Ванесса;
 
&НаКлиенте
// Структура, в которой хранится состояние сценария между выполнением шагов. Очищается перед выполнением каждого сценария.
Перем Контекст Экспорт;
 
&НаКлиенте
// Структура, в которой можно хранить служебные данные между запусками сценариев. Существует, пока открыта форма Vanessa-Behavior.
Перем КонтекстСохраняемый Экспорт;

// Делает отключение модуля
&НаКлиенте
Функция ОтключениеМодуля() Экспорт

	Ванесса = Неопределено;
	Контекст = Неопределено;
	КонтекстСохраняемый = Неопределено;

КонецФункции

&НаКлиенте
// Функция экспортирует список шагов, которые реализованы в данной внешней обработке.
Функция ПолучитьСписокТестов(КонтекстФреймворкаBDD) Экспорт
	Ванесса = КонтекстФреймворкаBDD;
	
	ВсеТесты = Новый Массив;

	//описание параметров
	//Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,Снипет,ИмяПроцедуры,ПредставлениеТеста,ОписаниеШага,ТипШага,Транзакция,Параметр);

	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯОткрываюФормуДокументаЗаполненногоНаОснованииПроведенногоНомерОт(Парам01,Парам02,Парам03,Парам04)","ЯОткрываюФормуДокументаЗаполненногоНаОснованииПроведенногоНомерОт","Когда Я открываю форму документа ""АвтоВзаимозачет"" заполненного на основании проведенного ""ПоступлениеАвтомобилей"" номер ""АИ00000002"" от ""12.03.2017""","Открытие формы на основании проведенного документа","UI.Формы.Ввод на основании");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯОткрываюФормуДокументаЗаполненногоНаОснованииПроведенного(Парам01,Парам02)","ЯОткрываюФормуДокументаЗаполненногоНаОснованииПроведенного","И я открываю форму документа ""АвтоВзаимозачет"" заполненного на основании проведенного ""ПоступлениеАвтомобилей""","Открытие формы на основании проведенного документа","UI.Формы.Ввод на основании");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯОткрываюФормуДокументаЗаполненногоНаОснованииНеПроведенногоНомерОт(Парам01,Парам02,Парам03,Парам04)","ЯОткрываюФормуДокументаЗаполненногоНаОснованииНеПроведенногоНомерОт","Когда Я открываю форму документа ""АвтоВзаимозачет"" заполненного на основании не проведенного ""ПоступлениеАвтомобилей"" номер ""АВ00000080"" от ""04.09.2016""","Открытие формы на основании не проведенного документа","UI.Формы.Ввод на основании");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯОткрываюФормуДокументаЗаполненногоНаОснованииНеПроведенного(Парам01,Парам02)","ЯОткрываюФормуДокументаЗаполненногоНаОснованииНеПроведенного","И я открываю форму документа ""АвтоВзаимозачет"" заполненного на основании не проведенного ""ПоступлениеАвтомобилей""","Открытие формы на основании не проведенного документа","UI.Формы.Ввод на основании");

	Возврат ВсеТесты;
КонецФункции
	
&НаСервере
// Служебная функция.
Функция ПолучитьМакетСервер(ИмяМакета)
	ОбъектСервер = РеквизитФормыВЗначение("Объект");
	Возврат ОбъектСервер.ПолучитьМакет(ИмяМакета);
КонецФункции
	
&НаКлиенте
// Служебная функция для подключения библиотеки создания fixtures.
Функция ПолучитьМакетОбработки(ИмяМакета) Экспорт
	Возврат ПолучитьМакетСервер(ИмяМакета);
КонецФункции

#КонецОбласти



#Область Работа_со_сценариями

&НаКлиенте
// Функция выполняется перед началом каждого сценария
Функция ПередНачаломСценария() Экспорт
	
КонецФункции

&НаКлиенте
// Функция выполняется перед окончанием каждого сценария
Функция ПередОкончаниемСценария() Экспорт
	
КонецФункции

#КонецОбласти


///////////////////////////////////////////////////
//Реализация шагов
///////////////////////////////////////////////////

&НаКлиенте
//Когда открываю форму документа "АвтоВзаимозачет" заполненного на основании проведенного "ПоступлениеАвтомобилей" номер "АИ00000002" от "12.03.2017"
//@ОткрываюФормуДокументаЗаполненногоНаОснованииПроведенногоНомерОт(Парам01,Парам02,Парам03,Парам04)
Функция ЯОткрываюФормуДокументаЗаполненногоНаОснованииПроведенногоНомерОт(ИмяДокумента, ДокументОснование,НомерДокумента,ДатаДокумента) Экспорт
	ПроверитьОткрытиеФормыНаОсновании(ИмяДокумента, ДокументОснование, Истина, НомерДокумента, ДатаДокумента);
КонецФункции

&НаКлиенте
//И     открываю форму документа "АвтоВзаимозачет" заполненного на основании проведенного "ПоступлениеАвтомобилей"
//@ОткрываюФормуДокументаЗаполненногоНаОснованииПроведенного(Парам01,Парам02)
Функция ЯОткрываюФормуДокументаЗаполненногоНаОснованииПроведенного(ИмяДокумента, ДокументОснование) Экспорт
	ПроверитьОткрытиеФормыНаОсновании(ИмяДокумента, ДокументОснование, Истина, Неопределено, Неопределено);
КонецФункции

&НаКлиенте
//Когда открываю форму документа "АвтоВзаимозачет" заполненного на основании не проведенного "ПоступлениеАвтомобилей" номер "АВ00000080" от "04.09.2016"
//@ОткрываюФормуДокументаЗаполненногоНаОснованииНеПроведенногоНомерОт(Парам01,Парам02,Парам03,Парам04)
Функция ЯОткрываюФормуДокументаЗаполненногоНаОснованииНеПроведенногоНомерОт(ИмяДокумента, ДокументОснование,НомерДокумента,ДатаДокумента) Экспорт
	ПроверитьОткрытиеФормыНаОсновании(ИмяДокумента, ДокументОснование, Ложь, НомерДокумента, ДатаДокумента);
КонецФункции

&НаКлиенте
//И     открываю форму документа "АвтоВзаимозачет" заполненного на основании не проведенного "ПоступлениеАвтомобилей"
//@ОткрываюФормуДокументаЗаполненногоНаОснованииНеПроведенного(Парам01,Парам02)
Функция ЯОткрываюФормуДокументаЗаполненногоНаОснованииНеПроведенного(ИмяДокумента, ДокументОснование) Экспорт
	ПроверитьОткрытиеФормыНаОсновании(ИмяДокумента, ДокументОснование, Ложь, Неопределено, Неопределено);
КонецФункции

&НаКлиенте
Функция ПроверитьОткрытиеФормыНаОсновании(ИмяДокумента, ДокументОснование, Проведен, НомерДокумента = Неопределено, ДатаДокумента = Неопределено)

	Если ДатаДокумента <> Неопределено Тогда
		ДатаДокумента = Сред(ДатаДокумента, 7, 4) + Сред(ДатаДокумента, 4, 2) + Сред(ДатаДокумента, 1, 2);
	КонецЕсли;
	
	Основание = ПолучитьСсылкуНаДокументОснование(ДокументОснование, Проведен, НомерДокумента, ДатаДокумента);
	
	Если Основание = Неопределено Тогда
		ТекстСообщения = Ванесса.ПолучитьТекстСообщенияПользователю("Для <%1> не найдено документа основания");
		ТекстСообщения = СтрЗаменить(ТекстСообщения,"%1",ИмяДокумента); 
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("Основание", Основание);
	ПолноеИмяФормы = "Документ." + ИмяДокумента + ".ФормаОбъекта";
	ТестироватьФорму(ПолноеИмяФормы, ПараметрыФормы);

КонецФункции // ПроверитьОткрытиеФормыНаОсновании()

&НаСервереБезКонтекста
Функция ПолучитьСсылкуНаДокументОснование(ДокументОснование, Проведен, НомерДокумента, ДатаДокумента)

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	#Док.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.#Док КАК #Док
		|ГДЕ
		|	НЕ #Док.ПометкаУдаления
		|	И #Док.Проведен = &Проведен
		|	#ЕстьНомерДата
		|
		|УПОРЯДОЧИТЬ ПО
		|	#Док.Дата УБЫВ";
		
	Если НомерДокумента <> Неопределено И ДатаДокумента <> Неопределено Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "#ЕстьНомерДата", "И #Док.Номер = &Номер И #Док.Дата  = &Дата"); 
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "#ЕстьНомерДата", "");
	КонецЕсли;
	Запрос.УстановитьПараметр("Проведен",  Проведен);
	Запрос.УстановитьПараметр("Номер",     НомерДокумента);
	Запрос.УстановитьПараметр("Дата",      ДатаДокумента);
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "#Док", ДокументОснование);
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	Если РезультатЗапроса.Количество() = 0 Тогда
		Если НомерДокумента <> Неопределено И ДатаДокумента <> Неопределено Тогда
			Возврат ПолучитьСсылкуНаДокументОснование(ДокументОснование, Проведен, Неопределено, Неопределено);
		Иначе
			Возврат Неопределено;
		КонецЕсли;
	Иначе
		Возврат РезультатЗапроса[0].Ссылка;
	КонецЕсли;

КонецФункции // ПолучитьСсылкуНаДокументОснование()

// заимствовона из плагина дымовых тестов xUnit
&НаКлиенте
Функция ТестироватьФорму(ПолноеИмяФормы, ПараметрыФормы) Экспорт
	
	КлючВременнойФормы = "908насмь9ыв3245";
	//Если Модально Тогда
	//	ТестируемаяФорма = ОткрытьФормуМодально(ПолноеИмяФормы, ПараметрыФормы);
	//Иначе
		//ошибка ="";
		//Попытка
		
		// К сожалению здесь исключения не ловятся https://github.com/xDrivenDevelopment/xUnitFor1C/issues/154
		ТестируемаяФорма = ОткрытьФорму(ПолноеИмяФормы, ПараметрыФормы,, КлючВременнойФормы);
		
		//Исключение
		//	ошибка = ОписаниеОшибки();
		//	Предупреждение(" поймали исключение 20" + ошибка);
		//КонецПопытки;
	//КонецЕсли;
	Если ТестируемаяФорма = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	//ТестируемаяФорма.Открыть(); // К сожалению здесь исключения не ловятся http://partners.v8.1c.ru/forum/thread.jsp?id=1080350#1080350
	Если ТестируемаяФорма.Открыта() = Ложь Тогда 
		ТекстСообщения = Ванесса.ПолучитьТекстСообщенияПользователю("ТестируемаяФорма <%1> не открылась, а должна была открыться"); 
		ТекстСообщения = СтрЗаменить(ТекстСообщения,"%1",ПолноеИмяФормы); 
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
		
	Если ТипЗнч(ТестируемаяФорма) = Тип("УправляемаяФорма") Тогда
		ТестируемаяФорма.ОбновитьОтображениеДанных();
	Иначе
			//Если ЭтоОбычнаяФорма(ТестируемаяФорма) Тогда
		ТестируемаяФорма.Обновить();
	КонецЕсли;
	
	ЗакрытьФорму(ТестируемаяФорма);

КонецФункции

&НаСервере
Функция ЗавершитьТранзакцию()

	Если ТранзакцияАктивна() Тогда
		ОтменитьТранзакцию();
	КонецЕсли;

КонецФункции

&НаКлиенте
Функция ЗакрытьФорму(ТестируемаяФорма)
	//Если ТипЗнч(ТестируемаяФорма) <> Тип("Форма") и ТипЗнч(ТестируемаяФорма) <> Тип("УправляемаяФорма") Тогда
	Если ТипЗнч(ТестируемаяФорма) <> Тип("УправляемаяФорма") Тогда
		Возврат Неопределено;
	КонецЕсли; 
	ТестируемаяФорма.Модифицированность = Ложь;
	Если ТестируемаяФорма.Открыта() Тогда
		ТестируемаяФорма.Модифицированность = Ложь;
		//Попытка
			ТестируемаяФорма.Закрыть();
		//Исключение
		//	Ошибка = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		//	ЗакрытьФормуБезусловноСОтменойТранзакции(ТестируемаяФорма);
		//	//Если ТранзакцияАктивна() Тогда
		//	//	ОтменитьТранзакцию();
		//	//КонецЕсли;
		//	//	//ДобавитьСтрокуРезультата(ИмяОперации, ИнформацияОбОшибке());
		//	//НачатьТранзакцию();
		//	//ТестируемаяФорма.УстановитьДействие("ПередЗакрытием", Неопределено);
		//	//ТестируемаяФорма.УстановитьДействие("ПриЗакрытии", Неопределено);
		//	//ТестируемаяФорма.Закрыть();
		//	ВызватьИсключение Ошибка; 			
		//КонецПопытки;
	Иначе
		Попытка
			ТестируемаяФорма.Закрыть();
		Исключение
		КонецПопытки;
	КонецЕсли;
	ТестируемаяФорма = "";

КонецФункции

//окончание текста модуля

///////////////////////////////////////////////////
//Генерация фич
///////////////////////////////////////////////////

&НаКлиенте
Функция ГенерацияФич(Команда)
	
	МассивТекстов = Новый Массив;
	ГенерацияФичНаСервере(МассивТекстов);
	
	//Для каждого Элемент Из МассивТекстов Цикл
	//	Элемент["Текст"].Показать(Элемент["Имя"], "Ввод на основании - " + Элемент["Имя"] + ".feature");
	//КонецЦикла;
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	Диалог.Заголовок = "Выберите каталог для feature файлов";
	ДополнительныеПарам =  Новый Структура("МассивТекстов", МассивТекстов);
	ОповещениеОбВыборе  = Новый ОписаниеОповещения("КаталогСохраненияФичЗавершение", ЭтаФорма, ДополнительныеПарам);
	Диалог.Показать(ОповещениеОбВыборе);
	
КонецФункции

&НаКлиенте
Функция КаталогСохраненияФичЗавершение(ВыбранныеФайлы, ДопПараметры) Экспорт
	
	Если ВыбранныеФайлы = Неопределено или ВыбранныеФайлы.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли; 
	
	Каталог = ВыбранныеФайлы.Получить(0);
	
	ОповещениеОбЗаписи = Новый ОписаниеОповещения("ЗаписьФайлаЗавершение", ЭтаФорма, Неопределено);
	
	Для каждого Элемент Из ДопПараметры["МассивТекстов"] Цикл
		ТекстДок = Элемент["Текст"];
		ТекстДок.НачатьЗапись(ОповещениеОбЗаписи, Каталог + "/"+ Элемент["Имя"] + ".feature", КодировкаТекста.UTF8);
	КонецЦикла; 
	
КонецФункции

&НаКлиенте
Функция ЗаписьФайлаЗавершение(Результат, ДопПараметры) Экспорт
		
КонецФункции

&НаСервере
Функция ГенерацияФичНаСервере(МассивТекстов)
	
	СписокМетаданных = ПолучитьСписокМетаданныхНаСервере();
	СписокДокументыОснования = ПолучитьСсылкиНаДокументыОснованияНаСервере(СписокМетаданных);
	
	Для каждого ТипМетаданного Из СписокМетаданных Цикл
		ТипДокумента = ТипМетаданного.Значение;
		
		ВводятсяНаОснованииДокумента = СписокВводятсяНаОснованииДокументаНаСервере(ТипДокумента.Имя);
		Если ВводятсяНаОснованииДокумента.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;		
		
		Отбор = Новый Структура;
		Отбор.Вставить("ТипДокумента", ТипДокумента.Имя);
		СписокОснований = СписокДокументыОснования.НайтиСтроки(Отбор);
		Если СписокОснований.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Текст = Новый ТекстовыйДокумент;
		Текст.ДобавитьСтроку("# language: ru");
		Текст.ДобавитьСтроку("");
		
		Текст.ДобавитьСтроку("@" + ТипДокумента.Имя);
		Текст.ДобавитьСтроку("@tree");
		Текст.ДобавитьСтроку("@smoke");
		Текст.ДобавитьСтроку("");
		
		Текст.ДобавитьСтроку("Функционал: Тестирование открытия форм для подсистемы ");
		Текст.ДобавитьСтроку("	Как Разработчик
							|	Я Хочу чтобы проверялось открытие формы всех элементов этой подсистемы
							|	Чтобы я мог гарантировать работоспособность заполнения форм на основании");		
		Текст.ДобавитьСтроку("");		
		
		Текст.ДобавитьСтроку("Сценарий: Ввод на основании документа """ + ТипДокумента.Синоним + """");
		
		Для каждого Основание Из СписокОснований Цикл
			ШаблонСнипета = "		Когда Я открываю форму документа ""#ВводитсяНаОсновании"" заполненного на основании #Проведен ""#ДокументОснования""";
			Если Основание.Проведен Тогда
				Текст.ДобавитьСтроку("	" + "Проведенного");
			Иначе
				Текст.ДобавитьСтроку("	" + "Не проведенного");
			КонецЕсли;
			
			Для каждого ВводитсяНаОсновании Из ВводятсяНаОснованииДокумента Цикл
				Снипет = СтрЗаменить(ШаблонСнипета, "#ВводитсяНаОсновании", ВводитсяНаОсновании.Значение.Имя);
				Снипет = СтрЗаменить(Снипет, "#ДокументОснования", ТипДокумента.Имя);
				Снипет = СтрЗаменить(Снипет, "#Проведен",  ?(Основание.Проведен, "", "не ") + "проведенного");
				
				Если УказыватьДокументОснование Тогда
					Снипет = Снипет + " номер ""#НомерДокументаОснования"" от ""#ДатаДокументаОснования""";
					Снипет = СтрЗаменить(Снипет, "#НомерДокументаОснования", Основание.Номер);
					Снипет = СтрЗаменить(Снипет, "#ДатаДокументаОснования",  Формат(Основание.Дата, "ДФ=dd.MM.yyyy"));
				КонецЕсли;
				
				Текст.ДобавитьСтроку(Снипет);
				
				ШаблонСнипета = СтрЗаменить(ШаблонСнипета, "	Когда", "	И    ");
			КонецЦикла;
		КонецЦикла;
		
		СоответствиеФорм = Новый Соответствие;
		СоответствиеФорм.Вставить("Имя",   ТипДокумента.Синоним);
		СоответствиеФорм.Вставить("Текст", Текст);
		
		МассивТекстов.Добавить(СоответствиеФорм);
		
	КонецЦикла;
	
КонецФункции

&НаСервере
Функция ПолучитьСписокМетаданныхНаСервере()

	СписокМетаданных = Новый Структура;
	Для каждого ТипДок Из Метаданные.Документы Цикл
		//СписокМетаданных.Вставить(ТипДок.Имя, Новый Структура("Имя, Синоним", ТипДок.Имя, ТипДок.Синоним));
		СписокМетаданных.Вставить(ТипДок.Имя, ТипДок);
	КонецЦикла;
	
	Возврат СписокМетаданных;

КонецФункции

&НаСервере
Функция СписокВводятсяНаОснованииДокументаНаСервере(ТипДокумента)
	
	ЯвляетсяОснованием = Новый Структура;
	
	ДокументОснования = Метаданные.Документы[ТипДокумента];
	//Если ДокументОснования.ИспользоватьСтандартныеКоманды Тогда	// исключаем документы которые пользователь не может создать из интерфейса
		КоллекцияВсехДокументов = Метаданные.Документы;
		
		Для каждого ДокументКоллекции ИЗ КоллекцияВсехДокументов Цикл
			ВводитсяНаОсновании = ДокументКоллекции.ВводитсяНаОсновании;
			Для каждого Док ИЗ ВводитсяНаОсновании Цикл
				Если Док = ДокументОснования Тогда
					ЯвляетсяОснованием.Вставить(ДокументКоллекции.Имя, Новый Структура("Имя, Синоним", ДокументКоллекции.Имя, ДокументКоллекции.Синоним));
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;	
	//КонецЕсли;
	
	Возврат ЯвляетсяОснованием;
	
КонецФункции

&НаСервере
Функция ПолучитьСсылкиНаДокументыОснованияНаСервере(СписокМетаданных)

	ШаблонЗапроса = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	#Док.Ссылка КАК Ссылка,
		|	#Док.Номер КАК Номер,
		|	#Док.Дата КАК Дата,
		|	#Док.Проведен КАК Проведен,
		|	""#Док"" КАК ТипДокумента
		|ПОМЕСТИТЬ #Док_Проведенные
		|ИЗ
		|	Документ.#Док КАК #Док
		|ГДЕ
		|	#Док.Проведен
		|
		|УПОРЯДОЧИТЬ ПО
		|	#Док.Дата УБЫВ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	#Док.Ссылка КАК Ссылка,
		|	#Док.Номер КАК Номер,
		|	#Док.Дата КАК Дата,
		|	#Док.Проведен КАК Проведен,
		|	""#Док"" КАК ТипДокумента		
		|ПОМЕСТИТЬ #Док_НеПроведенные
		|ИЗ
		|	Документ.#Док КАК #Док
		|ГДЕ
		|	НЕ #Док.ПометкаУдаления
		|	И НЕ #Док.Проведен
		|
		|УПОРЯДОЧИТЬ ПО
		|	#Док.Дата УБЫВ
		|;
		|";
	
	ШаблонРезультата = 
		"ВЫБРАТЬ
		|	#Док_Проведенные.Ссылка КАК Ссылка,
		|	#Док_Проведенные.Номер КАК Номер,
		|	#Док_Проведенные.Дата КАК Дата,
		|	#Док_Проведенные.Проведен КАК Проведен,
		|	#Док_Проведенные.ТипДокумента КАК ТипДокумента
		|ИЗ
		|	#Док_Проведенные КАК #Док_Проведенные
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	#Док_НеПроведенные.Ссылка КАК Ссылка,
		|	#Док_НеПроведенные.Номер КАК Номер,
		|	#Док_НеПроведенные.Дата КАК Дата,
		|	#Док_НеПроведенные.Проведен КАК Проведен,
		|	#Док_НеПроведенные.ТипДокумента КАК ТипДокумента
		|ИЗ
		|	#Док_НеПроведенные КАК #Док_НеПроведенные
		|";
	
	// Ищем тестовые документы: проведенный и не проведенный
	Запрос = Новый Запрос;
	ТекстПолученияРезультата = "";
	Для каждого ТипМетаданного Из СписокМетаданных Цикл
		Если ТипМетаданного.Значение.ДлинаНомера = 0 Тогда
			ШаблонЗапроса = СтрЗаменить(ШаблонЗапроса, "#Док.Номер", """""");
		КонецЕсли;
		
		Запрос.Текст = Запрос.Текст + 
		
		СтрЗаменить(ШаблонЗапроса, "#Док", ТипМетаданного.Значение.Имя);
		
		ТекстПолученияРезультата = ТекстПолученияРезультата + ?(ТекстПолученияРезультата = "", "", 
		"ОБЪЕДИНИТЬ ВСЕ
		 |") + 
		
		СтрЗаменить(ШаблонРезультата, "#Док", ТипМетаданного.Значение.Имя);
	КонецЦикла;	
	Запрос.Текст = Запрос.Текст + ТекстПолученияРезультата;
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
	Возврат РезультатЗапроса;
	
КонецФункции // ПолучитьОснованиеНаСервере()
