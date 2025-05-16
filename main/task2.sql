/*
Автор: Кайгородова В.А. 
Описание скрипта: API для сущностей “Платеж” и “Детали платежа”
*/
-- Создание платежа
Declare
   v_message        varchar2(200 char) := 'Платеж создан';
   c_status_create  constant payment.status%type := 0;
   v_current_dtime  timestamp := systimestamp;
   v_payment_id     payment.payment_id%type := 2;
   v_payment_detail t_payment_detail_array := t_payment_detail_array(t_payment_detail(1,'Приложение')
                                                                    ,t_payment_detail(2,'192.0.0.1')
                                                                    ,t_payment_detail(3,'тест')
                                                                    ,t_payment_detail(4,'Нет'));
   v_summa          payment.summa%type := 1000; 
   v_currency_id    currency.currency_id%type := 643;
   v_from_client_id client.client_id%type := 1;
   v_to_client_id   client.client_id%type := 2;
begin
   if v_payment_detail is not empty then 
     for i in v_payment_detail.first..v_payment_detail.last LOOP
     if v_payment_detail(i).field_id is null then
       dbms_output.put_line('ID поля не может быть пустым');
     end if;
     
     if v_payment_detail(i).field_value is null then
       dbms_output.put_line('Значение в поле не может быть пустым');
     end if;
     dbms_output.put_line('Field_id: '||v_payment_detail(i).field_id||'  field_value: '||v_payment_detail(i).field_value);
   end loop;
   else
     dbms_output.put_line('Коллекция не содержит данных');
   end if;

   dbms_output.put_line(v_message||'. Статус: '||c_status_create);
   dbms_output.put_line(to_char(v_current_dtime, 'yyyy/mm/dd hh24:mi:ss'));
   dbms_output.put_line('ИД Платежа: '||v_payment_id);
   
   --создание платежа
   insert into payment( payment_id,
            create_dtime,
            summa,
            currency_id,
            from_client_id,
            to_client_id,
            status,
            status_change_reason)
   values (payment_seq.nextval, v_current_dtime, v_summa, v_currency_id, v_from_client_id, v_to_client_id, c_status_create, null)
   returning payment_id into v_payment_id;
   
   dbms_output.put_line('Payment_id of new payment: '||v_payment_id);
   
   --Добавление данных по платежу
   insert into payment_detail(payment_id,
                              field_id,
                              field_value)
   select v_payment_id, value(t).field_id, value(t).field_value from table(v_payment_detail) t;
end;
/

-- Сброс платежа
Declare
   v_message       varchar2(200 char) := 'Сброс платежа в "ошибочный статус" с указанием причины';
   c_status_error  constant payment.status%type := 2;
   v_reason        payment.status_change_reason%type := 'недостаточно средств';
   v_current_dtime timestamp := systimestamp;
   v_payment_id    payment.payment_id%type := 2;
   v_message_error_id_null     varchar2(100 char) := 'ID объекта не может быть пустым';
   v_message_error_reason_null varchar2(100 char) := 'Причина не может быть пустой';
   c_status_create  constant payment.status%type := 0;
begin
   if v_payment_id is null then
     dbms_output.put_line(v_message_error_id_null);
   end if;
   if v_reason is null then
     dbms_output.put_line(v_message_error_reason_null);
   end if;
   dbms_output.put_line(v_message||'. Статус: '||c_status_error||'. Причина: '||v_reason);
   dbms_output.put_line(to_char(v_current_dtime, 'dd-mm-yyyy hh24:mi:ss.ff3'));
   dbms_output.put_line('ИД Платежа: '||v_payment_id);
   
   --Обновление статуса платежа
   update payment p 
      set p.status = c_status_error
       ,p.status_change_reason = v_reason
    where p.payment_id = v_payment_id
    and p.status = c_status_create;
end;
/

-- Отмена платежа
Declare
   v_message       varchar2(200 char):= 'Отмена платежа с указанием причины';
   c_status_cancel constant payment.status%type := 3;
   v_reason        payment.status_change_reason%type:= 'ошибка пользователя';
   v_current_dtime timestamp := systimestamp;
   v_payment_id    payment.payment_id%type := 2;
   v_message_error_id_null     varchar2(100 char) := 'ID объекта не может быть пустым';
   v_message_error_reason_null varchar2(100 char) := 'Причина не может быть пустой';
   c_status_create  constant payment.status%type := 0;
begin
   if v_payment_id is null then
     dbms_output.put_line(v_message_error_id_null);
   end if;
   if v_reason is null then
     dbms_output.put_line(v_message_error_reason_null);
   end if;
   dbms_output.put_line(v_message||'. Статус: '||c_status_cancel||'. Причина: '||v_reason);
   dbms_output.put_line(to_char(v_current_dtime, 'day month year  hh24:mi:ss.ff1'));
   dbms_output.put_line('ИД Платежа: '||v_payment_id);
   
   --Обновление статуса платежа
   update payment p 
      set p.status = c_status_cancel
       ,p.status_change_reason = v_reason
    where p.payment_id = v_payment_id
    and p.status = c_status_create;
end;
/

-- Завершение платежа
Declare
   v_message               varchar2(200 char) := 'Успешное завершение платежа';
   c_status_success        constant payment.status%type := 1;
   v_current_dtime         timestamp := systimestamp;
   v_payment_id            payment.payment_id%type := 2;
   v_message_error_id_null varchar2(100 char) := 'ID объекта не может быть пустым';
   c_status_create         constant payment.status%type := 0;
begin
   if v_payment_id is null then
     dbms_output.put_line(v_message_error_id_null);
   end if;
   dbms_output.put_line(v_message||'. Статус: '||c_status_success);
   dbms_output.put_line(to_char(v_current_dtime, 'dd-mon-rr hh24:mi:ssss'));
   dbms_output.put_line('ИД Платежа: '||v_payment_id);
   
   --Обновление статуса платежа
   update payment p 
      set p.status = c_status_success
       ,p.status_change_reason = null
    where p.payment_id = v_payment_id
    and p.status = c_status_create;
end;
/

-- Добавление или обновление данных по платежу
Declare
   v_message               varchar2(200 char) := 'Данные платежа добавлены или обновлены по списку id_поля/значение';
   v_current_dtime         timestamp := systimestamp;
   v_payment_id            payment.payment_id%type := 2;
   v_message_error_id_null varchar2(100 char) := 'ID объекта не может быть пустым';
   v_payment_detail        t_payment_detail_array := t_payment_detail_array(t_payment_detail(3,'тест2')
                                                                           ,t_payment_detail(4,'Да'));
begin
   if v_payment_id is null then
     dbms_output.put_line(v_message_error_id_null);
   end if;
   if v_payment_detail is not empty then 
     for i in v_payment_detail.first..v_payment_detail.last LOOP
     if v_payment_detail(i).field_id is null then
       dbms_output.put_line('ID поля не может быть пустым');
     end if;
     
     if v_payment_detail(i).field_value is null then
       dbms_output.put_line('Значение в поле не может быть пустым');
     end if;
     dbms_output.put_line('Field_id: '||v_payment_detail(i).field_id||'  field_value: '||v_payment_detail(i).field_value);
   end loop;
   else
     dbms_output.put_line('Коллекция не содержит данных');
   end if;

   dbms_output.put_line(v_message);
   dbms_output.put_line(to_char(v_current_dtime, 'fxfmdd-month-yy hh12:mi:ss'));
   dbms_output.put_line('ИД Платежа: '||v_payment_id);
   
   --Вставка обновление данных по платежу
   merge into payment_detail pt
   using (select v_payment_id payment_id
                ,value(t).field_id field_id
                ,value(t).field_value field_value
            from table(v_payment_detail)t ) n
      on (pt.payment_id = n.payment_id and pt.field_id = n.field_id)
  when matched then
    update set pt.field_value = n.field_value
  when not matched then 
    insert(payment_id, field_id, field_value)
    values(n.payment_id, n.field_id, n.field_value);
end;
/

-- Удаление деталей платежа
Declare
   v_message               varchar2(200 char) := 'Детали платежа удалены по списку id_полей';
   v_current_dtime         timestamp := systimestamp;
   v_payment_id            payment.payment_id%type := 2;
   v_message_error_id_null varchar2(100 char) := 'ID объекта не может быть пустым';
   v_delete_field_ids      t_number_array := t_number_array(2,3);
begin
   if v_payment_id is null then
     dbms_output.put_line(v_message_error_id_null);
   end if;
   if v_delete_field_ids is empty then 
     dbms_output.put_line('Коллекция не содержит данных');
   end if;
   dbms_output.put_line(v_message);
   dbms_output.put_line(to_char(v_current_dtime, 'fxdd/mon/yyyy hh24:mi:sssss.ff4'));
   dbms_output.put_line('ИД Платежа: '||v_payment_id);
   dbms_output.put_line('Количество удаляемых полей: '||v_delete_field_ids.count);
   
   delete payment_detail pd
    where pd.payment_id = v_payment_id
    and pd.field_id in (select value(t) from table(v_delete_field_ids) t);
end;
/
