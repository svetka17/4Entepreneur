--
-- STD  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--
CREATE OR REPLACE PACKAGE ASUPPP.STD 
/**
 * ����� ��������� ������� ����������� �������.
 */
is
  /** ���������� ��� ��� ����� */
  subtype string_t is varchar2(500);
  /** ���������� ��� ��� ������� ����� */
  subtype longstring_t is varchar2(10000);
  /** ��� "������ �����" */
  type stringarray_t is table of string_t index by pls_integer;
  /** ��� "������������� ������" */
  type assocv_t is table of longstring_t index by string_t;
  /** ��������������� ��������� ��� ������� <tt>extract_tags</tt> 
      � <tt>process_tags</tt>. 
  */
  type tag_t is record(
    l_name std.string_t,
    l_start pls_integer,
    l_end pls_integer,
    l_format std.string_t
  );
  /** ��������������� ��������� ��� ������� <tt>extract_tags</tt> 
      � <tt>process_tags</tt>. 
  */
  type taglist_t is table of tag_t index by pls_integer;
  
  /* -------------------- �������� �� �������� -------------------- */
  /* �������� ������ S � ����� ��� ������ ������ V */
  procedure stringarray_append(l_array in out stringarray_t, 
                               l_string in string_t, 
                               l_prepend in boolean := false);
  /* ���������� ������ ����� � ���� ������, �������� ���������
  /* ��������� ������������ */
  function stringarray_join(l_array in stringarray_t,
                            l_separator in string_t := ',') 
    return longstring_t;
  /* ���������� �� ������ L_STRING ���������� L_SUBSTRING */
  function starts_with(l_string in string_t, l_substring in string_t) return boolean;
  /* ����������, ������ �� ������ L_SUBSTRING � ������ L_STRING */
  function contains(l_string in string_t, l_substring in string_t) return boolean;
  /* ���������� ����� ��� ����������������� ������������� 
     � ����� SQL-�������� */
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
    l_i20 in string_t := null)
    return longstring_t;
  /* ������� ������ �� ����������� �� ������ ����� */
  function string_split(l_string in longstring_t, 
                        l_separator in string_t := ',') 
    return stringarray_t;
  /* �������� ��� ��������� ������ �� l_rplc � ���� %����[+������]% ��
  /* ��������������� �������� */
  function string_replace(l_string in longstring_t, l_rplc in assocv_t)
    return longstring_t;
  function is_alpha(l_char in varchar2) return boolean;
  function is_digit(l_char in varchar2) return boolean;
  /** ����������, �������� �� ������, �������� �������, ��������� �������.
  
      @param list ������ ��������, ���������� ������������ delim.  
          ������ ����� ��������� �������.
      @param element �������, ������� �������� ����� ���������.
      @param delim ����������� ��������� � ������.
      @return 0, ���� ������ �� �������� ��������� �������, � �������� >0, 
          ���� ��������.
    */
  function has_element(list in varchar2, element in varchar2, delim in varchar2 := ',')
    return integer;
  
    
  /* ������� ���������� REGEXP_SUBSTR �� ��� �����������, ���
  /* ��������� �������� �� ��� ���������, � ��������� ������ ������,
  /* �� ������ l_backref */
  function regexp_substr_ex(l_source_string in varchar2,
                            l_pattern in varchar2,
                            l_backref in pls_integer := 0,
                            l_position in pls_integer := 1,
                            l_occurence in pls_integer := 1,
                            l_match_parameter in varchar2 := null)
        return varchar2;
  /* �������� ����������� �� ������������� */
  function xml_escape(l_string in varchar2) return varchar2;
  /* ������������� �������� L_VALUE �������� L_FORMAT, ���� 
     ����������� ������� L_VALUE L_OP L_COND */
  function format_if(l_format in varchar2,
      l_value in varchar2, 
      l_cond in varchar2, 
      l_op in varchar2) return varchar2;
  /* ������������� �������� L_VALUE �������� L_FORMAT, ���� L_VALUE 
     �� NULL */
  function format_notnull(l_format in varchar2,
      l_value in varchar2) return varchar2;
  /* ����������, �������� �� ������ S ����� */
  function is_number(s in string_t) return boolean;
  /** ����� ��������� � �������� �����������.

      ����� ��������� L_PATTERN � ������ L_STRING, ������� � �������
      L_OFFSET, � �������� �����������.

      @return ������� ��������� � ������, ���� 0, ���� ��� �� �������.

    */

  function instr_backward(l_string in varchar2, l_pattern in varchar2, l_offset in integer) return integer;
    
  /* -------------------- ������ � ������ -------------------- */
  /* ���������� ���� � ������ l_month */ 
  function days_in_month (l_month in pls_integer) return pls_integer;
  function Is_Date(l_value in varchar2) return boolean;
  function default_date_format return varchar2;
  /* 
      ������� �������� ������ � ����������� ������.
      
      L_MONTH -- ����� ������ (1..12).
      L_DATE -- ����, �� ������� ����� ������� �����.
      L_LANGUAGE -- ����, �� ������� ���������� �������� �������� ������ (russian, ukrainian).
  */
  function of_month(l_month pls_integer, l_language varchar2 := 'russian') return varchar2;
  function of_month(l_date date, l_language varchar2 := 'russian') return varchar2;
  /** 
      ���������, ������������ �� ��� ��������� ���������.  
      
      @param p_start1 ������ ������� ���������
      @param p_end1 ����� ������� ���������
      @param p_start2 ������ ������� ���������
      @param p_end2 ����� ������� ���������
  */
  function date_intersect(p_start1 in date, p_end1 in date,
    p_start2 in date, p_end2 in date) return integer;
  /**
     ������������� INTERVAL DAY TO SECOND � ����������� ��� ("2 ���� 3 ������").
  
  */
  function dsinterval_readable(p_interval in interval day to second)
    return varchar2;
  
  /* -------------------- ������ � ������ -------------------- */
  /*
     ��� ������������ ����� "��������������" ��� �������� ������ 
     (��������� %-������������������� � printf). � ������ ����������
     ��� ������������ ����� ���, ����������� ����� ��������� `%'; 
     ����� ����� ����� ����� ��������� ������ `+' � ������ ������� ��� 
     ������. ��� ������� � ����� ��������������� ������� `%' ���������� 
     ������������ ������������������ `%%'. ������� �����:
     
        %naim%, %number_c%, %date_c+dd.mm.yyyy%, %cost+FM000.00%
        
     ������������� ����� ������� ����������� ��� ����������� � ������� 
     ������ ����� � ������.
        
  */
  /* 
    EXTRACT_TAGS -- ����� ��� ���� � ������� L_TEMPLATE; ���������� 
    ������ ������������ � �������� L_TAGLIST. ���� �� ���� ������, 
    ���������� TRUE, ����� FALSE.
  */
  function extract_tags(l_template in clob, l_taglist in out taglist_t) return boolean;
  /*
    PROCESS_TAGS -- �������� ���� � ������� L_TEMPLATE �� �������� ������. 
    ������ ����� �������� ���������� L_TAGLIST (���� ������ ������ ���� 
    �������������� ������� ����������� ������� EXTRACT_TAGS). ������ ��������
    �������� �������� �������� L_VALUES, � ������� ����� ��������� � ���� ����
    �����, � �������� -- � ���� �������� ��� ���� �����. ��������� ������������
    � �������� L_RESULT.
  */
  procedure process_tags(l_template in clob, l_taglist in taglist_t, l_values in std.assocv_t, 
    l_result in out clob);
  /*
    TEXT_REPLACE -- �������� ���� � ������� L_TEMPLATE �� ��������, ��������� � 
    ������� L_VALUES, ����� �������� ��������� � ���� ���� �����, � �������� -- 
    � ���� �������� ��� ���� �����. ���������� ��������� ������.
    
    NB: ��� ������� �������� ������ ��������������� �������� EXTRACT_TAGS � PROCESS_TAGS.
  */
  function text_replace(l_template in clob, l_values in std.assocv_t) return clob;
  
  /* -------------------- ������ -------------------- */
  /* �������� ��������� �� ������� l_message ��� ��������� ���������� l_application */
  procedure debug_message(l_application in varchar2, l_message in varchar2, add_to_debug in boolean default true);
  /* ������ ���������� ��������� �� ���������� ���������� �� ���������
  /* ������ ������� (����� ������ ���������� ������ ������������
  /* ������� ������� �������, �� ��������� = 1 ������) */
  procedure print_lastsession_debug(l_application in string_t, 
                                    l_treshold in pls_integer := 60);
  /* ������ �������� L_PATTERN � L_CLOB � �������� ����������� �� L_OFFSET 
     ���������� �������, ���� �������� ������, � 0, ���� �� ������.
  */
  function clob_instr_backward(l_clob in clob, l_pattern in varchar2, l_offset in integer) return integer;
  
  procedure clob_fragment_delete(l_clob in out clob, l_amount in integer, l_offset in integer);
  procedure clob_fragment_insert(l_clob in out clob, l_amount in integer, l_offset in integer,
                                 l_buffer in varchar2 character set l_clob%charset);
                                 
  
  
  /* ������� � ������ ���������� �������� � ������� ������ ������� ������.
      ��������: ���.������ "������  �   ���������    " => "������ � ���������".
  */
  FUNCTION del_spaces (f_text VARCHAR2)
   RETURN VARCHAR2;
   
   
   Function form_out(val varchar2, mask number) 
   return varchar2;
    /*
    @param val IN - ������ ��� ��������������
    @param mask IN - ����� �������������� ������
    @return - ������ ������� � mask ��������   
    */
    
    Function elem_by_pos(in_str in varchar2, pos_elem in integer) return varchar2;
end STD;
/
