create or replace package payment_api_pack is
/*
�����: ����������� �.�. 
�������� ������: API ��� �������� �������
*/

  --������� �������
  c_status_create         constant payment.status%type := 0;
  c_status_success        constant payment.status%type := 1;
  c_status_error          constant payment.status%type := 2;
  c_status_cancel         constant payment.status%type := 3;
  
  --��������� ������ 
  c_err_msg_empty_field_id    constant varchar2(100 char) := 'ID ���� �� ����� ���� ������';
  c_err_msg_empty_field_value constant varchar2(100 char) := '�������� � ���� �� ����� ���� ������';
  c_err_msg_empty_collection  constant varchar2(100 char) := '��������� �� �������� ������';
  c_err_msg_empty_object_id   constant varchar2(100 char) := 'ID ������� �� ����� ���� ������';
  c_err_msg_empty_reason      constant varchar2(100 char) := '������� �� ����� ���� ������';
  
  c_info_msg_create_payment              constant varchar2(100 char) := '������ ������';
  c_info_msg_fail_payment                constant varchar2(200 char) := '����� ������� � "��������� ������" � ��������� �������';
  c_info_msg_cancel_payment              constant varchar2(100 char) := '������ ������� � ��������� �������';
  c_info_msg_successful_finish_payment   constant varchar2(100 char) := '�������� ���������� �������';
  
  /*
  *  �������� �������
  *  @param p_summa             - ����� �������
  *  @param p_currency_id       - ������������� ������
  *  @param p_from_client_id    - ������������� ������� � �������� ���������
  *  @param p_to_client_id      - ������������� ������� ���� ���������
  *  @param p_create_dtime      - ���� �������� �������
  *  @param p_payment_detail    - ������ �������
  *  @return - ������������ �������
  */
  function create_payment(p_summa           payment.summa%type, 
                          p_currency_id     currency.currency_id%type,
                          p_from_client_id  client.client_id%type, 
                          p_to_client_id    client.client_id%type, 
                          p_create_dtime    timestamp := systimestamp,
                          p_payment_detail  t_payment_detail_array) return payment.payment_id%type;

  /*
  *  ����� �������
  *  @param p_payment_id   - ������������ �������
  *  @param p_reason       - ������� ������
  */
  procedure fail_payment(p_payment_id    payment.payment_id%type,
                         p_reason        payment.status_change_reason%type);
  /*
  *  ������ �������
  *  @param p_payment_id   - ������������ �������
  *  @param p_reason       - ������� ������
  */
  procedure cancel_payment (p_payment_id    payment.payment_id%type,
                            p_reason        payment.status_change_reason%type);

  /*
  *  ���������� �������
  *  @param p_payment_id   - ������������ �������
  */
  procedure successful_finish_payment(p_payment_id      payment.payment_id%type);
end payment_api_pack;
/
