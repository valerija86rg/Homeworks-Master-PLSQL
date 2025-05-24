create or replace package payment_api_pack is
/*
Автор: Кайгородова В.А. 
Описание пакета: API для сущности “Платеж”
*/

  --статусы платежа
  c_status_create         constant payment.status%type := 0;
  c_status_success        constant payment.status%type := 1;
  c_status_error          constant payment.status%type := 2;
  c_status_cancel         constant payment.status%type := 3;
  
  --сообщения ошибок 
  c_err_msg_empty_field_id    constant varchar2(100 char) := 'ID поля не может быть пустым';
  c_err_msg_empty_field_value constant varchar2(100 char) := 'Значение в поле не может быть пустым';
  c_err_msg_empty_collection  constant varchar2(100 char) := 'Коллекция не содержит данных';
  c_err_msg_empty_object_id   constant varchar2(100 char) := 'ID объекта не может быть пустым';
  c_err_msg_empty_reason      constant varchar2(100 char) := 'Причина не может быть пустой';
  
  c_info_msg_create_payment              constant varchar2(100 char) := 'Платеж создан';
  c_info_msg_fail_payment                constant varchar2(200 char) := 'Сброс платежа в "ошибочный статус" с указанием причины';
  c_info_msg_cancel_payment              constant varchar2(100 char) := 'Отмена платежа с указанием причины';
  c_info_msg_successful_finish_payment   constant varchar2(100 char) := 'Успешное завершение платежа';
  
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
end payment_api_pack;
/
