﻿
&НаСервереБезКонтекста
Процедура КомандаОтправитьНаСервере()
	ПараметрыПисьма = Новый Структура;
	ПараметрыПисьма.Вставить("Кому", "BlizzardAnton@mail.ru");
	ПараметрыПисьма.Вставить("Тело", "Тестовое письмо");
	ПараметрыПисьма.Вставить("Тема", "Тестовое письмо");
	//бпсОбщийМодуль.ОтправкаПисьма(РезультатФункции.ТекстУведомления,РезультатФункции.ТемаУведомления,СтрокаВТПользователиДляУведомления.Пользователь);				
	бпсОбщийМодуль.ОтправитьПочтовоеСообщение(Справочники.бпсУчетныеЗаписиЭлектроннойПочты.СистемнаяУчетнаяЗаписьЭлектроннойПочты,ПараметрыПисьма);

КонецПроцедуры

&НаКлиенте
Процедура КомандаОтправить(Команда)
	КомандаОтправитьНаСервере();
КонецПроцедуры
