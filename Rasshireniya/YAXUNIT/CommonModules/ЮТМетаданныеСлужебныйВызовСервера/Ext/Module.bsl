﻿//©///////////////////////////////////////////////////////////////////////////©//
//
//  Copyright 2021-2025 BIA-Technologies Limited Liability Company
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//©///////////////////////////////////////////////////////////////////////////©//

#Область СлужебныйПрограммныйИнтерфейс

#Область РаботаСРаширениями

// МодулиРасширений
// Выполняет чтение метаданных общих модулей, которые предположительно могут являться тестами
// 
// Возвращаемое значение:
//  Массив из см. ЮТФабрика.ОписаниеМетаданныеМодуля - Коллекция описаний моделей
Функция МодулиРасширений() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МетаданныеМодулей = Новый Массив;
	
	Для Каждого Модуль Из Метаданные.ОбщиеМодули Цикл
		
		Если Модуль.РасширениеКонфигурации() <> Неопределено Тогда
			
			МетаданныеМодуля = МетаданныеМодуля(Модуль);
			МетаданныеМодулей.Добавить(МетаданныеМодуля);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат МетаданныеМодулей;
	
КонецФункции

Функция РасширенияСеанса() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат РасширенияКонфигурации.Получить(, ИсточникРасширенийКонфигурации.СеансАктивные);
	
КонецФункции

Функция СсылочныеТипыРасширений() Экспорт
	
	МассивТипов = Новый Массив;
	
	СсылочныеКоллекции = СсылочныеКоллекции();
	СобственныйОбъект = Метаданные.СвойстваОбъектов.ПринадлежностьОбъекта.Собственный;
	
	Для Каждого Расширение Из РасширенияСеанса() Цикл
		
		Если НЕ Расширение.ИзменяетСтруктуруДанных() Тогда
			Продолжить;
		КонецЕсли;
		
		УстановитьБезопасныйРежим(Истина);
		// Создание через тип не работает, ошибка - конструктор не найден
		МетаданныеРасширения = Вычислить("Новый ОбъектМетаданныхКонфигурация(Расширение.ПолучитьДанные())");
		
		Для Каждого ИмяКоллекции Из СсылочныеКоллекции Цикл
			
			Коллекция = МетаданныеРасширения[ИмяКоллекции];
			ИмяЭлемента = ЮТМетаданныеСлужебныйПовтИсп.ТипыМетаданных()[ИмяКоллекции].Имя;
			
			Для Каждого ОбъектМетаданных Из Коллекция Цикл
				
				Если ОбъектМетаданных.ПринадлежностьОбъекта = СобственныйОбъект Тогда
					МассивТипов.Добавить(СтрШаблон("%1Ссылка.%2", ИмяЭлемента, ОбъектМетаданных.Имя));
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;
	
	ОписаниеТипов = Новый ОписаниеТипов(МассивТипов);
	Возврат ОписаниеТипов.Типы();
	
КонецФункции

#КонецОбласти

Функция ИменаМодулейДвижка() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Подсистема = Метаданные.Подсистемы.ЮТДвижок;
	
	Модули = Новый Массив;
	ЗаполнитьМодулиПодсистемыИПодчиненных(Подсистема, Модули);
	
	Возврат Модули;
	
КонецФункции

Функция МодулиПодсистемы(Знач Подсистема, Знач Серверные, Знач Клиентские) Экспорт
	
	Модули = Новый Массив();
	
	Для Каждого Объект Из Подсистема.Состав Цикл
		
		Если Метаданные.ОбщиеМодули.Содержит(Объект) Тогда
			
			Добавить = (Серверные И Клиентские)
				ИЛИ (Серверные И (Объект.Сервер))
				ИЛИ (Клиентские И (Объект.КлиентУправляемоеПриложение Или Объект.ВызовСервера));
				// КлиентОбычноеПриложение сознательно не анализируется, он должен идти в паре с другой настройкой
			
			Если Добавить Тогда
				Модули.Добавить(Объект.Имя);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Модули;
	
КонецФункции

Функция МетаданныеМодуля(Знач Модуль) Экспорт
	
	Если ТипЗнч(Модуль) = Тип("Строка") Тогда
		ИмяМодуля = Модуль;
		Модуль = Метаданные.ОбщиеМодули.Найти(ИмяМодуля);
		
		Если Модуль = Неопределено Тогда
			ВызватьИсключение "Не найден модуль с именем " + ИмяМодуля;
		КонецЕсли;
	КонецЕсли;
	
	Описание = ЮТФабрика.ОписаниеМетаданныеМодуля();
	Описание.Тип = "ОбщийМодуль";
	Описание.Имя = Модуль.Имя;
	Описание.КлиентУправляемоеПриложение = Модуль.КлиентУправляемоеПриложение;
	Описание.КлиентОбычноеПриложение = Модуль.КлиентОбычноеПриложение;
	Описание.Глобальный = Модуль.Глобальный;
	Описание.Сервер = Модуль.Сервер;
	Описание.ВызовСервера = Модуль.ВызовСервера;
	Описание.Расширение = Модуль.РасширениеКонфигурации().Имя;
	
	Возврат Описание;
	
КонецФункции

Функция ОписаниеОбъектаМетаданных(Знач Значение, ЗаполнятьРеквизиты = Истина) Экспорт
	
	МетаданныеОбъекта = ОбъектМетаданных(Значение);
	ОписаниеТипа = ОписаниеТипаМетаданных(МетаданныеОбъекта);
	
	ОписаниеОбъект = ЮТМетаданные.СтруктураОписанияОбъектаМетаданных();
	ОписаниеОбъект.Имя = МетаданныеОбъекта.Имя;
	ОписаниеОбъект.ОписаниеТипа = ОписаниеТипа;
	ЮТОбщий.УказатьТипСтруктуры(ОписаниеОбъект, "ОписаниеОбъектаМетаданных");
	
	Если НЕ ЗаполнятьРеквизиты Тогда
		Возврат ОписаниеОбъект;
	КонецЕсли;
	
	Для Каждого НаборРеквизитов Из ОписаниеТипа.НаборыРеквизитов Цикл
		Если СтрСравнить(НаборРеквизитов, "СтандартныеРеквизиты") = 0 Тогда
			Ключ = "Ссылка, Период";
		ИначеЕсли СтрСравнить(НаборРеквизитов, "Измерения") = 0 Тогда
			Ключ = Истина;
		Иначе
			Ключ = Ложь;
		КонецЕсли;
		
		ДобавитьОписанияРеквизитов(МетаданныеОбъекта[НаборРеквизитов], ОписаниеОбъект.Реквизиты, Ключ);
	КонецЦикла;
	
	ДобавитьОбщиеРеквизиты(МетаданныеОбъекта, ОписаниеОбъект.Реквизиты);
	
	Если ОписаниеТипа.ТабличныеЧасти Тогда
		
		Для Каждого ТабличнаяЧасть Из МетаданныеОбъекта.ТабличныеЧасти Цикл
			РеквизитыТабличнойЧасти = Новый Структура();
			ДобавитьОписанияРеквизитов(ТабличнаяЧасть.Реквизиты, РеквизитыТабличнойЧасти, Ложь);
			
			ОписаниеОбъект.ТабличныеЧасти.Вставить(ТабличнаяЧасть.Имя, РеквизитыТабличнойЧасти);
		КонецЦикла;
		
	КонецЕсли;
	
	Если ОписаниеТипа.ВидыСубконто Тогда
		
		РеквизитыТабличнойЧасти = Новый Структура();
		
		ОписаниеРеквизита = ОписаниеРеквизита("ВидСубконто", ЮТТипыДанныхСлужебный.НовыйТипСсылки(МетаданныеОбъекта.ВидыСубконто), Истина);
		РеквизитыТабличнойЧасти.Вставить(ОписаниеРеквизита.Имя, ОписаниеРеквизита);
		
		ОписаниеРеквизита = ОписаниеРеквизита("Предопределенное", Новый ОписаниеТипов("Булево"));
		РеквизитыТабличнойЧасти.Вставить(ОписаниеРеквизита.Имя, ОписаниеРеквизита);
		
		ОписаниеРеквизита = ОписаниеРеквизита("ТолькоОбороты", Новый ОписаниеТипов("Булево"));
		РеквизитыТабличнойЧасти.Вставить(ОписаниеРеквизита.Имя, ОписаниеРеквизита);
		
		ДобавитьОписанияРеквизитов(МетаданныеОбъекта.ПризнакиУчетаСубконто, РеквизитыТабличнойЧасти, Ложь);
		
		ОписаниеОбъект.ТабличныеЧасти.Вставить("ВидыСубконто", РеквизитыТабличнойЧасти);
		
	КонецЕсли;
	
	Возврат Новый ФиксированнаяСтруктура(ОписаниеОбъект);
	
КонецФункции

// Описание типа метаданных.
// 
// Параметры:
//  МетаданныеОбъекта - Тип, ОбъектМетаданных - Тип
// 
// Возвращаемое значение:
//  см. ЮТМетаданные.ОписаниеТипаМетаданных
Функция ОписаниеТипаМетаданных(Знач МетаданныеОбъекта) Экспорт
	
	Если ТипЗнч(МетаданныеОбъекта) = Тип("Тип") Тогда
		МетаданныеОбъекта = Метаданные.НайтиПоТипу(МетаданныеОбъекта);
	КонецЕсли;
	
	ПолноеИмя = МетаданныеОбъекта.ПолноеИмя();
	ЧастиИмени = СтрРазделить(ПолноеИмя, ".");
	Типы = ЮТМетаданныеСлужебныйПовтИсп.ТипыМетаданных();
	
	Если НЕ Типы.Свойство(ЧастиИмени[0]) Тогда
		Сообщение = СтрШаблон("Получение описания для '%1' не поддерживается, либо не реализовано", ЧастиИмени[0]);
		ВызватьИсключение Сообщение;
	КонецЕсли;
	
	Описание = ЮТМетаданные.ОписаниеТипаМетаданных();
	ЗаполнитьЗначенияСвойств(Описание, Типы[ЧастиИмени[0]]);
	//@skip-check constructor-function-return-section
	Возврат Новый ФиксированнаяСтруктура(Описание);
	
КонецФункции

Функция ТипыМетаданных() Экспорт
	
	Макет = ПолучитьОбщийМакет("ЮТОписаниеМетаданных").ПолучитьТекст();
	КоллекцияОписаний = ЮТТестовыеДанные.ТаблицаMarkDown(Макет);
	
	ТипыМетаданных = Новый Структура();
	
	//@skip-check structure-consructor-too-many-keys
	ИменаОбработкаОтчет = Новый Структура("Обработка, Отчет, Report, DataProcessor");
	
	Для Каждого Запись Из КоллекцияОписаний Цикл
		
		Описание = ЮТМетаданные.ОписаниеТипаМетаданных();
		Описание.Имя = Запись.Имя;
		Описание.ИмяКоллекции = Запись.ИмяКоллекции;
		Описание.Конструктор = Запись.Конструктор;
		Описание.НаборыРеквизитов = ЮТСтроки.РазделитьСтроку(Запись.Реквизиты, ",");
		Описание.Группы = Запись.Группы = "+";
		Описание.Ссылочный = Запись.Ссылочный = "+";
		Описание.ТабличныеЧасти = Запись.ТабличныеЧасти = "+";
		Описание.ВидыСубконто = Запись.ВидыСубконто = "+";
		Описание.УстановитьНовыйКод = Запись.УстановитьНовыйКод = "+";
		Описание.ОбработкаОтчет = ИменаОбработкаОтчет.Свойство(Запись.Имя);
		Описание.Регистр = СтрНачинаетсяС(Запись.Имя, "Регистр") Или СтрЗаканчиваетсяНа(Запись.Имя, "Register");
		
		ТипыМетаданных.Вставить(Описание.Имя, Описание);
		ТипыМетаданных.Вставить(Описание.ИмяКоллекции, Описание);
		
	КонецЦикла;
	
	Возврат ТипыМетаданных;
	
КонецФункции

Функция РазрешеныСинхронныеВызовы() Экспорт
	
	Режим = Метаданные.СвойстваОбъектов.РежимИспользованияСинхронныхВызововРасширенийПлатформыИВнешнихКомпонент;
	Возврат Метаданные.РежимИспользованияСинхронныхВызововРасширенийПлатформыИВнешнихКомпонент = Режим.Использовать;
	
КонецФункции

Функция РегистрыДвиженийДокумента(ПолноеИмя) Экспорт
	
	ОбъектМетаданных = ОбъектМетаданных(ПолноеИмя);
	
	Если НЕ Метаданные.Документы.Содержит(ОбъектМетаданных) Тогда
		ВызватьИсключение "Движения доступны только для документов. Не поддерживается получение движений для " + ПолноеИмя;
	КонецЕсли;
	
	Регистры = Новый Структура;
	
	Для Каждого Регистр Из ОбъектМетаданных.Движения Цикл
		
		Регистры.Вставить(Регистр.Имя, Регистр.ПолноеИмя());
		
	КонецЦикла;
	
	Возврат Регистры;
	
КонецФункции

Функция ОписаниеТиповЛюбаяСсылкаПоМетаданным() Экспорт
	
	МассивТипов = Новый Массив;
	
	СсылочныеКоллекции = СсылочныеКоллекции();
	
	Для Каждого ИмяКоллекции Из СсылочныеКоллекции Цикл
		
		Коллекция = Метаданные[ИмяКоллекции];
		ИмяЭлемента = ЮТМетаданныеСлужебныйПовтИсп.ТипыМетаданных()[ИмяКоллекции].Имя;
		
		Для Каждого ОбъектМетаданных Из Коллекция Цикл
			
			МассивТипов.Добавить(СтрШаблон("%1Ссылка.%2", ИмяЭлемента, ОбъектМетаданных.Имя));
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Новый ОписаниеТипов(СтрСоединить(МассивТипов, ","));
	
КонецФункции
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОбъектМетаданных(Значение)
	
	ТипЗначение = ТипЗнч(Значение);
	
	Если ТипЗначение = Тип("Тип") Тогда
		
		ОбъектМетаданных = Метаданные.НайтиПоТипу(Значение);
		
	ИначеЕсли ТипЗначение = Тип("ОбъектМетаданных") Тогда
		
		ОбъектМетаданных = Значение;
		
	ИначеЕсли ТипЗначение = Тип("Строка") Тогда
		
		ОбъектМетаданных = ОбъектМетаданныхИзСтроки(Значение);
		
	ИначеЕсли ЮТТипыДанныхСлужебный.ЭтоСтруктура(ТипЗначение) И Значение.Свойство("ОписаниеТипа") И Значение.Свойство("Имя") Тогда
		
		ОбъектМетаданных = Метаданные[Значение.ОписаниеТипа.ИмяКоллекции][Значение.Имя];
		
	Иначе
		
		ОбъектМетаданных = Неопределено;
		
	КонецЕсли;
	
	Если ОбъектМетаданных = Неопределено Тогда
		Сообщение = ЮТИсключения.НеподдерживаемыйПараметрМетода("ЮТМетаданныеСлужебныйВызовСервера.ОбъектМетаданных", Значение);
		ВызватьИсключение Сообщение;
	КонецЕсли;
	
	Возврат ОбъектМетаданных;
	
КонецФункции

Функция ОбъектМетаданныхИзСтроки(Значение)
	
	ЧастиСтроки = СтрРазделить(Значение, ".");
	
	Если ЧастиСтроки.Количество() = 2 Тогда
		
		ТипыМетаданных = ЮТМетаданныеСлужебныйПовтИсп.ТипыМетаданных();
		ОписаниеТипа = ТипыМетаданных[ЧастиСтроки[0]];
		Если ОписаниеТипа <> Неопределено Тогда
			ОбъектМетаданных = Метаданные[ОписаниеТипа.ИмяКоллекции].Найти(ЧастиСтроки[1]);
			
			Если ОбъектМетаданных = Неопределено Тогда
				ВызватьИсключение "Не найден объект метаданных " + Значение;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ОбъектМетаданных;
	
КонецФункции

Процедура ДобавитьОписанияРеквизитов(КоллекцияРеквизитов, КоллекцияОписаний, Знач ЭтоКлюч)
	
	Если ТипЗнч(ЭтоКлюч) = Тип("Строка") Тогда
		ИменаКлючевыхПолей = СтрРазделить(ЭтоКлюч, ", ");
	КонецЕсли;
	
	Для Каждого Реквизит Из КоллекцияРеквизитов Цикл
		
		Если ИменаКлючевыхПолей <> Неопределено Тогда
			ЭтоКлюч = ИменаКлючевыхПолей.Найти(Реквизит.Имя) <> Неопределено;
		КонецЕсли;
		
		КоллекцияОписаний.Вставить(Реквизит.Имя, НовоеОписаниеРеквизита(Реквизит, ЭтоКлюч));
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьОбщиеРеквизиты(МетаданныеОбъекта, КоллекцияОписаний)
	
	Использовать = Метаданные.СвойстваОбъектов.ИспользованиеОбщегоРеквизита.Использовать;
	Авто = Метаданные.СвойстваОбъектов.ИспользованиеОбщегоРеквизита.Авто;
	АвтоИспользование = Метаданные.СвойстваОбъектов.АвтоИспользованиеОбщегоРеквизита.Использовать;
	
	Для Каждого Реквизит Из Метаданные.ОбщиеРеквизиты Цикл
		
		ЭлементСостава = Реквизит.Состав.Найти(МетаданныеОбъекта);
		
		Если ЭлементСостава = Неопределено Тогда
			Продолжить;
		ИначеЕсли ЭлементСостава.Использование = Использовать Или Реквизит.АвтоИспользование = АвтоИспользование И ЭлементСостава.Использование = Авто Тогда
			КоллекцияОписаний.Вставить(Реквизит.Имя, НовоеОписаниеРеквизита(Реквизит, Ложь));
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция НовоеОписаниеРеквизита(Реквизит, ЭтоКлюч)
	
	Описание = ЮТМетаданные.ОписаниеРеквизита();
	Описание.Имя = Реквизит.Имя;
	Описание.Тип = Реквизит.Тип;
	Описание.Обязательный = Реквизит.ПроверкаЗаполнения = ПроверкаЗаполнения.ВыдаватьОшибку;
	Описание.ЭтоКлюч = ЭтоКлюч;
	
	Возврат Описание;
	
КонецФункции

Функция ВерсияДвижка() Экспорт
	
	Возврат Метаданные.ОбщиеМодули.ЮТМетаданныеСлужебныйВызовСервера.РасширениеКонфигурации().Версия;
	
КонецФункции

Функция ПодсистемыПодключаемыхМодулей() Экспорт
	
	ИмяПодсистемы = "ЮТПодключаемыеМодули";
	Результат = Новый Массив();
	Результат.Добавить(ИмяПодсистемы);
	
	Для Каждого Подсистема Из Метаданные.Подсистемы Цикл
		
		Если Подсистема.ВключатьВКомандныйИнтерфейс Тогда
			Продолжить;
		КонецЕсли;
		
		Если СтрЗаканчиваетсяНа(Подсистема.Имя, "_" + ИмяПодсистемы) Тогда
			Результат.Добавить(Подсистема.Имя);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ОписаниеРеквизита(Имя, Тип, Обязательное = Ложь)
	
	ОписаниеРеквизита = ЮТМетаданные.ОписаниеРеквизита();
	ОписаниеРеквизита.Имя = Имя;
	ОписаниеРеквизита.Обязательный = Обязательное;
	ОписаниеРеквизита.Тип = Тип;
	
	Возврат ОписаниеРеквизита;
	
КонецФункции

Процедура ЗаполнитьМодулиПодсистемыИПодчиненных(Подсистема, Модули)
	
	МодулиПодсистемы = МодулиПодсистемы(Подсистема, Истина, Истина);
	ЮТКоллекции.ДополнитьМассив(Модули, МодулиПодсистемы);
	
	Для Каждого ВложеннаяПодсистема Из Подсистема.Подсистемы Цикл
		
		ЗаполнитьМодулиПодсистемыИПодчиненных(ВложеннаяПодсистема, Модули);
		
	КонецЦикла;
	
КонецПроцедуры

Функция СсылочныеКоллекции()
	
	Возврат ЮТКоллекции.ЗначениеВМассиве("Справочники",
										 "Документы",
										 "БизнесПроцессы",
										 "Задачи",
										 "ПланыСчетов",
										 "ПланыОбмена",
										 "ПланыВидовХарактеристик",
										 "ПланыВидовРасчета");
	
КонецФункции

#КонецОбласти
