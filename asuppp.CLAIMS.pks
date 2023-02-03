CREATE OR REPLACE package ASUPPP.claims as
  function get_temp_uo return number;

  function get_ap_date return date;
  procedure set_ap_date(d date);

  function get_ap_dogon return number;
  procedure set_ap_dogon(d number);
  procedure ap_init;

  function get_tmc (uc number) return number;
  function get_godmes_spis (uc number) return number;
  function get_godmes_pol (uc number) return number;
    function get_godmes_before_perenos (uc number) return number;
  function get_notd (uc number) return number;
  function get_isp (uc number) return number;
  function get_kod_krid (uc number) return number;
  function get_invn (uc number) return number;
  function get_budget (uc number) return number;
  function get_nam (uc number) return varchar2;
  function get_zex (uc number) return number;
  function get_sh_zatr (uc number) return number;
  function get_sh_zatr_kr(b number, kr number) return number;
  
  function get_kol (uc number) return number;
  function get_status (uc number) return number;
  function get_kol_vyd (uc number) return number;
  function get_kol_svobodno_vydano(uc number) return number;
  function get_kol_ztrb (uc number) return number;
  function get_ost_vyd (uc number) return number;
  function get_kol_ztrb_vyd (uc number) return varchar2;
  function get_kol_dog (uc number) return number;
 -- function get_raspred (uc number) return number;
   function get_kol_dog_ (uc number) return number;
  function get_god (uc number) return number;
  function get_mes (uc number) return number;
  function get_qvart (uc number) return number;
  function get_otvet (uc number) return number;
  function get_subshet (uc number) return number;
  function get_gost (uc number) return varchar2;
  function get_mol (uc number) return number;
  function status_text(s number) return varchar2;
  function view_all_zex return number;
  function is_res_otdel return number; --является ли пользователь ресурсником
  function is_otdrem return number; --является ли пользователь отделом ремонтов
  function priem_allowed return number; --является ли пользователь принимающим заявки (бюджетный контроль - ОБ, ОБНА, ИО, ОБК
  
/*  function action_avail(c_status number, c_zex number, act number, b95 number default 95) --, grp number default 0) 
    return  number; 
  function action(uo number, a number, date_ro date default null, p_porz_iskl number default null
  ,    prich varchar2 default null, nporz number default null,
  zam_tmc number default null, p_job number default null
  ) return varchar2;
  
   */
  function nepof(zex number) return number;
  function neprof_cl(zex number) return number;
  
  function check_limit(p_zex number, p_budg95 number, p_god number, p_mes number, p_kod_limit number) return number;
  procedure job_Restore_claims(p_zex number, p_budg95 number, p_god number, p_mes number,p_kod_limit number default null);
  procedure job_Restore_claims;
  procedure job_Prosroch;
  procedure Kill_Claims_for_Limit(p_zex number, p_b95 number, p_god number, p_mes number, p_kod_limit number);  
  procedure job_Kill_Claims_for_Limit;  
  
  function zex_comp(z number) return number;

  procedure Cancel_Perenos(up number);
  
  function zex_sklad(z number, s number) return number;
  
  procedure uslugi_prices(g number);

  function uslugi_grp  return number;
  function uslugi_pgr  return number;
  function uslugi_notd return number;
  function uslugi_isp  return number;
  
  function budg_io(b number) return number;
  
  procedure autoPerenos_2012_nkk;
  -- процедура автопереноса, запускается каждую ночь джобом, сама проверяет 
  -- - пора ли ей отрабатывать и что именно делать
  
  function perenos_chop(uo number) return number;
  -- отделяет неисполненную (незавезённую, даже если законтрактована) часть одной заявки
  -- возвращает номер отделённой (новой) заявки, которую нужно переносить
  
  procedure perenos(uc number, gm date, s_lim number default 1);
  -- делает перенос одной заявки в указанный год-месяц
  -- s_lim = 1 значит что с переносом лимита по существующим правилам
  -- s_lim = 0 лимиты не трогаем вообще
  
  procedure correct_pos_budget (uo number);
  
  function zk_now(
    cl_date date, -- дата получения по заявке 
    d date default sysdate -- дата происходящего
  ) return number;
  -- идёт ли сейчас (или в указанную дату) заявочная кампания; 0 - нет; 1 - да
  
 -- function auto_close_by_cpp(uo number, ch number default 0, p_tmc number default null, p_kol number default null) return number;
  
 -- procedure auto_close_by_cpp_zex(uo number, ch number default 0);
  function zex_sklad_cpp(z number, s number) return number;
  function sklad_cpp_on_zex(z number) return number;
  
  function mol_slugba(p_zex number, p_mol number) return number parallel_enable;
  
  function slug_sogl_snp(p_snp number) return number;
  
  procedure notify_mails;
  
  procedure fill_zex_sum_ost_cpp;
  
  function check_normativ_ost_grn(p_zex number, p_godp number, p_mesp number, 
      p_sum_spistm number
    -- сумма списания по заявке в том же месяце ( должна быть 0 для псо и 0 если списание в другом месяце)
    ) return number;
  function otd_neisp(uo number) return varchar2;
  procedure otd_nedop(uo number);
  function tip_text(t number) return varchar2;
  
  temp_uo number;
  
  ap_date date;
  ap_dogon number;
  
  act_vern_deistv constant number(7) := -300;
  act_sogl_uit constant number(7) := -80;
  act_ro_my_date constant number(7) := -70;
  act_sogl_or constant number(7) := -46;
  act_otpr constant number(7) := -45;
  act_otl_lim constant number(7) := -11;
  act_otkaz constant number(7) := -9;
  act_ro_ok constant number(7) := -7;
  act_ro constant number(7) := -6;
  act_sogl constant number(7) := -5;
  act_chern constant number(7) := -4;
  act_iskl_ok constant number(7) := -3;
  act_deistv constant number(7) := 0;
  act_iskl_zapr constant number(7) := 1;
  act_iskl_chern constant number(7) := 2;
  act_prosr constant number(7) := 10;
  act_iskl_chern_v constant number(7) := 20;
  act_iskl_chern_otm constant number(7) := 100;
  act_otdelit constant number(7) := 993;
  act_sklad constant number(7) := 994;
  act_zakup constant number(7) := 995;
  act_zam_snp_otm constant number(7) := 996;
  act_zam_snp constant number(7) := 997;
  act_to_porz constant number(7) := 998;
  act_del constant number(7) := 999;
  act_perenos_lim constant number(7) := 991;
  act_perenos_nolim constant number(7) := 992;
    
end claims;
/
