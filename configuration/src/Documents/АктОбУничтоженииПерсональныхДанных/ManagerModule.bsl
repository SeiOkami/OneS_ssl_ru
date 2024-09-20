///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.Печать

// Заполняет список команд печати.
// 
// Параметры:
//  КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "УправлениеПечатью";
	КомандаПечати.Идентификатор = "Документ.АктОбУничтоженииПерсональныхДанных.ПФ_MXL_АктОбУничтоженииПерсональныхДанных";
	КомандаПечати.Представление = НСтр("ru = 'Акт об уничтожении персональных данных'");
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "УправлениеПечатью";
	КомандаПечати.Идентификатор = "Документ.АктОбУничтоженииПерсональныхДанных.ПФ_MXL_ВыгрузкаИзЖурнала";
	КомандаПечати.Представление = НСтр("ru = 'Выгрузка из журнала'");
	
КонецПроцедуры

// Подготавливает данные печати.
// 
// Параметры:
//  ИсточникиДанных - см. УправлениеПечатьюПереопределяемый.ПриПодготовкеДанныхПечати.ИсточникиДанных
//  ВнешниеНаборыДанных - см. УправлениеПечатьюПереопределяемый.ПриПодготовкеДанныхПечати.ВнешниеНаборыДанных
//  КодЯзыка - см. УправлениеПечатьюПереопределяемый.ПриПодготовкеДанныхПечати.КодЯзыка
//  ДополнительныеПараметры - см. УправлениеПечатьюПереопределяемый.ПриПодготовкеДанныхПечати.ДополнительныеПараметры
// 
Процедура ПриПодготовкеДанныхПечати(ИсточникиДанных, ВнешниеНаборыДанных, КодЯзыка, ДополнительныеПараметры) Экспорт
	
	ДанныеПечати = ДанныеПечати(ИсточникиДанных, КодЯзыка, ДополнительныеПараметры);
	ВнешниеНаборыДанных.Вставить("ДанныеПечати", ДанныеПечати);
	
КонецПроцедуры

// См. УправлениеПечатьюПереопределяемый.ПриОпределенииИсточниковДанныхПечати
Процедура ПриОпределенииИсточниковДанныхПечати(Объект, ИсточникиДанныхПечати) Экспорт
	
	Если Объект = "Документ.АктОбУничтоженииПерсональныхДанных.ФИОСубъекта"
		Или Объект = "Документ.АктОбУничтоженииПерсональныхДанных.НаименованиеОрганизации"
		Или Объект = "Документ.АктОбУничтоженииПерсональныхДанных.ПричинаУничтожения"
		Или Объект = "Документ.АктОбУничтоженииПерсональныхДанных.СпособУничтожения" Тогда
		
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.СклонениеПредставленийОбъектов") Тогда
			МодульСклонениеПредставленийОбъектов = ОбщегоНазначения.ОбщийМодуль("СклонениеПредставленийОбъектов");
			МодульСклонениеПредставленийОбъектов.ПодключитьИсточникДанныхПечатиСклоненияСтрок(ИсточникиДанныхПечати);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриОпределенииНастроекПечати(Настройки) Экспорт
	
	Настройки.ПриДобавленииКомандПечати = Истина;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Параметры:
//  Субъект - СправочникСсылка, СправочникОбъект
//
Процедура ПроверитьВозможностьОформленияАкта(Субъект) Экспорт
	
	Если ЗащитаПерсональныхДанных.ЭтоОбъектСУничтоженнымиПерсональнымиДанными(Субъект) Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Оформление акта невозможно, персональные данные субъекта %1 уже уничтожены.'"), Строка(Субъект));
	КонецЕсли;

КонецПроцедуры

// Параметры:
//  Субъект - ОпределяемыйТип.СубъектПерсональныхДанных
// 
// Возвращаемое значение:
//  Неопределено,Массив из Структура:
//   * ИмяОбъекта - Строка
//   * Субъект - ОпределяемыйТип.СубъектПерсональныхДанных
//   * Категория - Строка
//   * ИдентификаторОбъекта - УникальныйИдентификатор
//
Функция КатегорииУничтожаемыхДанныхСубъекта(Субъект) Экспорт
	
	Субъекты = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Субъект);
	Результат = ЗащитаПерсональныхДанных.КатегорииУничтожаемыхДанныхСубъектов(Субъекты);
	
	Если Результат = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
		
	Возврат ОбщегоНазначения.ТаблицаЗначенийВМассив(Результат);
	
КонецФункции

// Параметры:
//  КатегорииДанныхСубъекта - см. Документы.АктОбУничтоженииПерсональныхДанных.КатегорииУничтожаемыхДанныхСубъекта
// 
// Возвращаемое значение:
//  ТаблицаЗначений:
//   * ИмяОбъекта - Строка
//   * Категория - Строка
//
Функция ПодготовитьТаблицуКатегорий(КатегорииДанныхСубъекта) Экспорт
	
	ТаблицаКатегорий = Новый ТаблицаЗначений();
	ТаблицаКатегорий.Колонки.Добавить("Субъект", Метаданные.ОпределяемыеТипы.СубъектПерсональныхДанных.Тип);
	ТаблицаКатегорий.Колонки.Добавить("ИмяОбъекта", Новый ОписаниеТипов("Строка"));
	ТаблицаКатегорий.Колонки.Добавить("Категория", Новый ОписаниеТипов("Строка"));
	
	Для Каждого Элемент Из КатегорииДанныхСубъекта Цикл
		НоваяСтрока = ТаблицаКатегорий.Добавить();
		НоваяСтрока.Субъект = Элемент.Субъект;
		НоваяСтрока.ИмяОбъекта = Элемент.ИмяОбъекта;
		НоваяСтрока.Категория = Элемент.КатегорияДанных;
	КонецЦикла;
	
	ТаблицаКатегорий.Свернуть("Субъект,ИмяОбъекта,Категория");
	
	Возврат ТаблицаКатегорий;
	
КонецФункции

// Параметры:
//  КатегорииДанныхСубъекта - см. Документы.АктОбУничтоженииПерсональныхДанных.КатегорииУничтожаемыхДанныхСубъекта
// 
// Возвращаемое значение:
//  ТаблицаЗначений:
//   * ИмяОбъекта - Строка
//   * КоличествоОбъектов - Число
//
Функция ПодготовитьТаблицуОбъектов(КатегорииДанныхСубъекта) Экспорт
	
	ТаблицаОбъектов = Новый ТаблицаЗначений();
	ТаблицаОбъектов.Колонки.Добавить("ИмяОбъекта", Новый ОписаниеТипов("Строка"));
	ТаблицаОбъектов.Колонки.Добавить("ИдентификаторОбъекта", Новый ОписаниеТипов("Строка"));
	
	Для Каждого Элемент Из КатегорииДанныхСубъекта Цикл
		НоваяСтрока = ТаблицаОбъектов.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Элемент, "ИмяОбъекта,ИдентификаторОбъекта");
	КонецЦикла;
	
	ТаблицаОбъектов.Свернуть("ИмяОбъекта,ИдентификаторОбъекта");
	ТаблицаОбъектов.Колонки.Добавить("КоличествоОбъектов", Новый ОписаниеТипов("Число"));
	ТаблицаОбъектов.ЗаполнитьЗначения(1, "КоличествоОбъектов");
	ТаблицаОбъектов.Свернуть("ИмяОбъекта", "КоличествоОбъектов");
	
	Возврат ТаблицаОбъектов;
	
КонецФункции

Функция ПричиныУничтожения() Экспорт
	
	ПричиныУничтожения = Новый Структура;
	
	ПричиныУничтожения.Вставить("ОкончаниеСрокаХранения", НСтр("ru = 'Окончание срока хранения'"));
	ПричиныУничтожения.Вставить("ОкончаниеСрокаХраненияДляОбработки",
		НСтр("ru = 'Окончание срока хранения для последующей обработки'"));
	ПричиныУничтожения.Вставить("ПоЗаявлению", НСтр("ru = 'По заявлению физического лица'"));
	ПричиныУничтожения.Вставить("ПередачаВАрхив", НСтр("ru = 'В связи с передачей в архив'"));
	
	Возврат ПричиныУничтожения;
	
КонецФункции

Функция СпособыУничтожения() Экспорт
	
	СпособыУничтожения = Новый Структура;
	
	СпособыУничтожения.Вставить("Стирание", НСтр("ru = 'Стирание данных с носителя информации'"));
	СпособыУничтожения.Вставить("УничтожениеНосителя", НСтр("ru = 'Уничтожение носителя информации'"));
	
	Возврат СпособыУничтожения;
	
КонецФункции

// Возвращает массив категорий документа.
// 
// Параметры:
//  Документы - Массив из ДокументСсылка.АктОбУничтоженииПерсональныхДанных
// 
// Возвращаемое значение:
//  Соответствие из КлючИЗначение:
//   * Ключ - ДокументСсылка.АктОбУничтоженииПерсональныхДанных
//   * Значение - Массив из Строка
//
Функция КатегорииДанныхДокументов(Документы)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	АктОбУничтоженииПерсональныхДанныхКатегорииДанных.Ссылка КАК Документ,
		|	АктОбУничтоженииПерсональныхДанныхКатегорииДанных.Категория КАК Категория
		|ИЗ
		|	Документ.АктОбУничтоженииПерсональныхДанных.КатегорииДанных КАК АктОбУничтоженииПерсональныхДанныхКатегорииДанных
		|ГДЕ
		|	АктОбУничтоженииПерсональныхДанныхКатегорииДанных.Ссылка В (&Документы)
		|ИТОГИ
		|ПО
		|	Документ";
	
	Запрос.УстановитьПараметр("Документы", Документы);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	КатегорииДокументов = Новый Соответствие();
	
	ВыборкаДокумент = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаДокумент.Следующий() Цикл
		КатегорииДокументов.Вставить(ВыборкаДокумент.Документ);
		ВыборкаДетальныеЗаписи = ВыборкаДокумент.Выбрать();
		КатегорииДокумента = Новый Массив; // Массив из Строка
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			Если КатегорииДокумента.Найти(ВыборкаДетальныеЗаписи.Категория) = Неопределено Тогда
				КатегорииДокумента.Добавить(ВыборкаДетальныеЗаписи.Категория);
			КонецЕсли;
		КонецЦикла;
		КатегорииДокументов[ВыборкаДокумент.Документ] = КатегорииДокумента;
	КонецЦикла;

	Возврат КатегорииДокументов;
	
КонецФункции

// Возвращаемое значение:
//  Булево
//
Функция ЕстьАкты() Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		|	ИСТИНА
		|ИЗ
		|	Документ.АктОбУничтоженииПерсональныхДанных КАК АктОбУничтоженииПерсональныхДанных";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат Не РезультатЗапроса.Пустой();
	
КонецФункции

// Параметры:
//  ДанныеДокумента - ДвоичныеДанные
//  ПроверитьАктуальностьКатегорийДанных - Булево
// 
// Возвращаемое значение:
//  ДвоичныеДанные
//
Функция ВыполнитьПроведение(ДанныеДокумента, ПроверитьАктуальностьКатегорийДанных) Экспорт
	
	ДокументОбъект = ДесериализоватьОбъектИзДвоичныхДанных(ДанныеДокумента); // ДокументОбъект.АктОбУничтоженииПерсональныхДанных
	
	Если ПроверитьАктуальностьКатегорийДанных
		И Не ЗащитаПерсональныхДанных.ЭтоОбъектСУничтоженнымиПерсональнымиДанными(ДокументОбъект.Субъект) Тогда
		ДокументОбъект.ДополнительныеСвойства.Вставить("ПроверитьАктуальностьКатегорийДанных");
	КонецЕсли;
	
	ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
	
	Возврат СериализоватьОбъектВДвоичныеДанные(ДокументОбъект);
	
КонецФункции

// Возвращает сериализованный объект в виде двоичных данных.
//
// Параметры:
//  Объект - Произвольный - сериализуемый объект.
//
// Возвращаемое значение:
//  ДвоичныеДанные - сериализованный объект.
//
Функция СериализоватьОбъектВДвоичныеДанные(Объект) Экспорт
	
	ЗаписьXML = Новый ЗаписьFastInfoset;
	ЗаписьXML.УстановитьДвоичныеДанные();
	ЗаписьXML.ЗаписатьОбъявлениеXML();
	ЗаписатьXML(ЗаписьXML, Объект, НазначениеТипаXML.Явное);
	
	Возврат ЗаписьXML.Закрыть();

КонецФункции

// Десериализует объект из двоичных данных.
// 
// Параметры:
//   ДанныеОбъекта - ДвоичныеДанные - двоичные данные сериализованного объекта.
//
Функция ДесериализоватьОбъектИзДвоичныхДанных(ДанныеОбъекта) Экспорт
	
	ЧтениеXML = Новый ЧтениеFastInfoset;
	ЧтениеXML.УстановитьДвоичныеДанные(ДанныеОбъекта);
	Объект = ПрочитатьXML(ЧтениеXML);
	ЧтениеXML.Закрыть();
	
	Возврат Объект;
	
КонецФункции

Функция ДанныеПечати(ИсточникиДанных, КодЯзыка, ДополнительныеПараметры)
	
	ДанныеПечати = Новый ТаблицаЗначений;
	ДанныеПечати.Колонки.Добавить("Ссылка", Новый ОписаниеТипов("ДокументСсылка.АктОбУничтоженииПерсональныхДанных"));
	ДанныеПечати.Колонки.Добавить("Номер", Новый ОписаниеТипов("Строка"));
	ДанныеПечати.Колонки.Добавить("Дата", Новый ОписаниеТипов("Дата"));
	ДанныеПечати.Колонки.Добавить("ФИОСубъекта", Новый ОписаниеТипов("Строка"));
	ДанныеПечати.Колонки.Добавить("НаименованиеОрганизации", Новый ОписаниеТипов("Строка"));
	ДанныеПечати.Колонки.Добавить("ЮридическийАдресОрганизации", Новый ОписаниеТипов("Строка"));
	ДанныеПечати.Колонки.Добавить("ДатаУничтожения", Новый ОписаниеТипов("Дата"));
	ДанныеПечати.Колонки.Добавить("ПричинаУничтожения", Новый ОписаниеТипов("Строка"));
	ДанныеПечати.Колонки.Добавить("СпособУничтожения", Новый ОписаниеТипов("Строка"));
	ДанныеПечати.Колонки.Добавить("ФИООтветственногоЗаОбработкуПДн", Новый ОписаниеТипов("Строка"));
	ДанныеПечати.Колонки.Добавить("НаименованиеИнформационнойСистемы", Новый ОписаниеТипов("Строка"));
	ДанныеПечати.Колонки.Добавить("Категории", Новый ОписаниеТипов("ТаблицаЗначений"));
	
	ИменаРеквизитов = Новый Массив; // Массив из Строка
	ИменаРеквизитов.Добавить("Ссылка");
	ИменаРеквизитов.Добавить("Номер");
	ИменаРеквизитов.Добавить("Дата");
	ИменаРеквизитов.Добавить("ФИОСубъекта");
	ИменаРеквизитов.Добавить("НаименованиеОрганизации");
	ИменаРеквизитов.Добавить("ЮридическийАдресОрганизации");
	ИменаРеквизитов.Добавить("ДатаУничтожения");
	ИменаРеквизитов.Добавить("ПричинаУничтожения");
	ИменаРеквизитов.Добавить("СпособУничтожения");
	ИменаРеквизитов.Добавить("ФИООтветственногоЗаОбработкуПДн");
	ИменаРеквизитов.Добавить("НаименованиеИнформационнойСистемы");
	ИменаРеквизитов.Добавить("КатегорииДанных");
	
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(ИсточникиДанных, ИменаРеквизитов);
	
	КатегорииДокументов = КатегорииДанныхДокументов(ИсточникиДанных);
		
	Для Каждого Элемент Из ЗначенияРеквизитов Цикл
		
		ТаблицаКатегорий = НоваяТаблицаКатегорий();
		
		ДанныеДокумента = ДанныеПечати.Добавить();
		ЗаполнитьЗначенияСвойств(ДанныеДокумента, Элемент.Значение);
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПрефиксацияОбъектов") Тогда
			МодульПрефиксацияОбъектовКлиентСервер = ОбщегоНазначения.ОбщийМодуль("ПрефиксацияОбъектовКлиентСервер");
			ДанныеДокумента.Номер = МодульПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДанныеДокумента.Номер);
		КонецЕсли;
		ДанныеДокумента.ПричинаУничтожения = НРег(ДанныеДокумента.ПричинаУничтожения);
		ДанныеДокумента.СпособУничтожения = НРег(ДанныеДокумента.СпособУничтожения);
		ДанныеДокумента.Категории = ТаблицаКатегорий;
		
		Категории = КатегорииДокументов[ДанныеДокумента.Ссылка];
		
		Если Не ЗначениеЗаполнено(Категории) Тогда
			Продолжить;
		КонецЕсли;
		
		НомерСтроки = 1;
		Для Каждого Категория Из Категории Цикл
			ПредставлениеКатегории = ЗащитаПерсональныхДанных.ПредставлениеКатегорииПерсональныхДанных(Категория);
			НоваяСтрока = ДанныеДокумента.Категории.Добавить();
			НоваяСтрока.НомерСтроки = НомерСтроки;
			НоваяСтрока.Категория = НРег(Лев(ПредставлениеКатегории, 1)) + Сред(ПредставлениеКатегории, 2);
			НомерСтроки = НомерСтроки + 1;
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ДанныеПечати;
	
КонецФункции

// Возвращаемое значение:
//  ТаблицаЗначений:
//   * НомерСтроки - Число
//   * Категория - Строка
//
Функция НоваяТаблицаКатегорий()
	
	ТаблицаКатегорий = Новый ТаблицаЗначений;
	ТаблицаКатегорий.Колонки.Добавить("НомерСтроки", Новый ОписаниеТипов("Число"));
	ТаблицаКатегорий.Колонки.Добавить("Категория", Новый ОписаниеТипов("Строка"));
	
	Возврат ТаблицаКатегорий;
	
КонецФункции

#КонецОбласти

#КонецЕсли
