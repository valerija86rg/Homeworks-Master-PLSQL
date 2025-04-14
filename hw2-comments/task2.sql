/*
Автор: Кайгородова В.А. 
Описание скрипта: API для сущностей “Платеж” и “Детали платежа”
*/
-- Создание платежа
Declare
   v_message        varchar2(200) := 'Платеж создан';
   c_status_create  constant number := 0;
begin
   dbms_output.put_line(v_message||'. Статус: '||c_status_create);
end;
/

-- Сброс платежа
Declare
   v_message      varchar2(200) := 'Сброс платежа в "ошибочный статус" с указанием причины';
   c_status_error constant number := 2;
   v_reason       varchar2(200) := 'недостаточно средств';
   
begin
   dbms_output.put_line(v_message||'. Статус: '||c_status_error||'. Причина: '||v_reason);
end;
/

-- Отмена платежа
Declare
   v_message       varchar2(200):= 'Отмена платежа с указанием причины';
   c_status_cancel constant number := 3;
   v_reason        varchar2(200):= 'ошибка пользователя';
begin
   dbms_output.put_line(v_message||'. Статус: '||c_status_cancel||'. Причина: '||v_reason);
end;
/

-- Завершение платежа
Declare
   v_message        varchar2(200) := 'Успешное завершение платежа';
   c_status_success constant number := 1;
begin
   dbms_output.put_line(v_message||'. Статус: '||c_status_success);
end;
/

-- Добавление или обновление данных по платежу
Declare
   v_message        varchar2(200) := 'Данные платежа добавлены или обновлены по списку id_поля/значение';
begin
   dbms_output.put_line(v_message);
end;
/

-- Удаление деталей платежа
Declare
   v_message        varchar2(200) := 'Детали платежа удалены по списку id_полей';
begin
   dbms_output.put_line(v_message);
end;
/