///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Значение < 0 Или Значение > 2 Тогда
		ТекстОшибки = НСтр("ru = 'Недопустимое значение константы: %1. Допустимые значения:
			|0 - не усовершенствовать подписи автоматически и не показывать команды для ручной обработки в интерфейсе;
			|1 - усовершенствовать регламентным заданием;
			|2 - усовершенствовать вручную (показывать команды в интерфейсе администратора и в текущих делах)'");
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, Значение);
	КонецЕсли;
	
	ЭлектроннаяПодписьСлужебный.ИзменитьРегламентноеЗаданиеПродлениеДостоверностиПодписей(Значение);

КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли