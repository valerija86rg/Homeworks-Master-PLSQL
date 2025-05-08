/*
Автор: Кайгородова В.А. 
Описание скрипта: API для сущностей “Платеж” и “Детали платежа”
*/
-- Создание платежа
Declare
   v_message        varchar2(200 char) := 'Платеж создан';
   c_status_create  constant payment.status%type := 0;
   v_current_dtime  date := sysdate;
   v_payment_id     payment.payment_id%type := 1;
   v_payment_detail t_payment_detail_array := t_payment_detail_array(t_payment_detail(1,'Приложение')
                                                                    ,t_payment_detail(2,'192.0.0.1')
                                                                    ,t_payment_detail(3,'тест')
                                                                    ,t_payment_detail(4,'Нет'));
begin
   dbms_output.put_line(v_message||'. Статус: '||c_status_create);
   dbms_output.put_line(to_char(v_current_dtime, 'yyyy/mm/dd hh24:mi:ss'));
   dbms_output.put_line('ИД Платежа: '||v_payment_id);
end;
/

-- Сброс платежа
Declare
   v_message       varchar2(200 char) := 'Сброс платежа в "ошибочный статус" с указанием причины';
   c_status_error  constant payment.status%type := 2;
   v_reason        payment.status_change_reason%type := 'недостаточно средств';
   v_current_dtime timestamp := systimestamp;
   v_payment_id    payment.payment_id%type := 1;
   v_message_error_id_null     varchar2(100 char) := 'ID объекта не может быть пустым';
   v_message_error_reason_null varchar2(100 char) := 'Причина не может быть пустой';
begin
   dbms_output.put_line(v_message||'. Статус: '||c_status_error||'. Причина: '||v_reason);
   dbms_output.put_line(to_char(v_current_dtime, 'dd-mm-yyyy hh24:mi:ss.ff3'));
   dbms_output.put_line('ИД Платежа: '||v_payment_id);
   if v_payment_id is null then
     dbms_output.put_line(v_message_error_id_null);
   end if;
   if v_reason is null then
     dbms_output.put_line(v_message_error_reason_null);
   end if;
end;
/

-- Отмена платежа
Declare
   v_message       varchar2(200 char):= 'Отмена платежа с указанием причины';
   c_status_cancel constant payment.status%type := 3;
   v_reason        payment.status_change_reason%type:= 'ошибка пользователя';
   v_current_dtime timestamp := systimestamp;
   v_payment_id    payment.payment_id%type := 1;
   v_message_error_id_null     varchar2(100 char) := 'ID объекта не может быть пустым';
   v_message_error_reason_null varchar2(100 char) := 'Причина не может быть пустой';
begin
   dbms_output.put_line(v_message||'. Статус: '||c_status_cancel||'. Причина: '||v_reason);
   dbms_output.put_line(to_char(v_current_dtime, 'day month year  hh24:mi:ss.ff1'));
   dbms_output.put_line('ИД Платежа: '||v_payment_id);
   if v_payment_id is null then
     dbms_output.put_line(v_message_error_id_null);
   end if;
   if v_reason is null then
     dbms_output.put_line(v_message_error_reason_null);
   end if;
end;
/

-- Завершение платежа
Declare
   v_message               varchar2(200 char) := 'Успешное завершение платежа';
   c_status_success        constant payment.status%type := 1;
   v_current_dtime         date := sysdate;
   v_payment_id            payment.payment_id%type := 1;
   v_message_error_id_null varchar2(100 char) := 'ID объекта не может быть пустым';
begin
   dbms_output.put_line(v_message||'. Статус: '||c_status_success);
   dbms_output.put_line(to_char(v_current_dtime, 'dd-mon-rr hh24:mi:ssss'));
   dbms_output.put_line('ИД Платежа: '||v_payment_id);
   if v_payment_id is null then
     dbms_output.put_line(v_message_error_id_null);
   end if;
end;
/

-- Добавление или обновление данных по платежу
Declare
   v_message               varchar2(200 char) := 'Данные платежа добавлены или обновлены по списку id_поля/значение';
   v_current_dtime         date := sysdate;
   v_payment_id            payment.payment_id%type := 1;
   v_message_error_id_null varchar2(100 char) := 'ID объекта не может быть пустым';
   v_payment_detail        t_payment_detail_array := t_payment_detail_array(t_payment_detail(3,'тест2')
                                                                           ,t_payment_detail(4,'Да'));
begin
   dbms_output.put_line(v_message);
   dbms_output.put_line(to_char(v_current_dtime, 'fxfmdd-month-yy hh12:mi:ss'));
   dbms_output.put_line('ИД Платежа: '||v_payment_id);
   if v_payment_id is null then
     dbms_output.put_line(v_message_error_id_null);
   end if;
end;
/

-- Удаление деталей платежа
Declare
   v_message               varchar2(200 char) := 'Детали платежа удалены по списку id_полей';
   v_current_dtime         timestamp := systimestamp;
   v_payment_id            payment.payment_id%type := 1;
   v_message_error_id_null varchar2(100 char) := 'ID объекта не может быть пустым';
   v_delete_field_ids      t_number_array := t_number_array(2,3);
begin
   dbms_output.put_line(v_message);
   dbms_output.put_line(to_char(v_current_dtime, 'fxdd/mon/yyyy hh24:mi:sssss.ff4'));
   dbms_output.put_line('ИД Платежа: '||v_payment_id);
   if v_payment_id is null then
     dbms_output.put_line(v_message_error_id_null);
   end if;
end;
/
