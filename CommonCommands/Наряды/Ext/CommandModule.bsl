
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ДокументОснование",ПараметрКоманды);	
	ОткрытьФорму("Документ.Наряд.ФормаСписка", 
	             ПараметрыФормы, 
				 ПараметрыВыполненияКоманды.Источник, 
				 ПараметрыВыполненияКоманды.Уникальность, 
				 ПараметрыВыполненияКоманды.Окно, 
				 ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
	
КонецПроцедуры
