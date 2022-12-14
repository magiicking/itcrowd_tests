Функция ПодобратьСпособЗапроса(Метод, СтруктураПараметров) Экспорт
	
	СпособыЗапросов = Перечисления.ТелеграмСпособыЗапросов;
	
	Если СтруктураПараметров.Свойство("ВходнойФайлСтруктура") = Истина
		И (
		СтруктураПараметров.ВходнойФайлСтруктура.ВидИсточника = "Файл"
		ИЛИ СтруктураПараметров.ВходнойФайлСтруктура.ВидИсточника = "АдресВХранилище"
		ИЛИ СтруктураПараметров.ВходнойФайлСтруктура.ВидИсточника = "ДвоичныеДанные") Тогда // Есть ещё СерверТелеграм
		
		ПодобранныйСпособ = СпособыЗапросов.Мультипарт;
		
	Иначе
		// Способ по умолчанию
		ПодобранныйСпособ = СпособыЗапросов.Джейсон;
		
		СпособыЗапросовПростой = 
		"getUpdates
		|setWebhook
		|deleteWebhook
		|getWebhookInfo
		|getMe";
		
		СпособыЗапросовКодированный =
		"";
		
		СпособыЗапросовДжейсон = 
		"sendMessage
		|sendPhoto
		|sendAudio
		|sendDocument
		|sendSticker
		|sendVideo
		|sendVoice
		|sendLocation
		|sendVenue
		|sendContact
		|editMessageReplyMarkup";
		
		СпособыЗапросовМультипарт = 
		"setWebhook
		|sendPhoto
		|sendAudio
		|sendDocument
		|sendSticker
		|sendVideo
		|sendVoice";
		
		Если СтрНайти(СпособыЗапросовПростой, Метод + Символы.ПС) > 0 Тогда
			ПодобранныйСпособ = СпособыЗапросов.Простой;
		ИначеЕсли СтрНайти(СпособыЗапросовКодированный, Метод + Символы.ПС) > 0 Тогда
			ПодобранныйСпособ = СпособыЗапросов.Кодированный;
		ИначеЕсли СтрНайти(СпособыЗапросовДжейсон, Метод + Символы.ПС) > 0 Тогда
			ПодобранныйСпособ = СпособыЗапросов.Джейсон;
		ИначеЕсли СтрНайти(СпособыЗапросовМультипарт, Метод + Символы.ПС) > 0 Тогда
			ПодобранныйСпособ = СпособыЗапросов.Мультипарт;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ПодобранныйСпособ;
	
КонецФункции


Функция ТипСодержимого(СпособЗапроса) Экспорт
	
	Ответ = "";
	СпособыЗапроса = Перечисления.ТелеграмСпособыЗапросов;
	Если СпособЗапроса = СпособыЗапроса.Простой Тогда
		Ответ = "";
	ИначеЕсли СпособЗапроса = СпособыЗапроса.Кодированный Тогда
		Ответ = "application/x-www-form-urlencoded";
	ИначеЕсли СпособЗапроса = СпособыЗапроса.Джейсон Тогда
		Ответ = "application/json; charset=utf-8";
	ИначеЕсли СпособЗапроса = СпособыЗапроса.Мультипарт Тогда
		Разделитель = Строка(Новый УникальныйИдентификатор);
		Ответ = "multipart/form-data; boundary=" + Разделитель;
	КонецЕсли;
	
	Возврат Ответ;
	
КонецФункции