
Процедура ДобавитьТаблицуСтилей(ъТекст) Экспорт
	
	ъТекст = ъТекст + "
	|<style>
	|table.blueTable {
	|border: 1px solid #1C6EA4;
	|background-color: #EEEEEE;
//	|width: 100%;
	|text-align: left;
	|border-collapse: collapse;
	|}
	|table.blueTable td, table.blueTable th {
	|border: 1px solid #AAAAAA;
	|padding: 3px 2px;
	|}
	|table.blueTable tbody td {
	|font-size: 13px;
	|}
	|table.blueTable tr:nth-child(even) {
	|background: #D0E4F5;
	|}
	|table.blueTable thead {
	|background: #1C6EA4;
	|background: -moz-linear-gradient(top, #5592bb 0%, #327cad 66%, #1C6EA4 100%);
	|background: -webkit-linear-gradient(top, #5592bb 0%, #327cad 66%, #1C6EA4 100%);
	|background: linear-gradient(to bottom, #5592bb 0%, #327cad 66%, #1C6EA4 100%);
	|border-bottom: 2px solid #444444;
	|}
	|table.blueTable thead th {
	|font-size: 15px;
	|font-weight: bold;
	|color: #FFFFFF;
	|text-align: center;
	|border-left: 2px solid #D0E4F5;
	|}
	|table.blueTable thead th:first-child {
	|border-left: none;
	|}	
	|table.blueTable tfoot {
	|font-size: 14px;
	|font-weight: bold;
	|color: #FFFFFF;
	|background: #D0E4F5;
	|background: -moz-linear-gradient(top, #dcebf7 0%, #d4e6f6 66%, #D0E4F5 100%);
	|background: -webkit-linear-gradient(top, #dcebf7 0%, #d4e6f6 66%, #D0E4F5 100%);
	|background: linear-gradient(to bottom, #dcebf7 0%, #d4e6f6 66%, #D0E4F5 100%);
	|border-top: 2px solid #444444;
	|}
	|table.blueTable tfoot td {
	|font-size: 14px;
	|}
	|table.blueTable tfoot .links {
	|text-align: right;
	|}
	|table.blueTable tfoot .links a{
	|display: inline-block;
	|background: #1C6EA4;
	|color: #FFFFFF;
	|padding: 2px 8px;
	|border-radius: 5px;
	|} </style>
	|";

КонецПроцедуры


Процедура ДобавитьЗаголовкиHead(ъТекст, ъЗаглавие) Экспорт
	
	ъТекст = ъТекст +
	"<head>
	|<meta name=""theme-color"" content=""#323694"">
	|<title>" + ъЗаглавие + "</title>
	|</head>";
	
КонецПроцедуры


Процедура ДобавитьЗаголовкиОтвета(ъHTTPответ) Экспорт
	ъHTTPответ.Заголовки.Вставить("Content-type", "text/html; charset=utf-8");
	ъHTTPответ.Заголовки.Вставить("Cache-Control", "no-cache, must-revalidate");
	ъHTTPответ.Заголовки.Вставить("Pragma", "no-cache");	
КонецПроцедуры


Функция ПолучитьСтруктуруСокращений() Экспорт
	
	яР = Новый Структура;
	яР.Вставить("Н", "<tr><td>");
	яР.Вставить("С", "</td><td>");
	яР.Вставить("К", "</td></tr>");
	Возврат яР;
	
КонецФункции


Процедура УстановитьТелоОтвета(яОтветHTTP, яСтрока) Экспорт
	яОтветHTTP.УстановитьТелоИзСтроки(яСтрока, КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);	
КонецПроцедуры

Процедура УстановитьТелоОтветаJSON(яОтветHTTP, яДанные, яКодСостояния = 200) Экспорт
	яОтветHTTP.КодСостояния = яКодСостояния;
	яЗапись = Новый ЗаписьJSON();
	яПараметры = Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Unix, Символы.Таб, Истина, ЭкранированиеСимволовJSON.СимволыВнеBMP);
	яЗапись.УстановитьСтроку(яПараметры);
	ЗаписатьJSON(яЗапись, яДанные);
	яСтрока = яЗапись.Закрыть();
	яОтветHTTP.УстановитьТелоИзСтроки(яСтрока, КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);	
КонецПроцедуры