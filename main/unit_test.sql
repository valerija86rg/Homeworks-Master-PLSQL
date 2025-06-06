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
  v_payment_id := payment_api_pack.create_payment(p_summa => v_summa, 
                                                  p_currency_id => v_currency_id,
                                                  p_from_client_id => v_from_client_id, 
                                                  p_to_client_id => v_to_client_id, 
                                                  p_create_dtime => v_create_dtime,
                                                  p_payment_detail => v_payment_detail);
  dbms_output.put_line('ID Платежа: '||v_payment_id);
  --commit;
end;
/

select * from payment p where p.payment_id = 21;
select * from payment_detail pd where pd.payment_id = 21;


--Проверка "Сброс платежа"  
declare 
  v_reason        payment.status_change_reason%type := 'Тест: недостаточно средств';
  v_payment_id    payment.payment_id%type := 21;
begin
  payment_api_pack.fail_payment(p_payment_id => v_payment_id,
                                p_reason => v_reason);
end;
/
select * from payment p where p.payment_id = 21;

--Проверка "Отмена платежа" 
declare 
  v_reason        payment.status_change_reason%type:= 'Тест: ошибка пользователя';
  v_payment_id    payment.payment_id%type := 21;
begin  
  payment_api_pack.cancel_payment(p_payment_id => v_payment_id,
                                  p_reason => v_reason);
end;
/
select * from payment p where p.payment_id = 21;

--Проверка "Завершение платежа" 
declare 
  v_payment_id     payment.payment_id%type := 21;
begin
  payment_api_pack.successful_finish_payment(p_payment_id => v_payment_id);
end;
/
select * from payment p where p.payment_id = 21;

--Проверка "Добавление или обновление данных по платежу" 
declare 
  v_payment_id      payment.payment_id%type := 21;
  v_payment_detail  t_payment_detail_array := t_payment_detail_array(t_payment_detail(3,'тест2')
                                                                    ,t_payment_detail(4,'Да'));
begin
  payment_detail_api_pack.insert_or_update_payment_detail(p_payment_detail => v_payment_detail,
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
  payment_detail_api_pack.delete_payment_detail(p_delete_field_ids => v_delete_field_ids,
                                                p_payment_id => v_payment_id);
end;
/
                                                  
 select pd.*, dpf.name
   from payment_detail pd, 
        payment_detail_field dpf
  where pd.payment_id = 21
    and pd.field_id = dpf.field_id
  order by pd.field_id;
  
--негативные Unit тесты
--Проверка "Создание платежа"
declare 
  v_payment_detail t_payment_detail_array;
  v_summa           payment.summa%type; 
  v_currency_id     currency.currency_id%type;
  v_from_client_id  client.client_id%type;
  v_to_client_id    client.client_id%type;
  v_create_dtime    timestamp := systimestamp;
  v_payment_id      payment.payment_id%type;
begin 
  v_payment_id := payment_api_pack.create_payment(p_summa => v_summa, 
                                                  p_currency_id => v_currency_id,
                                                  p_from_client_id => v_from_client_id, 
                                                  p_to_client_id => v_to_client_id, 
                                                  p_create_dtime => v_create_dtime,
                                                  p_payment_detail => v_payment_detail);
  raise_application_error(-20999, 'Unit-тест или API выполнены неверно');
  exception
    when payment_api_pack.e_invalid_input_parametr then 
      dbms_output.put_line('Создание платежа. Исключение возбуждено успешно. Ошибка: '||sqlerrm);
end;
/

--Проверка "Сброс платежа"  
declare 
  v_reason        payment.status_change_reason%type;
  v_payment_id    payment.payment_id%type;
begin
  payment_api_pack.fail_payment(p_payment_id => v_payment_id,
                                p_reason => v_reason);
  raise_application_error(-20999, 'Unit-тест или API выполнены неверно');
  exception
    when payment_api_pack.e_invalid_input_parametr then 
      dbms_output.put_line('Сброс платежа. Исключение возбуждено успешно. Ошибка: '||sqlerrm);
end;
/

--Проверка "Отмена платежа" 
declare 
  v_reason        payment.status_change_reason%type;
  v_payment_id    payment.payment_id%type;
begin  
  payment_api_pack.cancel_payment(p_payment_id => v_payment_id,
                                  p_reason => v_reason);
  raise_application_error(-20999, 'Unit-тест или API выполнены неверно');
  exception
    when payment_api_pack.e_invalid_input_parametr then 
      dbms_output.put_line('Отмена платежа. Исключение возбуждено успешно. Ошибка: '||sqlerrm);
end;
/

--Проверка "Завершение платежа" 
declare 
  v_payment_id     payment.payment_id%type;
begin
  payment_api_pack.successful_finish_payment(p_payment_id => v_payment_id);
  raise_application_error(-20999, 'Unit-тест или API выполнены неверно');
  exception
    when payment_api_pack.e_invalid_input_parametr then 
      dbms_output.put_line('Завершение платежа. Исключение возбуждено успешно. Ошибка: '||sqlerrm);
end;
/

--Проверка "Добавление или обновление данных по платежу" 
declare 
  v_payment_id      payment.payment_id%type;
  v_payment_detail  t_payment_detail_array;
begin
  payment_detail_api_pack.insert_or_update_payment_detail(p_payment_detail => v_payment_detail,
                                                          p_payment_id => v_payment_id);
  raise_application_error(-20999, 'Unit-тест или API выполнены неверно');
  exception
    when payment_detail_api_pack.e_invalid_input_parametr then 
      dbms_output.put_line('Добавление или обновление данных по платежу. Исключение возбуждено успешно. Ошибка: '||sqlerrm);
end;
/
--Проверка "Удаление деталей платежа"
declare
  v_payment_id            payment.payment_id%type;
  v_delete_field_ids      t_number_array;
begin
  payment_detail_api_pack.delete_payment_detail(p_delete_field_ids => v_delete_field_ids,
                                                p_payment_id => v_payment_id);
  raise_application_error(-20999, 'Unit-тест или API выполнены неверно');
  exception
    when payment_detail_api_pack.e_invalid_input_parametr then 
      dbms_output.put_line('Удаление деталей платежа. Исключение возбуждено успешно. Ошибка: '||sqlerrm);
end;
/