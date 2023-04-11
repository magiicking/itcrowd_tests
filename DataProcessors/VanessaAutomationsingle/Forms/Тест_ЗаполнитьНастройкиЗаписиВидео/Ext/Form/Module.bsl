﻿//начало текста модуля

///////////////////////////////////////////////////
//Служебные функции и процедуры
///////////////////////////////////////////////////

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

	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ВОткрытойФормеВПолеЯВвожуКомандуДляIrfanView(Парам01)","ВОткрытойФормеВПолеЯВвожуКомандуДляIrfanView","И     В открытой форме в поле ""Команда создания скриншотов"" я ввожу команду для IrfanView","","");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ВПолеЯВвожуЗначениеИзTestManager(Парам01,Парам02)","ВПолеЯВвожуЗначениеИзTestManager","И в поле ""Экран ширина"" я ввожу значение из TestManager ""ЗаписьВидеоЭкранШирина""","","");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ВПолеСИменемЯВвожуЗначениеИзTestManager(Парам01,Парам02)","ВПолеСИменемЯВвожуЗначениеИзTestManager","И в поле с именем ""ИмяПоля"" я ввожу значение из TestManager ""ЗаписьВидеоЭкранШирина""","","");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯИзменяюФлагВСоответствииСоЗначениемTestManager(Парам01,Парам02)","ЯИзменяюФлагВСоответствииСоЗначениемTestManager","И я изменяю флаг ""Подсвечивать активные элементы форм"" в соответствии со значением TestManager ""ЗаписьВидеоПодсвечиватьАктивныеЭлементыФорм""","","");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ВПолеПутьКСловарюЗаменЯВвожуЗначениеИзTestManager(Парам01)","ВПолеПутьКСловарюЗаменЯВвожуЗначениеИзTestManager","И     в поле Путь к словарю замен я ввожу значение из TestManager ""ЗаписьВидеоСловарьЗамен""","","");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ВПолеКаталогСкриншотовЯУказываюПутьКОтносительномуКаталогу(Парам01)","ВПолеКаталогСкриншотовЯУказываюПутьКОтносительномуКаталогу","И     в поле каталог скриншотов я указываю путь к относительному каталогу ""tools\ScreenShots""");

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



///////////////////////////////////////////////////
//Работа со сценариями
///////////////////////////////////////////////////

&НаКлиенте
// Функция выполняется перед началом каждого сценария
Функция ПередНачаломСценария() Экспорт
	
КонецФункции

&НаКлиенте
// Функция выполняется перед окончанием каждого сценария
Функция ПередОкончаниемСценария() Экспорт
	
КонецФункции



///////////////////////////////////////////////////
//Реализация шагов
///////////////////////////////////////////////////

&НаКлиенте
//И в поле "Экран ширина" я ввожу значение из TestManager "ЗаписьВидеоЭкранШирина"
//@ВПолеЯВвожуЗначениеИзTestManager(Парам01,Парам02)
Функция ВПолеЯВвожуЗначениеИзTestManager(ИмяРеквизита,ИмяЗначения) Экспорт
	//Ванесса.ПосмотретьЗначение(Парам01,Истина);
	Поле = Ванесса.НайтиРеквизитОткрытойФормыПоЗаголовку(ИмяРеквизита,Ложь);
	Поле.ВвестиТекст(Формат(Ванесса.Объект[ИмяЗначения], "ЧГ=; ЧН=0"));
	
	//Ванесса.Шаг("И в поле """ + ИмяРеквизита + """ я ввожу текст '" + Формат(Ванесса.Объект[ИмяЗначения], "ЧГ=; ЧН=0") + "'");
КонецФункции

&НаКлиенте
//И в поле с именем "ИмяПоля" я ввожу значение из TestManager "ЗаписьВидеоЭкранШирина"
//@ВПолеСИменемЯВвожуЗначениеИзTestManager(Парам01,Парам02)
Функция ВПолеСИменемЯВвожуЗначениеИзTestManager(ИмяРеквизита,ИмяЗначения) Экспорт
	Поле = Ванесса.НайтиРеквизитОткрытойФормыПоЗаголовку(ИмяРеквизита,Истина);
	Поле.ВвестиТекст(Формат(Ванесса.Объект[ИмяЗначения], "ЧГ=; ЧН=0"));
	
	//Ванесса.Шаг("И в поле """ + ИмяРеквизита + """ я ввожу текст '" + Формат(Ванесса.Объект[ИмяЗначения], "ЧГ=; ЧН=0") + "'");
КонецФункции

//окончание текста модуля

&НаКлиенте
//И я изменяю флаг "Подсвечивать активные элементы форм" в соответствии со значением TestManager "ЗаписьВидеоПодсвечиватьАктивныеЭлементыФорм"
//@ЯИзменяюФлагВСоответствииСоЗначениемTestManager(Парам01,Парам02)
Функция ЯИзменяюФлагВСоответствииСоЗначениемTestManager(ИмяРеквизита,ИмяЗначения) Экспорт
	//Ванесса.ПосмотретьЗначение(Парам01,Истина);
	Если Ванесса.Объект[ИмяЗначения] Тогда
		Ванесса.Шаг("И я изменяю флаг """ + ИмяРеквизита + """");
	КонецЕсли;	 
КонецФункции

&НаКлиенте
//И     в поле Путь к словарю замен я ввожу значение из TestManager "ЗаписьВидеоСловарьЗамен"
//@ВПолеПутьКСловарюЗаменЯВвожуЗначениеИзTestManager(Парам01)
Функция ВПолеПутьКСловарюЗаменЯВвожуЗначениеИзTestManager(Парам01) Экспорт
	ЗаписьВидеоСловарьЗамен =  Ванесса.Объект.ЗаписьВидеоСловарьЗамен; //это список значений
	
	
	Для Каждого Элем Из ЗаписьВидеоСловарьЗамен Цикл
		Ванесса.Шаг("И я буду выбирать внешний файл """ + Элем.Значение + """");
		Ванесса.Шаг("И в таблице ""ЗаписьВидеоСловарьЗамен"" я нажимаю на кнопку ""Добавить""");
	КонецЦикла;	
КонецФункции

&НаКлиенте
//И     в поле каталог скриншотов я указываю путь к относительному каталогу "tools\ScreenShots"
//@ВПолеКаталогСкриншотовЯУказываюПутьКОтносительномуКаталогу(Парам01)
Функция ВПолеКаталогСкриншотовЯУказываюПутьКОтносительномуКаталогу(ЧастьПути) Экспорт
	Каталог = Ванесса.Объект.КаталогИнструментов + "\" + ЧастьПути;
	
	Если НЕ Ванесса.ФайлСуществуетКомандаСистемы(Каталог) Тогда
		Ванесса.СоздатьКаталогКомандаСистемы(Каталог);
	Иначе
		Ванесса.УдалитьКаталогКомандаСистемы(Каталог);
		Ванесса.Sleep(1);
		Ванесса.СоздатьКаталогКомандаСистемы(Каталог);
	КонецЕсли;	 
	
	Контекст.Вставить("КаталогСкриншотов",Каталог);
	Ванесса.Шаг("И В открытой форме в поле с именем ""КаталогВыгрузкиСкриншотов"" я ввожу текст """ + Каталог + """");
КонецФункции

&НаКлиенте
//И     В открытой форме в поле "Команда создания скриншотов" я ввожу команду для IrfanView
//@ВОткрытойФормеВПолеЯВвожуКомандуДляIrfanView(Парам01)
Функция ВОткрытойФормеВПолеЯВвожуКомандуДляIrfanView(ИмяПоля) Экспорт
	ПутьКExe = "C:\Program Files (x86)\IrfanView\i_view32.exe";
	Если НЕ Ванесса.ФайлСуществуетКомандаСистемы(ПутьКExe) Тогда
		ПутьКExe = "C:\Program Files\IrfanView\i_view32.exe";
	КонецЕсли;	 
	
	Поле = Ванесса.НайтиРеквизитОткрытойФормыПоЗаголовку("Команда создания скриншотов",Ложь);
	Поле.ВвестиТекст("""" + ПутьКExe + """ /capture=1 /convert=");
КонецФункции

