--Проверка "Создание платежа"
declare 
  v_payment_detail t_payment_detail_array := t_payment_detail_array(t_payment_detail(1,'Приложение')
                                                                   ,t_payment_detail(2,'192.0.0.3')
                                                                   ,t_payment_detail(3,'тест1')
                                                                   ,t_payment_detail(4,'Да'));
  v_summa           payment.summa%type := 2000; 
  v_currency_id     currency.currency_id%type := 643;
  v_from_client_id  client.client_id%type := 1;
  v_to_client_id    client.client_id%type := 2;
  v_create_dtime    timestamp := systimestamp;
  v_payment_id      payment.payment_id%type;
begin 
  v_payment_id := create_payment(p_summa => v_summa, 
                                 p_currency_id => v_currency_id,
                                 p_from_client_id => v_from_client_id, 
                                 p_to_client_id => v_to_client_id, 
                                 p_create_dtime => v_create_dtime,
                                 p_payment_detail => v_payment_detail);
  dbms_output.put_line('ID Платежа: '||v_payment_id);
  commit;
end;
/

select * from payment p where p.payment_id = 21;
select * from payment_detail pd where pd.payment_id = 21;


--Проверка "Сброс платежа"  
declare 
  v_reason        payment.status_change_reason%type := 'Тест: недостаточно средств';
  v_payment_id    payment.payment_id%type := 21;
begin
  fail_payment(p_payment_id => v_payment_id,
               p_reason => v_reason);
end;
/
select * from payment p where p.payment_id = 21;

--Проверка "Отмена платежа" 
declare 
  v_reason        payment.status_change_reason%type:= 'Тест: ошибка пользователя';
  v_payment_id    payment.payment_id%type := 21;
begin  
  cancel_payment (p_payment_id => v_payment_id,
                  p_reason => v_reason);
end;
/
select * from payment p where p.payment_id = 21;

--Проверка "Завершение платежа" 
declare 
  v_payment_id     payment.payment_id%type := 21;
begin
  successful_finish_payment(p_payment_id => v_payment_id);
end;
/
select * from payment p where p.payment_id = 21;

--Проверка "Добавление или обновление данных по платежу" 
declare 
  v_payment_id      payment.payment_id%type := 21;
  v_payment_detail  t_payment_detail_array := t_payment_detail_array(t_payment_detail(3,'тест2')
                                                                    ,t_payment_detail(4,'Да'));
begin
  insert_or_update_payment_detail(p_payment_detail => v_payment_detail,
                                  p_payment_id => v_payment_id);
end;
/
 select pd.*, dpf.name
  from payment_detail pd, 
       payment_detail_field dpf
 where pd.payment_id = 21
   and pd.field_id = dpf.field_id
 order by pd.field_id;
 
--Проверка "Удаление деталей платежа"
declare
  v_payment_id            payment.payment_id%type := 21;
  v_delete_field_ids      t_number_array := t_number_array(2,3);
begin
  delete_payment_detail(p_delete_field_ids => v_delete_field_ids,
                        p_payment_id => v_payment_id);
end;
/
                                                  
 select pd.*, dpf.name
   from payment_detail pd, 
        payment_detail_field dpf
  where pd.payment_id = 21
    and pd.field_id = dpf.field_id
  order by pd.field_id;