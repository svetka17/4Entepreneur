--
-- SQL2XL_HLP  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   SQL2XL_CONFIG_T (Type)
--
CREATE OR REPLACE PACKAGE ASUPPP.sql2xl_hlp AS
  l_cfg sql2xl_config_t;

  PROCEDURE init(id IN NUMBER);
  
  function l_column_name_count return number;  
  function l_column_name(i number) return varchar2;
  function l_column_format(i number) return varchar2;
  function l_column_type(i number) return varchar2;
  function l_column_width(i number) return number;
  function l_column_nonbasic(i number) return number;
  function l_column_excel_formula(i number) return varchar2;
  function l_query return varchar2;
  function l_rawxml_styles return varchar2;
function l_do_numbering return number;
function l_rawxml_before_hdr return varchar2;
function l_rawxml_before_hdr_rows return varchar2;
function l_header return varchar2;
function l_param_name_count return number;
function l_rawxml_after_hdr return varchar2;
function l_rawxml_after_hdr_rows return varchar2;
function l_param_print_title(i number) return varchar2;
function l_column_title(i number) return varchar2;
function get_param_print_value(i integer, p_raw_value varchar2) return varchar2;
function l_param_name(I number) return varchar2;
function l_column_has_summary(I number) return number;
function l_do_params return number;
function l_do_column_titles return number;
function l_do_autofilter return number;
  
  
  
END sql2xl_hlp;
/
