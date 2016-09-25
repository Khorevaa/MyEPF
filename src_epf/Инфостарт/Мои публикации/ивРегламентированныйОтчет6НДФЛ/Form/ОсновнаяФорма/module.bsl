﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	РегламентированнаяОтчетность.ПередОткрытиемОсновнойФормыРегламентиованногоОтчета(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	Если НЕ ЗначениеЗаполнено(мДатаНачалаПериодаОтчета) И НЕ ЗначениеЗаполнено(мДатаКонцаПериодаОтчета) Тогда
		мДатаКонцаПериодаОтчета  = КонецМесяца(ДобавитьМесяц(КонецКвартала(РабочаяДата), -3));
		мДатаНачалаПериодаОтчета = НачалоКвартала(мДатаКонцаПериодаОтчета);
	КонецЕсли;
	
	мПериодичность = Перечисления.Периодичность.Квартал;
	
	ПоказатьПериод();
	
	Если Организация = Справочники.Организации.ПустаяСсылка() Тогда
		ОргПоУмолчанию = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнаяОрганизация");
		Если ЗначениеЗаполнено(ОргПоУмолчанию) Тогда
			Организация = ОргПоУмолчанию;
		КонецЕсли;
	КонецЕсли;
	
	УчетПоВсемОрганизациям = РегламентированнаяОтчетность.ПолучитьПризнакУчетаПоВсемОрганизациям();
	ЭлементыФормы.Организация.ТолькоПросмотр = НЕ УчетПоВсемОрганизациям;
	
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

Процедура КнопкаПредыдущийПериодНажатие(Элемент)
	
	ИзменитьПериод(-1);
	
КонецПроцедуры

Процедура КнопкаСледующийПериодНажатие(Элемент)
	
	ИзменитьПериод(1);
	
КонецПроцедуры

Процедура КнопкаВыбораФормыНажатие(Элемент)
	
	ВыбраннаяФорма = РегламентированнаяОтчетность.ВыбратьФормуОтчетаИзДействующегоСписка(ЭтаФорма);
	Если ВыбраннаяФорма <> Неопределено Тогда
		мВыбраннаяФорма = ВыбраннаяФорма;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

Процедура ОсновныеДействияФормыОК(Кнопка)
	
	Если мСкопированаФорма <> Неопределено Тогда
		// Документ был скопирован.
		Если мВыбраннаяФорма <> мСкопированаФорма Тогда
			Предупреждение("Форма отчета изменилась, копирование невозможно!");
			Возврат;
		КонецЕсли;
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		Сообщить(РегламентированнаяОтчетность.ОсновнаяФормаОрганизацияНеЗаполненаВывестиТекст(), СтатусСообщения.Важное);
		Возврат;
	КонецЕсли;
	
	ДатаПодписи = РабочаяДата;
	
	ВыбФормаОтчета             = ПолучитьФорму(мВыбраннаяФорма);
	РегламентированнаяОтчетность.ДобавитьНадписьВнешнийОтчет(ВыбФормаОтчета);
	ВыбФормаОтчета.РежимВыбора = Ложь;
	ВыбФормаОтчета.Организация = Организация;
	
	ЭтаФорма.Закрыть();
	
	ВыбФормаОтчета.Открыть();
	ВыбФормаОтчета.Модифицированность = Истина;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ПоказатьПериод()
	
	СтрПериодОтчета = ПредставлениеПериода( НачалоДня(мДатаНачалаПериодаОтчета), КонецДня(мДатаКонцаПериодаОтчета), "ФП = Истина" );
	
	ЭлементыФормы.НадписьПериодСоставленияОтчета.Заголовок = СтрПериодОтчета;
	
	КоличествоФорм = РегламентированнаяОтчетность.КоличествоФормСоответствующихВыбранномуПериоду(ЭтаФорма);
	Если КоличествоФорм >= 1 Тогда
		Если КоличествоФорм > 1 Тогда
			ЭлементыФормы.КнопкаВыбораФормы.Доступность = Истина;
		Иначе
			ЭлементыФормы.КнопкаВыбораФормы.Доступность = Ложь;
		КонецЕсли;
		
		ЭлементыФормы.ОсновныеДействияФормы.Кнопки.ОК.Доступность = Истина;
		
	Иначе
		ЭлементыФормы.КнопкаВыбораФормы.Доступность = Ложь;
		ЭлементыФормы.ОписаниеНормативДок.Значение = "";
		ЭлементыФормы.ОсновныеДействияФормы.Кнопки.ОК.Доступность = Ложь;
		
	КонецЕсли;
	
	РегламентированнаяОтчетность.ВыборФормыРегламентированногоОтчетаПоУмолчанию(ЭтаФорма);
	
КонецПроцедуры

// Устанавливает границы периода построения отчета.
// Параметры:
//  Шаг          - число, количество стандартных периодов, на которое необходимо
//                 сдвигать период построения отчета;
//
Процедура ИзменитьПериод(Шаг)
	
	мДатаКонцаПериодаОтчета  = КонецКвартала(ДобавитьМесяц(мДатаКонцаПериодаОтчета, 3 * Шаг));
	мДатаНачалаПериодаОтчета = НачалоКвартала(мДатаКонцаПериодаОтчета);
	ПоказатьПериод();
	
КонецПроцедуры

Функция ПолучитьВерсиюФорматаВыгрузки(Знач НаДату = Неопределено) Экспорт
	
	Если НаДату = Неопределено Тогда
		НаДату = РабочаяДата;
	КонецЕсли;
	
	Возврат Перечисления.ВерсииФорматовВыгрузки.Версия500;
	
КонецФункции

Функция ПолучитьФормуДляПериода(НаДату) Экспорт
	
	Для Каждого Строка Из мТаблицаФормОтчета Цикл
		Если (Строка.ДатаНачалоДействия > КонецДня(НаДату))
		 ИЛИ ((Строка.ДатаКонецДействия > '00010101000000') И (Строка.ДатаКонецДействия < НачалоДня(НаДату))) Тогда
			Продолжить;
		КонецЕсли;
		
		мВыбраннаяФорма = Строка.ФормаОтчета;
		Возврат мВыбраннаяФорма;
	КонецЦикла;
	
	// Если не удалось найти форму, соответствующую выбранному периоду, то возвращается действующая форма.
	Если мВыбраннаяФорма = Неопределено Тогда
		мВыбраннаяФорма = мТаблицаФормОтчета[0].ФормаОтчета;
	КонецЕсли;
	
	Возврат мВыбраннаяФорма;
	
КонецФункции
