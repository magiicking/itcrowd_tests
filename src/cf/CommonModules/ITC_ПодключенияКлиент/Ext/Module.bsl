﻿

Функция ПодключитьсяККлиенту(ъКлиент, ъИмя, ъВидПодключения, ъРазрешениеЭкрана = Неопределено) Экспорт
	яРезультат = Новый Структура("Успех,Сообщение", Истина, "");
	
	яТД = ITC_ПодключенияСервер.ПолучитьДанныеПодключения(ъКлиент, ъИмя, ъВидПодключения);
	Если ПустаяСтрока(яТД.Адрес) Тогда
		яРезультат.Успех = Ложь;
		яРезультат.Сообщение = "Не удалось получить адрес подключения.";
		Возврат яРезультат;
	КонецЕсли;
	
	яДопПараметры = Новый Структура;
	Если яТД.ВидПодключения = ПредопределенноеЗначение("Справочник.ВидыПодключений.AmmyyAdmin") Тогда
		яМ = ITC_ПодключенияСервер.ВернутьМакет("Ammyy");
		яДопПараметры.Вставить("Бинарник", яМ);
	Иначеесли яТД.ВидПодключения = ПредопределенноеЗначение("Справочник.ВидыПодключений.TeamViewer") Тогда
		яПуть = ITC_ПодключенияСервер.ВернутьПутьИсполняемыйФайл(яТД.ВидПодключения);
		яДопПараметры.Вставить("ПутьИсполняемыйФайл", яПуть);
	Иначеесли яТД.ВидПодключения = ПредопределенноеЗначение("Справочник.ВидыПодключений.AnyDesk") Тогда
		яПуть = ITC_ПодключенияСервер.ВернутьПутьИсполняемыйФайл(яТД.ВидПодключения);
		яДопПараметры.Вставить("ПутьИсполняемыйФайл", яПуть);
	Иначеесли яТД.ВидПодключения = ПредопределенноеЗначение("Справочник.ВидыПодключений.RDP") Тогда
		яТекст =
		"screen mode id:i:1
		|use multimon:i:0
		|session bpp:i:16
		|compression:i:1
		|keyboardhook:i:2
		|audiocapturemode:i:0
		|videoplaybackmode:i:1
		|connection type:i:1
		|networkautodetect:i:0
		|bandwidthautodetect:i:1
		|displayconnectionbar:i:1
		|enableworkspacereconnect:i:0
		|disable wallpaper:i:1
		|allow font smoothing:i:0
		|allow desktop composition:i:0
		|disable full window drag:i:1
		|disable menu anims:i:1
		|disable themes:i:1
		|disable cursor setting:i:0
		|bitmapcachepersistenable:i:1
		|audiomode:i:0
		|redirectprinters:i:1
		|redirectcomports:i:0
		|redirectsmartcards:i:1
		|redirectclipboard:i:1
		|redirectposdevices:i:0
		|drivestoredirect:s:
		|autoreconnection enabled:i:1
		|authentication level:i:2
		|prompt for credentials:i:0
		|negotiate security layer:i:1
		|remoteapplicationmode:i:0
		|alternate shell:s:
		|shell working directory:s:
		|gatewayhostname:s:
		|gatewayusagemethod:i:4
		|gatewaycredentialssource:i:4
		|gatewayprofileusagemethod:i:0
		|promptcredentialonce:i:0
		|gatewaybrokeringtype:i:0
		|use redirection server name:i:0
		|rdgiskdcproxy:i:0
		|kdcproxyname:s:" + ?(ъРазрешениеЭкрана = Неопределено, "", ъРазрешениеЭкрана);
		
		
		
		яТекст = яТекст + Символы.ПС + "full address:s:" + яТД.Адрес;
		яТекст = яТекст + Символы.ПС + "username:s:" + яТД.Логин;
		
		ВывестиВБуферОбмена(яТД.Пароль);
		
		яДопПараметры.Вставить("Текст", яТекст);
		яДопПараметры.Вставить("ОпцииКС", ?(ъРазрешениеЭкрана = Неопределено, " /f", ""));
	КонецЕсли;
	
	яПараметры = Новый Структура("ТекстСкрипта,ДопПараметры,Логин,Пароль,Адрес,Название,ВидПодключения", "", яДопПараметры);
	ЗаполнитьЗначенияСвойств(яПараметры, яТД);
	яОповещение = Новый ОписаниеОповещения("ОбработатьКаталогВременныхФайлов", ITC_ПодключенияКлиент, яПараметры);
	НачатьПолучениеКаталогаВременныхФайлов(яОповещение);
	
	Возврат яРезультат;
	
КонецФункции




Процедура ОбработатьКаталогВременныхФайлов(ъИмяКаталога, ъПараметры) Экспорт
	яСИ = Новый СистемнаяИнформация;
	
	Если ъПараметры.ВидПодключения = ПредопределенноеЗначение("Справочник.ВидыПодключений.AmmyyAdmin") Тогда
		яПуть = ъИмяКаталога + "ammyy.exe";
		Попытка
			ъПараметры.ДопПараметры.Бинарник.Записать(яПуть);
		Исключение
		КонецПопытки;
		ъПараметры.ТекстСкрипта = яПуть + " -connect " + ъПараметры.Адрес + " -password " + ъПараметры.Пароль;
		яОповещение = Новый ОписаниеОповещения("ВыполнитьСкрипт", ITC_ПодключенияКлиент, ъПараметры);
		ВыполнитьОбработкуОповещения(яОповещение);
	ИначеЕсли ъПараметры.ВидПодключения = ПредопределенноеЗначение("Справочник.ВидыПодключений.RDP") Тогда
		яЗТ = Новый ТекстовыйДокумент();
		яЗТ.УстановитьТекст(ъПараметры.ДопПараметры.Текст);
		яПуть = ъИмяКаталога + "" + ъПараметры.Название + ".rdp";
		
		ъПараметры.ТекстСкрипта = "mstsc """ + яПуть + """ " + ъПараметры.ДопПараметры.ОпцииКС;
		
		яОповещение = Новый ОписаниеОповещения("ВыполнитьСкрипт", ITC_ПодключенияКлиент, ъПараметры);
		яЗТ.НачатьЗапись(яОповещение, яПуть, КодировкаТекста.UTF8);
	ИначеЕсли ъПараметры.ВидПодключения = ПредопределенноеЗначение("Справочник.ВидыПодключений.TeamViewer") Тогда
		ъПараметры.ТекстСкрипта = ъПараметры.ДопПараметры.ПутьИсполняемыйФайл + " -i " + ъПараметры.Адрес + " -P " + ъПараметры.Пароль;
		яОповещение = Новый ОписаниеОповещения("ВыполнитьСкрипт", ITC_ПодключенияКлиент, ъПараметры);
		ВыполнитьОбработкуОповещения(яОповещение);
	ИначеЕсли ъПараметры.ВидПодключения = ПредопределенноеЗначение("Справочник.ВидыПодключений.AnyDesk") Тогда
		Если яСИ.ТипПлатформы = ТипПлатформы.Windows_x86 ИЛИ яСИ.ТипПлатформы = ТипПлатформы.Windows_x86_64 Тогда
			яШелл = Новый COMОбъект("WScript.Shell");
			WshExec = яШелл.Exec("""" + ъПараметры.ДопПараметры.ПутьИсполняемыйФайл + """ " + ъПараметры.Адрес + " --with-password");
			InStream = WshExec.StdIn;
			InStream.WriteLine(ъПараметры.Пароль);
		Иначе
			ЗапуститьПриложение("echo """ + ъПараметры.Пароль + """ | anydesk """ + ъПараметры.Адрес + """ --with-password", , Ложь);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	
КонецПроцедуры

Процедура ВыполнитьСкрипт(ъРезультат, ъПараметры) Экспорт
	
	яШелл = Новый COMОбъект("WScript.Shell");
	яШелл.Run(ъПараметры.ТекстСкрипта, 0, -1);
	
КонецПроцедуры


Процедура ЗапуститьРДП(ъРезультат, ъПараметры) Экспорт
	
	яШелл = Новый COMОбъект("WScript.Shell");
	//яШелл.Run("cmdkey /add:""" + ъПараметры.Адрес + """ /user:""" + ъПараметры.Логин + """ /pass:""" + ъПараметры.Пароль + """", 0, Истина);
	яШелл.Run("mstsc """ + ъПараметры.Путь + """ " + ъПараметры.ДопПараметры.ОпцииКС, 0, Истина);
	
	//НачатьУдалениеФайлов(, ъПараметры.Путь);
	
	//мПараметры = ъПараметры;
	//ПодключитьОбработчикОжидания("УдалитьФайлСоединения", 1, Истина);
	
КонецПроцедуры


//Процедура УдалитьФайлСоединения() Экспорт
//	
//	//яШелл = Новый COMОбъект("WScript.Shell");
//	//яШелл.Run("cmdkey /delete:""" + мПараметры.Адрес + """", 0, Истина);
//	
//	НачатьУдалениеФайлов(, мПараметры.Путь);
//	
//КонецПроцедуры