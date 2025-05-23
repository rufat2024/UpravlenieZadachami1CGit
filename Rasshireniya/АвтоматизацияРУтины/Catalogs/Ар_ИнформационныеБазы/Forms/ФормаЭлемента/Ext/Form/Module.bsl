﻿
#Область ДействияФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ИнициализироватьНаКлиенте(Отказ);
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Ар_ИнформационныеБазыКлиент.ОбновитьФайлСпискаБазПоИнформационнойБазе(Объект.Ссылка)
КонецПроцедуры

#КонецОбласти

#Область ДействияЭлементовФормы

&НаКлиенте
Процедура ТипРасположенияИнформационныйБазыПриИзменении(Элемент)
	ИзменитьВидимостьСтраницТипыРасположенияИнформационныйБазыНаКлиенте();
КонецПроцедуры

&НаКлиенте
Процедура ВариантАутентификацииПриИзменении(Элемент)
	ИзменитьВидимостьНаКлиенте();
КонецПроцедуры

#КонецОбласти

#Область Команды

#КонецОбласти

#Область Заполнение

&НаКлиенте
Процедура ИнициализироватьНаКлиенте(Отказ)
	ИзменитьВидимостьНаКлиенте();
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВидимостьНаКлиенте()
	
	Данные = Ар_ИнформационныеБазыВызовСервера.ПолучитьДанныеФормированияКоманды(Объект.Ссылка);
	
	Элементы.Разрядность.Доступность 			= Данные.ЛичныйФайл;
	Элементы.ОсновнойРежимЗапуска.Доступность 	= Данные.ЛичныйФайл;
	Элементы.Версия1С.Доступность 				= Данные.ЛичныйФайл;
		
	Если Объект.ВариантАутентификации = ПредопределенноеЗначение("Перечисление.Ар_ВариантыАутентификации.АутентификацияWindows") Тогда 
		Элементы.Логин.Доступность				= Ложь;		
		Элементы.Пароль.Доступность				= Ложь;		
	Иначе 
		Элементы.Логин.Доступность				= Истина;		
		Элементы.Пароль.Доступность				= Истина;		
	КонецЕсли;
	
	ИзменитьВидимостьСтраницТипыРасположенияИнформационныйБазыНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВидимостьСтраницТипыРасположенияИнформационныйБазыНаКлиенте()
			
	Элементы.СтраницыТипыРасположенияИнформационнойБазы.ОтображениеСтраниц 	= ОтображениеСтраницФормы.Нет;
	
	Если Объект.ТипРасположенияИнформационныйБазы = ПредопределенноеЗначение("Перечисление.Ар_ТипыРасположенияИнформационныйБазы.НаДанномКомпьютереИлиНаКомпьютереВЛокальнойСети") Тогда 
		Элементы.СтраницыТипыРасположенияИнформационнойБазы.ТекущаяСтраница		= Элементы.СтраницаНаДанномКомпьютереИлиНаКомпьютереВЛокальнойСети;	
	ИначеЕсли Объект.ТипРасположенияИнформационныйБазы = ПредопределенноеЗначение("Перечисление.Ар_ТипыРасположенияИнформационныйБазы.НаВебСервере") Тогда
		Элементы.СтраницыТипыРасположенияИнформационнойБазы.ТекущаяСтраница		= Элементы.СтраницаНаВебСервере;	
	ИначеЕсли Объект.ТипРасположенияИнформационныйБазы = ПредопределенноеЗначение("Перечисление.Ар_ТипыРасположенияИнформационныйБазы.НаСервере1СПредприятия") Тогда
		Элементы.СтраницыТипыРасположенияИнформационнойБазы.ТекущаяСтраница		= Элементы.СтраницаНаСервере1СПредприятия;	
	КонецЕсли;	
			
КонецПроцедуры

#КонецОбласти

#Область Общее

#КонецОбласти
