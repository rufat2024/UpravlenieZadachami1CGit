﻿Процедура УстановитьСтатус(Задача, Статус) Экспорт
	Элемент = Задача.ПолучитьОбъект();
	Элемент.Статус = Статус;
	Элемент.Записать();
КонецПроцедуры