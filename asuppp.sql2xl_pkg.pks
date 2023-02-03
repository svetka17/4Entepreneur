--
-- SQL2XL_PKG  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   SQL2XL_CONFIG (Synonym)
--   SQL2XL_PARAM (Synonym)
--
CREATE OR REPLACE PACKAGE ASUPPP.sql2xl_pkg is
  type param_t is record (
    f_name sql2xl_param.f_name%type,
    title sql2xl_param.title%type,
    f_value varchar2(500)
  );
  type paramlist_t is table of param_t index by pls_integer;

  function get_paramlist(config_id in sql2xl_config.id%type)
    return paramlist_t;

  function process_config(l_id in sql2xl_config.id%type,
    l_params in paramlist_t)
    return clob;
end sql2xl_pkg;
/
