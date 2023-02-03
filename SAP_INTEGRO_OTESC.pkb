CREATE OR REPLACE PACKAGE BODY ASUPPP.SAP_INTEGRO_OTESC
As

function  form_sap_tesc(ldate in date, lsmena in number,lid_interface in number,lagregat in number default 0) return saprec_set pipelined 
  is
  TYPE sapcur IS REF CURSOR  RETURN  sap_integro_tesc%ROWTYPE;
  saprec  sapcur;
  l_out  sap_integro_tesc%rowtype;
  k_date number;
  
  
  begin
    ------------------------------------------------------------------------------ “›—÷  -------------------------------------------------------
       
     --- ZPP_TESC_311_RUL
 -- ËÁÏÂÌËÚ¸ system_id
     if lid_interface=187 then  
           OPEN saprec FOR 
          SELECT 
           null   ID,        3 PROCESS_ID,        992  SYSTEM_ID,          null NOM_OPER,
           trunc(sp.date_oper,'dd')  DATE_OF_POSTING,        sp.date_oper DATE_WITH_TIME,        sp.smena  SMENA,       sp.brigada   BRIGADA,
           (select object_id from sap_sklad_lpc where r3_number='0901')     OBJECT_ID,      '0901'  OBJECT_IDR,      (select object_id from sap_sklad_lpc where r3_number=sp.sklad_otpr)      OBJECT_ID_ADD,       sp.sklad_otpr  OBJECT_ID_ADDR,        null  OBJECT_TYPE_ID,
           (select ozm_id from mdg where mdg_code=sp.ozm) SUBJECT_ID,      sp.ozm  SUBJECT_IDR,        (select naim_kr from mdg where mdg_code=sp.ozm)  DESCR_OZM,          1002 MEASURE_UNIT_ID,
           sp.shirina   SHIRINA,       sp.tolshina  TOLSHINA,       null  DLINA,      null  DIAMETR,      null   PROFIL,
           sp.ves   QUANTITY,       null  KOLPOZ,
           sp.nplv   N_PLAVKI,       ras_nplv( sp.nplv,4)  GOD_PLAVKI,       sp.nprt   N_PARTII,
            null  ID_KRATA,        null  N_KRATA,
            sp.id_rulona  ID_RULPACH,        sp.n_rulona  N_RULONA,         null  N_PACHKI, 
            sp.id_sklad  ID_RULPF,        sp.num_tesc N_RULPF,     null  N_LINE,
            null  SD_ORD,         null SD_POS,       4900  WERKS,         '4900_09'  CEX,          'œ‘'  VID_OZ,     '“›—÷'  N_CEX,
            187 ID_INTERFACE,          null STAT_DATE,          null STAT_USERID,          608 STAN,          null PRIM,          1 TYPE_REC,
             sp.id_sklad KLUS_ID,          0 STATUS,          null PRIZN,          null ACCOUNT_ID,          null ERP_DOC,          null ERP_POS, null VES_UPAK, null ves_pogon_metrai,null n_lot,null n_zak_isp,null n_stec   
            from tesc_sklad  sp
            where  sp.stan=60800 and status=0 and  trunc(date_oper,'dd')=ldate and smena=nvl(lsmena,smena) and sp.sklad_otpr is not null ;  
       end if;     
            
    ---    ZPP_TESC_261_RUL    —œ»—¿Õ»≈ –”ÀŒÕŒ¬ Õ¿ œŒ–≈« ” œŒÀŒ—
       if lid_interface=181 then  
            OPEN saprec FOR 
           SELECT 
           null   ID,        2 PROCESS_ID,        992  SYSTEM_ID,          null NOM_OPER,
           trunc(sp.data_oper,'dd')  DATE_OF_POSTING,        sp.data_oper DATE_WITH_TIME,        sp.smena  SMENA,       sp.brigada   BRIGADA,
           (select object_id from sap_pr_zakaz where erp_number=sp.erp_number)  OBJECT_ID,      sp.erp_number   OBJECT_IDR,        (select object_id from sap_sklad_lpc where r3_number='0901')  OBJECT_ID_ADD,       '0901'  OBJECT_ID_ADDR,        20232   OBJECT_TYPE_ID,
           (select ozm_id from mdg where mdg_code=sr.ozm) SUBJECT_ID,      sr.ozm  SUBJECT_IDR,        (select naim_kr from mdg where mdg_code=sr.ozm)  DESCR_OZM,          1002 MEASURE_UNIT_ID,
           sr.shirina   SHIRINA,       sr.tolshina  TOLSHINA,       null  DLINA,      null  DIAMETR,      null   PROFIL,
           sp.vesz   QUANTITY,       null  KOLPOZ,
           sr.nplv   N_PLAVKI,       ras_nplv( sr.nplv,4)  GOD_PLAVKI,       sr.nprt   N_PARTII,
            null  ID_KRATA,        null  N_KRATA,
            sr.id_rulona  ID_RULPACH,        sr.n_rulona  N_RULONA,         null  N_PACHKI, 
            sr.id_sklad  ID_RULPF,        sr.num_tesc N_RULPF,     null  N_LINE,
            null  SD_ORD,         null SD_POS,       4900  WERKS,         '4900_09'  CEX,          'œ‘'  VID_OZ,     '“›—÷'  N_CEX,
            181 ID_INTERFACE,          null STAT_DATE,          null STAT_USERID,          608 STAN,          null PRIM,          1 TYPE_REC,
             sr.id_sklad*1000000000+nvl( (select object_id from sap_pr_zakaz where erp_number=sp.erp_number),0) KLUS_ID,          0 STATUS,          null PRIZN,          null ACCOUNT_ID,          null ERP_DOC,          null ERP_POS, null VES_UPAK, null ves_pogon_metrai,null n_lot,null n_zak_isp,null n_stec   
            from (select id_sklad,min(data_oper) data_oper,min(smena) smena,min(brigada) brigada,round(sum(ves_fact),2) vesz,get_erp(num_pr_zak)  erp_number  from tesc_strip where stan=60800 and trunc(data_oper,'dd')=ldate and smena=nvl(lsmena,smena)   group by id_sklad,get_erp(num_pr_zak))  sp
            join tesc_sklad sr on sr.id_sklad=sp.id_sklad and status=0; 
       end if;
       
    ---         ZPP_TESC_101_POL      œŒ—”œÀ≈Õ»≈ œŒÀŒ— Ë Œ¡–≈«» œŒ—À≈ œŒ–≈« »
       if lid_interface=182 then  
            OPEN saprec FOR 
            SELECT 
            null   ID,        8  PROCESS_ID,        993  SYSTEM_ID,          null NOM_OPER,
            trunc(sp.data_oper,'dd')  DATE_OF_POSTING,        sp.data_oper DATE_WITH_TIME,        sp.smena  SMENA,       sp.brigada   BRIGADA,
          case when  (select naim from mdg where mdg_code=sp.ozm) like '%œÓÎÓÒ‡%' then   (select object_id from sap_sklad_lpc where r3_number='0903')  else (select object_id from sap_sklad_lpc where r3_number='0902')  end  OBJECT_ID,    
           case when  (select naim from mdg where mdg_code=sp.ozm) like '%œÓÎÓÒ‡%' then  '0903' else '0902' end  OBJECT_IDR,        (select object_id from sap_pr_zakaz where erp_number=sp.erp_number)  OBJECT_ID_ADD,       sp.erp_number  OBJECT_ID_ADDR,        20232   OBJECT_TYPE_ID,
            (select ozm_id from mdg where mdg_code=sp.ozm) SUBJECT_ID,      sp.ozm  SUBJECT_IDR,        (select naim_kr from mdg where mdg_code=sp.ozm)  DESCR_OZM,          1002 MEASURE_UNIT_ID,
            sp.shirina  SHIRINA,       sp.tolshina  TOLSHINA,       null  DLINA,      null  DIAMETR,      null   PROFIL,
            round(sp.ves_fact,2)   QUANTITY,
           sp.kol  KOLPOZ,
           sr.nplv   N_PLAVKI,       ras_nplv( sr.nplv,4)  GOD_PLAVKI,     sr.nprt         N_PARTII,
           null  ID_KRATA,       null N_KRATA,
           null ID_RULPACH,         null  N_RULONA,         null  N_PACHKI, 
           sr.id_sklad  ID_RULPF,        sr.num_tesc N_RULPF,       null  N_LINE,
          null  SD_ORD,         null SD_POS,       4900  WERKS,         '4900_09' CEX,          'œ‘' VID_OZ,          '“›—÷' N_CEX,
           182 ID_INTERFACE,          null STAT_DATE,          null STAT_USERID,          608 STAN,          null PRIM,          1 TYPE_REC,
           sp.id_sklad*1000000000+ nvl((select object_id from sap_pr_zakaz where erp_number=sp.erp_number),0)  KLUS_ID,          0 STATUS,          null PRIZN,          null ACCOUNT_ID,          null ERP_DOC,          null ERP_POS, null VES_UPAK, null ves_pogon_metrai,null n_lot,null n_zak_isp,null n_stec   
           from ( select  count(*) kol,max(shirina) shirina,max(tolshina) tolshina,sum(ves_fact) ves_fact,id_sklad,max(data_oper) data_oper,max(ozm) ozm,max(smena) smena,max(brigada) brigada,get_erp(num_pr_zak) erp_number from tesc_strip where stan=60800 and trunc(data_oper,'dd')=ldate and smena=nvl(lsmena,smena)  and obrez=0 group by id_sklad,get_erp(num_pr_zak))  sp
          join tesc_sklad sr on sr.id_sklad=sp.id_sklad and status=0
      union all
         SELECT 
            null   ID,        9  PROCESS_ID,        993  SYSTEM_ID,          null NOM_OPER,
            trunc(sp.data_oper,'dd')  DATE_OF_POSTING,        sp.data_oper DATE_WITH_TIME,        sp.smena  SMENA,       sp.brigada   BRIGADA,
           (select object_id from sap_sklad_lpc where r3_number='0905')   OBJECT_ID,        '0905'  OBJECT_IDR,        (select object_id from sap_pr_zakaz where erp_number=sp.erp_number)  OBJECT_ID_ADD,       sp.erp_number  OBJECT_ID_ADDR,        20232   OBJECT_TYPE_ID,
           (select ozm_id from mdg where mdg_code=sp.ozm) SUBJECT_ID,      sp.ozm  SUBJECT_IDR,        (select naim   from mdg where mdg_code=sp.ozm)  DESCR_OZM,          1002 MEASURE_UNIT_ID,
           null  SHIRINA,       null  TOLSHINA,       null  DLINA,      null  DIAMETR,      null   PROFIL,
           round(sp.ves_fact,2)   QUANTITY,null   KOLPOZ,
          sr.nplv   N_PLAVKI,       ras_nplv( sr.nplv,4)  GOD_PLAVKI,       null  N_PARTII,
           null  ID_KRATA,        null  N_KRATA,
           null ID_RULPACH,         null  N_RULONA,         null  N_PACHKI, 
           sr.id_sklad  ID_RULPF,        sr.num_tesc N_RULPF,
          null  N_LINE,
          null  SD_ORD,         null SD_POS,       4900  WERKS,         '4900_09' CEX,          'œ‘' VID_OZ,          '“›—÷' N_CEX,
          182 ID_INTERFACE,          null STAT_DATE,          null STAT_USERID,          608 STAN,          null PRIM,          1 TYPE_REC,
          sp.id_sklad*1000000000+ nvl((select object_id from sap_pr_zakaz where erp_number=sp.erp_number),0)  KLUS_ID,          0 STATUS,          null PRIZN,          null ACCOUNT_ID,          null ERP_DOC,          null ERP_POS, null VES_UPAK, null ves_pogon_metrai,null n_lot,null n_zak_isp,null n_stec   
         from ( select  max(shirina) shirina,max(tolshina) tolshina,sum(ves_fact) ves_fact,id_sklad,max(data_oper) data_oper,max(ozm) ozm,max(smena) smena,max(brigada) brigada,get_erp(num_pr_zak) erp_number from tesc_strip where stan=60800 and trunc(data_oper,'dd')=ldate and smena=nvl(lsmena,smena)  and obrez=1 group by id_sklad,get_erp(num_pr_zak))    sp
         join tesc_sklad sr on sr.id_sklad=sp.id_sklad and status=0;
       end if;
       
      ---  ZPP_TESC_311_POL       œ≈–≈Ã≈Ÿ≈Õ»≈ œŒÀŒ— ¬ À»Õ»ﬁ
         if lid_interface=183 then  
            OPEN saprec FOR 
          SELECT 
           null   ID,       3  PROCESS_ID,        994  SYSTEM_ID,          null NOM_OPER,
          trunc(sp.data_line,'dd')  DATE_OF_POSTING,        sp.data_line DATE_WITH_TIME,        sp.smena_line  SMENA,       sp.brigada_line   BRIGADA,
          (select object_id from sap_sklad_lpc where r3_number='0906')    OBJECT_ID,          '0906'    OBJECT_IDR,        (select object_id from sap_sklad_lpc where r3_number='0903')  OBJECT_ID_ADD,         '0903'   OBJECT_ID_ADDR,        null   OBJECT_TYPE_ID,
         (select ozm_id from mdg where mdg_code=sp.ozm) SUBJECT_ID,      sp.ozm  SUBJECT_IDR,        (select naim_kr from mdg where mdg_code=sp.ozm)  DESCR_OZM,          1002 MEASURE_UNIT_ID,
          sp.shirina  SHIRINA,       sp.tolshina  TOLSHINA,       null  DLINA,      null  DIAMETR,      null   PROFIL,
          round(sp.ves_fact,2)  QUANTITY,   sp.kol  KOLPOZ,
          sr.nplv   N_PLAVKI,       ras_nplv( sr.nplv,4)  GOD_PLAVKI,       null  N_PARTII,
          null  ID_KRATA,       null N_KRATA,
          null  ID_RULPACH,         null  N_RULONA,         null  N_PACHKI, 
          sr.id_sklad  ID_RULPF,        sr.num_tesc N_RULPF,
          sp.num_line  N_LINE,
           null  SD_ORD,         null SD_POS,       4900  WERKS,         '4900_09' CEX,          'œ‘' VID_OZ,          '“›—÷' N_CEX,
          183 ID_INTERFACE,          null STAT_DATE,          null STAT_USERID,          608 STAN,          null PRIM,          1 TYPE_REC,
          sp.id_sklad KLUS_ID,          0 STATUS,          null PRIZN,          null ACCOUNT_ID,          null ERP_DOC,          null ERP_POS, null VES_UPAK, null ves_pogon_metrai,null n_lot,null n_zak_isp,null n_stec   
          from ( select  count(*) kol,max(num_line) num_line ,max(shirina) shirina,max(tolshina) tolshina,sum(ves_fact) ves_fact,id_sklad,max(data_line) data_line,max(ozm) ozm,max(smena_line) smena_line,max(brigada_line) brigada_line  from tesc_strip where stan=60800 and trunc(data_line,'dd')=ldate  and smena_line=nvl(lsmena,smena_line)  and obrez=0 and num_line in(1,2) group by id_sklad)  sp
          join tesc_sklad sr on sr.id_sklad=sp.id_sklad and status=0;
       end if;
       
      --   ZPP_TESC_261_POL  —œ»—¿Õ»≈ œŒÀŒ— Õ¿ œ–Œ»«¬Œƒ—“¬Œ “–”¡
   
         if lid_interface=184 then  
            OPEN saprec FOR 
             SELECT 
             null   ID,             2  PROCESS_ID,             995  SYSTEM_ID,             null NOM_OPER,
             sp.data_pak  DATE_OF_POSTING,              last_minute_of_smena(sp.data_pak,sp.smena)  DATE_WITH_TIME,             sp.smena  SMENA,             sp.brigada  BRIGADA,
             (select object_id  from sap_pr_zakaz where erp_number=sp.num_pr_zak )   OBJECT_ID,             sp.num_pr_zak  OBJECT_IDR,       
             (select object_id from sap_sklad_lpc where r3_number='0906')  OBJECT_ID_ADD,                   '0906'  OBJECT_ID_ADDR,             20231   OBJECT_TYPE_ID,
             (select ozm_id from mdg where mdg_code=sp.ozm) SUBJECT_ID,                  sp.ozm  SUBJECT_IDR,         (select naim_kr from mdg where mdg_code=sp.ozm)  DESCR_OZM,          1002 MEASURE_UNIT_ID,
             sp.shirina  SHIRINA,                  sp.tolshina   TOLSHINA,            null   DLINA,             null  DIAMETR,             null   PROFIL,
             sp.ves_fact  QUANTITY,     
             null  KOLPOZ,             sp.nplv   N_PLAVKI,             ras_nplv( sp.nplv,4)   GOD_PLAVKI,    
             null   N_PARTII,             null  ID_KRATA,             null N_KRATA,            null ID_RULPACH,            null  N_RULONA,            null  N_PACHKI,            
             sp.id_sklad  ID_RULPF,               sp.num_tesc N_RULPF,            sp.num_line  N_LINE,
             null  SD_ORD,                      null SD_POS,            4900  WERKS,             '4900_09' CEX,            'œ‘' VID_OZ,             '“›—÷' N_CEX,            184 ID_INTERFACE,     null STAT_DATE,      null STAT_USERID,       608 STAN,    null PRIM,    1 TYPE_REC,
             sp.id_sklad*1000000 + sp.stp_unik   KLUS_ID,          
             0 STATUS,          null PRIZN,          null ACCOUNT_ID,          null ERP_DOC,          null ERP_POS, null VES_UPAK, null ves_pogon_metrai,null n_lot,null n_zak_isp,null n_stec   
            
           from  ( select trunc(tesc_paket.date_oper) data_pak,tesc_paket.brigada,tesc_paket.num_pr_zak,tesc_sklad.nplv,tesc_paket.smena,max(tesc_strip.shirina) shirina,max(tesc_strip.tolshina) tolshina,max(num_line) 
                        num_line,round(sum(tesc_strip_to_paket.ves ),2) ves_fact,tesc_strip.id_sklad,max(tesc_strip.ozm) ozm,  max(tesc_strip_to_paket.unik) stp_unik, tesc_sklad.num_tesc
                           from tesc_strip,tesc_strip_to_paket,tesc_paket,tesc_sklad where tesc_strip.stan=60800 and tesc_sklad.id_sklad=tesc_strip.id_sklad and tesc_strip.id_strip=tesc_strip_to_paket.id_strip and tesc_paket.id_pak=tesc_strip_to_paket.id_pak and obrez=0 and 
                           (trunc(tesc_paket.date_oper,'dd')=ldate and tesc_paket.smena=nvl(lsmena,tesc_paket.smena) and nvl(tesc_strip_to_paket.status,0)=0 or  trunc(tesc_strip_to_paket.stat_when,'dd')=ldate and tesc_paket.smena=nvl(lsmena,tesc_paket.smena) 
                            and nvl(tesc_strip_to_paket.status,0)=1)
                           group by tesc_strip.id_sklad,trunc(tesc_paket.date_oper),tesc_paket.smena,tesc_sklad.nplv,tesc_paket.num_pr_zak,tesc_paket.brigada, tesc_sklad.num_tesc
                           
                    --  union 
                      
                    --   select trunc(data_pak) data_pak,tesc_paket.brigada,tesc_paket.num_pr_zak,tesc_sklad.nplv,tesc_paket.smena,max(tesc_strip.shirina) shirina,max(tesc_strip.tolshina) tolshina,max(num_line) num_line,round(sum(tesc_strip_to_paket.ves ),2) ves_fact,tesc_strip.id_sklad,max(tesc_strip.ozm) ozm,
                    --    max(tesc_strip_to_paket.unik) stp_unik ,  tesc_sklad.num_tesc
                    --       from tesc_strip,tesc_strip_to_paket,tesc_paket, tesc_sklad where tesc_sklad.id_sklad=tesc_strip.id_sklad and tesc_strip.id_strip=tesc_strip_to_paket.id_strip and tesc_paket.id_pak=tesc_strip_to_paket.id_pak and obrez=0 and trunc(tesc_strip_to_paket.stat_when,'dd')=ldate and tesc_paket.smena=nvl(lsmena,tesc_paket.smena) 
                    --        and nvl(tesc_strip_to_paket.status,0)=1
                    --       group by tesc_strip.id_sklad,trunc(data_pak),tesc_paket.smena,tesc_sklad.nplv,tesc_paket.num_pr_zak,tesc_paket.brigada, tesc_sklad.num_tesc  
                           
                           ) sp;

       end if;
      
       ---    ZPP_TESC_101_TUB         œŒ—“”œÀ≈Õ»≈ œ¿ ≈“Œ¬ » Œ¡–≈«»    
     
          if lid_interface=185 then  
            OPEN saprec FOR 
            SELECT 
             null   ID,        8  PROCESS_ID,        996 SYSTEM_ID,          null NOM_OPER,
             trunc(st.date_oper,'dd')  DATE_OF_POSTING,        st.date_oper  DATE_WITH_TIME,        st.smena  SMENA,        st.brigada  BRIGADA,
             (select object_id from sap_sklad_lpc where r3_number='0907')    OBJECT_ID,       '0907'  OBJECT_IDR,      (select object_id from sap_pr_zakaz where erp_number=st.num_pr_zak )    OBJECT_ID_ADD,      st.num_pr_zak  OBJECT_ID_ADDR,        20231   OBJECT_TYPE_ID,
              (select ozm_id from mdg where mdg_code=st.ozm) SUBJECT_ID,      st.ozm  SUBJECT_IDR,        (select naim_kr from mdg where mdg_code=st.ozm)  DESCR_OZM,          1002 MEASURE_UNIT_ID,
               null  SHIRINA,      st.tolshina   TOLSHINA,       st.dlina   DLINA,       st.diameter  DIAMETR,       st.profil   PROFIL,
               st.ves   QUANTITY,    st.kol   KOLPOZ,
               st.nplv   N_PLAVKI,       ras_nplv( st.nplv,4)   GOD_PLAVKI,       st.n_part   N_PARTII,
                null  ID_KRATA,       null N_KRATA,
                id_pak ID_RULPACH,         null  N_RULONA,         n_pak  N_PACHKI, 
                null  ID_RULPF,        null N_RULPF,      (select max(num_line) from tesc_strip,tesc_strip_to_paket  where tesc_strip_to_paket.id_pak=st.id_pak and tesc_strip.id_strip=tesc_strip_to_paket.id_strip)   N_LINE,
                null  SD_ORD,         null SD_POS,       4900  WERKS,         '4900_09' CEX,          'œ‘' VID_OZ,          '“›—÷' N_CEX,
                185 ID_INTERFACE,          null STAT_DATE,          null STAT_USERID,          608 STAN,          null PRIM,          1 TYPE_REC,
                id_pak  KLUS_ID,          0 STATUS,          null PRIZN,          null ACCOUNT_ID,          null ERP_DOC,          null ERP_POS, 5 VES_UPAK, ves_teor_metr ves_pogon_metrai,null n_lot,null n_zak_isp,null n_stec   
           from  tesc_paket st
           where trunc(st.date_oper,'dd')=ldate and st.smena=nvl(lsmena,st.smena)  and nplv is not null  and st.zakaz_object_type_id=20231 and st.stan=60800 /*-- Ô‡ÍÂÚ˚, ÍÓÚÓ˚Â ÌÂ ‰Ó ÍÓÌˆ‡ ‚‚Â‰ÂÌ˚ ÌÂ ‰ÓÎÊÌ˚ ÔÂÂ‰‡‚‡Ú¸Òˇ*/
           
        union all
           
           SELECT 
            null   ID,        9  PROCESS_ID,        996  SYSTEM_ID,          null NOM_OPER,   --Ó·ÂÁ¸
            trunc(sp.data_oper,'dd')  DATE_OF_POSTING,        sp.data_oper DATE_WITH_TIME,        sp.smena  SMENA,       sp.brigada   BRIGADA,
           (select object_id from sap_sklad_lpc where r3_number='0910')   OBJECT_ID,        '0910'  OBJECT_IDR,        (select object_id from sap_pr_zakaz where erp_number=sp.erp_number)  OBJECT_ID_ADD,       sp.erp_number  OBJECT_ID_ADDR,        20231   OBJECT_TYPE_ID,
           (select ozm_id from mdg where mdg_code=sp.ozm) SUBJECT_ID,      sp.ozm  SUBJECT_IDR,        (select naim   from mdg where mdg_code=sp.ozm)  DESCR_OZM,          1002 MEASURE_UNIT_ID,
           null  SHIRINA,       null  TOLSHINA,       null  DLINA,      null  DIAMETR,      null   PROFIL,
           round(sp.ves_fact,2)   QUANTITY,null   KOLPOZ,
          sp.nplv   N_PLAVKI,       ras_nplv( sp.nplv,4)  GOD_PLAVKI,       sp.n_part  N_PARTII,
           null  ID_KRATA,        null  N_KRATA,
           null ID_RULPACH,         null  N_RULONA,         sp.n_pak  N_PACHKI, 
           null  ID_RULPF,        null N_RULPF,
          (select max(num_line) from tesc_strip,tesc_strip_to_paket  where tesc_strip_to_paket.id_pak=sp.id_pak and tesc_strip.id_strip=tesc_strip_to_paket.id_strip)   N_LINE,
          null  SD_ORD,         null SD_POS,       4900  WERKS,         '4900_09' CEX,          'œ‘' VID_OZ,          '“›—÷' N_CEX,
          185 ID_INTERFACE,          null STAT_DATE,          null STAT_USERID,          608 STAN,          null PRIM,          1 TYPE_REC,
          sp.id_pak  KLUS_ID,          0 STATUS,          null PRIZN,          null ACCOUNT_ID,          null ERP_DOC,          null ERP_POS, null VES_UPAK, null ves_pogon_metra,null n_lot,null n_zak_isp,null n_stec   
          
         from (  select 
                        stp.id_pak,
                        max(tp.tolshina) tolshina,
                        sum(nvl(stp.ves,0)) ves_fact,
                        max(tp.date_oper) data_oper,
                        max(stp.ozm) ozm,
                        max(tp.nplv) nplv,
                        max(tp.smena) smena,
                        max(tp.brigada) brigada,
                        max(tp.num_pr_zak) erp_number ,
                        max(tp.n_part) n_part,
                        max(tp.n_pak) n_pak
                     from 
                        tesc_strip_to_paket stp, tesc_paket tp 
                    where 
                        stp.ozm='38.11.580000.00088' and tp.id_pak=stp.id_pak and trunc(stp.stat_when,'dd')=ldate and lsmena=smena(stp.stat_when) and tp.nplv is not null   and tp.zakaz_object_type_id=20231 and tp.stan=60800
                    group by stp.id_pak)    sp
         ;
           
           
           
       end if;
       
       
        --- ZPP_TESC_KOR_TUB
       if lid_interface=186 then  
            OPEN saprec FOR 
           SELECT  -- ÔÓËÁ‚Ó‰ÒÚ‚Ó 
             null   ID,        8  PROCESS_ID,        998 SYSTEM_ID,          null NOM_OPER,
             trunc(st.data_pak_teor,'dd')  DATE_OF_POSTING,         last_minute_of_smena(st.data_pak_teor,st.smena_teor) DATE_WITH_TIME,        st.smena_teor  SMENA,        brig_po_smene(st.data_pak_teor,st.smena_teor)  BRIGADA,
             (select object_id from sap_sklad_lpc where r3_number='0907')    OBJECT_ID,       '0907'  OBJECT_IDR,        (select object_id from sap_pr_zakaz where erp_number=st.num_pr_zak_teor )    OBJECT_ID_ADD,      to_char(st.num_pr_zak_teor)  OBJECT_ID_ADDR,         20233   OBJECT_TYPE_ID,
              (select id_ozm from sap_pr_zakaz where erp_number=st.num_pr_zak_teor) SUBJECT_ID,      (select ozm from sap_pr_zakaz where erp_number=st.num_pr_zak_teor)  SUBJECT_IDR,        (select naim_kr from mdg where mdg_code= (select ozm from sap_pr_zakaz where erp_number=st.num_pr_zak_teor))  DESCR_OZM,          1002 MEASURE_UNIT_ID,
               null  SHIRINA,      st.tolshina   TOLSHINA,       st.dlina   DLINA,       st.diameter  DIAMETR,       st.profil   PROFIL,
               st.ves_teor   QUANTITY,    st.kol   KOLPOZ,
               st.nplv   N_PLAVKI,       ras_nplv( st.nplv,4)   GOD_PLAVKI,       st.n_part   N_PARTII,
                null  ID_KRATA,       null N_KRATA,
                id_pak ID_RULPACH,         null  N_RULONA,         n_pak  N_PACHKI, 
                null  ID_RULPF,        null N_RULPF,      (select max(num_line) from tesc_strip,tesc_strip_to_paket  where tesc_strip_to_paket.id_pak=st.id_pak and tesc_strip.id_strip=tesc_strip_to_paket.id_strip)   N_LINE,
                null  SD_ORD,         null SD_POS,       4900  WERKS,         '4900_09' CEX,          'œ‘' VID_OZ,          '“›—÷' N_CEX,
                186 ID_INTERFACE,          null STAT_DATE,          null STAT_USERID,          608 STAN,          null PRIM,          1 TYPE_REC,
                id_pak  KLUS_ID,          0 STATUS,          null PRIZN,          null ACCOUNT_ID,          null ERP_DOC,          null ERP_POS, 5 VES_UPAK, ves_teor_metr ves_pogon_metra,null n_lot,null n_zak_isp,null n_stec   
           from  tesc_paket st
           where trunc(st.data_pak_teor,'dd')=ldate and st.smena_teor=nvl(lsmena,st.smena_teor) and st.stan=60800
           union all
           SELECT  
             null   ID,        2  PROCESS_ID,        998 SYSTEM_ID,          null NOM_OPER,
           trunc(st.data_pak_teor,'dd')  DATE_OF_POSTING,         last_minute_of_smena(st.data_pak_teor,st.smena_teor) DATE_WITH_TIME,        st.smena_teor  SMENA,        brig_po_smene(st.data_pak_teor,st.smena_teor)  BRIGADA,
             (select object_id from sap_pr_zakaz where erp_number=st.num_pr_zak_teor )     OBJECT_ID,      to_char(st.num_pr_zak_teor)  OBJECT_IDR,        (select object_id from sap_sklad_lpc where r3_number='0908')   OBJECT_ID_ADD,     '0908'  OBJECT_ID_ADDR,        20233   OBJECT_TYPE_ID,
              (select ozm_id from mdg where mdg_code=st.ozm) SUBJECT_ID,      st.ozm  SUBJECT_IDR,        (select naim_kr from mdg where mdg_code=st.ozm)  DESCR_OZM,          1002 MEASURE_UNIT_ID,
               null  SHIRINA,      st.tolshina   TOLSHINA,       st.dlina   DLINA,       st.diameter  DIAMETR,       st.profil   PROFIL,
               st.ves   QUANTITY,    st.kol   KOLPOZ,
               st.nplv   N_PLAVKI,       ras_nplv( st.nplv,4)   GOD_PLAVKI,       st.n_part   N_PARTII,
                null  ID_KRATA,       null N_KRATA,
                id_pak ID_RULPACH,         null  N_RULONA,         n_pak  N_PACHKI, 
                null  ID_RULPF,        null N_RULPF,      (select max(num_line) from tesc_strip,tesc_strip_to_paket  where tesc_strip_to_paket.id_pak=st.id_pak and tesc_strip.id_strip=tesc_strip_to_paket.id_strip)   N_LINE,
                null  SD_ORD,         null SD_POS,       4900  WERKS,         '4900_09' CEX,          '√œ' VID_OZ,          '“›—÷' N_CEX,
                186 ID_INTERFACE,          null STAT_DATE,          null STAT_USERID,          608 STAN,          null PRIM,          1 TYPE_REC,
                id_pak  KLUS_ID,          0 STATUS,          null PRIZN,          null ACCOUNT_ID,          null ERP_DOC,          null ERP_POS, null VES_UPAK, ves_teor_metr ves_pogon_metra,null n_lot,null n_zak_isp,null n_stec   
           from  tesc_paket st
           where trunc(st.data_pak_teor,'dd')=ldate and st.smena_teor=nvl(lsmena,st.smena_teor) and st.stan=60800; 
          end if;
          
            --- ZPP_TESC2_311_RUL
 -- ËÁÏÂÌËÚ¸ system_id
     if lid_interface=207 then  
        OPEN saprec FOR 
          SELECT 
           null   ID,        3 PROCESS_ID,        0  SYSTEM_ID,          null NOM_OPER,
           trunc(sp.date_oper,'dd')  DATE_OF_POSTING,        sp.date_oper DATE_WITH_TIME,        sp.smena  SMENA,       sp.brigada   BRIGADA,
           (select object_id from sap_sklad_lpc where r3_number='6001')     OBJECT_ID,      '6001'  OBJECT_IDR,      (select object_id from sap_sklad_lpc where r3_number=sp.sklad_otpr)      OBJECT_ID_ADD,       sp.sklad_otpr  OBJECT_ID_ADDR,        null  OBJECT_TYPE_ID,
           (select ozm_id from mdg where mdg_code=sp.ozm) SUBJECT_ID,      sp.ozm  SUBJECT_IDR,        (select naim_kr from mdg where mdg_code=sp.ozm)  DESCR_OZM,          1002 MEASURE_UNIT_ID,
           sp.shirina   SHIRINA,       sp.tolshina  TOLSHINA,       null  DLINA,      null  DIAMETR,      null   PROFIL,
           sp.ves   QUANTITY,       null  KOLPOZ,
           sp.nplv   N_PLAVKI,       ras_nplv( sp.nplv,4)  GOD_PLAVKI,       sp.nprt   N_PARTII,
            null  ID_KRATA,        null  N_KRATA,
            sp.id_rulona  ID_RULPACH,        sp.n_rulona  N_RULONA,         null  N_PACHKI, 
            sp.id_sklad  ID_RULPF,        sp.num_tesc N_RULPF,     null  N_LINE,
            null  SD_ORD,         null SD_POS,       4900  WERKS,         '4900_60'  CEX,          'œ‘'  VID_OZ,     '“›—÷2'  N_CEX,
            207 ID_INTERFACE,          null STAT_DATE,          null STAT_USERID,          616 STAN,          null PRIM,          1 TYPE_REC,
             sp.id_sklad KLUS_ID,          0 STATUS,          null PRIZN,          null ACCOUNT_ID,          null ERP_DOC,          null ERP_POS, null VES_UPAK, null ves_pogon_metrai,null n_lot,null n_zak_isp,null n_stec   
            from tesc_sklad  sp
            where  sp.stan=61600 and status=0 and  trunc(date_oper,'dd')=ldate and smena=nvl(lsmena,smena) and sp.sklad_otpr is not null ;  
       end if;     
            
    ---    ZPP_TESC2_261_RUL    —œ»—¿Õ»≈ –”ÀŒÕŒ¬ Õ¿ œŒ–≈« ” œŒÀŒ—
       if lid_interface=201 then  
            OPEN saprec FOR 
           SELECT 
           null   ID,        2 PROCESS_ID,        979  SYSTEM_ID,          null NOM_OPER,
           trunc(sp.data_oper,'dd')  DATE_OF_POSTING,        sp.data_oper DATE_WITH_TIME,        sp.smena  SMENA,       sp.brigada   BRIGADA,
           (select object_id from sap_pr_zakaz where erp_number=sp.erp_number)  OBJECT_ID,      sp.erp_number   OBJECT_IDR,        (select object_id from sap_sklad_lpc where r3_number='6001')  OBJECT_ID_ADD,       '6001'  OBJECT_ID_ADDR,        20236   OBJECT_TYPE_ID,
           (select ozm_id from mdg where mdg_code=sr.ozm) SUBJECT_ID,      sr.ozm  SUBJECT_IDR,        (select naim_kr from mdg where mdg_code=sr.ozm)  DESCR_OZM,          1002 MEASURE_UNIT_ID,
           sr.shirina   SHIRINA,       sr.tolshina  TOLSHINA,       null  DLINA,      null  DIAMETR,      null   PROFIL,
           sp.vesz   QUANTITY,       null  KOLPOZ,
           sr.nplv   N_PLAVKI,       ras_nplv( sr.nplv,4)  GOD_PLAVKI,       sr.nprt   N_PARTII,
            null  ID_KRATA,        null  N_KRATA,
            sr.id_rulona  ID_RULPACH,        sr.n_rulona  N_RULONA,         null  N_PACHKI, 
            sr.id_sklad  ID_RULPF,        sr.num_tesc N_RULPF,     null  N_LINE,
            null  SD_ORD,         null SD_POS,       4900  WERKS,         '4900_60'  CEX,          'œ‘'  VID_OZ,     '“›—÷2'  N_CEX,
            201 ID_INTERFACE,          null STAT_DATE,          null STAT_USERID,          616 STAN,          null PRIM,          1 TYPE_REC,
             sr.id_sklad*1000000000+nvl( (select object_id from sap_pr_zakaz where erp_number=sp.erp_number),0) KLUS_ID,          0 STATUS,          null PRIZN,          null ACCOUNT_ID,          null ERP_DOC,          null ERP_POS, null VES_UPAK, null ves_pogon_metrai,null n_lot,null n_zak_isp,null n_stec   
            from (select id_sklad,min(data_oper) data_oper,min(smena) smena,min(brigada) brigada,round(sum(ves_fact),2) vesz,get_erp(num_pr_zak)  erp_number  from tesc_strip where stan=61600 and trunc(data_oper,'dd')=ldate and smena=nvl(lsmena,smena)   group by id_sklad,get_erp(num_pr_zak))  sp
            join tesc_sklad sr on sr.id_sklad=sp.id_sklad and status=0; 
       end if;
       
    ---         ZPP_TESC_101_POL      œŒ—”œÀ≈Õ»≈ œŒÀŒ— Ë Œ¡–≈«» œŒ—À≈ œŒ–≈« »
       if lid_interface=202 then  
            OPEN saprec FOR 
            SELECT 
            null   ID,        8  PROCESS_ID,        980  SYSTEM_ID,          null NOM_OPER,
            trunc(sp.data_oper,'dd')  DATE_OF_POSTING,        sp.data_oper DATE_WITH_TIME,        sp.smena  SMENA,       sp.brigada   BRIGADA,
           (select object_id from sap_sklad_lpc where r3_number='6003')  OBJECT_ID,    
             '6003'  OBJECT_IDR,        (select object_id from sap_pr_zakaz where erp_number=sp.erp_number)  OBJECT_ID_ADD,       sp.erp_number  OBJECT_ID_ADDR,        20236   OBJECT_TYPE_ID,
            (select ozm_id from mdg where mdg_code=sp.ozm) SUBJECT_ID,      sp.ozm  SUBJECT_IDR,        (select naim_kr from mdg where mdg_code=sp.ozm)  DESCR_OZM,          1002 MEASURE_UNIT_ID,
            sp.shirina  SHIRINA,       sp.tolshina  TOLSHINA,       null  DLINA,      null  DIAMETR,      null   PROFIL,
            round(sp.ves_fact,2)   QUANTITY,
           sp.kol  KOLPOZ,
           sr.nplv   N_PLAVKI,       ras_nplv( sr.nplv,4)  GOD_PLAVKI,     sr.nprt         N_PARTII,
           null  ID_KRATA,       null N_KRATA,
           null ID_RULPACH,         null  N_RULONA,         null  N_PACHKI, 
           sr.id_sklad  ID_RULPF,        sr.num_tesc N_RULPF,       null  N_LINE,
          null  SD_ORD,         null SD_POS,       4900  WERKS,         '4900_60' CEX,          'œ‘' VID_OZ,          '“›—÷2' N_CEX,
           202 ID_INTERFACE,          null STAT_DATE,          null STAT_USERID,          616 STAN,          null PRIM,          1 TYPE_REC,
           sp.id_sklad*1000000000+ nvl((select object_id from sap_pr_zakaz where erp_number=sp.erp_number),0)  KLUS_ID,          0 STATUS,          null PRIZN,          null ACCOUNT_ID,          null ERP_DOC,          null ERP_POS, null VES_UPAK, null ves_pogon_metrai,null n_lot,null n_zak_isp,null n_stec   
           from ( select  count(*) kol,max(shirina) shirina,max(tolshina) tolshina,sum(ves_fact) ves_fact,id_sklad,max(data_oper) data_oper,max(ozm) ozm,max(smena) smena,max(brigada) brigada,get_erp(num_pr_zak) erp_number from tesc_strip where stan=61600 and trunc(data_oper,'dd')=ldate and smena=nvl(lsmena,smena)  and obrez=0 group by id_sklad,get_erp(num_pr_zak))  sp
          join tesc_sklad sr on sr.id_sklad=sp.id_sklad and status=0
      union all
         SELECT 
            null   ID,        9  PROCESS_ID,        980  SYSTEM_ID,          null NOM_OPER,
            trunc(sp.data_oper,'dd')  DATE_OF_POSTING,        sp.data_oper DATE_WITH_TIME,        sp.smena  SMENA,       sp.brigada   BRIGADA,
           (select object_id from sap_sklad_lpc where r3_number='6005')   OBJECT_ID,        '6005'  OBJECT_IDR,        (select object_id from sap_pr_zakaz where erp_number=sp.erp_number)  OBJECT_ID_ADD,       sp.erp_number  OBJECT_ID_ADDR,        20236   OBJECT_TYPE_ID,
           (select ozm_id from mdg where mdg_code=sp.ozm) SUBJECT_ID,      sp.ozm  SUBJECT_IDR,        (select naim   from mdg where mdg_code=sp.ozm)  DESCR_OZM,          1002 MEASURE_UNIT_ID,
           null  SHIRINA,       null  TOLSHINA,       null  DLINA,      null  DIAMETR,      null   PROFIL,
           round(sp.ves_fact,2)   QUANTITY,null   KOLPOZ,
          sr.nplv   N_PLAVKI,       ras_nplv( sr.nplv,4)  GOD_PLAVKI,       null  N_PARTII,
           null  ID_KRATA,        null  N_KRATA,
           null ID_RULPACH,         null  N_RULONA,         null  N_PACHKI, 
           sr.id_sklad  ID_RULPF,        sr.num_tesc N_RULPF,
          null  N_LINE,
          null  SD_ORD,         null SD_POS,       4900  WERKS,         '4900_60' CEX,          'œ‘' VID_OZ,          '“›—÷2' N_CEX,
          202 ID_INTERFACE,          null STAT_DATE,          null STAT_USERID,          616 STAN,          null PRIM,          1 TYPE_REC,
          sp.id_sklad*1000000000+ nvl((select object_id from sap_pr_zakaz where erp_number=sp.erp_number),0)  KLUS_ID,          0 STATUS,          null PRIZN,          null ACCOUNT_ID,          null ERP_DOC,          null ERP_POS, null VES_UPAK, null ves_pogon_metrai,null n_lot,null n_zak_isp,null n_stec   
         from ( select  max(shirina) shirina,max(tolshina) tolshina,sum(ves_fact) ves_fact,id_sklad,max(data_oper) data_oper,max(ozm) ozm,max(smena) smena,max(brigada) brigada,get_erp(num_pr_zak) erp_number from tesc_strip where stan=61600 and trunc(data_oper,'dd')=ldate and smena=nvl(lsmena,smena)  and obrez=1 group by id_sklad,get_erp(num_pr_zak))    sp
         join tesc_sklad sr on sr.id_sklad=sp.id_sklad and status=0;
       end if;
       
      ---  ZPP_TESC_311_POL       œ≈–≈Ã≈Ÿ≈Õ»≈ œŒÀŒ— ¬ À»Õ»ﬁ
         if lid_interface=203 then  
            OPEN saprec FOR 
          SELECT 
           null   ID,       3  PROCESS_ID,        981  SYSTEM_ID,          null NOM_OPER,
          trunc(sp.data_line,'dd')  DATE_OF_POSTING,        sp.data_line DATE_WITH_TIME,        sp.smena_line  SMENA,       sp.brigada_line   BRIGADA,
          (select object_id from sap_sklad_lpc where r3_number='6006')    OBJECT_ID,          '6006'    OBJECT_IDR,        (select object_id from sap_sklad_lpc where r3_number='6003')  OBJECT_ID_ADD,         '6003'   OBJECT_ID_ADDR,        null   OBJECT_TYPE_ID,
         (select ozm_id from mdg where mdg_code=sp.ozm) SUBJECT_ID,      sp.ozm  SUBJECT_IDR,        (select naim_kr from mdg where mdg_code=sp.ozm)  DESCR_OZM,          1002 MEASURE_UNIT_ID,
          sp.shirina  SHIRINA,       sp.tolshina  TOLSHINA,       null  DLINA,      null  DIAMETR,      null   PROFIL,
          round(sp.ves_fact,2)  QUANTITY,   sp.kol  KOLPOZ,
          sr.nplv   N_PLAVKI,       ras_nplv( sr.nplv,4)  GOD_PLAVKI,       null  N_PARTII,
          null  ID_KRATA,       null N_KRATA,
          null  ID_RULPACH,         null  N_RULONA,         null  N_PACHKI, 
          sr.id_sklad  ID_RULPF,        sr.num_tesc N_RULPF,
          sp.num_line  N_LINE,
           null  SD_ORD,         null SD_POS,       4900  WERKS,         '4900_60' CEX,          'œ‘' VID_OZ,          '“›—÷2' N_CEX,
          203 ID_INTERFACE,          null STAT_DATE,          null STAT_USERID,          616 STAN,          null PRIM,          1 TYPE_REC,
          sp.id_sklad KLUS_ID,          0 STATUS,          null PRIZN,          null ACCOUNT_ID,          null ERP_DOC,          null ERP_POS, null VES_UPAK, null ves_pogon_metrai,null n_lot,null n_zak_isp,null n_stec   
          from ( select  count(*) kol,max(num_line) num_line ,max(shirina) shirina,max(tolshina) tolshina,sum(ves_fact) ves_fact,id_sklad,max(data_line) data_line,max(ozm) ozm,max(smena_line) smena_line,max(brigada_line) brigada_line  from tesc_strip where stan=61600 and trunc(data_line,'dd')=ldate  and smena_line=nvl(lsmena,smena_line)  and obrez=0 and num_line in(1,2) group by id_sklad)  sp
          join tesc_sklad sr on sr.id_sklad=sp.id_sklad and status=0;
       end if;
       
      --   ZPP_TESC_261_POL  —œ»—¿Õ»≈ œŒÀŒ— Õ¿ œ–Œ»«¬Œƒ—“¬Œ “–”¡
   
         if lid_interface=204 then  
            OPEN saprec FOR 
             SELECT 
             null   ID,             2  PROCESS_ID,             982   SYSTEM_ID,             null NOM_OPER,
             sp.data_pak  DATE_OF_POSTING,              last_minute_of_smena(sp.data_pak,sp.smena)  DATE_WITH_TIME,             sp.smena  SMENA,             sp.brigada  BRIGADA,
             (select object_id  from sap_pr_zakaz where erp_number=sp.num_pr_zak )   OBJECT_ID,             sp.num_pr_zak  OBJECT_IDR,       
             (select object_id from sap_sklad_lpc where r3_number='6006')  OBJECT_ID_ADD,                   '6006'  OBJECT_ID_ADDR,             20235   OBJECT_TYPE_ID,
             (select ozm_id from mdg where mdg_code=sp.ozm) SUBJECT_ID,                  sp.ozm  SUBJECT_IDR,         (select naim_kr from mdg where mdg_code=sp.ozm)  DESCR_OZM,          1002 MEASURE_UNIT_ID,
             sp.shirina  SHIRINA,                  sp.tolshina   TOLSHINA,            null   DLINA,             null  DIAMETR,             null   PROFIL,
             sp.ves_fact  QUANTITY,     
             null  KOLPOZ,             sp.nplv   N_PLAVKI,             ras_nplv( sp.nplv,4)   GOD_PLAVKI,    
             null   N_PARTII,             null  ID_KRATA,             null N_KRATA,            null ID_RULPACH,            null  N_RULONA,            null  N_PACHKI,            
             sp.id_sklad  ID_RULPF,               sp.num_tesc N_RULPF,            sp.num_line  N_LINE,
             null  SD_ORD,                      null SD_POS,            4900  WERKS,             '4900_60' CEX,            'œ‘' VID_OZ,             '“›—÷2' N_CEX,            204 ID_INTERFACE,     null STAT_DATE,      null STAT_USERID,       616 STAN,    null PRIM,    1 TYPE_REC,
             sp.id_sklad*1000000 + sp.stp_unik   KLUS_ID,          
             0 STATUS,          null PRIZN,          null ACCOUNT_ID,          null ERP_DOC,          null ERP_POS, null VES_UPAK, null ves_pogon_metrai,null n_lot,null n_zak_isp,null n_stec   
            
           from  ( select trunc(tesc_paket.date_oper) data_pak,tesc_paket.brigada,tesc_paket.num_pr_zak,tesc_sklad.nplv,tesc_paket.smena,max(tesc_strip.shirina) shirina,max(tesc_strip.tolshina) tolshina,max(num_line) 
                        num_line,round(sum(tesc_strip_to_paket.ves ),2) ves_fact,tesc_strip.id_sklad,max(tesc_strip.ozm) ozm,  max(tesc_strip_to_paket.unik) stp_unik, tesc_sklad.num_tesc
                           from tesc_strip,tesc_strip_to_paket,tesc_paket,tesc_sklad where tesc_strip.stan=61600 and tesc_sklad.id_sklad=tesc_strip.id_sklad and tesc_strip.id_strip=tesc_strip_to_paket.id_strip and tesc_paket.id_pak=tesc_strip_to_paket.id_pak and obrez=0 and 
                           (trunc(tesc_paket.date_oper,'dd')=ldate and tesc_paket.smena=nvl(lsmena,tesc_paket.smena) and nvl(tesc_strip_to_paket.status,0)=0 or  trunc(tesc_strip_to_paket.stat_when,'dd')=ldate and tesc_paket.smena=nvl(lsmena,tesc_paket.smena) 
                            and nvl(tesc_strip_to_paket.status,0)=1)
                           group by tesc_strip.id_sklad,trunc(tesc_paket.date_oper),tesc_paket.smena,tesc_sklad.nplv,tesc_paket.num_pr_zak,tesc_paket.brigada, tesc_sklad.num_tesc
                           
                    --  union 
                      
                    --   select trunc(data_pak) data_pak,tesc_paket.brigada,tesc_paket.num_pr_zak,tesc_sklad.nplv,tesc_paket.smena,max(tesc_strip.shirina) shirina,max(tesc_strip.tolshina) tolshina,max(num_line) num_line,round(sum(tesc_strip_to_paket.ves ),2) ves_fact,tesc_strip.id_sklad,max(tesc_strip.ozm) ozm,
                    --    max(tesc_strip_to_paket.unik) stp_unik ,  tesc_sklad.num_tesc
                    --       from tesc_strip,tesc_strip_to_paket,tesc_paket, tesc_sklad where tesc_sklad.id_sklad=tesc_strip.id_sklad and tesc_strip.id_strip=tesc_strip_to_paket.id_strip and tesc_paket.id_pak=tesc_strip_to_paket.id_pak and obrez=0 and trunc(tesc_strip_to_paket.stat_when,'dd')=ldate and tesc_paket.smena=nvl(lsmena,tesc_paket.smena) 
                    --        and nvl(tesc_strip_to_paket.status,0)=1
                    --       group by tesc_strip.id_sklad,trunc(data_pak),tesc_paket.smena,tesc_sklad.nplv,tesc_paket.num_pr_zak,tesc_paket.brigada, tesc_sklad.num_tesc  
                           
                           ) sp;

       end if;
      
       ---    ZPP_TESC_101_TUB         œŒ—“”œÀ≈Õ»≈ œ¿ ≈“Œ¬ » Œ¡–≈«»    
     
          if lid_interface=205 then  
            OPEN saprec FOR 
            SELECT 
             null   ID,        8  PROCESS_ID,        983 SYSTEM_ID,          null NOM_OPER,
             trunc(st.date_oper,'dd')  DATE_OF_POSTING,        st.date_oper  DATE_WITH_TIME,        st.smena  SMENA,        st.brigada  BRIGADA,
             (select object_id from sap_sklad_lpc where r3_number='6007')    OBJECT_ID,       '6007'  OBJECT_IDR,      (select object_id from sap_pr_zakaz where erp_number=st.num_pr_zak )    OBJECT_ID_ADD,      st.num_pr_zak  OBJECT_ID_ADDR,        20235   OBJECT_TYPE_ID,
              (select ozm_id from mdg where mdg_code=st.ozm) SUBJECT_ID,      st.ozm  SUBJECT_IDR,        (select naim_kr from mdg where mdg_code=st.ozm)  DESCR_OZM,          1002 MEASURE_UNIT_ID,
               null  SHIRINA,      st.tolshina   TOLSHINA,       st.dlina   DLINA,       st.diameter  DIAMETR,       st.profil   PROFIL,
               st.ves   QUANTITY,    st.kol   KOLPOZ,
               st.nplv   N_PLAVKI,       ras_nplv( st.nplv,4)   GOD_PLAVKI,       st.n_part   N_PARTII,
                null  ID_KRATA,       null N_KRATA,
                id_pak ID_RULPACH,         null  N_RULONA,         n_pak  N_PACHKI, 
                null  ID_RULPF,        null N_RULPF,      (select max(num_line) from tesc_strip,tesc_strip_to_paket  where tesc_strip_to_paket.id_pak=st.id_pak and tesc_strip.id_strip=tesc_strip_to_paket.id_strip)   N_LINE,
                null  SD_ORD,         null SD_POS,       4900  WERKS,         '4900_60' CEX,          'œ‘' VID_OZ,          '“›—÷2' N_CEX,
                205 ID_INTERFACE,          null STAT_DATE,          null STAT_USERID,          616 STAN,          null PRIM,          1 TYPE_REC,
                id_pak  KLUS_ID,          0 STATUS,          null PRIZN,          null ACCOUNT_ID,          null ERP_DOC,          null ERP_POS, 5 VES_UPAK, ves_teor_metr ves_pogon_metrai,null n_lot,null n_zak_isp,null n_stec   
           from  tesc_paket st
           where trunc(st.date_oper,'dd')=ldate and st.smena=nvl(lsmena,st.smena)  and nplv is not null  and st.zakaz_object_type_id=20235  and st.stan=61600 /*-- Ô‡ÍÂÚ˚, ÍÓÚÓ˚Â ÌÂ ‰Ó ÍÓÌˆ‡ ‚‚Â‰ÂÌ˚ ÌÂ ‰ÓÎÊÌ˚ ÔÂÂ‰‡‚‡Ú¸Òˇ*/
           
        union all
           
           SELECT 
            null   ID,        9  PROCESS_ID,        983  SYSTEM_ID,          null NOM_OPER,   --Ó·ÂÁ¸
            trunc(sp.data_oper,'dd')  DATE_OF_POSTING,        sp.data_oper DATE_WITH_TIME,        sp.smena  SMENA,       sp.brigada   BRIGADA,
           (select object_id from sap_sklad_lpc where r3_number='6010')   OBJECT_ID,        '6010'  OBJECT_IDR,        (select object_id from sap_pr_zakaz where erp_number=sp.erp_number)  OBJECT_ID_ADD,       sp.erp_number  OBJECT_ID_ADDR,        20235   OBJECT_TYPE_ID,
           (select ozm_id from mdg where mdg_code=sp.ozm) SUBJECT_ID,      sp.ozm  SUBJECT_IDR,        (select naim   from mdg where mdg_code=sp.ozm)  DESCR_OZM,          1002 MEASURE_UNIT_ID,
           null  SHIRINA,       null  TOLSHINA,       null  DLINA,      null  DIAMETR,      null   PROFIL,
           round(sp.ves_fact,2)   QUANTITY,null   KOLPOZ,
          sp.nplv   N_PLAVKI,       ras_nplv( sp.nplv,4)  GOD_PLAVKI,       sp.n_part  N_PARTII,
           null  ID_KRATA,        null  N_KRATA,
           null ID_RULPACH,         null  N_RULONA,         sp.n_pak  N_PACHKI, 
           null  ID_RULPF,        null N_RULPF,
          (select max(num_line) from tesc_strip,tesc_strip_to_paket  where tesc_strip_to_paket.id_pak=sp.id_pak and tesc_strip.id_strip=tesc_strip_to_paket.id_strip)   N_LINE,
          null  SD_ORD,         null SD_POS,       4900  WERKS,         '4900_60' CEX,          'œ‘' VID_OZ,          '“›—÷2' N_CEX,
          205 ID_INTERFACE,          null STAT_DATE,          null STAT_USERID,          616 STAN,          null PRIM,          1 TYPE_REC,
          sp.id_pak  KLUS_ID,          0 STATUS,          null PRIZN,          null ACCOUNT_ID,          null ERP_DOC,          null ERP_POS, null VES_UPAK, null ves_pogon_metra,null n_lot,null n_zak_isp,null n_stec   
          
         from (  select 
                        stp.id_pak,
                        max(tp.tolshina) tolshina,
                        sum(nvl(stp.ves,0)) ves_fact,
                        max(tp.date_oper) data_oper,
                        max(stp.ozm) ozm,
                        max(tp.nplv) nplv,
                        max(tp.smena) smena,
                        max(tp.brigada) brigada,
                        max(tp.num_pr_zak) erp_number ,
                        max(tp.n_part) n_part,
                        max(tp.n_pak) n_pak
                     from 
                        tesc_strip_to_paket stp, tesc_paket tp 
                    where 
                        stp.ozm='38.11.580000.00088' and tp.id_pak=stp.id_pak and trunc(stp.stat_when,'dd')=ldate and lsmena=smena(stp.stat_when) and tp.nplv is not null   and tp.zakaz_object_type_id=20235 and tp.stan=61600
                    group by stp.id_pak)    sp
         ;
           
           
           
       end if;
       
       
        --- ZPP_TESC_KOR_TUB
       if lid_interface=206 then  
            OPEN saprec FOR 
           SELECT  -- ÔÓËÁ‚Ó‰ÒÚ‚Ó 
             null   ID,        8  PROCESS_ID,        985 SYSTEM_ID,          null NOM_OPER,
             trunc(st.data_pak_teor,'dd')  DATE_OF_POSTING,         last_minute_of_smena(st.data_pak_teor,st.smena_teor) DATE_WITH_TIME,        st.smena_teor  SMENA,        brig_po_smene(st.data_pak_teor,st.smena_teor)  BRIGADA,
             (select object_id from sap_sklad_lpc where r3_number='6007')    OBJECT_ID,       '6007'  OBJECT_IDR,        (select object_id from sap_pr_zakaz where erp_number=st.num_pr_zak_teor )    OBJECT_ID_ADD,      to_char(st.num_pr_zak_teor)  OBJECT_ID_ADDR,         20238   OBJECT_TYPE_ID,
              (select id_ozm from sap_pr_zakaz where erp_number=st.num_pr_zak_teor) SUBJECT_ID,      (select ozm from sap_pr_zakaz where erp_number=st.num_pr_zak_teor)  SUBJECT_IDR,        (select naim_kr from mdg where mdg_code= (select ozm from sap_pr_zakaz where erp_number=st.num_pr_zak_teor))  DESCR_OZM,          1002 MEASURE_UNIT_ID,
               null  SHIRINA,      st.tolshina   TOLSHINA,       st.dlina   DLINA,       st.diameter  DIAMETR,       st.profil   PROFIL,
               st.ves_teor   QUANTITY,    st.kol   KOLPOZ,
               st.nplv   N_PLAVKI,       ras_nplv( st.nplv,4)   GOD_PLAVKI,       st.n_part   N_PARTII,
                null  ID_KRATA,       null N_KRATA,
                id_pak ID_RULPACH,         null  N_RULONA,         n_pak  N_PACHKI, 
                null  ID_RULPF,        null N_RULPF,      (select max(num_line) from tesc_strip,tesc_strip_to_paket  where tesc_strip_to_paket.id_pak=st.id_pak and tesc_strip.id_strip=tesc_strip_to_paket.id_strip)   N_LINE,
                null  SD_ORD,         null SD_POS,       4900  WERKS,         '4900_60' CEX,          'œ‘' VID_OZ,          '“›—÷2' N_CEX,
                206 ID_INTERFACE,          null STAT_DATE,          null STAT_USERID,          616 STAN,          null PRIM,          1 TYPE_REC,
                id_pak  KLUS_ID,          0 STATUS,          null PRIZN,          null ACCOUNT_ID,          null ERP_DOC,          null ERP_POS, 5 VES_UPAK, ves_teor_metr ves_pogon_metra,null n_lot,null n_zak_isp,null n_stec   
           from  tesc_paket st
           where st.stan=61600 and trunc(st.data_pak_teor,'dd')=ldate and st.smena_teor=nvl(lsmena,st.smena_teor)
           union all
           SELECT  
             null   ID,        2  PROCESS_ID,        984 SYSTEM_ID,          null NOM_OPER,
           trunc(st.data_pak_teor,'dd')  DATE_OF_POSTING,         last_minute_of_smena(st.data_pak_teor,st.smena_teor) DATE_WITH_TIME,        st.smena_teor  SMENA,        brig_po_smene(st.data_pak_teor,st.smena_teor)  BRIGADA,
             (select object_id from sap_pr_zakaz where erp_number=st.num_pr_zak_teor )     OBJECT_ID,      to_char(st.num_pr_zak_teor)  OBJECT_IDR,        (select object_id from sap_sklad_lpc where r3_number='6008')   OBJECT_ID_ADD,     '6008'  OBJECT_ID_ADDR,        20238   OBJECT_TYPE_ID,
              (select ozm_id from mdg where mdg_code=st.ozm) SUBJECT_ID,      st.ozm  SUBJECT_IDR,        (select naim_kr from mdg where mdg_code=st.ozm)  DESCR_OZM,          1002 MEASURE_UNIT_ID,
               null  SHIRINA,      st.tolshina   TOLSHINA,       st.dlina   DLINA,       st.diameter  DIAMETR,       st.profil   PROFIL,
               st.ves   QUANTITY,    st.kol   KOLPOZ,
               st.nplv   N_PLAVKI,       ras_nplv( st.nplv,4)   GOD_PLAVKI,       st.n_part   N_PARTII,
                null  ID_KRATA,       null N_KRATA,
                id_pak ID_RULPACH,         null  N_RULONA,         n_pak  N_PACHKI, 
                null  ID_RULPF,        null N_RULPF,      (select max(num_line) from tesc_strip,tesc_strip_to_paket  where tesc_strip_to_paket.id_pak=st.id_pak and tesc_strip.id_strip=tesc_strip_to_paket.id_strip)   N_LINE,
                null  SD_ORD,         null SD_POS,       4900  WERKS,         '4900_60' CEX,          '√œ' VID_OZ,          '“›—÷2' N_CEX,
                206 ID_INTERFACE,          null STAT_DATE,          null STAT_USERID,          616 STAN,          null PRIM,          1 TYPE_REC,
                id_pak  KLUS_ID,          0 STATUS,          null PRIZN,          null ACCOUNT_ID,          null ERP_DOC,          null ERP_POS, null VES_UPAK, ves_teor_metr ves_pogon_metra,null n_lot,null n_zak_isp,null n_stec   
           from  tesc_paket st
           where st.stan=61600 and trunc(st.data_pak_teor,'dd')=ldate and st.smena_teor=nvl(lsmena,st.smena_teor) ; 
          end if;
       
    IF not saprec%ISOPEN THEN
     null;
   else
      LOOP
        FETCH saprec INTO l_out;         
        EXIT WHEN saprec%NOTFOUND;
         
          l_out.status:=0;
                    
            if nvl(l_out.object_id,0)=0 or nvl(l_out.object_id_add,0)=0 or nvl(l_out.subject_id,0)=0 or nvl(l_out.quantity,0)=0 or l_out.descr_ozm is null then
               l_out.status:=99;
               l_out.prim:='Œ¯Ë·Í‡ ‚ ‰‡ÌÌ˚ı: ÌÂÚ Ó·ˇÁ‡ÚÂÎ¸Ì˚ı ‰‡ÌÌ˚ı (ÔÓ ÒÍÎ‡‰Û,Œ«Ã ,œ« Á‡Í‡ÁÛ,ÚÓÌÌ‡ÊÛ)';
                       
            end if;
         
         k_date:=0;
          if l_out.id_interface in(182,185,202,205)  or l_out.id_interface in(186,206)  and l_out.process_id=8 then
              select max(ord_num),max(ord_poz),max(to_number(to_char(date_start,'yyyymm'))),max(nsnz),max(zak_numlot(nsnz,dpid,gdis,npoz)),max(zak_numspec(nsnz,dpid,gdis))   into l_out.sd_ord,l_out.sd_pos,k_date,l_out.n_zak_isp,l_out.n_lot,l_out.n_stec from sap_pr_zakaz where object_id=l_out.object_id_add;
                          if to_number(to_char(l_out.date_of_posting,'yyyymm'))!=k_date then
               l_out.status:=99;
               l_out.prim:=l_out.prim||' œÂËÓ‰ ‰ÂÈÒÚ‚Ëˇ Á‡Í‡Á‡ ÌÂ ÒÓÓÚ‚ÂÚÒÚ‚ÛÂÚ ÔÂËÓ‰Û ÓÔÂ‡ˆËË';
               end if;
          end if;
          
          if l_out.id_interface in(181,184,201,204)  or l_out.id_interface in(186,206) and l_out.process_id=2 then
           
              select max(ord_num),max(ord_poz),max(to_number(to_char(date_start,'yyyymm'))),max(nsnz),max(zak_numlot(nsnz,dpid,gdis,npoz)),max(zak_numspec(nsnz,dpid,gdis))   into l_out.sd_ord,l_out.sd_pos,k_date,l_out.n_zak_isp,l_out.n_lot,l_out.n_stec from sap_pr_zakaz where object_id=l_out.object_id;
              
                if to_number(to_char(l_out.date_of_posting,'yyyymm'))!=k_date then
               l_out.status:=99;
               l_out.prim:=l_out.prim||' œÂËÓ‰ ‰ÂÈÒÚ‚Ëˇ Á‡Í‡Á‡ ÌÂ ÒÓÓÚ‚ÂÚÒÚ‚ÛÂÚ ÔÂËÓ‰Û ÓÔÂ‡ˆËË';
                    end if;
          end if;
          
          pipe row(l_out);
         
           
           if lid_interface in(182,185,202,205)  and l_out.process_id=8  then
            l_out.process_id:=6;
            if l_out.id_interface in(182,202) then 
                 l_out.nom_oper:='1900';
            elsif  l_out.id_interface in(185,205) then 
                 l_out.nom_oper:='1910';
            end if;
        
          
            l_out.type_rec:=2;
            l_out.object_id:=l_out.object_id_add;
            l_out.object_idr:=l_out.object_id_addr;
            l_out.object_id_add:=-1;
            l_out.object_id_addr:='-1';
            pipe row(l_out);
            
                  
           end if;   
        
      END LOOP;
      CLOSE saprec;
 end if; 
  end  form_sap_tesc;
  


 function form_sap_tesc_period(ldate_s in date, ldate_po in date, lid_interface in number,lagregat in number default 0)  return saprec_set pipelined
  is
  TYPE sapcur IS REF CURSOR  RETURN  sap_integro_tesc%ROWTYPE;
  saprec  sapcur;
  l_out  sap_integro_tesc%rowtype;
  begin
  
    if ldate_po - ldate_s between 0 and 31 then
  
        for i in 1..ldate_po-ldate_s +1
        loop
             OPEN saprec FOR     select * from table(SAP_INTEGRO_OTESC.form_sap_tesc(ldate_s+i-1, null, lid_interface, nvl(lagregat,0)) ) ;
             loop
                 FETCH saprec INTO l_out;         
                 EXIT WHEN saprec%NOTFOUND;
                 pipe row(l_out);
             end loop;
            CLOSE saprec;
        end loop;
    
    end if;
  end  form_sap_tesc_period;
  
end sap_integro_otesc;
/