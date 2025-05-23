﻿Функция ВыполнитьПриложение(ТекстСкрипта, ТаймаутВыполненияКомандыСек = 600) Экспорт

	// Структура результата выполнения команды
	РезультатВыполненияСкрипта = Новый Структура;
	РезультатВыполненияСкрипта.Вставить("Вывод", "");
	РезультатВыполненияСкрипта.Вставить("Ошибки", "");

	// Вспомогательные переменные
	ТекстСкриптаДляВыполнения = "";
	ВременныйФайлСкрипта = "";
	ВременныйФайлРезультат = ""; 	

	// Сохраняем команду в файл BAT-скрипта
	ВременныйФайлСкрипта = ПолучитьИмяВременногоФайла("bat");
	ЗаписьТекстаСкрипта = Новый ТекстовыйДокумент;
	ЗаписьТекстаСкрипта.УстановитьТекст(ТекстСкрипта);
	ЗаписьТекстаСкрипта.Записать(ВременныйФайлСкрипта, "cp866");		
		
	ТекстСкриптаДляВыполнения = ВременныйФайлСкрипта;
	НачалоВыполненияКоманды = ТекущаяДата();
	ЗавершениеВыполненияКоманды = НачалоВыполненияКоманды + ТаймаутВыполненияКомандыСек;

	// Инициализация объекта WScript.Shell
	Попытка		
		objShell = Новый COMОбъект("WScript.Shell");		
	Исключение		
		ВызватьИсключение 
			"Не удалось инициализировать WScript.Shell.
			|Подробнее:
			|" + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());		
	КонецПопытки;
	// Выполнение команды
	objWshScriptExec = objShell.Exec(ТекстСкриптаДляВыполнения);
	objStdOut = objWshScriptExec.StdOut;
	objStdErr = objWshScriptExec.StdErr;

	// Проверка истечения времени таймаута
	КомандаЗавершенаПоТаймауту = Ложь;
	Пока objWshScriptExec.Status = 0 Цикл		
		Если ЗначениеЗаполнено(ТаймаутВыполненияКомандыСек) Тогда			
			Если ЗавершениеВыполненияКоманды <= ТекущаяДата() Тогда			
				КомандаЗавершенаПоТаймауту = Истина;			
				Прервать;				
			КонецЕсли;			
		Иначе			
			Прервать;			
		КонецЕсли;		
	КонецЦикла;

	// Читаем из потока результат выполнения команды - информация
	Если НЕ КомандаЗавершенаПоТаймауту Тогда	
		Пока Не objStdOut.AtEndOfStream Цикл			
			strLine = objStdOut.ReadLine();
			РезультатВыполненияСкрипта.Вывод = РезультатВыполненияСкрипта.Вывод 
				+ strLine 
				+ Символы.ВК 
				+ Символы.ПС;			
			Если ЗначениеЗаполнено(ТаймаутВыполненияКомандыСек)
				И ЗавершениеВыполненияКоманды <= ТекущаяДата() Тогда				
				КомандаЗавершенаПоТаймауту = Истина;
				Прервать;				
			КонецЕсли;			
		КонецЦикла; 		
	КонецЕсли;
	// Читаем из потока результат выполнения команды - ошибки
	Если НЕ КомандаЗавершенаПоТаймауту Тогда	
		Пока Не objStdErr.AtEndOfStream Цикл			
			strLine = objStdErr.ReadLine();
			РезультатВыполненияСкрипта.Ошибки = РезультатВыполненияСкрипта.Ошибки
				+ strLine 
				+ Символы.ВК 
				+ Символы.ПС;
				
			Если ЗначениеЗаполнено(ТаймаутВыполненияКомандыСек)
				И ЗавершениеВыполненияКоманды <= ТекущаяДата() Тогда				
				Прервать;				
			КонецЕсли;			
		КонецЦикла;		
	КонецЕсли;

	// "Насильно" завершаем процесс по завершению работы
	// и "уничтожаем" COM-объект
	Попытка		
		objWshScriptExec.Terminate();
		objWshScriptExec = Неопределено;		
	Исключение		
		objWshScriptExec = Неопределено;		
	КонецПопытки;	
	objShell = Неопределено;

	// Если команда завершена по таймауту - вызываем исключение.
	// Иначе читаем результат и удаляем временные файлы
	Если КомандаЗавершенаПоТаймауту Тогда		
		ВызватьИсключение "Внимание! Выполнение остановлено по истечении времени ожидания.";		
	Иначе		
		УдалитьФайлЕслиВозможно(ВременныйФайлСкрипта);
		
		РезультатВыполненияСкрипта.Вывод = ПреобразоватьКодировку(РезультатВыполненияСкрипта.Вывод);
		РезультатВыполненияСкрипта.Ошибки = ПреобразоватьКодировку(РезультатВыполненияСкрипта.Ошибки);		
	КонецЕсли;
	
	Возврат РезультатВыполненияСкрипта;
	
КонецФункции
функция ЗаписатьФайлВформатеUTF8безBOM(текст,полноеИмяФайла)

    // записываем в файл с символами BOM в начале файле	
    ТекстовыйФайлUTF8_Bom = Новый ТекстовыйДокумент();
    ТекстовыйФайлUTF8_Bom.ДобавитьСтроку(текст);
    ТекстовыйФайлUTF8_Bom.Записать(полноеИмяФайла,"UTF-8");
	
    // открываем файл и считываем символы после символов BOM
    Данные = Новый ДвоичныеДанные(полноеИмяФайла);
    Строка64=Base64Строка(Данные);
    Строка64=Прав(Строка64,СтрДлина(Строка64)-4);
    ДанныеНаЗапись=Base64Значение(Строка64);
    ДанныеНаЗапись.Записать(полноеИмяФайла); // записываем
	
КонецФункции
Функция ПреобразоватьКодировку(Текст, ИсходнаяКодировка = "windows-1251", НоваяКодировка = "cp866")
	
	ВременныйФайлИсходный = ПолучитьИмяВременногоФайла();
	
	ЗаписьТекстаИсходный = Новый ТекстовыйДокумент;
	ЗаписьТекстаИсходный.УстановитьТекст(Текст);
	ЗаписьТекстаИсходный.Записать(ВременныйФайлИсходный, ИсходнаяКодировка);
	
	ЧтениеТекстаНовый = Новый ТекстовыйДокумент;
	ЧтениеТекстаНовый.Прочитать(ВременныйФайлИсходный, НоваяКодировка); 
	КонвертированныйТекст = ЧтениеТекстаНовый.ПолучитьТекст();
	
	УдалитьФайлЕслиВозможно(ВременныйФайлИсходный);
	
	Возврат КонвертированныйТекст;	
	
КонецФункции
Функция УдалитьФайлЕслиВозможно(ПутьКФайлу)
	
	Если НЕ ЗначениеЗаполнено(ПутьКФайлу) Тогда
		Возврат Ложь;
	КонецЕсли;
		
	Попытка
		
		УдалитьФайлы(ПутьКФайлу);
		Возврат Истина;
		
	Исключение
		
		Возврат Ложь;
		
	КонецПопытки;
		
КонецФункции



Процедура ВыгрузитьКонфигурациюВКаталог(ИмяСервера, ИмяБазы, ИмяПользователь, ПарольПользователя, КаталогВыгрузи) Экспорт
	
	КаталогСерверногоПриложения = КаталогПрограммы();
	ПриложениеТолстыйКлиент = КаталогСерверногоПриложения + "1cv8.exe";
	
	КомандаКонфигуратора = """" + ПриложениеТолстыйКлиент + """"
		+ " DESIGNER"
		+ " /S""" + ИмяСервера + "\" + ИмяБазы + """"
		+ " /N""" + ИмяПользователь + """"
		+ " /P""" + ПарольПользователя + """"
		+ " /DumpConfigToFiles """ + КаталогВыгрузи + """"
		+ " ";
		
	РезультатВыполнения = ВыполнитьПриложение(КомандаКонфигуратора);
	Если ЗначениеЗаполнено(РезультатВыполнения.Ошибки) Тогда
		ВызватьИсключение "Не удалось выгрузить конфигурацию в файлы.
			|Подробно:
			|" + РезультатВыполнения.Ошибки;
	КонецЕсли;
	
КонецПроцедуры
