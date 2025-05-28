
create or replace package body payment_detail_api_pack is 
/*
Автор: Кайгородова В.А. 
Описание пакета: API для сущности “Детали платежа”
*/

  /*
  *  Добавление или обновление данных по платежу
  *  @param p_payment_detail     детали платежа
  *  @param p_payment_id         идетификатор платежа
  */
  procedure insert_or_update_payment_detail(p_payment_detail t_payment_detail_array,
                                            p_payment_id     payment.payment_id%type)
  is                                                      
  begin
     if p_payment_id is null then
       dbms_output.put_line(c_err_msg_empty_object_id);
     end if;
     if p_payment_detail is not empty then 
       for i in p_payment_detail.first..p_payment_detail.last LOOP
       if p_payment_detail(i).field_id is null then
         dbms_output.put_line('ID поля не может быть пустым');
       end if;
       
       if p_payment_detail(i).field_value is null then
         dbms_output.put_line('Значение в поле не может быть пустым');
       end if;
       dbms_output.put_line('Field_id: '||p_payment_detail(i).field_id||'  field_value: '||p_payment_detail(i).field_value);
     end loop;
     else
       dbms_output.put_line('Коллекция не содержит данных');
     end if;

     dbms_output.put_line(c_info_msg_update_payment_detail);
     dbms_output.put_line('ИД Платежа: '||p_payment_id);
     
     --Вставка обновление данных по платежу
     merge into payment_detail pt
     using (select p_payment_id payment_id
                  ,value(t).field_id field_id
                  ,value(t).field_value field_value
              from table(p_payment_detail)t ) n
        on (pt.payment_id = n.payment_id and pt.field_id = n.field_id)
    when matched then
      update set pt.field_value = n.field_value
    when not matched then 
      insert(payment_id, field_id, field_value)
      values(n.payment_id, n.field_id, n.field_value);
  end insert_or_update_payment_detail;

  /*
  *  Удаление деталей платежа
  *  @param p_delete_field_ids   идентификаторы деталей платежа
  *  @param p_payment_id         идетификатор платежа
  */
  procedure delete_payment_detail(p_delete_field_ids t_number_array,
                                  p_payment_id       payment.payment_id%type)
  is
  begin
     if p_payment_id is null then
       dbms_output.put_line(c_err_msg_empty_object_id);
     end if;
     if p_delete_field_ids is empty then 
       dbms_output.put_line('Коллекция не содержит данных');
     end if;
     dbms_output.put_line(c_info_msg_delete_payment_detail);
     dbms_output.put_line('ИД Платежа: '||p_payment_id);
     dbms_output.put_line('Количество удаляемых полей: '||p_delete_field_ids.count);
     
     delete payment_detail pd
      where pd.payment_id = p_payment_id
        and pd.field_id in (select value(t) from table(p_delete_field_ids) t);
  end delete_payment_detail;
end payment_detail_api_pack;
/
