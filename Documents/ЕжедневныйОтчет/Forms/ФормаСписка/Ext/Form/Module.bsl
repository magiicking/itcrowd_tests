
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,"Пользователь",ПолучениеТекущегоСотрудника (),ВидСравненияКомпоновкиДанных.Равно,,Истина,РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);	
	КонецПроцедуры
	Функция ПолучениеТекущегоСотрудника ()
		Возврат Справочники.Сотрудники.НайтиПоРеквизиту("Пользователь",ПараметрыСеанса.ТекущийПользователь);
		КонецФункции
