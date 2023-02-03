CREATE OR REPLACE package ASUPPP.xx_make_d_4_dbf_pkg authid current_user as
  function make_d4_header return varchar2;
  function to_ascii(p_number in number) return varchar2;
  function make_d4_column_script return varchar2;
  function make_d4_all return blob;
  function create_dbf_for_300346(polzz varchar2, pr number) return blob;
  function create_dbf_for_335957(polzz varchar2, pr number) return blob;
  function create_dbf_for_334970(polzz varchar2, pr number) return blob;
  function create_dbf_for_334970_new(polzz varchar2, pr number) return blob;
  function create_dbf_for_334970_new_(polzz varchar2, pr number) return blob;
  function create_dbf_for_334970_change(polzz varchar2, pr number) return blob;
  function create_dbf_for_394200(polzz varchar2, pr number) return blob;
  function create_dbf_for_335593(polzz varchar2, pr number) return blob;
  function create_dbf_for_335742(polzz varchar2, pr number) return blob;
  function create_for_380731(polzz varchar2, pr number) return number;
  function create_for_335678(polzz varchar2, pr number) return blob;
  function create_for_334442(polzz varchar2, pr number) return blob;
  function create_for_334442_new(polzz varchar2, pr number) return blob;
 -- function create_for_334442_new_(polzz varchar2, pr number) return blob;
  function create_for_335742_online(polzz varchar2, pr number) return blob;
--  function mmm(polzz varchar2) return integer;
  procedure xxx(polz varchar2, mfo number, rs number default 0);
end xx_make_d_4_dbf_pkg;
/

