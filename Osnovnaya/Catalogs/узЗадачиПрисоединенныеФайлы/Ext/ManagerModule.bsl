﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает реквизиты объекта, которые разрешается редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	// +++ Шевченко 19.01.2024 +++
	//ориг	Возврат ПрисоединенныеФайлы.РеквизитыРедактируемыеВГрупповойОбработке();
	Возврат РаботаСФайлами.РеквизитыРедактируемыеВГрупповойОбработке();
	// --- Шевченко ---
	
КонецФункции

//+ #201 Иванов А.Б. 2020-05-23 Изменения от Дениса Урянского @d-hurricane
// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	Ограничение.Текст =
	"РазрешитьЧтение
	|ГДЕ
	|	ЧтениеОбъектаРазрешено(ВладелецФайла)
	|;
	|РазрешитьИзменениеЕслиРазрешеноЧтение
	|ГДЕ
	|	ИзменениеОбъектаРазрешено(ВладелецФайла)";
	
КонецПроцедуры //- #201 Иванов А.Б. 2020-05-23 Изменения от Дениса Урянского @d-hurricane

#КонецОбласти

#КонецЕсли
