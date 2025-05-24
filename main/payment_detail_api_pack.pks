create or replace package payment_detail_api_pack  is 
/*
�����: ����������� �.�. 
�������� ������: API ��� �������� ������� ��������
*/
  c_err_msg_empty_object_id   constant varchar2(100 char) := 'ID ������� �� ����� ���� ������';
  
  c_info_msg_delete_payment_detail       constant varchar2(100 char) := '������ ������� ������� �� ������ id_�����';
  c_info_msg_update_payment_detail       constant varchar2(200 char) := '������ ������� ��������� ��� ��������� �� ������ id';

  /*
  *  ���������� ��� ���������� ������ �� �������
  *  @param p_payment_detail     ������ �������
  *  @param p_payment_id         ������������ �������
  */
  procedure insert_or_update_payment_detail(p_payment_detail t_payment_detail_array,
                                            p_payment_id     payment.payment_id%type);

  /*
  *  �������� ������� �������
  *  @param p_delete_field_ids   �������������� ������� �������
  *  @param p_payment_id         ������������ �������
  */
  procedure delete_payment_detail(p_delete_field_ids t_number_array,
                                  p_payment_id       payment.payment_id%type);
end payment_detail_api_pack;
/
