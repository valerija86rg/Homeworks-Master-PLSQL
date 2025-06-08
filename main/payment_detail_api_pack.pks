create or replace package payment_detail_api_pack  is 
/*
Автор: Кайгородова В.А. 
Описание пакета: API для сущности “Детали платежа”
*/
  c_err_msg_empty_object_id   constant varchar2(100 char) := 'ID объекта не может быть пустым';
  c_err_msg_empty_field_id    constant varchar2(100 char) := 'ID поля не может быть пустым';
  c_err_msg_empty_field_value constant varchar2(100 char) := 'Значение в поле не может быть пустым';
  c_err_msg_empty_collection  constant varchar2(100 char) := 'Коллекция не содержит данных';
  
  c_info_msg_delete_payment_detail       constant varchar2(100 char) := 'Детали платежа удалены по списку id_полей';
  c_info_msg_update_payment_detail       constant varchar2(200 char) := 'Данные платежа добавлены или обновлены по списку id';
  c_err_msg_manual_changes    constant varchar2(100 char) := 'Изменения должны вноситься только через API';

   --коды ошибок
  c_error_code_invalid_input_parametr    constant number(10) := -20101;
  c_error_code_manual_changes            constant number(10) := -20103;
  
  --объекты исключений
  e_invalid_input_parametr exception;
  pragma exception_init(e_invalid_input_parametr, -20101);
  e_invalid_manual_changes exception;
  pragma exception_init(e_invalid_manual_changes, -20103);
  

  /*
  *  Добавление или обновление данных по платежу
  *  @param p_payment_detail     детали платежа
  *  @param p_payment_id         идетификатор платежа
  */
  procedure insert_or_update_payment_detail(p_payment_detail t_payment_detail_array,
                                            p_payment_id     payment.payment_id%type);

  /*
  *  Удаление деталей платежа
  *  @param p_delete_field_ids   идентификаторы деталей платежа
  *  @param p_payment_id         идетификатор платежа
  */
  procedure delete_payment_detail(p_delete_field_ids t_number_array,
                                  p_payment_id       payment.payment_id%type);
                                  
  /*
  *  Проверка вызываемая из триггера
  */
  procedure is_change_through_api;
  
end payment_detail_api_pack;
