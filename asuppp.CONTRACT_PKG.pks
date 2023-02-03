CREATE OR REPLACE package ASUPPP.contract_pkg is


  /*
    ������� ��� ����� � ������� ��� ��������� ���������
  */
  function get_contract_report(l_unik_c in cont_head.unik_c%type) return varchar2;
  function get_contract_number(l_unik_c in cont_head.unik_c%type) return varchar2;
  /*
    ������� ��� ����� � ������� ��� �������� ������������
  */
  function get_spec_report(l_unik_s in cont_spec.unik_s%type,
    l_variant in pls_integer := 1, l_test in pls_integer default 0) return varchar2;
  -- ���� ����� � ���������� ������� �� �� �����, ��� � � L_UNIK_P,
  -- ������� true, ����� false
  function report_helper_mark_same(l_unik_p cont_pos.unik_p%type) return pls_integer;
  function report_helper_mark_same_all(l_unik_s cont_spec.unik_s%type, l_zak_pp cont_pos.zak_pp%type default 0) return pls_integer;  
  
  -- ���� ����� � �� � ���������� ������� �� �� �����, ��� � � L_UNIK_P,
  -- ������� true, ����� false
  function report_helper_gost_same(l_unik_p cont_pos.unik_p%type) return pls_integer;
  -- ���� ����� � �� �� ���� ������������ ����������,
  -- ������� true, ����� false
  function report_helper_gost_same_all(l_unik_s cont_spec.unik_s%type, l_zak_pp cont_pos.zak_pp%type default 0) return pls_integer;
  /*
   *  ���������� ������ ������������� ��������� (�����, ����������� ����������)
   */
  function report_helper_get_prod_char(l_unik_p cont_pos.unik_p%type) return varchar2;
  /*
   * ���������� ������, ������� ������� �������� � ������� ������� � L_INDEX
   */
  function report_helper_get_size_column(l_unik_p cont_pos.unik_p%type, l_index in number) return varchar2;


  /* ������������� ������������ CONT_SPEC � ����� Z001/Z002

       L_UNIK_S   -- CONT_SPEC.UNIK_S ������ ������������
       L_NSNZ     -- Z001.NSNZ ������������ ������
       L_DPID     -- Z001.DPID ������������ ������
       L_GDIS     -- Z001.GDIS ������������ ������
       L_LOG      -- �����-�������� ��������� ��������� (� ��� ����� � �� �������),
                     ���������� ����������. ������������ ����� ������ ��������
                     CONTRACT_PKG.CONV_*.
       L_FORCE    -- ������������� ������� ����� � ����� ���� �������������� (�����
                     ����������� ������)
  */
  function cont_spec_to_z001(
      l_unik_s cont_spec.unik_s%type,
      l_nsnz z001.nsnz%type,
      l_dpid z001.dpid%type,
      l_gdis z001.gdis%type,
      l_lot z002.lot%type,
      l_log out varchar2,
      l_force boolean,
      opp number default 0,
      l_mnth number default 1,
      l_cabotage number default 0) return boolean;
      
  /* ������������� ������� ������������ CONT_POZ � ������� ������ Z002

       L_UNIK_P   -- CONT_POS.UNIK_P ������ ������� ������������
       L_NSNZ     -- Z001.NSNZ ������
       L_DPID     -- Z001.DPID ������
       L_GDIS     -- Z001.GDIS ������
  */
  function cont_pos_to_z002(
      l_unik_p cont_pos.unik_p%type,
      l_nsnz z001.nsnz%type,
      l_dpid z001.dpid%type,
      l_gdis z001.gdis%type
      ) return boolean;    
        
  /*
    �������� ������ ������������ �������� ��������� � ������ (�� ���� DPID)
  */
  function z001_to_cont_spec(
      l_nsnz z001.nsnz%type,
      l_gdis z001.gdis%type,
      l_log out varchar2) return boolean;

   /*
     ���������� ������������
   */
   function copy_spec(
       l_unik_s cont_spec.unik_s%type,
       l_unik_c cont_head.unik_c%type,
       l_n_spc cont_spec.n_spc%type,
       l_copy_pos_full integer default 0,
       l_copy_razm integer default 0)
     return cont_spec.unik_s%type;

   --������ ����������� ������������
   function copy_spec_for_dop( l_unik_s cont_spec.unik_s%type,
       l_unik_c cont_head.unik_c%type,
       l_n_spc cont_spec.n_spc%type) return cont_spec.unik_s%type;
       
   /*
     ������� �������
   */
   function delete_position(l_unik_p cont_pos.unik_p%type) return boolean;

   /*
     ����� �� ������� (�����������) ������������ �������������
     ������, ��������� ������������� l_target_user
   */
   function can_edit(l_target_user passw.unik%type) return boolean;
   
      /*
     ����� �� ������������ (�����������) �������������
     ������, ��������� �������������� ������ ���� (��� ����)
   */   
   function can_edit_oves(l_target_user passw.unik%type) return boolean;   
   
/*
     ����� �� ������������ (�����������) ������ ������ �� ��������� 
     ��������� � ������������
   */   
   function user_full_access(l_target_user passw.unik%type) return boolean;   
   
   /*
     ���������� �� �������?
   */
   function is_suffix_valid(l_suffix cont_head.suffix%type) return boolean;
   /*
     �������������� "��������" ���� ������� � ��������� ���� � ��������
   */
   function size_combine(l_min in number, l_max in number, l_delim in varchar2)
     return varchar2;
   function size_split(l_size in varchar2, l_min in out number, l_max in out number,
     l_delim in out varchar2) return boolean;
   /*
     �������� ���������� ���������� �����
   */
   function is_account_valid(l_account in varchar2, l_bank in nsi111.nsi11101%type) return boolean;
   /*
     ��������� ��������� ��� ������ (� �������) ��� ��������� �����
   */
   procedure enable_freeform_account(l_bank in nsi111.nsi11101%type);

   /*
     ������� cont_type.id ��� ���������� "��������"
   */
   function get_type_for_contract return number;
   function get_type_for_dop_sogl return number;
   function get_type_for_pril return number;   
   function add_zero(l_inp in varchar2) return varchar2;
   function add_zero(l_inp in number) return varchar2;
 
   function vid_spc(p_unik_s in integer) return pls_integer;
   
   function spec_annul(p_unik_s in cont_spec.unik_s%type) return number;
   
   function spec_del(p_unik_s in cont_spec.unik_s%type) return varchar2;
   
   function sel_exec_imm(p_str in varchar2) return varchar2;
   
   function cont_to_dop_sogl(p_unik_c in cont_head.unik_c%type,p_type_dpid in cont_head.type_dpid%type) return number;
   
   function dop_sogl_to_cont(p_unik_c in cont_head.unik_c%type) return number;   
             
end contract_pkg;
/