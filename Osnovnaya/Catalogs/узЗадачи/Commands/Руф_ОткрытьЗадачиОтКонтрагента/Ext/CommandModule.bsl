﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	//Вставить содержимое обработчика.                   
	ЗначениеОтбора = Новый Структура("Контрагент", ПараметрКоманды);
	ПараметрыФормы = Новый Структура("Отбор", ЗначениеОтбора);
	ОткрытьФорму("Справочник.узЗадачи.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
КонецПроцедуры
