create or replace package payment_api_pack is
/*
Автор: Кайгородова В.А. 
Описание пакета: API для сущности “Платеж”
*/

   
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
                          p_payment_detail  t_payment_detail_array) return payment.payment_id%type;

  /*
  *  Сброс платежа
  *  @param p_payment_id   - идетификатор платежа
  *  @param p_reason       - причина сброса
  */
  procedure fail_payment(p_payment_id    payment.payment_id%type,
                         p_reason        payment.status_change_reason%type);
  /*
  *  Отмена платежа
  *  @param p_payment_id   - идетификатор платежа
  *  @param p_reason       - причина отмены
  */
  procedure cancel_payment (p_payment_id    payment.payment_id%type,
                            p_reason        payment.status_change_reason%type);

  /*
  *  Завершение платежа
  *  @param p_payment_id   - идетификатор платежа
  */
  procedure successful_finish_payment(p_payment_id      payment.payment_id%type);
  
  /*
  *  Проверка вызываемая из триггера
  */
  procedure is_change_through_api;
  
  /*
  *  Проверка на возможность удалять данные
  */
  procedure check_payment_delete_restriction
  
end payment_api_pack;
