create or replace trigger payment_b_iud_api
  before insert or update or delete on payment
begin
  payment_api_pack.is_change_through_api(); -- ��������� ����������� �� ��������� ����� API
end;
/
