create or replace package body payment_api_pack is
/*
Автор: Кайгородова В.А. 
Описание пакета: API для сущности “Платеж”
*/


  g_is_api boolean := false; --Признак выполняется ли изменения через API
  
  --разрешение менять данные
  procedure allow_changes
  is
  begin
    g_is_api := true;
  end;

  --запрет менять данные
  procedure disallow_changes
  is
  begin
    g_is_api := false;
  end;

  /*
  *  создания платежа
  *  @param p_summa             - сумма платежа
  *  @param p_currency_id       - идентификатор валюты
  *  @param p_from_client_id    - идентификатор клиента с которого переводим
  *  @param p_to_client_id      - идентификатор клиента кому переводим
  *  @param p_create_dtime      - дата создания платежа
  *  @param p_payment_detail    - детали платежа
  *  @return - идетификатор платежа
  */
  function create_payment(p_summa           payment.summa%type, 
                          p_currency_id     currency.currency_id%type,
                          p_from_client_id  client.client_id%type, 
                          p_to_client_id    client.client_id%type, 
                          p_create_dtime    timestamp := systimestamp,
                          p_payment_detail  t_payment_detail_array) return payment.payment_id%type
  is 
     v_payment_id     payment.payment_id%type;
  begin
     
     allow_changes();
     --создание платежа
     insert into payment( payment_id,
                          create_dtime,
                          summa,
                          currency_id,
                          from_client_id,
                          to_client_id,
                          status,
                          status_change_reason)
     values (payment_seq.nextval, p_create_dtime, p_summa, p_currency_id, p_from_client_id, p_to_client_id, common_pack.c_status_create, null)
     returning payment_id into v_payment_id;
     
     --Добавление данных по платежу
     payment_detail_api_pack.insert_or_update_payment_detail(p_payment_detail => p_payment_detail,
                                                             p_payment_id     => v_payment_id);
     disallow_changes();
     return v_payment_id;
  exception
    when others then
      disallow_changes();
      raise;
  end create_payment;

  /*
  *  Сброс платежа
  *  @param p_payment_id   - идетификатор платежа
  *  @param p_reason       - причина сброса
  */
  procedure fail_payment(p_payment_id    payment.payment_id%type,
                         p_reason        payment.status_change_reason%type)
  is
  begin
     if p_payment_id is null then
       raise_application_error(common_pack.c_error_code_invalid_input_parametr,common_pack.c_err_msg_empty_object_id);
     end if;
     if p_reason is null then
       raise_application_error(common_pack.c_error_code_invalid_input_parametr,common_pack.c_err_msg_empty_reason);
     end if;
    
     try_lock_payment(p_payment_id => p_payment_id);
     allow_changes();
     
     --Обновление статуса платежа
     update payment p 
        set p.status = common_pack.c_status_error
           ,p.status_change_reason = p_reason
      where p.payment_id = p_payment_id
        and p.status = common_pack.c_status_create;
        
    disallow_changes();
  exception
    when others then
      disallow_changes();
      raise;
  end fail_payment;

  /*
  *  Отмена платежа
  *  @param p_payment_id   - идетификатор платежа
  *  @param p_reason       - причина отмены
  */
  procedure cancel_payment (p_payment_id    payment.payment_id%type,
                            p_reason        payment.status_change_reason%type)
  is
  begin
     if p_payment_id is null then
       raise_application_error(common_pack.c_error_code_invalid_input_parametr,common_pack.c_err_msg_empty_object_id);
     end if;
     if p_reason is null then
       raise_application_error(common_pack.c_error_code_invalid_input_parametr,common_pack.c_err_msg_empty_reason);
     end if;
     
     try_lock_payment(p_payment_id => p_payment_id);
     allow_changes();
     
     --Обновление статуса платежа
     update payment p 
        set p.status = common_pack.c_status_cancel
           ,p.status_change_reason = p_reason
      where p.payment_id = p_payment_id
        and p.status = common_pack.c_status_create;
     disallow_changes();
     
    exception
      when others then
        disallow_changes();
        raise;
  end cancel_payment;

  /*
  *  Завершение платежа
  *  @param p_payment_id   - идетификатор платежа
  */
  procedure successful_finish_payment(p_payment_id      payment.payment_id%type)
  is
  begin
     if p_payment_id is null then
       raise_application_error(common_pack.c_error_code_invalid_input_parametr,common_pack.c_err_msg_empty_object_id);
     end if;
     
     try_lock_payment(p_payment_id => p_payment_id);
     allow_changes();
     
     --Обновление статуса платежа
     update payment p 
        set p.status = common_pack.c_status_success
           ,p.status_change_reason = null
      where p.payment_id = p_payment_id
        and p.status = common_pack.c_status_create;
     
     disallow_changes();     
        
     exception
      when others then
        disallow_changes();
        raise;
  end successful_finish_payment;
  
 /*
  *  Проверка вызываемая из триггера
  */
  procedure is_change_through_api
  is
  begin
    if not g_is_api and not common_pack.is_manual_changes_allowed() then 
      raise_application_error(common_pack.c_error_code_manual_changes, common_pack.c_err_msg_manual_changes);
    end if;    
  end is_change_through_api;
  
  /*
  *  Проверка на возможность удалять данные
  */
  procedure check_payment_delete_restriction
  is
  begin
    if not common_pack.is_manual_changes_allowed() then 
       raise_application_error(common_pack.c_error_code_delete_forbidden, 
                               common_pack.c_err_msg_delete_forbidden);
    end if;
  end check_payment_delete_restriction;
  
  /*
  *  Блокировка клиента для изменения
  *  @param p_payment_id   - идетификатор платежа
  */
  procedure try_lock_payment(p_payment_id  payment.payment_id%type)
  is 
    v_status payment.status%type;
  begin
    select p.status
      into v_status 
      from payment p 
     where p.payment_id = p_payment_id
    for update nowait;
    
    if v_status <> c_status_create then 
      raise_application_error(common_pack.c_error_code_object_final_status, 
                              common_pack.c_err_msg_object_final_status);
    end if;
    
    exception
      when no_data_found then 
        raise_application_error(common_pack.c_error_code_object_not_found, common_pack.c_err_msg_object_not_found);
      when common_pack.e_row_locker then 
        raise_application_error(common_pack.c_error_code_object_already_locked, common_pack.c_err_msg_object_already_locked);
  end try_lock_payment;
end payment_api_pack;
/