create or replace package common_pack  is 
/*
Автор: Кайгородова В.А. 
Описание пакета: для общих объектов
*/

    --статусы платежа
  c_status_create         constant payment.status%type := 0;
  c_status_success        constant payment.status%type := 1;
  c_status_error          constant payment.status%type := 2;
  c_status_cancel         constant payment.status%type := 3;
  
  --сообщения ошибок 
  c_err_msg_empty_field_id               constant varchar2(100 char) := 'ID поля не может быть пустым';
  c_err_msg_empty_field_value            constant varchar2(100 char) := 'Значение в поле не может быть пустым';
  c_err_msg_empty_collection             constant varchar2(100 char) := 'Коллекция не содержит данных';
  c_err_msg_empty_object_id              constant varchar2(100 char) := 'ID объекта не может быть пустым';
  c_err_msg_empty_reason                 constant varchar2(100 char) := 'Причина не может быть пустой';
  c_err_msg_delete_forbidden             constant varchar2(100 char) := 'Удаление объекта запрещено';
  c_err_msg_manual_changes               constant varchar2(100 char) := 'Изменения должны вноситься только через API';
  c_err_msg_object_final_status          constant varchar2(200 char) := 'Объект в конечном статусе. Изменения невозможны';
  c_err_msg_object_not_found             constant varchar2(200 char) := 'Объект не найден';
  c_err_msg_object_already_locked        constant varchar2(200 char) := 'Объект уже заблокирован';
  
  c_info_msg_delete_payment_detail       constant varchar2(100 char) := 'Детали платежа удалены по списку id_полей';
  c_info_msg_update_payment_detail       constant varchar2(200 char) := 'Данные платежа добавлены или обновлены по списку id';
  c_info_msg_create_payment              constant varchar2(100 char) := 'Платеж создан';
  c_info_msg_fail_payment                constant varchar2(200 char) := 'Сброс платежа в "ошибочный статус" с указанием причины';
  c_info_msg_cancel_payment              constant varchar2(100 char) := 'Отмена платежа с указанием причины';
  c_info_msg_successful_finish_payment   constant varchar2(100 char) := 'Успешное завершение платежа';
  
  --коды ошибок
  c_error_code_invalid_input_parametr    constant number(10) := -20101;
  c_error_code_delete_forbidden          constant number(10) := -20102;
  c_error_code_manual_changes            constant number(10) := -20103;
  c_error_code_object_final_status       constant number(10) := -20104;
  c_error_code_object_not_found          constant number(10) := -20105;
  c_error_code_object_already_locked     constant number(10) := -20106;
  
  --объекты исключений
  e_invalid_input_parametr exception;
  pragma exception_init(e_invalid_input_parametr, -20101);
  e_invalid_delete_forbidden exception;
  pragma exception_init(e_invalid_delete_forbidden, -20102);
  e_invalid_manual_changes exception;
  pragma exception_init(e_invalid_manual_changes, -20103);
  e_invalid_object_final_status exception;
  pragma exception_init(e_invalid_object_final_status, -20104);
  e_invalid_object_not_found exception;
  pragma exception_init(e_invalid_object_not_found, -20105);
  e_invalid_object_already_locked exception;
  pragma exception_init(e_invalid_object_already_locked, -20106);
  e_row_locker exception;
  pragma exception_init(e_row_locker, -00054);
  
  --включение отклчючение разрешения менять вручную данные объектов
  procedure enable_manual_changes;
  procedure disable_manual_changes;
  
  --разрешены ли ручные изменения
  function is_manual_changes_allowed return boolean;
  

end common_pack;
/