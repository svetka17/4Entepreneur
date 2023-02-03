CREATE OR REPLACE package body ASUPPP.xx_make_d_4_dbf_pkg as
procedure xxx(polz varchar2, mfo number, rs number default 0) is
file_handle UTL_FILE.FILE_TYPE;
blob_for_pass blob; tmp integer; co integer; p_num number;
nam varchar2(100);
BEGIN
-- обычные платежки priz=3
    
select count(*) into co from poruch where  
nvl(priz,0)=3 and polz like polz||'%' and mfon=mfo; 

if co<>0 then  
    UTL_FILE.FCLOSE (file_handle);
    select asuppp.xxx.nextval into tmp from dual;
    select translate(upper(polz),'АБВГДЕЖЗИКЛМНОПРСТУФХЦЧШЩЬЫЭЮЯ','ABVGDEJZIKLMNOPRSTUFHC123EUA')/*||'_'*/||to_char(sysdate,'mmss')||'.' into nam from dual;
    
    if mfo = 335957 then
    file_handle := UTL_FILE.FOPEN ('DIR335957',nam||'db_','wb',32767);
    select create_dbf_for_335957(polz||'%',3) into blob_for_pass from dual;
    IF utl_file.is_open(file_handle) THEN UTL_FILE.put_RAW(file_handle,blob_for_pass);  
    UTL_FILE.FCLOSE (file_handle);
    UTL_FILE.FRENAME ('DIR335957', nam||'db_','DIR335957',nam||'dbf',FALSE);
    end if;
    
    elsif mfo = 334442 then
    select create_for_334442_new(polz||'%',3) into blob_for_pass from dual;
    if dbms_lob.getlength(blob_for_pass)>0 then --jmac !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        file_handle := UTL_FILE.FOPEN ('DIR3344420',nam||'tx_','wb',32767);
        IF utl_file.is_open(file_handle) THEN UTL_FILE.put_RAW(file_handle,blob_for_pass);  
        UTL_FILE.FCLOSE (file_handle);
        UTL_FILE.FRENAME ('DIR3344420', nam||'tx_','DIR3344420',nam||'txt',FALSE);
        end if;
    end if; --jmac !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
     elsif mfo = 3344420 then
    select create_for_334442_new(polz||'%',3) into blob_for_pass from dual;
    if dbms_lob.getlength(blob_for_pass)>0 then --jmac !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        file_handle := UTL_FILE.FOPEN ('DIR3344420',nam||'tx_','wb',32767);
        IF utl_file.is_open(file_handle) THEN UTL_FILE.put_RAW(file_handle,blob_for_pass);  
        UTL_FILE.FCLOSE (file_handle);
        UTL_FILE.FRENAME ('DIR3344420', nam||'tx_','DIR3344420',nam||'txt',FALSE);
        end if;
    end if;
    
    elsif mfo = 335678 then
    file_handle := UTL_FILE.FOPEN ('DIR335678',nam||'tx_','wb',32767);
    select create_for_335678(polz||'%',3) into blob_for_pass from dual;  
    IF utl_file.is_open(file_handle) THEN UTL_FILE.put_RAW(file_handle,blob_for_pass);  
    UTL_FILE.FCLOSE (file_handle);
    UTL_FILE.FRENAME ('DIR335678', nam||'tx_','DIR335678',nam||'txt',FALSE);
    end if;
----    
    elsif mfo in (334851)  then
                    if rs in (26001962492921,26001962493232) then
                            /*file_handle := UTL_FILE.FOPEN ('DIR335742',nam||'db_','wb',32767);
                            select create_dbf_for_335742(polz||'%',3) into blob_for_pass from dual;
                            IF utl_file.is_open(file_handle) THEN UTL_FILE.put_RAW(file_handle,blob_for_pass); 
                            UTL_FILE.FCLOSE (file_handle);
                            UTL_FILE.FRENAME ('DIR335742', nam||'db_','DIR335742',nam||'dbf',FALSE);
                            end if; */
                            file_handle := UTL_FILE.FOPEN ('DIR334970',nam||'db_','wb',32767);
                            select create_dbf_for_334970_new_(polz||'%',3) into blob_for_pass from dual;--здесь исправить на новый _new_
                            IF utl_file.is_open(file_handle) THEN UTL_FILE.put_RAW(file_handle,blob_for_pass); 
                            UTL_FILE.FCLOSE (file_handle);
                            UTL_FILE.FRENAME ('DIR334970', nam||'db_','DIR334970',nam||'dbf',FALSE);
                            UTL_FILE.Fcopy ('DIR334970', nam||'dbf','DIRH334970',nam||'dbf');
                            end if;   
                    else
                            file_handle := UTL_FILE.FOPEN ('DIR334970',nam||'db_','wb',32767);
                            select create_dbf_for_334970_new_(polz||'%',3) into blob_for_pass from dual;--здесь исправить на новый _new_
                            IF utl_file.is_open(file_handle) THEN UTL_FILE.put_RAW(file_handle,blob_for_pass); 
                            UTL_FILE.FCLOSE (file_handle);
                            UTL_FILE.FRENAME ('DIR334970', nam||'db_','DIR334970',nam||'dbf',FALSE);
                            UTL_FILE.Fcopy ('DIR334970', nam||'dbf','DIRH334970',nam||'dbf');
                            end if;
                            /*file_handle := UTL_FILE.FOPEN ('DIR335742',nam||'db_','wb',32767);
                            select create_dbf_for_335742(polz||'%',3) into blob_for_pass from dual;
                            IF utl_file.is_open(file_handle) THEN UTL_FILE.put_RAW(file_handle,blob_for_pass); 
                            UTL_FILE.FCLOSE (file_handle);
                            UTL_FILE.FRENAME ('DIR335742', nam||'db_','DIR335742',nam||'dbf',FALSE);
                            end if; */
                    -- end if;      
                          end if;
----    
    elsif mfo in (335742) /*and rs in (26001962492921,26001962493232) */  then
              if polz='Зинченко' then
            file_handle := UTL_FILE.FOPEN ('DIR335742',nam||'db_','wb',32767);
            select create_for_335742_online(polz||'%',3) into blob_for_pass from dual;
            IF utl_file.is_open(file_handle) THEN UTL_FILE.put_RAW(file_handle,blob_for_pass); 
            UTL_FILE.FCLOSE (file_handle);
            UTL_FILE.FRENAME ('DIR335742', nam||'db_','DIR335742',nam||'dbf',FALSE);
            end if;
               else 
    
            file_handle := UTL_FILE.FOPEN ('DIR335742',nam||'db_','wb',32767);
            select create_dbf_for_335742(polz||'%',3) into blob_for_pass from dual;
            IF utl_file.is_open(file_handle) THEN UTL_FILE.put_RAW(file_handle,blob_for_pass); 
            UTL_FILE.FCLOSE (file_handle);
            UTL_FILE.FRENAME ('DIR335742', nam||'db_','DIR335742',nam||'dbf',FALSE);
            end if; 
           end if;
    elsif mfo in (334970) /* and rs not in (26001962492921,26001962493232) */ then
    file_handle := UTL_FILE.FOPEN ('DIR334970',nam||'db_','wb',32767);
    select create_dbf_for_334970(polz||'%',3) into blob_for_pass from dual;
    IF utl_file.is_open(file_handle) THEN UTL_FILE.put_RAW(file_handle,blob_for_pass); 
    UTL_FILE.FCLOSE (file_handle);
    UTL_FILE.FRENAME ('DIR334970', nam||'db_','DIR334970',nam||'dbf',FALSE);
    UTL_FILE.Fcopy ('DIR334970', nam||'dbf','DIRH334970',nam||'dbf');
    end if; 
    
    elsif mfo = 394200 then
    file_handle := UTL_FILE.FOPEN ('DIR394200',nam||'db_','wb',32767);
    select create_dbf_for_394200(polz||'%',3) into blob_for_pass from dual;
    IF utl_file.is_open(file_handle) THEN UTL_FILE.put_RAW(file_handle,blob_for_pass);  
    UTL_FILE.FCLOSE (file_handle);
    UTL_FILE.FRENAME ('DIR394200', nam||'db_','DIR394200',nam||'dbf',FALSE);
    end if; 
elsif mfo in (/*300346,*/380731) then 
--дойче банк
                /*file_handle := UTL_FILE.FOPEN ('DIR300346',nam||'db_','wb',32767);
                select create_dbf_for_300346(polz||'%',3) into blob_for_pass from dual;
                IF utl_file.is_open(file_handle) THEN UTL_FILE.put_RAW(file_handle,blob_for_pass);  
                UTL_FILE.FCLOSE (file_handle);
                UTL_FILE.FRENAME ('DIR300346', nam||'db_','DIR300346',nam||'dbf',FALSE);
                end if;*/ 
                
                /*file_handle := UTL_FILE.FOPEN ('DIR380731',nam||'db_','wb',32767);
                select create_dbf_for_300346(polz||'%',3) into blob_for_pass from dual;
                IF utl_file.is_open(file_handle) THEN UTL_FILE.put_RAW(file_handle,blob_for_pass);  
                UTL_FILE.FCLOSE (file_handle);
                UTL_FILE.FRENAME ('DIR380731', nam||'db_','DIR380731',nam||'dbf',FALSE);
                end if;*/
                select create_for_380731(polz||'%',3) into p_num from dual; 
 
                
                
                
    elsif mfo = 335593 then
    file_handle := UTL_FILE.FOPEN ('DIR335593',nam||'db_','wb',32767);
    select create_dbf_for_335593(polz||'%',3) into blob_for_pass from dual;
    IF utl_file.is_open(file_handle) THEN UTL_FILE.put_RAW(file_handle,blob_for_pass);  
    UTL_FILE.FCLOSE (file_handle);
    UTL_FILE.FRENAME ('DIR335593', nam||'db_','DIR335593',nam||'dbf',FALSE);
    end if;  
    end if;

    
    --UTL_RAW.SUBSTR(blob_for_pass,1,50));  end if;  
     begin
       UTL_FILE.FCLOSE (file_handle);
    --UTL_FILE.FRENAME ('DIR335957', nam||'.db_','DIR335957',nam||'.dbf',FALSE);
     exception when others then null; end;
     
   update poruch set priz=2 where polz like polz||'%' and mfon=mfo and priz=3;
   commit;
end if;
-- особые платежки платежки формируются в отдельный файл priz=4 (bad_bank(мфо получателя)<>0)

select count(*) into co from poruch where  
nvl(priz,0)=4 and polz like polz||'%' and mfon=mfo; 

if co<>0 then
        UTL_FILE.FCLOSE (file_handle);
    select asuppp.xxx.nextval into tmp from dual;
    select translate(upper(polz),'АБВГДЕЖЗИКЛМНОПРСТУФХЦЧШЩЬЫЭЮЯ','ABVGDEJZIKLMNOPRSTUFHC123EUA')/*||'_'*/||to_char(sysdate,'mmss')||'.' into nam from dual;

    if mfo = 335957 then
    file_handle := UTL_FILE.FOPEN ('DIR335957','A'||nam||'db_','wb',32767);
    select create_dbf_for_335957(polz||'%',4) into blob_for_pass from dual;
    IF utl_file.is_open(file_handle) THEN UTL_FILE.put_RAW(file_handle,blob_for_pass);  
    UTL_FILE.FCLOSE (file_handle);
    UTL_FILE.FRENAME ('DIR335957', 'A'||nam||'db_','DIR335957','A'||nam||'dbf',FALSE);
    end if;

    elsif mfo = 334442 then
    select create_for_334442_new(polz||'%',4) into blob_for_pass from dual;
    if dbms_lob.getlength(blob_for_pass)>0 then --jmac !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        file_handle := UTL_FILE.FOPEN ('DIR3344420','A'||nam||'tx_','wb',32767);
        IF utl_file.is_open(file_handle) THEN UTL_FILE.put_RAW(file_handle,blob_for_pass);  
        UTL_FILE.FCLOSE (file_handle);
        UTL_FILE.FRENAME ('DIR3344420', 'A'||nam||'tx_','DIR3344420','A'||nam||'txt',FALSE);
        end if;
    end if; --jmac !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
    elsif mfo = 3344420 then
    select create_for_334442_new(polz||'%',4) into blob_for_pass from dual;
    if dbms_lob.getlength(blob_for_pass)>0 then --jmac !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        file_handle := UTL_FILE.FOPEN ('DIR3344420','A'||nam||'tx_','wb',32767);
        IF utl_file.is_open(file_handle) THEN UTL_FILE.put_RAW(file_handle,blob_for_pass);  
        UTL_FILE.FCLOSE (file_handle);
        UTL_FILE.FRENAME ('DIR3344420', 'A'||nam||'tx_','DIR3344420','A'||nam||'txt',FALSE);
        end if;
    end if;
    
    elsif mfo = 335678 then
    file_handle := UTL_FILE.FOPEN ('DIR335678','A'||nam||'tx_','wb',32767);
    select create_for_335678(polz||'%',4) into blob_for_pass from dual;  
    IF utl_file.is_open(file_handle) THEN UTL_FILE.put_RAW(file_handle,blob_for_pass);  
    UTL_FILE.FCLOSE (file_handle);
    UTL_FILE.FRENAME ('DIR335678', 'A'||nam||'tx_','DIR335678','A'||nam||'txt',FALSE);
    end if;
----    
    elsif mfo = 334851 then 
    if rs in (26001962492921,26001962493232)  then
    file_handle := UTL_FILE.FOPEN ('DIR335742','A'||nam||'db_','wb',32767);
    select create_dbf_for_335742(polz||'%',4) into blob_for_pass from dual;
    IF utl_file.is_open(file_handle) THEN UTL_FILE.put_RAW(file_handle,blob_for_pass);  
    UTL_FILE.FCLOSE (file_handle);
    UTL_FILE.FRENAME ('DIR335742', 'A'||nam||'db_','DIR335742','A'||nam||'dbf',FALSE);
    end if;
    else
    file_handle := UTL_FILE.FOPEN ('DIR334970','A'||nam||'db_','wb',32767);
    select create_dbf_for_334970(polz||'%',4) into blob_for_pass from dual;
    IF utl_file.is_open(file_handle) THEN UTL_FILE.put_RAW(file_handle,blob_for_pass);  
    UTL_FILE.FCLOSE (file_handle);
    UTL_FILE.FRENAME ('DIR334970', 'A'||nam||'db_','DIR334970','A'||nam||'dbf',FALSE);
    UTL_FILE.Fcopy('DIR334970', 'A'||nam||'dbf','DIRH334970','A'||nam||'dbf');
    end if; 
    end if;
----    
    elsif mfo in (334970) /* and rs not in (26001962492921,26001962493232) */ then
    file_handle := UTL_FILE.FOPEN ('DIR334970','A'||nam||'db_','wb',32767);
    select create_dbf_for_334970(polz||'%',4) into blob_for_pass from dual;
    IF utl_file.is_open(file_handle) THEN UTL_FILE.put_RAW(file_handle,blob_for_pass);  
    UTL_FILE.FCLOSE (file_handle);
    UTL_FILE.FRENAME ('DIR334970', 'A'||nam||'db_','DIR334970','A'||nam||'dbf',FALSE);
    UTL_FILE.Fcopy ('DIR334970', 'A'||nam||'dbf','DIRH334970','A'||nam||'dbf');
    end if; 
    
    elsif mfo = 394200 then
    file_handle := UTL_FILE.FOPEN ('DIR394200','A'||nam||'db_','wb',32767);
    select create_dbf_for_394200(polz||'%',4) into blob_for_pass from dual;
    IF utl_file.is_open(file_handle) THEN UTL_FILE.put_RAW(file_handle,blob_for_pass);  
    UTL_FILE.FCLOSE (file_handle);
    UTL_FILE.FRENAME ('DIR394200', 'A'||nam||'db_','DIR394200','A'||nam||'dbf',FALSE);
    end if; 
elsif mfo = 300346 then
    file_handle := UTL_FILE.FOPEN ('DIR300346','A'||nam||'db_','wb',32767);
    select create_dbf_for_300346(polz||'%',4) into blob_for_pass from dual;
    IF utl_file.is_open(file_handle) THEN UTL_FILE.put_RAW(file_handle,blob_for_pass);  
    UTL_FILE.FCLOSE (file_handle);
    UTL_FILE.FRENAME ('DIR300346', 'A'||nam||'db_','DIR300346','A'||nam||'dbf',FALSE);
    end if; 
elsif mfo in (335742) /* and rs in (26001962492921,26001962493232) */ then
    file_handle := UTL_FILE.FOPEN ('DIR335742','A'||nam||'db_','wb',32767);
    select create_dbf_for_335742(polz||'%',4) into blob_for_pass from dual;
    IF utl_file.is_open(file_handle) THEN UTL_FILE.put_RAW(file_handle,blob_for_pass);  
    UTL_FILE.FCLOSE (file_handle);
    UTL_FILE.FRENAME ('DIR335742', 'A'||nam||'db_','DIR335742','A'||nam||'dbf',FALSE);
    end if; 
    elsif mfo = 335593 then
    file_handle := UTL_FILE.FOPEN ('DIR335593','A'||nam||'db_','wb',32767);
    select create_dbf_for_335593(polz||'%',4) into blob_for_pass from dual;
    IF utl_file.is_open(file_handle) THEN UTL_FILE.put_RAW(file_handle,blob_for_pass);  
    UTL_FILE.FCLOSE (file_handle);
    UTL_FILE.FRENAME ('DIR335593', 'A'||nam||'db_','DIR335593','A'||nam||'dbf',FALSE);
    end if;  
    end if;
    
    --UTL_RAW.SUBSTR(blob_for_pass,1,50));  end if;  
     begin
       UTL_FILE.FCLOSE (file_handle);
     exception when others then null; end;
     
   update poruch set priz=2 where polz like polz||'%' and mfon=mfo and priz=4;
   commit;
end if;

    
end xxx;

--334442 - ильичйовское го пиб
function create_for_334442(polzz varchar2, pr number) return blob is
    l_result varchar2(32767);
    l_blob      blob;
    v integer; d integer; o varchar2(15);
 
  begin
    l_result:='';
    for s in (select * from poruch where nvl(priz,0)=pr and polz like polzz and mfon=334442) 
    loop
    if length(s.okpop)>8 then 
    select convert(rpad(to_char(lpad(s.okpop,10,'0')),15,' '),'RU8PC866') into o from dual;
    else 
    select convert(rpad(to_char(lpad(s.okpop,8,'0')),15,' '),'RU8PC866') into o from dual;
    end if;     
    if s.okpop=0 then 
    select convert(rpad(to_char(lpad(s.okpop,9,'0')),15,' '),'RU8PC866') into o from dual;
    end if;
    select kval into v from sval where pval=nvl(s.pval,0);
    select decode(nvl(s.nds,0),0,0,3,round(s.sum_nds*100/(s.suman-s.sum_nds),2)*100 ,2000) into d from dual;
    
    l_result := l_result||
    convert(rpad(to_char(s.rshetn),35,' '),'RU8PC866')||
    convert(rpad(to_char(v),3,' '),'RU8PC866')||
    convert(rpad(to_char(nvl(s.mfo_new,s.mfop)),15,' '),'RU8PC866')||
    convert(rpad(to_char(upper(nvl(s.bank_name,text_bank_no_city(s.mfop)))),149,' '),'RU8PC866')||
    convert(rpad(to_char(nvl(s.schet_new,s.rshetp)),35,' '),'RU8PC866')||
    convert(rpad(to_char(v),3,' '),'RU8PC866')||
    --convert(rpad(to_char(lpad(s.okpop,10,'0')),15,' '),'RU8PC866')||
    o||
    convert(rpad(to_char(upper(text_firma_no_city(s.okpop,s.dpidp)) ),149,' '),'RU8PC866')||
    convert(rpad(to_char(804),3,' '),'RU8PC866')||
    convert(rpad(to_char(1),1,' '),'RU8PC866')||
    convert(rpad(to_char(nvl(s.vidp,0)),3,' '),'RU8PC866')||
    convert(rpad(to_char(s.suman*100),14,' '),'RU8PC866')||
    convert(rpad(to_char(s.nplat),10,' '),'RU8PC866')||
    --convert(rpad(to_char('-'),4,' '),'RU8PC866')||
    convert(rpad(to_char(d),4,' '),'RU8PC866')||
    convert(rpad(to_char(nvl(s.nds,0)),1,' '),'RU8PC866')||
    convert(rpad(to_char(0),1,' '),'RU8PC866')||
    convert(rpad(to_char(0),1,' '),'RU8PC866')||
    convert(rpad(to_char(' '),4,' '),'RU8PC866')||
    convert(rpad(to_char(' '),4,' '),'RU8PC866')||
    convert(rpad(to_char(to_date(s.datp,'yyyymmdd'),'ddmmyyyy'),8,' '),'RU8PC866')||
    convert(rpad(to_char(sysdate,'ddmmyyyy'),8,' '),'RU8PC866')||
    convert(rpad(to_char(substr(trim(upper(s.prim))||' '||trim(upper(s.prim3))/*||','||trim(upper(s.prim1))*/,0,159)),159,' '),'RU8PC866')||
    convert(rpad(to_char(' '),15,' '),'RU8PC866')||
    convert(rpad(to_char(' '),149,' '),'RU8PC866')||
    convert(rpad(to_char(' '),1,' '),'RU8PC866')||
    convert(rpad(to_char(' '),18,' '),'RU8PC866')||
    convert(rpad(to_char(' '),35,' '),'RU8PC866')||
    convert(rpad(to_char(' '),1,' '),'RU8PC866')||
    convert(rpad(to_char(' '),35,' '),'RU8PC866')||
    convert(rpad(to_char(' '),1,' '),'RU8PC866')||
    convert(rpad(to_char(' '),191,' '),'RU8PC866')||
    convert(rpad(to_char(' '),35,' '),'RU8PC866')||
    convert(rpad(to_char(' '),3,' '),'RU8PC866')||
    convert(rpad(' ',119,' '),'RU8PC866')||
    convert(rpad(' ',50,' '),'RU8PC866')||chr(10);
end loop;
    ----
    dbms_lob.createtemporary(l_blob, true);
      
    dbms_lob.append(l_blob, utl_raw.cast_to_raw(l_result));
    --Символ-метка конца записи
    --dbms_lob.append(l_blob, utl_raw.cast_to_raw(chr(26)));
    return l_blob;
    dbms_lob.freetemporary(l_blob);
  
END create_for_334442;


--Дойче банк  (380731)
function create_for_380731(polzz varchar2, pr number) return number is
   p_flag number := 0;
   p_name varchar2(100);
   v_file UTL_FILE.FILE_TYPE;
   
begin
    select to_char(sysdate, 'yyyymmdd_hh24miss') into p_name from dual;
    v_file := UTL_FILE.FOPEN ('DIR380731', p_name||'.txt', 'w', 32767);
    for s in (select poruch.*, decode(nvl(sum_nds,0), 0, 'N', 'Y') nds_priz, decode(nvl(sum_nds,0), 0, '', replace(sum_nds, ',', '.')) nds_sum, replace(suman, ',', '.') suman_point from poruch where nvl(priz,0)=pr and polz like polzz and mfon=380731)
        loop
         if p_flag=1 then UTL_FILE.PUT(v_file, chr(13)||chr(10)); end if;
         UTL_FILE.PUT(v_file, 
                 convert(
                            trim(s.rshetn)||'|'||
                            text_val_iso(s.pval)||'|'||
                            s.suman_point||'|'||
                            text_val_iso(s.pval)||'|'||
                            trim(s.nplat)||'|'||
                            to_char(to_date(s.datp, 'yyyymmdd'), 'dd.mm.yyyy')||'|'||
                            to_char(sysdate, 'dd.mm.yyyy')||'|||'||
                            'COM'||'|'||
                            substr(text_firma(s.okpop, s.dpidp),1,35)||'|'||
                            nvl(s.schet_new, trim(s.rshetp))||'|'||
                            case 
                                when length(s.okpop)<8 then
                                  lpad(s.okpop, 8, '0')
                                else
                                 to_char(s.okpop)
                            end||'|'||
                            'UA'||'||||'||
                            nvl(s.mfo_new,trim(s.mfop))||'|'||
                            'UABANK'||'||||||||'||
                            case 
                             when length(trim(s.prim))<=35 then
                                trim(s.prim)||'||||'
                             when length(trim(s.prim))>35 and length(trim(s.prim))<=70 then
                                substr(trim(s.prim),1,35)||'|'|| substr(trim(s.prim),36)||'|||'
                              when length(trim(s.prim))>70 and length(trim(s.prim))<=105 then
                                substr(trim(s.prim),1,35)||'|'|| substr(trim(s.prim),36,35)||'|'||substr(trim(s.prim),71,35)||'||'   
                             when length(trim(s.prim))>105  then
                                substr(trim(s.prim),1,35)||'|'|| substr(trim(s.prim),36,35)||'|'||substr(trim(s.prim),71,35)||'|'||substr(trim(s.prim),105) ||'|'   
                            end||
                            s.nds_priz||'|'||
                            s.nds_sum||'|||'
                    , 'CL8MSWIN1251') );  
        p_flag := 1;
        end loop;
        
    --exception when others then return 0;
    
    UTL_FILE.FCLOSE (v_file);
    return 1;
    
END create_for_380731;


--335678 - брокбизнесбанк
function create_for_335678(polzz varchar2, pr number) return blob is
    l_result varchar2(32767);
    l_blob      blob;o varchar2(20);
--    v integer;
 
  begin
    l_result := convert('Content-Type=doc/ua_payment','CL8MSWIN1251')||chr(13)||chr(10);
    
    for s in (select * from poruch where nvl(priz,0)=pr and polz like polzz and mfon=335678) 
    loop
        
--        begin
 if length(s.okpop)>8 then 
    select convert('RCPT_OKPO='||trim(lpad(s.okpop,10,'0')),'CL8MSWIN1251') into o from dual;
    else 
    select convert('RCPT_OKPO='||trim(lpad(s.okpop,8,'0')),'CL8MSWIN1251') into o from dual;
    end if;     
--    select kval into v from sval where pval=s.pval;
    l_result := l_result||
--  convert('Content-Type=doc/ua_payment','CL8MSWIN1251') 
--  ||chr(13)||chr(10)||chr(13)||chr(10)||    
  chr(13)||chr(10)||
  convert('DATE_DOC='||trim(to_char(to_date(s.datp,'yyyymmdd'),'dd.mm.yyyy')),'CL8MSWIN1251') 
  ||chr(13)
  ||chr(10)||    
  convert('NUM_DOC='||trim(substr(s.nplat,0,10)),'CL8MSWIN1251') 
  ||chr(13)
  ||chr(10);
  
  l_result := l_result||    
  convert('AMOUNT='||trim(to_char(nvl(s.suman,0),'99999999999.00')),'CL8MSWIN1251') 
  ||chr(13)
  ||chr(10)||    
  convert('CLN_NAME='||trim(substr(upper(text_firma_no_city(191129,0)),0,40)),'CL8MSWIN1251') 
  ||chr(13)
  ||chr(10)||    
  convert('CLN_OKPO=00191129','CL8MSWIN1251') 
  ||chr(13)
  ||chr(10)||    
  convert('CLN_ACCOUNT='||trim(s.rshetn),'CL8MSWIN1251') 
  ||chr(13)
  ||chr(10)||    
  convert('CLN_BANK_NAME='||trim(substr(upper(text_bank_no_city(s.mfon)),0,45)),'CL8MSWIN1251')  
  ||chr(13)
  ||chr(10)||    
  convert('CLN_BANK_MFO='||trim(s.mfon),'CL8MSWIN1251')  
  ||chr(13)
  ||chr(10)||    
  convert('RCPT_NAME='||trim(upper(substr(text_firma_no_city(s.okpop,s.dpidp),0,40))),'CL8MSWIN1251')  
  ||chr(13)
  ||chr(10)||    
  o  
  ||chr(13)
  ||chr(10)||    
  convert('RCPT_ACCOUNT='||trim(nvl(s.schet_new,s.rshetp)),'CL8MSWIN1251')  
  ||chr(13)
  ||chr(10)||    
  convert('RCPT_BANK_NAME='||trim(substr(nvl(s.bank_name,upper(text_bank_no_city(s.mfop))),0,45)),'CL8MSWIN1251')  
  ||chr(13)
  ||chr(10)||    
  convert('RCPT_BANK_MFO='||trim(nvl(s.mfo_new,s.mfop)),'CL8MSWIN1251')  
  ||chr(13)
  ||chr(10)||    
  convert('PAYMENT_DETAILS='||substr(upper(trim(s.prim))||' '||upper(trim(s.prim3))||' '||upper(trim(s.prim1)),0,160),'CL8MSWIN1251')
  ||chr(13)
  ||chr(10)||    
  convert('VALUE_DATE='||to_char(sysdate,'dd.mm.yyyy'),'CL8MSWIN1251')
  ||chr(13)
  ||chr(10);  
   
--   exception when others then null; end;

end loop;
    ----
    dbms_lob.createtemporary(l_blob, true);
      
    dbms_lob.append(l_blob, utl_raw.cast_to_raw(l_result));
    --Символ-метка конца записи
    --dbms_lob.append(l_blob, utl_raw.cast_to_raw(chr(26)));
    return l_blob;
    dbms_lob.freetemporary(l_blob);
  
END create_for_335678;



function create_for_334442_new(polzz varchar2, pr number) return blob is
    l_result varchar2(32767);
    l_blob      blob;o varchar2(20);
--    v integer;
 
  begin
    l_result := convert('Content-Type=doc/ua_payment','CL8MSWIN1251')||chr(13)||chr(10);
    
    for s in (select * from poruch where nvl(priz,0)=pr and polz like polzz and mfon=334442) 
    loop
        
--        begin
 if length(s.okpop)>8 then 
    select convert('RCPT_OKPO='||trim(lpad(s.okpop,10,'0')),'CL8MSWIN1251') into o from dual;
    else 
    select convert('RCPT_OKPO='||trim(lpad(s.okpop,8,'0')),'CL8MSWIN1251') into o from dual;
    end if;     
--    select kval into v from sval where pval=s.pval;
    l_result := l_result||
--  convert('Content-Type=doc/ua_payment','CL8MSWIN1251') 
--  ||chr(13)||chr(10)||chr(13)||chr(10)||    
  chr(13)||chr(10)||
  convert('DATE_DOC='||trim(to_char(to_date(s.datp,'yyyymmdd'),'dd.mm.yyyy')),'CL8MSWIN1251') 
  ||chr(13)||chr(10)||    
  convert('NUM_DOC='||trim(substr(s.nplat,0,10)),'CL8MSWIN1251') 
  ||chr(13)
  ||chr(10);
  
  l_result := l_result||    
  convert('AMOUNT='||trim(to_char(nvl(s.suman,0),'99999999999.00')),'CL8MSWIN1251') 
  ||chr(13)
  ||chr(10)||    
    convert('EXPENSE_ITEM=','CL8MSWIN1251') 
  ||chr(13)
  ||chr(10)||
  convert('CLN_NAME='||trim(substr(upper(text_firma_no_city(191129,0)),0,40)),'CL8MSWIN1251') 
  ||chr(13)
  ||chr(10)||    
  convert('CLN_OKPO=00191129','CL8MSWIN1251') 
  ||chr(13)
  ||chr(10)||    
  convert('CLN_ACCOUNT='||trim(s.rshetn),'CL8MSWIN1251') 
  ||chr(13)
  ||chr(10)||    
  convert('CLN_BANK_NAME='||trim(substr(upper(text_bank_no_city(s.mfon)),0,45)),'CL8MSWIN1251')  
  ||chr(13)
  ||chr(10)||    
  convert('CLN_BANK_MFO='||trim(s.mfon),'CL8MSWIN1251')  
  ||chr(13)
  ||chr(10)||    
    convert('CLN_COUNTRY_CODE=','CL8MSWIN1251') 
  ||chr(13)
  ||chr(10)||
  convert('RCPT_NAME='||trim(upper(substr(text_firma_no_city(s.okpop,s.dpidp),0,40))),'CL8MSWIN1251')  
  ||chr(13)
  ||chr(10)||    
  o  
  ||chr(13)
  ||chr(10)||    
  convert('RCPT_ACCOUNT='||trim(nvl(s.schet_new,s.rshetp)),'CL8MSWIN1251')  
  ||chr(13)
  ||chr(10)||    
  convert('RCPT_BANK_NAME='||trim(substr(nvl(s.bank_name,upper(text_bank_no_city(s.mfop))),0,45)),'CL8MSWIN1251')  
  ||chr(13)
  ||chr(10)||    
  convert('RCPT_BANK_MFO='||trim(nvl(s.mfo_new,s.mfop)),'CL8MSWIN1251')  
  ||chr(13)
  ||chr(10)||    
    convert('RCPT_COUNTRY_CODE=','CL8MSWIN1251') 
  ||chr(13)
  ||chr(10)||
  convert('PAYMENT_DETAILS='||substr(upper(trim(s.prim))||' '||upper(trim(s.prim3))||' '||upper(trim(s.prim1)),0,160),'CL8MSWIN1251')
  ||chr(13)
  ||chr(10)||    
  convert('VALUE_DATE='||to_char(sysdate,'dd.mm.yyyy'),'CL8MSWIN1251')
  ||chr(13)
  ||chr(10);  
   
--   exception when others then null; end;

end loop;
    ----
    dbms_lob.createtemporary(l_blob, true);
      
    dbms_lob.append(l_blob, utl_raw.cast_to_raw(l_result));
    --Символ-метка конца записи
    --dbms_lob.append(l_blob, utl_raw.cast_to_raw(chr(26)));
    return l_blob;
    dbms_lob.freetemporary(l_blob);
  
END create_for_334442_new;


-- 335957 укрэксим
function create_dbf_for_335957(polzz varchar2, pr number) return blob is
   l_result varchar2(4000);
   l_column varchar2(4000);
    
    l_columns   varchar2(32767);
    l_blob      blob;
    l_header    varchar2(32767);
    all_columns sys_refcursor;
    v_select    varchar2(32767);
    l_lines     varchar2(32767);
    l_number_of_columns binary_integer;
    l_line_length       binary_integer;
    l_number_of_records number;
    cursor c_columns is
    select column_name,data_type,data_length,data_scale
    from 
    (select 'D_NUMBER' COLUMN_NAME,'C' DATA_TYPE, 10 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'D_DATE' COLUMN_NAME,'D' DATA_TYPE, 8 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'S_NAME' COLUMN_NAME,'C' DATA_TYPE, 38 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'S_OKPO' COLUMN_NAME,'C' DATA_TYPE, 12 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'S_BANK' COLUMN_NAME,'C' DATA_TYPE, 38 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'S_MFO' COLUMN_NAME,'C' DATA_TYPE, 9 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'S_ACOUNT' COLUMN_NAME,'C' DATA_TYPE, 14 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'R_NAME' COLUMN_NAME,'C' DATA_TYPE, 38 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'R_OKPO' COLUMN_NAME,'C' DATA_TYPE, 12 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'R_BANK' COLUMN_NAME,'C' DATA_TYPE, 38 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'R_MFO' COLUMN_NAME,'C' DATA_TYPE, 9 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'R_ACOUNT' COLUMN_NAME,'C' DATA_TYPE, 14 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'CURRENCY' COLUMN_NAME,'C' DATA_TYPE, 3 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'SUMMA' COLUMN_NAME,'N' DATA_TYPE, 20 DATA_LENGTH, 4 DATA_SCALE from dual UNION ALL
    select 'C_SUMMA' COLUMN_NAME,'N' DATA_TYPE, 20 DATA_LENGTH, 4 DATA_SCALE from dual UNION ALL
    select 'DIRECT' COLUMN_NAME,'C' DATA_TYPE, 160 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'PAY_DATE' COLUMN_NAME,'D' DATA_TYPE, 8 DATA_LENGTH, 0 DATA_SCALE from dual 
    );
    
  begin
    l_number_of_columns:=17;
    l_line_length:=452;
   
    select count(*) into l_number_of_records from poruch where nvl(priz,0)=pr and polz like polzz and mfon=335957;
    --ЗАГОЛОВОК
    --№ - номер байта
    -- №0 Версия/ 1 байт
    -- 03 - простая таблица
    l_header := chr(3);
    -- №1,2,3 Дата последнего обновления таблицы в формате YYMMDD/ 3 байта
    l_header := l_header || chr(to_number(to_char(sysdate, 'YY'))) ||
                chr(to_number(to_char(sysdate, 'MM'))) ||
                chr(to_number(to_char(sysdate, 'DD')));
    --№4,5,6,7 Количество записей в таблице/ 32 бита = 4 байта
    l_header := l_header ||
                rpad(to_ascii(l_number_of_records), 4, chr(0));
    --№8,9 Количество байтов, занимаемых заголовком
    --/16 бит = 2 байта = 32 + 32*n + 1, где n - количество столбцов
    -- а 1 - ограничительный байт 
    l_header := l_header ||
                rpad(to_ascii(32 + l_number_of_columns * 32 + 1),
                     2,
                     chr(0));
    --№10,11 Количество байтов, занимаемых записью/16 бит = 2 байта 
    l_header := l_header || rpad(to_ascii(to_number(to_char(l_line_length,'XXXX'),'XXXX')), 2, chr(0));
    --№12,13 Зарезервировано
    l_header := l_header || rpad(chr(0), 2, chr(0));
    --№14 Транзакция, 1-начало, 0-конец(завершена)
    l_header := l_header || chr(0);
    --№15 Кодировка: 1-закодировано, 0-нормальная видимость 
    l_header := l_header || chr(0);
    --№16-27 Использование многопользовательского окружения
    l_header := l_header || rpad(chr(0), 12, chr(0));
    --№28 Использование индекса 0-не использовать
    l_header := l_header || chr(0);
    --№29 Номер драйвера языка
    l_header := l_header || chr(3);
    --№30,31 Зарезервировано
    l_header := l_header || rpad(chr(0), 2, chr(0));
    --ОПИСАНИЯ ПОЛЕЙ В ЗАГОЛОВКЕ
    for i in c_columns loop
      --№0-10 Имя поля с 0-завершением/11 байт
      l_header := l_header ||
                  rpad(substr(i.column_name, 1, 10), 11, chr(0));
      --№11 Тип поля/1 байт
      l_header := l_header || i.data_type;
      --№12,13,14,15 Игнорируется/4 байта
      l_header := l_header || rpad(chr(0), 4, chr(0));
      --№16 Размер поля/1 байт
      l_header := l_header || chr(i.data_length);
      --№17 Количество знаков после запятой/1 байт
      l_header := l_header || chr(i.data_scale);
      --№18,19 Зарезервированная область/2 байта
      l_header := l_header || rpad(chr(0), 2, chr(0));
      --№20 Идентификатор рабочей области/1 байт
      l_header := l_header || chr(0);
      --№21,22 Многопользовательский dBase/2 байта
      l_header := l_header || rpad(chr(0), 2, chr(0));
      --№23 Установленные поля/1 байт
      l_header := l_header || chr(1);
      --№24 Зарезервировано/7 байт
      l_header := l_header || rpad(chr(0), 7, chr(0));
      --№31 Флаг MDX-поля: 01H если поле имеет метку индекса в MDX-файле, 00H - нет.
      l_header := l_header || chr(0);
    end loop;
    --Завершающий заголовок символ 0D
    l_header := l_header || chr(13);
    dbms_lob.createtemporary(l_blob, true);
    for i in 1 .. trunc(length(l_header) / 2000) + 1 loop
      dbms_lob.append(l_blob,
                      utl_raw.cast_to_raw(substr(l_header, 1, 2000)));
      l_header := substr(l_header, 2000);
    end loop;
--v_select := 'SELECT CONVERT(rpad(substr(nplat,1,10) ,10)||rpad(substr(to_char(sysdate,''yyyymmdd''),1,8) ,8)||rpad(substr(upper(text_firma(okpon,0)),1,38) ,38)||rpad(substr(to_char(okpon),1,12) ,12)||rpad(substr(upper(text_bank(mfon,filn)),1,38) ,38)||rpad(substr(to_char(mfon),1,9) ,9)||rpad(substr(to_char(rshetn),1,14) ,14)||rpad(substr(upper(text_firma(okpop,0)),1,38) ,38)||rpad(substr((to_char(lpad(to_char(okpop),10,''0''))),1,12) ,12)||rpad(substr(upper(text_bank(mfop,filp)),1,38) ,38)||rpad(substr(to_char(mfop),1,9) ,9)||rpad(substr(to_char(rshetp),1,14) ,14)||rpad(substr(to_char(decode(pval,0,980,3,643,4,974) ),1,3) ,3)||rpad(substr(decode(pval,0,to_char(nvl(suman,0),''9999999999999999.00''),to_char(0,''9'')),1,20) ,20)||rpad(substr(decode(pval,0,to_char(0,''9''),to_char(nvl(suman,0),''9999999999999999.00'')),1,20) ,20)||rpad(upper(substr(trim(prim)||'' ''||trim(prim3)||'' ''||trim(prim1),1,160)) ,160)||rpad(substr(to_char(to_date2(datp,''yyyymmdd''),''yyyymmdd''),1,8) ,8),''CL8MSWIN1251'')'
--||' FROM poruch where nvl(priz,0)=3 and mfon=335957 and polz like '''||polzz||'''';
--work v_select := 'SELECT CONVERT(rpad(substr(nplat,1,10) ,10)||rpad(substr(to_char(sysdate,''yyyymmdd''),1,8) ,8)||rpad(substr(upper(text_firma(okpon,0)),1,38) ,38)||rpad(substr(to_char(okpon),1,12) ,12)||rpad(substr(upper(text_bank(mfon,filn)),1,38) ,38)||rpad(substr(to_char(mfon),1,9) ,9)||rpad(substr(to_char(rshetn),1,14) ,14)||rpad(substr(upper(text_firma(okpop,0)),1,38) ,38)||rpad(substr(lpad(to_char(okpop),8,''0''),1,12) ,12)||rpad(substr(upper(text_bank(mfop,filp)),1,38) ,38)||rpad(substr(to_char(mfop),1,9) ,9)||rpad(substr(to_char(rshetp),1,14) ,14)||rpad(substr(to_char(decode(pval,0,980,3,643,4,974) ),1,3) ,3)||rpad(substr(decode(pval,0,to_char(nvl(suman,0),''9999999999999999.00''),to_char(0,''9'')),1,20) ,20)||rpad(substr(decode(pval,0,to_char(0,''9''),to_char(nvl(suman,0),''9999999999999999.00'')),1,20) ,20)||rpad(upper(substr(trim(prim)||'' ''||trim(prim3)||'' ''||trim(prim1),1,160)) ,160)||rpad(substr(to_char(to_date2(datp,''yyyymmdd''),''yyyymmdd''),1,8) ,8),''CL8MSWIN1251'')'
--||' FROM poruch where nvl(priz,0)=3 and mfon=335957 and polz like '''||polzz||'''';
v_select := 'SELECT CONVERT(rpad(substr(nplat,1,10) ,10)||rpad(substr(to_char(sysdate,''yyyymmdd''),1,8) ,8)||rpad(substr(upper(text_firma(okpon,0)),1,38) ,38)||rpad(substr(to_char(okpon),1,12) ,12)||rpad(substr(upper(text_bank(mfon,filn)),1,38) ,38)||rpad(substr(to_char(mfon),1,9) ,9)||rpad(substr(to_char(rshetn),1,14) ,14)||rpad(substr(upper(text_firma(okpop,0)),1,38) ,38)||decode(length(okpop),9,rpad(substr(lpad(to_char(okpop),10,''0''),1,12) ,12),10,rpad(substr(lpad(to_char(okpop),10,''0''),1,12) ,12),rpad(substr(lpad(to_char(okpop),8,''0''),1,12) ,12) )||rpad(substr(nvl(bank_name,upper(text_bank(mfop,filp))),1,38) ,38)||rpad(substr(to_char(nvl(mfo_new,mfop)),1,9) ,9)||rpad(substr(to_char(nvl(schet_new,rshetp)),1,14) ,14)||rpad(substr(to_char(decode(nvl(pval,0),0,980,3,643,4,974) ),1,3) ,3)||rpad(substr(decode(nvl(pval,0),0,to_char(nvl(suman,0),''9999999999999999.00''),to_char(0,''9'')),1,20) ,20)||rpad(substr(decode(nvl(pval,0),0,to_char(0,''9''),to_char(nvl(suman,0),''9999999999999999.00'')),1,20) ,20)||rpad(upper(substr(trim(prim)||'' ''||trim(prim3)||'' ''||trim(prim1),1,160)) ,160)||rpad(substr(to_char(to_date2(datp,''yyyymmdd''),''yyyymmdd''),1,8) ,8),''CL8MSWIN1251'')'
||' FROM poruch where nvl(priz,0)='||pr||' and mfon=335957 and polz like '''||polzz||'''';

--v_select := 'SELECT CONVERT(rpad(substr(nplat,1,10) ,10)||rpad(substr(text_firma(okpon,0),1,38) ,38)||rpad(substr(to_char(okpon),1,12) ,12)||rpad(substr(text_bank(mfon,filn),1,38) ,38)||rpad(substr(to_char(mfon),1,38) ,38)||rpad(substr(to_char(rshetn),1,14) ,14)||rpad(substr(text_firma(okpop,0),1,38) ,38)||rpad(substr(to_char(okpop),1,12) ,12)||rpad(substr(text_bank(mfop,filp),1,38) ,38)||rpad(substr(to_char(mfop),1,38) ,38)||rpad(substr(to_char(rshetp),1,14) ,14)||rpad(substr(to_char(decode(pval,0,980,3,643,4,974) ),1,3) ,3)||rpad(substr(prim,1,160) ,160),''CL8MSWIN1251'')'
--||' FROM poruch where datp=20081112 and polz like ''укс%''';

    open all_columns for v_select;
    fetch all_columns
      into l_columns;
    while all_columns%found loop
      -- Символ CHR (32) обозначает, что записи не удалены
      l_lines := chr(32) || l_columns;
      dbms_lob.append(l_blob, utl_raw.cast_to_raw(l_lines));
      fetch all_columns
        into l_columns;
    end loop;
    --Символ-метка конца записи
    dbms_lob.append(l_blob, utl_raw.cast_to_raw(chr(26)));
    return l_blob;
    dbms_lob.freetemporary(l_blob);
  
END create_dbf_for_335957;


-- кредитпромбанк 335593
function create_dbf_for_335593(polzz varchar2, pr number) return blob is
   l_result varchar2(4000);
   l_column varchar2(4000);
    
    l_columns   varchar2(32767);
    l_blob      blob;
    l_header    varchar2(32767);
    all_columns sys_refcursor;
    v_select    varchar2(32767);
    l_lines     varchar2(32767);
    l_number_of_columns binary_integer;
    l_line_length       binary_integer;
    l_number_of_records number;
    cursor c_columns is
    select column_name,data_type,data_length,data_scale
    from 
    (
    select 'ORGDATE' COLUMN_NAME,'D' DATA_TYPE, 8 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'NOM' COLUMN_NAME,'C' DATA_TYPE, 10 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'SUMMA' COLUMN_NAME,'N' DATA_TYPE, 19 DATA_LENGTH, 2 DATA_SCALE from dual UNION ALL
    select 'CRNID' COLUMN_NAME,'N' DATA_TYPE, 3 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'DEBACC' COLUMN_NAME,'C' DATA_TYPE, 32 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'CRDMFO' COLUMN_NAME,'N' DATA_TYPE, 6 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'CRDACC' COLUMN_NAME,'C' DATA_TYPE, 32 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'CRDACCNAME' COLUMN_NAME,'C' DATA_TYPE, 38 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'CRDCLICODE' COLUMN_NAME,'C' DATA_TYPE, 10 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'NOTE' COLUMN_NAME,'C' DATA_TYPE, 160 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'ACTION' COLUMN_NAME,'C' DATA_TYPE, 4 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'CTRL' COLUMN_NAME,'C' DATA_TYPE, 10 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'KIND' COLUMN_NAME,'C' DATA_TYPE, 10 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'NOTES' COLUMN_NAME,'C' DATA_TYPE, 160 DATA_LENGTH, 0 DATA_SCALE from dual  
    );
    
  begin
    l_number_of_columns:=14;
    l_line_length:=503;
   
    select count(*) into l_number_of_records from poruch where nvl(priz,0)=pr and polz like polzz and mfon=335593;
    --ЗАГОЛОВОК
    --№ - номер байта
    -- №0 Версия/ 1 байт
    -- 03 - простая таблица
    l_header := chr(3);
    -- №1,2,3 Дата последнего обновления таблицы в формате YYMMDD/ 3 байта
    l_header := l_header || chr(100+to_number(to_char(sysdate, 'YY'))) ||
                chr(to_number(to_char(sysdate, 'MM'))) ||
                chr(to_number(to_char(sysdate, 'DD')));
    --№4,5,6,7 Количество записей в таблице/ 32 бита = 4 байта
    l_header := l_header ||
                rpad(to_ascii(l_number_of_records), 4, chr(0));
    --№8,9 Количество байтов, занимаемых заголовком
    --/16 бит = 2 байта = 32 + 32*n + 1, где n - количество столбцов
    -- а 1 - ограничительный байт 
    l_header := l_header ||
                rpad(to_ascii(32 + l_number_of_columns * 32 + 1),
                     2,
                     chr(0));
    --№10,11 Количество байтов, занимаемых записью/16 бит = 2 байта 
    l_header := l_header || rpad(to_ascii(to_number(to_char(l_line_length,'XXXX'),'XXXX')), 2, chr(0));
    --№12,13 Зарезервировано
    l_header := l_header || rpad(chr(0), 2, chr(0));
    --№14 Транзакция, 1-начало, 0-конец(завершена)
    l_header := l_header || chr(0);
    --№15 Кодировка: 1-закодировано, 0-нормальная видимость 
    l_header := l_header || chr(0);
    --№16-27 Использование многопользовательского окружения
    l_header := l_header || rpad(chr(0), 12, chr(0));
    --№28 Использование индекса 0-не использовать
    l_header := l_header || chr(0);
    --№29 Номер драйвера языка
    l_header := l_header || chr(ascii('W')); --chr(3);
    --№30,31 Зарезервировано
    l_header := l_header || rpad(chr(0), 2, chr(0));
    --ОПИСАНИЯ ПОЛЕЙ В ЗАГОЛОВКЕ
    for i in c_columns loop
      --№0-10 Имя поля с 0-завершением/11 байт
      l_header := l_header ||
                  rpad(substr(i.column_name, 1, 10), 11, chr(0));
      --№11 Тип поля/1 байт
      l_header := l_header || i.data_type;
      --№12,13,14,15 Игнорируется/4 байта
      l_header := l_header || rpad(chr(0), 4, chr(0));
      --№16 Размер поля/1 байт
      l_header := l_header || chr(i.data_length);
      --№17 Количество знаков после запятой/1 байт
      l_header := l_header || chr(i.data_scale);
      --№18,19 Зарезервированная область/2 байта
      l_header := l_header || rpad(chr(0), 2, chr(0));
      --№20 Идентификатор рабочей области/1 байт
      l_header := l_header || chr(0);
      --№21,22 Многопользовательский dBase/2 байта
      l_header := l_header || rpad(chr(0), 2, chr(0));
      --№23 Установленные поля/1 байт
      l_header := l_header || chr(0);--chr(1);
      --№24 Зарезервировано/7 байт
      l_header := l_header || rpad(chr(0), 7, chr(0));
      --№31 Флаг MDX-поля: 01H если поле имеет метку индекса в MDX-файле, 00H - нет.
      l_header := l_header || chr(0);
    end loop;
    --Завершающий заголовок символ 0D
    l_header := l_header || chr(13);
    dbms_lob.createtemporary(l_blob, true);
    for i in 1 .. trunc(length(l_header) / 2000) + 1 loop
      dbms_lob.append(l_blob,
                      utl_raw.cast_to_raw(substr(l_header, 1, 2000)));
      l_header := substr(l_header, 2000);
    end loop;
v_select := 'SELECT CONVERT(rpad(substr(to_char(to_date2(datp,''yyyymmdd''),''yyyymmdd''),1,8) ,8)||rpad(substr(nplat,1,10) ,10)||rpad(substr(decode(pval,0,to_char(nvl(suman,0),''999999999999999.00''),to_char(0,''9'')),1,19) ,19)||lpad(substr(to_char(pval),1,3) ,3)||rpad(substr(to_char(rshetn),1,32) ,32)||rpad(substr(to_char(nvl(mfo_new,mfop)),1,6) ,6)||rpad(substr(to_char(nvl(schet_new,rshetp)),1,32) ,32)||rpad(substr(upper(text_firma(okpop,0)),1,38) ,38)||rpad(substr(  decode(length(okpop),9,to_char(okpop),10,okpop, to_char(lpad(okpop,8,0)))  ,1,10) ,10)||rpad(substr(trim(prim)||'' ''||trim(prim3)||'' ''||trim(prim1),1,160) ,160)||rpad(substr('' '',1,4) ,4)||rpad(substr('' '',1,10) ,10)||rpad(substr('' '',1,10) ,10)||rpad(substr('' '',1,160) ,160) ,''CL8MSWIN1251'')'
||' FROM poruch where nvl(priz,0)='||pr||' and mfon=335593 and polz like '''||polzz||''''; --RU8PC866
--v_select := 'SELECT CONVERT(rpad(substr(nplat,1,10) ,10)||rpad(substr(text_firma(okpon,0),1,38) ,38)||rpad(substr(to_char(okpon),1,12) ,12)||rpad(substr(text_bank(mfon,filn),1,38) ,38)||rpad(substr(to_char(mfon),1,38) ,38)||rpad(substr(to_char(rshetn),1,14) ,14)||rpad(substr(text_firma(okpop,0),1,38) ,38)||rpad(substr(to_char(okpop),1,12) ,12)||rpad(substr(text_bank(mfop,filp),1,38) ,38)||rpad(substr(to_char(mfop),1,38) ,38)||rpad(substr(to_char(rshetp),1,14) ,14)||rpad(substr(to_char(decode(pval,0,980,3,643,4,974) ),1,3) ,3)||rpad(substr(prim,1,160) ,160),''CL8MSWIN1251'')'
--||' FROM poruch where datp=20081112 and polz like ''укс%''';

    open all_columns for v_select;
    fetch all_columns
      into l_columns;
    while all_columns%found loop
      -- Символ CHR (32) обозначает, что записи не удалены
      l_lines := chr(32) || l_columns;
      dbms_lob.append(l_blob, utl_raw.cast_to_raw(l_lines));
      fetch all_columns
        into l_columns;
    end loop;
    --Символ-метка конца записи
    dbms_lob.append(l_blob, utl_raw.cast_to_raw(chr(26)));
    return l_blob;
    dbms_lob.freetemporary(l_blob);
  
END create_dbf_for_335593;

--334970 - донгорбанк
function create_dbf_for_334970(polzz varchar2, pr number) return blob is
    l_result varchar2(4000);
    l_column varchar2(4000);
    l_columns   varchar2(32767);
    l_blob      blob;
    l_header    varchar2(32767);
    all_columns sys_refcursor;
    v_select    varchar2(32767);
    l_lines     varchar2(32767);
    l_number_of_columns binary_integer;
    l_line_length       binary_integer;
    l_number_of_records number;
    aaa varchar2(32767); i integer;
 /*   cursor c_columns is
    select column_name,data_type,data_length,data_scale
    from 
    (
    select 'CODE' COLUMN_NAME,'C' DATA_TYPE, 3 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'ACCCLI' COLUMN_NAME,'N' DATA_TYPE, 14 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'MFOCLI' COLUMN_NAME,'N' DATA_TYPE, 6 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'OKPOCLI' COLUMN_NAME,'N' DATA_TYPE, 10 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'NAMECLI' COLUMN_NAME,'C' DATA_TYPE, 38 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'BANKCLI' COLUMN_NAME,'C' DATA_TYPE, 38 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'ACCCOR' COLUMN_NAME,'N' DATA_TYPE, 14 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'MFOCOR' COLUMN_NAME,'N' DATA_TYPE, 6 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'OKPOCOR' COLUMN_NAME,'N' DATA_TYPE, 10 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'NAMECOR' COLUMN_NAME,'C' DATA_TYPE, 38 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'BANKCOR' COLUMN_NAME,'C' DATA_TYPE, 38 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'NDOC' COLUMN_NAME,'C' DATA_TYPE, 10 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'SUMMA' COLUMN_NAME,'N' DATA_TYPE, 16 DATA_LENGTH, 2 DATA_SCALE from dual UNION ALL
    select 'NAZN' COLUMN_NAME,'C' DATA_TYPE, 160 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'DV' COLUMN_NAME,'D' DATA_TYPE, 8 DATA_LENGTH, 0 DATA_SCALE from dual 
    ); */
    
  begin
    l_number_of_columns:=15;
    l_line_length:=410;--407;
   
    select count(*) into l_number_of_records from poruch where nvl(priz,0)=pr and polz like polzz and mfon in (334970, 334851);
    --ЗАГОЛОВОК
    --№ - номер байта
    -- №0 Версия/ 1 байт
    -- 03 - простая таблица
    l_header := chr(3);
    -- №1,2,3 Дата последнего обновления таблицы в формате YYMMDD/ 3 байта
    l_header := l_header || chr(100+to_number(to_char(sysdate, 'YY'))) ||
                chr(to_number(to_char(sysdate, 'MM'))) ||
                chr(to_number(to_char(sysdate, 'DD')));
    --№4,5,6,7 Количество записей в таблице/ 32 бита = 4 байта
    l_header := l_header ||
                rpad(to_ascii(l_number_of_records), 4, chr(0));
    --№8,9 Количество байтов, занимаемых заголовком
    --/16 бит = 2 байта = 32 + 32*n + 1, где n - количество столбцов
    -- а 1 - ограничительный байт 
    l_header := l_header ||
                rpad(to_ascii(32 + l_number_of_columns * 32 + 1),
                     2,
                     chr(0));
    --№10,11 Количество байтов, занимаемых записью/16 бит = 2 байта 
    l_header := l_header || rpad(to_ascii(to_number(to_char(l_line_length,'XXXX'),'XXXX')), 2, chr(0));
    --№12,13 Зарезервировано
    l_header := l_header || rpad(chr(0), 2, chr(0));
    --№14 Транзакция, 1-начало, 0-конец(завершена)
    l_header := l_header || chr(0);
    --№15 Кодировка: 1-закодировано, 0-нормальная видимость 
    l_header := l_header || chr(0);
    --№16-27 Использование многопользовательского окружения
    l_header := l_header || rpad(chr(0), 12, chr(0));
    --№28 Использование индекса 0-не использовать
    l_header := l_header || chr(0);
    --№29 Номер драйвера языка
    l_header := l_header ||chr(0); --chr(3);
    --№30,31 Зарезервировано
    l_header := l_header || rpad(chr(0), 2, chr(0));
    --ОПИСАНИЯ ПОЛЕЙ В ЗАГОЛОВКЕ
 /*   for i in c_columns loop
      --№0-10 Имя поля с 0-завершением/11 байт
      l_header := l_header ||
                  rpad(substr(i.column_name, 1, 10), 11, chr(0));
      --№11 Тип поля/1 байт
      l_header := l_header || i.data_type;
      --№12,13,14,15 Игнорируется/4 байта
      l_header := l_header || rpad(chr(0), 4, chr(0));
      --№16 Размер поля/1 байт
      l_header := l_header || chr(i.data_length);
      --№17 Количество знаков после запятой/1 байт
      l_header := l_header || chr(i.data_scale);
      --№18,19 Зарезервированная область/2 байта
      l_header := l_header || rpad(chr(0), 2, chr(0));
      --№20 Идентификатор рабочей области/1 байт
      l_header := l_header || chr(0);
      --№21,22 Многопользовательский dBase/2 байта
      l_header := l_header || rpad(chr(0), 2, chr(0));
      --№23 Установленные поля/1 байт
      l_header := l_header || chr(0);--chr(1);
      --№24 Зарезервировано/7 байт
      l_header := l_header || rpad(chr(0), 7, chr(0));
      --№31 Флаг MDX-поля: 01H если поле имеет метку индекса в MDX-файле, 00H - нет.
      l_header := l_header || chr(0);
    end loop;
   */

aaa:='43 4F 44 45 00 00 00 00 00 00 00 43 01 00 00 00 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 41 43 43 43 4C 49 00 00 00 00 00 4E 04 00 00 00 0E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4D 46 4F 43 4C 49 00 00 00 00 00 4E 12 00 00 00 06 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4F 4B 50 4F 43 4C 49 00 00 00 00 4E 18 00 00 00 0A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4E 41 4D 45 43 4C 49 00 00 00 00 43 22 00 00 00 26 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42 41 4E 4B 43 4C 49 00 00 00 00 43 48 00 00 00 26 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 41 43 43 43 4F 52 00 00 00 00 00 4E 6E 00 00 00 0E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4D 46 4F 43 4F 52 00 00 00 00 00 4E 7C 00 00 00 06 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4F 4B 50 4F 43 4F 52 00 00 00 00 4E 82 00 00 00 0A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4E 41 4D 45 43 4F 52 00 00 00 00 43 8C 00 00 00 26 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42 41 4E 4B 43 4F 52 00 00 00 00 43 B2 00 00 00 26 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4E 44 4F 43 00 00 00 00 00 00 00 43 D8 00 00 00 0A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 53 55 4D 4D 41 00 00 00 00 00 00 4E E2 00 00 00 10 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4E 41 5A 4E 00 00 00 00 00 00 00 43 F2 00 00 00 A0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 44 56 00 00 00 00 00 00 00 00 00 44 92 01 00 00 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00';
FOR i IN 1..480 LOOP
  l_header := l_header ||chr(to_number(REGEXP_substr(aaa,'[^ ]+',1,i),'XX'));
  END LOOP;

    --Завершающий заголовок символ 0D
    l_header := l_header || chr(13);
    dbms_lob.createtemporary(l_blob, true);
    for i in 1 .. trunc(length(l_header) / 2000) + 1 loop
      dbms_lob.append(l_blob,
                      utl_raw.cast_to_raw(substr(l_header, 1, 2000)));
      l_header := substr(l_header, 2000);
    end loop;
--v_select := 'SELECT CONVERT(to_number(rshetn,''99999999999999'')||rpad(substr(to_char(mfon,''999999''),1,6) ,6)||rpad(substr(to_char(okpon,''999999999999''),1,12) ,12)||rpad(substr(text_firma(okpon,0),1,38) ,38)||rpad(substr(text_bank(mfon,filn),1,38) ,38)||rpad(substr(to_char(to_number(rshetp,''99999999999999''),''99999999999999''),1,14) ,14)||rpad(substr(to_char(mfop,''999999''),1,6) ,6)||rpad(substr(to_char(okpop,''999999999999''),1,12) ,12)||rpad(substr(text_firma(okpop,0),1,38) ,38)||rpad(substr(text_bank(mfop,filp),1,38) ,38)||rpad(substr(to_char(nplat),1,10) ,10)||rpad(substr(decode(pval,0,to_char(nvl(suman,0),''99999999999999.00''),to_char(0,''9'')),1,16) ,16)||rpad(substr(prim,1,160) ,160)||rpad(substr(to_char(to_date2(datp,''yyyymmdd''),''yyyymmdd''),1,8) ,8),''CL8MSWIN1251'')'
--||' FROM poruch where nvl(priz,0)=3 and mfon=334970 and polz like '''||polzz||'''';
--v_select := 'SELECT CONVERT(,''CL8MSWIN1251'')'
--||' FROM poruch where nvl(priz,0)=3 and mfon=334970 and polz like '''||polzz||'''';

v_select := 'SELECT CONVERT(rpad(''Win'',3)||lpad(trim(rshetn),14)||rpad(substr(to_char(mfon),1,6) ,6)||lpad(to_char(okpon),10)||rpad(substr(upper(text_firma(okpon,nvl(dpidn,0))),1,38) ,38)||rpad(substr(upper(text_bank(mfon,filn)),1,38) ,38)||lpad(trim(nvl(schet_new,rshetp)),14)||rpad(substr(to_char(nvl(mfo_new,mfop)),1,6) ,6)||lpad(to_char(okpop),10)||rpad(substr(upper(text_firma(okpop,nvl(dpidp,0))),1,38) ,38)||rpad(substr(nvl(bank_name,upper(text_bank(mfop,filp))),1,38) ,38)||rpad(substr(to_char(nplat),1,10) ,10)||rpad(substr(decode(nvl(pval,0),0,to_char(nvl(suman,0),''999999999999.00''),to_char(0,''9'')),1,16) ,16)||rpad(substr(trim(prim)||'' ''||trim(prim3)||'' ''||trim(prim1),1,160) ,160)||rpad(substr(''        '',1,8) ,8),''CL8MSWIN1251'')'
||' FROM poruch where nvl(priz,0)='||pr||' and mfon in (334970, 334851) and polz like '''||polzz||'''';
--||rpad(substr(to_char(to_number(rshetp),''9999999999999''),1,14) ,14)||rpad(substr(to_char(mfop),1,6) ,6)||rpad(substr(to_char(okpop),1,10) ,10)||rpad(substr(text_firma(okpop,0),1,38) ,38)||rpad(substr(text_bank(mfop,filp),1,38) ,38)||rpad(substr(to_char(nplat),1,10) ,10)
    open all_columns for v_select;
    fetch all_columns
      into l_columns;
    while all_columns%found loop
      -- Символ CHR (32) обозначает, что записи не удалены
      l_lines := chr(32) || l_columns;
      dbms_lob.append(l_blob, utl_raw.cast_to_raw(l_lines));
      fetch all_columns
        into l_columns;
    end loop;
    --Символ-метка конца записи
    dbms_lob.append(l_blob, utl_raw.cast_to_raw(chr(26)));
    return l_blob;
    dbms_lob.freetemporary(l_blob);
  
END create_dbf_for_334970;

function create_dbf_for_334970_change(polzz varchar2, pr number) return blob is
    l_result varchar2(4000);
    l_column varchar2(4000);
    l_columns   varchar2(32767);
    l_blob      blob;
    l_header    varchar2(32767);
    all_columns sys_refcursor;
    v_select    varchar2(32767);
    l_lines     varchar2(32767);
    l_number_of_columns binary_integer;
    l_line_length       binary_integer;
    l_number_of_records number;
    aaa varchar2(32767); i integer;
 /*   cursor c_columns is
    select column_name,data_type,data_length,data_scale
    from 
    (
    select 'CODE' COLUMN_NAME,'C' DATA_TYPE, 3 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'ACCCLI' COLUMN_NAME,'N' DATA_TYPE, 14 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'MFOCLI' COLUMN_NAME,'N' DATA_TYPE, 6 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'OKPOCLI' COLUMN_NAME,'N' DATA_TYPE, 10 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'NAMECLI' COLUMN_NAME,'C' DATA_TYPE, 38 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'BANKCLI' COLUMN_NAME,'C' DATA_TYPE, 38 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'ACCCOR' COLUMN_NAME,'N' DATA_TYPE, 14 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'MFOCOR' COLUMN_NAME,'N' DATA_TYPE, 6 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'OKPOCOR' COLUMN_NAME,'N' DATA_TYPE, 10 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'NAMECOR' COLUMN_NAME,'C' DATA_TYPE, 38 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'BANKCOR' COLUMN_NAME,'C' DATA_TYPE, 38 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'NDOC' COLUMN_NAME,'C' DATA_TYPE, 10 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'SUMMA' COLUMN_NAME,'N' DATA_TYPE, 16 DATA_LENGTH, 2 DATA_SCALE from dual UNION ALL
    select 'NAZN' COLUMN_NAME,'C' DATA_TYPE, 160 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'DV' COLUMN_NAME,'D' DATA_TYPE, 8 DATA_LENGTH, 0 DATA_SCALE from dual 
    ); */
    
  begin
    l_number_of_columns:=15;
    l_line_length:=410;--407;
   
    select count(*) into l_number_of_records from poruch where nvl(priz,0)=pr and polz like polzz and mfon in (334970, 334851);
    --ЗАГОЛОВОК
    --№ - номер байта
    -- №0 Версия/ 1 байт
    -- 03 - простая таблица
    l_header := chr(3);
    -- №1,2,3 Дата последнего обновления таблицы в формате YYMMDD/ 3 байта
    l_header := l_header || chr(100+to_number(to_char(sysdate, 'YY'))) ||
                chr(to_number(to_char(sysdate, 'MM'))) ||
                chr(to_number(to_char(sysdate, 'DD')));
    --№4,5,6,7 Количество записей в таблице/ 32 бита = 4 байта
    l_header := l_header ||
                rpad(to_ascii(l_number_of_records), 4, chr(0));
    --№8,9 Количество байтов, занимаемых заголовком
    --/16 бит = 2 байта = 32 + 32*n + 1, где n - количество столбцов
    -- а 1 - ограничительный байт 
    l_header := l_header ||
                rpad(to_ascii(32 + l_number_of_columns * 32 + 1),
                     2,
                     chr(0));
    --№10,11 Количество байтов, занимаемых записью/16 бит = 2 байта 
    l_header := l_header || rpad(to_ascii(to_number(to_char(l_line_length,'XXXX'),'XXXX')), 2, chr(0));
    --№12,13 Зарезервировано
    l_header := l_header || rpad(chr(0), 2, chr(0));
    --№14 Транзакция, 1-начало, 0-конец(завершена)
    l_header := l_header || chr(0);
    --№15 Кодировка: 1-закодировано, 0-нормальная видимость 
    l_header := l_header || chr(0);
    --№16-27 Использование многопользовательского окружения
    l_header := l_header || rpad(chr(0), 12, chr(0));
    --№28 Использование индекса 0-не использовать
    l_header := l_header || chr(0);
    --№29 Номер драйвера языка
    l_header := l_header ||chr(0); --chr(3);
    --№30,31 Зарезервировано
    l_header := l_header || rpad(chr(0), 2, chr(0));
    --ОПИСАНИЯ ПОЛЕЙ В ЗАГОЛОВКЕ
 /*   for i in c_columns loop
      --№0-10 Имя поля с 0-завершением/11 байт
      l_header := l_header ||
                  rpad(substr(i.column_name, 1, 10), 11, chr(0));
      --№11 Тип поля/1 байт
      l_header := l_header || i.data_type;
      --№12,13,14,15 Игнорируется/4 байта
      l_header := l_header || rpad(chr(0), 4, chr(0));
      --№16 Размер поля/1 байт
      l_header := l_header || chr(i.data_length);
      --№17 Количество знаков после запятой/1 байт
      l_header := l_header || chr(i.data_scale);
      --№18,19 Зарезервированная область/2 байта
      l_header := l_header || rpad(chr(0), 2, chr(0));
      --№20 Идентификатор рабочей области/1 байт
      l_header := l_header || chr(0);
      --№21,22 Многопользовательский dBase/2 байта
      l_header := l_header || rpad(chr(0), 2, chr(0));
      --№23 Установленные поля/1 байт
      l_header := l_header || chr(0);--chr(1);
      --№24 Зарезервировано/7 байт
      l_header := l_header || rpad(chr(0), 7, chr(0));
      --№31 Флаг MDX-поля: 01H если поле имеет метку индекса в MDX-файле, 00H - нет.
      l_header := l_header || chr(0);
    end loop;
   */

aaa:='43 4F 44 45 00 00 00 00 00 00 00 43 01 00 00 00 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 41 43 43 43 4C 49 00 00 00 00 00 4E 04 00 00 00 0E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4D 46 4F 43 4C 49 00 00 00 00 00 4E 12 00 00 00 06 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4F 4B 50 4F 43 4C 49 00 00 00 00 4E 18 00 00 00 0A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4E 41 4D 45 43 4C 49 00 00 00 00 43 22 00 00 00 26 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42 41 4E 4B 43 4C 49 00 00 00 00 43 48 00 00 00 26 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 41 43 43 43 4F 52 00 00 00 00 00 4E 6E 00 00 00 0E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4D 46 4F 43 4F 52 00 00 00 00 00 4E 7C 00 00 00 06 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4F 4B 50 4F 43 4F 52 00 00 00 00 4E 82 00 00 00 0A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4E 41 4D 45 43 4F 52 00 00 00 00 43 8C 00 00 00 26 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42 41 4E 4B 43 4F 52 00 00 00 00 43 B2 00 00 00 26 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4E 44 4F 43 00 00 00 00 00 00 00 43 D8 00 00 00 0A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 53 55 4D 4D 41 00 00 00 00 00 00 4E E2 00 00 00 10 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4E 41 5A 4E 00 00 00 00 00 00 00 43 F2 00 00 00 A0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 44 56 00 00 00 00 00 00 00 00 00 44 92 01 00 00 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00';
FOR i IN 1..480 LOOP
  l_header := l_header ||chr(to_number(REGEXP_substr(aaa,'[^ ]+',1,i),'XX'));
  END LOOP;

    --Завершающий заголовок символ 0D
    l_header := l_header || chr(13);
    dbms_lob.createtemporary(l_blob, true);
    for i in 1 .. trunc(length(l_header) / 2000) + 1 loop
      dbms_lob.append(l_blob,
                      utl_raw.cast_to_raw(substr(l_header, 1, 2000)));
      l_header := substr(l_header, 2000);
    end loop;
--v_select := 'SELECT CONVERT(to_number(rshetn,''99999999999999'')||rpad(substr(to_char(mfon,''999999''),1,6) ,6)||rpad(substr(to_char(okpon,''999999999999''),1,12) ,12)||rpad(substr(text_firma(okpon,0),1,38) ,38)||rpad(substr(text_bank(mfon,filn),1,38) ,38)||rpad(substr(to_char(to_number(rshetp,''99999999999999''),''99999999999999''),1,14) ,14)||rpad(substr(to_char(mfop,''999999''),1,6) ,6)||rpad(substr(to_char(okpop,''999999999999''),1,12) ,12)||rpad(substr(text_firma(okpop,0),1,38) ,38)||rpad(substr(text_bank(mfop,filp),1,38) ,38)||rpad(substr(to_char(nplat),1,10) ,10)||rpad(substr(decode(pval,0,to_char(nvl(suman,0),''99999999999999.00''),to_char(0,''9'')),1,16) ,16)||rpad(substr(prim,1,160) ,160)||rpad(substr(to_char(to_date2(datp,''yyyymmdd''),''yyyymmdd''),1,8) ,8),''CL8MSWIN1251'')'
--||' FROM poruch where nvl(priz,0)=3 and mfon=334970 and polz like '''||polzz||'''';
--v_select := 'SELECT CONVERT(,''CL8MSWIN1251'')'
--||' FROM poruch where nvl(priz,0)=3 and mfon=334970 and polz like '''||polzz||'''';

v_select := 'SELECT CONVERT(rpad(''Win'',3)||lpad(trim(rshetn),14)||rpad(substr(to_char(mfon),1,6) ,6)||lpad(to_char(lpad(okpon,8,''0'')),10)||rpad(substr(upper(text_firma(okpon,nvl(dpidn,0))),1,38) ,38)||rpad(substr(upper(text_bank(mfon,filn)),1,38) ,38)||lpad(trim(nvl(schet_new,rshetp)),14)||rpad(substr(to_char(nvl(mfo_new,mfop)),1,6) ,6)||lpad(to_char(lpad(okpop,8,''0'')),10)||rpad(substr(upper(text_firma(okpop,nvl(dpidp,0))),1,38) ,38)||rpad(substr(nvl(bank_name,upper(text_bank(mfop,filp))),1,38) ,38)||rpad(substr(to_char(nplat),1,10) ,10)||rpad(substr(decode(nvl(pval,0),0,to_char(nvl(suman,0)*100,''999999999999.00''),to_char(0,''9'')),1,16) ,16)||rpad(substr(trim(prim)||'' ''||trim(prim3)||'' ''||trim(prim1),1,160) ,160)||rpad(substr(''        '',1,8) ,8),''CL8MSWIN1251'')'
||' FROM poruch where nvl(priz,0)='||pr||' and mfon in (334970, 334851) and polz like '''||polzz||'''';
--||rpad(substr(to_char(to_number(rshetp),''9999999999999''),1,14) ,14)||rpad(substr(to_char(mfop),1,6) ,6)||rpad(substr(to_char(okpop),1,10) ,10)||rpad(substr(text_firma(okpop,0),1,38) ,38)||rpad(substr(text_bank(mfop,filp),1,38) ,38)||rpad(substr(to_char(nplat),1,10) ,10)
    open all_columns for v_select;
    fetch all_columns
      into l_columns;
    while all_columns%found loop
      -- Символ CHR (32) обозначает, что записи не удалены
      l_lines := chr(32) || l_columns;
      dbms_lob.append(l_blob, utl_raw.cast_to_raw(l_lines));
      fetch all_columns
        into l_columns;
    end loop;
    --Символ-метка конца записи
    dbms_lob.append(l_blob, utl_raw.cast_to_raw(chr(26)));
    return l_blob;
    dbms_lob.freetemporary(l_blob);
  
END create_dbf_for_334970_change;

--334970 - вега, бывший донгорбанк НОКК
function create_dbf_for_334970_new_(polzz varchar2, pr number) return blob is
    l_result varchar2(4000);
    l_column varchar2(4000);
    l_columns   varchar2(32767);
    l_blob      blob;
    l_header    varchar2(32767);
    all_columns sys_refcursor;
    v_select    varchar2(32767);
    l_lines     varchar2(32767);
    l_number_of_columns binary_integer;
    l_line_length       binary_integer;
    l_number_of_records number;
    aaa varchar2(32767); i integer;
    
  begin
    l_number_of_columns:=15;
    l_line_length:=416;--407;
   
    select count(*) into l_number_of_records from poruch where nvl(priz,0)=pr and polz like polzz and mfon in (334970, 334851);
    --ЗАГОЛОВОК
    --№ - номер байта
    -- №0 Версия/ 1 байт
    -- 03 - простая таблица
    l_header := chr(3);
    -- №1,2,3 Дата последнего обновления таблицы в формате YYMMDD/ 3 байта
    l_header := l_header || chr(100+to_number(to_char(sysdate, 'YY'))) ||
                chr(to_number(to_char(sysdate, 'MM'))) ||
                chr(to_number(to_char(sysdate, 'DD')));
    --№4,5,6,7 Количество записей в таблице/ 32 бита = 4 байта
    l_header := l_header ||
                rpad(to_ascii(l_number_of_records), 4, chr(0));
    --№8,9 Количество байтов, занимаемых заголовком
    --/16 бит = 2 байта = 32 + 32*n + 1, где n - количество столбцов
    -- а 1 - ограничительный байт 
    l_header := l_header ||
                rpad(to_ascii(32 + l_number_of_columns * 32 + 1),
                     2,
                     chr(0));
    --№10,11 Количество байтов, занимаемых записью/16 бит = 2 байта 
    l_header := l_header || rpad(to_ascii(to_number(to_char(l_line_length,'XXXX'),'XXXX')), 2, chr(0));
    --№12,13 Зарезервировано
    l_header := l_header || rpad(chr(0), 2, chr(0));
    --№14 Транзакция, 1-начало, 0-конец(завершена)
    l_header := l_header || chr(0);
    --№15 Кодировка: 1-закодировано, 0-нормальная видимость 
    l_header := l_header || chr(0);
    --№16-27 Использование многопользовательского окружения
    l_header := l_header || rpad(chr(0), 12, chr(0));
    --№28 Использование индекса 0-не использовать
    l_header := l_header || chr(0);
    --№29 Номер драйвера языка
    l_header := l_header ||chr(0); --chr(3);
    --№30,31 Зарезервировано
    l_header := l_header || rpad(chr(0), 2, chr(0));
    --ОПИСАНИЯ ПОЛЕЙ В ЗАГОЛОВКЕ
 /*   for i in c_columns loop
      --№0-10 Имя поля с 0-завершением/11 байт
      l_header := l_header ||
                  rpad(substr(i.column_name, 1, 10), 11, chr(0));
      --№11 Тип поля/1 байт
      l_header := l_header || i.data_type;
      --№12,13,14,15 Игнорируется/4 байта
      l_header := l_header || rpad(chr(0), 4, chr(0));
      --№16 Размер поля/1 байт
      l_header := l_header || chr(i.data_length);
      --№17 Количество знаков после запятой/1 байт
      l_header := l_header || chr(i.data_scale);
      --№18,19 Зарезервированная область/2 байта
      l_header := l_header || rpad(chr(0), 2, chr(0));
      --№20 Идентификатор рабочей области/1 байт
      l_header := l_header || chr(0);
      --№21,22 Многопользовательский dBase/2 байта
      l_header := l_header || rpad(chr(0), 2, chr(0));
      --№23 Установленные поля/1 байт
      l_header := l_header || chr(0);--chr(1);
      --№24 Зарезервировано/7 байт
      l_header := l_header || rpad(chr(0), 7, chr(0));
      --№31 Флаг MDX-поля: 01H если поле имеет метку индекса в MDX-файле, 00H - нет.
      l_header := l_header || chr(0);
    end loop;
   */
-- aaa:='43 4F 44 45 00 00 00 00 00 00 00 43 01 00 00 00 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 41 43 43 43 4C 49 00 00 00 00 00 4E 04 00 00 00 0E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4D 46 4F 43 4C 49 00 00 00 00 00 4E 12 00 00 00 06 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4F 4B 50 4F 43 4C 49 00 00 00 00 4E 18 00 00 00 0A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4E 41 4D 45 43 4C 49 00 00 00 00 43 22 00 00 00 26 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42 41 4E 4B 43 4C 49 00 00 00 00 43 48 00 00 00 26 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 41 43 43 43 4F 52 00 00 00 00 00 4E 6E 00 00 00 0E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4D 46 4F 43 4F 52 00 00 00 00 00 4E 7C 00 00 00 06 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4F 4B 50 4F 43 4F 52 00 00 00 00 4E 82 00 00 00 0A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4E 41 4D 45 43 4F 52 00 00 00 00 43 8C 00 00 00 26 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42 41 4E 4B 43 4F 52 00 00 00 00 43 B2 00 00 00 26 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4E 44 4F 43 00 00 00 00 00 00 00 43 E0 00 00 00 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 53 55 4D 4D 41 00 00 00 00 00 00 4E F0 00 00 00 10 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4E 41 5A 4E 00 00 00 00 00 00 00 43 F2 00 00 00 A0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 44 56 00 00 00 00 00 00 00 00 00 44 92 01 00 00 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00';
--aaa:='43 4F 44 45 00 00 00 00 00 00 00 43 01 00 00 00 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 41 43 43 43 4C 49 00 00 00 00 00 4E 04 00 00 00 0E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4D 46 4F 43 4C 49 00 00 00 00 00 4E 12 00 00 00 06 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4F 4B 50 4F 43 4C 49 00 00 00 00 43 18 00 00 00 0A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4E 41 4D 45 43 4C 49 00 00 00 00 43 22 00 00 00 28 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42 41 4E 4B 43 4C 49 00 00 00 00 43 4A 00 00 00 28 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 41 43 43 43 4F 52 00 00 00 00 00 4E 72 00 00 00 0E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4D 46 4F 43 4F 52 00 00 00 00 00 4E 80 00 00 00 06 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4F 4B 50 4F 43 4F 52 00 00 00 00 43 86 00 00 00 0A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4E 41 4D 45 43 4F 52 00 00 00 00 43 90 00 00 00 28 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42 41 4E 4B 43 4F 52 00 00 00 00 43 B8 00 00 00 28 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4E 44 4F 43 00 00 00 00 00 00 00 43 E0 00 00 00 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 53 55 4D 4D 41 00 00 00 00 00 00 4E F0 00 00 00 10 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4E 41 5A 4E 00 00 00 00 00 00 00 43 00 01 00 00 A0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 44 56 00 00 00 00 00 00 00 00 00 44 A0 01 00 00 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00';
   aaa:='43 4F 44 45 00 00 00 00 00 00 00 43 01 00 00 00 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 41 43 43 43 4C 49 00 00 00 00 00 4E 04 00 00 00 0E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4D 46 4F 43 4C 49 00 00 00 00 00 4E 12 00 00 00 06 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4F 4B 50 4F 43 4C 49 00 00 00 00 43 18 00 00 00 0A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4E 41 4D 45 43 4C 49 00 00 00 00 43 22 00 00 00 26 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42 41 4E 4B 43 4C 49 00 00 00 00 43 4A 00 00 00 26 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 41 43 43 43 4F 52 00 00 00 00 00 4E 72 00 00 00 0E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4D 46 4F 43 4F 52 00 00 00 00 00 4E 80 00 00 00 06 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4F 4B 50 4F 43 4F 52 00 00 00 00 43 86 00 00 00 0A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4E 41 4D 45 43 4F 52 00 00 00 00 43 90 00 00 00 26 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42 41 4E 4B 43 4F 52 00 00 00 00 43 B8 00 00 00 26 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4E 44 4F 43 00 00 00 00 00 00 00 43 E0 00 00 00 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 53 55 4D 4D 41 00 00 00 00 00 00 4E F0 00 00 00 10 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4E 41 5A 4E 00 00 00 00 00 00 00 43 00 01 00 00 A0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 44 56 00 00 00 00 00 00 00 00 00 44 A0 01 00 00 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00';
--aaa:='43 4F 44 45 00 00 00 00 00 00 00 43 01 00 00 00 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 41 43 43 43 4C 49 00 00 00 00 00 4E 04 00 00 00 0E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4D 46 4F 43 4C 49 00 00 00 00 00 4E 12 00 00 00 06 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4F 4B 50 4F 43 4C 49 00 00 00 00 4E 18 00 00 00 0A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4E 41 4D 45 43 4C 49 00 00 00 00 43 22 00 00 00 26 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42 41 4E 4B 43 4C 49 00 00 00 00 43 48 00 00 00 26 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 41 43 43 43 4F 52 00 00 00 00 00 4E 6E 00 00 00 0E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4D 46 4F 43 4F 52 00 00 00 00 00 4E 7C 00 00 00 06 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4F 4B 50 4F 43 4F 52 00 00 00 00 4E 82 00 00 00 0A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4E 41 4D 45 43 4F 52 00 00 00 00 43 8C 00 00 00 26 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42 41 4E 4B 43 4F 52 00 00 00 00 43 B2 00 00 00 26 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4E 44 4F 43 00 00 00 00 00 00 00 43 D8 00 00 00 0A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 53 55 4D 4D 41 00 00 00 00 00 00 4E E2 00 00 00 10 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4E 41 5A 4E 00 00 00 00 00 00 00 43 F2 00 00 00 A0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 44 56 00 00 00 00 00 00 00 00 00 44 92 01 00 00 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00';
FOR i IN 1..480 LOOP
  l_header := l_header ||chr(to_number(REGEXP_substr(aaa,'[^ ]+',1,i),'XX'));
  END LOOP;

    --Завершающий заголовок символ 0D
    l_header := l_header || chr(13);
    dbms_lob.createtemporary(l_blob, true);
    for i in 1 .. trunc(length(l_header) / 2000) + 1 loop
      dbms_lob.append(l_blob,
                      utl_raw.cast_to_raw(substr(l_header, 1, 2000)));
      l_header := substr(l_header, 2000);
    end loop;
--v_select := 'SELECT CONVERT(to_number(rshetn,''99999999999999'')||rpad(substr(to_char(mfon,''999999''),1,6) ,6)||rpad(substr(to_char(okpon,''999999999999''),1,12) ,12)||rpad(substr(text_firma(okpon,0),1,38) ,38)||rpad(substr(text_bank(mfon,filn),1,38) ,38)||rpad(substr(to_char(to_number(rshetp,''99999999999999''),''99999999999999''),1,14) ,14)||rpad(substr(to_char(mfop,''999999''),1,6) ,6)||rpad(substr(to_char(okpop,''999999999999''),1,12) ,12)||rpad(substr(text_firma(okpop,0),1,38) ,38)||rpad(substr(text_bank(mfop,filp),1,38) ,38)||rpad(substr(to_char(nplat),1,10) ,10)||rpad(substr(decode(pval,0,to_char(nvl(suman,0),''99999999999999.00''),to_char(0,''9'')),1,16) ,16)||rpad(substr(prim,1,160) ,160)||rpad(substr(to_char(to_date2(datp,''yyyymmdd''),''yyyymmdd''),1,8) ,8),''CL8MSWIN1251'')'
--||' FROM poruch where nvl(priz,0)=3 and mfon=334970 and polz like '''||polzz||'''';
--v_select := 'SELECT CONVERT(,''CL8MSWIN1251'')'
--||' FROM poruch where nvl(priz,0)=3 and mfon=334970 and polz like '''||polzz||'''';

--v_select := 'SELECT CONVERT(rpad(''Win'',3)||lpad(trim(rshetn),14)||rpad(substr(to_char(mfon),1,6) ,6)||lpad(to_char(okpon),10)||rpad(substr(upper(text_firma(okpon,nvl(dpidn,0))),1,40) ,40)||rpad(substr(upper(text_bank(mfon,filn)),1,40) ,40)||lpad(trim(nvl(schet_new,rshetp)),14)||rpad(substr(to_char(nvl(mfo_new,mfop)),1,6) ,6)||lpad(to_char(okpop),10)||rpad(substr(upper(text_firma(okpop,nvl(dpidp,0))),1,40) ,40)||rpad(substr(nvl(bank_name,upper(text_bank(mfop,filp))),1,40) ,40)||rpad(substr(to_char(nplat),1,16) ,16)||rpad(substr(decode(nvl(pval,0),0,to_char(nvl(suman,0)*100,''999999999999.00''),to_char(0,''9'')),1,16) ,16)||rpad(substr(trim(prim)||'' ''||trim(prim3)||'' ''||trim(prim1),1,160) ,160)||rpad(substr(''        '',1,8) ,8),''CL8MSWIN1251'')'
--||' FROM poruch where nvl(priz,0)='||pr||' and mfon in (334970, 334851) and polz like '''||polzz||'''';
v_select := 'SELECT CONVERT(rpad(''Win'',3)||lpad(trim(rshetn),14)||rpad(substr(to_char(mfon),1,6) ,6)||lpad(to_char(lpad(okpon,8,''0'')),10)||rpad(substr(upper(text_firma(okpon,nvl(dpidn,0))),1,38) ,38)||rpad(substr(upper(text_bank(mfon,filn)),1,38) ,38)||lpad(trim(nvl(schet_new,rshetp)),14)||rpad(substr(to_char(nvl(mfo_new,mfop)),1,6) ,6)||lpad(to_char(decode(length(okpop),11,lpad(okpop,11,''0''),10,lpad(okpop,10,''0''),9,lpad(okpop,9,''0''),lpad(okpop,8,''0'')) ),10)||rpad(substr(upper(text_firma(okpop,nvl(dpidp,0))),1,38) ,38)||rpad(substr(nvl(bank_name,upper(text_bank(mfop,filp))),1,38) ,38)||rpad(substr(to_char(nplat),1,16) ,16)||rpad(substr(decode(nvl(pval,0),0,to_char(nvl(suman,0)*100,''999999999999.00''),to_char(0,''9'')),1,16) ,16)||rpad(substr(trim(prim)||'' ''||trim(prim3)||'' ''||trim(prim1),1,160) ,160)||rpad(substr(''        '',1,8) ,8),''CL8MSWIN1251'')'
||' FROM poruch where nvl(priz,0)='||pr||' and mfon in (334970, 334851) and polz like '''||polzz||'''';

    open all_columns for v_select;
    fetch all_columns
      into l_columns;
    while all_columns%found loop
      -- Символ CHR (32) обозначает, что записи не удалены
      l_lines := chr(32) || l_columns;
      dbms_lob.append(l_blob, utl_raw.cast_to_raw(l_lines));
      fetch all_columns
        into l_columns;
    end loop;
    --Символ-метка конца записи
    dbms_lob.append(l_blob, utl_raw.cast_to_raw(chr(26)));
    return l_blob;
    dbms_lob.freetemporary(l_blob);
  
END create_dbf_for_334970_new_;

function create_dbf_for_334970_new(polzz varchar2, pr number) return blob is
    l_result varchar2(4000);
    l_column varchar2(4000);
    l_columns   varchar2(32767);
    l_blob      blob;
    l_header    varchar2(32767);
    all_columns sys_refcursor;
    v_select    varchar2(32767);
    l_lines     varchar2(32767);
    l_number_of_columns binary_integer;
    l_line_length       binary_integer;
    l_number_of_records number;
    aaa varchar2(32767); i integer;
    
  begin
    l_number_of_columns:=15;
    l_line_length:=424;--407;
   
    select count(*) into l_number_of_records from poruch where nvl(priz,0)=pr and polz like polzz and mfon in (334970, 334851);
    --ЗАГОЛОВОК
    --№ - номер байта
    -- №0 Версия/ 1 байт
    -- 03 - простая таблица
    l_header := chr(3);
    -- №1,2,3 Дата последнего обновления таблицы в формате YYMMDD/ 3 байта
    l_header := l_header || chr(100+to_number(to_char(sysdate, 'YY'))) ||
                chr(to_number(to_char(sysdate, 'MM'))) ||
                chr(to_number(to_char(sysdate, 'DD')));
    --№4,5,6,7 Количество записей в таблице/ 32 бита = 4 байта
    l_header := l_header ||
                rpad(to_ascii(l_number_of_records), 4, chr(0));
    --№8,9 Количество байтов, занимаемых заголовком
    --/16 бит = 2 байта = 32 + 32*n + 1, где n - количество столбцов
    -- а 1 - ограничительный байт 
    l_header := l_header ||
                rpad(to_ascii(32 + l_number_of_columns * 32 + 1),
                     2,
                     chr(0));
    --№10,11 Количество байтов, занимаемых записью/16 бит = 2 байта 
    l_header := l_header || rpad(to_ascii(to_number(to_char(l_line_length,'XXXX'),'XXXX')), 2, chr(0));
    --№12,13 Зарезервировано
    l_header := l_header || rpad(chr(0), 2, chr(0));
    --№14 Транзакция, 1-начало, 0-конец(завершена)
    l_header := l_header || chr(0);
    --№15 Кодировка: 1-закодировано, 0-нормальная видимость 
    l_header := l_header || chr(0);
    --№16-27 Использование многопользовательского окружения
    l_header := l_header || rpad(chr(0), 12, chr(0));
    --№28 Использование индекса 0-не использовать
    l_header := l_header || chr(0);
    --№29 Номер драйвера языка
    l_header := l_header ||chr(0); --chr(3);
    --№30,31 Зарезервировано
    l_header := l_header || rpad(chr(0), 2, chr(0));
    --ОПИСАНИЯ ПОЛЕЙ В ЗАГОЛОВКЕ
 /*   for i in c_columns loop
      --№0-10 Имя поля с 0-завершением/11 байт
      l_header := l_header ||
                  rpad(substr(i.column_name, 1, 10), 11, chr(0));
      --№11 Тип поля/1 байт
      l_header := l_header || i.data_type;
      --№12,13,14,15 Игнорируется/4 байта
      l_header := l_header || rpad(chr(0), 4, chr(0));
      --№16 Размер поля/1 байт
      l_header := l_header || chr(i.data_length);
      --№17 Количество знаков после запятой/1 байт
      l_header := l_header || chr(i.data_scale);
      --№18,19 Зарезервированная область/2 байта
      l_header := l_header || rpad(chr(0), 2, chr(0));
      --№20 Идентификатор рабочей области/1 байт
      l_header := l_header || chr(0);
      --№21,22 Многопользовательский dBase/2 байта
      l_header := l_header || rpad(chr(0), 2, chr(0));
      --№23 Установленные поля/1 байт
      l_header := l_header || chr(0);--chr(1);
      --№24 Зарезервировано/7 байт
      l_header := l_header || rpad(chr(0), 7, chr(0));
      --№31 Флаг MDX-поля: 01H если поле имеет метку индекса в MDX-файле, 00H - нет.
      l_header := l_header || chr(0);
    end loop;
   */
   aaa:='43 4F 44 45 00 00 00 00 00 00 00 43 01 00 00 00 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 41 43 43 43 4C 49 00 00 00 00 00 4E 04 00 00 00 0E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4D 46 4F 43 4C 49 00 00 00 00 00 4E 12 00 00 00 06 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4F 4B 50 4F 43 4C 49 00 00 00 00 43 18 00 00 00 0A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4E 41 4D 45 43 4C 49 00 00 00 00 43 22 00 00 00 28 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42 41 4E 4B 43 4C 49 00 00 00 00 43 4A 00 00 00 28 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 41 43 43 43 4F 52 00 00 00 00 00 4E 72 00 00 00 0E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4D 46 4F 43 4F 52 00 00 00 00 00 4E 80 00 00 00 06 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4F 4B 50 4F 43 4F 52 00 00 00 00 43 86 00 00 00 0A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4E 41 4D 45 43 4F 52 00 00 00 00 43 90 00 00 00 28 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42 41 4E 4B 43 4F 52 00 00 00 00 43 B8 00 00 00 28 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4E 44 4F 43 00 00 00 00 00 00 00 43 E0 00 00 00 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 53 55 4D 4D 41 00 00 00 00 00 00 4E F0 00 00 00 10 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4E 41 5A 4E 00 00 00 00 00 00 00 43 00 01 00 00 A0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 44 56 00 00 00 00 00 00 00 00 00 44 A0 01 00 00 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00';
--aaa:='43 4F 44 45 00 00 00 00 00 00 00 43 01 00 00 00 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 41 43 43 43 4C 49 00 00 00 00 00 4E 04 00 00 00 0E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4D 46 4F 43 4C 49 00 00 00 00 00 4E 12 00 00 00 06 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4F 4B 50 4F 43 4C 49 00 00 00 00 4E 18 00 00 00 0A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4E 41 4D 45 43 4C 49 00 00 00 00 43 22 00 00 00 26 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42 41 4E 4B 43 4C 49 00 00 00 00 43 48 00 00 00 26 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 41 43 43 43 4F 52 00 00 00 00 00 4E 6E 00 00 00 0E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4D 46 4F 43 4F 52 00 00 00 00 00 4E 7C 00 00 00 06 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4F 4B 50 4F 43 4F 52 00 00 00 00 4E 82 00 00 00 0A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4E 41 4D 45 43 4F 52 00 00 00 00 43 8C 00 00 00 26 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42 41 4E 4B 43 4F 52 00 00 00 00 43 B2 00 00 00 26 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4E 44 4F 43 00 00 00 00 00 00 00 43 D8 00 00 00 0A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 53 55 4D 4D 41 00 00 00 00 00 00 4E E2 00 00 00 10 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4E 41 5A 4E 00 00 00 00 00 00 00 43 F2 00 00 00 A0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 44 56 00 00 00 00 00 00 00 00 00 44 92 01 00 00 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00';
FOR i IN 1..480 LOOP
  l_header := l_header ||chr(to_number(REGEXP_substr(aaa,'[^ ]+',1,i),'XX'));
  END LOOP;

    --Завершающий заголовок символ 0D
    l_header := l_header || chr(13);
    dbms_lob.createtemporary(l_blob, true);
    for i in 1 .. trunc(length(l_header) / 2000) + 1 loop
      dbms_lob.append(l_blob,
                      utl_raw.cast_to_raw(substr(l_header, 1, 2000)));
      l_header := substr(l_header, 2000);
    end loop;
--v_select := 'SELECT CONVERT(to_number(rshetn,''99999999999999'')||rpad(substr(to_char(mfon,''999999''),1,6) ,6)||rpad(substr(to_char(okpon,''999999999999''),1,12) ,12)||rpad(substr(text_firma(okpon,0),1,38) ,38)||rpad(substr(text_bank(mfon,filn),1,38) ,38)||rpad(substr(to_char(to_number(rshetp,''99999999999999''),''99999999999999''),1,14) ,14)||rpad(substr(to_char(mfop,''999999''),1,6) ,6)||rpad(substr(to_char(okpop,''999999999999''),1,12) ,12)||rpad(substr(text_firma(okpop,0),1,38) ,38)||rpad(substr(text_bank(mfop,filp),1,38) ,38)||rpad(substr(to_char(nplat),1,10) ,10)||rpad(substr(decode(pval,0,to_char(nvl(suman,0),''99999999999999.00''),to_char(0,''9'')),1,16) ,16)||rpad(substr(prim,1,160) ,160)||rpad(substr(to_char(to_date2(datp,''yyyymmdd''),''yyyymmdd''),1,8) ,8),''CL8MSWIN1251'')'
--||' FROM poruch where nvl(priz,0)=3 and mfon=334970 and polz like '''||polzz||'''';
--v_select := 'SELECT CONVERT(,''CL8MSWIN1251'')'
--||' FROM poruch where nvl(priz,0)=3 and mfon=334970 and polz like '''||polzz||'''';

--v_select := 'SELECT CONVERT(rpad(''Win'',3)||lpad(trim(rshetn),14)||rpad(substr(to_char(mfon),1,6) ,6)||lpad(to_char(okpon),10)||rpad(substr(upper(text_firma(okpon,nvl(dpidn,0))),1,40) ,40)||rpad(substr(upper(text_bank(mfon,filn)),1,40) ,40)||lpad(trim(nvl(schet_new,rshetp)),14)||rpad(substr(to_char(nvl(mfo_new,mfop)),1,6) ,6)||lpad(to_char(okpop),10)||rpad(substr(upper(text_firma(okpop,nvl(dpidp,0))),1,40) ,40)||rpad(substr(nvl(bank_name,upper(text_bank(mfop,filp))),1,40) ,40)||rpad(substr(to_char(nplat),1,16) ,16)||rpad(substr(decode(nvl(pval,0),0,to_char(nvl(suman,0)*100,''999999999999.00''),to_char(0,''9'')),1,16) ,16)||rpad(substr(trim(prim)||'' ''||trim(prim3)||'' ''||trim(prim1),1,160) ,160)||rpad(substr(''        '',1,8) ,8),''CL8MSWIN1251'')'
--||' FROM poruch where nvl(priz,0)='||pr||' and mfon in (334970, 334851) and polz like '''||polzz||'''';
v_select := 'SELECT CONVERT(rpad(''Win'',3)||lpad(trim(rshetn),14)||rpad(substr(to_char(mfon),1,6) ,6)||lpad(to_char(lpad(okpon,8,''0'')),10)||rpad(substr(upper(text_firma(okpon,nvl(dpidn,0))),1,40) ,40)||rpad(substr(upper(text_bank(mfon,filn)),1,40) ,40)||lpad(trim(nvl(schet_new,rshetp)),14)||rpad(substr(to_char(nvl(mfo_new,mfop)),1,6) ,6)||lpad(to_char(lpad(okpop,8,''0'')),10)||rpad(substr(upper(text_firma(okpop,nvl(dpidp,0))),1,40) ,40)||rpad(substr(nvl(bank_name,upper(text_bank(mfop,filp))),1,40) ,40)||rpad(substr(to_char(nplat),1,16) ,16)||rpad(substr(decode(nvl(pval,0),0,to_char(nvl(suman,0)*100,''999999999999.00''),to_char(0,''9'')),1,16) ,16)||rpad(substr(trim(prim)||'' ''||trim(prim3)||'' ''||trim(prim1),1,160) ,160)||rpad(substr(''        '',1,8) ,8),''CL8MSWIN1251'')'
||' FROM poruch where nvl(priz,0)='||pr||' and mfon in (334970, 334851) and polz like '''||polzz||'''';

    open all_columns for v_select;
    fetch all_columns
      into l_columns;
    while all_columns%found loop
      -- Символ CHR (32) обозначает, что записи не удалены
      l_lines := chr(32) || l_columns;
      dbms_lob.append(l_blob, utl_raw.cast_to_raw(l_lines));
      fetch all_columns
        into l_columns;
    end loop;
    --Символ-метка конца записи
    dbms_lob.append(l_blob, utl_raw.cast_to_raw(chr(26)));
    return l_blob;
    dbms_lob.freetemporary(l_blob);
  
END create_dbf_for_334970_new;

--394200 - ощадбанк
function create_dbf_for_394200(polzz varchar2, pr number) return blob is
   i integer; aaa varchar2(32767);
   l_result varchar2(4000);
   l_column varchar2(4000);
    
    l_columns   varchar2(32767);
    l_blob      blob;
    l_header    varchar2(32767);
    all_columns sys_refcursor;
    v_select    varchar2(32767);
    l_lines     varchar2(32767);
    l_number_of_columns binary_integer;
    l_line_length       binary_integer;
    l_number_of_records number;
  /*  cursor c_columns is
    select column_name,data_type,data_length,data_scale
    from 
    (
    select 'PAYDOC' COLUMN_NAME,'N' DATA_TYPE, 10 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'DOCNO' COLUMN_NAME,'C' DATA_TYPE, 10 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'DOCDATE' COLUMN_NAME,'D' DATA_TYPE, 8 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'DBANK' COLUMN_NAME,'D' DATA_TYPE, 8 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'MFOA' COLUMN_NAME,'C' DATA_TYPE, 6 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'ACCA' COLUMN_NAME,'C' DATA_TYPE, 14 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'OKPOA' COLUMN_NAME,'C' DATA_TYPE, 14 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'CLIENTA' COLUMN_NAME,'C' DATA_TYPE, 38 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'MFOB' COLUMN_NAME,'C' DATA_TYPE, 6 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'ACCB' COLUMN_NAME,'C' DATA_TYPE, 14 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'OKPOB' COLUMN_NAME,'C' DATA_TYPE, 14 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'CLIENTB' COLUMN_NAME,'C' DATA_TYPE, 38 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'BANKA' COLUMN_NAME,'C' DATA_TYPE, 254 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'BANKB' COLUMN_NAME,'C' DATA_TYPE, 254 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'ASNTEXT' COLUMN_NAME,'C' DATA_TYPE, 160 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'NOTETEXT' COLUMN_NAME,'C' DATA_TYPE, 60 DATA_LENGTH, 0 DATA_SCALE from dual UNION ALL
    select 'PAYSUM' COLUMN_NAME,'N' DATA_TYPE, 20 DATA_LENGTH, 2 DATA_SCALE from dual  
    ); */
    
  begin
    l_number_of_columns:=17;
    l_line_length:=931;
   
    select count(*) into l_number_of_records from poruch where nvl(priz,0)=pr and polz like polzz and mfon=394200;
    --ЗАГОЛОВОК
    --№ - номер байта
    -- №0 Версия/ 1 байт
    -- 03 - простая таблица
    l_header := chr(3);
    -- №1,2,3 Дата последнего обновления таблицы в формате YYMMDD/ 3 байта
    l_header := l_header || chr(100+to_number(to_char(sysdate, 'YY'))) ||
                chr(to_number(to_char(sysdate, 'MM'))) ||
                chr(to_number(to_char(sysdate, 'DD')));
    --№4,5,6,7 Количество записей в таблице/ 32 бита = 4 байта
    l_header := l_header ||
                rpad(to_ascii(l_number_of_records), 4, chr(0));
    --№8,9 Количество байтов, занимаемых заголовком
    --/16 бит = 2 байта = 32 + 32*n + 1, где n - количество столбцов
    -- а 1 - ограничительный байт 
    l_header := l_header ||
                rpad(to_ascii(32 + l_number_of_columns * 32 + 1),
                     2,
                     chr(0));
    --№10,11 Количество байтов, занимаемых записью/16 бит = 2 байта 
    l_header := l_header || rpad(to_ascii(to_number(to_char(l_line_length,'XXXX'),'XXXX')), 2, chr(0));
    --№12,13 Зарезервировано
    l_header := l_header || rpad(chr(0), 2, chr(0));
    --№14 Транзакция, 1-начало, 0-конец(завершена)
    l_header := l_header || chr(0);
    --№15 Кодировка: 1-закодировано, 0-нормальная видимость 
    l_header := l_header || chr(0);
    --№16-27 Использование многопользовательского окружения
    l_header := l_header || rpad(chr(0), 12, chr(0));
    --№28 Использование индекса 0-не использовать
    l_header := l_header || chr(0);
    --№29 Номер драйвера языка
    l_header := l_header ||chr(0); --chr(3);
    --№30,31 Зарезервировано
    l_header := l_header || rpad(chr(0), 2, chr(0));
    --ОПИСАНИЯ ПОЛЕЙ В ЗАГОЛОВКЕ
/*    for i in c_columns loop
      --№0-10 Имя поля с 0-завершением/11 байт
      l_header := l_header ||
                  rpad(substr(i.column_name, 1, 10), 11, chr(0));
      --№11 Тип поля/1 байт
      l_header := l_header || i.data_type;
      --№12,13,14,15 Игнорируется/4 байта
      l_header := l_header || rpad(chr(0), 4, chr(0));
      --№16 Размер поля/1 байт
      l_header := l_header || chr(i.data_length);
      --№17 Количество знаков после запятой/1 байт
      l_header := l_header || chr(i.data_scale);
      --№18,19 Зарезервированная область/2 байта
      l_header := l_header || rpad(chr(0), 2, chr(0));
      --№20 Идентификатор рабочей области/1 байт
      l_header := l_header || chr(0);
      --№21,22 Многопользовательский dBase/2 байта
      l_header := l_header || rpad(chr(0), 2, chr(0));
      --№23 Установленные поля/1 байт
      l_header := l_header || chr(1);
      --№24 Зарезервировано/7 байт
      l_header := l_header || rpad(chr(0), 7, chr(0));
      --№31 Флаг MDX-поля: 01H если поле имеет метку индекса в MDX-файле, 00H - нет.
      l_header := l_header || chr(0);
    end loop;
*/
aaa:='50 41 59 44 4F 43 00 00 00 00 00 4E 01 00 00 00 0A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 44 4F 43 4E 4F 00 00 00 00 00 00 43 0B 00 00 00 0A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 44 4F 43 44 41 54 45 00 00 00 00 44 15 00 00 00 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 44 42 41 4E 4B 00 00 00 00 00 00 44 1D 00 00 00 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4D 46 4F 41 00 00 00 00 00 00 00 43 25 00 00 00 06 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 41 43 43 41 00 00 00 00 00 00 00 43 2B 00 00 00 0E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4F 4B 50 4F 41 00 00 00 00 00 00 43 39 00 00 00 0E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 43 4C 49 45 4E 54 41 00 00 00 00 43 47 00 00 00 26 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4D 46 4F 42 00 00 00 00 00 00 00 43 6D 00 00 00 06 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 41 43 43 42 00 00 00 00 00 00 00 43 73 00 00 00 0E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4F 4B 50 4F 42 00 00 00 00 00 00 43 81 00 00 00 0E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 43 4C 49 45 4E 54 42 00 00 00 00 43 8F 00 00 00 26 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42 41 4E 4B 41 00 00 00 00 00 00 43 B5 00 00 00 FF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42 41 4E 4B 42 00 00 00 00 00 00 43 B4 01 00 00 FF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 41 53 4E 54 45 58 54 00 00 00 00 43 B3 02 00 00 A0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4E 4F 54 45 54 45 58 54 00 00 00 43 53 03 00 00 3C 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 50 41 59 53 55 4D 00 00 00 00 00 4E 8F 03 00 00 14 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00';
FOR i IN 1..545 LOOP
  l_header := l_header ||chr(to_number(REGEXP_substr(aaa,'[^ ]+',1,i),'XX'));
  END LOOP;



 --ascii('504159444F4300000000004E010000000A000000000000000000000000000000444F434E4F000000000000430B0000000A000000000000000000000000000000444F4344415445000000004415000000080000000000000000000000000000004442414E4B000000000000441D000000080000000000000000000000000000004D464F41000000000000004325000000060000000000000000000000000000004143434100000000000000432B0000000E0000000000000000000000000000004F4B504F4100000000000043390000000E000000000000000000000000000000434C49454E5441000000004347000000260000000000000000000000000000004D464F4200000000000000436D00000006000000000000000000000000000000414343420000000000000043730000000E0000000000000000000000000000004F4B504F4200000000000043810000000E000000000000000000000000000000434C49454E544200000000438F0000002600000000000000000000000000000042414E4B4100000000000043B5000000FF00000000000000000000000000000042414E4B4200000000000043B4010000FF00000000000000000000000000000041534E544558540000000043B3020000A00000000000000000000000000000004E4F54455445585400000043530300003C00000000000000000000000000000050415953554D00000000004E8F03000014020000000000000000000000000000');    
    --Завершающий заголовок символ 0D
    l_header := l_header || chr(13);
    dbms_lob.createtemporary(l_blob, true);
    for i in 1 .. trunc(length(l_header) / 2000) + 1 loop
      dbms_lob.append(l_blob,
                      utl_raw.cast_to_raw(substr(l_header, 1, 2000)));
      l_header := substr(l_header, 2000);
    end loop;
--work v_select := 'SELECT CONVERT(rpad(substr(0,1,10) ,10)||rpad(substr(nplat,1,10) ,10)||rpad(substr(to_char(to_date2(datp,''yyyymmdd''),''yyyymmdd''),1,8) ,8)||rpad(substr(to_char(sysdate,''yyyymmdd''),1,8) ,8)||rpad(substr(to_char(mfon),1,6) ,6)||rpad(substr(to_char(rshetn),1,14) ,14)||rpad(substr(lpad(to_char(okpon),8,''0''),1,14) ,14)||rpad(substr(upper(text_firma(okpon,0)),1,38) ,38)||rpad(substr(to_char(mfop),1,6) ,6)||rpad(substr(to_char(rshetp),1,14) ,14)||rpad(substr(lpad(to_char(okpop),10,''0''),1,14) ,14)||rpad(substr(upper(text_firma(okpop,0)),1,38) ,38)||rpad(substr(upper(text_bank(mfon,filn)),1,255) ,255)||rpad(substr(upper(text_bank(mfop,filp)),1,255) ,255)||rpad(substr(trim(prim)||'' ''||trim(prim3)||'' ''||trim(prim1),1,160) ,160)||rpad(substr('' '',1,60) ,60)||rpad(substr(decode(pval,0,to_char(nvl(suman,0),''9999999999999999.00''),to_char(0,''9'')),1,20) ,20),''RU8PC866'')'
--||' FROM poruch where nvl(priz,0)=3 and mfon=394200 and polz like '''||polzz||'''';
v_select := 'SELECT CONVERT(rpad(substr(0,1,10) ,10)||rpad(substr(nplat,1,10) ,10)||rpad(substr(to_char(to_date2(datp,''yyyymmdd''),''yyyymmdd''),1,8) ,8)||rpad(substr(to_char(sysdate,''yyyymmdd''),1,8) ,8)||rpad(substr(to_char(mfon),1,6) ,6)||rpad(substr(to_char(rshetn),1,14) ,14)||rpad(substr(lpad(to_char(okpon),8,''0''),1,14) ,14)||rpad(substr(upper(text_firma(okpon,0)),1,38) ,38)||rpad(substr(to_char(nvl(mfo_new,mfop)),1,6) ,6)||rpad(substr(to_char(nvl(schet_new,rshetp)),1,14) ,14)||decode(length(okpop),9,rpad(substr(lpad(to_char(okpop),10,''0''),1,14) ,14),10,rpad(substr(lpad(to_char(okpop),10,''0''),1,14) ,14),rpad(substr(lpad(to_char(okpop),8,''0''),1,14) ,14) )||rpad(substr(upper(text_firma(okpop,0)),1,38) ,38)||rpad(substr(upper(text_bank(mfon,filn)),1,255) ,255)||rpad(substr(nvl(bank_name,upper(text_bank(mfop,filp))),1,255) ,255)||rpad(substr(trim(prim)||'' ''||trim(prim3)||'' ''||trim(prim1),1,160) ,160)||rpad(substr('' '',1,60) ,60)||rpad(substr(decode(nvl(pval,0),0,to_char(nvl(suman,0),''9999999999999999.00''),to_char(0,''9'')),1,20) ,20),''RU8PC866'')'
||' FROM poruch where nvl(priz,0)='||pr||' and mfon=394200 and polz like '''||polzz||'''';
--v_select := 'SELECT CONVERT(rpad(substr(nplat,1,10) ,10)||rpad(substr(text_firma(okpon,0),1,38) ,38)||rpad(substr(to_char(okpon),1,12) ,12)||rpad(substr(text_bank(mfon,filn),1,38) ,38)||rpad(substr(to_char(mfon),1,38) ,38)||rpad(substr(to_char(rshetn),1,14) ,14)||rpad(substr(text_firma(okpop,0),1,38) ,38)||rpad(substr(to_char(okpop),1,12) ,12)||rpad(substr(text_bank(mfop,filp),1,38) ,38)||rpad(substr(to_char(mfop),1,38) ,38)||rpad(substr(to_char(rshetp),1,14) ,14)||rpad(substr(to_char(decode(pval,0,980,3,643,4,974) ),1,3) ,3)||rpad(substr(prim,1,160) ,160),''CL8MSWIN1251'')'
--||' FROM poruch where datp=20081112 and polz like ''укс%''';

    open all_columns for v_select;
    fetch all_columns
      into l_columns;
    while all_columns%found loop
      -- Символ CHR (32) обозначает, что записи не удалены
      l_lines := 
      --chr(32)
      chr(to_number('20','XX')) 
      || l_columns;
      dbms_lob.append(l_blob, utl_raw.cast_to_raw(l_lines));
      fetch all_columns
        into l_columns;
    end loop;
    --Символ-метка конца записи
    dbms_lob.append(l_blob, utl_raw.cast_to_raw(chr(26)));
    return l_blob;
    dbms_lob.freetemporary(l_blob);
  
END create_dbf_for_394200;
----------------PUMB
function create_dbf_for_335742(polzz varchar2, pr number) return blob is
    l_result varchar2(4000);
    l_column varchar2(4000);
    l_columns   varchar2(32767);
    l_blob      blob;
    l_header    varchar2(32767);
    all_columns sys_refcursor;
    v_select    varchar2(32767);
    l_lines     varchar2(32767);
    l_number_of_columns binary_integer;
    l_line_length       binary_integer;
    l_number_of_records number;
    aaa varchar2(32767); i integer;

    
  begin
    l_number_of_columns:=19;
    l_line_length:=534;--407;
   
    select count(*) into l_number_of_records from poruch where nvl(priz,0)=pr and polz like polzz and mfon in (335742,334851);
    --ЗАГОЛОВОК
    --№ - номер байта
    -- №0 Версия/ 1 байт
    -- 03 - простая таблица
    l_header := chr(3);
    -- №1,2,3 Дата последнего обновления таблицы в формате YYMMDD/ 3 байта
    l_header := l_header || chr(100+to_number(to_char(sysdate, 'YY'))) ||
                chr(to_number(to_char(sysdate, 'MM'))) ||
                chr(to_number(to_char(sysdate, 'DD')));
    --№4,5,6,7 Количество записей в таблице/ 32 бита = 4 байта
    l_header := l_header ||
                rpad(to_ascii(l_number_of_records), 4, chr(0));
    --№8,9 Количество байтов, занимаемых заголовком
    --/16 бит = 2 байта = 32 + 32*n + 1, где n - количество столбцов
    -- а 1 - ограничительный байт 
    l_header := l_header ||
                rpad(to_ascii(32 + l_number_of_columns * 32 + 1),
                     2,
                     chr(0));
    --№10,11 Количество байтов, занимаемых записью/16 бит = 2 байта 
    l_header := l_header || rpad(to_ascii(to_number(to_char(l_line_length,'XXXX'),'XXXX')), 2, chr(0));
    --№12,13 Зарезервировано
    l_header := l_header || rpad(chr(0), 2, chr(0));
    --№14 Транзакция, 1-начало, 0-конец(завершена)
    l_header := l_header || chr(0);
    --№15 Кодировка: 1-закодировано, 0-нормальная видимость 
    l_header := l_header || chr(0);
    --№16-27 Использование многопользовательского окружения
    l_header := l_header || rpad(chr(0), 12, chr(0));
    --№28 Использование индекса 0-не использовать
    l_header := l_header || chr(0);
    --№29 Номер драйвера языка
    l_header := l_header ||chr(0); --chr(3);
    --№30,31 Зарезервировано
    l_header := l_header || rpad(chr(0), 2, chr(0));
 
aaa:='44 4F 43 5F 44 41 54 45 00 00 00 44 00 00 00 00 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4E 55 4D 42 45 52 00 00 00 00 00 43 00 00 00 00 0A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 41 4D 4F 55 4E 54 00 00 00 00 00 4E 00 00 00 00 0F 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 41 5F 4E 41 4D 45 00 00 00 00 00 43 00 00 00 00 26 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 41 5F 4F 4B 50 4F 00 00 00 00 00 43 00 00 00 00 0E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 41 5F 4D 46 4F 00 00 00 00 00 00 4E 00 00 00 00 09 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 41 5F 42 41 4E 4B 4E 41 4D 45 00 43 00 00 00 00 26 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 41 5F 41 43 43 4F 55 4E 54 00 00 43 00 00 00 00 0E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42 5F 4E 41 4D 45 00 00 00 00 00 43 00 00 00 00 26 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42 5F 4F 4B 50 4F 00 00 00 00 00 43 00 00 00 00 0E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42 5F 4D 46 4F 00 00 00 00 00 00 4E 00 00 00 00 09 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42 5F 42 41 4E 4B 4E 41 4D 45 00 43 00 00 00 00 26 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42 5F 41 43 43 4F 55 4E 54 00 00 43 00 00 00 00 0E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4D 45 4D 4F 00 00 00 00 00 00 00 43 00 00 00 00 A0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 43 43 59 5F 44 41 54 45 00 00 00 44 00 00 00 00 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 41 5F 43 4F 55 4E 54 52 59 00 00 4E 00 00 00 00 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42 5F 43 4F 55 4E 54 52 59 00 00 4E 00 00 00 00 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 45 58 50 45 4E 53 45 5F 49 54 00 43 00 00 00 00 32 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 52 45 53 50 4F 4E 53 49 42 4C 00 43 00 00 00 00 32 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00';
FOR i IN 1..608 LOOP
  l_header := l_header ||chr(to_number(REGEXP_substr(aaa,'[^ ]+',1,i),'XX'));
  END LOOP;

    --Завершающий заголовок символ 0D
    l_header := l_header || chr(13);
    dbms_lob.createtemporary(l_blob, true);
    for i in 1 .. trunc(length(l_header) / 2000) + 1 loop
      dbms_lob.append(l_blob,
                      utl_raw.cast_to_raw(substr(l_header, 1, 2000)));
      l_header := substr(l_header, 2000);
    end loop;

v_select := 'SELECT CONVERT(rpad(substr(to_char(to_date2(datp,''yyyymmdd''),''yyyymmdd''),1,8) ,8)||rpad(substr(nplat,1,9) ,9)||decode(nvl(pval,0),0,to_char(nvl(suman,0),''999999999999.00''),to_char(0,''9''))||rpad(substr(upper(text_firma(okpon,0)),1,38) ,38)||rpad(substr(lpad(okpon,8,''0''),1,14) ,14)||rpad(substr(to_char(mfon,''99999999''),1,9) ,9)||rpad(substr(upper(text_bank(mfon,filn)),1,38) ,38)||rpad(substr(to_char(rshetn),1,14) ,14)||rpad(substr(upper(text_firma(okpop,0)),1,38) ,38)||decode(length(okpop),9,rpad(substr(lpad(to_char(okpop),10,''0''),1,14) ,14),10,rpad(substr(lpad(to_char(okpop),10,''0''),1,14) ,14),rpad(substr(lpad(to_char(okpop),8,''0''),1,14) ,14) )||rpad(substr(to_char(nvl(mfo_new,mfop),''99999999''),1,9) ,9)||rpad(substr(nvl(bank_name,upper(text_bank(mfop,filp))),1,38) ,38)||rpad(substr(to_char(nvl(schet_new,rshetp)),1,14) ,14)||rpad(upper(substr(trim(prim)||'' ''||trim(prim3)||'' ''||trim(prim1),1,160)) ,160)||rpad(substr(to_char(sysdate,''yyyymmdd''),1,8) ,8)||rpad(substr(to_char(980),1,3) ,3)||rpad(substr(to_char(decode(nvl(pval,0),0,980,3,643,4,974) ),1,3) ,3)||rpad(substr(polz,1,50) ,50)||rpad(substr(polz,1,50) ,50),''RU8PC866'' )'  --,CL8MSWIN1251 ''RU8PC866''  -----''CL8ISO8859P5'',''CL8MSWIN1251''
--v_select := 'SELECT rpad(substr(to_char(to_date2(datp,''yyyymmdd''),''yyyymmdd''),1,8) ,8)||rpad(substr(nplat,1,9) ,9)||decode(nvl(pval,0),0,to_char(nvl(suman,0),''999999999999.00''),to_char(0,''9''))||rpad(substr(upper(text_firma(okpon,0)),1,38) ,38)||rpad(substr(lpad(okpon,8,''0''),1,14) ,14)||rpad(substr(to_char(mfon,''99999999''),1,9) ,9)||rpad(substr(upper(text_bank(mfon,filn)),1,38) ,38)||rpad(substr(to_char(rshetn),1,14) ,14)||rpad(substr(upper(text_firma(okpop,0)),1,38) ,38)||decode(length(okpop),9,rpad(substr(lpad(to_char(okpop),10,''0''),1,14) ,14),10,rpad(substr(lpad(to_char(okpop),10,''0''),1,14) ,14),rpad(substr(lpad(to_char(okpop),8,''0''),1,14) ,14) )||rpad(substr(to_char(mfop,''99999999''),1,9) ,9)||rpad(substr(upper(text_bank(mfop,filp)),1,38) ,38)||rpad(substr(to_char(rshetp),1,14) ,14)||rpad(upper(substr(trim(prim)||'' ''||trim(prim3)||'' ''||trim(prim1),1,160)) ,160)||rpad(substr(to_char(sysdate,''yyyymmdd''),1,8) ,8)||rpad(substr(to_char(980),1,3) ,3)||rpad(substr(to_char(decode(nvl(pval,0),0,980,3,643,4,974) ),1,3) ,3)||rpad(substr(polz,1,50) ,50)||rpad(substr(polz,1,50) ,50))'
||' FROM poruch where nvl(priz,0)='||pr||' and mfon in (335742,334851) and polz like '''||polzz||'''';
--||rpad(substr(to_char(to_number(rshetp),''9999999999999''),1,14) ,14)||rpad(substr(to_char(mfop),1,6) ,6)||rpad(substr(to_char(okpop),1,10) ,10)||rpad(substr(text_firma(okpop,0),1,38) ,38)||rpad(substr(text_bank(mfop,filp),1,38) ,38)||rpad(substr(to_char(nplat),1,10) ,10)
    open all_columns for v_select;
    fetch all_columns
      into l_columns;
    while all_columns%found loop
      -- Символ CHR (32) обозначает, что записи не удалены
      l_lines := chr(32) || l_columns;
      dbms_lob.append(l_blob, utl_raw.cast_to_raw(l_lines));
      fetch all_columns
        into l_columns;
    end loop;
    --Символ-метка конца записи
    --dbms_lob.append(l_blob, utl_raw.cast_to_raw(chr(26))); --1A
    return l_blob;
    dbms_lob.freetemporary(l_blob);
  
END create_dbf_for_335742;

----------------
-- 335742 ПУМБ
--ALFA 
function create_dbf_for_300346(polzz varchar2, pr number) return blob is
    l_result varchar2(4000);
    l_column varchar2(4000);
    l_columns   varchar2(32767);
    l_blob      blob;
    l_header    varchar2(32767);
    all_columns sys_refcursor;
    v_select    varchar2(32767);
    l_lines     varchar2(32767);
    l_number_of_columns binary_integer;
    l_line_length       binary_integer;
    l_number_of_records number;
    aaa varchar2(32767); i integer;

    
  begin
    l_number_of_columns:=15;
    l_line_length:=549;--534;--407;
   
    select count(*) into l_number_of_records from poruch where nvl(priz,0)=pr and polz like polzz and mfon=300346;
    --ЗАГОЛОВОК
    --№ - номер байта
    -- №0 Версия/ 1 байт
    -- 03 - простая таблица
    l_header := chr(3);
    -- №1,2,3 Дата последнего обновления таблицы в формате YYMMDD/ 3 байта
    l_header := l_header || chr(100+to_number(to_char(sysdate, 'YY'))) ||
                chr(to_number(to_char(sysdate, 'MM'))) ||
                chr(to_number(to_char(sysdate, 'DD')));
    --№4,5,6,7 Количество записей в таблице/ 32 бита = 4 байта
    l_header := l_header ||
                rpad(to_ascii(l_number_of_records), 4, chr(0));
    --№8,9 Количество байтов, занимаемых заголовком
    --/16 бит = 2 байта = 32 + 32*n + 1, где n - количество столбцов
    -- а 1 - ограничительный байт 
    l_header := l_header ||
                rpad(to_ascii(32 + l_number_of_columns * 32 + 1),
                     2,
                     chr(0));
    --№10,11 Количество байтов, занимаемых записью/16 бит = 2 байта 
    l_header := l_header || rpad(to_ascii(to_number(to_char(l_line_length,'XXXX'),'XXXX')), 2, chr(0));
    --№12,13 Зарезервировано
    l_header := l_header || rpad(chr(0), 2, chr(0));
    --№14 Транзакция, 1-начало, 0-конец(завершена)
    l_header := l_header || chr(0);
    --№15 Кодировка: 1-закодировано, 0-нормальная видимость 
    l_header := l_header || chr(0);
    --№16-27 Использование многопользовательского окружения
    l_header := l_header || rpad(chr(0), 12, chr(0));
    --№28 Использование индекса 0-не использовать
    l_header := l_header || chr(0);
    --№29 Номер драйвера языка
    l_header := l_header ||chr(0); --chr(3);
    --№30,31 Зарезервировано
    l_header := l_header || rpad(chr(0), 2, chr(0));
 
aaa:='41 00 00 00 00 00 00 00 00 00 00 43 00 00 00 00 50 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42 00 00 00 00 00 00 00 00 00 00 43 00 00 00 00 50 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 41 43 43 4F 55 4E 54 5F 41 00 00 4E 00 00 00 00 0E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 41 43 43 4F 55 4E 54 5F 42 00 00 4E 00 00 00 00 0E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4D 46 4F 5F 41 00 00 00 00 00 00 4E 00 00 00 00 09 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4D 46 4F 5F 42 00 00 00 00 00 00 4E 00 00 00 00 09 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4F 4B 50 4F 5F 41 00 00 00 00 00 4E 00 00 00 00 0E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4F 4B 50 4F 5F 42 00 00 00 00 00 4E 00 00 00 00 0E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42 41 4E 4B 5F 41 00 00 00 00 00 43 00 00 00 00 26 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42 41 4E 4B 5F 42 00 00 00 00 00 43 00 00 00 00 26 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 43 49 54 59 5F 41 00 00 00 00 00 43 00 00 00 00 19 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 43 49 54 59 5F 42 00 00 00 00 00 43 00 00 00 00 19 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 41 4D 4F 55 4E 54 00 00 00 00 00 4E 00 00 00 00 12 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4E 55 4D 42 45 52 00 00 00 00 00 43 00 00 00 00 0A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 44 45 54 41 49 4C 53 00 00 00 00 43 00 00 00 00 A0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00';
FOR i IN 1..496 LOOP
  l_header := l_header ||chr(to_number(REGEXP_substr(aaa,'[^ ]+',1,i),'XX'));
  END LOOP;

    --Завершающий заголовок символ 0D
    l_header := l_header || chr(13);
    dbms_lob.createtemporary(l_blob, true);
    for i in 1 .. trunc(length(l_header) / 2000) + 1 loop
      dbms_lob.append(l_blob,
                      utl_raw.cast_to_raw(substr(l_header, 1, 2000)));
      l_header := substr(l_header, 2000);
    end loop;

v_select := 'SELECT CONVERT(rpad(substr(upper(trim(text_firma(okpon,nvl(dpidn,0)))),1,80) ,80)||rpad(substr(upper(trim(text_firma(okpop,nvl(dpidp,0)))),1,80) ,80)||rpad(substr(to_char(rshetn,''99999999999999''),-14,14) ,14)||rpad(substr(to_char(nvl(schet_new,rshetp),''99999999999999''),-14,14) ,14)||rpad(substr(to_char(mfon,''999999999''),-9,9) ,9)||rpad(substr(to_char(nvl(mfo_new,mfop),''999999999''),-9,9) ,9)||rpad(substr(to_char(okpon,''99999999999999''),-14,14) ,14)||rpad(substr(to_char(okpop,''99999999999999''),-14,14) ,14)||rpad(substr(upper(text_bank(mfon,filn)),1,38) ,38)||rpad(substr(nvl(bank_name,upper(text_bank(mfop,filp))),1,38) ,38)||rpad(substr(upper(''Г.МАРИУПОЛЬ''),1,25) ,25)||rpad(substr(upper(text_city(okpop,nvl(dpidp,0))),1,25) ,25)||decode(nvl(pval,0),0,to_char(nvl(suman,0),''99999999999999.00''),to_char(0,''9''))||rpad(substr(nplat,1,10) ,10)||rpad(upper(substr(trim(prim)||'' ''||trim(prim3)||'' ''||trim(prim1),1,160)) ,160),''RU8PC866'')' --CL8MSWIN1251   RU8PC866
||' FROM poruch where nvl(priz,0)='||pr||' and mfon=300346 and polz like '''||polzz||'''';
--||rpad(substr(to_char(to_number(rshetp),''9999999999999''),1,14) ,14)||rpad(substr(to_char(mfop),1,6) ,6)||rpad(substr(to_char(okpop),1,10) ,10)||rpad(substr(text_firma(okpop,0),1,38) ,38)||rpad(substr(text_bank(mfop,filp),1,38) ,38)||rpad(substr(to_char(nplat),1,10) ,10)
    open all_columns for v_select;
    fetch all_columns
      into l_columns;
    while all_columns%found loop
      -- Символ CHR (32) обозначает, что записи не удалены
      l_lines := chr(32) || l_columns;
      dbms_lob.append(l_blob, utl_raw.cast_to_raw(l_lines));
      fetch all_columns
        into l_columns;
    end loop;
    --Символ-метка конца записи
    --dbms_lob.append(l_blob, utl_raw.cast_to_raw(chr(26))); --1A
    return l_blob;
    dbms_lob.freetemporary(l_blob);
  
END create_dbf_for_300346;

--ПУМБ онлайн
function create_for_335742_online(polzz varchar2, pr number) return blob is
    l_result varchar2(4000);
    l_column varchar2(4000);
    l_columns   varchar2(32767);
    l_blob      blob;
    l_header    varchar2(32767);
    all_columns sys_refcursor;
    v_select    varchar2(32767);
    l_lines     varchar2(32767);
    l_number_of_columns binary_integer;
    l_line_length       binary_integer;
    l_number_of_records number;
    aaa varchar2(32767); i integer;

  begin
    l_number_of_columns:=18;
    l_line_length:=725;--534;--407;
   
    select count(*) into l_number_of_records from poruch where nvl(priz,0)=pr and polz like polzz and mfon in (335742);
    --ЗАГОЛОВОК
    --№ - номер байта
    -- №0 Версия/ 1 байт
    -- 03 - простая таблица
    l_header := chr(3);
    -- №1,2,3 Дата последнего обновления таблицы в формате YYMMDD/ 3 байта
    l_header := l_header || chr(100+to_number(to_char(sysdate, 'YY'))) ||
                chr(to_number(to_char(sysdate, 'MM'))) ||
                chr(to_number(to_char(sysdate, 'DD')));
    --№4,5,6,7 Количество записей в таблице/ 32 бита = 4 байта
    l_header := l_header ||
                rpad(to_ascii(l_number_of_records), 4, chr(0));
    --№8,9 Количество байтов, занимаемых заголовком
    --/16 бит = 2 байта = 32 + 32*n + 1, где n - количество столбцов
    -- а 1 - ограничительный байт 
    l_header := l_header ||
                rpad(to_ascii(32 + l_number_of_columns * 32 + 1),
                     2,
                     chr(0));
    --№10,11 Количество байтов, занимаемых записью/16 бит = 2 байта 
    l_header := l_header || rpad(to_ascii(to_number(to_char(l_line_length,'XXXX'),'XXXX')), 2, chr(0));
    --№12,13 Зарезервировано
    l_header := l_header || rpad(chr(0), 2, chr(0));
    --№14 Транзакция, 1-начало, 0-конец(завершена)
    l_header := l_header || chr(0);
    --№15 Кодировка: 1-закодировано, 0-нормальная видимость 
    l_header := l_header || chr(0);
    --№16-27 Использование многопользовательского окружения
    l_header := l_header || rpad(chr(0), 12, chr(0));
    --№28 Использование индекса 0-не использовать
    l_header := l_header || chr(0);
    --№29 Номер драйвера языка
    l_header := l_header ||chr(0); --chr(3);
    --№30,31 Зарезервировано
    l_header := l_header || rpad(chr(0), 2, chr(0));

--aaa:='444159000000000000000043000000000A0000000000000000000000000000004E554D424552000000000043000000000A000000000000000000000000000000410000000000000000000043000000005000000000000000000000000000000042000000000000000000004300000000500000000000000000000000000000004F4B504F5F41000000000043000000000E0000000000000000000000000000004F4B504F5F42000000000043000000000E0000000000000000000000000000004143434F554E545F41000043000000000E0000000000000000000000000000004143434F554E545F42000043000000000E00000000000000000000000000000042414E4B5F41000000000043000000005000000000000000000000000000000042414E4B5F4200000000004300000000500000000000000000000000000000004D464F5F410000000000004300000000090000000000000000000000000000004D464F5F42000000000000430000000009000000000000000000000000000000434954595F410000000000430000000019000000000000000000000000000000434954595F420000000000430000000019000000000000000000000000000000414D4F554E54000000000043000000001200000000000000000000000000000044455441494C53000000004300000000A00000000000000000000000000000004755494C5459000000000043000000003200000000000000000000000000000044455441494C535F540000430000000032000000000000000000000000000000'; 
aaa:='44 41 59 00 00 00 00 00 00 00 00 43 00 00 00 00 0A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4E 55 4D 42 45 52 00 00 00 00 00 43 00 00 00 00 0A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 41 00 00 00 00 00 00 00 00 00 00 43 00 00 00 00 50 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42 00 00 00 00 00 00 00 00 00 00 43 00 00 00 00 50 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4F 4B 50 4F 5F 41 00 00 00 00 00 43 00 00 00 00 0E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4F 4B 50 4F 5F 42 00 00 00 00 00 43 00 00 00 00 0E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 41 43 43 4F 55 4E 54 5F 41 00 00 43 00 00 00 00 0E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 41 43 43 4F 55 4E 54 5F 42 00 00 43 00 00 00 00 0E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42 41 4E 4B 5F 41 00 00 00 00 00 43 00 00 00 00 50 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42 41 4E 4B 5F 42 00 00 00 00 00 43 00 00 00 00 50 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4D 46 4F 5F 41 00 00 00 00 00 00 43 00 00 00 00 09 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4D 46 4F 5F 42 00 00 00 00 00 00 43 00 00 00 00 09 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 43 49 54 59 5F 41 00 00 00 00 00 43 00 00 00 00 19 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 43 49 54 59 5F 42 00 00 00 00 00 43 00 00 00 00 19 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 41 4D 4F 55 4E 54 00 00 00 00 00 43 00 00 00 00 12 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 44 45 54 41 49 4C 53 00 00 00 00 43 00 00 00 00 A0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 47 55 49 4C 54 59 00 00 00 00 00 43 00 00 00 00 32 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 44 45 54 41 49 4C 53 5F 54 00 00 43 00 00 00 00 32 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00';
--aaa:='44 4F 43 5F 44 41 54 45 00 00 00 44 00 00 00 00 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4E 55 4D 42 45 52 00 00 00 00 00 43 00 00 00 00 0A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 41 4D 4F 55 4E 54 00 00 00 00 00 4E 00 00 00 00 0F 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 41 5F 4E 41 4D 45 00 00 00 00 00 43 00 00 00 00 26 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 41 5F 4F 4B 50 4F 00 00 00 00 00 43 00 00 00 00 0E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 41 5F 4D 46 4F 00 00 00 00 00 00 4E 00 00 00 00 09 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 41 5F 42 41 4E 4B 4E 41 4D 45 00 43 00 00 00 00 26 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 41 5F 41 43 43 4F 55 4E 54 00 00 43 00 00 00 00 0E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42 5F 4E 41 4D 45 00 00 00 00 00 43 00 00 00 00 26 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42 5F 4F 4B 50 4F 00 00 00 00 00 43 00 00 00 00 0E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42 5F 4D 46 4F 00 00 00 00 00 00 4E 00 00 00 00 09 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42 5F 42 41 4E 4B 4E 41 4D 45 00 43 00 00 00 00 26 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42 5F 41 43 43 4F 55 4E 54 00 00 43 00 00 00 00 0E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4D 45 4D 4F 00 00 00 00 00 00 00 43 00 00 00 00 A0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 43 43 59 5F 44 41 54 45 00 00 00 44 00 00 00 00 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 41 5F 43 4F 55 4E 54 52 59 00 00 4E 00 00 00 00 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42 5F 43 4F 55 4E 54 52 59 00 00 4E 00 00 00 00 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 45 58 50 45 4E 53 45 5F 49 54 00 43 00 00 00 00 32 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 52 45 53 50 4F 4E 53 49 42 4C 00 43 00 00 00 00 32 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00';
FOR i IN 1..576 LOOP
  l_header := l_header ||chr(to_number(REGEXP_substr(aaa,'[^ ]+',1,i),'XX'));
  END LOOP;

    --Завершающий заголовок символ 0D
    l_header := l_header || chr(13);
    dbms_lob.createtemporary(l_blob, true);
    for i in 1 .. trunc(length(l_header) / 2000) + 1 loop
      dbms_lob.append(l_blob,
                      utl_raw.cast_to_raw(substr(l_header, 1, 2000)));
      l_header := substr(l_header, 2000);
    end loop;

v_select := 'SELECT CONVERT(
rpad(substr(to_char(to_date2(datp,''yyyymmdd''),''yyyymmdd''),1,10) ,10)||
rpad(substr(nplat,1,10) ,10)||
rpad(substr(upper(text_firma(okpon,0)),1,80) ,80)||
rpad(substr(upper(text_firma(okpop,nvl(dpidp,0))),1,80) ,80)||
rpad(substr(lpad(okpon,8,''0''),1,14) ,14)||
rpad(substr(lpad(okpop,8,''0''),1,14) ,14)||
rpad(substr(to_char(rshetn),1,14) ,14)||
rpad(substr(to_char(nvl(schet_new,rshetp)),1,14) ,14)||
rpad(substr(upper(text_bank(mfon,filn)),1,80) ,80)||
rpad(substr(nvl(bank_name,upper(text_bank(mfop,filp))),1,80) ,80)||
rpad(substr(to_char(mfon,''99999999''),1,9) ,9)||
rpad(substr(to_char(nvl(mfo_new,mfop),''99999999''),1,9) ,9)||
rpad(substr(to_char(804),1,25) ,25)||
rpad(substr(to_char(804),1,25) ,25)||
rpad(substr(decode(nvl(pval,0),0,trim(to_char(nvl(suman,0),''999999999999999.00'')),trim(to_char(0,''9''))),1,18),18)||
rpad(upper(substr(trim(prim)||'' ''||trim(prim3)||'' ''||trim(prim1),1,160)) ,160)||
rpad(substr(polz,1,50) ,50)||
rpad(substr(polz,1,50) ,50),
''CL8MSWIN1251'' )'  --,CL8MSWIN1251 ''RU8PC866''  -----''CL8ISO8859P5'',''CL8MSWIN1251''  --decode(nvl(pval,0),0,to_char(nvl(suman,0),''999999999999999.00''),to_char(0,''9''))||  --
--v_select := 'SELECT rpad(substr(to_char(to_date2(datp,''yyyymmdd''),''yyyymmdd''),1,8) ,8)||rpad(substr(nplat,1,9) ,9)||decode(nvl(pval,0),0,to_char(nvl(suman,0),''999999999999.00''),to_char(0,''9''))||rpad(substr(upper(text_firma(okpon,0)),1,38) ,38)||rpad(substr(lpad(okpon,8,''0''),1,14) ,14)||rpad(substr(to_char(mfon,''99999999''),1,9) ,9)||rpad(substr(upper(text_bank(mfon,filn)),1,38) ,38)||rpad(substr(to_char(rshetn),1,14) ,14)||rpad(substr(upper(text_firma(okpop,0)),1,38) ,38)||decode(length(okpop),9,rpad(substr(lpad(to_char(okpop),10,''0''),1,14) ,14),10,rpad(substr(lpad(to_char(okpop),10,''0''),1,14) ,14),rpad(substr(lpad(to_char(okpop),8,''0''),1,14) ,14) )||rpad(substr(to_char(mfop,''99999999''),1,9) ,9)||rpad(substr(upper(text_bank(mfop,filp)),1,38) ,38)||rpad(substr(to_char(rshetp),1,14) ,14)||rpad(upper(substr(trim(prim)||'' ''||trim(prim3)||'' ''||trim(prim1),1,160)) ,160)||rpad(substr(to_char(sysdate,''yyyymmdd''),1,8) ,8)||rpad(substr(to_char(980),1,3) ,3)||rpad(substr(to_char(decode(nvl(pval,0),0,980,3,643,4,974) ),1,3) ,3)||rpad(substr(polz,1,50) ,50)||rpad(substr(polz,1,50) ,50))'
||' FROM poruch where nvl(priz,0)='||pr||' and mfon in (335742) and polz like '''||polzz||'''';
--||rpad(substr(to_char(to_number(rshetp),''9999999999999''),1,14) ,14)||rpad(substr(to_char(mfop),1,6) ,6)||rpad(substr(to_char(okpop),1,10) ,10)||rpad(substr(text_firma(okpop,0),1,38) ,38)||rpad(substr(text_bank(mfop,filp),1,38) ,38)||rpad(substr(to_char(nplat),1,10) ,10)
    open all_columns for v_select;
    fetch all_columns
      into l_columns;
    while all_columns%found loop
      -- Символ CHR (32) обозначает, что записи не удалены
      l_lines := chr(32) || l_columns;
      dbms_lob.append(l_blob, utl_raw.cast_to_raw(l_lines));
      fetch all_columns
        into l_columns;
    end loop;
    --Символ-метка конца записи
    --dbms_lob.append(l_blob, utl_raw.cast_to_raw(chr(26))); --1A
    return l_blob;
    dbms_lob.freetemporary(l_blob);
  
END create_for_335742_online;

  function make_d4_header return varchar2 is
    l_header            varchar2(32767);
    l_number_of_columns binary_integer;
    l_line_length       binary_integer;
    l_number_of_records number;
    cursor c_columns is
      select c.column_name,
             decode(c.data_type,
                    'VARCHAR2',
                    'C',
                    'DATE',
                    'D',
                    'NUMBER',
                    'N',
                    'C') data_type,
             decode(c.data_type, 'DATE', 8, 'NUMBER', 10, c.data_length) data_length,
             nvl(c.data_scale, 0) data_scale
        from all_tab_columns c
       where c.table_name = 'NAT' and owner='ASUPPP';
  begin
    select count(*), sum(decode(c.data_type, 'DATE', 8, c.data_length)) + 1
    --+1 потому что к строке добавляется символ 
    --удалена или нет
      into l_number_of_columns, l_line_length
      from all_tab_columns c
     where c.table_name = 'NAT' and owner='ASUPPP';
  
    select count(*) into l_number_of_records from NAT;
    --ЗАГОЛОВОК
    --№ - номер байта
    -- №0 Версия/ 1 байт
    -- 03 - простая таблица
    l_header := chr(3);
    -- №1,2,3 Дата последнего обновления таблицы в формате YYMMDD/ 3 байта
    l_header := l_header || chr(to_number(to_char(sysdate, 'YY'))) ||
                chr(to_number(to_char(sysdate, 'MM'))) ||
                chr(to_number(to_char(sysdate, 'DD')));
    --№4,5,6,7 Количество записей в таблице/ 32 бита = 4 байта
    l_header := l_header ||
                rpad(to_ascii(l_number_of_records), 4, chr(0));
    --№8,9 Количество байтов, занимаемых заголовком
    --/16 бит = 2 байта = 32 + 32*n + 1, где n - количество столбцов
    -- а 1 - ограничительный байт 
    l_header := l_header ||
                rpad(to_ascii(32 + l_number_of_columns * 32 + 1),
                     2,
                     chr(0));
    --№10,11 Количество байтов, занимаемых записью/16 бит = 2 байта 
    l_header := l_header || rpad(to_ascii(to_number(to_char(l_line_length,'XXXX'))), 2, chr(0));
    --№12,13 Зарезервировано
    l_header := l_header || rpad(chr(0), 2, chr(0));
    --№14 Транзакция, 1-начало, 0-конец(завершена)
    l_header := l_header || chr(0);
    --№15 Кодировка: 1-закодировано, 0-нормальная видимость 
    l_header := l_header || chr(0);
    --№16-27 Использование многопользовательского окружения
    l_header := l_header || rpad(chr(0), 12, chr(0));
    --№28 Использование индекса 0-не использовать
    l_header := l_header || chr(0);
    --№29 Номер драйвера языка
    l_header := l_header || chr(3);
    --№30,31 Зарезервировано
    l_header := l_header || rpad(chr(0), 2, chr(0));
    --ОПИСАНИЯ ПОЛЕЙ В ЗАГОЛОВКЕ
    for i in c_columns loop
      --№0-10 Имя поля с 0-завершением/11 байт
      l_header := l_header ||
                  rpad(substr(i.column_name, 1, 10), 11, chr(0));
      --№11 Тип поля/1 байт
      l_header := l_header || i.data_type;
      --№12,13,14,15 Игнорируется/4 байта
      l_header := l_header || rpad(chr(0), 4, chr(0));
      --№16 Размер поля/1 байт
      l_header := l_header || chr(i.data_length);
      --№17 Количество знаков после запятой/1 байт
      l_header := l_header || chr(i.data_scale);
      --№18,19 Зарезервированная область/2 байта
      l_header := l_header || rpad(chr(0), 2, chr(0));
      --№20 Идентификатор рабочей области/1 байт
      l_header := l_header || chr(0);
      --№21,22 Многопользовательский dBase/2 байта
      l_header := l_header || rpad(chr(0), 2, chr(0));
      --№23 Установленные поля/1 байт
      l_header := l_header || chr(1);
      --№24 Зарезервировано/7 байт
      l_header := l_header || rpad(chr(0), 7, chr(0));
      --№31 Флаг MDX-поля: 01H если поле имеет метку индекса в MDX-файле, 00H - нет.
      l_header := l_header || chr(0);
    end loop;
    --Завершающий заголовок символ 0D
    l_header := l_header || chr(13);
    return l_header;
  end make_d4_header;
  function to_ascii(p_number in number) return varchar2 is
    l_number number := p_number;
    l_data   varchar2(8);
    l_bytes  number;
    l_byte   number;
  begin
    select vsize(l_number) into l_bytes from dual;
    for i in 1 .. l_bytes loop
      l_byte := trunc(mod(l_number, power(2, 8 * i)) /
                      power(2, 8 * (i - 1)));
      l_data := l_data || chr(l_byte);
    end loop;
    return l_data;
  end to_ascii;
  function make_d4_all return blob is
  
    l_columns   varchar2(32767);
    l_blob      blob;
    l_header    varchar2(32767);
    all_columns sys_refcursor;
    v_select    varchar2(32767);
    l_lines     varchar2(32767);
  begin
    --Формируем заголовок и записываем его
    l_header := make_d4_header;
    dbms_lob.createtemporary(l_blob, true);
    for i in 1 .. trunc(length(l_header) / 2000) + 1 loop
      dbms_lob.append(l_blob,
                      utl_raw.cast_to_raw(substr(l_header, 1, 2000)));
      l_header := substr(l_header, 2000);
    end loop;
    --формируем данные
    v_select := make_d4_column_script;
    open all_columns for v_select;
    fetch all_columns
      into l_columns;
    while all_columns%found loop
      -- Символ CHR (32) обозначает, что записи не удалены
      l_lines := chr(32) || l_columns;
      dbms_lob.append(l_blob, utl_raw.cast_to_raw(l_lines));
      fetch all_columns
        into l_columns;
    end loop;
    --Символ-метка конца записи
    dbms_lob.append(l_blob, utl_raw.cast_to_raw(chr(26)));
    return l_blob;
    dbms_lob.freetemporary(l_blob);
  end make_d4_all;

function make_d4_column_script return varchar2 is
   l_result varchar2(4000);
   l_column varchar2(4000);
   cursor c_all_columns is
   --Здесь надо привести свои форматы к формата dbf
     select decode(c.data_type,
                   'VARCHAR2',
                   'C',
                   'DATE',
                   'D',
                   'NUMBER',
                   'N',
                   'C') data_type,
            decode(c.data_type, 'DATE', 8, 'NUMBER',10, c.data_length) data_length,
            c.column_name,
            rownum column_seq --'
       from all_tab_columns c
      where c.table_name = 'NAT' and owner='ASUPPP';
 begin
   for rec_all_columns in c_all_columns loop
     --Для дат формат должен быть YYYYMMDD
     if rec_all_columns.data_type = 'D' then
       l_column := 'TO_CHAR' || '(' || rec_all_columns.column_name ||
                   ', ''YYYYMMDD'')';
     elsif rec_all_columns.data_type = 'N' then
       --Здесь нужно вставить свой формат чисел
       l_column := 'TO_CHAR(NVL(' || rec_all_columns.column_name || ',0),''999999999'')';
     else
       l_column := rec_all_columns.column_name;
     end if;
     --Если вдруг после преобразований получилось, 
     --что длина поля больше указанной,
     --обрезаем поле
     l_column := 'substr(' || l_column || ',1,' ||
                 rec_all_columns.data_length || ')';
     --Далее для формата dbf необходимо "дописать" значение
     --в колонке до максимальной длины колонки 
     l_column := 'rpad(' || l_column || ',' || rec_all_columns.data_length || ')';
     if l_result is not null then
       l_result := l_result || ' || ';
     end if;
     l_result := l_result || l_column;
   end loop;
   --Здесь нужно вставить свою кодировку CL8MSWIN1251 или CL8ISO8859P5, например
   l_result := 'SELECT CONVERT(' || l_result ||
               ',''CL8MSWIN1251'') FROM NAT';
   return l_result;
 end make_d4_column_script;
  
end xx_make_d_4_dbf_pkg;
/