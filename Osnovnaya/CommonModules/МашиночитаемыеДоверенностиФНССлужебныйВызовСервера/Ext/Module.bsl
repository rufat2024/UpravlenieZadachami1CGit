﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

Функция АвторизоватьсяНаСервереМЧДРР() Экспорт
	Возврат МашиночитаемыеДоверенностиФНССлужебный.АвторизоватьсяНаСервереМЧДРР();
КонецФункции

Функция ПолучитьНомерМЧДРР(ТокенДоступа = "") Экспорт
	Возврат МашиночитаемыеДоверенностиФНССлужебный.ПолучитьНомерМЧДРР(ТокенДоступа);
КонецФункции

Функция ЗарегистрироватьМЧДРР(ИмяФайлаВыгрузки, ДанныеИлиАдресВыгрузки, ДанныеИлиАдресПодписи, ТокенДоступа = "",
		НомерДоверенности = "") Экспорт 
		
	Возврат МашиночитаемыеДоверенностиФНССлужебный.ЗарегистрироватьМЧДРР(
		ИмяФайлаВыгрузки, ДанныеИлиАдресВыгрузки, ДанныеИлиАдресПодписи, ТокенДоступа, НомерДоверенности);
		
КонецФункции
	
Функция ЗагрузитьДоверенностьИзРеестра(НомерДоверенности, ИННДоверителя, ТокенДоступа = "") Экспорт
	Возврат МашиночитаемыеДоверенностиФНССлужебный.ЗагрузитьДоверенностьИзРеестра(НомерДоверенности, ИННДоверителя, ТокенДоступа);
КонецФункции 

Функция ОтменитьМЧДРР(ИмяФайлаВыгрузки, ДанныеИлиАдресВыгрузки, ДанныеИлиАдресПодписи, Доверенность, ТокенДоступа = "") Экспорт
	Возврат МашиночитаемыеДоверенностиФНССлужебный.ОтменитьМЧДРР(ИмяФайлаВыгрузки, ДанныеИлиАдресВыгрузки, ДанныеИлиАдресПодписи, Доверенность, ТокенДоступа);
КонецФункции

Функция ПолучитьФайлОтменыДоверенности(Доверенность, ПричинаОтмены) Экспорт
	Возврат МашиночитаемыеДоверенностиФНССлужебный.ПолучитьФайлОтменыДоверенности(Доверенность, ПричинаОтмены);
КонецФункции
	
Функция ИспользуетсяРежимТестирования() Экспорт
	Возврат МашиночитаемыеДоверенностиФНССлужебный.ИспользуетсяРежимТестирования();
КонецФункции

Процедура УстановитьПараметрСеансаПараметрыАвторизацииВРаспределенномРеестре(
	ИмяПараметра = Неопределено,
	УстановленныеПараметры = Неопределено) Экспорт
	МашиночитаемыеДоверенностиФНССлужебный.УстановитьПараметрСеансаПараметрыАвторизацииВРаспределенномРеестре(ИмяПараметра, УстановленныеПараметры)
КонецПроцедуры

Функция ДоверенностиДляНалоговыхОрганов(Доверенности) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	ИСТИНА
	               |ИЗ
	               |	Справочник.МашиночитаемыеДоверенности КАК МашиночитаемыеДоверенности
	               |ГДЕ
	               |	МашиночитаемыеДоверенности.Ссылка В(&Доверенности)
	               |	И МашиночитаемыеДоверенности.ДляНалоговыхОрганов";
	
	Запрос.УстановитьПараметр("Доверенности", Доверенности);
	
	Результат = Запрос.Выполнить();
	Возврат Не Результат.Пустой();
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция РезультатПроверкиДоверенности(Знач Доверенность, Знач ПроверятьВРеестреФНС = Неопределено, Знач ИдентификаторФормы = Неопределено) Экспорт
	
	Возврат МашиночитаемыеДоверенностиФНССлужебный.РезультатПроверкиДанныхДоверенности(МашиночитаемыеДоверенностиФНССлужебный.ДанныеМЧД(Доверенность),
		ПроверятьВРеестреФНС, ИдентификаторФормы);
	
КонецФункции

Функция РезультатПроверкиПодписиПоМЧД(Знач Доверенность, Знач ПодписанныйОбъект, Знач Сертификат, Знач НаДату, Знач ГотовыеПроверки) Экспорт
	
	Возврат МашиночитаемыеДоверенностиФНССлужебный.РезультатПроверкиПодписиПоМЧД(Доверенность, ПодписанныйОбъект, Сертификат, НаДату, ГотовыеПроверки);
	
КонецФункции

Функция РезультатПроверкиМЧДДляПодписания(Знач Доверенность, Знач Сертификат) Экспорт
	
	ПротоколПроверки = Новый Структура;
	ДатаПроверки = ТекущаяДатаСеанса();
	
	ПроверкаДоверенности = МашиночитаемыеДоверенностиФНССлужебный.РезультатПроверкиДоверенности(Доверенность);
	МашиночитаемыеДоверенностиФНССлужебный.ДобавитьВПротоколПроверкуДоверенности(ПротоколПроверки, ПроверкаДоверенности, ДатаПроверки);
	
	ПроверкаПодписанта = МашиночитаемыеДоверенностиФНССлужебный.ПроверитьСертификатПредставителя(Доверенность, Сертификат, ДатаПроверки);
	МашиночитаемыеДоверенностиФНССлужебный.ДобавитьВПротоколПроверкуПодписанта(ПротоколПроверки, ПроверкаПодписанта, ДатаПроверки);
	
	Возврат ПротоколПроверки;
	
КонецФункции

Функция ФайлыДоверенности(Знач Доверенность, Знач ДляНалоговыхОрганов) Экспорт
	
	Возврат МашиночитаемыеДоверенностиФНС.ФайлыДоверенности(Доверенность, ДляНалоговыхОрганов);
	
КонецФункции

// Возвращает машиночитаемые доверенности в виде набора файлов.
// Если файлы отдельно взятой доверенности еще не сформированы, то по ней возвращается пустой набор файлов.
// 
// Параметры:
//  Доверенности - Массив из СправочникСсылка.МашиночитаемыеДоверенности
//  
// Возвращаемое значение:
//   Соответствие из КлючИЗначение:
//    * Ключ - СправочникСсылка.МашиночитаемыеДоверенности
//    * Значение - см. ФайлыДоверенности
//
Функция ФайлыДоверенностей(Знач Доверенности, Знач ДляНалоговыхОрганов) Экспорт
	
	Возврат МашиночитаемыеДоверенностиФНС.ФайлыДоверенностей(Доверенности, ДляНалоговыхОрганов);
	
КонецФункции

#КонецОбласти
