/*
Автор: Кайгородова В.А. 
*/

Declare
   type t_my_rec is record(
      field1  number
     ,field2  varchar2(10 char) := 'Hello'
     ,field3  char(1) not null := 'y'
     );
   
   v_my_rec1 t_my_rec;
   v_my_rec2 t_my_rec;
   v_my_rec3 t_my_rec;
   
   v_payment_detail_field  payment_detail_field%rowtype;
begin
   v_my_rec1.field1 := 10;
   v_my_rec2.field1 := 20;
   v_my_rec3.field1 := 30;
   dbms_output.put_line('v_my_rec1.field1 = '||v_my_rec1.field1);
   dbms_output.put_line('v_my_rec2.field1 = '||v_my_rec2.field1);
   dbms_output.put_line('v_my_rec3.field1 = '||v_my_rec3.field1);
   
   v_my_rec1 := null;
   if v_my_rec1.field1 is null 
      and v_my_rec1.field2 is null 
      and v_my_rec1.field3 is null then
     dbms_output.put_line('It’s null');
   else 
     dbms_output.put_line('It’s not null');
   end if;
   
   select *
     into v_payment_detail_field
     from payment_detail_field pdf
    where pdf.field_id = 1;
   
   dbms_output.put_line('v_payment_detail_field: '||'(name: '||v_payment_detail_field.name
   ||'  description:  '||v_payment_detail_field.description||')');
end;
/

