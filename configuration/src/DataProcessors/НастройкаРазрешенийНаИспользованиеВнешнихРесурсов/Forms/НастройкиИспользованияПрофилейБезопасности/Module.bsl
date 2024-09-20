///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ОбновитьИнтерфейс;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не РаботаВБезопасномРежимеСлужебный.ВозможноИспользованиеПрофилейБезопасности() Тогда
		ВызватьИсключение НСтр("ru = 'Внимание! Использование профилей безопасности недоступно для данной конфигурации'");
	КонецЕсли;
	
	Если Не РаботаВБезопасномРежимеСлужебный.ДоступнаНастройкаПрофилейБезопасности() Тогда
		ВызватьИсключение НСтр("ru = 'Внимание! Настройка профилей безопасности недоступна'");
	КонецЕсли;
	
	Если Не Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав доступа'");
	КонецЕсли;
	
	// Настройки видимости при запуске.
	ПрочитатьРежимИспользованияПрофилейБезопасности();
	
	// Обновление состояния элементов.
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	ОбновитьИнтерфейсПрограммы();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РежимИспользованияПрофилейБезопасностиПриИзменении(Элемент)
	
	Попытка
		
		НачатьПрименениеНастроекПрофилейБезопасности(ЭтотОбъект.УникальныйИдентификатор);
		
		ПредыдущийРежим = ТекущийРежимИспользованияПрофилейБезопасности();
		НовыйРежим = РежимИспользованияПрофилейБезопасности;
		
		Если (ПредыдущийРежим <> НовыйРежим) Тогда
			
			Если (ПредыдущийРежим = 2 Или НовыйРежим = 2) Тогда
				
				ОповещениеОЗакрытии = Новый ОписаниеОповещения("ПослеЗакрытияПомощникаПримененияИзмененийВПрофиляхБезопасности", ЭтотОбъект, Истина);
				
				Если НовыйРежим = 2 Тогда
					
					НастройкаРазрешенийНаИспользованиеВнешнихРесурсовКлиент.НачатьВключениеИспользованияПрофилейБезопасности(ЭтотОбъект, ОповещениеОЗакрытии);
					
				Иначе
					
					НастройкаРазрешенийНаИспользованиеВнешнихРесурсовКлиент.НачатьОтключениеИспользованияПрофилейБезопасности(ЭтотОбъект, ОповещениеОЗакрытии);
					
				КонецЕсли;
				
			Иначе
				
				ЗавершитьПрименениеНастроекПрофилейБезопасности();
				УстановитьДоступность("РежимИспользованияПрофилейБезопасности");
				
			КонецЕсли;
			
		КонецЕсли;
		
	Исключение
		
		ПрочитатьРежимИспользованияПрофилейБезопасности();
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрофильБезопасностиИнформационнойБазыПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ТребуемыеРазрешения(Команда)
	
	ПараметрыОтчета = Новый Структура();
	ПараметрыОтчета.Вставить("СформироватьПриОткрытии", Истина);
	
	ОткрытьФорму(
		"Отчет.ИспользуемыеВнешниеРесурсы.ФормаОбъекта",
		ПараметрыОтчета);
	
КонецПроцедуры

&НаКлиенте
Процедура ВосстановитьПрофилиБезопасности(Команда)
	
	Попытка
		
		НачатьПрименениеНастроекПрофилейБезопасности(ЭтотОбъект.УникальныйИдентификатор);
		ОповещениеОЗакрытии = Новый ОписаниеОповещения("ПослеЗакрытияПомощникаПримененияИзмененийВПрофиляхБезопасности", ЭтотОбъект, Истина);
		НастройкаРазрешенийНаИспользованиеВнешнихРесурсовКлиент.НачатьВосстановлениеПрофилейБезопасности(ЭтотОбъект, ОповещениеОЗакрытии);
		
	Исключение
		
		ПрочитатьРежимИспользованияПрофилейБезопасности();
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВнешнююОбработку(Команда)
	
	РаботаВБезопасномРежимеКлиент.ОткрытьВнешнююОбработкуИлиОтчет(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеЗакрытияПомощникаПримененияИзмененийВПрофиляхБезопасности(Результат, ТребуетсяПерезапускКлиентскогоПриложения) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		ЗавершитьПрименениеНастроекПрофилейБезопасности();
	КонецЕсли;
	
	ПрочитатьРежимИспользованияПрофилейБезопасности();
	
	Если Результат = КодВозвратаДиалога.ОК И ТребуетсяПерезапускКлиентскогоПриложения Тогда
		ПрекратитьРаботуСистемы(Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьРежимИспользованияПрофилейБезопасности()
	
	РежимИспользованияПрофилейБезопасности = ТекущийРежимИспользованияПрофилейБезопасности();
	УстановитьДоступность("РежимИспользованияПрофилейБезопасности");
	
КонецПроцедуры

&НаСервере
Функция ТекущийРежимИспользованияПрофилейБезопасности()
	
	Если РаботаВБезопасномРежимеСлужебный.ВозможноИспользованиеПрофилейБезопасности() И ПолучитьФункциональнуюОпцию("ИспользуютсяПрофилиБезопасности") Тогда
		
		Если Константы.АвтоматическиНастраиватьРазрешенияВПрофиляхБезопасности.Получить() Тогда
			
			Результат = 2; // Из текущей ИБ
			
		Иначе
			
			Результат = 1; // Через консоль кластера
			
		КонецЕсли;
		
	Иначе
		
		Результат = 0; // Не используются
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Процедура НачатьПрименениеНастроекПрофилейБезопасности(Знач УникальныйИдентификатор)
	
	Если Не РаботаВБезопасномРежимеСлужебный.ВозможноИспользованиеПрофилейБезопасности() Тогда
		ВызватьИсключение НСтр("ru = 'Внимание! Включение автоматического запроса разрешений недоступно'");
	КонецЕсли;
	
	УстановитьМонопольныйРежим(Истина);
	
КонецПроцедуры

&НаСервере
Процедура ЗавершитьПрименениеНастроекПрофилейБезопасности()
	
	Если РежимИспользованияПрофилейБезопасности = 0 Тогда
		
		Константы.ИспользуютсяПрофилиБезопасности.Установить(Ложь);
		Константы.АвтоматическиНастраиватьРазрешенияВПрофиляхБезопасности.Установить(Ложь);
		Константы.ПрофильБезопасностиИнформационнойБазы.Установить("");
		
	ИначеЕсли РежимИспользованияПрофилейБезопасности = 1 Тогда
		
		Константы.ИспользуютсяПрофилиБезопасности.Установить(Истина);
		Константы.АвтоматическиНастраиватьРазрешенияВПрофиляхБезопасности.Установить(Ложь);
		
	ИначеЕсли РежимИспользованияПрофилейБезопасности = 2 Тогда
		
		Константы.ИспользуютсяПрофилиБезопасности.Установить(Истина);
		Константы.АвтоматическиНастраиватьРазрешенияВПрофиляхБезопасности.Установить(Истина);
		
	КонецЕсли;
	
	Если МонопольныйРежим() Тогда
		УстановитьМонопольныйРежим(Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	ИмяКонстанты = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	ОбновитьПовторноИспользуемыеЗначения();
	
	Если ОбновлятьИнтерфейс Тогда
		ОбновитьИнтерфейс = Истина;
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
	КонецЕсли;
	
	Если ИмяКонстанты <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, ИмяКонстанты);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	ИмяКонстанты = СохранитьЗначениеРеквизита(РеквизитПутьКДанным);
	УстановитьДоступность(РеквизитПутьКДанным);
	ОбновитьПовторноИспользуемыеЗначения();
	Возврат ИмяКонстанты;
	
КонецФункции

&НаСервере
Функция СохранитьЗначениеРеквизита(РеквизитПутьКДанным)
	
	ЧастиИмени = СтрРазделить(РеквизитПутьКДанным, ".");
	Если ЧастиИмени.Количество() <> 2 Тогда
		Возврат "";
	КонецЕсли;
	
	ИмяКонстанты = ЧастиИмени[1];
	КонстантаМенеджер = Константы[ИмяКонстанты];
	КонстантаЗначение = НаборКонстант[ИмяКонстанты];
	
	Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
		КонстантаМенеджер.Установить(КонстантаЗначение);
	КонецЕсли;
	
	Возврат ИмяКонстанты;
	
КонецФункции

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	Если Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
		
		Если РеквизитПутьКДанным = "РежимИспользованияПрофилейБезопасности" ИЛИ РеквизитПутьКДанным = "" Тогда
			
			Элементы.ГруппаПрофильБезопасностиИнформационнойБазы.Доступность = РежимИспользованияПрофилейБезопасности > 0;
			
			Элементы.ПрофильБезопасностиИнформационнойБазы.ТолькоПросмотр = (РежимИспользованияПрофилейБезопасности = 2);
			Элементы.ГруппаВосстановлениеПрофилейБезопасности.Доступность = (РежимИспользованияПрофилейБезопасности = 2);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
