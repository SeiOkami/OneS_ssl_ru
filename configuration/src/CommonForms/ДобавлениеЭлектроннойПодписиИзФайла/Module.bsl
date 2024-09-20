///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем КлиентскиеПараметры Экспорт;

&НаКлиенте
Перем ОписаниеДанных, ФормаОбъекта, ТекущийСписокПредставлений;

&НаКлиенте
Перем ОтображениеДанныхОбновлено;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если ЗначениеЗаполнено(Параметры.ЗаголовокДанных) Тогда
		Элементы.ПредставлениеДанных.Заголовок = Параметры.ЗаголовокДанных;
	Иначе
		Элементы.ПредставлениеДанных.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
	КонецЕсли;
	
	ПредставлениеДанных = Параметры.ПредставлениеДанных;
	Элементы.ПредставлениеДанных.Гиперссылка = Параметры.ПредставлениеДанныхОткрывается;
	
	Если Не ЗначениеЗаполнено(ПредставлениеДанных) Тогда
		Элементы.ПредставлениеДанных.Видимость = Ложь;
	КонецЕсли;
	
	Если Не Параметры.ПоказатьКомментарий Тогда
		Элементы.Подписи.Шапка = Ложь;
		Элементы.ПодписиКомментарий.Видимость = Ложь;
	КонецЕсли;
	
	МенеджерКриптографииНаСервереОписаниеОшибки = Новый Структура;
	
	Если ЭлектроннаяПодпись.ПроверятьЭлектронныеПодписиНаСервере()
	 Или ЭлектроннаяПодпись.СоздаватьЭлектронныеПодписиНаСервере() Тогда
		
		ПараметрыСоздания = ЭлектроннаяПодписьСлужебный.ПараметрыСозданияМенеджераКриптографии();
		ПараметрыСоздания.ОписаниеОшибки = Новый Структура;
		
		ЭлектроннаяПодписьСлужебный.МенеджерКриптографии("", ПараметрыСоздания);
		МенеджерКриптографииНаСервереОписаниеОшибки = ПараметрыСоздания.ОписаниеОшибки;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если КлиентскиеПараметры = Неопределено Тогда
		Отказ = Истина;
	Иначе
		ОписаниеДанных             = КлиентскиеПараметры.ОписаниеДанных;
		ФормаОбъекта               = КлиентскиеПараметры.Форма;
		ТекущийСписокПредставлений = КлиентскиеПараметры.ТекущийСписокПредставлений;
		ПодключитьОбработчикОжидания("ПослеОткрытия", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредставлениеДанныхНажатие(Элемент, СтандартнаяОбработка)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ПредставлениеДанныхНажатие(ЭтотОбъект,
		Элемент, СтандартнаяОбработка, ТекущийСписокПредставлений);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПодписи

&НаКлиенте
Процедура ПодписиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
	Если ОтображениеДанныхОбновлено = Истина Тогда
		ВыбратьФайл(Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодписиПутьКФайлуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбратьФайл();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Если Подписи.Количество() = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Не выбрано ни одного файла подписи'"));
		Возврат;
	КонецЕсли;
	
	Если Не ОписаниеДанных.Свойство("Объект") Тогда
		ОписаниеДанных.Вставить("Подписи", МассивПодписей());
		Закрыть(Истина);
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ОписаниеДанных.Объект) <> Тип("ОписаниеОповещения") Тогда
		ВерсияОбъекта = Неопределено;
		ОписаниеДанных.Свойство("ВерсияОбъекта", ВерсияОбъекта);
		МассивПодписей = Неопределено;
		Попытка
			ДобавитьПодпись(ОписаниеДанных.Объект, ВерсияОбъекта, МассивПодписей);
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ОКЗавершение(Новый Структура("ОписаниеОшибки", ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке)));
			Возврат;
		КонецПопытки;
		ОписаниеДанных.Вставить("Подписи", МассивПодписей);
		ОповеститьОбИзменении(ОписаниеДанных.Объект);
	Иначе
		ОписаниеДанных.Вставить("Подписи", МассивПодписей());
		
		ПараметрыВыполнения = Новый Структура;
		ПараметрыВыполнения.Вставить("ОписаниеДанных", ОписаниеДанных);
		ПараметрыВыполнения.Вставить("Оповещение", Новый ОписаниеОповещения("ОКЗавершение", ЭтотОбъект));
		
		Попытка
			ВыполнитьОбработкуОповещения(ОписаниеДанных.Объект, ПараметрыВыполнения);
			Возврат;
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ОКЗавершение(Новый Структура("ОписаниеОшибки", ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке)));
			Возврат;
		КонецПопытки;
	КонецЕсли;
	
	ОКЗавершение(Новый Структура);
	
КонецПроцедуры

// Продолжение процедуры ОК.
&НаКлиенте
Процедура ОКЗавершение(Результат, Контекст = Неопределено) Экспорт
	
	Если Результат.Свойство("ОписаниеОшибки") Тогда
		ОписаниеДанных.Удалить("Подписи");
		
		Ошибка = Новый Структура("ОписаниеОшибки",
			НСтр("ru = 'Не удалось записать подпись по причине:'") + Символы.ПС + Результат.ОписаниеОшибки);
			
		ЭлектроннаяПодписьСлужебныйКлиент.ПоказатьОшибкуОбращенияКПрограмме(
			НСтр("ru = 'Не удалось добавить электронную подпись из файла'"), "", Ошибка, Новый Структура);
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПредставлениеДанных) Тогда
		ЭлектроннаяПодписьКлиент.ИнформироватьОПодписанииОбъекта(
			ЭлектроннаяПодписьСлужебныйКлиент.ПолноеПредставлениеДанных(ЭтотОбъект),, Истина);
	КонецЕсли;
	
	Закрыть(Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеОткрытия()
	
	ОтображениеДанныхОбновлено = Истина;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПодписиПутьКФайлу.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Подписи.ПутьКФайлу");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФайл(ДобавитьНовуюСтроку = Ложь)
	
	Контекст = Новый Структура;
	Контекст.Вставить("ДобавитьНовуюСтроку", ДобавитьНовуюСтроку);
	
	Оповещение = Новый ОписаниеОповещения("ВыбратьФайлПослеПомещенияФайла", ЭтотОбъект, Контекст);
	
	ПараметрыЗагрузки = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
	ПараметрыЗагрузки.ИдентификаторФормы = УникальныйИдентификатор;
	ПараметрыЗагрузки.Диалог.Заголовок = НСтр("ru = 'Выберите файл электронной подписи'");
	ПараметрыЗагрузки.Диалог.Фильтр = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Файлы подписи (*.%1)|*.%1'"),
		ЭлектроннаяПодписьКлиент.ПерсональныеНастройки().РасширениеДляФайловПодписи);
	ПараметрыЗагрузки.Диалог.Фильтр = ПараметрыЗагрузки.Диалог.Фильтр + "|" + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Все файлы (%1)|%1'"), ПолучитьМаскуВсеФайлы());
	
	Если Не ДобавитьНовуюСтроку Тогда
		ПараметрыЗагрузки.Диалог.ПолноеИмяФайла = Элементы.Подписи.ТекущиеДанные.ПутьКФайлу;
	КонецЕсли;
	
	ФайловаяСистемаКлиент.ЗагрузитьФайл(Оповещение, ПараметрыЗагрузки);
	
КонецПроцедуры

// Продолжение процедуры ВыбратьФайл.
&НаКлиенте
Процедура ВыбратьФайлПослеПомещенияФайла(ПомещенныйФайл, Контекст) Экспорт
	
	Если ПомещенныйФайл = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СоставИмени = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ПомещенныйФайл.Имя);
	
	Контекст.Вставить("Адрес",               ПомещенныйФайл.Хранение);
	Контекст.Вставить("ИмяФайла",            СоставИмени.Имя);
	Контекст.Вставить("ОшибкаНаСервере",     Новый Структура);
	Контекст.Вставить("ДанныеПодписи",       Неопределено);
	Контекст.Вставить("ДатаПодписи",         Неопределено);
	Контекст.Вставить("АдресСвойствПодписи", Неопределено);
	
	Успех = ДобавитьСтрокуНаСервере(Контекст.Адрес, Контекст.ИмяФайла, Контекст.ДобавитьНовуюСтроку,
		Контекст.ОшибкаНаСервере, Контекст.ДанныеПодписи, Контекст.ДатаПодписи, Контекст.АдресСвойствПодписи);
	
	Если Успех Тогда
		ВыбратьФайлПослеДобавленияСтроки(Контекст);
		Возврат;
	КонецЕсли;
	
	ПараметрыСоздания = ЭлектроннаяПодписьСлужебныйКлиент.ПараметрыСозданияМенеджераКриптографии();
	ПараметрыСоздания.АлгоритмПодписи = ЭлектроннаяПодписьСлужебныйКлиентСервер.АлгоритмСформированнойПодписи(Контекст.ДанныеПодписи);
	ПараметрыСоздания.ПоказатьОшибку = Неопределено;
	
	ЭлектроннаяПодписьСлужебныйКлиент.СоздатьМенеджерКриптографии(Новый ОписаниеОповещения(
			"ВыбратьФайлПослеСозданияМенеджераКриптографии", ЭтотОбъект, Контекст),
		"", ПараметрыСоздания);
	
КонецПроцедуры

// Продолжение процедуры ВыбратьФайл.
&НаКлиенте
Процедура ВыбратьФайлПослеСозданияМенеджераКриптографии(МенеджерКриптографии, Контекст) Экспорт
	
	Если ТипЗнч(МенеджерКриптографии) <> Тип("МенеджерКриптографии") Тогда
		ПараметрыСоздания = ЭлектроннаяПодписьСлужебныйКлиент.ПараметрыСозданияМенеджераКриптографии();  
		ПараметрыСоздания.ПоказатьОшибку = Неопределено;
		ЭлектроннаяПодписьСлужебныйКлиент.ПрочитатьСвойстваПодписи(Новый ОписаниеОповещения(
			"ВыбратьФайлПослеЧтенияСвойствПодписи", ЭтотОбъект, Контекст),
			Контекст.ДанныеПодписи, Истина, Ложь);
		Возврат;
	КонецЕсли;
	
	Контекст.Вставить("МенеджерКриптографии", МенеджерКриптографии);
	
	Если ЭлектроннаяПодписьКлиент.ОбщиеНастройки().ДоступнаУсовершенствованнаяПодпись Тогда
		МенеджерКриптографии.НачатьПолучениеКонтейнераПодписейКриптографии(Новый ОписаниеОповещения(
			"ВыбратьФайлПослеПолученияКонтейнераПодписи", ЭтотОбъект, Контекст,
			"ВыбратьФайлПослеОшибкиПолученияКонтейнераПодписи", ЭтотОбъект), Контекст.ДанныеПодписи);
		Возврат;
	КонецЕсли;
	
	Контекст.Вставить("ПараметрыПодписи", Неопределено);
	МенеджерКриптографии.НачатьПолучениеСертификатовИзПодписи(Новый ОписаниеОповещения(
		"ВыбратьФайлПослеПолученияСертификатовИзПодписи", ЭтотОбъект, Контекст,
		"ВыбратьФайлПослеОшибкиПолученияСертификатовИзПодписи", ЭтотОбъект), Контекст.ДанныеПодписи);
	
КонецПроцедуры

// Продолжение процедуры ВыбратьФайл.
&НаКлиенте
Процедура ВыбратьФайлПослеЧтенияСвойствПодписи(Результат, Контекст) Экспорт
	
	Если Результат.Успех = Ложь Тогда
		ПоказатьОшибку(Результат.ТекстОшибки, Контекст.ОшибкаНаСервере);
		Возврат;
	КонецЕсли;
	
	Контекст.Вставить("МенеджерКриптографии", Неопределено);
	Контекст.Вставить("ПараметрыПодписи", Результат);
	
	Если Результат.Сертификат <> Неопределено Тогда
		
		СвойстваСертификата = Новый Структура;
		СвойстваСертификата.Вставить("ДвоичныеДанные", Результат.Сертификат);
		СвойстваСертификата.Вставить("Отпечаток", Результат.Отпечаток);
		СвойстваСертификата.Вставить("КомуВыдан", Результат.КомуВыданСертификат);
		
		СвойстваПодписи = ЭлектроннаяПодписьСлужебныйКлиентСервер.СвойстваПодписи(Контекст.ДанныеПодписи,
			СвойстваСертификата, "", ПользователиКлиент.АвторизованныйПользователь(), Контекст.ИмяФайла,
			Контекст.ПараметрыПодписи, Истина);

		ДобавитьСтроку(ЭтотОбъект, Контекст.ДобавитьНовуюСтроку, СвойстваПодписи, Контекст.ИмяФайла,
			Контекст.АдресСвойствПодписи);

		ВыбратьФайлПослеДобавленияСтроки(Контекст);
	Иначе
		ОшибкаНаКлиенте = Новый Структура("ОписаниеОшибки", НСтр("ru = 'В файле подписи нет ни одного сертификата.'"));

		ПоказатьОшибку(ОшибкаНаКлиенте, Контекст.ОшибкаНаСервере);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ВыбратьФайл.
&НаКлиенте
Процедура ВыбратьФайлПослеОшибкиПолученияКонтейнераПодписи(ИнформацияОбОшибке, СтандартнаяОбработка, Контекст) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ОшибкаНаКлиенте = Новый Структура("ОписаниеОшибки", СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Не удалось получить контейнер подписи из файла подписи по причине:
		           |%1'"),
		ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке)));
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ПоказатьИнструкцию", Истина);
	ДополнительныеПараметры.Вставить("Подпись", Контекст.ДанныеПодписи);
	
	ПоказатьОшибку(ОшибкаНаКлиенте, Контекст.ОшибкаНаСервере, ДополнительныеПараметры);
	
КонецПроцедуры

// Продолжение процедуры ВыбратьФайл.
&НаКлиенте
Процедура ВыбратьФайлПослеПолученияКонтейнераПодписи(КонтейнерПодписи, Контекст) Экспорт
	
	ДатаСеанса = ОбщегоНазначенияКлиент.ДатаСеанса();
	ДобавкаВремени = ДатаСеанса - ОбщегоНазначенияКлиент.ДатаУниверсальная();
	ПараметрыПодписи = ЭлектроннаяПодписьСлужебныйКлиентСервер.ПараметрыПодписиКриптографии(
		КонтейнерПодписи, ДобавкаВремени, ДатаСеанса);
			
	Контекст.Вставить("ПараметрыПодписи", ПараметрыПодписи);
	ДатаПодписи = ПараметрыПодписи.НеподтвержденнаяДатаПодписи;
	Если ЗначениеЗаполнено(ДатаПодписи) Тогда
		Контекст.Вставить("ДатаПодписи", ДатаПодписи);
	КонецЕсли;
	
	Сертификаты = Новый Массив;
	Если ПараметрыПодписи.ОписаниеСертификата <> Неопределено Тогда
		Сертификаты.Добавить(КонтейнерПодписи.Подписи[0].СертификатПодписи);
	КонецЕсли;

	ВыбратьФайлПослеПолученияСертификатовИзПодписи(Сертификаты, Контекст);
	
КонецПроцедуры

// Продолжение процедуры ВыбратьФайл.
&НаКлиенте
Процедура ВыбратьФайлПослеОшибкиПолученияСертификатовИзПодписи(ИнформацияОбОшибке, СтандартнаяОбработка, Контекст) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ОшибкаНаКлиенте = Новый Структура("ОписаниеОшибки", СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Не удалось получить сертификаты из файла подписи по причине:
		           |%1'"),
		ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке)));
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ПоказатьИнструкцию", Истина);
	ДополнительныеПараметры.Вставить("Подпись", Контекст.ДанныеПодписи);
	
	ПоказатьОшибку(ОшибкаНаКлиенте, Контекст.ОшибкаНаСервере, ДополнительныеПараметры);
	
КонецПроцедуры

// Продолжение процедуры ВыбратьФайл.
&НаКлиенте
Процедура ВыбратьФайлПослеПолученияСертификатовИзПодписи(Сертификаты, Контекст) Экспорт
	
	Если Сертификаты.Количество() = 0 Тогда
		ОшибкаНаКлиенте = Новый Структура("ОписаниеОшибки",
			НСтр("ru = 'В файле подписи нет ни одного сертификата.'"));
		
		ПоказатьОшибку(ОшибкаНаКлиенте, Контекст.ОшибкаНаСервере);
		Возврат;
	КонецЕсли;
	
	Попытка
		Если Сертификаты.Количество() = 1 Тогда
			Сертификат = Сертификаты[0];
		ИначеЕсли Сертификаты.Количество() > 1 Тогда
			Сертификат = ЭлектроннаяПодписьСлужебныйКлиентСервер.СертификатыПоПорядкуДоКорневого(Сертификаты)[0];
		КонецЕсли;
	Исключение
		ОшибкаНаКлиенте = Новый Структура("ОписаниеОшибки",
			ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		ПоказатьОшибку(ОшибкаНаКлиенте, Контекст.ОшибкаНаСервере);
		Возврат;
	КонецПопытки;
	
	Контекст.Вставить("Сертификат", Сертификат);
	
	ТекущийСертификат = Контекст.Сертификат; // СертификатКриптографии
	ТекущийСертификат.НачатьВыгрузку(Новый ОписаниеОповещения(
		"ВыбратьФайлПослеВыгрузкиСертификата", ЭтотОбъект, Контекст));
	
КонецПроцедуры

// Продолжение процедуры ВыбратьФайл.
&НаКлиенте
Процедура ВыбратьФайлПослеВыгрузкиСертификата(ДанныеСертификата, Контекст) Экспорт
	
	СвойстваСертификата = ЭлектроннаяПодписьКлиент.СвойстваСертификата(Контекст.Сертификат);
	СвойстваСертификата.Вставить("ДвоичныеДанные", ДанныеСертификата);
	
	СвойстваПодписи = ЭлектроннаяПодписьСлужебныйКлиентСервер.СвойстваПодписи(Контекст.ДанныеПодписи,
		СвойстваСертификата, "", ПользователиКлиент.АвторизованныйПользователь(), Контекст.ИмяФайла, Контекст.ПараметрыПодписи);
	
	ДобавитьСтроку(ЭтотОбъект, Контекст.ДобавитьНовуюСтроку, СвойстваПодписи,
		Контекст.ИмяФайла, Контекст.АдресСвойствПодписи);
	
	ВыбратьФайлПослеДобавленияСтроки(Контекст);
	
КонецПроцедуры

// Продолжение процедуры ВыбратьФайл.
&НаКлиенте
Процедура ВыбратьФайлПослеДобавленияСтроки(Контекст)
	
	Если Не ОписаниеДанных.Свойство("Данные") Тогда
		Возврат; // Если данные не указаны, подпись проверить невозможно.
	КонецЕсли;
	
	ЭлектроннаяПодписьСлужебныйКлиент.ПолучитьДанныеИзОписанияДанных(Новый ОписаниеОповещения(
			"ВыбратьФайлПослеПолученияДанных", ЭтотОбъект, Контекст),
		ЭтотОбъект, ОписаниеДанных, ОписаниеДанных.Данные, Истина);
	
КонецПроцедуры

// Продолжение процедуры ВыбратьФайл.
&НаКлиенте
Процедура ВыбратьФайлПослеПолученияДанных(Результат, Контекст) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		Возврат; // Не удалось получить данные, подпись проверить невозможно.
	КонецЕсли;
	
	ЭлектроннаяПодписьСлужебныйКлиент.ПроверитьПодпись(Новый ОписаниеОповещения(
			"ВыбратьФайлПослеПроверкиПодписи", ЭтотОбъект, Контекст),
		Результат, Контекст.ДанныеПодписи, , Контекст.ДатаПодписи, Ложь);
	
КонецПроцедуры

// Продолжение процедуры ВыбратьФайл.
&НаКлиенте
Процедура ВыбратьФайлПослеПроверкиПодписи(Результат, Контекст) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат; // Не удалось проверить подпись.
	КонецЕсли;
	
	ОбновитьРезультатПроверкиПодписи(Контекст.АдресСвойствПодписи, Результат = Истина);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьРезультатПроверкиПодписи(АдресСвойствПодписи, ПодписьВерна)
	
	ТекущаяДатаСеанса = ТекущаяДатаСеанса();
	СвойстваПодписи = ПолучитьИзВременногоХранилища(АдресСвойствПодписи);
	
	Если ЗначениеЗаполнено(ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(
		СвойстваПодписи, "НеподтвержденнаяДатаПодписи", Неопределено)) Тогда
		ДатаПодписи = СвойстваПодписи.НеподтвержденнаяДатаПодписи;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДатаПодписи) Тогда
		Если Не ЗначениеЗаполнено(СвойстваПодписи.ДатаПодписи) Тогда
			СвойстваПодписи.ДатаПодписи = ТекущаяДатаСеанса;
		КонецЕсли;
	Иначе
		СвойстваПодписи.ДатаПодписи = ДатаПодписи;
	КонецЕсли;

	СвойстваПодписи.ДатаПроверкиПодписи = ТекущаяДатаСеанса;
	СвойстваПодписи.ПодписьВерна = ПодписьВерна;
	
	ПоместитьВоВременноеХранилище(СвойстваПодписи, АдресСвойствПодписи);
	
КонецПроцедуры

&НаСервере
Функция ДобавитьСтрокуНаСервере(Адрес, ИмяФайла, ДобавитьНовуюСтроку, ОшибкаНаСервере,
			ДанныеПодписи, ДатаПодписи, АдресСвойствПодписи)
	
	ДанныеПодписи = ПолучитьИзВременногоХранилища(Адрес); // ДвоичныеДанные
	
	ПолноеИмяВременногоФайла = ПолучитьИмяВременногоФайла();
	ДанныеПодписи.Записать(ПолноеИмяВременногоФайла);
	Текст = Новый ТекстовыйДокумент;
	Текст.Прочитать(ПолноеИмяВременногоФайла);
	
	Попытка
		УдалитьФайлы(ПолноеИмяВременногоФайла);
	Исключение
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Электронная подпись.Удаление временного файла'",
				ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, , ,
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	СтрокаBase64 = Неопределено;
	Если Текст.КоличествоСтрок() > 3 И СтрНачинаетсяС(Текст.ПолучитьСтроку(1), "-----BEGIN")
		И СтрНачинаетсяС(Текст.ПолучитьСтроку(Текст.КоличествоСтрок()), "-----END") Тогда
		Текст.УдалитьСтроку(1);
		Текст.УдалитьСтроку(Текст.КоличествоСтрок());
		СтрокаBase64 = Текст.ПолучитьТекст();
	ИначеЕсли СтрНачинаетсяС(Текст.ПолучитьСтроку(1), "MII") Тогда
		СтрокаBase64 = Текст.ПолучитьТекст();
	КонецЕсли;
	
	Если СтрокаBase64 <> Неопределено Тогда
		Попытка
			ДанныеПодписи = Base64Значение(СтрокаBase64);
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ОшибкаНаСервере.Вставить("ОписаниеОшибки", СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Не удалось получить данные из файла подписи по причине:
			 |%1'"), ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке)));
			Возврат Ложь;
		КонецПопытки;
	КонецЕсли;
	
	ДатаПодписи = ЭлектроннаяПодпись.ДатаПодписания(ДанныеПодписи);
	
	Если Не ЭлектроннаяПодпись.ПроверятьЭлектронныеПодписиНаСервере()
		И Не ЭлектроннаяПодпись.СоздаватьЭлектронныеПодписиНаСервере() Тогда
		
		Возврат Ложь;
	КонецЕсли;
	
	ПараметрыСоздания = ЭлектроннаяПодписьСлужебный.ПараметрыСозданияМенеджераКриптографии();
	ПараметрыСоздания.ОписаниеОшибки = ОшибкаНаСервере;
	ПараметрыСоздания.АлгоритмПодписи = ЭлектроннаяПодписьСлужебныйКлиентСервер.АлгоритмСформированнойПодписи(ДанныеПодписи);
	
	МенеджерКриптографии = ЭлектроннаяПодписьСлужебный.МенеджерКриптографии("", ПараметрыСоздания);
	
	ОшибкаНаСервере = ПараметрыСоздания.ОписаниеОшибки;
	Если МенеджерКриптографии = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ПараметрыПодписи = Неопределено;
	Если ЭлектроннаяПодпись.ОбщиеНастройки().ДоступнаУсовершенствованнаяПодпись Тогда
		КонтейнерПодписи = МенеджерКриптографии.ПолучитьКонтейнерПодписейКриптографии(ДанныеПодписи);
		ПараметрыПодписи = ЭлектроннаяПодписьСлужебныйКлиентСервер.ПараметрыПодписиКриптографии(КонтейнерПодписи,
			ЭлектроннаяПодписьСлужебный.ДобавкаВремени(), ТекущаяДатаСеанса());
		
		Если ЗначениеЗаполнено(ПараметрыПодписи.НеподтвержденнаяДатаПодписи) Тогда
			ДатаПодписи = ПараметрыПодписи.НеподтвержденнаяДатаПодписи;
		КонецЕсли;
	КонецЕсли;
	
	Если ПараметрыПодписи = Неопределено Тогда
		
		Попытка
			
			Сертификаты = МенеджерКриптографии.ПолучитьСертификатыИзПодписи(ДанныеПодписи);
			
			Если Сертификаты.Количество() = 0 Тогда
				ВызватьИсключение НСтр("ru = 'В файле подписи нет ни одного сертификата.'");
			КонецЕсли;
			
			Если Сертификаты.Количество() = 1 Тогда
				Сертификат = Сертификаты[0];
			ИначеЕсли Сертификаты.Количество() > 1 Тогда
				ДанныеСертификатов = Новый Массив;
				Для Каждого Сертификат Из Сертификаты Цикл
					ДанныеСертификатов.Добавить(Сертификат.Выгрузить());
				КонецЦикла;
			
				ДвоичныеДанныеСертификата = ЭлектроннаяПодписьСлужебный.СертификатыПоПорядкуДоКорневого(
						ДанныеСертификатов)[0];
				Сертификат = Новый СертификатКриптографии(ДвоичныеДанныеСертификата);
			КонецЕсли;
			
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ОшибкаНаСервере.Вставить("ОписаниеОшибки", СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось получить сертификаты из файла подписи по причине:
				           |%1'"),
				ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке)));
			Возврат Ложь;
		КонецПопытки;
		
		СвойстваСертификата = ЭлектроннаяПодпись.СвойстваСертификата(Сертификат);
		
	Иначе
		
		СвойстваСертификата = ПараметрыПодписи.ОписаниеСертификата;
		Сертификат = КонтейнерПодписи.Подписи[0].СертификатПодписи;
	КонецЕсли;
	
	СвойстваСертификата.Вставить("ДвоичныеДанные", Сертификат.Выгрузить());
	
	СвойстваПодписи = ЭлектроннаяПодписьСлужебныйКлиентСервер.СвойстваПодписи(ДанныеПодписи,
		СвойстваСертификата, "", Пользователи.АвторизованныйПользователь(), ИмяФайла, ПараметрыПодписи);
	
	ДобавитьСтроку(ЭтотОбъект, ДобавитьНовуюСтроку, СвойстваПодписи, ИмяФайла, АдресСвойствПодписи);
	
	Возврат Истина;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ДобавитьСтроку(Форма, ДобавитьНовуюСтроку, СвойстваПодписи, ИмяФайла, АдресСвойствПодписи)
	
	АдресСвойствПодписи = ПоместитьВоВременноеХранилище(СвойстваПодписи, Форма.УникальныйИдентификатор);
	
	Если ДобавитьНовуюСтроку Тогда
		ТекущиеДанные = Форма.Подписи.Добавить();
	Иначе
		ТекущиеДанные = Форма.Подписи.НайтиПоИдентификатору(Форма.Элементы.Подписи.ТекущаяСтрока);
	КонецЕсли;
	
	ТекущиеДанные.ПутьКФайлу = ИмяФайла;
	ТекущиеДанные.АдресСвойствПодписи = АдресСвойствПодписи;
	
КонецПроцедуры

&НаСервере
Функция МассивПодписей()
	
	МассивПодписей = Новый Массив;
	
	Для каждого Строка Из Подписи Цикл
		
		СвойстваПодписи = ПолучитьИзВременногоХранилища(Строка.АдресСвойствПодписи);
		СвойстваПодписи.Вставить("Комментарий", Строка.Комментарий);
		
		МассивПодписей.Добавить(ПоместитьВоВременноеХранилище(СвойстваПодписи, УникальныйИдентификатор));
	КонецЦикла;
	
	Возврат МассивПодписей;
	
КонецФункции

&НаСервере
Процедура ДобавитьПодпись(СсылкаНаОбъект, ВерсияОбъекта, МассивПодписей)
	
	МассивПодписей = МассивПодписей();
	
	ЭлектроннаяПодпись.ДобавитьПодпись(СсылкаНаОбъект,
		МассивПодписей, УникальныйИдентификатор, ВерсияОбъекта);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОшибку(ОшибкаНаКлиенте, ОшибкаНаСервере, ДополнительныеПараметры = Неопределено)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ПоказатьОшибкуОбращенияКПрограмме(
		НСтр("ru = 'Не удалось получить подпись из файла'"),
		"", ОшибкаНаКлиенте, ОшибкаНаСервере, ДополнительныеПараметры);
	
КонецПроцедуры

#КонецОбласти