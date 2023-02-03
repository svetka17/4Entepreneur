--
-- SQL2XL_PKG  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY ASUPPP.sql2xl_pkg is

  procedure Log_Exception(l_module in varchar2, l_addmsg in varchar2 := null) IS
    l_errmsg debug.message_text%type;
  begin

    if l_addmsg is not null then
      l_errmsg := '[' || l_addmsg || '] ';
    end if;
    l_errmsg := dbms_utility.format_error_stack
      || 'Error backtrace: ' || chr(10)
      || dbms_utility.format_error_backtrace;
    std.debug_message(l_module, l_errmsg);
  end;

  function get_paramlist(config_id in sql2xl_config.id%type)
    return paramlist_t is
    type stringlist_t is table of pls_integer index by sql2xl_param.f_name%type;

    l_retval paramlist_t;
    /* здесь хранятся уже описанные параметры, чтобы при распарсивании

    /* запроса их не добавлять повторно */
    l_defined_params stringlist_t;
    l_select_stmt sql2xl_config.select_stmt%type;
    l_param sql2xl_param.f_name%type;
    i pls_integer;
    k pls_integer;

    cursor param_cur(l_config_id number) is
      select * from sql2xl_param where config_id = l_config_id order by pos;
  begin
    -- выберем все параметры из таблицы параметров
    for param_rec in param_cur(config_id)
    loop
      l_retval(param_rec.pos).f_name := param_rec.f_name;
      l_retval(param_rec.pos).title := param_rec.title;
      case param_rec.default_type
        when 1 then
          execute immediate 'select ' || param_rec.default_value || ' from dual'
            into l_retval(param_rec.pos).f_value;
        when 2 then
          execute immediate param_rec.default_value into l_retval(param_rec.pos).f_value;
        else
          l_retval(param_rec.pos).f_value := param_rec.default_value;
      end case;
      l_defined_params(param_rec.f_name) := 1;
    end loop;
    -- теперь распарсим оператор выборки и добавим все неописанные параметры
    begin
      select select_stmt into l_select_stmt from sql2xl_config where id = config_id;
      i := 1;
      loop
        l_param := regexp_substr_ex@f(l_select_stmt, ':([A-Za-z][A-Za-z0-9_]*)', 1, 1, i);
        exit when l_param is null;
        if not l_defined_params.exists(l_param) then
          k := Nvl(l_retval.last, 0) + 1;
          l_retval(k).f_name := l_param;
          l_retval(k).title := l_param;
          l_defined_params(l_param) := 1;
        end if;
        i := i + 1;
      end loop;
      exception when No_Data_Found then null;
    end;

    return l_retval;
  end;

  function process_config(l_id in sql2xl_config.id%type,
    l_params in paramlist_t)
    return clob is
    l_module std.string_t := 'sql2xl.process_config';
    l_retval clob;
    l_datarows clob;
    l_config_r sql2xl_config%rowtype;
    i pls_integer;
    -- переменные для динамического запроса
    l_query_cur number;
    l_desc_tab dbms_sql.desc_tab;
    l_col_cnt pls_integer;
    l_res pls_integer;
    l_val clob;
    -- переменные для шаблона
    l_row_begin_clause constant std.string_t := '<!-- sql-datarow-begin -->';
    l_row_end_clause constant std.string_t := '<!-- sql-datarow-end -->';
    l_row_begin_pos pls_integer;
    l_row_end_pos pls_integer;
    l_datarow_format clob;
    l_datarow clob;

    l_datarow_tags std.taglist_t;
    l_datarow_values std.assocv_t;

    l_common_values std.assocv_t;
  begin
    std.debug_message(l_module, 'Запуск, id = ' || l_id);
    begin
      select * into l_config_r from sql2xl_config where id = l_id;
      exception
        when No_Data_Found then
          return null;
    end;
    -- найдем в шаблоне метки, отделяющие блок записей
    if l_config_r.html_tmpl is null then
      std.debug_message(l_module, 'Шаблон пуст');
      return null;
    end if;
    l_row_begin_pos := dbms_lob.InStr(l_config_r.html_tmpl, l_row_begin_clause);
    l_row_end_pos := dbms_lob.InStr(l_config_r.html_tmpl, l_row_end_clause);
    if l_row_begin_pos = 0 or l_row_end_pos = 0 then
      std.debug_message(l_module, 'Не обнаружена одна из меток sql-datarow');
      return null;
    end if;
    dbms_lob.createtemporary(l_retval, TRUE, dbms_lob.session);
    dbms_lob.createtemporary(l_datarow_format, TRUE, dbms_lob.session);
    dbms_lob.createtemporary(l_datarow, TRUE, dbms_lob.session);
    dbms_lob.createtemporary(l_datarows, TRUE, dbms_lob.session);
    -- выделим текст блока записей
    dbms_lob.copy(l_datarow_format, l_config_r.html_tmpl,
      l_row_end_pos - l_row_begin_pos - Length(l_row_begin_clause), 1,
      l_row_begin_pos + Length(l_row_begin_clause));
    if not std.extract_tags(l_datarow_format, l_datarow_tags) then
      std.debug_message(l_module, 'Ошибка при извлечении тегов');
      return null;
    end if;
    -- подготовим запрос
    l_query_cur := dbms_sql.open_cursor;
    dbms_sql.parse(l_query_cur, l_config_r.select_stmt, dbms_sql.NATIVE);
    -- привяжем параметры отчета к запросу
    for i in l_params.first .. l_params.last
    loop
      l_common_values(l_params(i).f_name) := l_params(i).f_value;
      begin
        dbms_sql.bind_variable(l_query_cur, l_params(i).f_name, l_params(i).f_value);
      exception when others then null;
      end;
    end loop;
    -- получим информацию о колонках
    dbms_sql.describe_columns(l_query_cur, l_col_cnt, l_desc_tab);
    for i in 1 .. l_col_cnt
    loop
      dbms_sql.define_column(l_query_cur, i, l_val);
    end loop;
    l_res := dbms_sql.execute(l_query_cur);
    -- выбираем строчки
        
    loop
      exit when dbms_sql.fetch_rows(l_query_cur) <= 0;
      l_datarow_values.delete;
      for i in l_desc_tab.first .. l_desc_tab.last
      loop
        dbms_sql.column_value(l_query_cur, i - l_desc_tab.first + 1, l_val);

        if l_desc_tab(i).col_type = 12 then
          if to_date(l_val) < to_date(19200101,'yyyymmdd') then
            l_val := to_char(to_date(19200101,'yyyymmdd'));
          end if;
          if to_date(l_val) > to_date(35000101,'yyyymmdd') then
            l_val := to_char(to_date(35000101,'yyyymmdd'));
          end if;
        end if;

        l_datarow_values(lower(l_desc_tab(i).col_name)) := std.xml_escape(l_val);
      end loop;
      std.process_tags(l_datarow_format, l_datarow_tags, l_datarow_values, l_datarow);
      dbms_lob.writeappend(l_datarows, Length(l_datarow), l_datarow);
    end loop;
    l_common_values('rowcount') := dbms_sql.last_row_count;
    dbms_sql.close_cursor(l_query_cur);
    -- пишем заголовок
    dbms_lob.trim(l_datarow_format, 0);
    dbms_lob.copy(l_datarow_format, l_config_r.html_tmpl, l_row_begin_pos - 1);
    if not std.extract_tags(l_datarow_format, l_datarow_tags) then
      return null;
    end if;
    std.process_tags(l_datarow_format, l_datarow_tags, l_common_values, l_retval);
    -- пишем строки данных
    dbms_lob.append(l_retval, l_datarows);
    -- пишем трейлер
    dbms_lob.trim(l_datarow_format, 0);
    dbms_lob.copy(l_datarow_format, l_config_r.html_tmpl,
      dbms_lob.getlength(l_config_r.html_tmpl) - l_row_end_pos - Length(l_row_end_clause) + 1,
      1, l_row_end_pos + Length(l_row_end_clause));
    if not std.extract_tags(l_datarow_format, l_datarow_tags) then
      return null;
    end if;
    std.process_tags(l_datarow_format, l_datarow_tags, l_common_values, l_datarow);
    dbms_lob.append(l_retval, l_datarow);
    return l_retval;
  exception when others then
    Log_Exception(l_module);
    raise;
  end;

end sql2xl_pkg;
/
