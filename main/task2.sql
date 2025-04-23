/*
Автор: Кайгородова В.А. 
Описание скрипта: API для сущностей “Платеж” и “Детали платежа”
*/
-- Создание платежа
Declare
   v_message        varchar2(200 char) := 'Платеж создан';
   c_status_create  constant number(1) := 0;
   v_current_dtime  date := sysdate;
begin
   dbms_output.put_line(v_message||'. Статус: '||c_status_create);
   dbms_output.put_line(to_char(v_current_dtime, 'yyyy/mm/dd hh24:mi:ss'));
end;
/

-- Сброс платежа
Declare
   v_message        varchar2(200 char) := 'Сброс платежа в "ошибочный статус" с указанием причины';
   c_status_error   constant number(1) := 2;
   v_reason         varchar2(200 char) := 'недостаточно средств';
   v_current_dtime  timestamp := systimestamp;
begin
   dbms_output.put_line(v_message||'. Статус: '||c_status_error||'. Причина: '||v_reason);
   dbms_output.put_line(to_char(v_current_dtime, 'dd-mm-yyyy hh24:mi:ss.ff3'));
end;
/

-- Отмена платежа
Declare
   v_message        varchar2(200 char):= 'Отмена платежа с указанием причины';
   c_status_cancel  constant number(1) := 3;
   v_reason         varchar2(200 char):= 'ошибка пользователя';
   v_current_dtime  timestamp := systimestamp;
begin
   dbms_output.put_line(v_message||'. Статус: '||c_status_cancel||'. Причина: '||v_reason);
   dbms_output.put_line(to_char(v_current_dtime, 'day month year  hh24:mi:ss.ff1'));
end;
/

-- Завершение платежа
Declare
   v_message        varchar2(200 char) := 'Успешное завершение платежа';
   c_status_success constant number(1) := 1;
   v_current_dtime  date := sysdate;
begin
   dbms_output.put_line(v_message||'. Статус: '||c_status_success);
   dbms_output.put_line(to_char(v_current_dtime, 'dd-mon-rr hh24:mi:ssss'));
end;
/

-- Добавление или обновление данных по платежу
Declare
   v_message        varchar2(200 char) := 'Данные платежа добавлены или обновлены по списку id_поля/значение';
   v_current_dtime  date := sysdate;
begin
   dbms_output.put_line(v_message);
   dbms_output.put_line(to_char(v_current_dtime, 'fxfmdd-month-yy hh12:mi:ss'));
end;
/

-- Удаление деталей платежа
Declare
   v_message        varchar2(200 char) := 'Детали платежа удалены по списку id_полей';
   v_current_dtime  timestamp := systimestamp;
begin
   dbms_output.put_line(v_message);
   dbms_output.put_line(to_char(v_current_dtime, 'fxdd/mon/yyyy hh24:mi:sssss.ff4'));
end;
/