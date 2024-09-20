///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// Связь реквизитов с пометкой удаления.
	Если ПометкаУдаления Тогда
		Использование = Перечисления.ВариантыИспользованияВнешнихКомпонент.Отключена;
	КонецЕсли;
	
	// Связь реквизитов с вариантом использования.
	Если Использование = Перечисления.ВариантыИспользованияВнешнихКомпонент.Отключена Тогда
		ОбновлятьСПортала1СИТС = Ложь;
	КонецЕсли;
	
	// Не должно быть несколько компонент с одним идентификатором, с одновременно включенными ОбновлятьСПортала1СИТС.
	Если Не ЭтоКомпонентаПоследнейВерсии() Тогда
		ОбновлятьСПортала1СИТС = Ложь;
	КонецЕсли;
	
	// Контроль уникальности идентификатора и версии компоненты.
	Если Не ЭтоУникальнаяКомпонента() Тогда 
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Внешняя компонента с таким идентификатором ""%1"" и датой ""%2"" уже загружена в программу.'"),
			Идентификатор,
			ДатаВерсии);
	КонецЕсли;
	
	// Помещение двоичных данных компоненты
	ДвоичныеДанныеКомпоненты = Неопределено;
	Если ДополнительныеСвойства.Свойство("ДвоичныеДанныеКомпоненты", ДвоичныеДанныеКомпоненты) Тогда
		ХранилищеКомпоненты = Новый ХранилищеЗначения(ДвоичныеДанныеКомпоненты);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// Если была загружается компонента новой версии, а у одной из старых есть признак ОбновлятьСПортала1СИТС
	// то при перезаписи компонент младших версий признак будет сброшен.
	Если ЭтоКомпонентаПоследнейВерсии() Тогда
		ПерезаписатьКомпонентыМладшихВерсий();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЭтоКомпонентаПоследнейВерсии() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	МАКСИМУМ(ВнешниеКомпоненты.ДатаВерсии) КАК ДатаВерсии
		|ИЗ
		|	Справочник.ВнешниеКомпоненты КАК ВнешниеКомпоненты
		|ГДЕ
		|	ВнешниеКомпоненты.Идентификатор = &Идентификатор
		|	И ВнешниеКомпоненты.Ссылка <> &Ссылка
		|	И НЕ ВнешниеКомпоненты.ПометкаУдаления";
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	Возврат (Выборка.ДатаВерсии = Null) Или (Выборка.ДатаВерсии <= ДатаВерсии)
	
КонецФункции

Функция ЭтоУникальнаяКомпонента()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ДатаВерсии", ДатаВерсии);
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	1 КАК Поле1
		|ИЗ
		|	Справочник.ВнешниеКомпоненты КАК ВнешниеКомпоненты
		|ГДЕ
		|	ВнешниеКомпоненты.Идентификатор = &Идентификатор
		|	И ВнешниеКомпоненты.Использование = ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияВнешнихКомпонент.Используется)
		|	И ВнешниеКомпоненты.Ссылка <> &Ссылка
		|	И ВнешниеКомпоненты.ДатаВерсии = &ДатаВерсии";
	
	Результат = Запрос.Выполнить();
	Возврат Результат.Пустой();
	
КонецФункции

Процедура ПерезаписатьКомпонентыМладшихВерсий()
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("Справочник.ВнешниеКомпоненты");
	ЭлементБлокировки.УстановитьЗначение("Идентификатор", Идентификатор);
	Блокировка.Заблокировать();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
	Запрос.УстановитьПараметр("ДатаВерсии", ДатаВерсии);
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВнешниеКомпоненты.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ВнешниеКомпоненты КАК ВнешниеКомпоненты
		|ГДЕ
		|	ВнешниеКомпоненты.Идентификатор = &Идентификатор
		|	И ВнешниеКомпоненты.Использование = ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияВнешнихКомпонент.Используется)
		|	И ВнешниеКомпоненты.ДатаВерсии < &ДатаВерсии";
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл 
		Объект = Выборка.Ссылка.ПолучитьОбъект();
		Объект.Заблокировать();
		Объект.Записать();
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли