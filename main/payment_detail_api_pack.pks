create or replace package payment_detail_api_pack  is 
/*
Автор: Кайгородова В.А. 
Описание пакета: API для сущности “Детали платежа”
*/
  c_err_msg_empty_object_id   constant varchar2(100 char) := 'ID объекта не может быть пустым';
  
  c_info_msg_delete_payment_detail       constant varchar2(100 char) := 'Детали платежа удалены по списку id_полей';
  c_info_msg_update_payment_detail       constant varchar2(200 char) := 'Данные платежа добавлены или обновлены по списку id';

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
end payment_detail_api_pack;
/
