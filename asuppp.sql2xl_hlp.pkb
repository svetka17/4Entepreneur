--
-- SQL2XL_HLP  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY ASUPPP.sql2xl_hlp AS
  PROCEDURE init(id IN NUMBER)
   as
  begin
    l_cfg := sql2xl_config_t(id);
  end;
  
  function l_column_name_count return number as
  begin
    return l_cfg.l_column_name.count;
  end;
  
  function l_column_name(i number) return varchar2 as
  begin
    return l_cfg.l_column_name(i);
  end;

  function l_column_format(i number) return varchar2 as
  begin
    return l_cfg.l_column_format(i);
  end;
  
  function l_column_type(i number) return varchar2 as
  begin
    return l_cfg.l_column_type(i);
  end;

  function l_column_width(i number) return number as
  begin
    return l_cfg.l_column_width(i);
  end;
  
  function l_column_nonbasic(i number) return number as
  begin
    return l_cfg.l_column_nonbasic(i);
  end;
  
  function l_column_excel_formula(i number) return varchar2 as
  begin  
    return l_cfg.l_column_excel_formula(i);
  end;

  function l_query return varchar2 as
  begin
    return l_cfg.l_query;
  end;
  
  function l_rawxml_styles return varchar2 as begin return l_cfg.l_rawxml_styles; end;
function l_do_numbering return number as begin return l_cfg.l_do_numbering; end;
function l_rawxml_before_hdr return varchar2 as begin return l_cfg.l_rawxml_before_hdr; end;
function l_rawxml_before_hdr_rows return varchar2 as begin return l_cfg.l_rawxml_before_hdr_rows; end;
function l_header return varchar2 as begin return l_cfg.l_header; end;
function l_param_name_count return number as begin return l_cfg.l_param_name.count; end;
function l_rawxml_after_hdr return varchar2 as begin return l_cfg.l_rawxml_after_hdr; end;
function l_rawxml_after_hdr_rows return varchar2 as begin return l_cfg.l_rawxml_after_hdr_rows; end;
function l_param_print_title(i number) return varchar2 as begin return l_cfg.l_param_print_title(i); end;
function l_column_title(i number) return varchar2 as begin return l_cfg.l_column_title(i); end;
function get_param_print_value(i integer, p_raw_value varchar2) return varchar2 as begin return l_cfg.get_param_print_value(i, p_raw_value); end;
function l_param_name(I number) return varchar2 as begin return l_cfg.l_param_name(i); end;
function l_column_has_summary(I number) return number as begin return l_cfg.l_column_has_summary(i); end;
function l_do_params return number as begin return l_cfg.l_do_params; end;
function l_do_column_titles return number as begin return l_cfg.l_do_column_titles; end;
function l_do_autofilter return number as begin return l_cfg.l_do_autofilter; end;

 
END sql2xl_hlp;
/
