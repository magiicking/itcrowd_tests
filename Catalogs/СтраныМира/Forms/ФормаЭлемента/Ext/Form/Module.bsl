﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы
//

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.Предопределенный Тогда
		Элементы.ГруппаНаименование.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.Заголовок) Тогда
		Заголовок     = Параметры.Заголовок;
		АвтоЗаголовок = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Справочник.СтраныМира.Изменение", Объект.Ссылка, ЭтотОбъект);
КонецПроцедуры

#КонецОбласти
