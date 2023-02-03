--
-- STD  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--
CREATE OR REPLACE PACKAGE ASUPPP.STD 
/**
 * Пакет различных удобных стандартных функций.
 */
is
  /** Обобщенный тип для строк */
  subtype string_t is varchar2(500);
  /** Обобщенный тип для длинных строк */
  subtype longstring_t is varchar2(10000);
  /** Тип "массив строк" */
  type stringarray_t is table of string_t index by pls_integer;
  /** Тип "ассоциативный массив" */
  type assocv_t is table of longstring_t index by string_t;
  /** Вспомогательная структура для функций <tt>extract_tags</tt> 
      и <tt>process_tags</tt>. 
  */
  type tag_t is record(
    l_name std.string_t,
    l_start pls_integer,
    l_end pls_integer,
    l_format std.string_t
  );
  /** Вспомогательная структура для функций <tt>extract_tags</tt> 
      и <tt>process_tags</tt>. 
  */
  type taglist_t is table of tag_t index by pls_integer;
  
  /* -------------------- ОПЕРАЦИИ СО СТРОКАМИ -------------------- */
  /* Добавить строку S в конец или начало списка V */
  procedure stringarray_append(l_array in out stringarray_t, 
                               l_string in string_t, 
                               l_prepend in boolean := false);
  /* Объединить массив строк в одну строку, разделяя подстроки
  /* указанным разделителем */
  function stringarray_join(l_array in stringarray_t,
                            l_separator in string_t := ',') 
    return longstring_t;
  /* Начинается ли строка L_STRING подстрокой L_SUBSTRING */
  function starts_with(l_string in string_t, l_substring in string_t) return boolean;
  /* Определить, входит ли строка L_SUBSTRING в строку L_STRING */
  function contains(l_string in string_t, l_substring in string_t) return boolean;
  /* упрощенная форма для непосредственного использования 
     в среде SQL-запросов */
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
  /* Разбить строку по разделителю на массив строк */
  function string_split(l_string in longstring_t, 
                        l_separator in string_t := ',') 
    return stringarray_t;
  /* Заменить все вхождения ключей из l_rplc в виде %ключ[+формат]% на
  /* соответствующие значения */
  function string_replace(l_string in longstring_t, l_rplc in assocv_t)
    return longstring_t;
  function is_alpha(l_char in varchar2) return boolean;
  function is_digit(l_char in varchar2) return boolean;
  /** Определить, содержит ли список, заданный строкой, указанный элемент.
  
      @param list Список значений, разделённых разделителем delim.  
          Список может содержать пробелы.
      @param element Элемент, наличие которого нужно проверить.
      @param delim Разделитель элементов в списке.
      @return 0, если список не содержит указанный элемент, и значение >0, 
          если содержит.
    */
  function has_element(list in varchar2, element in varchar2, delim in varchar2 := ',')
    return integer;
  
    
  /* Функция аналогична REGEXP_SUBSTR за тем исключением, что
  /* позволяет выбирать не все выражение, а некоторую группу внутри,
  /* по номеру l_backref */
  function regexp_substr_ex(l_source_string in varchar2,
                            l_pattern in varchar2,
                            l_backref in pls_integer := 0,
                            l_position in pls_integer := 1,
                            l_occurence in pls_integer := 1,
                            l_match_parameter in varchar2 := null)
        return varchar2;
  /* заменить спецсимволы их эквивалентами */
  function xml_escape(l_string in varchar2) return varchar2;
  /* форматировать значение L_VALUE форматом L_FORMAT, если 
     выполняется условие L_VALUE L_OP L_COND */
  function format_if(l_format in varchar2,
      l_value in varchar2, 
      l_cond in varchar2, 
      l_op in varchar2) return varchar2;
  /* форматировать значение L_VALUE форматом L_FORMAT, если L_VALUE 
     не NULL */
  function format_notnull(l_format in varchar2,
      l_value in varchar2) return varchar2;
  /* Определяет, содержит ли строка S число */
  function is_number(s in string_t) return boolean;
  /** Поиск подстроки в обратном направлении.

      Поиск подстроки L_PATTERN в строке L_STRING, начиная с позиции
      L_OFFSET, в обратном направлении.

      @return Позицию подстроки в тексте, либо 0, если она не найдена.

    */

  function instr_backward(l_string in varchar2, l_pattern in varchar2, l_offset in integer) return integer;
    
  /* -------------------- РАБОТА С ДАТАМИ -------------------- */
  /* Количество дней в месяце l_month */ 
  function days_in_month (l_month in pls_integer) return pls_integer;
  function Is_Date(l_value in varchar2) return boolean;
  function default_date_format return varchar2;
  /* 
      Вернуть название месяца в родительном падеже.
      
      L_MONTH -- номер месяца (1..12).
      L_DATE -- дата, по которой нужно выбрать месяц.
      L_LANGUAGE -- язык, на котором необходимо получить название месяца (russian, ukrainian).
  */
  function of_month(l_month pls_integer, l_language varchar2 := 'russian') return varchar2;
  function of_month(l_date date, l_language varchar2 := 'russian') return varchar2;
  /** 
      Проверить, пересекаются ли два временных интервала.  
      
      @param p_start1 Начало первого интервала
      @param p_end1 Конец первого интервала
      @param p_start2 Начало второго интервала
      @param p_end2 Конец второго интервала
  */
  function date_intersect(p_start1 in date, p_end1 in date,
    p_start2 in date, p_end2 in date) return integer;
  /**
     Преобразовать INTERVAL DAY TO SECOND в читабельный вид ("2 часа 3 минуты").
  
  */
  function dsinterval_readable(p_interval in interval day to second)
    return varchar2;
  
  /* -------------------- РАБОТА С ТЭГАМИ -------------------- */
  /*
     Тег представляет собой "местодержатель" для реальных данных 
     (наподобие %-последовательностей в printf). В данной реализации
     тег представляет собой имя, заключенное между символами `%'; 
     сразу после имени может следовать символ `+' и строка формата для 
     данных. Для вставки в текст непосредственно символа `%' необходимо 
     использовать последовательность `%%'. Примеры тегов:
     
        %naim%, %number_c%, %date_c+dd.mm.yyyy%, %cost+FM000.00%
        
     Нижеописанный набор функций применяется для эффективной и быстрой 
     замены тегов в тексте.
        
  */
  /* 
    EXTRACT_TAGS -- найти все теги в шаблоне L_TEMPLATE; полученный 
    список записывается в аргумент L_TAGLIST. Если не было ошибок, 
    возвращает TRUE, иначе FALSE.
  */
  function extract_tags(l_template in clob, l_taglist in out taglist_t) return boolean;
  /*
    PROCESS_TAGS -- заменить теги в шаблоне L_TEMPLATE на реальные данные. 
    Список тегов задается параметром L_TAGLIST (этот список должен быть 
    предварительно получен посредством функции EXTRACT_TAGS). Список реальных
    значений задается словарем L_VALUES, в котором ключи выступают в роли имен
    тегов, а значения -- в роли значений для этих тегов. Результат записывается
    в аргумент L_RESULT.
  */
  procedure process_tags(l_template in clob, l_taglist in taglist_t, l_values in std.assocv_t, 
    l_result in out clob);
  /*
    TEXT_REPLACE -- заменить теги в шаблоне L_TEMPLATE на значения, описанные в 
    словаре L_VALUES, ключи которого выступают в роли имен тегов, а значения -- 
    в роли значений для этих тегов. Возвращает результат замены.
    
    NB: эта функция является просто последовательно вызывает EXTRACT_TAGS и PROCESS_TAGS.
  */
  function text_replace(l_template in clob, l_values in std.assocv_t) return clob;
  
  /* -------------------- РАЗНОЕ -------------------- */
  /* Добавить сообщение об отладке l_message для заданного приложения l_application */
  procedure debug_message(l_application in varchar2, l_message in varchar2, add_to_debug in boolean default true);
  /* Выдать отладочные сообщения от указанного приложения за последнюю
  /* сессию запуска (можно вторым параметром задать максимальный
  /* разброс времени запуска, по умолчанию = 1 минута) */
  procedure print_lastsession_debug(l_application in string_t, 
                                    l_treshold in pls_integer := 60);
  /* Искать фрагмент L_PATTERN в L_CLOB в обратном направлении от L_OFFSET 
     Возвращает позицию, если фрагмент найден, и 0, если не найден.
  */
  function clob_instr_backward(l_clob in clob, l_pattern in varchar2, l_offset in integer) return integer;
  
  procedure clob_fragment_delete(l_clob in out clob, l_amount in integer, l_offset in integer);
  procedure clob_fragment_insert(l_clob in out clob, l_amount in integer, l_offset in integer,
                                 l_buffer in varchar2 character set l_clob%charset);
                                 
  
  
  /* Удаляет в строке повторение пробелов и удаляет лишнии пробелы справа.
      Например: Исх.строка "Строка  с   пробелами    " => "Строка с пробелами".
  */
  FUNCTION del_spaces (f_text VARCHAR2)
   RETURN VARCHAR2;
   
   
   Function form_out(val varchar2, mask number) 
   return varchar2;
    /*
    @param val IN - строка для форматирования
    @param mask IN - длина результирующей строки
    @return - строку блинной в mask символов   
    */
    
    Function elem_by_pos(in_str in varchar2, pos_elem in integer) return varchar2;
end STD;
/
