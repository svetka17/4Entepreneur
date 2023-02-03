CREATE OR REPLACE package ASUPPP.contract_pkg is


  /*
    Вернуть имя файла с отчетом для заданного контракта
  */
  function get_contract_report(l_unik_c in cont_head.unik_c%type) return varchar2;
  function get_contract_number(l_unik_c in cont_head.unik_c%type) return varchar2;
  /*
    Вернуть имя файла с отчетом для заданной спецификации
  */
  function get_spec_report(l_unik_s in cont_spec.unik_s%type,
    l_variant in pls_integer := 1, l_test in pls_integer default 0) return varchar2;
  -- Если марки в предыдущей позиции те же самые, что и в L_UNIK_P,
  -- вернуть true, иначе false
  function report_helper_mark_same(l_unik_p cont_pos.unik_p%type) return pls_integer;
  function report_helper_mark_same_all(l_unik_s cont_spec.unik_s%type, l_zak_pp cont_pos.zak_pp%type default 0) return pls_integer;  
  
  -- Если госты и ТТ в предыдущей позиции те же самые, что и в L_UNIK_P,
  -- вернуть true, иначе false
  function report_helper_gost_same(l_unik_p cont_pos.unik_p%type) return pls_integer;
  -- Если госты и ТТ во всей спецификации одинаковые,
  -- вернуть true, иначе false
  function report_helper_gost_same_all(l_unik_s cont_spec.unik_s%type, l_zak_pp cont_pos.zak_pp%type default 0) return pls_integer;
  /*
   *  Возвратить строку характеристик продукции (ГОСТы, технические требования)
   */
  function report_helper_get_prod_char(l_unik_p cont_pos.unik_p%type) return varchar2;
  /*
   * Возвратить строку, которую следует печатать в колонке размера № L_INDEX
   */
  function report_helper_get_size_column(l_unik_p cont_pos.unik_p%type, l_index in number) return varchar2;


  /* преобразовать спецификацию CONT_SPEC в заказ Z001/Z002

       L_UNIK_S   -- CONT_SPEC.UNIK_S нужной спецификации
       L_NSNZ     -- Z001.NSNZ создаваемого заказа
       L_DPID     -- Z001.DPID создаваемого заказа
       L_GDIS     -- Z001.GDIS создаваемого заказа
       L_LOG      -- буфер-приемник различных сообщений (в том числе и об ошибках),
                     выдаваемых программой. Представляет собой массив значений
                     CONTRACT_PKG.CONV_*.
       L_FORCE    -- принудительно создать заказ в обход всех предупреждений (кроме
                     критических ошибок)
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
      
  /* преобразовать позицию спецификации CONT_POZ в позицию заказа Z002

       L_UNIK_P   -- CONT_POS.UNIK_P нужной позиции спецификации
       L_NSNZ     -- Z001.NSNZ заказа
       L_DPID     -- Z001.DPID заказа
       L_GDIS     -- Z001.GDIS заказа
  */
  function cont_pos_to_z002(
      l_unik_p cont_pos.unik_p%type,
      l_nsnz z001.nsnz%type,
      l_dpid z001.dpid%type,
      l_gdis z001.gdis%type
      ) return boolean;    
        
  /*
    Обновить версии спецификации согласно изменений в заказе (по всем DPID)
  */
  function z001_to_cont_spec(
      l_nsnz z001.nsnz%type,
      l_gdis z001.gdis%type,
      l_log out varchar2) return boolean;

   /*
     Копировать спецификацию
   */
   function copy_spec(
       l_unik_s cont_spec.unik_s%type,
       l_unik_c cont_head.unik_c%type,
       l_n_spc cont_spec.n_spc%type,
       l_copy_pos_full integer default 0,
       l_copy_razm integer default 0)
     return cont_spec.unik_s%type;

   --полное копирование спецификации
   function copy_spec_for_dop( l_unik_s cont_spec.unik_s%type,
       l_unik_c cont_head.unik_c%type,
       l_n_spc cont_spec.n_spc%type) return cont_spec.unik_s%type;
       
   /*
     Удалить позицию
   */
   function delete_position(l_unik_p cont_pos.unik_p%type) return boolean;

   /*
     Может ли текущий (залогиненый) пользователь редактировать
     объект, созданный пользователем l_target_user
   */
   function can_edit(l_target_user passw.unik%type) return boolean;
   
      /*
     Может ли пользователь (залогиненый) редактировать
     объект, созданный пользователями своего бюро (для ОВЭС)
   */   
   function can_edit_oves(l_target_user passw.unik%type) return boolean;   
   
/*
     Имеет ли пользователь (залогиненый) полный доступ на изменение 
     договоров и спецификаций
   */   
   function user_full_access(l_target_user passw.unik%type) return boolean;   
   
   /*
     Правильный ли суффикс?
   */
   function is_suffix_valid(l_suffix cont_head.suffix%type) return boolean;
   /*
     Преобразования "сборного" поля размера в отдельные поля и наоборот
   */
   function size_combine(l_min in number, l_max in number, l_delim in varchar2)
     return varchar2;
   function size_split(l_size in varchar2, l_min in out number, l_max in out number,
     l_delim in out varchar2) return boolean;
   /*
     Проверка валидности расчетного счета
   */
   function is_account_valid(l_account in varchar2, l_bank in nsi111.nsi11101%type) return boolean;
   /*
     Разрешить свободный вид счетов (с буквами) для заданного банка
   */
   procedure enable_freeform_account(l_bank in nsi111.nsi11101%type);

   /*
     Вернуть cont_type.id для соглашения "контракт"
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