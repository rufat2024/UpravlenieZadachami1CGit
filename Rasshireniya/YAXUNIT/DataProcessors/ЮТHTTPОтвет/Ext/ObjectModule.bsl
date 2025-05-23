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

#Если Сервер Тогда

#Область ОписаниеПеременных

// Заголовки
Перем Headers Экспорт; // ENG
Перем Заголовки Экспорт;

// Код состояния
Перем StatusCode Экспорт;  // ENG
Перем КодСостояния Экспорт;

// Контекст конструктора
Перем Контекст;

#КонецОбласти

#Область ПрограммныйИнтерфейс

#Область HTTPОтвет

// Получает имя файла, в который было записано тело (ENG)
//
// Возвращаемое значение:
//  - Строка - Имя файла
//  - Неопределено - Если тело не записывалось в файл
//
Функция GetBodyFileName() Экспорт
	
	Возврат ПолучитьИмяФайлаТела();
	
КонецФункции

// Получает тело в виде двоичных данных (ENG)
//
// Возвращаемое значение:
//  - ДвоичныеДанные - Тело в виде двоичных данных
//  - Неопределено - Если тело записывалось в файл
//
Функция GetBodyAsBinaryData() Экспорт
	
	Возврат ПолучитьТелоКакДвоичныеДанные();
	
КонецФункции

// Получает поток для чтения тела (ENG)
//
// Возвращаемое значение:
//  - Поток - Если тело не записывалось в файл
//  - ФайловыйПоток - Если тело записывалось в файл
//
Функция GetBodyAsStream() Экспорт
	
	Возврат ПолучитьТелоКакПоток();
	
КонецФункции

// Получает тело в виде строки (ENG)
//
// Параметры:
//  Кодировка - КодировкаТекста, Строка - Указывает кодировку, в которой должно интерпретироваться тело
//
// Возвращаемое значение:
//  - Строка - Тело в виде строки
//  - Неопределено - Если тело записывалось в файл
//
Функция GetBodyAsString(Кодировка = Неопределено) Экспорт
	
	Возврат ПолучитьТелоКакСтроку(Кодировка);
	
КонецФункции

// Получает имя файла, в который было записано тело
//
// Возвращаемое значение:
//  - Строка - Имя файла
//  - Неопределено - Если тело не записывалось в файл
//
Функция ПолучитьИмяФайлаТела() Экспорт
	
	Если НЕ Контекст.ИзФайла Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Контекст.ИмяФайла;
	
КонецФункции

// Получает тело в виде двоичных данных
//
// Возвращаемое значение:
//  - ДвоичныеДанные - Тело в виде двоичных данных
//  - Неопределено - Если тело записывалось в файл
//
Функция ПолучитьТелоКакДвоичныеДанные() Экспорт
	
	Если Контекст.ИзФайла Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ТипТела = ТипЗнч(Контекст.Тело);
	
	Если ТипТела = Тип("ДвоичныеДанные") Тогда
		ДвоичныеДанные = Контекст.Тело;
	ИначеЕсли ТипТела = Тип("Строка") Тогда
		ДвоичныеДанные = ПолучитьДвоичныеДанныеИзСтроки(Контекст.Тело);
	Иначе
		ДвоичныеДанные = ПолучитьДвоичныеДанныеИзСтроки("");
	КонецЕсли;
	
	Возврат ДвоичныеДанные;
	
КонецФункции

// Получает поток для чтения тела
//
// Возвращаемое значение:
//  - Поток - Если тело не записывалось в файл
//  - ФайловыйПоток - Если тело записывалось в файл
//
Функция ПолучитьТелоКакПоток() Экспорт
	
	Если Контекст.ИзФайла Тогда
		Поток = Новый ФайловыйПоток(Контекст.ИмяФайла, РежимОткрытияФайла.Открыть);
	Иначе
		Поток = ПолучитьТелоКакДвоичныеДанные().ОткрытьПотокДляЧтения();
	КонецЕсли;
	
	Возврат Поток;
	
КонецФункции

// Получает тело в виде строки
//
// Параметры:
//  Кодировка - КодировкаТекста, Строка - Указывает кодировку, в которой должно интерпретироваться тело
//
// Возвращаемое значение:
//  - Строка - Тело в виде строки
//  - Неопределено - Если тело записывалось в файл
//
Функция ПолучитьТелоКакСтроку(Кодировка = Неопределено) Экспорт
	
	Если Контекст.ИзФайла Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ТипТела = ТипЗнч(Контекст.Тело);
	
	Если ТипТела = Тип("ДвоичныеДанные") Тогда
		Тело = ПолучитьСтрокуИзДвоичныхДанных(Контекст.Тело, Кодировка);
	ИначеЕсли ТипТела = Тип("Строка") Тогда
		Тело = Контекст.Тело;
	Иначе
		Тело = "";
	КонецЕсли;
	
	Возврат Тело;
	
КонецФункции

#КонецОбласти

#Область Конструктор

// Записывает тело в файл, устанавливает тело и имя файла для чтения тела
//
// Параметры:
//  Тело - Строка - Тело в виде строки
//       - ДвоичныеДанные - Тело в виде двоичных данных
//       - Неопределено - Будет взято тело установленное через метод УстановитьТело
//  ИмяФайла - Строка - Имя файла
//           - Неопределено - Будет взято имя установленное через метод УстановитьИмяФайлаТела
//                            или сгенерировано имя временного файла
//
// Возвращаемое значение:
//  ОбработкаОбъект.ЮТHTTPОтвет - Конструктор
//
Функция ЗаписатьТелоВФайл(Тело = Неопределено, ИмяФайла = Неопределено) Экспорт
	
	Если Тело = Неопределено И ЗначениеЗаполнено(Контекст.Тело) Тогда
		Тело = Контекст.Тело;
	КонецЕсли;
	
	Если ИмяФайла = Неопределено Тогда
		Если ЗначениеЗаполнено(Контекст.ИмяФайла) Тогда
			ИмяФайла = Контекст.ИмяФайла;
		Иначе
			ИмяФайла = ПолучитьИмяВременногоФайла();
		КонецЕсли;
	КонецЕсли;
	
	УстановитьТело(Тело);
	УстановитьИмяФайлаТела(ИмяФайла);
	ДвоичныеДанные = ПолучитьТелоКакДвоичныеДанные();
	ДвоичныеДанные.Записать(ИмяФайла);
	Возврат ЭтотОбъект;
	
КонецФункции

// Добавляет заголовки
//
// Параметры:
//  Значения - Соответствие:
//    * Ключ - Строка - Наименование заголовка
//    * Значение - Строка - Значение заголовка
//
// Возвращаемое значение:
//  ОбработкаОбъект.ЮТHTTPОтвет - Конструктор
//
Функция ДобавитьЗаголовки(Значения) Экспорт
	
	Для Каждого ЭлементКоллекции Из Значения Цикл
		ДобавитьЗаголовок(ЭлементКоллекции.Ключ, ЭлементКоллекции.Значение);
	КонецЦикла;
	
	Возврат ЭтотОбъект;
	
КонецФункции

// Добавляет заголовок
//
// Параметры:
//  Ключ - Строка - Наименование заголовка
//  Значение - Строка - Значение заголовка
//
// Возвращаемое значение:
//  ОбработкаОбъект.ЮТHTTPОтвет - Конструктор
//
Функция ДобавитьЗаголовок(Ключ, Значение) Экспорт
	
	Headers.Вставить(Ключ, Значение);
	Заголовки.Вставить(Ключ, Значение);
	Возврат ЭтотОбъект;
	
КонецФункции

// Устанавливает имя файла для чтения тела
//
// Параметры:
//  ИмяФайла - Строка - Имя файла
//
// Возвращаемое значение:
//  ОбработкаОбъект.ЮТHTTPОтвет - Конструктор
//
Функция УстановитьИмяФайлаТела(ИмяФайла) Экспорт
	
	Контекст.ИзФайла = Истина;
	Контекст.ИмяФайла = ИмяФайла;
	Возврат ЭтотОбъект;
	
КонецФункции

// Устанавливает код состояния
//
// Параметры:
//  Значение - Число - Код состояния
//
// Возвращаемое значение:
//  ОбработкаОбъект.ЮТHTTPОтвет - Конструктор
//
Функция УстановитьКодСостояния(Значение) Экспорт
	
	StatusCode = Значение;
	КодСостояния = Значение;
	Возврат ЭтотОбъект;
	
КонецФункции

// Устанавливает тело
//
// Параметры:
//  Тело - Строка - Тело в виде строки
//       - ДвоичныеДанные - Тело в виде двоичных данных
//
// Возвращаемое значение:
//  ОбработкаОбъект.ЮТHTTPОтвет - Конструктор
//
Функция УстановитьТело(Тело) Экспорт
	
	Контекст.Тело = Тело;
	Возврат ЭтотОбъект;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Инициализирует начальные значения переменных
//
Процедура Инициализировать()
	
	Заголовки = Новый Соответствие();
	Headers = Новый Соответствие();
	
	КодСостояния = 0;
	StatusCode = 0;
	
	Контекст = Новый Структура;
	Контекст.Вставить("ИзФайла", Ложь);
	Контекст.Вставить("ИмяФайла", "");
	Контекст.Вставить("Тело", Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область Инициализация

Инициализировать();

#КонецОбласти

#КонецЕсли
