CREATE OR REPLACE package body ASUPPP.contract_pkg is
  
  function get_contract_report(l_unik_c in cont_head.unik_c%type) return varchar2 is
    l_result varchar2(100);
    cont_r cont_head%rowtype;
    l_vidr_naim vidr.naim%type;
  begin
    begin
      select * into cont_r from cont_head where unik_c = l_unik_c;
    exception
      when No_Data_Found then
        std.debug_message('contract_pkg.get_contract_report',
          'UNIK_C = ' || l_unik_c || '; контракт не найден');
        return null;
    end;
    begin
      select lower(naim) into l_vidr_naim from vidr where kod = cont_r.kod_ras;
    exception
      when No_Data_Found then
        std.debug_message('contract_pkg.get_contract_report',
          'UNIK_C = ' || l_unik_c || '; вид расчета не найден, KOD_RAS = '
          || cont_r.kod_ras);
        return null;
    end;
    if cont_r.type = get_type_for_dop_sogl then
      if cont_r.dop_sogl_predmet = 1 then
        l_result := 'BAV_DOP_SOGL_OAO2PAO.rdf';
      elsif   cont_r.dop_sogl_predmet = 2 then
        l_result := 'BAV_DOP_SOGL_PUMB.rdf';
      elsif   cont_r.dop_sogl_predmet = 4 then
        l_result := 'BAV_DOP_SOGL_BANK.rdf';  
      else
        l_result := 'BAV_DOP_SOGL_GENERIC.rdf';
      end if;
    elsif cont_r.type = get_type_for_pril then
       l_result := 'BAV_PRIL.rdf';  
    elsif cont_r.type = get_type_for_contract then
      -- определим имя нужного нам отчета
      l_result := 'BAV_CONTRACT_';
      if cont_r.kod_ras = 49 then
        l_result := l_result || 'MIXED_VIDR49_';
      elsif l_vidr_naim = 'предоплата' then
        -- полная предоплата
        l_result := l_result || 'PREPAID_';
      elsif l_vidr_naim like 'предоплата %' then
        l_result := l_result || 'MIXED_';
      elsif l_vidr_naim like 'отсрочка%' then
        l_result := l_result || 'DEFER_';
      else
          std.debug_message('contract_pkg.get_contract_report',
            'UNIK_C = ' || l_unik_c || '; отчет для вида расчета VIDR_NAIM = ' ||
            l_vidr_naim || ' не определен');
          return null;
      end if;
      case cont_r.suffix
        when 13 then l_result := l_result || 'PRO';
        when 20 then l_result := l_result || 'ILS';
        when 126 then l_result := l_result || 'PRO';
        when 1 then l_result := l_result || 'PRO';
        else
          std.debug_message('contract_pkg.get_contract_report',
            'UNIK_C = ' || l_unik_c || '; шаблон для отдела с суффиксом SUFFIX = ' ||
            cont_r.suffix || ' не найден');
          return null;
      end case;
      l_result := l_result || '.rdf';
    end if;
    --std.debug_message('contract_pkg.get_contract_report',l_result||' '||l_unik_c);
    return l_result;
  end;

  function get_contract_number(l_unik_c in cont_head.unik_c%type) return varchar2
  is
    cont_r cont_head%rowtype;
    num_cont varchar2(240);
  begin
    begin
      select * into cont_r from cont_head where unik_c = l_unik_c;
    exception
      when No_Data_Found then
        std.debug_message('contract_pkg.get_contract_number',
          'UNIK_C = ' || l_unik_c || '; контракт не найден');
        return null;
    end;
    case
      when to_number(cont_r.vid_cont)=60 and nvl(cont_r.type,0)<>4 then 
        case
          when cont_r.number_c = '12EXP/12-01' then num_cont := '12EXP/12-01';
          when cont_r.number_c = '12EXP/12-02' then num_cont := '12EXP/12-02';
          when cont_r.number_c = '3M-300' then num_cont := '3M-300';
          when cont_r.number_c = '3М-300' then num_cont := '3M-300';
          when cont_r.number_c = '12EXP/30' and cont_r.year=2013 then num_cont := '12EXP/30/13/13';
          else num_cont := cont_r.number_c||'-'||substr(cont_r.year,-2)||case 
                                                                                                          when cont_r.number_c_dop is null then ''
                                                                                                          when cont_r.number_c_dop = '' then ''
                                                                                                          else '/'||cont_r.number_c_dop
                                                                                                        end;
        end case;  
         
         --select trim(decode(number_c,'12EXP/12-01','12EXP/12-01','12EXP/12-02','12EXP/12-02','3M-300','3M-300','3М-300','3M-300',number_c||'-'||substr(year,-2)))||decode(number_c_dop,null,null,'/'||number_c_dop) into num_cont from cont_head where unik_c = l_unik_c;
      else    
        if (cont_r.suffix in (13, 20) and cont_r.type = get_type_for_contract)  or cont_r.unik_c=161404   then
          num_cont := cont_r.number_c || '/' || cont_r.suffix || '/' || lpad(mod(cont_r.year, 100), 2, '0')||case when cont_r.number_c_dop is null then null else '/'||cont_r.number_c_dop end;
        elsif cont_r.suffix in (10, 1) and cont_r.type = get_type_for_contract then
          num_cont := cont_r.number_c||case when cont_r.number_c_dop is null then null else '/'||cont_r.number_c_dop end;
        elsif  cont_r.suffix in (126) and cont_r.type = get_type_for_contract and to_number(cont_r.vid_cont)=50 then
          num_cont := cont_r.number_c || '/' || cont_r.suffix||case when cont_r.number_c_dop is null then null else '/'||cont_r.number_c_dop end;
        else
          -- fallback
          num_cont := cont_r.number_c||case when cont_r.number_c_dop is null then null else '/'||cont_r.number_c_dop end;
        end if;
    end case; 
    return substr(num_cont,1,240); 
  end;
  

  function get_spec_report(l_unik_s in cont_spec.unik_s%type,
    l_variant in pls_integer, l_test in pls_integer default 0) return varchar2
  is
   -- l_unik_c cont_head.unk_c%type;
    l_suffix cont_head.suffix%type;
    l_shop cont_spec.shop%type;
    l_vid_cont cont_head.vid_cont%type;
    l_prizn_otsort cont_spec.prizn_otsort%type;
    l_report varchar2(100) := 'BAV_CONT_SPEC';
  begin
    select --ch.unik_c,
    ch.suffix, ch.vid_cont,cs.shop,cs.prizn_otsort
      into --l_unik_c,
      l_suffix, l_vid_cont,l_shop,l_prizn_otsort
      from cont_head ch
        join cont_spec cs on ch.unik_c = cs.unik_c
      where unik_s = l_unik_s;
    if (l_vid_cont = 60) then
     if l_shop in (610,611,613,602) then
      l_report := l_report||'_EXP_'||l_shop;
     else
      l_report :=  l_report||'_EXP_602';
     end if; 
    else    
      if l_variant = 2 or l_variant = 3 then
        l_report := l_report || '_' || l_variant;
      end if;   
      if (l_suffix in (10, 13, 1))  then
        l_report := l_report || '_PRO';
      elsif (l_suffix = 20)  then
        l_report := l_report || '_ILS';
      elsif (l_suffix = 126)  then
        l_report := l_report || '_MARKETING';
      else
        std.debug_message('contract_pkg.get_spec_report',
          'UNIK_S = ' || l_unik_s || '; шаблон для отдела с суффиксом SUFFIX = ' ||
          l_suffix || ' не найден');
        return null;
      end if;
    end if;
   /* if (nvl(l_prizn_otsort,0) > 0) and (l_vid_cont = 60) and (l_shop = 611) then
     l_report := l_report||'_OTSORT';
    end if;*/  
    if l_test = 1 then
      l_report := l_report || '_TEST';
    end if;  
    l_report := l_report || '.rdf';
    return l_report;
  exception when No_Data_Found then
    std.debug_message('contract_pkg.get_spec_report',
      'UNIK_S = ' || l_unik_s || '; спецификация не найдена');
    return null;
  end;

  function report_helper_mark_same(l_unik_p cont_pos.unik_p%type) return pls_integer
  is
    cursor prev_pos_c(l_unik_p cont_pos.unik_p%type) is
      select cp1.unik_p
        from cont_pos cp1
          join cont_pos cp2 on cp2.unik_p = l_unik_p
        where cp1.npoz < cp2.npoz and cp1.unik_s = cp2.unik_s and nvl(cp1.zak_pp,0) = nvl(cp2.zak_pp,0)
        order by cp1.npoz desc;
    l_result boolean := false;
    l_prev_unik_p cont_pos.unik_p%type;
    l_prev_marks varchar2(500);
    l_curr_marks varchar2(500);
    ct number;
  begin
    open prev_pos_c(l_unik_p);
    -- получить UNIK_P предыдущей позиции
    fetch prev_pos_c into l_prev_unik_p;
    if prev_pos_c%found then
       select count(unik_p)
       into ct 
       from cont_pos_mark
       where unik_p= l_unik_p;
      -- получить марки предыдущей позиции
      if  ct>0
     then 
            l_prev_marks:=sql_to_str('mark', 'cont_pos_mark', 'unik_p='|| l_prev_unik_p, ' ' ) ;
            l_curr_marks:=sql_to_str('mark', 'cont_pos_mark', 'unik_p='|| l_unik_p, ' ' ) ;
     else
      
              select mark1 || ' ' || mark2 || ' ' || mark3 || ' ' || mark4 || ' ' || mark_txt
                into l_prev_marks
                from cont_pos where unik_p = l_prev_unik_p;
              -- получить марки текущей позиции
              select mark1 || ' ' || mark2 || ' ' || mark3 || ' ' || mark4 || ' ' || mark_txt
                into l_curr_marks
                from cont_pos where unik_p = l_unik_p;
                
      end if;          
      l_result := l_prev_marks = l_curr_marks;
    end if;
    close prev_pos_c;
    return case l_result when true then 1 else 0 end;
  end;
  
  function report_helper_mark_same_all(l_unik_s cont_spec.unik_s%type, l_zak_pp cont_pos.zak_pp%type default 0) return pls_integer
  is
    n number;
    n1 number;
    ct number;
--    suf number;
  begin
     select count(unik_p)
     into ct 
     from cont_pos_mark
     where unik_p in (select unik_p from cont_pos
                                where unik_s=l_unik_s);
       
    if ct>0  then
        declare
                mark_all varchar2(2000);
                mark_curr varchar2(2000);

                begin
                  n1:=0;
                  mark_all:='';
                  mark_curr:='gbfgfg';
                  for i in   (select  distinct unik_p
                               from cont_pos
                               where unik_s=l_unik_s)
                   loop
                     for j in   (select  mark MM
                                  from cont_pos_mark
                                  where unik_p=i.unik_p)
                      loop            
                            --gost_curr:=std.arguments_join(' ', j.gost1, j.gost2, j.gost3, j.gost4);
                            mark_all:= mark_all||' '||j.MM;
                     end loop;               

                     if mark_curr<>mark_all
                     then n1:=n1+1;
                            mark_curr:=mark_all;
                     end if;       
                     -- DBMS_OUTPUT.PUT_LINE(gost_all);     
                      mark_all:='';
                   end loop;

                    --  DBMS_OUTPUT.PUT_LINE(n1);    

                end;
    else
        select count(distinct std.arguments_join(' ',
            mark1, mark2, mark3, mark4))
          into n
          from cont_pos where unik_s = l_unik_s; 
     end if;      
     
    if n > 1 or n1 > 1 then
      return 0;
    else
      return 1;
    end if;
  end;  

 
  function report_helper_gost_same(l_unik_p cont_pos.unik_p%type) return pls_integer
  is
    cursor prev_pos_c(l_unik_p cont_pos.unik_p%type) is
      select cp1.unik_p
        from cont_pos cp1
          join cont_pos cp2 on cp2.unik_p = l_unik_p
        where cp1.npoz < cp2.npoz and cp1.unik_s = cp2.unik_s
        order by cp1.npoz desc;
    l_result boolean := false;
    l_prev_unik_p cont_pos.unik_p%type;
    l_prev_gost varchar2(500);
    l_curr_gost varchar2(500);
    l_prev_gost1 varchar2(500);
    l_curr_gost1 varchar2(500);
    l_prev_tt varchar2(500);
    l_curr_tt varchar2(500);
    ct number;
  begin
    open prev_pos_c(l_unik_p);
    -- получить UNIK_P предыдущей позиции
    fetch prev_pos_c into l_prev_unik_p;
    if prev_pos_c%found then
       select count(unik_p)
       into ct 
       from cont_pos_mark
       where unik_p= l_unik_p;
    
       if  ct>0
      then 
            
                  -- получить госты предыдущей позиции
       /*           select std.arguments_join(' ',
                      cm.gost1, cm.gost2, cm.gost3, cm.gost4)                
                  into l_prev_gost1
                  from cont_pos_mark cm
                  where cm.unik_p = l_prev_unik_p;*/
                  
                  l_prev_gost1:=sql_to_str('nvl(gost1,0)||nvl(gost2,0)||nvl(gost3,0)||nvl(gost4,0)||nvl(zak_pp,0)', 'cont_pos_mark', 'unik_p='||l_prev_unik_p);

                  select std.arguments_join(' ',
                           cp.tt1, cp.tt2, cp.tt3, cp.tt4, cp.tt5, cp.tt6, cp.tt7, cp.tt8, cp.uzk,cp.dop_treb)                      
                  into l_prev_tt
                  from cont_pos cp
                  where   cp.unik_p = l_prev_unik_p ;  
                  
                 l_prev_gost:=l_prev_gost1||l_prev_tt;                 
                  
                  -- получить госты  текущей позиции
       /*           select std.arguments_join(' ',
                      cm.gost1, cm.gost2, cm.gost3, cm.gost4)                
                  into l_curr_gost1
                  from cont_pos_mark cm
                  where cm.unik_p = l_unik_p;*/
                  
                  
                  
                  
                   l_curr_gost1:=sql_to_str('nvl(gost1,0)||nvl(gost2,0)||nvl(gost3,0)||nvl(gost4,0)||nvl(zak_pp,0)', 'cont_pos_mark', 'unik_p='||l_unik_p);

                  select std.arguments_join(' ',
                           cp.tt1, cp.tt2, cp.tt3, cp.tt4, cp.tt5, cp.tt6, cp.tt7, cp.tt8, cp.uzk,cp.dop_treb)                      
                  into l_curr_tt
                  from cont_pos cp
                  where   cp.unik_p = l_unik_p ;  
                  
                 l_curr_gost:= l_curr_gost1||l_curr_tt;      

            
      else                   
                  -- получить госты предыдущей позиции
                  select std.arguments_join(' ',
                      gost1, gost2, gost3, gost4,
                      tt1, tt2, tt3, tt4, tt5, tt6, tt7, tt8, uzk,dop_treb,zak_pp)
                    into l_prev_gost
                    from cont_pos where unik_p = l_prev_unik_p;
                  -- получить госты  текущей позиции
                  select std.arguments_join(' ',
                      gost1, gost2, gost3, gost4,
                      tt1, tt2, tt3, tt4, tt5, tt6, tt7, tt8, uzk,dop_treb,zak_pp)
                    into l_curr_gost
                    from cont_pos where unik_p = l_unik_p;
       end if;  
      l_result := l_prev_gost = l_curr_gost;
    end if;
    close prev_pos_c;
    return case l_result when true then 1 else 0 end;
  end;

  function report_helper_gost_same_all(l_unik_s cont_spec.unik_s%type, l_zak_pp cont_pos.zak_pp%type default 0) return pls_integer
  is
    n number;
    ct number;
    n1 number;
  begin
  /*  case 
      when spc_vidspec(l_unik_s)<>10 then 
          select count(distinct std.arguments_join(' ', gost1, gost2, gost3, gost4, tt1, tt2, tt3, tt4, tt5, tt6, tt7, tt8, uzk,dop_treb)) into n
          from cont_pos where unik_s = l_unik_s and nvl(zak_pp,0)=nvl(l_zak_pp,0);
      else*/    
      
       select count(unik_p)
       into ct 
       from cont_pos_mark
       where unik_p in (select unik_p from cont_pos
                                where unik_s=l_unik_s);
       
      if ct>0
      then
                declare
                gost_all varchar2(2000);
                gost_curr varchar2(2000);
                tt_curr varchar2(2000);
                tt_all varchar2(2000);

                begin
                  n1:=0;
                  gost_all:='';
                  gost_curr:='gbfgfg';
                  for i in   (select  distinct unik_p
                               from cont_pos
                               where unik_s=l_unik_s)
                   loop
                             select distinct std.arguments_join(' ', tt1, tt2, tt3, tt4, tt5, tt6, tt7, tt8, uzk,dop_treb)
                              into  tt_curr
                              from cont_pos     
                              where unik_p=i.unik_p;
                                                  
                     for j in   (select  distinct std.arguments_join(' ', gost1, gost2, gost3, gost4) GG
                                  from cont_pos_mark
                                  where unik_p=i.unik_p)
                      loop            
                            --gost_curr:=std.arguments_join(' ', j.gost1, j.gost2, j.gost3, j.gost4);
                            gost_all:= gost_all||' '||j.GG;
                            
                     end loop;               

                    gost_all:= gost_all||tt_curr;

                     if gost_curr<>gost_all
                     then n1:=n1+1;
                            gost_curr:=gost_all;
                     end if;       
                     -- DBMS_OUTPUT.PUT_LINE(gost_all);     
                      gost_all:='';
                   end loop;

                    --  DBMS_OUTPUT.PUT_LINE(n1);    

                end;

                                    
      else 
          select count(distinct std.arguments_join(' ', gost1, gost2, gost3, gost4, tt1, tt2, tt3, tt4, tt5, tt6, tt7, tt8, uzk,dop_treb)) into n
          from cont_pos     
          where unik_s = l_unik_s;
          
      end if;
      
    --end case;      
    if n > 1 or n1>1 then
      return 0;
    else
      return 1;
    end if;
  end;

  function report_helper_get_prod_char(l_unik_p cont_pos.unik_p%type) return varchar2
  is
    l_gost varchar2(1000);
    l_tts std.stringarray_t;
    l_tt_string varchar2(500);
    l_class varchar2(100);
    l_pravila varchar2(500);
    v_gost1 varchar2(300);
    v_gost1_1 varchar2(300);
    v_gost1_2 varchar2(300);
    v_gost2 varchar2(300);
    v_gost3 varchar2(300);
    v_gost4 varchar2(300);
    v_en_in number;    
    ct number;
  begin
    for r in (
      select
          spc_vidspec(cont_pos.unik_s) vid_spc,
          use_eurogost_scheme,
          nsi2021.nsi20201 as gost1,
          nsi2021_1.nsi20201 as gost1_1,
          nsi2021_2.nsi20201 as gost1_2,
          nsi2022.nsi20201 as gost2,
          nsi2023.nsi20201 as gost3,
          nsi2024.nsi20201 as gost4,
          tt1,
          tt2,
          tt3,
          tt4,
          tt5,
          tt6,
          tt7,
          tt8,
          nvl(nsi205_1.nsi20503,nsi205_1.nsi20505) as uzk,
          nsi20603 as uslp,
          nvl(nsi205_2.nsi20503,nsi205_2.nsi20505) as doptr
        from cont_pos
          join cont_spec on cont_spec.unik_s = cont_pos.unik_s
          left join nsi202 nsi2021 on nsi2021.nsi20203 = gost1
          left join nsi202 nsi2021_1 on nsi2021_1.nsi20203 = gost1_1
          left join nsi202 nsi2021_2 on nsi2021_2.nsi20203 = gost1_2
          left join nsi202 nsi2022 on nsi2022.nsi20203 = gost2
          left join nsi202 nsi2023 on nsi2023.nsi20203 = gost3
          left join nsi202 nsi2024 on nsi2024.nsi20203 = gost4
          left join nsi205 nsi205_1 on nsi205_1.nsi20501 = uzk
          left join nsi206 on nsi20601 = uslp
          left join nsi205 nsi205_2 on nsi205_2.nsi20501=dop_treb
        where
          unik_p = l_unik_p)
    loop
      l_pravila := '';
      
      select str_join(nsi20505) into l_pravila
      from cont_pos
      join cont_spec on cont_spec.unik_s = cont_pos.unik_s
      left join cont_spec_dop_treb on cont_spec_dop_treb.unik_s=cont_pos.unik_s
      left join nsi205 on nsi205.nsi20501=cont_spec_dop_treb.code
      where unik_p = l_unik_p and nsi205.nsi20504=9;
      
      select count(unik_p) into ct from cont_pos_mark where unik_p=l_unik_p; --есть ли позиция в cont_pos_mark
      
      if ct=0 then --если нет, берем из cont_pos
        v_gost1 := r.gost1;
        v_gost1_1 := r.gost1_1;
        v_gost1_2 := r.gost1_2;
        v_gost2 := r.gost2;
        v_gost3 := r.gost3;
        v_gost4 := r.gost4;
        if instr(v_gost2,'EN')<>0 then 
          v_en_in := 1;
        else
          v_en_in := 0;
        end if;
      else --если есть, берем из cont_pos_mark 1-я марка
        v_gost1 := sql_to_str('text_gost(gost1)','cont_pos_mark','unik_p='||l_unik_p||' and gost1 is not null',',',1,'npp');
        v_gost1_1 := null;
        v_gost1_2 := null;        
        v_gost2 := sql_to_str('text_gost(gost2)','cont_pos_mark','unik_p='||l_unik_p||' and gost2 is not null',',',1,'npp');
        v_gost3 := sql_to_str('text_gost(gost3)','cont_pos_mark','unik_p='||l_unik_p||' and gost3 is not null',',',1,'npp');
        v_gost4 := sql_to_str('text_gost(gost4)','cont_pos_mark','unik_p='||l_unik_p||' and gost4 is not null',',',1,'npp');      
        if instr(v_gost2,'EN')<>0 then 
          v_en_in := 1;
        else
          v_en_in := 0;
        end if;        
      end if;        
             
    
      if (r.use_eurogost_scheme = 1) and (r.vid_spc=60 or v_en_in=1) then
        return
          std.arguments_join(',' || chr(10),
            -- стандарт
            v_gost1,
            -- условия на допуски
            std.arguments_join(' ',
              v_gost2,
              std.format_notnull('кл. %s', r.tt1),
              std.format_notnull('пл. %s', r.tt2)
            ),
            -- требования к состоянию поверхности
            std.arguments_join(' ',
              v_gost3,
              std.format_notnull('кл. %s', r.tt3),
              std.format_notnull('п/кл. %s', r.tt4)
            ),         
            -- вид сертификата
            v_gost4,
            -- узк
            r.uzk,
            -- условия порезки
            r.uslp,
            l_pravila,
            r.doptr
          );
      else
        l_gost :=
          std.arguments_join(',' || chr(10),
            v_gost1,
            v_gost2,
            v_gost3,
            v_gost4
            /*r.gost1_2,
            r.gost2,
            r.gost3,
            r.gost4*/);
        /*
          После гостов должны идти технические требования,
          но если среди них есть классы прочности (цифры 265,
          295, 315, 325, 345, 355, 375, 390, 440), то
          необходимо их печатать как "кл. НИЖНИЙ-ВЕРХНИЙ" (если
          две цифры), либо как "кл. НОМЕР" (если одна)
        */
        std.stringarray_append(l_tts, r.tt1);
        std.stringarray_append(l_tts, r.tt2);
        std.stringarray_append(l_tts, r.tt3);
        std.stringarray_append(l_tts, r.tt4);
        std.stringarray_append(l_tts, r.tt5);
        std.stringarray_append(l_tts, r.tt6);
        std.stringarray_append(l_tts, r.tt7);
        std.stringarray_append(l_tts, r.tt8);
        for i in l_tts.first .. l_tts.last
        loop
          if l_tts(i) in ('265', '295', '315', '325', '345', '355', '375', '390', '440', '295-345') then
            -- если нашли класс прочности, сформируем из него L_CLASS
            if l_class is null then
              l_class := 'кл. ' || l_tts(i);
            else
              l_class := l_class || '-' || l_tts(i);
            end if;
          else
            -- иначе просто добавим тех. требование в список
            l_tt_string := l_tt_string || ' ' || l_tts(i);
          end if;
        end loop;
        -- если класс прочности заполнен, добавим его в тех. требования
        if l_class is not null then
          l_tt_string := l_tt_string || ' ' || l_class;
        end if;
        -- обрежем передний лишний пробел
        l_tt_string := LTrim(l_tt_string);
        return
          std.arguments_join(chr(10),
            l_gost,
            l_tt_string,
            r.uzk,
            r.uslp,
            l_pravila,
            r.doptr);
      end if;
    end loop;
  end;


  function report_helper_get_size_column(l_unik_p cont_pos.unik_p%type, l_index in number) return varchar2
  is
    r cont_pos%rowtype;
    l_vid_gaza nsi205.nsi20503%type;

  begin
    for r in (
      select
        s1mn, s1mx, s1delim,
        s2mn, s2mx, s2delim,
        s3mn, s3mx, s3delim,
        internal_diameter_min, internal_diameter_max,
        cp.prim,
        prod,
        vid_gaza
      from
        cont_pos cp join cont_spec cs on cp.unik_s = cs.unik_s
      where unik_p = l_unik_p)
    loop
      case l_index
        when 1 then
          /*
            Для стальных профильных труб в поле первого размера
            необходимо печатать примечание (в которое заносится
            интервал профилей)
           */
          /*if r.prod in (138800,138900) then
            return r.prim;
          els*/if r.prod = 141200 then
            if r.vid_gaza is not null then
              select lower(nsi20503) into l_vid_gaza from nsi205 where nsi20501=r.vid_gaza;
            end if;
            return l_vid_gaza;
          else
            return
              std.arguments_join(' /',
                size_combine(r.s1mn, r.s1mx, r.s1delim),
                size_combine(r.internal_diameter_min, r.internal_diameter_max, '-'));
          end if;
        when 2 then
          return size_combine(r.s2mn, r.s2mx, r.s2delim);
        when 3 then
          return size_combine(r.s3mn, r.s3mx, r.s3delim);
      end case;
    end loop;
  end;




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
      l_cabotage number default 0) return boolean is
      
    spec_r cont_spec%rowtype;
    z001_r z001%rowtype;
    z002_r z002%rowtype;
    l_module constant varchar2(50) := 'contract_pkg.cont_spec_to_z001';
    l_stop_process boolean := false;
    l_nliz z001.nliz%type;
    i pls_integer;
    l_dtt_count pls_integer;
    l_acceptance_count pls_integer;
    l_uzk_count pls_integer;
    l_mark varchar2(100);
    l_rs cont_head.rs%type;
    add_to_debug boolean := true;
    v_dop_treb number := 0;
    mark_str varchar2(200);
    mark_txt varchar2(200);  cm number;       --  20/03/2013
    n_row pls_integer;
    min_pz pls_integer;
    cont_suf cont_head.suffix%type;
    p_uzk number; --переменная для УЗК (из доптребований по спецификации)
    ras_ct number;
    toler_ves spr_tolerance.ves%type;
    toler_vid spr_tolerance.vid%type;
    kod_inc number;


    -- выборка доп. тех. требований
    l_dtt_tolerance3 constant number := 1;
    l_dtt_tolerance5 constant number := 2;
    l_dtt_acceptance constant number := 3;
    l_dtt_uzk constant number := 4;
    l_dtt_skip constant number := 5;
    l_dtt_tolerance15 constant number := 6;
    l_dtt_tolerance10_0 constant number := 7;
    l_dtt_tolerance10 constant number := 8;
    l_dtt_tolerance5_0 constant number := 9;
    l_dtt_tolerance5_2 constant number := 10;
    l_dtt_tolerance5_3 constant number := 11;
    l_dtt_tolerance2_0 constant number := 12;
    l_dtt_tolerance2 constant number := 13;
    l_dtt_tolerance0_5 constant number := 14;
    l_dtt_tolerance0_10 constant number := 15;
    
    -- различные коды доп. тех. требований
    cursor dtt_c(l_unik_s cont_spec.unik_s%type) is
      select code,
          case
            when code in (274,8889) then l_dtt_tolerance3
            when code in (1000,1067,1333,1141,8890,1428) then l_dtt_tolerance5
            when code in (1060,8892) then l_dtt_tolerance15
            when code in (1066) then l_dtt_tolerance10_0
            when code in (1064,1031,8891,6012) then l_dtt_tolerance10
            when code in (1058,1143) then l_dtt_tolerance5_0
            when code in (1080) then l_dtt_tolerance5_2
            when code in (8894) then l_dtt_tolerance5_3
            when code in (1081) then l_dtt_tolerance2_0
            when code in (8895) then l_dtt_tolerance2
            when code in (1070,1077,6026) then l_dtt_tolerance0_5
            when code in (6025) then l_dtt_tolerance0_10
            when code in (select nsi20501 from nsi205 where nsi20504 in (3,9)) then l_dtt_acceptance
            when code in (select nsi20501 from nsi205 where nsi20504 = 4) then l_dtt_uzk
            when code in (select nsi20501 from nsi205 where nsi20504 = 6) then l_dtt_skip
          end as dtt_group
        from cont_spec_dop_treb
        where unik_s = l_unik_s;
        

    procedure add_to_log(l_value in varchar2, l_fatal boolean) is
    begin
      if instr(l_log,l_value)=0 then
        l_log:= l_log||chr(10)||l_value;
      end if;
      l_stop_process := l_fatal;
    end;

  begin
  
  savepoint order_creation;
  
  if add_to_debug then
   std.debug_message('cont_spec_to_z001','00. Запуск');
  end if; 
  
    if l_unik_s is null or l_nsnz is null or l_gdis is null then
      add_to_log('Спецификация не найдена', true);
      goto RETURN_RESULTS;
    end if;
   
  -- выбрать спецификацию
    begin
      select * into spec_r from cont_spec where unik_s = l_unik_s;
    exception
      when No_Data_Found then
        add_to_log('Спецификация не найдена', true);
        goto RETURN_RESULTS;
    end;
    -- проверить, чтобы не было такого заказа в базе
    begin
/*      if opp = 1 then
        select * into z001_r from z001_opp where nsnz = l_nsnz and dpid = l_dpid and gdis = l_gdis;
      else*/
        select * into z001_r from z001 where nsnz = l_nsnz and dpid = l_dpid and gdis = l_gdis;
--      end if; 
      add_to_log('Заказ уже существует', true);
      goto RETURN_RESULTS;
    exception
      when No_Data_Found then null;
    end;
   
   if add_to_debug then
     std.debug_message('cont_spec_to_z001','01. Спецификация выбрана');
   end if;  
  
   --контракт
    begin
      select
        --number_c || '/' || suffix || '/' || lpad(mod(year, 100), 2, '0'),
        contract_pkg.get_contract_number(unik_c),
        contract_pkg.get_contract_number(unik_c),
        --decode(number_c,'12EXP/12-01','12EXP/12-01','12EXP/12-02','12EXP/12-02',number_c || '-' || lpad(mod(year, 100), 2, '0')),
        --To_Char(c_data, 'yyyymmdd'),
        to_char(date_zakl,'yyyymmdd'),
        nvl(spec_r.kdkp, spec_r.kdpl),
        nvl(spec_r.opok,n110_pok.nsi11012),
        nsi90504,
        nsi10701,
        cont_head.bank,
        cont_head.rs,
        cont_head.vid_cont,
        cont_head.unik_c,
        cont_head.suffix
      into
        l_nliz,
        z001_r.nzch,
        z001_r.dtko,
        z001_r.kpok,
        z001_r.opok,
        z001_r.txdu,
        z001_r.cnrs,
        z001_r.kdbn,
        l_rs,
        z001_r.vd01,
        z001_r.unik_c,
        cont_suf
      from cont_head
        left join nsi110 n110_pok on nsi11001 = kpok
        left join nsi905 on nsi90501 = nvl(spec_r.opok,n110_pok.nsi11012)
        left join nsi107 on nsi10707 = nvl(spec_r.opok,n110_pok.nsi11012)
      where
        unik_c = spec_r.unik_c
        and rownum = 1;
      
      
      --условия оплаты по контракту
    for s1 in (select vid_opl,kod_ras,dni_ot,is_dog_com from cont_head where unik_c = spec_r.unik_c and rownum=1) loop
      
        if s1.is_dog_com=1 then
          z001_r.vd02 := 'МИК';
        else
          z001_r.vd02 := 'ДП';
        end if;    
        
        if s1.vid_opl is not null then
          if s1.vid_opl=0 or s1.vid_opl=400 then 
             z001_r.vd03 := 'Б';
             z001_r.vd04 := null;
             z001_r.vd05 := null;
          else
            for s2 in (select type_oplata,day from spr_oplata_element where kod_spr_oplata=s1.vid_opl and n_pp=1) loop
              case s2.type_oplata
                when 0 then
                  z001_r.vd03 := 'П';
                  z001_r.vd04 := null;
                  z001_r.vd05 := null;
                else
                  z001_r.vd03 := 'ОТП';
                  z001_r.vd04 := null;
                  z001_r.vd05 := substr('O'||s2.day,-3);  
              end case;  
            end loop; 
          end if;   
        else
         select count(kod) into ras_ct from vidr where kod=s1.kod_ras and upper(naim) like '%ПРЕДОПЛАТА%';
          if ras_ct>0 then
            z001_r.vd03 := 'П';
            z001_r.vd04 := null;
            z001_r.vd05 := null;
          end if;            
          select count(kod) into ras_ct from vidr where kod=s1.kod_ras and upper(naim) like '%ОТСРОЧКА%';
          if ras_ct>0 then
            z001_r.vd03 := 'ОТП';
            z001_r.vd04 := null;
            z001_r.vd05 := substr('О'||s1.dni_ot,-3);
          end if;  
         select count(kod) into ras_ct from vidr where kod=s1.kod_ras and upper(naim) like '%БЕЗВОЗМ%';
          if ras_ct>0 then
            z001_r.vd03 := 'Б';
            z001_r.vd04 := null;
            z001_r.vd05 := null;
          end if;                                  
        end if;
      end loop;
        
      z001_r.unik_s  := l_unik_s;
     
      if Length(l_rs) <= 25 and std.is_number(l_rs) then
        z001_r.shns := To_Number(l_rs);
      else
       z001_r.shns := Substr(l_rs,1,25);  
      end if;
    exception
      when No_Data_Found then
        -- ошибка есть, но выходить повременим, чтобы выдать сразу все ошибки
        add_to_log('Шапка контракта не найдена', true);
    end;    
    
    if add_to_debug then
      std.debug_message('cont_spec_to_z001','02. Контракт выбран');
    end if;  
    
   -- ВСТАВКА ШАПКИ ЗАКАЗА
    --z001_r.punkt_dp_kvit := 0;
    z001_r.nsnz := l_nsnz;
    z001_r.nlmg := (l_nsnz - mod(l_nsnz, 1000000)) / 1000000;
    z001_r.dpid := l_dpid;
    z001_r.gdis := l_gdis;
    z001_r.kdpr := spec_r.prod;
    z001_r.stan := spec_r.shop;
    z001_r.stan_1 := spec_r.shop;
    z001_r.days_isp := spec_r.days_isp;
    z001_r.otmetki_15 := spec_r.col4;
    z001_r.sap_nsnz := spec_r.sap_nsnz;
    z001_r.okpo_sobstv := spec_r.okpo_sobstv;
    z001_r.naim_sobstv := spec_r.naim_sobstv;
    
    if z001_r.stan in (610,611,613) then
      z001_r.sost := 3;
      z001_r.zak_block := 1;
    else
      z001_r.sost := 0;
      z001_r.zak_block := 0;
    end if;
        
    z001_r.dtpd := To_Char(sysdate, 'yyyymmdd');
    z001_r.dtvd := z001_r.dtpd;
    z001_r.date_spc := spec_r.reg_date;
    z001_r.mnth := nvl(l_mnth,extract(month from spec_r.date_beg));
    z001_r.zak_perenos := 0;
    z001_r.inspector := spec_r.inspector;
    z001_r.calc_dw := 0;
    z001_r.region_marport := spec_r.region_marport;
    z001_r.is_cabotage := nvl(l_cabotage,0);
     
    case to_number(z001_r.vd01)
      when 60 then
        Begin 
          z001_r.num_spc_t := spec_r.num_oves_num;
          z001_r.num_spc := spec_r.num_oves_num;
          if z001_r.nzch in ('12EXP/12-01','12EXP/12-02') then
            z001_r.nzvs := spec_r.num_oves_txt||'2';
          else 
            z001_r.nzvs := spec_r.num_oves_txt||substr(z001_r.nzch,-1);
          end if;  
          z001_r.lot := l_lot;
          z001_r.kdpo := nvl(spec_r.port,spec_r.stanc_nazn);--порт (или станция перехода для экспортных или СНГ)
          select max(nsi11008) into z001_r.pola from nsi110 where nsi11001 = spec_r.kdpl; 
          select substr(decode(str_join(dop_markir),'',null,str_join(dop_markir)),1,40) into z001_r.mark from cont_exp_spec_lot 
            where unik_s = l_unik_s and 
            (lot is null or lot in (select lot from cont_pos where zak_pp=l_lot)) and upper(dop_markir) not like '%ПОЛОС%';
        End;  
      when 10 then
        Begin
          z001_r.nliz := l_nliz;
          z001_r.num_spc_t := spec_r.n_spc;
          z001_r.num_spc := spec_r.n_spc;
          z001_r.nzch := null;
          z001_r.kdpo := null; --nvl(spec_r.port,spec_r.stanc_nazn);--порт (или станция перехода для экспортных или СНГ)
        End;
      when 50 then
        Begin
          z001_r.nliz := l_nliz;
          z001_r.num_spc_t := spec_r.n_spc;
          z001_r.num_spc := spec_r.n_spc;
          z001_r.nzch := null;
          z001_r.kdpo := spec_r.port;
        End;  
      else
        null;  
    end case;
   
    if add_to_debug then 
      std.debug_message('cont_spec_to_z001','03. Номер спецификации');
    end if;  
      
    z001_r.nspc_mih := spec_r.n_spc_mih;
    z001_r.date_spc_mih := spec_r.reg_date_mih;
    z001_r.kdco := spec_r.kod_country;
    z001_r.punkt_dp_kvit := nvl(spec_r.punkt_dp_kvit,0);
  
    if spec_r.kod_inc is not null then
     begin
      case z001_r.vd01
        when '60' then select kod,naim into z001_r.kod_inc,z001_r.vzak from sprexp where kod_oves = spec_r.kod_inc;
        else select kod,naim into z001_r.kod_inc,z001_r.vzak from sprexp where kod = spec_r.kod_inc;
      end case;  
      exception
        when No_Data_Found then
          -- ошибка есть, но выходить повременим, чтобы выдать сразу все ошибки
          add_to_log('Код условия поставки не найден', true);
      end;
    end if;

    begin
        select kod into kod_inc from sprexp where naim=z001_r.vzak;
        z001_r.price_tip := 
        case z001_r.unik_c
           when 161238 then 3
           when 136607 then 3
           else get_price_tip_by_inc(kod_inc,z001_r.vd01)
        end;   
        exception
          when No_data_found then
             z001_r.price_tip := 0;
    end;            
    
    if add_to_debug then
      std.debug_message('cont_spec_to_z001','04. Условия поставки');
    end if;  
        
    begin
        select trim(substr(text_doptreb(code),1,100)) into z001_r.prgz from cont_spec_dop_treb where unik_s = l_unik_s and code in (select distinct nsi20501 from nsi205 where nsi20504=6) and rownum=1;
        exception
         when no_data_found 
           then z001_r.prgz := null;
     End;
           
    if spec_r.currency is not null then
      begin
        select cval,pval into z001_r.kded,z001_r.pval from sval where pval = spec_r.currency;
      exception
        when No_Data_Found then
        add_to_log('Код валюты не найден', true);
      end;
    end if;
    
    select
        count(*),
        sum(nvl(kw1, 0) + nvl(kw2, 0) + nvl(kw3, 0) + nvl(kw4, 0)),
        sum(nvl(kw1, 0)),
        sum(nvl(kw2, 0)),
        sum(nvl(kw3, 0)),
        sum(nvl(kw4, 0))
      into
        z001_r.qspz,
        z001_r.vg01,
        z001_r.vg02,
        z001_r.vg03,
        z001_r.vg04,
        z001_r.vg05
      from cont_pos
      where unik_s = spec_r.unik_s and nvl(zak_pp,0)=l_lot;
    
    if l_cabotage=1 then
      z001_r.vg01 := 0;
      z001_r.vg02 := 0;
      z001_r.vg03 := 0;
      z001_r.vg04 := 0;
      z001_r.vg05 := 0;
      z001_r.sost := 0;
      z001_r.zak_block := 0;      
    end if;        
    
    z001_r.kpot := spec_r.kpol;
    z001_r.kdrw := spec_r.kdrw;
    
    if nvl(l_cabotage,0)=1 then
      z001_r.kddr := 777777;
    else  
      z001_r.kddr := nvl(spec_r.stanc,spec_r.stanc_nazn);
    end if;  
    z001_r.kddr_p := spec_r.stanc_nazn;
    if nvl(z001_r.kddr,0)=0 or instr(UPPER(text_stanc(z001_r.kddr)),'ПОРТ')<>0 then --портовые станции
      if nvl(l_cabotage,0)=1 then
        z001_r.kddr := 777777;
      else  
        z001_r.kddr := spec_r.port;
      end if;  
    end if; 
    if spec_r.ados is not null 
      then z001_r.ados := spec_r.ados;
      else 
         if spec_r.ados_type = 1 then z001_r.ados := 'ВЕТКА'; end if;
         if spec_r.ados_type = 2 then z001_r.ados := 'ПП'; end if;
    end if;
    
    z001_r.kdpl := spec_r.kdpl;
    if spec_r.bank is not null then
      z001_r.kdbn := spec_r.bank;
    end if;
    if spec_r.rs is not null and Length(spec_r.rs) <= 25 and std.is_number(spec_r.rs) then
      z001_r.shns := To_Number(spec_r.rs);
    end if;
    z001_r.stat1 := oasu.get_prop('user_name');
    z001_r.otv := oasu.get_prop('user_unik');
    z001_r.stat2 := To_Char(sysdate, 'yyyymmdd');
    z001_r.stat3 := To_Char(sysdate, 'hh24mi');
    z001_r.zak_fin := 0;
    z001_r.zak_start := 0;
    if l_stop_process then
      goto RETURN_RESULTS;
    end if;
    
   insert into z001 values z001_r;
         
   if add_to_debug then   
     std.debug_message('cont_spec_to_z001', '05. Шапка заказа создана');
   end if;  
   
    
    -- ПОЗИЦИИ
    -- поля, общие для всех позиций
    z002_r.nsnz := z001_r.nsnz;
    z002_r.dpid := z001_r.dpid;
    z002_r.gdis := z001_r.gdis;
    z002_r.kdpr := z001_r.kdpr;
    z002_r.nlmg := z001_r.nlmg;
    z002_r.sost := z001_r.sost;
    z002_r.stan := z001_r.stan;
    z002_r.stat1 := z001_r.stat1;
    z002_r.otv := z001_r.otv;
    z002_r.stat2 := z001_r.stat2;
    z002_r.stat3 := z001_r.stat3;
    z002_r.upmn := spec_r.uslp;
                    
    if nvl(spec_r.toler_type,0)<>0 then
      z002_r.nktt04 := -nvl(spec_r.toler_min,0);
      z002_r.nktt05 := nvl(spec_r.toler_max,0);
    end if; 
    
    
   
   if add_to_debug then  
     std.debug_message('cont_spec_to_z001', '06. Общие поля по позициям');
   end if;  
    
    -- получим доп. тех. требования
    i := 1;
    l_dtt_count := 0;
    l_acceptance_count := 0;
    l_uzk_count := 0;
    for r in dtt_c(spec_r.unik_s)
    loop
      case r.dtt_group
        when l_dtt_tolerance3 then
          z002_r.nktt04 := -3;
          z002_r.nktt05 := 3;
        when l_dtt_tolerance5 then
          z002_r.nktt04 := -5;
          z002_r.nktt05 := 5;
        when l_dtt_tolerance15 then
          z002_r.nktt04 := -15;
          z002_r.nktt05 := 15;
        when l_dtt_tolerance10_0 then
          z002_r.nktt04 := -10;
          z002_r.nktt05 := 0;
        when l_dtt_tolerance10 then
          z002_r.nktt04 := -10;
          z002_r.nktt05 := 10;
        when l_dtt_tolerance5_0 then
          z002_r.nktt04 := -5;
          z002_r.nktt05 := 0;
        when l_dtt_tolerance5_2 then
          z002_r.nktt04 := -5;
          z002_r.nktt05 := 2;
        when l_dtt_tolerance5_3 then
          z002_r.nktt04 := -5;
          z002_r.nktt05 := 3;
        when l_dtt_tolerance2_0 then
          z002_r.nktt04 := -2;
          z002_r.nktt05 := 0;
        when l_dtt_tolerance2 then
          z002_r.nktt04 := -2;
          z002_r.nktt05 := 2;
        when l_dtt_tolerance0_5 then
          z002_r.nktt04 := 0;
          z002_r.nktt05 := 5;
        when l_dtt_tolerance0_10 then
          z002_r.nktt04 := 0;
          z002_r.nktt05 := 10;  
             
      
      if add_to_debug then       
        std.debug_message('cont_spec_to_z001', '07. Толеранс');
      end if;  
                          
        when l_dtt_acceptance then
          case l_acceptance_count
            when 0 then z002_r.nktt01 := r.code;
            when 1 then z002_r.nktt02 := r.code;
            when 2 then z002_r.nktt03 := r.code;
            else
              add_to_log('Слишком много приемок', not l_force);
          end case;
          l_acceptance_count := l_acceptance_count + 1;
          
      if add_to_debug then      
        std.debug_message('cont_spec_to_z001', '08. Приемка');
      end if;  
          
        when l_dtt_uzk then
          case l_uzk_count
            when 0 then p_uzk := r.code;
            else
              add_to_log('Слишком много УЗК', not l_force);
          end case;
          l_uzk_count := l_uzk_count + 1;
          
       if add_to_debug then  
         std.debug_message('cont_spec_to_z001', '09. УЗК');
       end if;     
          
        when l_dtt_skip then z002_r.nktt06:=r.code;
        
        else
            case l_dtt_count
                when 0 then z002_r.ktd01 := r.code;
                when 1 then z002_r.ktd02 := r.code;
                when 2 then z002_r.ktd02 := r.code;
                when 3 then z002_r.ktd02 := r.code;
                when 4 then z002_r.ktd02 := r.code;
                else
                  add_to_log('Слишком много дополнительных технических требований', not l_force);
              end case;
              l_dtt_count := l_dtt_count + 1;    
      end case;
    end loop;

    if add_to_debug then  
      std.debug_message('cont_spec_to_z001', '09_1. Начало попозиционки.');
    end if;  
               
    n_row := 0; /*Счетчик для позиций  экспортных контрактов*/
    
    for pos_r in (select * from cont_pos where unik_s = spec_r.unik_s and nvl(zak_pp,0)=l_lot order by nvl(lot,0),nvl(s1mn,0),nvl(s2mn,0),nvl(s3mn,0),npoz)
    loop
      z002_r.unik_p := pos_r.unik_p;
      z002_r.nomn := pos_r.nomn;
      z002_r.snp := pos_r.snp;
      z002_r.kod_uktved := pos_r.kod_uktved;
      z002_r.kod_gkpu := pos_r.kod_gkpu;
      z002_r.vid_razl := pos_r.vid_razl;
    if add_to_debug then  
      std.debug_message('cont_spec_to_z001', '09_2. Коды.');
    end if;       
      z002_r.tlmn := pos_r.s1mn;
      z002_r.tlmx := pos_r.s1mx;
      z002_r.tlrz := case when pos_r.s1mn = pos_r.s1mx then null else '-' end;
      z002_r.shmn := pos_r.s2mn;
      z002_r.shmx := pos_r.s2mx;
      z002_r.shrz := case when pos_r.s2mn = pos_r.s2mx then null else '-' end;
      z002_r.dlmn := pos_r.s3mn;
      z002_r.dlmx := pos_r.s3mx;
      z002_r.dlrz := case when pos_r.s3mn = pos_r.s3mx then null else '-' end;
    if add_to_debug then  
      std.debug_message('cont_spec_to_z001', '09_3. Размеры.');
    end if;      
      z002_r.cena := pos_r.price;
      z002_r.plates := pos_r.plates;
      z002_r.mark1 := pos_r.mark1;
      z002_r.mark2 := pos_r.mark2;
      z002_r.mark3 := pos_r.mark3;
      z002_r.mark4 := pos_r.mark4;
    if add_to_debug then  
      std.debug_message('cont_spec_to_z001', '09_4. Марки.');
    end if;      
      z002_r.gost1 := pos_r.gost1;
      z002_r.gost1_1 := pos_r.gost1_1;
      z002_r.gost1_2 := pos_r.gost1_2;
      z002_r.gost2 := pos_r.gost2;
      z002_r.gost3 := pos_r.gost3;
      z002_r.gost4 := pos_r.gost4;
    if add_to_debug then  
      std.debug_message('cont_spec_to_z001', '09_5. Госты.');
    end if;        
     -- std.debug_message('cont_spec_to_z001', pos_r.uzk);
      if pos_r.uzk is not null then
        z002_r.ktd03 := pos_r.uzk;
      else
        z002_r.ktd03 := p_uzk;
      end if;     
     -- std.debug_message('cont_spec_to_z001', z002_r.ktd03);
     
    --Доп требования (лот для цеха) и маркировка    
     if to_number(z001_r.vd01) = 60 then
       n_row := n_row + 1;
       z002_r.npoz := n_row;
       case pos_r.lot
         when 1 then z002_r.ktd01 := 360;
         when 2 then z002_r.ktd01 := 357;
         when 3 then z002_r.ktd01 := 358;
         when 4 then z002_r.ktd01 := 353;
         when 5 then z002_r.ktd01 := 354;
         when 6 then z002_r.ktd01 := 361;
         when 7 then z002_r.ktd01 := 362;
         when 8 then z002_r.ktd01 := 359;
         when 9 then z002_r.ktd01 := 363;
         when 10 then z002_r.ktd01 := 364;
         when 11 then z002_r.ktd01 := 372;
         when 12 then z002_r.ktd01 := 373;
         when 13 then z002_r.ktd01 := 380;
         when 14 then z002_r.ktd01 := 381;
         when 15 then z002_r.ktd01 := 382;
         when 16 then z002_r.ktd01 := 383;
         when 17 then z002_r.ktd01 := 384;
         when 18 then z002_r.ktd01 := 385;
         when 19 then z002_r.ktd01 := 386;
         when 20 then z002_r.ktd01 := 387;
         when 21 then z002_r.ktd01 := 388;
         when 22 then z002_r.ktd01 := 332;
         when 23 then z002_r.ktd01 := 390;
         else null; 
       end case; 
       select decode(max(markir),0,null,max(markir)) into z002_r.ktd02 from cont_exp_spec_lot where unik_s = pos_r.unik_s and (nvl(lot,0) = nvl(pos_r.lot,0) or lot is null);
     elsif (to_number(z001_r.vd01) = 50) and (cont_suf<>126) then
        select min(npoz) into min_pz from cont_pos where unik_s = spec_r.unik_s and nvl(zak_pp,0) = l_lot;
        z002_r.npoz := pos_r.npoz - min_pz + 1;
     else
        z002_r.npoz := pos_r.npoz;    
     end if;
     
     z002_r.sap_npoz := pos_r.sap_npoz;
         
      z002_r.vg01 := nvl(pos_r.kw1, 0) + nvl(pos_r.kw2, 0) + nvl(pos_r.kw3, 0) + nvl(pos_r.kw4, 0);
      z002_r.vg02 := pos_r.kw1;
      z002_r.vg03 := pos_r.kw2;
      z002_r.vg04 := pos_r.kw3;
      z002_r.vg05 := pos_r.kw4;
      
      if l_cabotage=1 then
        z002_r.vg01 := 0;
        z002_r.vg02 := 0;
        z002_r.vg03 := 0;
        z002_r.vg04 := 0;
        z002_r.vg05 := 0;
      end if; 
      
      z002_r.lot := pos_r.lot;
      z002_r.prgz := pos_r.prim;
     
     ------------- толеранс по весу или ширине -------------
     toler_ves := 0;
     
     if (nvl(spec_r.toler_type,0)=0) and ((nvl(spec_r.toler_type_ves,0)<>0) or (nvl(spec_r.toler_type_sh,0)<>0)) then
     
       select ves,vid into toler_ves,toler_vid from spr_tolerance where unik=nvl(spec_r.toler_type_ves,spec_r.toler_type_sh);
       
       if toler_vid=2 then 
         if nvl(z002_r.vg01,0)>0 and nvl(z002_r.vg01,0)<=toler_ves then
          z002_r.nktt04 := -nvl(spec_r.toler_min_ves,0);
          z002_r.nktt05 := nvl(spec_r.toler_max_ves,0);
         end if;
       elsif toler_vid=3 then
         if nvl(z002_r.shmn,0)>0 and nvl(z002_r.shmn,0)=toler_ves then
          z002_r.nktt04 := -nvl(spec_r.toler_min_sh,0);
          z002_r.nktt05 := nvl(spec_r.toler_max_sh,0);
         end if;           
       else
        z002_r.nktt04 := -nvl(spec_r.toler_min,0);
        z002_r.nktt05 := nvl(spec_r.toler_max,0);   
       end if;
     end if;   
   
     ------------- изменения 20/03/2013 ---------------------------------------------------
     for s in (select *
                 from cont_pos_mark cpm
                 where cpm.unik_p=pos_r.unik_p
                 )
     loop
                delete from z002_pos_mark where nsnz=z002_r.nsnz and dpid=z002_r.dpid and gdis=z002_r.gdis and npoz=z002_r.npoz;
                insert into z002_pos_mark(nsnz, dpid, gdis, npoz,npp, mark, gost1, gost2, gost3, gost4,dop_marka) values  (z002_r.nsnz, z002_r.dpid, z002_r.gdis, z002_r.npoz,s.npp, s.mark, s.gost1, s.gost2, s.gost3, s.gost4, s.dop_marka);              
     end loop;      


      -- получим ГОСТы
      if pos_r.gost1 is not null then
        select nsi20201, nsi20204, nsi20205, nsi20206, nsi20207
          into z002_r.gst1, z002_r.pr11, z002_r.pr12, z002_r.pr13, z002_r.pr14
          from nsi202
          where nsi20203 = pos_r.gost1;
      else    
        z002_r.gst1 := null; 
        z002_r.pr11 := null; 
        z002_r.pr12 := null; 
        z002_r.pr13 := null; 
        z002_r.pr14 := null;
      end if;
      if pos_r.gost1_1 is not null then
        select nsi20201, nsi20204, nsi20205, nsi20206, nsi20207
          into z002_r.gst1_1, z002_r.pr11_1, z002_r.pr12_1, z002_r.pr13_1, z002_r.pr14_1
          from nsi202
          where nsi20203 = pos_r.gost1_1;
      else    
        z002_r.gst1_1 := null; 
        z002_r.pr11_1 := null; 
        z002_r.pr12_1 := null; 
        z002_r.pr13_1 := null; 
        z002_r.pr14_1 := null;
      end if;
      if pos_r.gost1_2 is not null then
        select nsi20201, nsi20204, nsi20205, nsi20206, nsi20207
          into z002_r.gst1_2, z002_r.pr11_2, z002_r.pr12_2, z002_r.pr13_2, z002_r.pr14_2
          from nsi202
          where nsi20203 = pos_r.gost1_2;
      else    
        z002_r.gst1_2 := null; 
        z002_r.pr11_2 := null; 
        z002_r.pr12_2 := null; 
        z002_r.pr13_2 := null; 
        z002_r.pr14_2 := null;          
      end if;
      if pos_r.gost2 is not null then
        select nsi20201, nsi20204, nsi20205, nsi20206, nsi20207
          into z002_r.gst2, z002_r.pr21, z002_r.pr22, z002_r.pr23, z002_r.pr24
          from nsi202
          where nsi20203 = pos_r.gost2;
      else    
        z002_r.gst2 := null; 
        z002_r.pr21 := null; 
        z002_r.pr22 := null; 
        z002_r.pr23 := null; 
        z002_r.pr24 := null;
      end if;
      if pos_r.gost3 is not null then
        select nsi20201, nsi20204, nsi20205, nsi20206, nsi20207
          into z002_r.gst3, z002_r.pr31, z002_r.pr32, z002_r.pr33, z002_r.pr34
          from nsi202
          where nsi20203 = pos_r.gost3;
      else    
        z002_r.gst3 := null; 
        z002_r.pr31 := null; 
        z002_r.pr32 := null; 
        z002_r.pr33 := null; 
        z002_r.pr34 := null;          
      end if;
      if pos_r.gost4 is not null then
        select nsi20201, nsi20204, nsi20205, nsi20206, nsi20207
          into z002_r.gst4, z002_r.pr41, z002_r.pr42, z002_r.pr43, z002_r.pr44
          from nsi202
          where nsi20203 = pos_r.gost4;
      else    
        z002_r.gst4 := null; 
        z002_r.pr41 := null; 
        z002_r.pr42 := null; 
        z002_r.pr43 := null; 
        z002_r.pr44 := null;          
      end if;
      
      if add_to_debug then  
        std.debug_message('cont_spec_to_z001', '10. ГОСТЫ');
      end if;  
    
 
     ----------------------- в цикле госты из cont_pos_mark
        for gost_cpm in (select *
                                 from cont_pos_mark cpm
                                 where cpm.unik_p=pos_r.unik_p
                                           and npp=1
                                 )
         loop
                  if gost_cpm.gost1 is not null then      -- Гост1
                      select nsi20201, nsi20204, nsi20205, nsi20206, nsi20207
                      into z002_r.gst1, z002_r.pr11, z002_r.pr12, z002_r.pr13, z002_r.pr14
                      from nsi202
                      where nsi20203 = gost_cpm.gost1;
                  end if;
                  if gost_cpm.gost2 is not null then           -- Гост2
                    select nsi20201, nsi20204, nsi20205, nsi20206, nsi20207
                      into z002_r.gst2, z002_r.pr21, z002_r.pr22, z002_r.pr23, z002_r.pr24
                      from nsi202
                      where nsi20203 = gost_cpm.gost2;
                  end if;
                  if gost_cpm.gost3 is not null then           -- Гост3
                    select nsi20201, nsi20204, nsi20205, nsi20206, nsi20207
                      into z002_r.gst3, z002_r.pr31, z002_r.pr32, z002_r.pr33, z002_r.pr34
                      from nsi202
                      where nsi20203 = gost_cpm.gost3;
                  end if;
                  if gost_cpm.gost4 is not null then           -- Гост4
                    select nsi20201, nsi20204, nsi20205, nsi20206, nsi20207
                      into z002_r.gst4, z002_r.pr41, z002_r.pr42, z002_r.pr43, z002_r.pr44
                      from nsi202
                      where nsi20203 =gost_cpm.gost4;
                  end if;
         end loop;
         
      if add_to_debug then  
        std.debug_message('cont_spec_to_z001', '10-1. ГОСТЫ из CONT_POS_MARK');
      end if;
------------------------------------------------------------- 20/03/2013 --------------------*/ 

     -- доставим марки
      select std.arguments_join(',', nsi2081.nsi20801, nsi2082.nsi20801, nsi2083.nsi20801, nsi2084.nsi20801) into mark_str 
      from dual left join nsi208 nsi2081 on nsi2081.nsi20815 = pos_r.mark1
                     left join nsi208 nsi2082 on nsi2082.nsi20815 = pos_r.mark2
                     left join nsi208 nsi2083 on nsi2083.nsi20815 = pos_r.mark3
                     left join nsi208 nsi2084 on nsi2084.nsi20815 = pos_r.mark4;
      if length(mark_str) > 30 then
        select std.arguments_join(',', nsi2081.nsi20801, nsi2082.nsi20801, nsi2083.nsi20801) into mark_str 
        from dual left join nsi208 nsi2081 on nsi2081.nsi20815 = pos_r.mark1
                       left join nsi208 nsi2082 on nsi2082.nsi20815 = pos_r.mark2
                       left join nsi208 nsi2083 on nsi2083.nsi20815 = pos_r.mark3;
      end if;               
      if length(mark_str) > 30 then
        select std.arguments_join(',', nsi2081.nsi20801, nsi2082.nsi20801) into mark_str 
        from dual left join nsi208 nsi2081 on nsi2081.nsi20815 = pos_r.mark1
                       left join nsi208 nsi2082 on nsi2082.nsi20815 = pos_r.mark2;
      end if;               
      if length(mark_str) >= 30 then
        select nsi20801 into mark_str  from nsi208 where nsi20815 = pos_r.mark1;
      end if;                     
      mark_txt := trim(pos_r.mark_txt);
      
    if add_to_debug then       
      std.debug_message('cont_spec_to_z001', '11. Марки');
    end if;       

----------------------------- в цикле марки 20/03/2013 -----------------------------------/*
               -- основные марки
                -- mark_str:='';
                for i in (select npp                                   -- по уменьшению №п/п
                            from cont_pos_mark cpm
                            where cpm.unik_p=pos_r.unik_p
                            order by npp desc
                           )
                loop
                       select sql_to_str('text_marka(mark)','cont_pos_mark','unik_p=' ||pos_r.unik_p||' and dop_marka=0 and npp<='||i.npp,',',1,'npp') 
                       into  mark_str from dual;
                       exit when length(mark_str)<=30;   
                end loop;
               
               -- дополнительные марки 
                -- mark_txt:='';
                for j in (select npp                                  
                            from cont_pos_mark cpm
                            where cpm.unik_p=pos_r.unik_p
                            order by npp desc
                           )
                loop
                       select sql_to_str('text_marka(mark)','cont_pos_mark','unik_p=' ||pos_r.unik_p||' and dop_marka=1 and npp<='||j.npp,',',1,'npp') 
                       into   mark_txt from dual;
                       exit when length(mark_txt)<=60;   
                end loop;
                
    if add_to_debug then       
      std.debug_message('cont_spec_to_z001', '11-1. Марки из CONT_POS_MARK');
    end if;       
------------------------------------------------------------- 20/03/2013 --------------------*/ 
   
      z002_r.mark := trim(mark_str);
      z002_r.mark_txt := trim(mark_txt);

      -- тех. требования
      z002_r.tt01 := pos_r.tt1;
      z002_r.tt02 := pos_r.tt2;
      z002_r.tt03 := pos_r.tt3;
      z002_r.tt04 := pos_r.tt4;
      z002_r.tt05 := pos_r.tt5;
      z002_r.tt06 := pos_r.tt6;
      z002_r.tt07 := pos_r.tt7;
      z002_r.tt08 := pos_r.tt8;
    
    if add_to_debug then       
      std.debug_message('cont_spec_to_z001', '12. ТТ');
    end if;   
    
    -- доп требования для экспорта
    if pos_r.dop_treb is not null then 
      select nsi20504 into v_dop_treb from nsi205 where nsi20501 = pos_r.dop_treb;
      if v_dop_treb in (3,9) then
        z002_r.nktt01 := pos_r.dop_treb;
      else
        z002_r.ktd05 := pos_r.dop_treb;  
      end if;
    End if;  
               
      -- вычислим агрегат
      begin
        select
            max(nsi98304)
          into
            z002_r.agrt
        from
          nsi983
        where
          -- условие по стану
          nsi98303 = z001_r.stan
          -- условие по продукции
          and (
            nvl(nsi98309, 0) = 0 or
            nsi98309 = z001_r.kdpr or
            nsi98310 = z001_r.kdpr or
            nsi98311 = z001_r.kdpr
          )
          -- условие по ширине
          and (
            (nvl(nsi98307, 0) = 0 and nvl(nsi98308, 0) = 0) or
            (nsi98307 <= nvl(z002_r.shmn, 0) and nsi98308 >= nvl(z002_r.shmx, 0))
          )
          -- условие по условию поставки
          and (
            nvl(z002_r.upmn, 0) <> 70
              and (nvl(nsi98305, 0) = 0 or nvl(nsi98305,0) = nvl(z002_r.upmn, 0))
              or nvl(nsi98312, 0) = 0
          )
          -- условие по экспортному/неэкспортному заказу
          and (
            z001_r.vd01 = 60
              and (nvl(nsi98306, 0) = 0 and nvl(nsi98313, 0) = 0 or nsi98306 = 1)
              or nvl(nsi98306, 0) = 0
          )
          -- отсеять пустоту
          and nsi98304 is not null
          order by nsi98304;
      
          
               
      exception
        when No_Data_Found then
          add_to_log('Агрегат не найден', false);
      end;
      
      if add_to_debug then  
        std.debug_message('cont_spec_to_z001', '13. Агрегат');
      end if;  
      
      z002_r.wag_quota := 65;
      
         
      if pos_r.vid_gaza is not null then
        z002_r.ktd01 := pos_r.vid_gaza;
      end if;
    
    --признак отсортировки (1) или выборочных характеристик (2)  
     if spec_r.prizn_otsort = 1 then
       z002_r.ktd01 := 213;
     elsif spec_r.prizn_otsort = 2 then
       z002_r.ktd01 := 420;
     end if;      
      
     if add_to_debug then
       std.debug_message('cont_spec_to_z001', '14. Вид газа');
     end if;  

      if l_stop_process then
        goto RETURN_RESULTS;
      end if;
      
      if add_to_debug then
        std.debug_message('cont_spec_to_z001', '15. Перед вставкой позиций');
      end if;   
      
      insert into z002 values z002_r;              
     
     if add_to_debug then  
       std.debug_message('cont_spec_to_z001', '16. Вставка позиций');
     end if;   
      
    end loop;
    
     if add_to_debug then  
       std.debug_message('cont_spec_to_z001', '17. Позиции вставлены');
     end if;     
    
   <<RETURN_RESULTS>>
    begin
      if l_stop_process then
        rollback to savepoint order_creation;
        if add_to_debug then  
           std.debug_message('cont_spec_to_z001', '18. l_stop_process');
        end if; 
      else
        insert into cont_spec_to_z001 (id, unik_s, nsnz, gdis,dpid,date_ins) values (cont_spec_to_z001_seq.nextval, l_unik_s, l_nsnz, l_gdis,l_dpid,sysdate);
      end if;
    end;
    return not l_stop_process;
  exception
    when others then
      std.debug_message(l_module, 'Exception was raised:' || chr(10) || chr(10)
        || 'ORA-' || SQLCODE || ': ' || DBMS_UTILITY.FORMAT_ERROR_STACK
        || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      rollback to savepoint order_creation;
      return false;
  end;
  
  function cont_pos_to_z002(
      l_unik_p cont_pos.unik_p%type,
      l_nsnz z001.nsnz%type,
      l_dpid z001.dpid%type,
      l_gdis z001.gdis%type
      ) return boolean is
  begin
    return true;
  end;     

  function helper_z001_to_cont_spec(
      l_nsnz z001.nsnz%type,
      l_dpid z001.dpid%type,
      l_gdis z001.gdis%type,
      l_log out varchar2) return number is
    l_module constant varchar2(50) := 'contract_pkg.z001_to_cont_spec';
    l_fail boolean := false;
    i pls_integer;
    k pls_integer;

    z001_r z001%rowtype;
    l_unik_s cont_spec.unik_s%type;
    l_unik_s2 cont_spec.unik_s%type;
    l_unik_p cont_pos.unik_p%type;
    spec_r cont_spec%rowtype;
    pos_r cont_pos%rowtype;
    l_marks std.stringarray_t;
    l_mark_id nsi208.nsi20815%type;

    cursor pos_c(l_unik_s in cont_pos.unik_s%type) is
      select *
        into pos_r
        from cont_pos
        where unik_s = l_unik_s
        order by npoz;

    cursor mark_id_c(l_title in nsi208.nsi20801%type) is
      select nsi20815 from nsi208 where nsi20801 = l_title;

    procedure add_to_log(l_value in varchar2, l_fatal boolean) is
    begin
      if instr(l_log,l_value)=0 then
        l_log:= l_log||chr(10)||l_value;
      end if;

    end;


  begin
    savepoint spec_creation;
    -- выберем заказ
    begin
      select *
        into z001_r
        from z001
        where nsnz = l_nsnz and dpid = l_dpid and gdis = l_gdis;
    exception
      when No_Data_Found then
        add_to_log('Заказ не найден ', true);
        goto RETURN_RESULTS;
    end;
    -- выберем UNIK_S исходной спецификации (версия = 1), соответствующей этому заказу
    begin
      select unik_s
        into l_unik_s
        from cont_spec_to_z001
        where nsnz = l_nsnz
          and gdis = l_gdis
          and dpid = l_dpid;
    exception
      when No_Data_Found then
        add_to_log('Нет соответствующей спецификации', true);
        goto RETURN_RESULTS;
    end;
    -- выберем шапку и заготовку позиции спецификации по UNIK_S
    begin
      select *
        into spec_r
        from cont_spec
        where unik_s = l_unik_s;
       open pos_c(spec_r.unik_s);
       fetch pos_c into pos_r;
       if sql%notfound then
         raise No_Data_Found;
       end if;
       close pos_c;
    exception
      when No_Data_Found then
        add_to_log('Спецификация не найдена', true);
        goto RETURN_RESULTS;
    end;
    -- внесем исправления из заказа
    spec_r.spec_version := l_dpid + 2;
    spec_r.kpol := z001_r.kpot;
    spec_r.stanc := z001_r.kddr;
    spec_r.kdpo := z001_r.kdpo;
    spec_r.kdrw := z001_r.kdrw;
    spec_r.ados := z001_r.ados;
    begin
      select unik_s
        into l_unik_s2
        from cont_spec
        where unik_c = spec_r.unik_c
          and n_spc = spec_r.n_spc
          and spec_version = spec_r.spec_version;
      spec_r.unik_s := l_unik_s2;
      update cont_spec
        set row = spec_r
        where unik_s = spec_r.unik_s;
    exception
      when No_Data_Found then
        select cont_spec_seq.nextval into spec_r.unik_s from dual;
        insert into cont_spec values spec_r;
        insert into cont_spec_dop_treb(unik, unik_s, code)
          select cont_helper_seq.nextval, spec_r.unik_s, code
          from cont_spec_dop_treb
          where unik_s = l_unik_s;
    end;
    -- теперь позиции
    pos_r.unik_s := spec_r.unik_s;
    for z002_r in (
      select *
        from z002
        where nsnz = l_nsnz
          and gdis = l_gdis
          and dpid = l_dpid
        order by npoz)
    loop
      pos_r.npoz := z002_r.npoz - z002_r.dpid * 100;
      pos_r.kw1 := z002_r.vg02;
      pos_r.kw2 := z002_r.vg03;
      pos_r.kw3 := z002_r.vg04;
      pos_r.kw4 := z002_r.vg05;
      pos_r.s1mn := z002_r.tlmn;
      pos_r.s1mx := z002_r.tlmx;
      pos_r.s2mn := z002_r.shmn;
      pos_r.s2mx := z002_r.shmx;
      pos_r.s3mn := z002_r.dlmn;
      pos_r.s3mx := z002_r.dlmx;
      pos_r.price := z002_r.cena;
      -- обработать марки
      pos_r.mark1 := null;
      pos_r.mark2 := null;
      pos_r.mark3 := null;
      pos_r.mark4 := null;
      l_marks := std.string_split(z002_r.mark, ',');
      k := 1;
      if l_marks.count > 0 then
        for i in l_marks.first .. l_marks.last
        loop
          if l_marks(i) is not null then
            begin
              open mark_id_c(l_marks(i));
              fetch mark_id_c into l_mark_id;
              if sql%notfound then
                add_to_log('Марка не найдена', true);
                goto RETURN_RESULTS;
              end if;
              close mark_id_c;
            end;
            case k
              when 1 then pos_r.mark1 := l_mark_id;
              when 2 then pos_r.mark2 := l_mark_id;
              when 3 then pos_r.mark3 := l_mark_id;
              when 4 then pos_r.mark4 := l_mark_id;
            end case;
            k := k + 1;
          end if;
        end loop;
      end if;
      begin
        select unik_p
          into l_unik_p
          from cont_pos
          where
            unik_s = spec_r.unik_s
            and npoz = pos_r.npoz;
        pos_r.unik_p := l_unik_p;
        update cont_pos
          set row = pos_r
          where unik_p = pos_r.unik_p;
      exception
        when No_Data_Found then
          select cont_pos_seq.nextval into pos_r.unik_p from dual;
          insert into cont_pos values pos_r;
      end;
    end loop;
    <<RETURN_RESULTS>>
    begin
      if l_fail then
        rollback to savepoint spec_creation;
        return null;
      else
        commit;
        return spec_r.unik_s;
      end if;
    end;
  exception
    when others then
      std.debug_message(l_module, 'Exception was raised:' || chr(10) || chr(10)
        || 'ORA-' || SQLCODE || ': ' || DBMS_UTILITY.FORMAT_ERROR_STACK
        || chr(10) || 'Backtrace:' || chr(10) || chr(10) || DBMS_UTILITY.format_error_backtrace
        );
      rollback to savepoint spec_creation;
      add_to_log('Неизвестная ошибка', true);
      return null;
  end;

  function z001_to_cont_spec(
      l_nsnz z001.nsnz%type,
      l_gdis z001.gdis%type,
      l_log out varchar2) return boolean is
    l_retval number;
  begin
    for r in (select dpid from z001 where nsnz = l_nsnz and gdis = l_gdis)
    loop
      l_retval := helper_z001_to_cont_spec(l_nsnz, r.dpid, l_gdis, l_log);
      if l_retval is null then
        return false;
      end if;
    end loop;
    return true;
  end;

  function copy_spec(
     l_unik_s cont_spec.unik_s%type,
     l_unik_c cont_head.unik_c%type,
     l_n_spc cont_spec.n_spc%type,
     l_copy_pos_full integer default 0,
     l_copy_razm integer default 0) return cont_spec.unik_s%type is
   l_spec_r cont_spec%rowtype;
   l_cont_r cont_head%rowtype;
   l_old_p cont_pos.unik_p%type;
   l_vid_cont cont_head.vid_cont%type;
   pr_act number;
   l_module constant varchar2(50) := 'contract_pkg.copy_spec';
   add_to_debug boolean := true;
 begin
   -- проверим, чтобы исходная спецификация существовала
   begin
     select * into l_spec_r from cont_spec where unik_s = l_unik_s;
   exception
     when No_Data_Found then
       return null;
   end;
   if add_to_debug then
    std.debug_message('copy_spec','1. Найдена спецификация');
   end if; 
   -- проверим, чтобы конечный контракт существовал
   begin
     select * into l_cont_r from cont_head where unik_c = l_unik_c;
   exception
     when No_Data_Found then
       return null;
   end;
   if add_to_debug then
    std.debug_message('copy_spec','2. Найден контракт');
   end if;    
   l_spec_r.unik_c := l_unik_c;
   -- определим номер спецификации и версию
   l_spec_r.spec_version := 1;
   l_spec_r.n_spc := l_n_spc;
   if l_spec_r.n_spc is not null then
     select Nvl(max(spec_version), 0) + 1
       into l_spec_r.spec_version
       from cont_spec
       where unik_c = l_unik_c and n_spc = l_n_spc;
       if add_to_debug then
         std.debug_message('copy_spec','3. Увеличена версия');
       end if;
   else
     select Nvl(max(n_spc), 0) + 1 into l_spec_r.n_spc from
       (select n_spc from cont_spec  where unik_c = l_unik_c
          union all
        select nvl(to_number(n_spc),0) from specif_all where is_number(n_spc)=1 and unik_d = l_unik_c);  
       if add_to_debug then
         std.debug_message('copy_spec','4. Принят новый номер');
       end if; 
     -- временное
     -- уточнить номер новой спецификации с учетом старой базы контрактов
     declare
       l_suffix cont_head.suffix%type;
       l_number_c cont_head.number_c%type;
       l_year cont_head.year%type;
       l_cont_type cont_type.name%type;
       n number;
     begin
       select suffix, number_c, year,vid_cont, name
         into l_suffix, l_number_c, l_year, l_vid_cont, l_cont_type
         from cont_head, cont_type
         where type = id and unik_c = l_unik_c;
       select nvl(max(specnum), 0) + 1 into n from pr_specif
         where
           decode(lower(l_cont_type), 'контракт', nomer || '', product) = l_number_c
           and suffix = l_suffix
           and god = l_year;
         if l_spec_r.n_spc < n then
           l_spec_r.n_spc := n;
           if add_to_debug then
             std.debug_message('copy_spec','5. Присвоен новый номер');
           end if; 
         end if;
     end;
     -- конец временного
   end if;
   select cont_spec_seq.nextval into l_spec_r.unik_s from dual;
   select pr_actual into pr_act from nsi201 where nsi20101 = l_spec_r.prod;
   if pr_act=0 then
     l_spec_r.prod := null;
   end if;
   
   l_spec_r.status := 1;
   l_spec_r.status_usl := 0;
   l_spec_r.otv := nvl(oasu.get_prop('user_unik'), 218);
   l_spec_r.stat2 := sysdate;
   l_spec_r.kdpl := l_cont_r.kpok;
   l_spec_r.bank := l_cont_r.bank;
   l_spec_r.date_beg := sysdate;
   l_spec_r.reg_date := sysdate;
   l_spec_r.date_dejs := null;
   l_spec_r.external_number := null;
   l_spec_r.port_confirm := 0;
   l_spec_r.date_port_confirm := null;
   
   case l_spec_r.shop
     when 610 then l_spec_r.days_isp := 33;
     when 611 then l_spec_r.days_isp := 45;
     when 613 then l_spec_r.days_isp := 33;            
     else l_spec_r.days_isp := null;
   end case;        
   
   if add_to_debug then
    std.debug_message('copy_spec','6. Установлено дней исполнения '||to_char(nvl(l_spec_r.days_isp,0)));
   end if;    
   
   if l_cont_r.suffix<>126 then
     l_spec_r.rs := l_cont_r.rs;
     l_spec_r.kdkp := null;
     l_spec_r.num_oves_num := null;
     l_spec_r.num_oves_txt := null;
   end if;  
   
   -- вставка шапки спецификации
   insert into cont_spec values l_spec_r;
   if add_to_debug then
    std.debug_message('copy_spec','7. Вставлена шапка спецификации');
   end if; 
   --  доп. тех. требования
   insert into cont_spec_dop_treb(unik, unik_s, code)
     select cont_helper_seq.nextval, l_spec_r.unik_s, code
       from cont_spec_dop_treb
       where unik_s = l_unik_s;
   if add_to_debug then
    std.debug_message('copy_spec','8. Вставлены доптребования');
   end if;   
   
   -- позиции
   -- для признака l_copy_spec_full=1 только первая позиция (с минимальным номером)
   for pos_r in (select * from cont_pos where unik_s = l_unik_s and ((l_copy_pos_full=0) or (l_copy_pos_full=1 and npoz=(select min(npoz) from cont_pos where unik_s = l_unik_s))))
   loop
     if add_to_debug then
       std.debug_message('copy_spec','9. Вставлена позиция '||pos_r.npoz);
     end if; 
     l_old_p := pos_r.unik_p;
     select cont_pos_seq.nextval into pos_r.unik_p from dual;
     pos_r.unik_s := l_spec_r.unik_s;
     pos_r.snp := 0;
     pos_r.zak_pp := null;
     pos_r.zak_oves := null;
     if (l_vid_cont = 60) and (l_copy_razm=0) then
       pos_r.s1delim := null;
       pos_r.s1mn := null;
       pos_r.s1mx := null;
       pos_r.s2delim := null;
       pos_r.s2mn := null;
       pos_r.s2mx := null;
       pos_r.s3delim := null;
       pos_r.s3mn := null;
       pos_r.s3mx := null;
       pos_r.kw1 := null;
       pos_r.kw2 := null;
       pos_r.kw3 := null;
       pos_r.kw4 := null;
     else
       if l_spec_r.shop=613 and pos_r.s1mx>32 then  
         update cont_spec set days_isp=38 where unik_s = pos_r.unik_s;
       end if;  
     end if;
     insert into cont_pos values pos_r;
     for pos_mark_r in (select * from cont_pos_mark where unik_p = l_old_p) 
     loop
       pos_mark_r.unik_p := pos_r.unik_p;
       insert into cont_pos_mark values pos_mark_r;
     end loop;
   end loop;
    
   commit;
   if add_to_debug then
    std.debug_message('copy_spec','10. Вставлены все позиции');
   end if; 
   return l_spec_r.unik_s;
 exception
   when others then
      std.debug_message(l_module, 'Exception was raised:' || chr(10) || chr(10)
        || 'ORA-' || SQLCODE || ': ' || DBMS_UTILITY.FORMAT_ERROR_STACK
        || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      return null;
 end;
 
function copy_spec_for_dop( l_unik_s cont_spec.unik_s%type,
     l_unik_c cont_head.unik_c%type,
     l_n_spc cont_spec.n_spc%type) return cont_spec.unik_s%type is
   l_spec_r cont_spec%rowtype;
   l_cont_r cont_head%rowtype;
   l_old_p cont_pos.unik_p%type;
   l_vid_cont cont_head.vid_cont%type;
   pr_act number;
   l_module constant varchar2(50) := 'contract_pkg.copy_spec';
 begin
   -- проверим, чтобы исходная спецификация существовала
   begin
     select * into l_spec_r from cont_spec where unik_s = l_unik_s;
   exception
     when No_Data_Found then
       return null;
   end;
   -- проверим, чтобы конечный контракт существовал
   begin
     select * into l_cont_r from cont_head where unik_c = l_unik_c;
   exception
     when No_Data_Found then
       return null;
   end;
   l_spec_r.unik_c := l_unik_c;
   -- определим номер спецификации и версию
   l_spec_r.spec_version := 0;
   l_spec_r.n_spc := l_n_spc;
   select cont_spec_seq.nextval into l_spec_r.unik_s from dual;
   select pr_actual into pr_act from nsi201 where nsi20101 = l_spec_r.prod;
   if pr_act=0 then
     l_spec_r.prod := null;
   end if;
   l_spec_r.status := 1;
   l_spec_r.status_usl := 0;
   l_spec_r.prizn_dop := 1;
   l_spec_r.unik_s_ch := nvl(l_spec_r.unik_s_ch,l_unik_s);
   l_spec_r.otv := nvl(oasu.get_prop('user_unik'), 218);
   l_spec_r.stat2 := sysdate;
   l_spec_r.kdpl := l_cont_r.kpok;
   l_spec_r.bank := l_cont_r.bank;
   l_spec_r.date_beg := sysdate;
   l_spec_r.reg_date := sysdate;
   l_spec_r.rs := l_cont_r.rs;
   -- вставка шапки спецификации
   insert into cont_spec values l_spec_r;
   --  доп. тех. требования
   insert into cont_spec_dop_treb(unik, unik_s, code)
     select cont_helper_seq.nextval, l_spec_r.unik_s, code
       from cont_spec_dop_treb
       where unik_s = l_unik_s;
   -- позиции
   -- для экспортных контрактов копируется только первая позиция (с минимальным номером)
   for pos_r in (select * from cont_pos where unik_s = l_unik_s)  loop
     l_old_p := pos_r.unik_p;
     select cont_pos_seq.nextval into pos_r.unik_p from dual;
     pos_r.unik_s := l_spec_r.unik_s;
     insert into cont_pos values pos_r;
     for pos_mark_r in (select * from cont_pos_mark where unik_p = l_old_p) 
     loop
       pos_mark_r.unik_p := pos_r.unik_p;
       insert into cont_pos_mark values pos_mark_r;
     end loop;     
   end loop;
   for mark_r in (select * from CONT_EXP_SPEC_LOT where unik_s = l_unik_s) loop
    mark_r.unik_s := l_spec_r.unik_s;
    insert into CONT_EXP_SPEC_LOT values mark_r;
   end loop;
   commit;
   update cont_spec set spec_version = spec_version + 1 where unik_s = l_spec_r.unik_s_ch or unik_s_ch = l_spec_r.unik_s_ch;
   commit;
   return l_spec_r.unik_s;
 exception
   when others then
      std.debug_message(l_module, 'Exception was raised:' || chr(10) || chr(10)
        || 'ORA-' || SQLCODE || ': ' || DBMS_UTILITY.FORMAT_ERROR_STACK
        || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      return null;
 end; 

 function delete_position(l_unik_p cont_pos.unik_p%type) return boolean is
   l_npoz cont_pos.npoz%type;
   l_unik_s cont_pos.unik_s%type;
 begin
   select npoz, unik_s into l_npoz, l_unik_s
     from cont_pos where unik_p = l_unik_p;
   delete from cont_pos_mark where unik_p = l_unik_p;     
   delete from cont_pos where unik_p = l_unik_p;
   if sql%rowcount <> 1 then
     return false;
   end if;
   update cont_pos set npoz = npoz - 1
     where unik_s = l_unik_s and npoz > l_npoz;
   commit;
   return true;
 exception
   when No_Data_Found then
     return false;
 end;

 function can_edit(l_target_user passw.unik%type) return boolean
 is
 begin
   return true;
  /*   (l_target_user = oasu.get_prop('user_unik')) 
     or
     ((nvl(oasu.get_prop('user_buro'),0) = 7) and (oasu.get_prop('user_cex') = 69600));*/
 end;
 
 function can_edit_oves(l_target_user passw.unik%type) return boolean
 is
 ch number;
 br number;
 kd char(10);
 begin
   /*select cex,buro,kod into ch,br,kd from passw where unik=l_target_user;
   if ((trim(kd)='60') and (trim(oasu.get_prop('user_kod'))='60') and (oasu.get_prop('user_cex')=ch) and (nvl(oasu.get_prop('user_buro'),0)=nvl(br,0)))
       or
     ((nvl(oasu.get_prop('user_buro'),0) = 7) and (oasu.get_prop('user_cex') = 69600))
   then 
     return true;
   else
     return false;
   end if;*/
   return true;    
 end; 
 
 function user_full_access(l_target_user passw.unik%type) return boolean
 is
 begin
  if l_target_user in (3736) then
    return true;
  else
    return false;
  end if;    
 end;  

 function is_suffix_valid(l_suffix cont_head.suffix%type) return boolean
 is
 begin
   /*
     13 -- КОНТРАКТЫ КОМБИНАТА
     20 -- КОНТРАКТЫ ИЛЬИЧ-СТАЛИ
     126 -- КОНТРАКТЫ МАРКЕТИНГА
     10 -- КОНТРАКТЫ АГРОДОНБАССА
     1 -- КОНТРАКТЫ МЕТИНВЕСТ-УКРАИНА
   */
   return l_suffix in (13, 20, 126, 10, 1);
 end;

 function size_combine(l_min in number, l_max in number, l_delim in varchar2)
   return varchar2
 is
 begin
   if l_delim is not null then
     if l_delim = '-' and Nvl(l_min, 0) = Nvl(l_max, 0) then
       return add_zero(to_char(l_min));
     else
       return add_zero(to_char(l_min)) || l_delim || add_zero(to_char(l_max));
     end if;
   else
     return add_zero(to_char(l_min));
   end if;
 end;

  function size_split(l_size in varchar2, l_min in out number, l_max in out number,
    l_delim in out varchar2) return boolean
  is
    l_vmin cont_pos.s1mn%type;
    l_vmax cont_pos.s1mx%type;
    l_vdelim cont_pos.s1delim%type;
    l_smin varchar2(200);
    l_smax varchar2(200);
    k integer;
    r integer;
    n integer;
  begin
    if std.is_number(l_size) or l_size is null then
      l_vmin := To_Number(l_size);
      l_vmax := l_vmin;
      l_vdelim := null;
    else
      -- найдем разделитель
      k := 1;
      n := Length(l_size);
      while k < n and SubStr(l_size, k, 1) in
          ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', ',', '.')
      loop
        k := k + 1;
      end loop;
      if k = n then
        return false;
      end if;
      -- выделим минимум и максимум
      l_smin := SubStr(l_size, 1, k - 1);
      l_smax := SubStr(l_size, k + 1);
      -- проверим, числа ли это
      if (l_smin is not null and not std.is_number(l_smin))
         or (l_smax is not null and not std.is_number(l_smax)) then
        return false;
      end if;
      l_vmin := To_Number(l_smin);
      l_vmax := To_Number(l_smax);
      l_vdelim := SubStr(l_size, k, 1);
    end if;
    l_min := l_vmin;
    l_max := l_vmax;
    l_delim := l_vdelim;
    return true;
  end;

  function is_account_valid(l_account in varchar2,
    l_bank in nsi111.nsi11101%type) return boolean
  is
    l_freeform nsi111.freeform_account%type;
  begin
    if l_bank is null then
      return true;
    else
     Begin
      select freeform_account into l_freeform from nsi111 where nsi11101 = l_bank;
      if l_freeform = 0 then
        return std.is_number(l_account) and Length(l_account) <= 25;
      else
        return true;
      end if;  
    exception
    when No_Data_Found then
      return false;
    end;  
    end if;
    --return true;
  end;

  procedure enable_freeform_account(l_bank in nsi111.nsi11101%type)
  is
  begin
    update nsi111 set freeform_account = 1 where nsi11101 = l_bank;
  end;

   function get_type_for_contract return number
   is
   begin
     return 1;
   end;

   function get_type_for_dop_sogl return number
   is
   begin
     return 4;
   end;
   
 function get_type_for_pril return number
   is
   begin
     return 6;
   end;   

  function add_zero(l_inp in varchar2) return varchar2
  is
  begin
    if substr(l_inp,1,1) in (',','.') then
      return '0'||l_inp;
    else
      return l_inp;   
    end if;
  end;
  
 function add_zero(l_inp in number) return varchar2
  is
    l_str varchar2(600);
  begin
    l_str := to_char(l_inp);
    if substr(l_str,1,1) in (',','.') then
      return '0'||l_str;
    else
      return l_str;   
    end if;
  end;  
  
function vid_spc(p_unik_s in integer) return pls_integer is
  p_unik_c pls_integer;
  vid_cont pls_integer;
Begin
  select unik_c into p_unik_c from cont_spec where unik_s = p_unik_s; 
  select max(vid_cont) into vid_cont from cont_head where unik_c = p_unik_c;
  return vid_cont;
End;

function spec_annul(p_unik_s in cont_spec.unik_s%type) return number is
  ct_otgr_z004 number;
  ct_otgr_psert number;
Begin
  select count(*) into ct_otgr_z004 from z004 where (nsnz,dpid,gdis) in (select nsnz,dpid,gdis from z001 where unik_s = p_unik_s) and ngves<>0;
  select count(*) into ct_otgr_psert from psert where (nsnz,dpid,gdis) in (select nsnz,dpid,gdis from z001 where unik_s = p_unik_s)  and aktvz is null and nsrt>0;
  if (nvl(ct_otgr_z004,0)+nvl(ct_otgr_psert,0))>0 then
    return 0;
  else
    update z001 set sost=2,zak_block=1,zak_fin=1,stat2=to_number(to_char(sysdate,'yyyymmdd')),stat3=to_number(to_char(sysdate,'hh24mi')) where unik_s = p_unik_s;
    update z002 set sost=2,stat2=to_number(to_char(sysdate,'yyyymmdd')),stat3=to_number(to_char(sysdate,'hh24mi')) where (nsnz,dpid,gdis) in (select nsnz,dpid,gdis from z001 where unik_s = p_unik_s);
    update cont_spec set status=-2,status_usl=0 where unik_s = p_unik_s;
    commit;
    return 1;
  end if;     
End;
   
function spec_del(p_unik_s in cont_spec.unik_s%type) return varchar2 is
  ct_otgr_z004 number;
  ct_otgr_psert number;
Begin
  select count(*) into ct_otgr_z004 from z004 where (nsnz,dpid,gdis) in (select nsnz,dpid,gdis from z001 where unik_s = p_unik_s) and ngves<>0;
  select count(*) into ct_otgr_psert from psert where (nsnz,dpid,gdis) in (select nsnz,dpid,gdis from z001 where unik_s = p_unik_s);
  if (nvl(ct_otgr_z004,0)+nvl(ct_otgr_psert,0))>0 then
    return 'Удаление не возможно!!! По спецификации есть отгрузка!!!';
  else
    for s in (select nsnz,dpid,gdis from z001 where unik_s = p_unik_s) loop
      ZAKAZ_PKG.ZAK_DEL(s.nsnz,s.dpid,s.gdis);
    end loop;
    update cont_spec set status=-3, prizn_del=1 where unik_s = p_unik_s;
    commit;
    return 'OK';
  end if;
End;

function sel_exec_imm(p_str in varchar2) return varchar2 is
  cv varchar2(4000);
begin
  execute immediate (p_str) into cv;
  return cv;
end;

function cont_to_dop_sogl(p_unik_c in cont_head.unik_c%type,p_type_dpid in cont_head.type_dpid%type) return number is
  r_cont_head cont_head%rowtype;
  r_cont_bank cont_head_bank%rowtype;
  v_new_unik cont_head.unik_c%type;
  v_old_unik cont_head.unik_c%type;
begin

  select * into r_cont_head from cont_head where unik_c = p_unik_c;
        
  select seq_dogov.nextval into v_new_unik from dual; 
  v_old_unik := p_unik_c;
            
  r_cont_head.unik_c := v_new_unik;
  r_cont_head.for_contract := v_old_unik;    
  r_cont_head.type := 4;
  r_cont_head.type_dpid := p_type_dpid;
  r_cont_head.number_c := null;
  r_cont_head.c_data := sysdate;
  r_cont_head.status := 1;
  r_cont_head.status_usl := 0;
  r_cont_head.stat2 := sysdate;
  r_cont_head.f_yurist := null;
  r_cont_head.otv := oasu.get_prop('user_unik');
        
  insert into cont_head values r_cont_head;
   
  for s in (select unik_b from cont_head_bank where unik_c = v_old_unik) loop
    select * into r_cont_bank from cont_head_bank where unik_b = s.unik_b and unik_c = v_old_unik;
    --select cont_head_bank_seq.nextval into r_cont_bank.unik_b from dual;
    r_cont_bank.unik_c := v_new_unik;
    insert into cont_head_bank values r_cont_bank;
  end loop;
  
  return v_new_unik;
end;  

function dop_sogl_to_cont(p_unik_c in cont_head.unik_c%type) return number is
  r_cont_head cont_head%rowtype;
  r_cont_bank cont_head_bank%rowtype;
  v_arc_unik cont_head.unik_c%type;
  v_old_unik cont_head.unik_c%type;
  v_dop_unik cont_head.unik_c%type;
  str_unik varchar2(2000);
Begin

  select * into r_cont_head from cont_head where unik_c = p_unik_c;
  
  if r_cont_head.type=4 and r_cont_head.type_dpid=1 and r_cont_head.status=0 then

    select seq_dogov.nextval into v_arc_unik from dual; 
    v_old_unik  := r_cont_head.for_contract;
    v_dop_unik := r_cont_head.unik_c; 
    select number_c,c_data,status_usl into r_cont_head.number_c,r_cont_head.c_data,r_cont_head.status_usl from cont_head where unik_c = v_old_unik;  
    
    select str_join(unik_c) into str_unik from cont_head where unik_c=v_dop_unik or for_contract=v_old_unik;
    --проставляем по допсоглашениям для возможности изменения в контракте
    update cont_head set for_contract=-999999 where unik_c in (select * from table(std.split_to_table(str_unik)));
    std.debug_message('ds2cont','1');
    --проставляем по спецификациям для возможности изменения в контракте
    update cont_spec set unik_c=-999999 where unik_c = v_old_unik;
    std.debug_message('ds2cont','2');
    --изменияем уник старого контракта
    update cont_head set unik_c=v_arc_unik,status=-1,status_usl=0,stat2=sysdate where unik_c =v_old_unik;
    std.debug_message('ds2cont','3');
    --изменяем уник по банкам
    update cont_head_bank set unik_c = v_arc_unik where unik_c = v_old_unik;
    std.debug_message('ds2cont','4');
              
    r_cont_head.unik_c := v_old_unik;
    r_cont_head.for_contract := null;    
    r_cont_head.type := 1;
    r_cont_head.type_dpid := 0;
    r_cont_head.status := 0;
    r_cont_head.stat2 := sysdate;
      
    insert into cont_head values r_cont_head;
    std.debug_message('ds2cont','5');
          
    for s in (select unik_b from cont_head_bank where unik_c = v_dop_unik) loop
      select * into r_cont_bank from cont_head_bank where unik_b = s.unik_b and unik_c=v_dop_unik;
      --select cont_head_bank_seq.nextval into r_cont_bank.unik_b from dual;
      r_cont_bank.unik_c := v_old_unik;
      insert into cont_head_bank values r_cont_bank;
    end loop;  
    std.debug_message('ds2cont','6');
    update cont_head set for_contract=v_old_unik where unik_c = v_arc_unik or (unik_c in (select * from table(std.split_to_table(str_unik))) and unik_c<>v_dop_unik);
    std.debug_message('ds2cont','7');
    update cont_head set for_contract=v_arc_unik where unik_c = v_dop_unik;
    std.debug_message('ds2cont','8');
    update cont_spec set unik_c = v_old_unik where unik_c = -999999;
    std.debug_message('ds2cont','9');
    commit;
    std.debug_message('ds2cont','10');
    return 1;
  else
    return 9;    
  end if;
  exception
    when others then
      std.debug_message('ds2cont', 'Exception was raised:' || chr(10) || chr(10)
        || 'ORA-' || SQLCODE || ': ' || DBMS_UTILITY.FORMAT_ERROR_STACK
        || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      return 0;
   
End;

end contract_pkg;
/