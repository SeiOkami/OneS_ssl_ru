///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.ИнформацияОбнаруженоЗацикливание.Заголовок = СтроковыеФункции.ФорматированнаяСтрока(
		Элементы.ИнформацияОбнаруженоЗацикливание.Заголовок, 
		ОбменДаннымиКонтрольЗацикливания.ВсеЗацикленныеУзлыПредставление());
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Настройки.УзелИнформационнойБазы КАК УзелИнформационнойБазы,
		|	Настройки.РегистрацияДанныхОбменаПриЗацикливании КАК РегистрацияДанныхОбменаПриЗацикливании
		|ИЗ
		|	РегистрСведений.ОбщиеНастройкиУзловИнформационныхБаз КАК Настройки
		|ГДЕ
		|	Настройки.ОбнаруженоЗацикливание";
	
	Таблица = Запрос.Выполнить().Выгрузить();
	ТаблицаУзлов.Загрузить(Таблица);
	
	Если ТаблицаУзлов.Количество() > 0 Тогда
		
		Элементы.ГруппаЭтаБаза.Видимость = Истина;
		Элементы.ГруппаДругаяБаза.Видимость = Ложь;
		
	Иначе
		
		Элементы.ГруппаЭтаБаза.Видимость = Ложь;
		Элементы.ГруппаДругаяБаза.Видимость = Истина;
		
		Элементы.ИнформацияДругаяБаза.Заголовок = СтроковыеФункции.ФорматированнаяСтрока(
			Элементы.ИнформацияДругаяБаза.Заголовок,
			ОбменДаннымиКонтрольЗацикливания.БазаСПриостановленнойРегистрациейПредставление());
		
	КонецЕсли;
		
	УстановитьУсловноеОформление();
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаУзлов

&НаКлиенте
Процедура ТаблицаУзловВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "ТаблицаУзловРегистрацияДанныхОбменаПриЗацикливании" Тогда
		
		Строка = ТаблицаУзлов.НайтиПоИдентификатору(ВыбраннаяСтрока);
		Строка.РегистрацияДанныхОбменаПриЗацикливании = НЕ Строка.РегистрацияДанныхОбменаПриЗацикливании;
		
		ВозобновитьПриостановитьРегистрацию(Строка.УзелИнформационнойБазы, Строка.РегистрацияДанныхОбменаПриЗацикливании);
		
	ИначеЕсли Поле.Имя = "ТаблицаУзловНезарегистрированныеДанные" Тогда
		
		Строка = ТаблицаУзлов.НайтиПоИдентификатору(ВыбраннаяСтрока);
		ПараметрыФормы = Новый Структура("УзелИнформационнойБазы", Строка.УзелИнформационнойБазы);
		
		ОткрытьФорму("РегистрСведений.ОбъектыНезарегистрированныеПриЗацикливании.ФормаСписка", ПараметрыФормы);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВозобновитьПриостановитьРегистрацию(УзелИнформационнойБазы, РегистрацияДанныхОбменаПриЗацикливании)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Попытка 
		
		РегистрыСведений.ОбщиеНастройкиУзловИнформационныхБаз.УстановитьЗацикливание(
			УзелИнформационнойБазы,, 
			РегистрацияДанныхОбменаПриЗацикливании);
		
	Исключение
		
		ЗаписьЖурналаРегистрации(, УровеньЖурналаРегистрации.Ошибка,,, ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// Возобновить регистрацию
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ТаблицаУзловРегистрацияДанныхОбменаПриЗацикливании");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаУзлов.РегистрацияДанныхОбменаПриЗацикливании");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Текст = НСтр("ru = 'Возобновить регистрацию'");
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", Текст);
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Синий);
	
	// Приостановить регистрацию
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ТаблицаУзловРегистрацияДанныхОбменаПриЗацикливании");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаУзлов.РегистрацияДанныхОбменаПриЗацикливании");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Текст = НСтр("ru = 'Приостановить регистрацию'");
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", Текст);
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Синий);

	// Перейти
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ТаблицаУзловНезарегистрированныеДанные");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаУзлов.УзелИнформационнойБазы");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	Текст = НСтр("ru = 'Перейти'");
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", Текст);
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Синий);
	
КонецПроцедуры

#КонецОбласти
