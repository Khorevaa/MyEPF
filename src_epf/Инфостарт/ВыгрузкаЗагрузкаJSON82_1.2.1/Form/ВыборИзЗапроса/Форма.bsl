﻿
//#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПараметрыЗапросаЭтоВыражениеПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ПараметрыЗапроса.ТекущиеДанные;
	
	Если ТекущиеДанные.ЭтоВыражение И Не ТипЗнч(ТекущиеДанные.ЗначениеПараметра) = Тип("Строка") Тогда
		ТекущиеДанные.ЗначениеПараметра = "";
	КонецЕсли;
	
	ИзменитьВыборТипа();
	
КонецПроцедуры

//#КонецОбласти

//#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьЗапрос(Команда)
	
	ТекстЗапроса = ДокументТекстЗапроса.ПолучитьТекст();
	
	Если ПустаяСтрока(ТекстЗапроса) Тогда
		
		СообщитьПользователю(Нстр("ru = 'Не задан текст запроса'"), "ТекстЗапроса");
		Возврат;
		
	КонецЕсли;
	
	ВыполнитьЗапросНаСервере(ТекстЗапроса);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПараметры(Команда)
	ЗаполнитьПараметрыНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВРезультатВыгрузки(Команда)
	
	Если Элементы.Найти("РезультатЗапроса") = Неопределено Тогда
		
	Иначе
		
		ОповеститьОВыборе(ЭтаФорма.РезультатЗапроса);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьЗапрос(Команда)
	
	ТекстЗапроса = ДокументТекстЗапроса.ПолучитьТекст();
	
	//Если ЗначениеЗаполнено(ТекстЗапроса) Тогда
	//КонструкторЗапроса = Новый КонструкторЗапроса(ТекстЗапроса);
	//Иначе
	//КонструкторЗапроса = Новый КонструкторЗапроса();
	//КонецЕсли; 
	//ОписаниеОповещения = Новый ОписаниеОповещения("ПриЗакрытииКонструктораЗапроса",ЭтаФорма);
	//
	//КонструкторЗапроса.Показать(ОписаниеОповещения); 
	
КонецПроцедуры


//#КонецОбласти

//#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ВыполнитьЗапросНаСервере(ТекстЗапроса)
	
	Запрос = Новый Запрос;
	
	Для каждого СтрокаПараметров Из ПараметрыЗапроса Цикл
		Если СтрокаПараметров.ЭтоВыражение Тогда
			Запрос.УстановитьПараметр(СтрокаПараметров.ИмяПараметра, Вычислить(СтрокаПараметров.ЗначениеПараметра));
		Иначе
			Запрос.УстановитьПараметр(СтрокаПараметров.ИмяПараметра, СтрокаПараметров.ЗначениеПараметра);
		КонецЕсли;
	КонецЦикла;
	
	Запрос.Текст = ТекстЗапроса;
	Результат = Запрос.Выполнить();
	ТаблицаРезультата = Результат.Выгрузить();
	
	УдалитьЭлементыФормы();
	ДобавитьЭлементыФормы(ТаблицаРезультата);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьЭлементыФормы(ТаблицаРезультата)
	
	МассивРеквизитов = Новый Массив;
	МассивРеквизитов.Добавить(Новый РеквизитФормы("РезультатЗапроса", Новый ОписаниеТипов("ТаблицаЗначений")));
	
	Для Каждого Колонка Из ТаблицаРезультата.Колонки Цикл
		МассивРеквизитов.Добавить(Новый РеквизитФормы(Колонка.Имя, Колонка.ТипЗначения, "РезультатЗапроса"));
	КонецЦикла;
	
	ИзменитьРеквизиты(МассивРеквизитов);
	
	ТаблицаФормы = Элементы.Добавить("РезультатЗапроса", Тип("ТаблицаФормы"), Элементы.ГруппаРезультатЗапроса);
	ТаблицаФормы.ПутьКДанным = "РезультатЗапроса";
	ТаблицаФормы.ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиЭлементаФормы.Нет;
	ТаблицаФормы.РастягиватьПоВертикали = Ложь;
	
	Для Каждого Колонка Из ТаблицаРезультата.Колонки Цикл
		НовыйЭлемент = Элементы.Добавить("Колонка_" + Колонка.Имя, Тип("ПолеФормы"), ТаблицаФормы);
		НовыйЭлемент.Вид = ВидПоляФормы.ПолеВвода;
		НовыйЭлемент.ПутьКДанным = "РезультатЗапроса." + Колонка.Имя;
	КонецЦикла; 
	
	ЗначениеВРеквизитФормы(ТаблицаРезультата,"РезультатЗапроса");
	
	Элементы.ГруппаРезультатаЗапроса.ТекущаяСтраница = Элементы.ГруппаРезультатаЗапроса.ПодчиненныеЭлементы.ГруппаРезультатЗапроса;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьЭлементыФормы()
	
	Если Элементы.Найти("РезультатЗапроса") <> Неопределено Тогда
		
		МассивРеквизитов = Новый Массив;
		МассивРеквизитов.Добавить("РезультатЗапроса");
		
		ИзменитьРеквизиты(, МассивРеквизитов);
		
		Элементы.Удалить(Элементы.РезультатЗапроса);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура СообщитьПользователю(Текст, ПутьКДанным = "")
	
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = Текст;
	Сообщение.ПутьКДанным = ПутьКДанным;
	Сообщение.Сообщить();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПараметрыНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = ДокументТекстЗапроса.ПолучитьТекст();
	
	ОписаниеПараметров = Запрос.НайтиПараметры();
	
	Для Каждого Параметр Из ОписаниеПараметров Цикл
		ИмяПараметра =  Параметр.Имя;
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("ИмяПараметра", ИмяПараметра);
		МассивСтрок = ПараметрыЗапроса.НайтиСтроки(ПараметрыОтбора);
		
		Если МассивСтрок.Количество() = 1 Тогда
			
			СтрокаПараметров = МассивСтрок[0];
			
		Иначе
			
			СтрокаПараметров = ПараметрыЗапроса.Добавить();
			СтрокаПараметров.ИмяПараметра = ИмяПараметра;
			
		КонецЕсли;
		
		СтрокаПараметров.ЗначениеПараметра = Параметр.ТипЗначения.ПривестиЗначение(СтрокаПараметров.ЗначениеПараметра);
		СтрокаПараметров.ТипПараметра = Параметр.ТипЗначения;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыборТипа()
	
	ТекущиеДанные = Элементы.ПараметрыЗапроса.ТекущиеДанные;
	ПараметрЗапроса = Элементы.ПараметрыЗапроса.ПодчиненныеЭлементы.ПараметрыЗапросаЗначениеПараметра;
	
	ПараметрЗапроса.ОграничениеТипа = ?(ТекущиеДанные.ЭтоВыражение, Новый ОписаниеТипов, ТекущиеДанные.ТипПараметра);
	ПараметрЗапроса.ВыбиратьТип = Не ТекущиеДанные.ЭтоВыражение;
	
КонецПроцедуры


&НаКлиенте
Процедура ПриЗакрытииКонструктораЗапроса(ТекстЗапроса, ДополнительныеПараметры) Экспорт

	ДокументТекстЗапроса.УстановитьТекст(ТекстЗапроса);

КонецПроцедуры



//#КонецОбласти
