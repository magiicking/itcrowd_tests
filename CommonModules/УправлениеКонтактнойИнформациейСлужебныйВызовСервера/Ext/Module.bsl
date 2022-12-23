﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Разбирает представление контактной информации и возвращает строку XML со значениями полей.
//
//  Параметры:
//      Текст        - Строка - представление контактной информации
//      ОжидаемыйТип - СправочникСсылка.ВидыКонтактнойИнформации
//                   - ПеречислениеСсылка.ТипыКонтактнойИнформации - для
//                     контроля типов.
//
//  Возвращаемое значение:
//      Строка - JSON
//
Функция КонтактнаяИнформацияПоПредставлению(Знач Текст, Знач ОжидаемыйВид) Экспорт
	Возврат УправлениеКонтактнойИнформацией.КонтактнаяИнформацияПоПредставлению(Текст, ОжидаемыйВид);
КонецФункции

// Возвращает строку состава из значения контактной информации.
//
//  Параметры:
//      XMLДанные - Строка - XML данных контактной информации.
//
//  Возвращаемое значение:
//      Строка - содержимое
//      Неопределено - если значение состава сложного типа.
//
Функция СтрокаСоставаКонтактнойИнформации(Знач XMLДанные) Экспорт;
	Возврат УправлениеКонтактнойИнформациейСлужебный.СтрокаСоставаКонтактнойИнформации(XMLДанные);
КонецФункции

// Преобразует все входящие форматы контактной информации в XML.
//
Функция ПривестиКонтактнуюИнформациюXML(Знач Данные) Экспорт
	Возврат УправлениеКонтактнойИнформациейСлужебный.ПривестиКонтактнуюИнформациюXML(Данные);
КонецФункции

// Возвращает найденную ссылку или создает новую страну мира и возвращает ссылку на нее.
//
Функция СтранаМираПоДаннымКлассификатора(Знач КодСтраны) Экспорт
	
	Возврат УправлениеКонтактнойИнформацией.СтранаМираПоКодуИлиНаименованию(КодСтраны);
	
КонецФункции

// Заполняет коллекцию ссылками на найденные или созданные страны мира.
//
Процедура КоллекцияСтранМираПоДаннымКлассификатора(Коллекция) Экспорт
	
	Для Каждого КлючЗначение Из Коллекция Цикл
		Коллекция[КлючЗначение.Ключ] =  УправлениеКонтактнойИнформацией.СтранаМираПоКодуИлиНаименованию(КлючЗначение.Значение.Код);
	КонецЦикла;
	
КонецПроцедуры

// Заполняет список вариантов адреса при автоподборе по введенному пользователем тексту.
//
Процедура АвтоподборАдреса(Знач Текст, ДанныеВыбора) Экспорт
	
	УправлениеКонтактнойИнформациейСлужебный.АвтоподборАдреса(Текст, ДанныеВыбора);
	
КонецПроцедуры

#КонецОбласти
