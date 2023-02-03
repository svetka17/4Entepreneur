CREATE OR REPLACE package body ASUPPP.STD is
  
  procedure stringarray_append(l_array in out stringarray_t, 
                               l_string in string_t, 
                               l_prepend in boolean) is
  begin
    if l_prepend then
        l_array(Nvl(l_array.first,1)-1) := l_string;
    else
      l_array(Nvl(l_array.last,-1)+1) := l_string;
    end if;
  end;

  function stringarray_join(l_array in stringarray_t,
                            l_separator in string_t) 
    return longstring_t is
    i number;
    l_result longstring_t;
  begin
      i := l_array.First;
      while i is not null
      loop
          if l_array(i) is not null then
              if l_result is not null then 
              l_result := l_result || l_separator; 
            end if;
              l_result := l_result || l_array(i);
          end if;
          i := l_array.Next(i);
      end loop;
      return l_result;
  end;

  function string_split(l_string in longstring_t, 
                        l_separator in string_t) 
    return stringarray_t is
      l_res stringarray_t;
      l_start pls_integer := 1;
      l_end pls_integer;
    l_seplen constant pls_integer := length(l_separator);
  begin
      loop
      l_end := InStr(l_string, l_separator, l_start);
        exit when l_end = 0 or l_end is null;
        stringarray_append(l_res, SubStr(l_string, l_start, l_end - l_start));
        l_start := l_end + l_seplen;
      end loop;
    if l_start <= Length(l_string) then
      stringarray_append(l_res, SubStr(l_string, l_start));
    end if;
      return l_res;
  end;
  
  function days_in_month (l_month in pls_integer) 
    return pls_integer is
  begin
    return to_char(last_day(to_date(to_char(l_month), 'mm')), 'dd');
  end;
      
  procedure debug_message(l_application in varchar2, l_message in varchar2, add_to_debug in boolean default true)
  is
    pragma autonomous_transaction;
  begin
    if add_to_debug then
       begin
        insert into debug (
            message_date, 
            message_app, 
            message_text,
            session_id,
            user_unik)
          values (
            systimestamp, 
            l_application, 
            l_message,
            userenv('sessionid'),
            oasu.get_prop('user_unik'));
        commit;
      exception
       when others then null;
      end;
    else
        null;
    end if;        
  end;
  
  procedure print_lastsession_debug(l_application string_t, l_treshold pls_integer)
  is
    l_last date;
  begin
    begin
      select max(message_date) into l_last from debug where message_app = l_application;
    exception when others then return;
    end;
    dbms_output.enable(2000000);
    for dmsg in (select * from debug where 
      message_date between (l_last - l_treshold / (24 * 60 * 60)) and l_last 
      order by message_date)
    loop
      dbms_output.put_line('=> ' || dmsg.message_text);
    end loop;
    null;
  end;
  
  function Is_Date(l_value in varchar2) return boolean is
    tmp date;
  begin
    tmp := To_Date(l_value, default_date_format);
    return true;
  exception when others then return false;
  end;
  
  function default_date_format return varchar2 is
  begin
    return 'dd.mm.yyyy';
    --return 'dd.mm.yyyy hh24:mi:ss';
  end;

  function xml_escape(l_string in varchar2) return varchar2 is
  begin
    return Replace(Replace(Replace(Replace(Replace(Rtrim(
            l_string), '&', '&amp;'),
                       '>', '&gt;'),
                       '<', '&lt;'),
                       '"', '&quot;'),
                       '''', '&apos;');
  end;
  
  function of_month(l_month pls_integer, l_language varchar2) return varchar2
  is
    type months_t is varray(12) of varchar2(50);
    l_ru_months months_t := months_t(
      'января',
      'февраля',
      'марта',
      'апреля',
      'мая',
      'июня',
      'июля',
      'августа',
      'сентября',
      'октября',
      'ноября',
      'декабря'
    );
    l_uk_months months_t := months_t(
      'січня',
      'лютого',
      'березня',
      'квітня',
      'травня',
      'червня',
      'липня',
      'серпня',
      'вересня',
      'жовтня',
      'листопада',
      'грудня'
    );
  begin
    if l_month between 1 and 12 and lower(l_language) in ('russian', 'ukrainian') then
      return
        case lower(l_language)
          when 'russian' then l_ru_months(l_month)
          when 'ukrainian' then l_uk_months(l_month)
        end;
    else
      return null;
    end if;
  end;
  
  function of_month(l_date date, l_language varchar2) return varchar2
  is
  begin
    return of_month(extract(month from l_date), l_language);
  end;
  
  function date_intersect(p_start1 in date, p_end1 in date,
    p_start2 in date, p_end2 in date) return integer
  is
  begin
    if p_start2 between p_start1 and p_end1
        or p_end2 between p_start1 and p_end1 
        or p_start1 > p_start2 and p_end2 > p_end1 then
      return 1;
    else
      return 0;
    end if;
  end;
  
  function dsinterval_readable(p_interval in interval day to second)
    return varchar2
  is
    l_result varchar2(200);
    
    procedure add(l_value in pls_integer, l_one in varchar2, 
      l_two_to_four in varchar2, l_five_more in varchar2)
    is
      l_part varchar2(20);
      l_v pls_integer := mod(l_value, 10);
    begin
      if nvl(l_value, 0) <> 0 then
        if l_v = 1 then
          l_part := l_value || ' ' || l_one;
        elsif l_v between 2 and 4 then
          l_part := l_value || ' ' || l_two_to_four;
        elsif l_v > 4 or l_v = 0 then
          l_part := l_value || ' ' || l_five_more;
        end if;
      end if;
      if l_part is not null then
        if l_result is null then
          l_result := l_part;
        else
          l_result := l_result || ' ' || l_part;
        end if;
      end if;
    end;
    
  begin
    add(extract(day from p_interval), 'день', 'дня', 'дней');
    add(extract(hour from p_interval), 'час', 'часа', 'часов');
    add(extract(minute from p_interval), 'минута', 'минуты', 'минут');
    add(extract(second from p_interval), 'секунда', 'секунды', 'секунд');
    return l_result;
  end;
  
  
  function arguments_join(l_separator in string_t, 
    l_i1 in string_t, 
    l_i2 in string_t := null,
    l_i3 in string_t := null,
    l_i4 in string_t := null,
    l_i5 in string_t := null,
    l_i6 in string_t := null,
    l_i7 in string_t := null,
    l_i8 in string_t := null,
    l_i9 in string_t := null,
    l_i10 in string_t := null,
    l_i11 in string_t := null,
    l_i12 in string_t := null,
    l_i13 in string_t := null,
    l_i14 in string_t := null,
    l_i15 in string_t := null,
    l_i16 in string_t := null,
    l_i17 in string_t := null,
    l_i18 in string_t := null,
    l_i19 in string_t := null,
    l_i20 in string_t := null) return longstring_t is
    l_sa stringarray_t;
  begin
    stringarray_append(l_sa, l_i1);
    stringarray_append(l_sa, l_i2);
    stringarray_append(l_sa, l_i3);
    stringarray_append(l_sa, l_i4);
    stringarray_append(l_sa, l_i5);
    stringarray_append(l_sa, l_i6);
    stringarray_append(l_sa, l_i7);
    stringarray_append(l_sa, l_i8);
    stringarray_append(l_sa, l_i9);
    stringarray_append(l_sa, l_i10);
    stringarray_append(l_sa, l_i11);
    stringarray_append(l_sa, l_i12);
    stringarray_append(l_sa, l_i13);
    stringarray_append(l_sa, l_i14);
    stringarray_append(l_sa, l_i15);
    stringarray_append(l_sa, l_i16);
    stringarray_append(l_sa, l_i17);
    stringarray_append(l_sa, l_i18);
    stringarray_append(l_sa, l_i19);
    stringarray_append(l_sa, l_i20);
    return stringarray_join(l_sa, l_separator);
  end;

  function extract_tags(l_template in clob, l_taglist in out taglist_t) return boolean is
    l_pos pls_integer := 1;
    l_pos2 pls_integer := 1;
    l_tag tag_t;
  begin
    l_taglist.delete;
    loop
      l_pos := dbms_lob.InStr(l_template, '%', l_pos);
      exit when Nvl(l_pos, 0) = 0;
      l_tag.l_start := l_pos;
      l_pos2 := dbms_lob.InStr(l_template, '%', l_pos + 1);
      if l_pos2 <> 0 then
        l_tag.l_end := l_pos2;
        l_pos := dbms_lob.InStr(l_template, '+', l_pos);
        if Nvl(l_pos, 0) <> 0 and l_pos < l_pos2 then
          -- тег содержит формат
          l_tag.l_name := dbms_lob.SubStr(l_template, l_pos - l_tag.l_start - 1, 
            l_tag.l_start + 1);
          l_tag.l_format := dbms_lob.SubStr(l_template, l_pos2 - l_pos - 1, 
            l_pos + 1);
        else
          l_tag.l_name := dbms_lob.SubStr(l_template, l_tag.l_end - l_tag.l_start - 1, 
            l_tag.l_start + 1);
          l_tag.l_format := null;
        end if;
        l_taglist(l_taglist.count+1) := l_tag;
      elsif l_pos2 = 0 then
        return false;
      end if;
      l_pos := l_pos2 + 1;
    end loop;
    return true;
  end;

  procedure process_tags(l_template in clob, l_taglist in taglist_t, l_values in std.assocv_t, 
    l_result in out clob) is
    l_pos pls_integer := 1;
    i pls_integer;
    l_tag tag_t;
    l_val std.longstring_t;
    
    procedure append_lob(l_dest in out clob, l_src in clob, l_offset pls_integer, l_amount pls_integer) is
    /*
      Добавить кусок данных из L_SRC, который начинается с L_OFFSET и имеет длину L_AMOUNT, к
      L_DEST. См. http://localhost:8080/FrontPage/Blog#entry05092008
    */
      l_size pls_integer;
      l_max constant pls_integer := 32767;
    begin
      for i in 0 .. Ceil(l_amount / l_max) - 1
      loop
        if l_amount - i * l_max > l_max then
          l_size := l_max;
        else
          l_size := l_amount - i * l_max;
        end if;
        dbms_lob.writeappend(l_dest, l_size, 
          dbms_lob.substr(l_src, l_size, l_offset + i * l_max));
      end loop;
    end;
  begin
    dbms_lob.trim(l_result, 0);
    if l_taglist.count > 0 then
      for i in l_taglist.first .. l_taglist.last
      loop
        l_tag := l_taglist(i);
        -- добавить данные перед тегом
        if l_tag.l_start <> l_pos then
          append_lob(l_result, l_template, l_pos, l_tag.l_start - l_pos);
        end if;
        l_val := null;
        if l_tag.l_name is null then
          -- Если имя пусто, то это не тэг, а просто
          -- последовательность `%%' и ее нужно заменить на одиночный
          -- `%'
          l_val := '%';
        elsif l_values.exists(l_tag.l_name) then
          -- словарь с данными содержит значение для этого тега, нужно
          -- заменить тег значением
          l_val := l_values(l_tag.l_name);
          -- если нужно перед этим применить специальный формат...
          if l_tag.l_format is not null then
            begin
              -- если дата, то явно конвертируем сначала в дату
              l_val := To_Char(To_Date(l_val, std.default_date_format), l_tag.l_format); 
            exception
              when others then
                l_val := To_Char(To_Number(l_val), l_tag.l_format);
            end;
          end if;
        end if;
        -- если полученное значение не пустое, добавим его к результату
        if l_val is not null then
          dbms_lob.writeappend(l_result, length(l_val), l_val);
        end if;
        l_pos := l_tag.l_end + 1;
      end loop;
    end if;
    -- добавить данные после всех тегов
    append_lob(l_result, l_template, l_pos, dbms_lob.getlength(l_template) - l_pos + 1);
  end;
  
  function text_replace(l_template in clob, l_values in std.assocv_t) return clob is
    l_tags taglist_t;
    l_result clob;
  begin
    if extract_tags(l_template, l_tags) then
      dbms_lob.createtemporary(l_result, true, dbms_lob.session); 
      process_tags(l_template, l_tags, l_values, l_result);
    end if;
    return l_result;
  end;

  function format_if(l_format in varchar2,
      l_value in varchar2, 
      l_cond in varchar2, 
      l_op in varchar2) return varchar2 is
    l_result boolean := false;
  begin
    l_result := 
      case l_op
        when 1 then 
          l_value = l_cond or (l_cond is null and l_value is null)
        when 2 then 
          l_value <> l_cond or (l_cond is null and l_value is not null)
             or (l_cond is not null and l_value is null)
        when 3 then l_value < l_cond
        when 4 then l_value <= l_cond
        when 5 then l_value > l_cond
        when 6 then l_value >= l_cond
      end;
    if l_result then
      return Replace(l_format, '%s', l_value);
    else
      return null;
    end if;
  end;
  
  function format_notnull(l_format in varchar2,
      l_value in varchar2) return varchar2 is
  begin
    return format_if(l_format, l_value, null, 2);
  end;
  
  function is_number(s in string_t) return boolean is
      num number;
  begin
      num := To_Number(s);
      return true;
  exception
      when others then
          return false;
  end;
  
  function instr_backward(l_string in varchar2, l_pattern in varchar2, l_offset in integer) return integer
  is
    n integer := length(l_pattern);
    k1 integer := 0;
    k2 integer;
    k3 integer;
  begin
    loop
      if k1 = 0 then
        k3 := 1;
      else
        k3 := k1 + n;
      end if;
      k2 := instr(l_string, l_pattern, k3, 1);
      exit when k2 >= l_offset or k2 = 0;
      k1 := k2;
    end loop;
    return k1;
  end;
  
  function starts_with(l_string in string_t, l_substring in string_t) return boolean is
  begin
    return length(l_string) > length(l_substring) and instr(l_string, l_substring) = 1;
  end;

  function contains(l_string in string_t, l_substring in string_t) return boolean is
  begin
    return InStr(l_string, l_substring) <> 0;
  end;

  function string_replace(l_string in longstring_t, l_rplc in assocv_t)
    return longstring_t is
    l_retval longstring_t;
    l_key string_t;
    l_format string_t;
    l_value longstring_t;
    l_pos integer := 1;
    l_key_matcher constant varchar2(100) := '%(\w+)(\+([^%]+))?%';
    l_module constant varchar2(100) := 'std.string_replace';
  begin
    l_retval := l_string;
    loop
      l_pos := Regexp_InStr(l_retval, l_key_matcher, l_pos);
      exit when l_pos = 0;
      l_key := Regexp_SubStr_Ex(l_retval, l_key_matcher, 1, l_pos);
      if l_rplc.exists(Lower(l_key)) then
        l_format := Regexp_SubStr_Ex(l_retval, l_key_matcher, 3, l_pos);
        if l_format is not null then
          if Is_Date(l_rplc(l_key)) then
            l_value := To_Char(To_Date(l_rplc(l_key)), l_format);
          else
            l_value := To_Char(l_rplc(l_key), l_format);
          end if;
        else
          l_value := l_rplc(l_key);
        end if;
        l_retval := Regexp_Replace(l_retval, l_key_matcher, l_value, l_pos, 1);
      else
        l_pos := l_pos + Length(Regexp_Substr(l_retval, l_key_matcher, l_pos, 1));
      end if;
    end loop;
    return l_retval;
  end;
  
  function regexp_substr_ex(l_source_string in varchar2,
                            l_pattern in varchar2,
                            l_backref in pls_integer,
                            l_position in pls_integer,
                            l_occurence in pls_integer,
                            l_match_parameter in varchar2)
        return varchar2 is
  begin
    if l_backref = 0 then
      return regexp_substr(l_source_string, l_pattern, l_position, 
          l_occurence, l_match_parameter);
    else
      -- вернуть не все совпадение, а capture group с порядковым номером BACKREF
      return regexp_replace(
               regexp_substr(l_source_string, l_pattern, l_position, 
                  l_occurence, l_match_parameter),
               l_pattern,
               '\' || l_backref, 1, 1, l_match_parameter);
    end if;       
  end;
  
  function is_alpha(l_char in varchar2) return boolean
  is
  begin
    return InStr('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', l_char) != 0;
  end;
  
  function is_digit(l_char in varchar2) return boolean
  is
  begin
    return InStr('0123456789', l_char) != 0;
  end;
  
  function has_element(list in varchar2, element in varchar2, delim in varchar2 := ',')
    return integer
  is
  begin
    return instr(delim || replace(list, ' ', '') || delim,
      delim || element || delim);
  end;

  

  function clob_instr_backward(l_clob in clob, l_pattern in varchar2, l_offset in integer) return integer
  is
    n integer := length(l_pattern);
    k1 integer := 0;
    k2 integer;
    k3 integer;
  begin
    loop
      if k1 = 0 then
        k3 := 1;
      else
        k3 := k1 + n;
      end if;
      k2 := dbms_lob.instr(l_clob, l_pattern, k3, 1);
      exit when k2 >= l_offset or k2 = 0;
      k1 := k2;
    end loop;
    return k1;
  end;

  procedure clob_fragment_delete(l_clob in out clob, l_amount in integer, l_offset in integer)
  is
    l_len integer := dbms_lob.getlength(l_clob);
  begin
    if nvl(l_amount, 0) = 0 or nvl(l_offset, 0) = 0 then
      return;
    end if;
    dbms_lob.copy(l_clob, l_clob, l_len - l_offset - l_amount + 1, l_offset, l_offset + l_amount);
    dbms_lob.trim(l_clob, l_len - l_amount);
  end;

  procedure clob_fragment_insert(l_clob in out clob, l_amount in integer, l_offset in integer,
                                 l_buffer in varchar2 character set l_clob%charset)
  is
    l_len integer := dbms_lob.getlength(l_clob);
    l_sub varchar2(32767) := dbms_lob.substr(l_clob, l_len - l_offset + 1, l_offset);
  begin
    if nvl(l_amount, 0) = 0  or nvl(l_offset, 0) = 0 then
      return;
    end if;
/*    
    ИНТЕРЕСНОЕ: вот тут http://asktom.oracle.com/pls/asktom/f?p=100:11:0::::P11_QUESTION_ID:1533006062995 
    пишут, что можно копировать блоб сам в себя, но у меня при больших 
    обработках данных периодически проскакивают ситуации, при которых 
    это копирование каким-то образом "перемешивает" данные на участке 
    копирования, в результате чего получается каша.
    
    dbms_lob.copy(l_clob, l_clob, l_len - l_offset + 1, l_offset + l_amount, l_offset);
*/
    dbms_lob.write(l_clob, l_len - l_offset + 1, l_offset + l_amount, l_sub);
    dbms_lob.write(l_clob, l_amount, l_offset, l_buffer);
  end;
  
 FUNCTION del_spaces (f_text VARCHAR2)
   RETURN VARCHAR2
IS
   l_text                  VARCHAR2 (30000);
   l_infinite_loop_defence   NUMBER           := 0;
/******************************************************************************
   NAME:       del_spaces
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        20.06.2011          1. Created this function.

   NOTES:
      Удаляет в строке повторение пробелов и удаляет лишнии пробелы справа.
      Например: Исх.строка "Строка  с   пробелами    " => "Строка с пробелами".

   Automatically available Auto Replace Keywords:
      Object Name:     del_spaces
      Sysdate:         20.06.2011
      Date and Time:   20.06.2011, 10:30:04, and 20.06.2011 10:30:04
      Username:         Lenskyy Vyacheslav 2 buro 098-110-20-22
      Table Name:       Any Table

******************************************************************************/
BEGIN
   l_text := TRIM (f_text);

   WHILE (INSTR (l_text, '  ') > 0) OR (l_infinite_loop_defence > 300)
   LOOP
      l_text := REPLACE (l_text, '  ', ' ');
      l_infinite_loop_defence := l_infinite_loop_defence + 1;
   END LOOP;
   
   IF l_infinite_loop_defence>300 then return('infite loop');
   END IF;

   RETURN (l_text);
EXCEPTION
   WHEN OTHERS
   THEN
      -- Consider logging the error and then re-raise
      RAISE;
END del_spaces;

Function form_out(val varchar2, mask number) return varchar2 is
    ret_value varchar2(100);
  begin
    Select lpad(val, mask) into ret_value from dual;
    Return(ret_value);
  end form_out;

Function elem_by_pos(in_str in varchar2, pos_elem in integer) return varchar2 is
    l_array std.stringarray_t := std.string_split(in_str, ',');
    l_result varchar2(200);
begin
    if l_array.last >= pos_elem then
     return l_array(pos_elem);
    else
      return null;  
    end if;
end elem_by_pos;

function split_to_table(p_list varchar2, p_del varchar2 := ',') return split_tbl pipelined
is
    l_idx    pls_integer;
    l_list    varchar2(32767) := p_list;
    l_value    varchar2(32767);
begin
    loop
        l_idx := instr(l_list,p_del);
        if l_idx > 0 then
            pipe row(substr(l_list,1,l_idx-1));
            l_list := substr(l_list,l_idx+length(p_del));

        else
            pipe row(l_list);
            exit;
        end if;
    end loop;
    return;
end split_to_table;  
                 
end STD;
/
