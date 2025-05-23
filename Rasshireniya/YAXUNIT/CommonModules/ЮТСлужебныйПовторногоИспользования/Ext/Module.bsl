﻿//©///////////////////////////////////////////////////////////////////////////©//
//
//  Copyright 2021-2024 BIA-Technologies Limited Liability Company
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

Функция АдресСерверногоКонтекста() Экспорт
	
	Возврат ЮТКонтекстСлужебныйВызовСервера.АдресСерверногоКонтекста(Ложь);
	
КонецФункции

Функция МетодМодуляСуществует(ИмяМодуля, ИмяМетода) Экспорт
	
	Возврат ЮТМетодыСлужебный.МетодМодуляСуществует(ИмяМодуля, ИмяМетода, Ложь);
	
КонецФункции

Функция ПараметрыТиповОшибок() Экспорт
	
	Возврат ЮТФабрикаСлужебный.ПараметрыТиповОшибок(Ложь);
	
КонецФункции

Функция ОписаниеТиповЛюбаяСсылка() Экспорт
	
	Возврат ЮТТипыДанныхСлужебный.ОписаниеТиповЛюбаяСсылка(Ложь);
	
КонецФункции

Функция ПодключитьКомпоненту(ИмяМакета, ИмяКомпоненты) Экспорт
	
	Возврат ЮТКомпоненты.ПодключитьКомпоненту(ИмяМакета, ИмяКомпоненты, Ложь);
	
КонецФункции

Функция СоздатьКомпоненту(ОписаниеКомпоненты) Экспорт
	
	Возврат ЮТКомпоненты.СоздатьКомпоненту(ОписаниеКомпоненты, Ложь);
	
КонецФункции
	
Функция ПримитивныеТипы() Экспорт
	
	Типы = Новый Массив();
	Типы.Добавить(Тип("Строка"));
	Типы.Добавить(Тип("Число"));
	Типы.Добавить(Тип("Дата"));
	Типы.Добавить(Тип("Булево"));
	Типы.Добавить(Тип("УникальныйИдентификатор"));
	
	Возврат Новый ФиксированныйМассив(Типы);
	
КонецФункции

Функция МножителиИнтервалов() Экспорт
	
	СекундВМинуте = 60;
	СекундВЧасе = СекундВМинуте * 60;
	СекундВДне = СекундВЧасе * 24;
	СекундВНеделе = СекундВДне * 7;
	
	Множители = Новый Структура;
	Множители.Вставить("секунда", 1);
	Множители.Вставить("секунды", 1);
	Множители.Вставить("секунд", 1);
	Множители.Вставить("минута", СекундВМинуте);
	Множители.Вставить("минуты", СекундВМинуте);
	Множители.Вставить("минут", СекундВМинуте);
	Множители.Вставить("час", СекундВЧасе);
	Множители.Вставить("часа", СекундВЧасе);
	Множители.Вставить("часов", СекундВЧасе);
	Множители.Вставить("день", СекундВДне);
	Множители.Вставить("дня", СекундВДне);
	Множители.Вставить("дней", СекундВДне);
	Множители.Вставить("неделя", СекундВНеделе);
	Множители.Вставить("недели", СекундВНеделе);
	Множители.Вставить("недель", СекундВНеделе);
	
	Возврат Множители;
	
КонецФункции

Функция ВерсияПлатформы() Экспорт
	
	СистемнаяИнформация = Новый СистемнаяИнформация();
	Возврат СистемнаяИнформация.ВерсияПриложения;
	
КонецФункции

Функция ОбработчикиСобытий(Знач Подсистема, Знач Серверные = Истина, Знач Клиентские = Истина) Экспорт
	
	Возврат ЮТПодключаемыеМодулиСлужебныйВызовСервера.ОбработчикиСобытий(Подсистема, Серверные, Клиентские);
	
КонецФункции

#КонецОбласти
