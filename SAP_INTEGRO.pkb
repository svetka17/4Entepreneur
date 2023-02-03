CREATE OR REPLACE PACKAGE BODY ASUPPP.SAP_INTEGRO
As


function  form_sap_object(ldate in date, lsmena in number,lid_interface in number,lagregat in number default 0) return saprec_set pipelined 
  is
  TYPE sapcur IS REF CURSOR  RETURN  sap_integro_lpc%ROWTYPE;
  saprec  sapcur;
  l_out  sap_integro_lpc%rowtype;
  p_snp number;
  k_date number;
  
  
  begin
    ------------------------------------------------------------------------------ ЛПЦ-1700 -------------------------------------------------------
   -- поступление слябов в ЛПЦ-1700  ZPP_311_SLABKC
      if lid_interface=1 then  
            OPEN saprec FOR 
                    SELECT  null id,trunc(n.date_otk,'dd') date_of_posting,last_minute_of_smena(n.date_otk,n.smena_otk) date_with_time,n.smena_otk smena,brig_po_smene(n.date_otk,n.smena_otk) brigada,
                                cex_integro_info (60500,0,0,0,sl.slyab_id,0,0,0,1) subject_id,
                                null subject_id_add,
                                cex_integro_info (60500,0,0,0,sl.slyab_id,0,0,0,2) subject_idr,
                                null subject_id_addr,(select object_id from sap_sklad_lpc where r3_number=case when n.cex_nazn = 61000 then '0604'  else '0605' end) object_id,(select object_id from sap_sklad_lpc where r3_number='0313') object_id_add,case when n.cex_nazn = 61000 then '0604'  else '0605' end object_idr,
                                '0313' object_id_addr,3 process_id,918 system_id,  1002  measure_unit_id, null account_id,null sd_ord,null sd_pos,
                                cex_integro_info (60500,0,0,0,sl.slyab_id,0,0,0,3)  descr_ozm,
                                dlina,shirina,tolshina,sl.ves quantity,pl.num_plavki n_plavki,pl.mnlz n_mnlz,null n_partii,null nom_oper,null n_slitka,sl.num_slyaba n_slyaba,null n_krata,null n_kolodca,null tip_izlognic,null id_slitka,slyab_id id_slyaba,null id_rulpf,null n_rulona,null n_pachki,null n_lista,null n_rulpf,
                                null n_avto,null id_krata,null id_rulpach,null erp_doc,null erp_pos,1 id_interface,null stat_date,null stat_userid,null n_motalki,null n_pechi,610 stan,4900 werks,'4900_06' cex,'ПФ' vid_oz,'1150' n_cex ,89200 kdpr,null kromka,null  travl,pl.marka_id id_marki,
                                nvl(pl.id_ntd,pl.id_gost) id_gostm,null id_gostt,null id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec,null date_of_postingr,slyab_id klus_id,null object_type_id,null object_type_r,null marka,pl.plavka_id,0 status,null brigada_v,null brigada_r,null n_line,null subject_id_pzr,null subject_id_pzd,null m_sklad,1 prizn,null kds,2 zagot,0 vidslyab,null obrab,
                                null n_korob,ras_nplv(pl.num_plavki,4) god_plavki,null id_krat_lista,null n_krat_lista,null mesto_hranen_1,null mesto_hranen_2,null n_nakl,null id_svar_rul,null shifr_reglam,null vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr  
                    FROM slyab sl 
                    left join slitok s using(slitok_id)
                    left join plavka pl on pl.plavka_id=s.plavka_id
                    JOIN sl_nakl n on n.nakl_id=sl.nakl_id 
                    WHERE n.status=3 AND trunc(n.date_otk)=ldate AND n.smena_otk=nvl(lsmena,n.smena_otk); 
       end if;
       
   -- поступление слитков в ЛПЦ-1700 ZPP_311_SLITCPS
       if lid_interface=2 then 
          OPEN saprec FOR 
             SELECT null id,  trunc(pl.date_cps,'dd') date_of_posting,last_minute_of_smena(pl.date_cps,pl.smena_cps) date_with_time,pl.smena_cps smena,pl.brig_cps  brigada, 
                          null subject_id,
                          null subject_id_add,   
                          null subject_idr,
                          null subject_id_addr,
                          (select object_id from sap_sklad_lpc where r3_number='0601') object_id,(select object_id from sap_sklad_lpc where r3_number='0503') object_id_add,
                          '0601' object_idr,'0503' object_id_addr,4 process_id,917 system_id, 1002  measure_unit_id,  null account_id,null sd_ord,null sd_pos,
                          null descr_ozm,
                          null dlina,null shirina,null tolshina,nvl(s.ves_fakt,s.ves)  quantity,pl.num_plavki n_plavki,pl.mnlz n_mnlz,null n_partii,
                          null nom_oper,to_char(num_slitka) n_slitka,null n_slyaba,null n_krata,null n_kolodca,(select tip_izl from spr_izlog where id=s.izl_id) tip_izlognic ,slitok_id id_slitka, null id_slyaba,null id_rulpf,null n_rulona,null n_pachki,null n_lista,null n_rulpf,null n_avto,null id_krata,null id_rulpach,
                          null erp_doc,null erp_pos,2 id_interface,null stat_date,null stat_userid,null n_motalki,null n_pechi,610 stan,4900 werks,'4900_06' cex,'ПФ' vid_oz,'1150' n_cex,88200 kdpr,null kromka,null  travl,pl.marka_id id_marki,
                          nvl(pl.id_ntd,pl.id_gost) id_gostm,null id_gostt,null id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec ,null date_of_postingr,slitok_id klus_id,null object_type_id,null object_type_r,null marka,pl.plavka_id,0 status,null brigada_v,null brigada_r,null n_line,null subject_id_pzr,null subject_id_pzd,null m_sklad,0 prizn,null kds,null zagot,null vidslyab,null obrab,
                          null n_korob,ras_nplv(pl.num_plavki,4) god_plavki,null id_krat_lista,null n_krat_lista,null mesto_hranen_1,null mesto_hranen_2,null n_nakl,null id_svar_ru,null shifr_reglam,null vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr  
             FROM slitok s 
             JOIN plavka pl on pl.plavka_id=s.plavka_id
             WHERE s.pr_att_otk=1 AND pl.date_cps=ldate AND pl.smena_cps=nvl(lsmena,pl.smena_cps)
             union all
             SELECT null id,  trunc(pl.date_cps,'dd') date_of_posting,last_minute_of_smena(pl.date_cps,pl.smena_cps) date_with_time,pl.smena_cps smena,pl.brig_cps  brigada, 
                          null subject_id,
                          null subject_id_add,   
                          null  subject_idr,
                          null subject_id_addr,
                          (select object_id from sap_sklad_lpc where r3_number='0503') object_id,null object_id_add,
                          '0503' object_idr,null object_id_addr,8 process_id,917 system_id, 1002  measure_unit_id,  null account_id,null sd_ord,null sd_pos,
                          null descr_ozm,
                          null dlina,null shirina,null tolshina,nvl(s.ves_fakt,s.ves)  quantity,pl.num_plavki n_plavki,pl.mnlz n_mnlz,null n_partii,
                          null nom_oper,to_char(num_slitka) n_slitka,null n_slyaba,null n_krata,null n_kolodca,(select tip_izl from spr_izlog where id=s.izl_id) tip_izlognic ,slitok_id id_slitka, null id_slyaba,null id_rulpf,null n_rulona,null n_pachki,null n_lista,null n_rulpf,s.num_tel n_avto,null id_krata,null id_rulpach,
                          null erp_doc,null erp_pos,2 id_interface,null stat_date,null stat_userid,null n_motalki,null n_pechi,610 stan,4900 werks,'4900_06' cex,'ПФ' vid_oz,'1150' n_cex,88200 kdpr,null kromka,null  travl,pl.marka_id id_marki,
                          nvl(pl.id_ntd,pl.id_gost) id_gostm,null id_gostt,null id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec ,null date_of_postingr,slitok_id klus_id,null object_type_id,null object_type_r,null marka,pl.plavka_id,0 status,null brigada_v,null brigada_r,null n_line,null subject_id_pzr,null subject_id_pzd,null m_sklad,0 prizn,null kds,null zagot,null vidslyab,null obrab,
                          null n_korob,ras_nplv(pl.num_plavki,4) god_plavki,null id_krat_lista,null n_krat_lista,null mesto_hranen_1,null mesto_hranen_2,null n_nakl,null id_svar_ru,null shifr_reglam,null vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr  
             FROM slitok s 
             JOIN plavka pl on pl.plavka_id=s.plavka_id
             WHERE s.pr_att_otk=1 AND pl.date_cps=ldate AND pl.smena_cps=nvl(lsmena,pl.smena_cps);
      end if; 
      
       -- Данные о списании слябов на порезку ZPP_261_REZSLAB
     if lid_interface=15 then
         OPEN saprec FOR
         SELECT null id,trunc(sl.date_ins,'dd') date_of_posting,sl.date_ins date_with_time,CEX.SMENA(sl.date_ins) smena,brig_po_smene(sl.date_ins,CEX.brigada(sl.date_ins))  brigada,
                             cex_integro_info (61000,173,0,0,sl.slyab_id,0,0,0,7) subject_id,   
                             null subject_id_add,
                             cex_integro_info (61000,173,0,0,sl.slyab_id,0,0,0,8)  subject_idr,
                             null subject_id_addr,to_number( cex_integro_info (61000,173,0,0,sl.slyab_id,0,0,0,4)) object_id,
                             (select object_id from sap_sklad_lpc where r3_number='0604')  object_id_add, 
                             cex_integro_info (61000,173,0,0,sl.slyab_id,0,0,0,5)  object_idr,
                             '0604' object_id_addr,2 process_id,933 system_id,1002  measure_unit_id,null account_id,null sd_ord,null sd_pos,
                             cex_integro_info (61000,173,0,0,sl.slyab_id,0,0,0,9) descr_ozm,
                            nvl(sy.dlina_cor,sy.dlina)  dlina, NVL (sy.shirina_rem, nvl(sy.shirina_cor,sy.shirina)) shirina, nvl(sy.tolshina_cor,sy.tolshina)  tolshina,
                             case when nvl(sy.dlina_cor,0)!=0 or nvl(sy.shirina_rem,0)!=0 then round(sy.tolshina*nvl(sy.shirina_rem,sy.shirina)*nvl(sy.dlina_cor,sy.dlina)*7.85/1000000000,3) else sy.ves end quantity,
                             pl.num_plavki n_plavki,pl.mnlz n_mnlz,null n_partii,null nom_oper,null n_slitka,nvl(to_char(sy.num_slyaba),sy.num_slyaba_full)  n_slyaba,null n_krata,null n_kolodca,null tip_izlognic,null id_slitka,
                             sy.slyab_id id_slyaba,null id_rulpf,null n_rulona,null n_pachki,null n_lista,null n_rulpf,null n_avto,null id_krata,null id_rulpach,
                             null erp_doc,null erp_pos,15 id_interface,null stat_date,null stat_userid,null n_motalki,null n_pechi,610 stan,4900 werks,'4900_06' cex,'ПФ' vid_oz,'1150' n_cex,case when pl.mnlz is null then 88200 else 89200 end kdpr,null kromka,null  travl,pl.marka_id id_marki,
                             nvl(pl.id_ntd,pl.id_gost) id_gostm,null id_gostt,null id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec,null date_of_postingr,sy.slyab_id klus_id ,20242 object_type_id,null object_type_r,null marka,pl.plavka_id,0 status,null brigada_v,null brigada_r,null n_line,null subject_id_pzr,null subject_id_pzd,
                             null m_sklad,1 prizn,null kds,case when nvl(pl.mnlz,0)=0 then 1 else 2 end  zagot,0 vidslyab,null obrab,
                             null n_korob,ras_nplv(pl.num_plavki,4) god_plavki,null id_krat_lista,null n_krat_lista,null mesto_hranen_1,null mesto_hranen_2,null n_nakl,null id_svar_ru,null shifr_reglam,null vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr  
                    FROM  (select prim_slyab_id,max(slyab_id) slyab_id,min(date_ins) date_ins   from slyab where trunc(date_ins) =ldate and nvl(pr_op,0)=4 and CEX.SMENA(date_ins)=nvl(lsmena,CEX.SMENA(date_ins)) and nvl(pr_cps,0)=0 group by prim_slyab_id) sl
                    join slyab sy  on sy.slyab_id=sl.prim_slyab_id
                    JOIN slitok s on s.slitok_id=sy.slitok_id
                    join plavka pl on pl.plavka_id=s.plavka_id ;
       end if;
       
     -- Данные о порезке слябов ZPP_101_REZSLAB
     if lid_interface=16 then
         OPEN saprec FOR
         SELECT null id,trunc(sl.date_ins,'dd') date_of_posting,sl.date_ins date_with_time,CEX.SMENA(sl.date_ins) smena,cex.brigada(sl.date_ins)  brigada,
                             cex_integro_info (61000,173,0,0,sl.slyab_id,0,0,0,1) subject_id,   
                             null subject_id_add,
                             cex_integro_info (61000,173,0,0,sl.slyab_id,0,0,0,2)  subject_idr,
                             null subject_id_addr, (select object_id from sap_sklad_lpc where r3_number='0618')  object_id,
                            to_number( cex_integro_info (61000,173,0,0,sl.slyab_id,0,0,0,4)) object_id_add,'0618'   object_idr,
                            cex_integro_info (61000,173,0,0,sl.slyab_id,0,0,0,5) object_id_addr,8 process_id,934 system_id,1002  measure_unit_id,null account_id,null sd_ord,null sd_pos,
                             cex_integro_info (61000,173,0,0,sl.slyab_id,0,0,0,3) descr_ozm,
                             nvl(sl.dlina_cor,sl.dlina) dlina,
                              NVL (sl.shirina_rem, nvl(sl.shirina_cor,sl.shirina) ) 
                              shirina, nvl(sl.tolshina_cor,sl.tolshina)  tolshina,
                             case when nvl(sl.dlina_cor,0)!=0 or nvl(sl.shirina_rem,0)!=0 then round(sl.tolshina*nvl(sl.shirina_rem,sl.shirina)*nvl(sl.dlina_cor,sl.dlina)*7.85/1000000000,3) else sl.ves end  quantity,
                             pl.num_plavki n_plavki,pl.mnlz n_mnlz,null n_partii,null nom_oper,null n_slitka,nvl(to_char(sl.num_slyaba),sl.num_slyaba_full)  n_slyaba,num_krat n_krata,null n_kolodca,null tip_izlognic,null id_slitka,
                             sl.slyab_id id_slyaba,null id_rulpf,null n_rulona,null n_pachki,null n_lista,null n_rulpf,null n_avto,null id_krata,null id_rulpach,
                             null erp_doc,null erp_pos,16 id_interface,null stat_date,null stat_userid,null n_motalki,null n_pechi,610 stan,4900 werks,'4900_06' cex,'ПФ' vid_oz,'1150' n_cex,case when pl.mnlz is null then 88200 else 89200 end kdpr,null kromka,null  travl,pl.marka_id id_marki,
                             nvl(pl.id_ntd,pl.id_gost) id_gostm,null id_gostt,null id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec,null date_of_postingr,sl.slyab_id  klus_id ,20242 object_type_id,null object_type_r,null marka,pl.plavka_id,0 status,null brigada_v,null brigada_r,null n_line,null subject_id_pzr,null subject_id_pzd,
                             null m_sklad,1 prizn,null kds,case when nvl(pl.mnlz,0)=0 then 1 else 2 end  zagot,case when nvl(pl.mnlz,0)=0 then 0 else 1 end vidslyab,null obrab,
                             null n_korob,ras_nplv(pl.num_plavki,4) god_plavki,null id_krat_lista,null n_krat_lista,null mesto_hranen_1,null mesto_hranen_2,null n_nakl,null id_svar_ru,null shifr_reglam,null vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr  
                    FROM slyab sl 
                    JOIN slitok s on s.slitok_id=sl.slitok_id
                    join plavka pl on pl.plavka_id=s.plavka_id
                    where trunc(sl.date_ins) =ldate and nvl(sl.pr_op,0)=4 and CEX.SMENA(sl.date_ins)=nvl(lsmena,CEX.SMENA(sl.date_ins))  and nvl(sl.pr_cps,0)=0;
    end if;     
    
    -- Перемещение НЛЗ резаных с адьюстажа ЛПЦ 1700  на нагрев в НК ZPP_311_NLZR1700
      if lid_interface=17  then
       OPEN saprec FOR
       SELECT null id,trunc(sy.data_reduc) date_of_posting,sy.data_reduc date_with_time,sy.smena_reduc  smena,brig_po_smene(sy.data_reduc,sy.smena_reduc)    brigada,
                             cex_integro_info (61000,173,0,0,sy.slyab_id,0,0,0,1) subject_id,   
                             null subject_id_add,
                             cex_integro_info (61000,173,0,0,sy.slyab_id,0,0,0,2)  subject_idr,
                             null subject_id_addr, (select object_id from sap_sklad_lpc where r3_number='0601') object_id,
                             (select object_id from sap_sklad_lpc where r3_number='0618')  object_id_add, '0601'  object_idr,'0618' object_id_addr,
                             3 process_id,932 system_id,1002  measure_unit_id,null account_id,null sd_ord,null sd_pos,
                             cex_integro_info (61000,173,0,0,sy.slyab_id,0,0,0,3) descr_ozm,
                            nvl(sy.dlina_cor,sy.dlina)  dlina, NVL (sy.shirina_rem, nvl(sy.shirina_cor,sy.shirina))  shirina, nvl(sy.tolshina_cor,sy.tolshina)  tolshina,
                             case when nvl(sy.dlina_cor,0)!=0 or nvl(sy.shirina_rem,0)!=0 then round(sy.tolshina*nvl(sy.shirina_rem,sy.shirina)*nvl(sy.dlina_cor,sy.dlina)*7.85/1000000000,3) else sy.ves end  quantity,
                             pl.num_plavki n_plavki,pl.mnlz n_mnlz,null n_partii,null nom_oper,null n_slitka,nvl(to_char(sy.num_slyaba),sy.num_slyaba_full)  n_slyaba,sy.num_krat n_krata,s.nkol n_kolodca,(select tip_izl from spr_izlog where id=s.izl_id) tip_izlognic,null id_slitka,
                             sy.slyab_id id_slyaba,null id_rulpf,null n_rulona,null n_pachki,null n_lista,null n_rulpf,null n_avto,null id_krata,null id_rulpach,
                             null erp_doc,null erp_pos,17 id_interface,null stat_date,null stat_userid,null n_motalki,null n_pechi,610 stan,4900 werks,'4900_06' cex,'ПФ' vid_oz,'1150' n_cex,case when pl.mnlz is null then 88200 else 89200 end kdpr,null kromka,null  travl,pl.marka_id id_marki,
                             nvl(pl.id_ntd,pl.id_gost) id_gostm,null id_gostt,null id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec,trunc(sy.data_reduc,'dd')  date_of_postingr,sy.slyab_id klus_id ,null object_type_id,null object_type_r,null marka,pl.plavka_id,0 status,null brigada_v,null brigada_r,null n_line,null subject_id_pzr,null subject_id_pzd,
                             null m_sklad,1 prizn,null kds,case when nvl(pl.mnlz,0)=0 then 1 else 2 end  zagot,case when nvl(pl.mnlz,0)=0 then 0 else 1 end vidslyab,null obrab,
                             null n_korob,ras_nplv(pl.num_plavki,4) god_plavki,null id_krat_lista,null n_krat_lista,null mesto_hranen_1,null mesto_hranen_2,null n_nakl,null id_svar_ru,null shifr_reglam,null vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr  
                    FROM slyab sy
                --    left join slyab sy on sy.slyab_id=sl.prim_slyab_id
                    JOIN slitok s on s.slitok_id=sy.slitok_id
                    join plavka pl on pl.plavka_id=s.plavka_id
                    where 
                    --sl.date_pu5=ldate AND sl.smena_pu5=nvl(lsmena,sl.smena_pu5)  and sl.prim_slyab_id_dest is  not null 
                    trunc(sy.data_reduc) =ldate and sy.smena_reduc=nvl(lsmena,sy.smena_reduc) and  sy.nakl is not null;
         end if;
      
   -- Данные о списании слитков и редуцированных слябов на производство слябов  катаных ZPP_261_1150
      if lid_interface=4 then
         OPEN saprec FOR
                 SELECT null id,trunc(sl.date_pu5,'dd') date_of_posting,last_minute_of_smena(sl.date_pu5,sl.smena_pu5) date_with_time,sl.smena_pu5 smena,sl.brig_pu5  brigada,
                             cex_integro_info (61000,176,0,0,sl.slyab_id,0,0,0,7) subject_id,   
                             null subject_id_add,
                             cex_integro_info (61000,176,0,0,sl.slyab_id,0,0,0,8)  subject_idr,
                             null subject_id_addr,to_number( cex_integro_info (61000,176,0,0,sl.slyab_id,0,0,0,4)) object_id,
                             (select object_id from sap_sklad_lpc where r3_number=case when sy.data_reduc is not null or pl.mnlz is null then '0601' else '0607' end)  object_id_add, cex_integro_info (61000,176,0,0,sl.slyab_id,0,0,0,5)  object_idr,case when sy.data_reduc is not null or pl.mnlz is null then '0601' else '0607' end object_id_addr,2 process_id,923 system_id,1002  measure_unit_id,null account_id,null sd_ord,null sd_pos,
                             cex_integro_info (61000,176,0,0,sl.slyab_id,0,0,0,9) descr_ozm,
                             case when mnlz is null then null else nvl(sy.dlina_cor,sy.dlina) end dlina, case when mnlz is null then null else NVL (sy.shirina_rem, nvl(sy.shirina_cor,sy.shirina)) end shirina, case when mnlz is null then null else nvl(sy.tolshina_cor,sy.tolshina) end tolshina,
                             case when mnlz is null then nvl(s.ves_fakt,s.ves)  else case when nvl(sy.dlina_cor,0)!=0 or nvl(sy.shirina_rem,0)!=0 then round(sy.tolshina*nvl(sy.shirina_rem,sy.shirina)*nvl(sy.dlina_cor,sy.dlina)*7.85/1000000000,3) else sy.ves end  end quantity,
                             pl.num_plavki n_plavki,pl.mnlz n_mnlz,null n_partii,null nom_oper,to_char(num_slitka) n_slitka,nvl(to_char(sy.num_slyaba),sy.num_slyaba_full)  n_slyaba,sy.num_krat n_krata,s.nkol n_kolodca,(select tip_izl from spr_izlog where id=s.izl_id) tip_izlognic,case when mnlz is null then s.slitok_id else null end id_slitka,
                             case when mnlz is null then null else sy.slyab_id end id_slyaba,null id_rulpf,null n_rulona,null n_pachki,null n_lista,null n_rulpf,null n_avto,null id_krata,null id_rulpach,
                             null erp_doc,null erp_pos,4 id_interface,null stat_date,null stat_userid,null n_motalki,null n_pechi,610 stan,4900 werks,'4900_06' cex,'ПФ' vid_oz,'1150' n_cex,case when pl.mnlz is null then 88200 else 89200 end kdpr,null kromka,null  travl,pl.marka_id id_marki,
                             nvl(pl.id_ntd,pl.id_gost) id_gostm,null id_gostt,null id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec,null date_of_postingr,sl.slyab_id klus_id ,case when pl.mnlz is null then 20217 else case when sy.data_reduc is not null then 20240 else 20241 end end object_type_id,null object_type_r,null marka,pl.plavka_id,0 status,null brigada_v,null brigada_r,null n_line,null subject_id_pzr,null subject_id_pzd,
                             null m_sklad,1 prizn,null kds,case when nvl(pl.mnlz,0)=0 then 1 else 2 end  zagot,case when nvl(pl.mnlz,0)!=0 and sy.data_reduc is not null then 1 else 0  end vidslyab,null obrab,
                             null n_korob,ras_nplv(pl.num_plavki,4) god_plavki,null id_krat_lista,null n_krat_lista,null mesto_hranen_1,null mesto_hranen_2,null n_nakl,null id_svar_ru,null shifr_reglam,null vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr  
                    FROM (select prim_slyab_id,slitok_id,min(slyab_id) slyab_id,min(date_pu5) date_pu5,min(smena_pu5) smena_pu5,min(brig_pu5) brig_pu5 from slyab where date_pu5=ldate AND smena_pu5=nvl(lsmena,smena_pu5) group by prim_slyab_id,slitok_id) sl 
                    left join slyab sy on sy.slyab_id=sl.prim_slyab_id
                    left JOIN slitok s on s.slitok_id=sl.slitok_id
                    left  join plavka pl on pl.plavka_id=s.plavka_id;
               --    where sl.date_pu5=ldate AND sl.smena_pu5=nvl(lsmena,sl.smena_pu5)
                     --and prim_slyab_id_dest is null ;
         
    end if; 
    
   
    
   -- Данные о производствe катаных слябов  ZPP_101_PF_1150
       if lid_interface=5 then 
                    OPEN saprec FOR
                        SELECT null id,trunc(sl.date_pu5,'dd') date_of_posting,last_minute_of_smena(sl.date_pu5,sl.smena_pu5) date_with_time,sl.smena_pu5 smena,sl.brig_pu5  brigada,
                             cex_integro_info(61000,176,0,0,sl.slyab_id,0,0,0,1) subject_id,   
                             null subject_id_add,
                              cex_integro_info(61000,176,0,0,sl.slyab_id,0,0,0,2) subject_idr,
                                null subject_id_addr,
                                (select object_id from sap_sklad_lpc where r3_number='0602') object_id,
                                to_number( cex_integro_info (61000,176,0,0,sl.slyab_id,0,0,0,4)) object_id_add,
                                '0602'  object_idr,
                                 cex_integro_info (61000,176,0,0,sl.slyab_id,0,0,0,5) object_id_addr,
                                8 process_id,924 system_id,1002  measure_unit_id,null account_id,null sd_ord,null sd_pos,
                                 cex_integro_info(61000,176,0,0,sl.slyab_id,0,0,0,3) descr_ozm,
                                 nvl(sl.dlina_cor,sl.dlina) dlina,NVL (sl.shirina_rem, nvl(sl.shirina_cor,sl.shirina)) shirina, nvl(sl.tolshina_cor,sl.tolshina) tolshina,sl.ves quantity,pl.num_plavki n_plavki,pl.mnlz n_mnlz,null n_partii,null nom_oper,to_char(s.num_slitka) n_slitka,nvl(to_char(sl.num_slyaba),sl.num_slyaba_full) n_slyaba,sl.num_krat n_krata,s.nkol n_kolodca,(select tip_izl from spr_izlog where id=s.izl_id) tip_izlognic,sl.slitok_id id_slitka,
                                sl.slyab_id id_slyaba,null id_rulpf,null n_rulona,null n_pachki,null n_lista,null n_rulpf,null n_avto,null id_krata,null id_rulpach,
                               null erp_doc,null erp_pos,5 id_interface,null stat_date,null stat_userid,null n_motalki,null n_pechi,610 stan,4900 werks,'4900_06' cex,'ПФ' vid_oz,'1150' n_cex,89100 kdpr,null kromka,null  travl,pl.marka_id id_marki,
                               nvl(pl.id_ntd,pl.id_gost) id_gostm,null id_gostt,null id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec,null date_of_postingr,sl.slyab_id klus_id ,case when pl.mnlz is null then 20217 else case when sy.data_reduc is not null then 20240 else 20241 end end object_type_id,null object_type_r,null marka,pl.plavka_id,0 status,null brigada_v,null brigada_r,null n_line,null subject_id_pzr,null subject_id_pzd,null m_sklad,1 prizn,null kds,(case when nvl(pl.mnlz,0)=0 then 1 else 2 end ) zagot,2  vidslyab,null obrab,
                               null n_korob,ras_nplv(pl.num_plavki,4) god_plavki,null id_krat_lista,null n_krat_lista,null mesto_hranen_1,null mesto_hranen_2,null n_nakl,null id_svar_ru,null shifr_reglam,null vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr  
                    FROM slyab sl 
                    left join slyab sy on sy.slyab_id=sl.prim_slyab_id
                    JOIN slitok s on s.slitok_id=sl.slitok_id
                     join plavka pl on pl.plavka_id=s.plavka_id
                    where sl.date_pu5=ldate AND sl.smena_pu5=nvl(lsmena,sl.smena_pu5); --  and prim_slyab_id_dest is null ;
         end if; 
         
  -- Данные о перемещении слябов на нагрев в печи ZPP_NAGR_1700
           if lid_interface=9  then 
                 OPEN saprec FOR
                   SELECT    null id, trunc(sl.data_pechi,'dd') date_of_posting,last_minute_of_smena(sl.data_pechi,sl.smena_pechi) date_with_time,sl.smena_pechi smena,brig_po_smene(sl.data_pechi,sl.smena_pechi)  brigada,
                   cex_integro_info(61000,176,0,0,sl.slyab_id,0,0,0,1) subject_id,
                                null subject_id_add, 
                                cex_integro_info(61000,176,0,0,sl.slyab_id,0,0,0,2)  subject_idr,
                                null subject_id_addr,
                                 (select object_id from sap_sklad_lpc where r3_number='0607') object_id,
                                 (select object_id from sap_sklad_lpc where r3_number=case when pr_lit=0 then '0602' else case when nvl(shirina_rem,0)!=0 then '0615' else '0604' end end )  object_id_add,
                                '0607' object_idr,case when pr_lit=0 then '0602' else case when nvl(shirina_rem,0)!=0 then '0615' else '0604' end end object_id_addr,3 process_id,case when sl.pr_lit=1 then 920 else 924 end system_id,  1002  measure_unit_id, null account_id,null sd_ord,null sd_pos,
                               cex_integro_info(61000,176,0,0,sl.slyab_id,0,0,0,3)  descr_ozm,
                                nvl(dlina_cor,dlina) dlina,NVL (shirina_rem, nvl(shirina_cor,shirina)) shirina, nvl(tolshina_cor,tolshina) tolshina, case when nvl(sl.dlina_cor,0)!=0 or nvl(sl.shirina_rem,0)!=0 then round(sl.tolshina*nvl(sl.shirina_rem,sl.shirina)*nvl(dlina_cor,dlina)*7.85/1000000000,3) else sl.ves end quantity,
                                pl.num_plavki n_plavki,pl.mnlz n_mnlz,null n_partii,null n_oper,to_char(num_slitka) n_slitka,nvl(to_char(sl.num_slyaba),sl.num_slyaba_full)  n_slyaba,sl.num_krat n_krata,s.nkol n_kolodca,(select tip_izl from spr_izlog where id=s.izl_id) tip_izlognic ,slitok_id id_slitka,slyab_id id_slyaba,
                                null id_rulpf,null n_rulona,null n_pachki,null n_lista,null n_rulpf,null n_avto,null id_krata,null id_rulpach,
                               null erp_doc,null erp_pos,9 id_interface,null stat_date,null stat_userid,null n_motalki,null n_pechi,610 stan,4900 werks,'4900_06' cex,'ПФ' vid_oz,'1700' n_cex,(case when sl.pr_lit=1 then 89200 else 89100 end) kdpr,null kromka,null  travl,pl.marka_id id_marki,
                                nvl(pl.id_ntd,pl.id_gost) id_gostm,null id_gostt,null id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec,null date_of_postingr,slyab_id klus_id ,null object_type_id,null object_type_r,null marka,pl.plavka_id,0 status,null brigada_v,null brigada_r,null n_line,null subject_id_pzr,null subject_id_pzd,null m_sklad,1 prizn,null kds,(case when nvl(pl.mnlz,0)=0 then 1 else 2 end ) zagot,(case when sl.pr_lit=1 then 0 else 2 end)  vidslyab,null obrab,
                                null n_korob,ras_nplv(pl.num_plavki,4) god_plavki,null id_krat_lista,null n_krat_lista,null mesto_hranen_1,null mesto_hranen_2,null n_nakl,null id_svar_ru,null shifr_reglam,null vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr  
                  FROM slyab sl
                  JOIN slitok s using(slitok_id)
                  join plavka pl on pl.plavka_id=s.plavka_id
                  where sl.data_pechi=ldate AND sl.smena_pechi=nvl(lsmena,sl.smena_pechi)  AND dest=5;
         end if; 
  
   -- Данные об отпуске  слябов (списании) на производство рулонов на стане 1700  ZPP_261_PF_1700
     if  lid_interface=10  then       
             OPEN saprec FOR
             SELECT  null id, trunc(pr.data_prokata,'dd') date_of_posting,last_minute_of_smena(pr.data_prokata,pr.smena_prokata) date_with_time,pr.smena_prokata smena,brig_po_smene(pr.data_prokata,pr.smena_prokata)  brigada,
                                cex_integro_info(61000,118,0,0,0,0,st.prokat_str_id,0,7) subject_id,
                                null subject_id_add, 
                                cex_integro_info(61000,118,0,0,0,0,st.prokat_str_id,0,8) subject_idr,
                                null subject_id_addr,
                                 to_number( cex_integro_info(61000,118,0,0,0,0,st.prokat_str_id,0,4)) object_id,
                                 (select object_id from sap_sklad_lpc where r3_number=decode(st.dest,5,'0607',2,'0602','0604'))  object_id_add,
                                cex_integro_info(61000,118,0,0,0,0,st.prokat_str_id,0,5) object_idr,
                                 decode(st.dest,5,'0607',2,'0602','0604') object_id_addr,2 process_id,case when st.dest=5 then 927 else 924 end system_id,  1002  measure_unit_id, null account_id,null sd_ord,null sd_pos,
                                 cex_integro_info(61000,118,0,0,0,0,st.prokat_str_id,0,9) descr_ozm,
                                 st.dlina_slyaba dlina,st.shirina_slyaba shirina,st.tolshina_slyaba tolshina,st.ves quantity,pl.num_plavki n_plavki,pl.mnlz n_mnlz,null n_partii,null n_oper,
                                 to_char(st.num_slitka) n_slitka,nvl(to_char(sl.num_slyaba),sl.num_slyaba_full)  n_slyaba,sl.num_krat n_krata,s.nkol n_kolodca,(select tip_izl from spr_izlog where id=s.izl_id) tip_izlognic,
                                 slitok_id id_slitka,slyab_id id_slyaba, null id_rulpf,null n_rulona,null n_pachki,null n_lista,null n_rulpf,null n_avto,null id_krata,null id_rulpach,
                                null erp_doc,null erp_pos,10 id_interface,null stat_date,null stat_userid,null n_motalki,null n_pechi,610 stan,4900 werks,'4900_06' cex,'ПФ' vid_oz,'1700' n_cex,(case when sl.pr_lit=1 then 89200 else 89100 end) kdpr,null kromka,null  travl,pl.marka_id id_marki,
                                nvl(pl.id_ntd,pl.id_gost) id_gostm,null id_gostt,null id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec ,null date_of_postingr,st.prokat_str_id klus_id,null object_type_id,null object_type_r,null marka,pl.plavka_id,0 status,null brigada_v,null brigada_r,null n_line,null subject_id_pzr,null subject_id_pzd,null m_sklad,1 prizn,null kds,(case when nvl(pl.mnlz,0)=0 then 1 else 2 end ) zagot,(case when sl.pr_lit=1 then 0 else 2 end) vidslyab,null obrab,
                                null n_korob,ras_nplv(pl.num_plavki,4) god_plavki,null id_krat_lista,null n_krat_lista,null mesto_hranen_1,null mesto_hranen_2,null n_nakl,null id_svar_ru,null shifr_reglam,null vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr  
             FROM prokat pr
             JOIN prokat_str st on st.prokat_id=pr.prokat_id
                JOIN slyab sl using(slyab_id)
                JOIN slitok s using(slitok_id)
                join plavka pl on pl.plavka_id=s.plavka_id                     
             WHERE  nvl(st.vozvrat,0)=0 AND st.pr_ready_str=1 AND  pr.data_prokata=ldate AND pr.smena_prokata=nvl(lsmena,pr.smena_prokata);
       end if;
  
    -- Данные о производстве рулонов гк ПФ  ZPP_101_PF_1700
      if  lid_interface=11  then       
             OPEN saprec FOR
               SELECT null id, trunc(pr.data_prokata,'dd') date_of_posting,last_minute_of_smena(pr.data_prokata,pr.smena_prokata) date_with_time,pr.smena_prokata smena,brig_po_smene(pr.data_prokata,pr.smena_prokata)  brigada,
               cex_integro_info(61000,118,0,0,0,0,st.prokat_str_id,0,1) subject_id, 
               null subject_id_add,
               cex_integro_info(61000,118,0,0,0,0,st.prokat_str_id,0,2) subject_idr,
                null subject_id_addr,
                (select object_id from sap_sklad_lpc where r3_number='0608')   object_id, 
                to_number( cex_integro_info (61000,118,0,0,0,0,st.prokat_str_id,0,4))   object_id_add,
                '0608' object_idr,
                cex_integro_info (61000,118,0,0,0,0,st.prokat_str_id,0,5) object_id_addr,
                8 process_id,928 system_id, 1002  measure_unit_id, null account_id,null sd_ord,null sd_pos,
                cex_integro_info(61000,118,0,0,0,0,st.prokat_str_id,0,3) descr_ozm,
                null dlina,pr.shirina,pr.tolshina,cr.ves_rul/1000  quantity,pl.num_plavki n_plavki,pl.mnlz n_mnlz,null n_partii,null nom_oper, cr.num_slitka n_slitka, nvl(to_char(sl.num_slyaba),sl.num_slyaba_full)  n_slyaba, null n_krata, 
                s.nkol n_kolodca,(select tip_izl from spr_izlog where id=s.izl_id) tip_izlognic,slitok_id id_slitka,st.slyab_id id_slyaba, cr.id id_rulpf,null n_rulona,null n_pachki,null n_lista,cp.num_matkart*100+cr.npp_num_rul n_rulpf,null n_avto,null id_krata,null id_rulpach, null erp_doc,null erp_pos,11 id_interface,null stat_date,null stat_userid,
                cr.num_motalki  n_motalki,sl.pechi_number n_pechi,610 stan,4900 werks,'4900_06' cex,'ПФ' vid_oz,'1700' n_cex,case when oboznachenie='РИФ' then 97040 else 97010 end kdpr,2 kromka,2  travl,pr.marka_id id_marki,
                nvl(pl.id_ntd,pl.id_gost) id_gostm,null id_gostt,null id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec ,null date_of_postingr,cr.id klus_id ,null object_type_id,null object_type_r ,null marka,pl.plavka_id,0 status ,null brigada_v,null brigada_r,null n_line,null subject_id_pzr,null subject_id_pzd ,null m_sklad,1 prizn,null kds,(case when nvl(pl.mnlz,0)=0 then 1 else 2 end ) zagot,null vidslyab,0 obrab,
                null n_korob,ras_nplv(pl.num_plavki,4) god_plavki,null id_krat_lista,null n_krat_lista,null mesto_hranen_1,null mesto_hranen_2,to_char(cp.num_matkart) n_nakl,null id_svar_ru,null shifr_reglam,null vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr                                    
             FROM prokat pr
             JOIN prokat_str st on st.prokat_id=pr.prokat_id
             left JOIN slyab sl on sl.slyab_id=st.slyab_id 
             join chp_rul cr on cr.prokat_str_id=st.prokat_str_id
             join chp_postup cp on cr.fk_id_postup=cp.id
               JOIN slitok s using(slitok_id)
               join plavka pl on pl.plavka_id=s.plavka_id
                 WHERE  nvl(st.vozvrat,0)=0 AND st.pr_ready_str=1 AND pr.data_prokata=ldate AND pr.smena_prokata=nvl(lsmena,pr.smena_prokata);                        
      end if;
       
      -- Данные о перемещении рулонов в ЦХП и на склад листоотделки стана 1700  ZPP_311_RULON
     if  lid_interface=12  then       
            OPEN saprec FOR 
             SELECT null id ,
                 case when cp.cex_id=61000 then trunc(cr.data_vzves,'dd') else  trunc(cp.data_postup,'dd') end  date_of_posting,
                 case when cp.cex_id=61000 then last_minute_of_smena(cr.data_vzves,cr.smena_vzves) else last_minute_of_smena(cp.data_postup, cp.smena_postup)  end date_with_time,
                 case when cp.cex_id=61000 then cr.smena_vzves else  cp.smena_postup  end smena,
                 case when cp.cex_id=61000 then brig_po_smene(cr.data_vzves,cr.smena_vzves)  else  brig_po_smene(cp.data_postup, cp.smena_postup)   end brigada,
                 cex_integro_info(61000,118,0,0,0,0,st.prokat_str_id,0,1) subject_id, 
                 null subject_id_add,
                 cex_integro_info(61000,118,0,0,0,0,st.prokat_str_id,0,2)  subject_idr,
                 null subject_id_addr,
                  (select object_id from sap_sklad_lpc where r3_number=(case when cp.cex_id=61000 then '0609' else '0801' end)) object_id, 
                  (select object_id from sap_sklad_lpc where r3_number='0608') object_id_add,
                  case when cp.cex_id=61000 then '0609' else '0801' end object_idr,
                 '0608' object_id_addr,
                 3 process_id,929 system_id, 1002  measure_unit_id, null account_id,null sd_ord,null sd_pos,
                 cex_integro_info(61000,118,0,0,0,0,st.prokat_str_id,0,3)  descr_ozm,
                 cp.dlina dlina,cp.shirina,cp.tolshina,cr.ves_rul/1000  quantity, pl.num_plavki n_plavki,pl.mnlz n_mnlz,null n_partii,null nom_oper,cr.num_slitka n_slitka,
                 nvl(to_char(sl.num_slyaba),sl.num_slyaba_full) n_slyaba,null n_krata,s.nkol n_kolodca,(select tip_izl from spr_izlog where id=s.izl_id)  tip_izlognic,slitok_id id_slitka,st.slyab_id id_slyaba,
                  cr.id id_rulpf,null n_rulona,null n_pachki,null n_lista,cp.num_matkart*100+cr.npp_num_rul n_rulpf,null n_avto,null id_krata,null id_rulpach, null erp_doc,null erp_pos,12 id_interface,null stat_date,null stat_userid,
                  cr.num_motalki  n_motalki,sl.pechi_number n_pechi,610 stan,4900 werks,'4900_06' cex,'ПФ' vid_oz,'1700' n_cex,case when oboznachenie='РИФ' then 97040 else 97010 end kdpr,2 kromka,2  travl,cp.kod_marki id_marki,
                   nvl(pl.id_ntd,pl.id_gost) id_gostm,null id_gostt,null id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec,null date_of_postingr,cr.id klus_id  ,null object_type_id,null object_type_r   ,null marka ,pl.plavka_id,0 status,null brigada_v,null brigada_r,null n_line,null subject_id_pzr,null subject_id_pzd ,null m_sklad,1 prizn,null kds  ,(case when nvl(pl.mnlz,0)=0 then 1 else 2 end ) zagot,null vidslyab,0 obrab,
                  null n_korob,ras_nplv(pl.num_plavki,4) god_plavki,null id_krat_lista,null n_krat_lista,null mesto_hranen_1,null mesto_hranen_2,to_char(cp.num_matkart) n_nakl,null id_svar_ru,null shifr_reglam,null vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr                                   
                 FROM chp_postup cp 
                JOIN chp_rul cr ON cp.id=cr.fk_id_postup
                JOIN prokat_str st on st.prokat_str_id=cr.prokat_str_id
              join prokat pr on pr.prokat_id=st.prokat_id
                left JOIN slyab sl on sl.slyab_id=st.slyab_id 
                left JOIN slitok s using(slitok_id)
                left join plavka pl on pl.plavka_id=s.plavka_id
               WHERE     ((cr.data_vzves=ldate AND cr.smena_vzves=nvl(lsmena,cr.smena_vzves) and cp.cex_id=61000) or (cp.data_postup=ldate AND cp.smena_postup=nvl(lsmena,cp.smena_postup) and cp.cex_id=61100)) ;
      end if;
       
      -- Данные о списании  рулонов гк на листоотделку ZPP_261_GP_1700
     if  lid_interface=13  then       
             OPEN saprec FOR 
             SELECT null id,
                  trunc(p.data_porezki,'dd')   date_of_posting,
                 last_minute_of_smena(p.data_porezki,p.smena_porezki)  date_with_time,
                  p.smena_porezki  smena,
                  brigada_porezki brigada,
                 cex_integro_info (61000,p.id_agregata,0,0,0,p.id,0,0,7)   subject_id, 
                 null subject_id_add,
                cex_integro_info (61000,p.id_agregata,0,0,0,p.id,0,0,8)  subject_idr,
                 null subject_id_addr,
                  to_number( cex_integro_info (61000,p.id_agregata,0,0,0,p.id,0,0,4) )   object_id,
                   (select object_id from sap_sklad_lpc where r3_number='0609') object_id_add,
                  cex_integro_info (61000,p.id_agregata,0,0,0,p.id,0,0,5)  object_idr,
                  '0609' object_id_addr,
                  2 process_id,930 system_id, 1002  measure_unit_id, null account_id,null sd_ord,null sd_pos,
                  cex_integro_info (61000,p.id_agregata,0,0,0,p.id,0,0,3)   descr_ozm,
                  cp.dlina dlina,cp.shirina,cp.tolshina,cr.ves_rul/1000  quantity, pl.num_plavki n_plavki,pl.mnlz n_mnlz,null n_partii,null nom_oper,cr.num_slitka n_slitka,
                  sl.num_slyaba n_slyaba,null n_krata,s.nkol n_kolodca,(select tip_izl from spr_izlog where id=s.izl_id)  tip_izlognic,s.slitok_id id_slitka,st.slyab_id id_slyaba,
                  cr.id id_rulpf,null n_rulona,null n_pachki,null n_lista,cp.num_matkart*100+cr.npp_num_rul  n_rulpf,null n_avto,null id_krata,null id_rulpach, null erp_doc,null erp_pos,13 id_interface,null stat_date,null stat_userid,
                  cr.num_motalki  n_motalki,sl.pechi_number n_pechi,610 stan,4900 werks,'4900_06' cex,'ПФ' vid_oz,'1700' n_cex,case when oboznachenie='РИФ' then 97040 else 97010 end kdpr,2 kromka,2  travl,cp.kod_marki id_marki,
                   nvl(pl.id_ntd,pl.id_gost) id_gostm,null id_gostt,null id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec ,null date_of_postingr,cr.id  klus_id   ,null object_type_id,null object_type_r  ,null marka ,pl.plavka_id,0 status ,null brigada_v,null brigada_r,decode(p.id_agregata,100,5,108,4,109,6,110,7,112,2,115,3,114,1) n_line,null subject_id_pzr,null subject_id_pzd ,null m_sklad,1 prizn,null kds ,(case when nvl(pl.mnlz,0)=0 then 1 else 2 end ) zagot,null vidslyab,0 obrab,
                  null n_korob,ras_nplv(pl.num_plavki,4) god_plavki,null id_krat_lista,null n_krat_lista,null mesto_hranen_1,null mesto_hranen_2,to_char(cp.num_matkart) n_nakl,null id_svar_ru,null shifr_reglam,null vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr                                  
                  FROM (select min(data_porezki) data_porezki,min(smena_porezki) smena_porezki,min(brigada_porezki) brigada_porezki ,fk_id_rul,min(id_agregata) id_agregata ,min(id) id   from chp_porezka where  prim_id IS NULL  and cex_id=61000  
                 group by fk_id_rul)  p 
                 JOIN chp_rul cr ON p.fk_id_rul=cr.id
            join chp_postup cp on  cp.id=cr.fk_id_postup
            JOIN prokat_str st on st.prokat_str_id=cr.prokat_str_id
            join prokat pr on pr.prokat_id=st.prokat_id
            left JOIN slyab sl on sl.slyab_id=st.slyab_id 
            join plavka pl on pl.plavka_id=pr.plavka_id 
            left JOIN slitok s on s.slitok_id=sl.slitok_id
            WHERE p.data_porezki=ldate AND p.smena_porezki=nvl(lsmena,p.smena_porezki)  and  (decode(p.id_agregata,100,5,108,4,109,6,110,7,112,2,115,3,114,1)=lagregat or nvl(lagregat,0)=0)
            ;
      end if;
       
    -- Данные о производстве рулонов, пачек листов на листоотделке ЛПЦ-1700  ZPP_101_GP_1700
      if lid_interface=14 then 
         OPEN saprec FOR
          SELECT null id,trunc(p.data_porezki,'dd')  date_of_posting,last_minute_of_smena(p.data_porezki,p.smena_porezki)  date_with_time,p.smena_porezki  smena,brigada_porezki brigada,
                     cex_integro_info (61000,p.id_agregata,0,0,0,p.id,0,0,1)  subject_id,
                      null subject_id_add, cex_integro_info (61000,p.id_agregata,0,0,0,p.id,0,0,2) subject_idr,
                       null subject_id_addr,  (select object_id from sap_sklad_lpc where r3_number='0611') object_id,
                       to_number( cex_integro_info (61000,p.id_agregata,0,0,0,p.id,0,0,4)) object_id_add,'0611' object_idr,
                       cex_integro_info (61000,p.id_agregata,0,0,0,p.id,0,0,5) object_id_addr,
                       8 process_id,931 system_id,   1002  measure_unit_id,null account_id,null sd_ord,null sd_pos,cex_integro_info (61000,p.id_agregata,0,0,0,p.id,0,0,3) descr_ozm,
                      p.dlina dlina,p.shirina,p.tolshina,round(p.ves/1000,3)  quantity,pl.num_plavki n_plavki,pl.mnlz n_mnlz,p.num_partii n_partii,null nom_oper,cr.num_slitka n_slitka,nvl(to_char(sl.num_slyaba),sl.num_slyaba_full) n_slyaba,null n_krata,s.nkol n_kolodca,(select tip_izl from spr_izlog where id=s.izl_id)  TIP_IZLOGNIC,
                      slitok_id id_slitka,st.slyab_id id_slyaba,cr.id id_rulpf,case when id_agregata!=112 then num_rul_pach else null end n_rulona,case when id_agregata=112 then num_rul_pach else null end n_pachki,null n_lista,cp.num_matkart*100+cr.npp_num_rul n_rulpf,null n_avto,null id_krata,p.id id_rulpach,null erp_doc,null erp_pos,
                      14 id_interface,null stat_date,null stat_usrid,cr.num_motalki  n_motalki,sl.pechi_number n_pechi,610 stan,4900 werks,'4900_06' cex,'ПФ' vid_oz,'1700' n_cex,(case when id_agregata=112 then case when oboznachenie='РИФ' then 97800 else 97000 end else  case when oboznachenie='РИФ' then 97040 else 97010 end end) kdpr,decode(p.kromka,'НО',2,'О',1,0) kromka,2  travl,p.id_marki id_marki,
                      gost_id id_gostm,gost3_id id_gostt,gost2_id id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec,null date_of_postingr,p.id klus_id,20216 object_type_id,null object_type_r,null marka,pl.plavka_id,0 status,null brigada_v,null brigada_r,decode(p.id_agregata,100,5,108,4,109,6,110,7,112,2,115,3,114,1) n_line,null subject_id_pzr,null subject_id_pzd,
                      p.m_sklad  m_sklad,0 prizn,null kds,null zagot,null vidslyab,null obrab,
                      null n_korob,ras_nplv(pl.num_plavki,4) god_plavki,null id_krat_lista,null n_krat_lista,null mesto_hranen_1,null mesto_hranen_2,to_char(num_matkart) n_nakl,null id_svar_ru,null shifr_reglam,p.kromka vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,cp.num_str n_str_prokat, decode(pr.vsad,3,'транзит','печи')  vid_nagr  
           FROM chp_porezka p 
           left join prb_task_st prbs using(prb_task_st_id)
           JOIN chp_rul cr ON p.fk_id_rul=cr.id
           join chp_postup cp on  cp.id=cr.fk_id_postup
           JOIN prokat_str st on st.prokat_str_id=cr.prokat_str_id
            join prokat pr on pr.prokat_id=st.prokat_id
           left JOIN slyab sl on sl.slyab_id=st.slyab_id 
           join plavka pl on pl.plavka_id=pr.plavka_id 
           left JOIN slitok s using(slitok_id)
           WHERE p.data_porezki=ldate AND p.smena_porezki=nvl(lsmena,p.smena_porezki) AND p.prim_id IS NULL  and p.cex_id=61000 
           and  (decode(p.id_agregata,100,5,108,4,109,6,110,7,112,2,115,3,114,1)=lagregat or nvl(lagregat,0)=0)
           ;
      end if; 
      
         
    ------------------------------------------------------------------------------ ЛПЦ-3000 -------------------------------------------------------  
     
     -- Перемещение слябов из ЛПЦ ст.1700 и КЦ       ZPP3000_K11_ POST
     if lid_interface=29  then 
         OPEN saprec FOR
         select  
         null id,trunc(data_vzves,'dd') date_of_posting,last_minute_of_smena(data_vzves,smena_vzves) date_with_time,smena_vzves smena,brigada_vzves brigada,
                                cex_integro_info (61300,200,0,0,slyab_id,0,0,0,1) subject_id,
                                null subject_id_add, 
                                cex_integro_info (61300,200,0,0,slyab_id,0,0,0,2) subject_idr,
                                null subject_id_addr,
                                (select object_id from sap_sklad_lpc where r3_number=case when n.cex_nazn = 61301 then '0702'  else '0701' end) object_id,
                                (select object_id from sap_sklad_lpc where r3_number=case when n.cex_id = 60500 then '0314'  else '0618' end) object_id_add,
                                case when n.cex_nazn = 61301 then '0702'  else '0701' end  object_idr,
                                case when n.cex_id = 60500 then '0314'  else '0618' end object_id_addr,
                                4 process_id,937 system_id,  1002  measure_unit_id, null account_id,null sd_ord,null sd_pos,
                                cex_integro_info (61300,200,0,0,slyab_id,0,0,0,3)  descr_ozm,
                                r.dlina,p.shirina,p.tolshina,round(ves_rul/1000,3)  quantity,p.num_plavki n_plavki,pl.mnlz n_mnlz,null n_partii,null nom_oper,null n_slitka,nvl(sl.num_slyaba,r.npp_num_rul) n_slyaba,null n_krata,null n_kolodca,null tip_izlognic,null id_slitka,slyab_id id_slyaba,null id_rulpf,null n_rulona,null n_pachki,null n_lista,null n_rulpf,
                                vagon_no n_avto,null id_krata,null id_rulpach,null erp_doc,null erp_pos,29 id_interface,null stat_date,null stat_userid,null n_motalki,null n_pechi,613 stan,4900 werks,'4900_07' cex,'ПФ' vid_oz,'3000' n_cex ,89200 kdpr,null kromka,null  travl,p.kod_marki id_marki,
                                nvl(pl.id_ntd,pl.id_gost) id_gostm,null id_gostt,null id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec ,null date_of_postingr,r.id klus_id,null object_type_id,null object_type_r,null marka,pl.plavka_id,0 status,null brigada_v,null brigada_r,null n_line,null subject_id_pzr,null subject_id_pzd,null m_sklad,case when n.cex_nazn = 61301 then 0 else 1 end  prizn,null kds,2 zagot,0 vidslyab,null obrab,
                                null n_korob,ras_nplv(p.num_plavki,4) god_plavki,null id_krat_lista,null n_krat_lista,null mesto_hranen_1,null mesto_hranen_2,null n_nakl,null id_svar_ru,null shifr_reglam,null vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr  
          from chp_postup p 
          JOIN chp_rul r ON p.id=r.fk_id_postup
          left join plavka pl on pl.plavka_id=p.plavka_id
          left join slyab sl using(slyab_id)
          left join sl_nakl n on n.nakl_id=sl.nakl_id
          WHERE r.data_vzves=ldate AND r.smena_vzves=nvl(lsmena,r.smena_vzves) and p.cex_id=61300 and nvl(r.priznak_rasxoda,0)<2 ;
     end if;    
     
     --Отпуск слябов на порезку для стана 3000       ZPP3000_261_POR
      if lid_interface=30 then 
         OPEN saprec FOR
         select 
                  null id,trunc(cdr.data_porezki_sl,'dd') date_of_posting,last_minute_of_smena(cdr.data_porezki_sl,cdr.smena_porezki_sl) date_with_time,cdr.smena_porezki_sl smena,cdr.brigada_porezki_sl brigada,
                                cex_integro_info(61300,200,r.id,0,0,0,0,0,7) subject_id,
                                null subject_id_add, 
                                cex_integro_info(61300,200,r.id,0,0,0,0,0,8) subject_idr,
                                null subject_id_addr,
                                to_number(cex_integro_info(61300,200,r.id,0,0,0,0,0,4)) object_id,
                                (select object_id from sap_sklad_lpc where r3_number= '0701') object_id_add,
                                cex_integro_info(61300,200,r.id,0,0,0,0,0,5)  object_idr,
                                '0701' object_id_addr,
                                2 process_id,938 system_id,  1002  measure_unit_id, null account_id,null sd_ord,null sd_pos,
                                cex_integro_info(61300,200,r.id,0,0,0,0,0,9) descr_ozm,
                                r.dlina,p.shirina,p.tolshina,round(ves_rul/1000,3)  quantity,p.num_plavki n_plavki,pl.mnlz n_mnlz,null n_partii,null nom_oper,null n_slitka,nvl(sl.num_slyaba,r.npp_num_rul) n_slyaba,null n_krata,null n_kolodca,null tip_izlognic,null id_slitka,slyab_id id_slyaba,null id_rulpf,null n_rulona,null n_pachki,null n_lista,null n_rulpf,
                                null n_avto,null id_krata,null id_rulpach,null erp_doc,null erp_pos,30 id_interface,null stat_date,null stat_userid,null n_motalki,null n_pechi,613 stan,4900 werks,'4900_07' cex,'ПФ' vid_oz,'3000' n_cex ,89200 kdpr,null kromka,null  travl,p.kod_marki id_marki,
                                nvl(pl.id_ntd,pl.id_gost) id_gostm,null id_gostt,null id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec ,null date_of_postingr,r.id klus_id,null object_type_id,null object_type_r,null marka,pl.plavka_id,0 status,null brigada_v,null brigada_r,null n_line,null subject_id_pzr,null subject_id_pzd,null m_sklad,1 prizn,null kds,2 zagot,0 vidslyab,null obrab,
                                null n_korob,ras_nplv(p.num_plavki,4) god_plavki,null id_krat_lista,null n_krat_lista,null mesto_hranen_1,null mesto_hranen_2,null n_nakl,null id_svar_ru,p.shifr_reglamenta shifr_reglam,null vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr  
           from  (select  min(data_porezki_sl) data_porezki_sl,min(smena_porezki_sl) smena_porezki_sl,min(brigada_porezki_sl) brigada_porezki_sl,fk_id_rul from chp_dvig_rul where data_porezki_sl=ldate and smena_porezki_sl=nvl(lsmena,smena_porezki_sl) and nvl(pr_op,0)=0 and num_rul is not null     group by fk_id_rul) cdr 
           JOIN chp_rul r on (r.id=cdr.fk_id_rul ) 
           join chp_postup p on p.id=r.fk_id_postup
           left join plavka pl on pl.plavka_id=p.plavka_id
         left join slyab sl using(slyab_id)
         left join sl_nakl n on n.nakl_id=sl.nakl_id
         WHERE  p.cex_id=61300 ; 
     end if;   
     
      --Поступление кратных слябов после порезки  ZPP3000_101_ POR 
      if lid_interface=31 then 
         OPEN saprec FOR
         select 
         null id,trunc(cdr.data_porezki_sl,'dd') date_of_posting,last_minute_of_smena(cdr.data_porezki_sl,cdr.smena_porezki_sl) date_with_time,cdr.smena_porezki_sl smena,cdr.brigada_porezki_sl brigada,
                               cex_integro_info(61300,200,0,cdr.id,0,0,0,0,1) subject_id,
                          null subject_id_add,cex_integro_info(61300,200,0,cdr.id,0,0,0,0,2) subject_idr,
                                null subject_id_addr,
                                (select object_id from sap_sklad_lpc where r3_number=  '0718') object_id,
                                to_number(cex_integro_info(61300,200,0,cdr.id,0,0,0,0,4))  object_id_add,
                                '0718'  object_idr,
                               cex_integro_info(61300,200,0,cdr.id,0,0,0,0,5) object_id_addr,
                                8 process_id,938 system_id,1002  measure_unit_id, null account_id,null sd_ord,null sd_pos,
                               cex_integro_info(61300,200,0,cdr.id,0,0,0,0,3) descr_ozm,
                                cdr.dlina,cdr.shirina,cdr.tolshina,cdr.ves  quantity,p.num_plavki n_plavki,pl.mnlz  n_mnlz,null n_partii,null nom_oper,null n_slitka,nvl(sl.num_slyaba,cr.npp_num_rul) n_slyaba, (case when  cdr.stan_num_rul_a is null then to_char(cdr.num_rul)  else cdr.num_rul||'-'||cdr.stan_num_rul_a end)  n_krata,null n_kolodca,null tip_izlognic,null id_slitka,slyab_id id_slyaba,null id_rulpf,null n_rulona,null n_pachki,null n_lista,null n_rulpf,
                                null n_avto,cdr.id id_krata,null id_rulpach,null erp_doc,null erp_pos,31 id_interface,null stat_date,null stat_userid,null n_motalki,null n_pechi,613 stan,4900 werks,'4900_07' cex,'ПФ' vid_oz,'3000' n_cex ,89200 kdpr,null kromka,null  travl,cdr.id_marki id_marki,
                                 nvl(pl.id_ntd,pl.id_gost) id_gostm,null id_gostt,null id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec ,null date_of_postingr,cdr.id klus_id,null object_type_id,null object_type_r,null marka,pl.plavka_id,0 status,null brigada_v,null brigada_r,null n_line,null subject_id_pzr,null subject_id_pzd,null m_sklad,1 prizn,null kds,2 zagot,1 vidslyab,null obrab,
                                null n_korob,ras_nplv(p.num_plavki,4) god_plavki,null id_krat_lista,null n_krat_lista,null mesto_hranen_1,null mesto_hranen_2,null n_nakl,null id_svar_ru,p.shifr_reglamenta shifr_reglam,null vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr  
         from chp_dvig_rul cdr 
         left join chp_rul cr on  (cr.id=cdr.fk_id_rul )
         left join chp_postup p  on (p.id=cr.fk_id_postup )
         left join plavka pl on pl.plavka_id=p.plavka_id
         left join slyab sl using(slyab_id)
         left join sl_nakl n on n.nakl_id=sl.nakl_id
         where cdr.data_porezki_sl=ldate and cdr.smena_porezki_sl=nvl(lsmena,cdr.smena_porezki_sl) and nvl(cdr.pr_op,0)=0 and cdr.num_rul is not null and  p.cex_id=61300 ;
     end if;  
     
      --Перемещение кратных слябов на нагрев  ZPP3000_311_ NAGR
        if lid_interface=32 then 
         OPEN saprec FOR
         select 
         null id,trunc(cdr.data_posada,'dd') date_of_posting,last_minute_of_smena(cdr.data_posada,cdr.smena_posada) date_with_time,cdr.smena_posada smena,cdr.brigada_posada brigada,
                                cex_integro_info(61300,200,0,cdr.id,0,0,0,0,1) subject_id,
                                null subject_id_add,  cex_integro_info(61300,200,0,cdr.id,0,0,0,0,2) subject_idr,
                                null subject_id_addr,
                                (select object_id from sap_sklad_lpc where r3_number=  '0704') object_id,
                                (select object_id from sap_sklad_lpc where r3_number=  '0718')  object_id_add,
                               '0704'  object_idr,
                               '0718'  object_id_addr,
                                3 process_id,939 system_id,1002  measure_unit_id, null account_id,null sd_ord,null sd_pos,
                                 cex_integro_info(61300,200,0,cdr.id,0,0,0,0,3) descr_ozm,
                                cdr.dlina,cdr.shirina,cdr.tolshina,cdr.ves  quantity,p.num_plavki n_plavki,pl.mnlz  n_mnlz,null n_partii,null nom_oper,null n_slitka,nvl(sl.num_slyaba,cr.npp_num_rul) n_slyaba, (case when  cdr.stan_num_rul_a is null then to_char(cdr.num_rul)  else cdr.num_rul||'-'||cdr.stan_num_rul_a end)  n_krata,null n_kolodca,null tip_izlognic,null id_slitka,slyab_id id_slyaba,null id_rulpf,null n_rulona,null n_pachki,null n_lista,null n_rulpf,
                                null n_avto,cdr.id id_krata,null id_rulpach,null erp_doc,null erp_pos,32 id_interface,null stat_date,null stat_userid,null n_motalki,null n_pechi,613 stan,4900 werks,'4900_07' cex,'ПФ' vid_oz,'3000' n_cex ,89200 kdpr,null kromka,null  travl,cdr.id_marki id_marki,
                                 nvl(pl.id_ntd,pl.id_gost) id_gostm,null id_gostt,null id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec ,null date_of_postingr,cdr.id klus_id,null object_type_id,null object_type_r,null marka,pl.plavka_id,0 status,null brigada_v,null brigada_r,null n_line,null subject_id_pzr,null subject_id_pzd,null m_sklad,1 prizn,null kds,2 zagot,1 vidslyab,null obrab,
                                null n_korob,ras_nplv(p.num_plavki,4) god_plavki,null id_krat_lista,null n_krat_lista,null mesto_hranen_1,null mesto_hranen_2,null n_nakl,null id_svar_ru,p.shifr_reglamenta shifr_reglam,null vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr  
              from chp_postup p
              left join chp_rul cr on (p.id=cr.fk_id_postup )
              left join chp_dvig_rul cdr on (cr.id=cdr.fk_id_rul )
          --    left join chp_hist_per_rul ch on (cdr.id=ch.id_rul)
              left join plavka pl on pl.plavka_id=p.plavka_id
              left join slyab sl using(slyab_id)
              where  p.cex_id=61300 and cdr.num_rul is not null and nvl(cdr.pr_op,0)=0 and trunc(cdr.data_posada)=ldate and cdr.smena_posada=nvl(lsmena,cdr.smena_posada) ;
     end if;    
     
     -- Возврат кратных слябов  ZPP3000_311_ VOZV
      if lid_interface=33 then 
         OPEN saprec FOR
         select 
         null id,trunc(ch.data_izm,'dd') date_of_posting,last_minute_of_smena(ch.data_izm,ch.smena_izm) date_with_time,ch.smena_izm smena,ch.brigada_izm brigada,
                               cex_integro_info(61300,200,0,cdr.id,0,0,0,0,1) subject_id,
                                null subject_id_add, cex_integro_info(61300,200,0,cdr.id,0,0,0,0,2) subject_idr,
                                null subject_id_addr,
                                (select object_id from sap_sklad_lpc where r3_number=  '0718') object_id,
                                (select object_id from sap_sklad_lpc where r3_number=  '0704')  object_id_add,
                               '0718' object_idr,
                                '0704' object_id_addr,
                                3 process_id,940 system_id,1002  measure_unit_id, null account_id,null sd_ord,null sd_pos,
                               cex_integro_info(61300,200,0,cdr.id,0,0,0,0,3) descr_ozm,
                                cdr.dlina,cdr.shirina,cdr.tolshina,cdr.ves  quantity,p.num_plavki n_plavki,pl.mnlz n_mnlz,null n_partii,null nom_oper,null n_slitka,nvl(sl.num_slyaba,cr.npp_num_rul) n_slyaba, (case when  cdr.stan_num_rul_a is null then to_char(cdr.num_rul)  else cdr.num_rul||'-'||cdr.stan_num_rul_a end)  n_krata,null n_kolodca,null tip_izlognic,null id_slitka,slyab_id id_slyaba,null id_rulpf,null n_rulona,null n_pachki,null n_lista,null n_rulpf,
                                null n_avto,cdr.id id_krata,null id_rulpach,null erp_doc,null erp_pos,33 id_interface,null stat_date,null stat_userid,null n_motalki,null n_pechi,613 stan,4900 werks,'4900_07' cex,'ПФ' vid_oz,'3000' n_cex ,89200 kdpr,null kromka,null  travl,cdr.id_marki id_marki,
                               nvl(pl.id_ntd,pl.id_gost) id_gostm,null id_gostt,null id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec,null date_of_postingr,cdr.id klus_id ,null object_type_id,null object_type_r,null marka,pl.plavka_id,0 status,null brigada_v,null brigada_r,null n_line,null subject_id_pzr,null subject_id_pzd,null m_sklad,1 prizn,null kds,2 zagot,1 vidslyab,null obrab,
                                null n_korob,ras_nplv(p.num_plavki,4) god_plavki,null id_krat_lista,null n_krat_lista,null mesto_hranen_1,null mesto_hranen_2,null n_nakl,null id_svar_ru,p.shifr_reglamenta shifr_reglam,null vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr  
             from chp_postup p
             left join chp_rul cr on (p.id=cr.fk_id_postup )
             left join chp_dvig_rul cdr on (cr.id=cdr.fk_id_rul )
             left join chp_hist_per_rul ch on (cdr.id=ch.id_rul)
             left join plavka pl on pl.plavka_id=p.plavka_id
             left join slyab sl using(slyab_id)
             where  p.cex_id=61300 and cdr.num_rul is not null and nvl(cdr.pr_op,0)=0 and trunc(ch.data_izm)=ldate and ch.smena_izm=nvl(lsmena,ch.smena_izm)  and ch.id_naznach_old in (202,203,204) and ch.id_naznach =200 ;
     end if;    
     
     --  Отпуск кратных слябов на прокат  ZPP3000_261_ PROK
      if lid_interface=34 then 
         OPEN saprec FOR
        select
          null id,trunc(kl.date_zap,'dd') date_of_posting,last_minute_of_smena(kl.date_zap,kl.smena_zap) date_with_time,kl.smena_zap smena,brig(datewithtime(kl.date_zap,decode(kl.smena_zap,1,'02.00',2,'10.00','18.00'))) brigada,
                                cex_integro_info(61300,204,0,cdr.id,0,0,0,0,7) subject_id,
                                null subject_id_add,cex_integro_info(61300,204,0,cdr.id,0,0,0,0,8) subject_idr,
                                null subject_id_addr,
                                to_number(cex_integro_info(61300,204,0,cdr.id,0,0,0,0,4)) object_id,
                                (select object_id from sap_sklad_lpc where r3_number=  '0704')  object_id_add,
                                cex_integro_info(61300,204,0,cdr.id,0,0,0,0,5) object_idr,
                                '0704' object_id_addr,
                                2 process_id,941 system_id,1002  measure_unit_id, null account_id,null sd_ord,null sd_pos,
                               cex_integro_info(61300,204,0,cdr.id,0,0,0,0,9)  descr_ozm,
                                cdr.dlina,cdr.shirina,cdr.tolshina,cdr.ves  quantity,p.num_plavki n_plavki,pl.mnlz n_mnlz,null n_partii,null nom_oper,null n_slitka,nvl(sl.num_slyaba,cr.npp_num_rul) n_slyaba, (case when  cdr.stan_num_rul_a is null then to_char(cdr.num_rul)  else cdr.num_rul||'-'||cdr.stan_num_rul_a end)  n_krata,null n_kolodca,null tip_izlognic,null id_slitka,slyab_id id_slyaba,null id_rulpf,null n_rulona,null n_pachki,null n_lista,null n_rulpf,
                                null n_avto,cdr.id id_krata,null id_rulpach,null erp_doc,null erp_pos,34 id_interface,null stat_date,null stat_userid,null n_motalki,null n_pechi,613 stan,4900 werks,'4900_07' cex,'ПФ' vid_oz,'3000' n_cex ,89200 kdpr,null kromka,null  travl,cdr.id_marki id_marki,
                               nvl(pl.id_ntd,pl.id_gost) id_gostm,null id_gostt,null id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec,null date_of_postingr,cdr.id klus_id ,null object_type_id,null object_type_r,null marka,pl.plavka_id,0 status,null brigada_v,null brigada_r,null n_line,null subject_id_pzr,null subject_id_pzd,null m_sklad,1 prizn,null kds,2 zagot,1 vidslyab,null obrab,
                                null n_korob,ras_nplv(p.num_plavki,4) god_plavki,null id_krat_lista,null n_krat_lista,null mesto_hranen_1,null mesto_hranen_2,null n_nakl,null id_svar_ru,p.shifr_reglamenta shifr_reglam,null vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr  
         from (select min(date_zap) date_zap,min(smena_zap) smena_zap,fk_id_dvig_rul  from krat_list where  date_zap=ldate and  smena_zap=nvl(lsmena, smena_zap) and  nvl(pr_nal,0)=0 and  dlina is not null group by fk_id_dvig_rul) kl 
         left join chp_dvig_rul cdr on (cdr.id=kl.fk_id_dvig_rul )
         left join chp_rul cr on (cr.id=cdr.fk_id_rul ) 
         left join chp_postup p on p.id=cr.fk_id_postup
          left join plavka pl on pl.plavka_id=p.plavka_id
          left join slyab sl using(slyab_id)
         ;
     end if;  
      
     --Поступление горячего проката листов/плит (НЗП)   ZPP3000_101_ NZP
      
   
        if lid_interface=35  then 
         OPEN saprec FOR
         select 
          null id,trunc(kl.date_zap,'dd') date_of_posting,last_minute_of_smena(kl.date_zap,kl.smena_zap) date_with_time,kl.smena_zap smena,brig(datewithtime(kl.date_zap,decode(kl.smena_zap,1,'02.00',2,'10.00','18.00'))) brigada,
                                cex_integro_info(61300,204,0,cdr.id,0,0,0,0,1) subject_id,
                                null subject_id_add, 
                                cex_integro_info(61300,204,0,cdr.id,0,0,0,0,2) subject_idr,
                                null subject_id_addr,
                                (select object_id from sap_sklad_lpc where r3_number=  case when prbs.tolshina>33 then '0709' else '0706'  end)  object_id,
                                to_number(cex_integro_info(61300,204,0,cdr.id,0,0,0,0,4)) object_id_add,
                                case when prbs.tolshina>33 then '0709' else '0706'  end object_idr,
                                cex_integro_info(61300,204,0,cdr.id,0,0,0,0,5) object_id_addr,
                                8 process_id,942 system_id,1002  measure_unit_id, null account_id,null sd_ord,null sd_pos,
                               cex_integro_info(61300,204,0,cdr.id,0,0,0,0,3) descr_ozm,
                                kl.dlina,kl.shirina_kr_lista shirina,prbs.tolshina,round(kl.ves_krat_list/1000,3) quantity,p.num_plavki n_plavki,pl.mnlz n_mnlz,cdr.num_partii n_partii,null nom_oper,null n_slitka,nvl(sl.num_slyaba,cr.npp_num_rul) n_slyaba, (case when  cdr.stan_num_rul_a is null then to_char(cdr.num_rul)  else cdr.num_rul||'-'||cdr.stan_num_rul_a end)  n_krata,null n_kolodca,null tip_izlognic,null id_slitka,slyab_id id_slyaba,null id_rulpf,null n_rulona,null n_pachki,null n_lista,null n_rulpf,
                                null n_avto,cdr.id id_krata,kl.id  id_rulpach,null erp_doc,null erp_pos,35 id_interface,null stat_date,null stat_userid,null n_motalki,null n_pechi,613 stan,4900 werks,'4900_07' cex,'ПФ' vid_oz,'3000' n_cex ,97000 kdpr,0  kromka,0  travl, prbs.marka_id id_marki,
                                prbs.gost_id  id_gostm,prbs.gost3_id  id_gostt,prbs.gost2_id  id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec,null date_of_postingr,kl.id  klus_id ,null object_type_id,null object_type_r,null marka,pl.plavka_id,0 status,null brigada_v,null brigada_r,null n_line,null subject_id_pzr,null subject_id_pzd,null m_sklad,1 prizn,null kds,2 zagot,null vidslyab,null obrab,
                                null n_korob,ras_nplv(p.num_plavki,4) god_plavki,kl.num_krat_list n_krat_lista,kl.id id_krat_lista,kl.mesto_pfo mesto_hranen_1,kl.mesto_24A mesto_hranen_2,null n_nakl,null id_svar_ru,null shifr_reglam,null vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr  
             from krat_list kl
             left join prb_task_st prbs on (prbs.prb_task_st_id=kl.prb_task_st_id)
             left join chp_dvig_rul cdr on (cdr.id=kl.fk_id_dvig_rul )
             left join chp_rul cr on  cr.id=cdr.fk_id_rul 
             left join chp_postup p on (p.id=cr.fk_id_postup) 
             left join plavka pl on pl.plavka_id=p.plavka_id
             left join slyab sl using(slyab_id)
             where  p.cex_id=61300 and  kl.date_zap=ldate and kl.smena_zap=nvl(lsmena,kl.smena_zap) and  nvl(kl.pr_nal,0)=0 and kl.dlina is not null ; 
     end if;  
     
     --Перемещение горячего проката листов/плит (НЗП)   ZPP3000_311_ NZP на отделку
        if lid_interface=36 then 
         OPEN saprec FOR
         select 
          null id,
         case  when  kl.date_time_pfo_sbros is not null and trunc(kl.date_time_pfo_sbros,'dd')=ldate   then trunc(kl.date_time_pfo_sbros,'dd') 
         when kl.date_time_24A_sbros is not null and trunc(kl.date_time_24A_sbros,'dd')=ldate  then trunc(kl.date_time_24A_sbros)  end date_of_posting,
          case  when  kl.date_time_pfo_sbros is not null and trunc(kl.date_time_pfo_sbros,'dd')=ldate   then last_minute_of_smena(kl.date_time_pfo_sbros,smena_pfo_sbros)  
         when kl.date_time_24A_sbros is not null and trunc(kl.date_time_24A_sbros,'dd')=ldate   then last_minute_of_smena(kl.date_time_24A_sbros,kl.smena_24A_sbros)  end  date_with_time,
         case  when  kl.date_time_pfo_sbros is not null and trunc(kl.date_time_pfo_sbros,'dd')=ldate then  kl.smena_pfo_sbros
         when kl.date_time_24A_sbros is not null and trunc(kl.date_time_24A_sbros,'dd')=ldate  then kl.smena_24A_sbros  end   smena,
        case  when  kl.date_time_pfo_sbros is not null and trunc(kl.date_time_pfo_sbros,'dd')=ldate   then   brig_po_smene(kl.date_time_pfo_sbros,kl.smena_pfo_sbros)
         when kl.date_time_24A_sbros is not null and trunc(kl.date_time_24A_sbros,'dd')=ldate   then brig_po_smene( kl.date_time_24A_sbros,kl.smena_24A_sbros)  end   brigada,
                               cex_integro_info(61300,204,0,cdr.id,0,0,0,0,1)  subject_id,
                                null subject_id_add, 
                               cex_integro_info(61300,204,0,cdr.id,0,0,0,0,2) subject_idr,
                               null subject_id_addr,
                                (select object_id from sap_sklad_lpc where r3_number=
                                 case 
                                when  kl.date_time_pfo_sbros is not null and trunc(kl.date_time_pfo_sbros,'dd')=ldate   then '0707'                                
                                when  kl.date_time_24A_sbros is not null and trunc(kl.date_time_24A_sbros,'dd')=ldate   then '0708'  end )  object_id,
                                (select object_id from sap_sklad_lpc where r3_number=  case when prbs.tolshina>33 then '0709' else '0706'  end) object_id_add,
                                 case 
                                when  kl.date_time_pfo_sbros is not null and trunc(kl.date_time_pfo_sbros,'dd')=ldate  then '0707'                                
                                when  kl.date_time_24A_sbros is not null and trunc(kl.date_time_24A_sbros,'dd')=ldate   then '0708'  end  object_idr,
                                case when prbs.tolshina>33 then '0709' else '0706'  end object_id_addr,
                                3 process_id,946 system_id,1002  measure_unit_id, null account_id,null sd_ord,null sd_pos,
                                 cex_integro_info(61300,204,0,cdr.id,0,0,0,0,3)  descr_ozm,
                                 kl.dlina,kl.shirina_kr_lista shirina,prbs.tolshina,round(kl.ves_krat_list/1000,3) quantity,p.num_plavki n_plavki,pl.mnlz  n_mnlz,cdr.num_partii n_partii,null nom_oper,null n_slitka,nvl(sl.num_slyaba,cr.npp_num_rul) n_slyaba, (case when  cdr.stan_num_rul_a is null then to_char(cdr.num_rul)  else cdr.num_rul||'-'||cdr.stan_num_rul_a end)  n_krata,null n_kolodca,null tip_izlognic,null id_slitka,slyab_id id_slyaba,null id_rulpf,null n_rulona,null n_pachki,null n_lista,null n_rulpf,
                                null n_avto,cdr.id id_krata,null  id_rulpach,null erp_doc,null erp_pos,36 id_interface,null stat_date,null stat_userid,null n_motalki,null n_pechi,613 stan,4900 werks,'4900_07' cex,'ПФ' vid_oz,'3000' n_cex ,97000 kdpr,0  kromka,0  travl,prbs.marka_id id_marki,
                               prbs.gost_id  id_gostm,prbs.gost3_id  id_gostt,prbs.gost2_id  id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec ,null date_of_postingr,kl.id  klus_id,null object_type_id,null object_type_r,null marka,pl.plavka_id,0 status,null brigada_v,null brigada_r,null n_line,null subject_id_pzr,null subject_id_pzd,null m_sklad,1 prizn,null kds,2 zagot,null vidslyab,null obrab,
                                null n_korob,ras_nplv(p.num_plavki,4) god_plavki,kl.num_krat_list n_krat_lista,kl.id id_krat_lista,kl.mesto_pfo mesto_hranen_1,kl.mesto_24A mesto_hranen_2,null n_nakl,null id_svar_ru,null shifr_reglam,null vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr  
                 
          from krat_list kl
              left join prb_task_st prbs on (prbs.prb_task_st_id=kl.prb_task_st_id)
              left join chp_dvig_rul cdr on (cdr.id=kl.fk_id_dvig_rul )
              left join chp_rul cr on  cr.id=cdr.fk_id_rul 
              left join chp_postup p on (p.id=cr.fk_id_postup) 
              left join plavka pl on pl.plavka_id=p.plavka_id
              left join slyab sl using(slyab_id)
              where  p.cex_id=61300 and   nvl(kl.pr_nal,0)=0 and
              (( kl.date_time_pfo_sbros is not null and trunc(kl.date_time_pfo_sbros,'dd')=ldate  and kl.smena_pfo_sbros=nvl(lsmena,kl.smena_pfo_sbros) or   (kl.date_time_24A_sbros is not null and trunc(kl.date_time_24A_sbros,'dd')=ldate  and kl.smena_24A_sbros=nvl(lsmena,kl.smena_24A_sbros)) ) )    ;                  
           end if;   
     
      --Перемещение горячего проката листов/плит (НЗП)   ZPP3000_311_VOZV_NZP с отделки
        if lid_interface=101 then 
         OPEN saprec FOR
         select 
         null id,
         case  when  kl.date_time_pfo_podyom is not null and trunc(kl.date_time_pfo_podyom,'dd')=ldate  then trunc(kl.date_time_pfo_podyom,'dd') 
         when kl.date_time_24A_podyom is not null and trunc(kl.date_time_24A_podyom,'dd')=ldate   then trunc(kl.date_time_24A_podyom)  end date_of_posting,
          case  when  kl.date_time_pfo_podyom is not null and trunc(kl.date_time_pfo_podyom,'dd')=ldate   then last_minute_of_smena(kl.date_time_pfo_podyom,smena_pfo_podyom)  
         when kl.date_time_24A_podyom is not null and trunc(kl.date_time_24A_podyom,'dd')=ldate   then last_minute_of_smena(kl.date_time_24A_podyom,kl.smena_24A_podyom)  end  date_with_time,
         case  when  kl.date_time_pfo_podyom is not null and trunc(kl.date_time_pfo_podyom,'dd')=ldate   then  kl.smena_pfo_podyom
         when kl.date_time_24A_podyom is not null and trunc(kl.date_time_24A_podyom,'dd')=ldate   then kl.smena_24A_podyom end   smena,
         case  when  kl.date_time_pfo_podyom is not null and trunc(kl.date_time_pfo_podyom,'dd')=ldate   then   brig_po_smene(kl.date_time_pfo_podyom,kl.smena_pfo_podyom)
         when kl.date_time_24A_podyom is not null and trunc(kl.date_time_24A_podyom,'dd')=ldate   then brig_po_smene( kl.date_time_24A_podyom,kl.smena_24A_podyom)  end   brigada,
                               cex_integro_info(61300,204,0,cdr.id,0,0,0,0,1) subject_id,
                                null subject_id_add, 
                              cex_integro_info(61300,204,0,cdr.id,0,0,0,0,2) subject_idr,
                               null subject_id_addr, 
                                 (select object_id from sap_sklad_lpc where r3_number=  case when prbs.tolshina>33 then '0709' else '0706'  end) object_id,
                                (select object_id from sap_sklad_lpc where r3_number=      case 
                                when     kl.date_time_pfo_podyom is not null and trunc(kl.date_time_pfo_podyom,'dd')=ldate  then '0707'                                
                                when  kl.date_time_24A_podyom is not null and trunc(kl.date_time_24A_podyom,'dd')=ldate   then '0708'
                                                               
                                   end )  object_id_add,
                                case when prbs.tolshina>33 then '0709' else '0706'  end  object_idr,
                                 case 
                                when      kl.date_time_pfo_podyom is not null and trunc(kl.date_time_pfo_podyom,'dd')=ldate  then '0707'                                
                                when  kl.date_time_24A_podyom is not null and trunc(kl.date_time_24A_podyom,'dd')=ldate   then '0708' 
                                      end  object_id_addr,
                          
                                3 process_id,947 system_id,1002  measure_unit_id, null account_id,null sd_ord,null sd_pos,
                              cex_integro_info(61300,204,0,cdr.id,0,0,0,0,3) descr_ozm,
                               kl.dlina,kl.shirina_kr_lista shirina,prbs.tolshina,round(kl.ves_krat_list/1000,3) quantity,p.num_plavki n_plavki,pl.mnlz n_mnlz,cdr.num_partii n_partii,null nom_oper,null n_slitka,nvl(sl.num_slyaba,cr.npp_num_rul) n_slyaba, (case when  cdr.stan_num_rul_a is null then to_char(cdr.num_rul)  else cdr.num_rul||'-'||cdr.stan_num_rul_a end)  n_krata,null n_kolodca,null tip_izlognic,null id_slitka,slyab_id id_slyaba,null id_rulpf,null n_rulona,null n_pachki,null n_lista,null n_rulpf,
                                null n_avto,cdr.id id_krata,null  id_rulpach,null erp_doc,null erp_pos,101 id_interface,null stat_date,null stat_userid,null n_motalki,null n_pechi,613 stan,4900 werks,'4900_07' cex,'ПФ' vid_oz,'3000' n_cex ,97000 kdpr,0  kromka,0  travl,prbs.marka_id  id_marki,
                                prbs.gost_id  id_gostm,prbs.gost3_id  id_gostt,prbs.gost2_id  id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec ,null date_of_postingr,kl.id  klus_id,null object_type_id,null object_type_r,null marka,pl.plavka_id,0 status,null brigada_v,null brigada_r,null n_line,null subject_id_pzr,null subject_id_pzd,null m_sklad,1 prizn,null kds,2 zagot,null vidslyab,null obrab,
                                null n_korob,ras_nplv(p.num_plavki,4) god_plavki,kl.num_krat_list n_krat_lista,kl.id id_krat_lista,kl.mesto_pfo mesto_hranen_1,kl.mesto_24A mesto_hranen_2,null n_nakl,null id_svar_ru,null shifr_reglam,null vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr  
              from krat_list kl
              left join prb_task_st prbs on (prbs.prb_task_st_id=kl.prb_task_st_id)
              left join chp_dvig_rul cdr on (cdr.id=kl.fk_id_dvig_rul )
              left join chp_rul cr on  cr.id=cdr.fk_id_rul 
              left join chp_postup p on (p.id=cr.fk_id_postup) 
              left join plavka pl on pl.plavka_id=p.plavka_id
              left join slyab sl using(slyab_id)
              where  p.cex_id=61300  and  nvl(kl.pr_nal,0)=0 and  (((kl.date_time_pfo_podyom is not null and trunc(kl.date_time_pfo_podyom,'dd')=ldate  
                                and smena_pfo_podyom=nvl(lsmena,smena_pfo_podyom)) or  (kl.date_time_24A_podyom is not null and trunc(kl.date_time_24A_podyom,'dd')=ldate  and kl.smena_24A_podyom=nvl(lsmena,kl.smena_24A_podyom)
                               )) );
     end if;   
     
     --Поступление готового проката листов/плит    ZPP3000_101_ PROK
       if lid_interface=37 then 
         OPEN saprec FOR
          select
          null id,trunc(cp.data_porezki,'dd') date_of_posting,last_minute_of_smena(cp.data_porezki,cp.smena_porezki) date_with_time,cp.smena_porezki smena,cp.brigada_porezki brigada,
                                cex_integro_info(61300,192,0,0,0,cp.id,0,0,1) subject_id,
                                null subject_id_add, 
                                cex_integro_info(61300,192,0,0,0,cp.id,0,0,2) subject_idr,
                               null subject_id_addr,
                                (select object_id from sap_sklad_lpc where r3_number= '0712' )  object_id,
                                 to_number(cex_integro_info(61300,192,0,0,0,cp.id,0,0,4)) object_id_add,
                                '0712'   object_idr,
                                cex_integro_info(61300,192,0,0,0,cp.id,0,0,5)  object_id_addr,
                                8 process_id,944 system_id,1002  measure_unit_id, null account_id,null sd_ord,null sd_pos,
                                cex_integro_info(61300,192,0,0,0,cp.id,0,0,3)  descr_ozm,
                                cp.dlina,cp.shirina,cp.tolshina,round(nvl(cp.ves_ne_att,cp.ves)/1000,3)  quantity,cp.num_plavki n_plavki,pl.mnlz  n_mnlz,cp.num_partii n_partii,null nom_oper,null n_slitka,nvl(sl.num_slyaba,cr.npp_num_rul) n_slyaba, (case when  cdr.stan_num_rul_a is null then to_char(cdr.num_rul)  else cdr.num_rul||'-'||cdr.stan_num_rul_a end)  n_krata,null n_kolodca,null tip_izlognic,null id_slitka,slyab_id id_slyaba,null id_rulpf,null n_rulona,null n_pachki,
                                case when cp.line_no2 is not null and cp.line_no is not null then cp.line_no||'-'|| cp.line_no2||'-'|| cp.num_rul_pach
                                when cp.line_no2 is null and cp.line_no is not null then cp.line_no||'-'||cp.num_rul_pach else to_char(cp.num_rul_pach)  end  n_lista,
                                null n_rulpf,
                                null n_avto,cdr.id id_krata,cp.id  id_rulpach,null erp_doc,null erp_pos,37 id_interface,null stat_date,null stat_userid,null n_motalki,null n_pechi,613 stan,4900 werks,'4900_07' cex,'ПФ' vid_oz,'3000' n_cex ,97000 kdpr,1 kromka,2  travl,cp.id_marki id_marki,
                               gost_id  id_gostm,gost3_id  id_gostt,gost2_id  id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec ,null date_of_postingr,cp.id  klus_id,null object_type_id,null object_type_r,null marka,pl.plavka_id,0 status,null brigada_v,null brigada_r,null n_line,null subject_id_pzr,null subject_id_pzd,null m_sklad,0 prizn,null kds,null zagot,null vidslyab,null obrab,
                                null n_korob,ras_nplv(cp.num_plavki,4) god_plavki,kl.num_krat_list n_krat_lista,kl.id id_krat_lista,to_char(kl.mesto_pfo) mesto_hranen_1,to_char(kl.mesto_24A) mesto_hranen_2,null n_nakl,null id_svar_ru,null shifr_reglam,null vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr  
          from krat_list kl
             left join chp_porezka cp on (kl.id=cp.fk_id_krat_list)
            left  join prb_task_st prbs on (prbs.prb_task_st_id=kl.prb_task_st_id)
         left join chp_dvig_rul cdr on (cdr.id=cp.fk_id_dvig_rul )
         left join chp_rul cr on  cr.id=cdr.fk_id_rul 
         left join chp_postup p on (p.id=cr.fk_id_postup) 
         left join plavka pl on pl.plavka_id=p.plavka_id
         left join slyab sl using(slyab_id)
         where      cp.data_porezki=ldate and cp.smena_porezki=nvl(lsmena,cp.smena_porezki) and nvl(cp.pr_op,0)<4 and cp.cex_id=61300 and nvl(cp.pr_nal,0)<4;
        end if;
        
          --Списание кратов листов/плит  на отделку  ZPP3000_261_NZP
        if lid_interface=141 then 
         
         OPEN saprec FOR
         select 
         null id,trunc(cp.data_porezki,'dd') date_of_posting,last_minute_of_smena(cp.data_porezki,cp.smena_porezki) date_with_time,cp.smena_porezki smena,cp.brigada_porezki brigada,
        -- null id,trunc(cp.data_porezki,'dd') date_of_posting,last_minute_of_smena(cp.data_porezki,cp.smena_porezki) date_with_time,cp.smena_porezki smena,cp.brigada_porezki brigada,
                               cex_integro_info(61300,192,0,0,0,cp.id,0,0,7) subject_id,
                                null subject_id_add, 
                                cex_integro_info(61300,192,0,0,0,cp.id,0,0,8) subject_idr,
                               null subject_id_addr,
                                to_number(cex_integro_info(61300,192,0,0,0,cp.id,0,0,4))  object_id,
                               (select object_id from sap_sklad_lpc where r3_number=   case 
                                  when  prbs.tolshina<=33  then '0706' 
                                   when   prbs.tolshina>33  then '0709' 
                                   end )  object_id_add,
                              cex_integro_info(61300,192,0,0,0,cp.id,0,0,5)  object_idr,
                                case 
                                 when  prbs.tolshina<=33  then '0706' 
                                 when  prbs.tolshina>33    then '0709' 
                                   end     object_id_addr,
                                2 process_id,943 system_id,1002  measure_unit_id, null account_id,null sd_ord,null sd_pos,
                                cex_integro_info(61300,192,0,0,0,cp.id,0,0,9)  descr_ozm,
                                kl.dlina,kl.shirina_kr_lista shirina,prbs.tolshina,round(kl.ves_krat_list/1000,3) quantity,p.num_plavki n_plavki,pl.mnlz n_mnlz,cdr.num_partii  n_partii,null nom_oper,null n_slitka,nvl(sl.num_slyaba,cr.npp_num_rul) n_slyaba, (case when  cdr.stan_num_rul_a is null then to_char(cdr.num_rul)  else cdr.num_rul||'-'||cdr.stan_num_rul_a end)  n_krata,null n_kolodca,null tip_izlognic,null id_slitka,slyab_id id_slyaba,null id_rulpf,null n_rulona,null n_pachki,null  n_lista,null n_rulpf,
                                null n_avto,cdr.id id_krata,cp.id  id_rulpach,null erp_doc,null erp_pos,141 id_interface,null stat_date,null stat_userid,null n_motalki,null n_pechi,613 stan,4900 werks,'4900_07' cex,'ПФ' vid_oz,'3000' n_cex ,97000 kdpr,0  kromka,0  travl,prbs.marka_id id_marki,
                               prbs.gost_id  id_gostm,prbs.gost3_id  id_gostt,prbs.gost2_id  id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec ,null date_of_postingr,kl.id  klus_id,null object_type_id,null object_type_r,null marka,pl.plavka_id,0 status,null brigada_v,null brigada_r,null n_line,null subject_id_pzr,null subject_id_pzd,null m_sklad,1 prizn,null kds,2 zagot,null vidslyab,null obrab,
                                null n_korob,ras_nplv(p.num_plavki,4) god_plavki,kl.num_krat_list n_krat_lista,kl.id id_krat_lista,kl.mesto_pfo mesto_hranen_1,kl.mesto_24A mesto_hranen_2,null n_nakl,null id_svar_ru,null shifr_reglam,null vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr  
           from ( select min(data_porezki) data_porezki,min(smena_porezki) smena_porezki,min(brigada_porezki) brigada_porezki,min(id) id,fk_id_krat_list  from chp_porezka where   data_porezki=ldate and smena_porezki=nvl(lsmena,smena_porezki) and nvl(pr_op,0)<4 and  cex_id=61300  and nvl(pr_nal,0)<4 and nvl(pr_s_br_rul,0)=0 group by fk_id_krat_list) cp
           left join krat_list kl on kl.id=cp.fk_id_krat_list
           left  join prb_task_st prbs on (prbs.prb_task_st_id=kl.prb_task_st_id)
           left join chp_dvig_rul cdr on (cdr.id=kl.fk_id_dvig_rul )
           left join chp_rul cr on  cr.id=cdr.fk_id_rul 
           left join chp_postup p on (p.id=cr.fk_id_postup) 
           left join plavka pl on pl.plavka_id=p.plavka_id
           left join slyab sl using(slyab_id);
         -- where   cp.data_porezki=ldate and cp.smena_porezki=nvl(lsmena,cp.smena_porezki);
     end if;    
     
           
     
                ------------------------------------------------------------------------------ ЦХП---------------------------------------------------------------
                               
                                
           --   Списание рулонов на травление ZPP_CHP_261_TRAV 
         if lid_interface=61 then 
         OPEN saprec FOR  
         SELECT null id ,
                 trunc(cr.data_rasx,'dd')   date_of_posting,
                 last_minute_of_smena(cr.data_rasx,cr.smena_rasx)  date_with_time,
                 cr.smena_rasx  smena,
                 brig_po_smene(cr.data_rasx,cr.smena_rasx)   brigada,
                 cex_integro_info(61100,cr.fk_id_naznach,cr.id,0,0,0,0,0,7)  subject_id, 
                 null subject_id_add,
                 cex_integro_info(61100,cr.fk_id_naznach,cr.id,0,0,0,0,0,8) subject_idr,
                 null subject_id_addr,
                 to_number(cex_integro_info(61100,cr.fk_id_naznach,cr.id,0,0,0,0,0,4)) object_id,
                 (select object_id from sap_sklad_lpc where r3_number='0801') object_id_add,
                 cex_integro_info(61100,cr.fk_id_naznach,cr.id,0,0,0,0,0,5) object_idr,
                 '0801' object_id_addr,
                 2 process_id,951 system_id, 1002  measure_unit_id, null account_id,null sd_ord,null sd_pos,
               cex_integro_info(61100,cr.fk_id_naznach,cr.id,0,0,0,0,0,9) descr_ozm,
                null dlina,cp.shirina,cp.tolshina,round(cr.ves_rul/1000,3)  quantity, cp.num_plavki n_plavki,ras_nplv(cp.num_plavki,2) n_mnlz,null n_partii,null nom_oper,cr.num_slitka n_slitka,
                 sl.num_slyaba n_slyaba,null n_krata,s.nkol n_kolodca,(select tip_izl from spr_izlog where id=s.izl_id)  tip_izlognic,slitok_id id_slitka,st.slyab_id id_slyaba,
                  cr.id id_rulpf,null n_rulona,null n_pachki,null n_lista,
                 case when cr.npp_num_rul <100 then cp.num_matkart*100+cr.npp_num_rul else cr.npp_num_rul end  n_rulpf,
                 null n_avto,null id_krata,null id_rulpach, null erp_doc,null erp_pos,61 id_interface,null stat_date,null stat_userid,
                  cr.num_motalki  n_motalki,sl.pechi_number n_pechi,611 stan,4900 werks,'4900_08' cex,'ПФ' vid_oz,'ЦХП' n_cex, 97010  kdpr,2 kromka,2  travl,cp.kod_marki id_marki,
                 nvl(pl.id_ntd,pl.id_gost)  id_gostm,null id_gostt,null id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec,null date_of_postingr,cr.id klus_id  ,null object_type_id,null object_type_r   ,null marka   ,pl.plavka_id,0 status,null brigada_v,null brigada_r,null n_line,null subject_id_pzr,null subject_id_pzd ,null m_sklad,1 prizn,null kds  ,case when pl.mnlz is null then 1 else 2 end   zagot,null vidslyab,null obrab,
                  null n_korob,ras_nplv(cp.num_plavki,4) god_plavki,null id_krat_lista,null n_krat_lista,null mesto_hranen_1,null mesto_hranen_2,to_char(num_matkart)  n_nakl,null id_svar_ru,null shifr_reglam,null vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr                             
                 FROM chp_postup cp 
                JOIN chp_rul cr ON cp.id=cr.fk_id_postup
                JOIN prokat_str st USING (prokat_str_id)
                left join prokat pr on pr.prokat_id=st.prokat_id
                left JOIN slyab sl on sl.slyab_id=st.slyab_id 
                left JOIN slitok s using(slitok_id)
                left join plavka pl on pl.plavka_id=s.plavka_id
               WHERE cp.cex_id=61100 and nvl(priznak_rasxoda,0)=1 and cr.data_rasx=ldate and cr.smena_rasx=nvl(lsmena,cr.smena_rasx) and cr.fk_id_naznach in (1,2);
          end if;
               
        --   Поступление рулонов травленых       ZPP_CHP_101_ TRAV 
        if lid_interface=62 then 
         OPEN saprec FOR   
         select
          null id,trunc(cdr.data_operacii,'dd') date_of_posting,last_minute_of_smena(cdr.data_operacii,cdr.smena_operacii) date_with_time,cdr.smena_operacii smena,cdr.brigada_operacii brigada,
                               cex_integro_info(61100,cr.fk_id_naznach,0,cdr.id,0,0,0,0,1) subject_id,
                               null subject_id_add, cex_integro_info(61100,cr.fk_id_naznach,0,cdr.id,0,0,0,0,2) subject_idr,
                                null subject_id_addr,
                                (select object_id from sap_sklad_lpc where r3_number=  '0809') object_id,
                               to_number(cex_integro_info(61100,cr.fk_id_naznach,0,cdr.id,0,0,0,0,4))  object_id_add,
                                '0809'  object_idr,
                                cex_integro_info(61100,cr.fk_id_naznach,0,cdr.id,0,0,0,0,5) object_id_addr,
                                8 process_id,952 system_id,1002  measure_unit_id, null account_id,null sd_ord,null sd_pos,
                               cex_integro_info(61100,cr.fk_id_naznach,0,cdr.id,0,0,0,0,3) descr_ozm,
                                null dlina,cdr.shirina,cdr.tolshina,nvl(cdr.stan_ves, cdr.akr_ves)  quantity,cp.num_plavki n_plavki,ras_nplv(cp.num_plavki,2) n_mnlz,null n_partii,null nom_oper,null n_slitka,null n_slyaba, null  n_krata,null n_kolodca,null tip_izlognic,null id_slitka,null id_slyaba,cdr.id id_rulpf,null n_rulona,null n_pachki,null n_lista, TO_CHAR (cdr.num_rul)   n_rulpf,
                                null n_avto,null id_krata,null id_rulpach,null erp_doc,null erp_pos,62 id_interface,null stat_date,null stat_userid,null n_motalki,null n_pechi,611 stan,4900 werks,'4900_08' cex,'ПФ' vid_oz,'ЦХП' n_cex ,97010 kdpr,2 kromka,1 travl,cdr.id_marki id_marki,
                                nvl(pl.id_ntd,pl.id_gost)  id_gostm,null id_gostt,null id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec,null date_of_postingr,cdr.id klus_id ,null object_type_id,null object_type_r,null marka,pl.plavka_id,0 status,null brigada_v,null brigada_r,line n_line,null subject_id_pzr,null subject_id_pzd,null m_sklad,1 prizn,null kds,case when pl.mnlz is null then 1 else 2 end  zagot,null vidslyab,null obrab,
                                null n_korob,ras_nplv(cp.num_plavki,4) god_plavki,null id_krat_lista,null n_krat_lista,null mesto_hranen_1,null mesto_hranen_2,to_char(num_matkart)  n_nakl,(select str_join(id_start)  from chp_hist where id_start!=id_finish and id_finish=cdr.id) id_svar_ru,null shifr_reglam,null vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr  
          from chp_postup cp
          left join chp_rul cr on (cp.id=cr.fk_id_postup )
          left join chp_dvig_rul cdr on (cr.id=cdr.fk_id_rul )
         left join plavka pl on pl.plavka_id=cp.plavka_id
          where  cp.cex_id=61100 and  nvl(cdr.pr_op,0)<7 and trunc(cdr.data_operacii)=ldate and cdr.smena_operacii=nvl(lsmena,cdr.smena_operacii)  and nvl(cdr.podmotka,0)=0;
    end if;
        --   Перемещение травленых рулонов ZPP_CHP_311_TRAV  
       if lid_interface=63 then 
         OPEN saprec FOR  
         select
           null id,trunc(ch.data_izm,'dd') date_of_posting,last_minute_of_smena(ch.data_izm,ch.smena_izm) date_with_time,ch.smena_izm smena,ch.brigada_izm brigada,
                                 cex_integro_info(61100,ch.id_naznach_old,0,cdr.id,0,0,0,0,1) subject_id,
                                 null subject_id_add,cex_integro_info(61100,ch.id_naznach_old,0,cdr.id,0,0,0,0,2) subject_idr,
                                null subject_id_addr,
                                 (select object_id from sap_sklad_lpc where r3_number=case when ch.id_naznach=3 then '0812' else '0802' end)  object_id,
                                case when nvl(ch.id_naznach_old,0) in (1,2) then (select object_id from sap_sklad_lpc where r3_number=  '0809') else  (select object_id from sap_sklad_lpc where r3_number=  '0801')  end  object_id_add,
                                case when ch.id_naznach=3 then '0812' else '0802' end object_idr,
                                case when nvl(ch.id_naznach_old,0) in (1,2) then '0809' else  '0801' end object_id_addr,
                                3 process_id,952 system_id,1002  measure_unit_id, null account_id,null sd_ord,null sd_pos,
                                cex_integro_info(61100,ch.id_naznach_old,0,cdr.id,0,0,0,0,3) descr_ozm,
                                null dlina,cdr.shirina,cdr.tolshina,nvl(cdr.stan_ves, cdr.akr_ves)   quantity,cp.num_plavki n_plavki,ras_nplv(cp.num_plavki,2) n_mnlz,null n_partii,null nom_oper,null n_slitka,null n_slyaba,null  n_krata,null n_kolodca,null tip_izlognic,null id_slitka,null id_slyaba,cdr.id id_rulpf,null n_rulona,null n_pachki,null n_lista, TO_CHAR (nvl(cdr.num_rul_do_porezki,cdr.num_rul))   n_rulpf,
                                null n_avto,null id_krata,null id_rulpach,null erp_doc,null erp_pos,63 id_interface,null stat_date,null stat_userid,null n_motalki,null n_pechi,611 stan,4900 werks,'4900_08' cex,'ПФ' vid_oz,'ЦХП' n_cex ,97010 kdpr,2 kromka,case when nvl(ch.id_naznach_old,0) in (1,2) then 1 else 0 end  travl,cdr.id_marki id_marki,
                                nvl(pl.id_ntd,pl.id_gost)  id_gostm,null id_gostt,null id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec,null date_of_postingr,cdr.id klus_id ,null object_type_id,null object_type_r,null marka,pl.plavka_id,0 status,null brigada_v,null brigada_r,line n_line,null subject_id_pzr,null subject_id_pzd,null m_sklad,1 prizn,null kds,case when pl.mnlz is null then 1 else 2 end  zagot,null vidslyab,null obrab,
                                null n_korob,ras_nplv(cp.num_plavki,4) god_plavki,null id_krat_lista,null n_krat_lista,null mesto_hranen_1,null mesto_hranen_2,to_char(num_matkart)  n_nakl,(select str_join( id_start)  from chp_hist where id_start!=id_finish and id_finish=cdr.id) id_svar_ru,null shifr_reglam,null vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr  
           from chp_postup cp
           left join chp_rul cr on (cp.id=cr.fk_id_postup )
           left join chp_dvig_rul cdr on (cr.id=cdr.fk_id_rul )
           left join chp_hist_per_rul ch on (cdr.id=ch.id_rul)
           left join plavka pl on pl.plavka_id=cp.plavka_id
           where  cp.cex_id=61100 and nvl(ch.id_naznach_old,0) in (0,1,2) and nvl(ch.id_naznach,0) in (3,68) and nvl(cdr.pr_op,0)<7 and trunc(ch.data_izm)=ldate and ch.smena_izm=nvl(lsmena,ch.smena_izm) and nvl(cdr.podmotka,0)=0;
end if;

  --Списание рулонов на отделку ZPP_CHP_261_OTD
     if lid_interface=64 then  
         OPEN saprec FOR  
         select 
          null id, trunc(cpr.data_porezki,'dd') date_of_posting,last_minute_of_smena(cpr.data_porezki,cpr.smena_porezki) date_with_time,cpr.smena_porezki smena,cpr.brigada_porezki brigada,
                                cex_integro_info(61100,cdr.fk_id_naznach,0,cdr.id,0,0,0,0,7) subject_id,
                                 null subject_id_add,cex_integro_info(61100,cdr.fk_id_naznach,0,cdr.id,0,0,0,0,8) subject_idr,
                                null subject_id_addr,
                                to_number(cex_integro_info(61100,cdr.fk_id_naznach,0,cdr.id,0,0,0,0,4))  object_id,
                               (select object_id from sap_sklad_lpc where r3_number= '0802') object_id_add,
                                cex_integro_info(61100,cdr.fk_id_naznach,0,cdr.id,0,0,0,0,5) object_idr,
                                '0802' object_id_addr,
                                2 process_id,961 system_id,1002  measure_unit_id, null account_id,null sd_ord,null sd_pos,
                               cex_integro_info(61100,cdr.fk_id_naznach,0,cdr.id,0,0,0,0,9) descr_ozm,
                               null dlina,cdr.shirina,cdr.tolshina,
                               nvl(cdr.akr_ves,cdr.ves)-round((select nvl(sum(ves/1000),0) from chp_porezka where fk_id_dvig_rul=cdr.id and nvl(pr_ostatok,0)=1),3)  quantity,
                               pl.num_plavki n_plavki,ras_nplv(pl.num_plavki,2) n_mnlz,null n_partii,null nom_oper,null n_slitka,null n_slyaba, null n_krata,null n_kolodca,null tip_izlognic,null id_slitka,null id_slyaba,cdr.id id_rulpf,null n_rulona,null n_pachki,null n_lista,cdr.num_rul n_rulpf,
                                null n_avto,null id_krata,null  id_rulpach,null erp_doc,null erp_pos,64 id_interface,null stat_date,null stat_userid,null n_motalki,null n_pechi,611 stan,4900 werks,'4900_08' cex,'ПФ' vid_oz,'ЦХП' n_cex ,97010 kdpr,2 kromka,chp_travlenie(cdr.id)  travl,cp.kod_marki id_marki,
                                nvl(pl.id_ntd,pl.id_gost)  id_gostm,null id_gostt,null id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec,null date_of_postingr,cdr.id  klus_id ,null object_type_id,null object_type_r,null marka,pl.plavka_id,0 status,null brigada_v,null brigada_r,line n_line,null subject_id_pzr,null subject_id_pzd,null m_sklad,1 prizn,null kds,case when pl.mnlz is null then 1 else 2 end  zagot,null vidslyab,0 obrab,
                                null n_korob,ras_nplv(pl.num_plavki,4) god_plavki,null id_krat_lista,null n_krat_lista,null mesto_hranen_1,null mesto_hranen_2,to_char(num_matkart)  n_nakl,null id_svar_ru,null shifr_reglam,null vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr  
          from (select min(data_porezki) data_porezki,min(brigada_porezki) brigada_porezki,min(smena_porezki) smena_porezki,fk_id_dvig_rul,min(id) id  from chp_porezka where data_porezki=ldate and smena_porezki=nvl(lsmena,smena_porezki)  and  id_agregata =68 and nvl(pr_op,0)<4   and nvl(pr_nal,0)<4 and nvl(pr_s_br_rul,0)=0 and nvl(pr_s_rs,0)=0 group by fk_id_dvig_rul) cpr  
          join chp_dvig_rul cdr on cpr.fk_id_dvig_rul =cdr.id
          join chp_rul cr on (cr.id=cdr.fk_id_rul )
          join chp_postup cp on (cp.id=cr.fk_id_postup )
          left join plavka pl on pl.plavka_id=cp.plavka_id
          where  cp.cex_id=61100 ;
        end if;    
            -- Поступление листов, г/к или травленых рулонов ZPP_CHP_101_ OTD
              if lid_interface=65 then 
         OPEN saprec FOR  
           select
          null id,trunc(cpr.data_porezki,'dd') date_of_posting,last_minute_of_smena(cpr.data_porezki,cpr.smena_porezki) date_with_time,cpr.smena_porezki smena,cpr.brigada_porezki brigada,
                                cex_integro_info(61100,cdr.fk_id_naznach,0,cdr.id,0,0,0,0,1) subject_id,
                                null subject_id_add,cex_integro_info(61100,cdr.fk_id_naznach,0,cdr.id,0,0,0,0,2) subject_idr,
                                null subject_id_addr,
                                (select object_id from sap_sklad_lpc where r3_number=  '0803') object_id,
                                 to_number(cex_integro_info(61100,cdr.fk_id_naznach,0,cdr.id,0,0,0,0,4)) object_id_add,
                               '0803'  object_idr,
                                cex_integro_info(61100,cdr.fk_id_naznach,0,cdr.id,0,0,0,0,5) object_id_addr,
                                8 process_id,962 system_id,1002  measure_unit_id, null account_id,null sd_ord,null sd_pos,
                               cex_integro_info(61100,cdr.fk_id_naznach,0,cdr.id,0,0,0,0,3)  descr_ozm,
                                cpr.dlina,cpr.shirina,cpr.tolshina,round(cpr.ves/1000,3)  quantity,cp.num_plavki n_plavki,ras_nplv(cp.num_plavki,2) n_mnlz,cpr.num_partii n_partii,null nom_oper,null n_slitka,null n_slyaba, null  n_krata,null n_kolodca,null tip_izlognic,null id_slitka,null id_slyaba,cdr.id id_rulpf,case when nvl(cpr.dlina,0)=0 then cpr.num_rul_pach else null end n_rulona,case when nvl(cpr.dlina,0)!=0 then cpr.num_rul_pach else null end n_pachki,null n_lista, to_char(cdr.num_rul)  n_rulpf,
                                null n_avto,null id_krata,cpr.id id_rulpach,null erp_doc,null erp_pos,65 id_interface,null stat_date,null stat_userid,null n_motalki,null n_pechi,611 stan,4900 werks,'4900_08' cex,'ПФ' vid_oz,'ЦХП' n_cex ,97010 kdpr,decode(cpr.kromka,'НО',2,'О',1,0) kromka,2  travl,cdr.id_marki id_marki,
                                nvl(pl.id_ntd,pl.id_gost)  id_gostm,null id_gostt,null id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec,null date_of_postingr,cpr.id klus_id ,null object_type_id,null object_type_r,null marka,pl.plavka_id,0 status,null brigada_v,null brigada_r,line n_line,null subject_id_pzr,null subject_id_pzd,null m_sklad,1 prizn,null kds,case when pl.mnlz is null then 1 else 2 end  zagot,null vidslyab,null obrab,
                                null n_korob,ras_nplv(cp.num_plavki,4) god_plavki,null id_krat_lista,null n_krat_lista,null mesto_hranen_1,null mesto_hranen_2,to_char(num_matkart)  n_nakl,(select str_join(id_start)  from chp_hist where id_start!=id_finish and id_finish=cdr.id) id_svar_ru,null shifr_reglam,cpr.kromka vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr  
          from chp_porezka cpr  
          left join chp_dvig_rul cdr on cpr.fk_id_dvig_rul =cdr.id
          left join chp_rul cr on (cr.id=cdr.fk_id_rul )
          left join chp_postup cp on (cp.id=cr.fk_id_postup )
          left join plavka pl on pl.plavka_id=cp.plavka_id
          where  cp.cex_id=61100 and  cpr.data_porezki=ldate and cpr.smena_porezki=nvl(lsmena,cpr.smena_porezki) and  cpr.id_agregata =68 and nvl(cpr.pr_op,0)<=3  and nvl(cpr.pr_ostatok,0)=0 and nvl(cpr.pr_nal,0)=0 and nvl(cpr.pr_s_br_rul,0)=0 and nvl(cpr.pr_s_rs,0)=0
          ;
           end if;
           -- Списание рулонов на прокатку на 4-х клетьевом стане ZPP_CHP_261_PROK
        if lid_interface=66 then 
         OPEN saprec FOR  
     select
          null id,trunc(cdr.stan_data,'dd') date_of_posting,last_minute_of_smena(cdr.stan_data,cdr.stan_sm) date_with_time,cdr.stan_sm smena,cdr.stan_br brigada,
                                cex_integro_info(61100,3,0,cdr.id,0,0,0,0,7) subject_id,
                                 null subject_id_add, cex_integro_info(61100,3,0,cdr.id,0,0,0,0,8) subject_idr,
                                null subject_id_addr,
                                 to_number(cex_integro_info(61100,3,0,cdr.id,0,0,0,0,4)) object_id,
                                 (select object_id from sap_sklad_lpc where r3_number=  '0812')  object_id_add,
                                 cex_integro_info(61100,3,0,cdr.id,0,0,0,0,5) object_idr,
                                 '0812' object_id_addr,
                                2 process_id,953 system_id,1002  measure_unit_id, null account_id,null sd_ord,null sd_pos,
                                 cex_integro_info(61100,3,0,cdr.id,0,0,0,0,9)  descr_ozm,
                                null dlina,cdr.shirina,cdr.tolshina,cdr.stan_ves  quantity,cp.num_plavki n_plavki,ras_nplv(cp.num_plavki,2) n_mnlz,null n_partii,null nom_oper,null n_slitka,null n_slyaba, null  n_krata,null n_kolodca,null tip_izlognic,null id_slitka,null id_slyaba,cdr.id id_rulpf,null n_rulona,null n_pachki,null n_lista, TO_CHAR (nvl(cdr.num_rul_do_porezki,cdr.num_rul) || cdr.stan_num_rul_a)  n_rulpf,
                                null n_avto,null id_krata,null id_rulpach,null erp_doc,null erp_pos,66 id_interface,null stat_date,null stat_userid,null n_motalki,null n_pechi,611 stan,4900 werks,'4900_08' cex,'ПФ' vid_oz,'ЦХП' n_cex ,97010 kdpr,2 kromka,null travl,cdr.id_marki id_marki,
                                nvl(pl.id_ntd,pl.id_gost)  id_gostm,null id_gostt,null id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec,null date_of_postingr,cdr.id klus_id ,null object_type_id,null object_type_r,null marka,pl.plavka_id,0 status,null brigada_v,null brigada_r,cdr.line  n_line,null subject_id_pzr,null subject_id_pzd,null m_sklad,1 prizn,null kds,case when pl.mnlz is null then 1 else 2 end  zagot,null vidslyab,null obrab,
                                null n_korob,ras_nplv(cp.num_plavki,4) god_plavki,null id_krat_lista,null n_krat_lista,null mesto_hranen_1,null mesto_hranen_2,to_char(num_matkart)  n_nakl,(select str_join(id_start)  from chp_hist where id_start!=id_finish and id_finish=cdr.id) id_svar_ru,null shifr_reglam,null vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr  
          from chp_postup cp
          left join chp_rul cr on (cp.id=cr.fk_id_postup )
          left join chp_dvig_rul cdr on (cr.id=cdr.fk_id_rul )
         left join plavka pl on pl.plavka_id=cp.plavka_id
        where  cp.cex_id=61100 and nvl(cdr.pr_op,0)<=7 and trunc(cdr.stan_data)=ldate and cdr.stan_sm=nvl(lsmena,cdr.stan_sm);
        end if;
        -- Поступление х/к рулонов ZPP_CHP_101_ PROK
       if lid_interface=67 then 
         OPEN saprec FOR  
        select  
           null id,trunc(cdr.stan_data,'dd') date_of_posting,last_minute_of_smena(cdr.stan_data,cdr.stan_sm) date_with_time,cdr.stan_sm smena,cdr.stan_br brigada,
                                 cex_integro_info(61100,3,0,cdr.id,0,0,0,0,1) subject_id,
                                 null subject_id_add, cex_integro_info(61100,3,0,cdr.id,0,0,0,0,2) subject_idr,
                                 null subject_id_addr,
                                 (select object_id from sap_sklad_lpc where r3_number=case when cdr.u_nazn like 'Zn%' then '0814' else '0813' end)  object_id,
                                 to_number(cex_integro_info(61100,3,0,cdr.id,0,0,0,0,4))  object_id_add,
                                case when cdr.u_nazn like 'Zn%' then '0814' else '0813' end  object_idr,
                                cex_integro_info(61100,3,0,cdr.id,0,0,0,0,5)  object_id_addr,
                                8 process_id,954 system_id,1002  measure_unit_id, null account_id,null sd_ord,null sd_pos,
                                 cex_integro_info(61100,3,0,cdr.id,0,0,0,0,3) descr_ozm,
                                null dlina,cdr.shirina,cdr.stan_tolshina,cdr.stan_ves_after  quantity,cp.num_plavki n_plavki,ras_nplv(cp.num_plavki,2) n_mnlz,null n_partii,null nom_oper,null n_slitka,null n_slyaba,null  n_krata,null n_kolodca,null tip_izlognic,null id_slitka,null id_slyaba,cdr.id id_rulpf,null n_rulona,null n_pachki,null n_lista, TO_CHAR (nvl(cdr.num_rul_do_porezki,cdr.num_rul) || cdr.stan_num_rul_a)  n_rulpf,
                                null n_avto,null id_krata,null id_rulpach,null erp_doc,null erp_pos,67 id_interface,null stat_date,null stat_userid,null n_motalki,null n_pechi,611 stan,4900 werks,'4900_08' cex,'ПФ' vid_oz,'ЦХП' n_cex ,97310 kdpr,2 kromka,null  travl,cdr.id_marki id_marki,
                               nvl(pl.id_ntd,pl.id_gost) id_gostm,null id_gostt,null id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec,null date_of_postingr,cdr.id klus_id ,null object_type_id,null object_type_r,null marka,pl.plavka_id,0 status,null brigada_v,null brigada_r,cdr.line n_line,null subject_id_pzr,null subject_id_pzd,null m_sklad,1 prizn,null kds,null zagot,null vidslyab,null obrab,
                                null n_korob,ras_nplv(cp.num_plavki,4) god_plavki,null id_krat_lista,null n_krat_lista,null mesto_hranen_1,null mesto_hranen_2,to_char(num_matkart)  n_nakl,(select str_join( id_start)  from chp_hist where id_start!=id_finish and id_finish=cdr.id) id_svar_ru,null shifr_reglam,null vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr  
           from chp_postup cp
           left join chp_rul cr on (cp.id=cr.fk_id_postup )
           left join chp_dvig_rul cdr on (cr.id=cdr.fk_id_rul )
           left join plavka pl on pl.plavka_id=cp.plavka_id
           where  cp.cex_id=61100  and nvl(cdr.pr_op,0)<=7 and trunc(cdr.stan_data)=ldate and cdr.stan_sm=nvl(lsmena,cdr.stan_sm);
       end if;    
        if lid_interface=161  then 
         OPEN saprec FOR  
        select  
           null id,trunc(cdr.stan_data,'dd') date_of_posting,last_minute_of_smena(cdr.stan_data,cdr.stan_sm) date_with_time,cdr.stan_sm smena,cdr.stan_br brigada,
                                 (select ozm_id from mdg where mdg_code='38.11.580000.00088') subject_id,
                                 null subject_id_add,  '38.11.580000.00088' subject_idr,
                                 null subject_id_addr,
                                 (select object_id from sap_sklad_lpc where r3_number='0815')  object_id,
                                 to_number(cex_integro_info(61100,3,0,cdr.id,0,0,0,0,4))  object_id_add,
                                 '0815'  object_idr,
                                 cex_integro_info(61100,3,0,cdr.id,0,0,0,0,5)  object_id_addr,
                                 9 process_id,954 system_id,1002  measure_unit_id, null account_id,null sd_ord,null sd_pos,
                                  (select naim from mdg where mdg_code='38.11.580000.00088') descr_ozm,
                                null dlina,cdr.shirina,cdr.stan_tolshina,abs(nvl(cdr.stan_ves_after,0)-nvl(cdr.stan_ves,0))  quantity,cp.num_plavki n_plavki,ras_nplv(cp.num_plavki,2) n_mnlz,null n_partii,null nom_oper,null n_slitka,null n_slyaba,null  n_krata,null n_kolodca,null tip_izlognic,null id_slitka,null id_slyaba,cdr.id id_rulpf,null n_rulona,null n_pachki,null n_lista, TO_CHAR (nvl(cdr.num_rul_do_porezki,cdr.num_rul) || cdr.stan_num_rul_a)  n_rulpf,
                                null n_avto,null id_krata,null id_rulpach,null erp_doc,null erp_pos,161 id_interface,null stat_date,null stat_userid,null n_motalki,null n_pechi,611 stan,4900 werks,'4900_08' cex,'ПФ' vid_oz,'ЦХП' n_cex ,97310 kdpr,2 kromka,null  travl,cdr.id_marki id_marki,
                               nvl(pl.id_ntd,pl.id_gost)  id_gostm,null id_gostt,null id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec,null date_of_postingr,cdr.id klus_id ,null object_type_id,null object_type_r,null marka,pl.plavka_id,0 status,null brigada_v,null brigada_r,cdr.line  n_line,null subject_id_pzr,null subject_id_pzd,null m_sklad,1 prizn,null kds,null zagot,null vidslyab,null obrab,
                                null n_korob,ras_nplv(cp.num_plavki,4) god_plavki,null id_krat_lista,null n_krat_lista,null mesto_hranen_1,null mesto_hranen_2,to_char(num_matkart)  n_nakl,(select str_join( id_start)  from chp_hist where id_start!=id_finish and id_finish=cdr.id) id_svar_ru,null shifr_reglam,null vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr  
           from chp_postup cp
           left join chp_rul cr on (cp.id=cr.fk_id_postup )
           left join chp_dvig_rul cdr on (cr.id=cdr.fk_id_rul )
           left join plavka pl on pl.plavka_id=cp.plavka_id
           where  cp.cex_id=61100  and nvl(cdr.pr_op,0)<=7 and trunc(cdr.stan_data)=ldate and cdr.stan_sm=nvl(lsmena,cdr.stan_sm) and nvl(cdr.stan_ves_after,0)-nvl(cdr.stan_ves,0)!=0;
       end if;    
       
           -- Перемещение х/к рулонов ZPP_CHP_311_ PROK
              if lid_interface=68 then 
         OPEN saprec FOR  
           select
            null id,trunc(cdr.stan_data,'dd') date_of_posting,last_minute_of_smena(cdr.stan_data,cdr.stan_sm) date_with_time,cdr.stan_sm smena,cdr.stan_br brigada,
                               cex_integro_info(61100,3,0,cdr.id,0,0,0,0,1) subject_id,
                                 null subject_id_add,  cex_integro_info(61100,3,0,cdr.id,0,0,0,0,2) subject_idr,
                                null subject_id_addr,
                                 (select object_id from sap_sklad_lpc where r3_number=case when cdr.fk_id_naznach=4 then '0826' when cdr.fk_id_naznach=5 then '0829' else '0816' end)  object_id,
                              (select object_id from sap_sklad_lpc where r3_number=case when cdr.u_nazn like 'Zn%' then '0814' else '0813' end) object_id_add,
                               case when cdr.fk_id_naznach=4 then '0826' when cdr.fk_id_naznach=5 then '0829' else '0816' end  object_idr,
                                case when cdr.u_nazn like 'Zn%' then '0814' else '0813' end  object_id_addr,
                                3 process_id,954 system_id,1002  measure_unit_id, null account_id,null sd_ord,null sd_pos,
                                 cex_integro_info(61100,3,0,cdr.id,0,0,0,0,3) descr_ozm,
                                null dlina,cdr.shirina,cdr.stan_tolshina,cdr.stan_ves_after  quantity,cp.num_plavki n_plavki,ras_nplv(cp.num_plavki,2) n_mnlz,null n_partii,null nom_oper,null n_slitka,null n_slyaba,null  n_krata,null n_kolodca,null tip_izlognic,null id_slitka,null id_slyaba,cdr.id id_rulpf,null n_rulona,null n_pachki,null n_lista, to_char(cdr.num_rul||stan_num_rul_a)  n_rulpf,
                                null n_avto,null id_krata,null id_rulpach,null erp_doc,null erp_pos,68 id_interface,null stat_date,null stat_userid,null n_motalki,null n_pechi,611 stan,4900 werks,'4900_08' cex,'ПФ' vid_oz,'ЦХП' n_cex ,97310 kdpr,2 kromka,null  travl,cdr.id_marki id_marki,
                                nvl(pl.id_ntd,pl.id_gost)  id_gostm,null id_gostt,null id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec,null date_of_postingr,cdr.id klus_id ,null object_type_id,null object_type_r,null marka,pl.plavka_id,0 status,null brigada_v,null brigada_r,cdr.line n_line,null subject_id_pzr,null subject_id_pzd,null m_sklad,1 prizn,null kds,null zagot,null vidslyab,null obrab,
                                null n_korob,ras_nplv(cp.num_plavki,4) god_plavki,null id_krat_lista,null n_krat_lista,null mesto_hranen_1,null mesto_hranen_2,to_char(num_matkart)  n_nakl,(select str_join(id_start)  from chp_hist where id_start!=id_finish and id_finish=cdr.id) id_svar_ru,null shifr_reglam,null vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr  
           from chp_postup cp
           left join chp_rul cr on (cp.id=cr.fk_id_postup )
           left join chp_dvig_rul cdr on (cr.id=cdr.fk_id_rul )
          -- left join chp_hist_per_rul ch on (cdr.id=ch.id_rul)
           left join plavka pl on pl.plavka_id=cp.plavka_id
          -- where  cp.cex_id=61100  and nvl(ch.id_naznach_old,0) in (3) and nvl(ch.id_naznach,0) in (4,5,87) and NVL (cdr.pr_op, 0) =0   and trunc(ch.data_izm)=ldate and ch.smena_izm=nvl(lsmena,ch.smena_izm)
           where  cp.cex_id=61100  and nvl(cdr.pr_op,0)<=7 and trunc(cdr.stan_data)=ldate and cdr.stan_sm=nvl(lsmena,cdr.stan_sm);
           end if;
           
           -- Перемещение с участка термообработки в колпаковые печи  ZPP_CHP_311_ TERM
       if lid_interface=69 then 
         OPEN saprec FOR  
  select
      null id,trunc(cdr.to_data_upak_st,'dd') date_of_posting,last_minute_of_smena(cdr.to_data_upak_st,cdr.to_smena_upak) date_with_time,cdr.to_smena_upak smena,cdr.to_brigada_upak brigada,
                                cex_integro_info(61100,3,0,cdr.id,0,0,0,0,1)  subject_id,
                                 null subject_id_add,  cex_integro_info(61100,3,0,cdr.id,0,0,0,0,2)subject_idr,
                                null subject_id_addr,
                                (select object_id from sap_sklad_lpc where r3_number=  '0827') object_id,
                                 (select object_id from sap_sklad_lpc where r3_number=  '0826')  object_id_add,
                                '0827' object_idr,
                                '0826' object_id_addr,
                                3 process_id,975 system_id,1002  measure_unit_id, null account_id,null sd_ord,null sd_pos,
                                 cex_integro_info(61100,3,0,cdr.id,0,0,0,0,3) descr_ozm,
                                null dlina,cdr.shirina,cdr.stan_tolshina,cdr.stan_ves_after  quantity,cp.num_plavki n_plavki,ras_nplv(cp.num_plavki,2) n_mnlz,cdr.num_partii n_partii,null nom_oper,null n_slitka,null n_slyaba, null  n_krata,null n_kolodca,null tip_izlognic,null id_slitka,null id_slyaba,cdr.id id_rulpf,null n_rulona,null n_pachki,null n_lista, to_char(cdr.num_rul||stan_num_rul_a)  n_rulpf,
                                null n_avto,null id_krata,null id_rulpach,null erp_doc,null erp_pos,69 id_interface,null stat_date,null stat_userid,null n_motalki,null n_pechi,611 stan,4900 werks,'4900_08' cex,'ПФ' vid_oz,'ЦХП' n_cex ,97310 kdpr,2 kromka,null travl,cdr.id_marki id_marki,
                                nvl(pl.id_ntd,pl.id_gost)  id_gostm,null id_gostt,null id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec,null date_of_postingr,cdr.id klus_id ,null object_type_id,null object_type_r,null marka,pl.plavka_id,0 status,null brigada_v,null brigada_r,line n_line,null subject_id_pzr,null subject_id_pzd,null m_sklad,1 prizn,null kds,null zagot,null vidslyab,null obrab,
                                null n_korob,ras_nplv(cp.num_plavki,4) god_plavki,null id_krat_lista,null n_krat_lista,null mesto_hranen_1,null mesto_hranen_2,to_char(num_matkart) n_nakl,(select str_join( id_start)  from chp_hist where id_start!=id_finish and id_finish=cdr.id) id_svar_ru,null shifr_reglam,null vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr  
          from chp_postup cp
          left join chp_rul cr on (cp.id=cr.fk_id_postup )
          left join chp_dvig_rul cdr on (cr.id=cdr.fk_id_rul )
          left join plavka pl on pl.plavka_id=cp.plavka_id
          where  cp.cex_id=61100 and  NVL (cdr.pr_op, 0) <7 and  trunc(cdr.to_data_upak_st)=ldate and cdr.to_smena_upak=nvl(lsmena,cdr.to_smena_upak);
          end if;
          -- Списание рулонов х/к на термообработку ZPP_CHP_261_TO
             if lid_interface=70 then 
         OPEN saprec FOR  
           select -- поменять даты
           null id,
           --trunc(cdr.to_data_upak_st,'dd') date_of_posting,last_minute_of_smena(cdr.to_data_upak_st,cdr.to_smena_upak) date_with_time,cdr.to_smena_upak smena,cdr.to_brigada_upak brigada,
           trunc(cdr.to_data_rasp,'dd') date_of_posting,last_minute_of_smena(cdr.to_data_rasp,cdr.to_smena_rasp) date_with_time,cdr.to_smena_rasp smena,cdr.to_brigada_rasp brigada,
                                cex_integro_info(61100,4,0,cdr.id,0,0,0,0,7) subject_id,
                                 null subject_id_add,  cex_integro_info(61100,4,0,cdr.id,0,0,0,0,8)  subject_idr,
                                null subject_id_addr,
                               to_number(cex_integro_info(61100,4,0,cdr.id,0,0,0,0,4))    object_id,
                              (select object_id from sap_sklad_lpc where r3_number='0827') object_id_add,
                              cex_integro_info(61100,4,0,cdr.id,0,0,0,0,5)   object_idr,
                                 '0827'  object_id_addr,
                                2 process_id,955 system_id,1002  measure_unit_id, null account_id,null sd_ord,null sd_pos,
                                 cex_integro_info(61100,4,0,cdr.id,0,0,0,0,9)   descr_ozm,
                                null dlina,cdr.shirina,cdr.stan_tolshina,cdr.stan_ves_after  quantity,cp.num_plavki n_plavki,ras_nplv(cp.num_plavki,2) n_mnlz,cdr.num_partii n_partii,null nom_oper,null n_slitka,null n_slyaba,null  n_krata,null n_kolodca,null tip_izlognic,null id_slitka,null id_slyaba,cdr.id id_rulpf,null n_rulona,null n_pachki,null n_lista, to_char(cdr.num_rul||stan_num_rul_a)  n_rulpf,
                                null n_avto,null id_krata,null id_rulpach,null erp_doc,null erp_pos,70 id_interface,null stat_date,null stat_userid,null n_motalki,null n_pechi,611 stan,4900 werks,'4900_08' cex,'ПФ' vid_oz,'ЦХП' n_cex ,97310 kdpr,2 kromka,null  travl,cdr.id_marki id_marki,
                                nvl(pl.id_ntd,pl.id_gost)  id_gostm,null id_gostt,null id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec,null date_of_postingr,cdr.id klus_id ,null object_type_id,null object_type_r,null marka,pl.plavka_id,0 status,null brigada_v,null brigada_r,line n_line,null subject_id_pzr,null subject_id_pzd,null m_sklad,1 prizn,null kds,null zagot,null vidslyab,null obrab,
                                null n_korob,ras_nplv(cp.num_plavki,4) god_plavki,null id_krat_lista,null n_krat_lista,null mesto_hranen_1,null mesto_hranen_2,to_char(num_matkart)  n_nakl,(select str_join(id_start)  from chp_hist where id_start!=id_finish and id_finish=cdr.id) id_svar_ru,null shifr_reglam,null vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr  
           from chp_postup cp
           left join chp_rul cr on (cp.id=cr.fk_id_postup )
           left join chp_dvig_rul cdr on (cr.id=cdr.fk_id_rul )
          left join plavka pl on pl.plavka_id=cp.plavka_id
           where  cp.cex_id=61100   and NVL (cdr.pr_op, 0) <7 and trunc(cdr.to_data_rasp)=ldate and cdr.to_smena_rasp=nvl(lsmena,cdr.to_smena_rasp);
           --and  trunc(cdr.to_data_upak_st)=ldate and cdr.to_smena_upak=nvl(lsmena,cdr.to_smena_upak);
           end if;
           -- Поступление рулонов термообработанных  ZPP_CHP_101_ TO
              if lid_interface=71 then 
         OPEN saprec FOR  
                select
          null id,trunc(cdr.to_data_rasp,'dd') date_of_posting,last_minute_of_smena(cdr.to_data_rasp,cdr.to_smena_rasp) date_with_time,cdr.to_smena_rasp smena,cdr.to_brigada_rasp brigada,
                                 cex_integro_info(61100,4,0,cdr.id,0,0,0,0,1) subject_id,
                                null subject_id_add, cex_integro_info(61100,4,0,cdr.id,0,0,0,0,2 )subject_idr,
                                null subject_id_addr,
                                (select object_id from sap_sklad_lpc where r3_number=  '0828') object_id,
                                 to_number(cex_integro_info(61100,4,0,cdr.id,0,0,0,0,4))  object_id_add,
                                '0828'  object_idr,
                                 cex_integro_info(61100,4,0,cdr.id,0,0,0,0,5) object_id_addr,
                                8 process_id,956 system_id,1002  measure_unit_id, null account_id,null sd_ord,null sd_pos,
                                 cex_integro_info(61100,4,0,cdr.id,0,0,0,0,3)  descr_ozm,
                                null dlina,cdr.shirina,cdr.stan_tolshina,cdr.stan_ves_after  quantity,cp.num_plavki n_plavki,ras_nplv(cp.num_plavki,2) n_mnlz,cdr.num_partii n_partii,null nom_oper,null n_slitka,null n_slyaba, null  n_krata,null n_kolodca,null tip_izlognic,null id_slitka,null id_slyaba,cdr.id id_rulpf,null n_rulona,null n_pachki,null n_lista, to_char(cdr.num_rul||stan_num_rul_a)  n_rulpf,
                                null n_avto,null id_krata,null id_rulpach,null erp_doc,null erp_pos,71 id_interface,null stat_date,null stat_userid,null n_motalki,null n_pechi,611 stan,4900 werks,'4900_08' cex,'ПФ' vid_oz,'ЦХП' n_cex ,97310 kdpr,2 kromka,1 travl,cdr.id_marki id_marki,
                                nvl(pl.id_ntd,pl.id_gost) id_gostm,null id_gostt,null id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec,null date_of_postingr,cdr.id klus_id ,null object_type_id,null object_type_r,null marka,pl.plavka_id,0 status,null brigada_v,null brigada_r,to_num_stenda||case  when to_num_stenda_n is null then null else '/'||to_num_stenda_n end n_line,null subject_id_pzr,null subject_id_pzd,null m_sklad,1 prizn,null kds,null zagot,null vidslyab,null obrab,
                                null n_korob,ras_nplv(cp.num_plavki,4) god_plavki,null id_krat_lista,null n_krat_lista,null mesto_hranen_1,null mesto_hranen_2,to_char(num_matkart)  n_nakl,(select str_join(id_start)  from chp_hist where id_start!=id_finish and id_finish=cdr.id) id_svar_ru,null shifr_reglam,null vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr  
          from chp_postup cp
          left join chp_rul cr on (cp.id=cr.fk_id_postup )
          left join chp_dvig_rul cdr on (cr.id=cdr.fk_id_rul )
         left join plavka pl on pl.plavka_id=cp.plavka_id
          where  cp.cex_id=61100 and  NVL (cdr.pr_op, 0) <7  and trunc(cdr.to_data_rasp)=ldate and cdr.to_smena_rasp=nvl(lsmena,cdr.to_smena_rasp) ;
          end if;
          -- Перемещение т/о рулонов ZPP_CHP_311_ TO
             if lid_interface=72 then 
         OPEN saprec FOR  
             select
           null id,trunc(ch.data_izm,'dd') date_of_posting,last_minute_of_smena(ch.data_izm,ch.smena_izm) date_with_time,ch.smena_izm smena,ch.brigada_izm brigada,
                                cex_integro_info(61100,4,0,cdr.id,0,0,0,0,1) subject_id,
                                null subject_id_add, cex_integro_info(61100,4,0,cdr.id,0,0,0,0,2)subject_idr,
                                null subject_id_addr,
                                 (select object_id from sap_sklad_lpc where r3_number=case when ch.id_naznach=3 then '0812' else '0829' end)  object_id,
                                (select object_id from sap_sklad_lpc where r3_number=  '0828')  object_id_add,
                                case when ch.id_naznach=3 then '0812' else '0829' end object_idr,
                                '0828' object_id_addr,
                                3 process_id,956 system_id,1002  measure_unit_id, null account_id,null sd_ord,null sd_pos,
                                 cex_integro_info(61100,4,0,cdr.id,0,0,0,0,3) descr_ozm,
                                null dlina,cdr.shirina,cdr.stan_tolshina,cdr.stan_ves_after  quantity,cp.num_plavki n_plavki,ras_nplv(cp.num_plavki,2) n_mnlz,cdr.num_partii n_partii,null nom_oper,null n_slitka,null n_slyaba,null  n_krata,null n_kolodca,null tip_izlognic,null id_slitka,null id_slyaba,cdr.id id_rulpf,null n_rulona,null n_pachki,null n_lista, to_char(cdr.num_rul||stan_num_rul_a)  n_rulpf,
                                null n_avto,null id_krata,null id_rulpach,null erp_doc,null erp_pos,72 id_interface,null stat_date,null stat_userid,null n_motalki,null n_pechi,611 stan,4900 werks,'4900_08' cex,'ПФ' vid_oz,'ЦХП' n_cex ,97010 kdpr,2 kromka,1  travl,cdr.id_marki id_marki,
                                nvl(pl.id_ntd,pl.id_gost) id_gostm,null id_gostt,null id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec,null date_of_postingr,cdr.id klus_id ,null object_type_id,null object_type_r,null marka,pl.plavka_id,0 status,null brigada_v,null brigada_r,to_num_stenda||case  when to_num_stenda_n is null then null else '/'||to_num_stenda_n end n_line,null subject_id_pzr,null subject_id_pzd,null m_sklad,1 prizn,null kds,null zagot,null vidslyab,null obrab,
                                null n_korob,ras_nplv(cp.num_plavki,4) god_plavki,null id_krat_lista,null n_krat_lista,null mesto_hranen_1,null mesto_hranen_2,to_char(num_matkart)  n_nakl,(select str_join( id_start)  from chp_hist where id_start!=id_finish and id_finish=cdr.id) id_svar_ru,null shifr_reglam,null vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr  
           from chp_postup cp
           left join chp_rul cr on (cp.id=cr.fk_id_postup )
           left join chp_dvig_rul cdr on (cr.id=cdr.fk_id_rul )
           left join chp_hist_per_rul ch on (cdr.id=ch.id_rul)
           left join plavka pl on pl.plavka_id=cp.plavka_id
           where  cp.cex_id=61100 and nvl(ch.id_naznach_old,0) in (4) and nvl(ch.id_naznach,0) in (3,5) and nvl(cdr.pr_op,0)=0 and trunc(ch.data_izm)=ldate and ch.smena_izm=nvl(lsmena,ch.smena_izm);
           end if;
           -- Списание рулонов на оцинкование  ZPP_CHP_261_OCEN
              if lid_interface=73 then 
         OPEN saprec FOR         
              select 
           null id,trunc(cpr.data_porezki,'dd') date_of_posting,last_minute_of_smena(cpr.data_porezki,cpr.smena_porezki) date_with_time,cpr.smena_porezki smena,cpr.brigada_porezki brigada,
                                 cex_integro_info(61100,cdr.fk_id_naznach,0,cdr.id,0,0,0,0,7)  subject_id, 
                 null subject_id_add,
                 cex_integro_info(61100,cdr.fk_id_naznach,0,cdr.id,0,0,0,0,8)  subject_idr,
                               null subject_id_addr,
                               to_number(cex_integro_info(61100,cdr.fk_id_naznach,0,cdr.id,0,0,0,0,4))   object_id,
                              (select object_id from sap_sklad_lpc where r3_number=  '0816' ) object_id_add,
                              cex_integro_info(61100,cdr.fk_id_naznach,0,cdr.id,0,0,0,0,5)   object_idr,
                               '0816'   object_id_addr,
                               2 process_id,957 system_id,1002  measure_unit_id, null account_id,null sd_ord,null sd_pos,
                               cex_integro_info(61100,cdr.fk_id_naznach,0,cdr.id,0,0,0,0,9)  descr_ozm,
                                null dlina,cdr.shirina,cdr.stan_tolshina,
                                cdr.stan_ves_after-round((select nvl(sum(ves/1000),0) from chp_porezka where fk_id_dvig_rul=cdr.id and nvl(pr_ostatok,0)=1),3)   quantity,
                                cp.num_plavki n_plavki,ras_nplv(cp.num_plavki,2) n_mnlz,null n_partii,null nom_oper,null n_slitka,null n_slyaba,null  n_krata,null n_kolodca,null tip_izlognic,null id_slitka,null id_slyaba,cdr.id id_rulpf,null n_rulona,null n_pachki,null n_lista, to_char(cdr.num_rul||stan_num_rul_a)  n_rulpf,
                                null n_avto,null id_krata,null id_rulpach,null erp_doc,null erp_pos,73 id_interface,null stat_date,null stat_userid,null n_motalki,null n_pechi,611 stan,4900 werks,'4900_08' cex,'ПФ' vid_oz,'ЦХП' n_cex ,97310 kdpr,0 kromka,0  travl,cdr.id_marki id_marki,
                               nvl(pl.id_ntd,pl.id_gost)  id_gostm,null id_gostt,null id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec,null date_of_postingr,cdr.id klus_id ,null object_type_id,null object_type_r,null marka,pl.plavka_id,0 status,null brigada_v,null brigada_r,line_no n_line,null subject_id_pzr,null subject_id_pzd,null m_sklad,1 prizn,null kds,case when pl.mnlz is null then 1 else 2 end  zagot,null vidslyab,0  obrab,
                                null n_korob,ras_nplv(cp.num_plavki,4) god_plavki,null id_krat_lista,null n_krat_lista,null mesto_hranen_1,null mesto_hranen_2,to_char(num_matkart)  n_nakl,(select str_join(id_start)  from chp_hist where id_start!=id_finish and id_finish=cdr.id) id_svar_ru,null shifr_reglam,null vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr  
            
           from (select min(data_porezki) data_porezki,min(brigada_porezki) brigada_porezki,min(smena_porezki) smena_porezki,fk_id_dvig_rul,min(id) id,min(line_no) line_no  from chp_porezka where data_porezki=ldate and smena_porezki=nvl(lsmena,smena_porezki)  and id_agregata in (66,67) and nvl(pr_op,0)<4 and nvl(pr_nal,0)<4  and nvl(pr_s_br_rul,0)=0 and nvl(pr_s_rs,0)=0 and (line_no=lagregat or nvl(lagregat,0)=0) group by fk_id_dvig_rul) cpr  
          join chp_dvig_rul cdr on cpr.fk_id_dvig_rul =cdr.id
          join chp_rul cr on (cr.id=cdr.fk_id_rul )
          join chp_postup cp on (cp.id=cr.fk_id_postup )
          left join plavka pl on pl.plavka_id=cp.plavka_id
          where  cp.cex_id=61100 ;
           
           end if;
           -- Поступление рулонов и листов после оцинкования ZPP_CHP_101_OCEN
              if lid_interface=74 then 
         OPEN saprec FOR  
           select
          null id,trunc(cpr.data_porezki,'dd') date_of_posting,last_minute_of_smena(cpr.data_porezki,cpr.smena_porezki) date_with_time,cpr.smena_porezki smena,cpr.brigada_porezki brigada,
                               cex_integro_info(61100,cdr.fk_id_naznach,0,cdr.id,0,0,0,0,1)   subject_id,
                                null subject_id_add, cex_integro_info(61100,cdr.fk_id_naznach,0,cdr.id,0,0,0,0,2)   subject_idr,
                                null subject_id_addr,
                                  (select object_id from sap_sklad_lpc where r3_number= case when cpr.id_agregata=66 then  '0817' else '0822' end ) object_id,
                                 to_number( cex_integro_info(61100,cdr.fk_id_naznach,0,cdr.id,0,0,0,0,4) )   object_id_add,
                                 case when cpr.id_agregata=66 then  '0817' else '0822' end  object_idr,
                                cex_integro_info(61100,cdr.fk_id_naznach,0,cdr.id,0,0,0,0,5)    object_id_addr,
                                8 process_id,958 system_id,1002  measure_unit_id, null account_id,null sd_ord,null sd_pos,
                               cex_integro_info(61100,cdr.fk_id_naznach,0,cdr.id,0,0,0,0,3) descr_ozm,
                                cpr.dlina,cpr.shirina,cpr.tolshina,round(nvl(cpr.ves_1karm,nvl(cpr.ves_ne_att,cpr.ves))/1000,3)  quantity,cp.num_plavki n_plavki,ras_nplv(cp.num_plavki,2) n_mnlz,cpr.num_partii n_partii,null nom_oper,null n_slitka,null n_slyaba, null  n_krata,null n_kolodca,null tip_izlognic,null id_slitka,null id_slyaba,cdr.id id_rulpf,
                                case when nvl(cpr.dlina,0)=0 then case when line_no is not null then line_no||'-'||cpr.num_rul_pach else  to_char(cpr.num_rul_pach) end else null end n_rulona,
                                case when nvl(cpr.dlina,0)!=0 then case when line_no is not null then line_no||'-'||cpr.num_rul_pach else to_char(cpr.num_rul_pach) end else null end n_pachki,
                                null n_lista, to_char(cdr.num_rul||stan_num_rul_a)  n_rulpf,
                                null n_avto,null id_krata,cpr.id id_rulpach,null erp_doc,null erp_pos,74 id_interface,null stat_date,null stat_userid,null n_motalki,null n_pechi,611 stan,4900 werks,'4900_08' cex,'ПФ' vid_oz,'ЦХП' n_cex ,case when nvl(cpr.dlina,0)=0 then 97010 else 97000 end kdpr,decode(cpr.kromka,'НО',2,'О',1,0) kromka,null travl,cdr.id_marki id_marki,
                               nvl(pl.id_ntd,pl.id_gost)  id_gostm,null id_gostt,null id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec,null date_of_postingr,cpr.id klus_id ,null object_type_id,null object_type_r,null marka,pl.plavka_id,0 status,null brigada_v,null brigada_r,cpr.line_no n_line,null subject_id_pzr,null subject_id_pzd,null m_sklad,1 prizn,null kds,null zagot,null vidslyab,null obrab,
                                null n_korob,ras_nplv(cp.num_plavki,4) god_plavki,null id_krat_lista,null n_krat_lista,null mesto_hranen_1,null mesto_hranen_2,to_char(num_matkart)  n_nakl,(select str_join(id_start)  from chp_hist where id_start!=id_finish and id_finish=cdr.id) id_svar_ru,null shifr_reglam,cpr.kromka vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr  
          from chp_porezka cpr  
          left join chp_dvig_rul cdr on cpr.fk_id_dvig_rul =cdr.id
          left join chp_rul cr on (cr.id=cdr.fk_id_rul )
          left join chp_postup cp on (cp.id=cr.fk_id_postup )
          left join plavka pl on pl.plavka_id=cp.plavka_id
          where  cp.cex_id=61100 and  cpr.data_porezki=ldate and cpr.smena_porezki=nvl(lsmena,cpr.smena_porezki) and cpr.id_agregata in (66,67) and nvl(cpr.pr_op,0)<=3 and nvl(cpr.pr_ostatok,0)=0 and nvl(cpr.pr_s_br_rul,0)=0 and nvl(cpr.pr_s_rs,0)=0 and (line_no=lagregat or nvl(lagregat,0)=0);
         end if;
           --Перемещение оцинкованных рулонов и листов ZPP_CHP_311_OCEN
                  if lid_interface=75 then 
         OPEN saprec FOR  
              select
          null id,trunc(ch.data_izm,'dd') date_of_posting,last_minute_of_smena(ch.data_izm,ch.smena_izm) date_with_time,ch.smena_izm smena,ch.brigada_izm brigada,
                                 cex_integro_info(61100,ch.id_naznach_old,0,cdr.id,0,0,0,0,1)  subject_id,
                                null subject_id_add, cex_integro_info(61100,ch.id_naznach_old,0,cdr.id,0,0,0,0,2)  subject_idr,
                                null subject_id_addr,
                                  (select object_id from sap_sklad_lpc where r3_number=  '0829') object_id,
                               (select object_id from sap_sklad_lpc where r3_number= case when cdr.fk_id_agregat in (66,87) then '0818' else '0823' end)  object_id_add,
                                 '0829'  object_idr,
                                  (select object_id from sap_sklad_lpc where r3_number= case when cdr.fk_id_agregat in (66,87) then '0818' else '0823' end)  object_id_addr,
                                3 process_id,958 system_id,1002  measure_unit_id, null account_id,null sd_ord,null sd_pos,
                                   cex_integro_info(61100,ch.id_naznach_old,0,cdr.id,0,0,0,0,3)   descr_ozm,
                                null dlina, cdr.shirina,cdr.stan_tolshina,cdr.stan_ves_after   quantity,cp.num_plavki n_plavki,ras_nplv(cp.num_plavki,2) n_mnlz,cdr.num_partii n_partii,null nom_oper,null n_slitka,null n_slyaba, null  n_krata,null n_kolodca,null tip_izlognic,null id_slitka,null id_slyaba,cdr.id id_rulpf,null  n_rulona,null n_pachki,null n_lista, to_char(cdr.num_rul)  n_rulpf,
                                null n_avto,null id_krata,null  id_rulpach,null erp_doc,null erp_pos,75 id_interface,null stat_date,null stat_userid,null n_motalki,null n_pechi,611 stan,4900 werks,'4900_08' cex,'ПФ' vid_oz,'ЦХП' n_cex , 97010 kdpr ,2 kromka,null travl,cdr.id_marki id_marki,
                                nvl(pl.id_ntd,pl.id_gost)  id_gostm,null id_gostt,null id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec,null date_of_postingr,cdr.id klus_id ,null object_type_id,null object_type_r,null marka,pl.plavka_id,0 status,null brigada_v,null brigada_r,cdr.line  n_line,null subject_id_pzr,null subject_id_pzd,null m_sklad,1 prizn,null kds,null zagot,null vidslyab,null obrab,
                                null n_korob,ras_nplv(cp.num_plavki,4) god_plavki,null id_krat_lista,null n_krat_lista,null mesto_hranen_1,null mesto_hranen_2,to_char(num_matkart)  n_nakl,(select str_join( id_start)  from chp_hist where id_start!=id_finish and id_finish=cdr.id) id_svar_ru,null shifr_reglam,null vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr  
          from chp_dvig_rul cdr  
          left join chp_hist_per_rul ch on (cdr.id=ch.id_rul)
          left join chp_rul cr on (cr.id=cdr.fk_id_rul )
          left join chp_postup cp on (cp.id=cr.fk_id_postup )
          left join plavka pl on pl.plavka_id=cp.plavka_id
          where  cp.cex_id=61100  and nvl(ch.id_naznach_old,0) in (66,67,87)     and nvl(ch.id_naznach,0) in (5) and nvl(cdr.pr_op,0)=0 and trunc(ch.data_izm)=ldate and ch.smena_izm=nvl(lsmena,ch.smena_izm) and (line=lagregat or nvl(lagregat,0)=0);
           end if;
         --Списание рулонов на дрессировку ZPP_CHP_261_DRESER
              if lid_interface=76 then 
         OPEN saprec FOR  
             SELECT NULL id, TRUNC (cdr.dres_data_enter, 'dd') date_of_posting, last_minute_of_smena (cdr.dres_data_enter, cdr.dres_sm) date_with_time, cdr.dres_sm smena,cdr.dres_br brigada,
                   cex_integro_info (61100, 5, 0, cdr.id, 0, 0, 0, 0, 7)   subject_id,
                   NULL subject_id_add, cex_integro_info (61100, 5, 0,
                                     cdr.id,
                                     0,
                                     0,
                                     0,
                                     0,
                                     8)
                      subject_idr,
                   NULL subject_id_addr,
                   TO_NUMBER (cex_integro_info (61100,
                                                5,
                                                0,
                                                cdr.id,
                                                0,
                                                0,
                                               0,
                                                0,
                                                4))
                      object_id,
                   (SELECT object_id
                      FROM sap_sklad_lpc
                     WHERE r3_number = '0829')
                      object_id_add,
                   cex_integro_info (61100,
                                     5,
                                     0,
                                     cdr.id,
                                     0,
                                     0,
                                     0,
                                     0,
                                     5)
                      object_idr,
                   '0829' object_id_addr,
                   2 process_id,
                   959 system_id,
                   1002 measure_unit_id,
                   NULL account_id,
                   NULL sd_ord,
                   NULL sd_pos,
                   cex_integro_info (61100,
                                     5,
                                     0,
                                     cdr.id,
                                     0,
                                     0,
                                     0,
                                     0,
                                     9)
                      descr_ozm,
                   NULL dlina,
                   cdr.shirina,
                   cdr.stan_tolshina,
                   cdr.stan_ves_after quantity,
                   cp.num_plavki n_plavki,
                   ras_nplv (cp.num_plavki, 2) n_mnlz,
                   cdr.num_partii n_partii,
                   NULL nom_oper,
                   NULL n_slitka,
                   NULL n_slyaba,
                   NULL n_krata,
                   NULL n_kolodca,
                   NULL tip_izlognic,
                   NULL id_slitka,
                   NULL id_slyaba,
                   cdr.id id_rulpf,
                   NULL n_rulona,
                   NULL n_pachki,
                   NULL n_lista,
                   TO_CHAR (nvl(cdr.num_rul_do_porezki,cdr.num_rul)) n_rulpf,
                   NULL n_avto,
                   NULL id_krata,
                   NULL id_rulpach,
                   NULL erp_doc,
                   NULL erp_pos,
                   76 id_interface,
                   NULL stat_date,
                   NULL stat_userid,
                   NULL n_motalki,
                   NULL n_pechi,
                   611 stan,
                   4900 werks,
                   '4900_08' cex,
                   'ПФ' vid_oz,
                   'ЦХП' n_cex,
                   97010 kdpr,
                   2 kromka,
                   NULL travl,
                   cdr.id_marki id_marki,
                   NVL (pl.id_ntd, pl.id_gost) id_gostm,
                   NULL id_gostt,
                   NULL id_gosts,
                   NULL num_plavki_kkc,
                   NULL n_konv,
                   NULL n_kovsha,
                   NULL n_mixer,
                   NULL prim,
                   1 type_rec,
                   NULL date_of_postingr,
                   cdr.id klus_id,
                   NULL object_type_id,
                   NULL object_type_r,
                   NULL marka,
                   pl.plavka_id,
                   0 status,
                   NULL brigada_v,
                   NULL brigada_r,
                   line n_line,
                   NULL subject_id_pzr,
                   NULL subject_id_pzd,
                   NULL m_sklad,
                   1 prizn,
                   NULL kds,
                   NULL zagot,
                   NULL vidslyab,
                   NULL obrab,
                   NULL n_korob,
                   ras_nplv (cp.num_plavki, 4) god_plavki,
                   NULL id_krat_lista,
                   NULL n_krat_lista,
                   NULL mesto_hranen_1,
                   NULL mesto_hranen_2,
                   TO_CHAR (num_matkart) n_nakl,
                   (SELECT str_join (id_start)
                      FROM chp_hist
                     WHERE id_start != id_finish AND id_finish = cdr.id)
                      id_svar_ru,
                   NULL shifr_reglam,
                   NULL vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr  
              FROM chp_postup cp
                   LEFT JOIN chp_rul cr
                      ON (cp.id = cr.fk_id_postup)
                   LEFT JOIN chp_dvig_rul cdr
                      ON (cr.id = cdr.fk_id_rul)
         --          LEFT JOIN chp_hist_per_rul ch
           --           ON (cdr.id = ch.id_rul)
                   LEFT JOIN plavka pl
                      ON pl.plavka_id = cp.plavka_id
             WHERE cp.cex_id = 61100
                   --AND NVL (ch.id_naznach_old, 0) IN
                     --     (4, 66, 67, 87, 69, 70, 71, 3)
                   --AND NVL (ch.id_naznach, 0) IN (5)
                   AND NVL (cdr.pr_op, 0) < 7
                   AND TRUNC (cdr.dres_data_enter) = ldate
                   AND cdr.dres_sm = NVL (lsmena, cdr.dres_sm);

           end if;
           -- Поступление рулонов после дрессировки ZPP_CHP_101_DRESER
              if lid_interface=77 then 
         OPEN saprec FOR  
          select
          null id,trunc(cdr.dres_data_enter,'dd') date_of_posting,last_minute_of_smena(cdr.dres_data_enter,dres_sm) date_with_time,dres_sm smena,brig_po_smene(cdr.dres_data_enter,dres_sm) brigada,
                               cex_integro_info(61100,5,0,cdr.id,0,0,0,0,1)  subject_id,
                                null subject_id_add,cex_integro_info(61100,5,0,cdr.id,0,0,0,0,2)  subject_idr,
                                null subject_id_addr,
                                (select object_id from sap_sklad_lpc where r3_number=  '0831') object_id,
                                to_number(cex_integro_info(61100,5,0,cdr.id,0,0,0,0,4))   object_id_add,
                                '0831'  object_idr,
                                cex_integro_info(61100,5,0,cdr.id,0,0,0,0,5)   object_id_addr,
                                8 process_id,960 system_id,1002  measure_unit_id, null account_id,null sd_ord,null sd_pos,
                               cex_integro_info(61100,5,0,cdr.id,0,0,0,0,3)  descr_ozm,
                                null dlina,cdr.shirina,cdr.stan_tolshina,nvl(cdr.dres_ves_after,cdr.stan_ves_after)  quantity,cp.num_plavki n_plavki,ras_nplv(cp.num_plavki,2) n_mnlz,cdr.num_partii n_partii,null nom_oper,null n_slitka,null n_slyaba, null  n_krata,null n_kolodca,null tip_izlognic,null id_slitka,null id_slyaba,cdr.id id_rulpf,null n_rulona,null n_pachki,null n_lista, to_char(cdr.num_rul)  n_rulpf,
                                null n_avto,null id_krata,null id_rulpach,null erp_doc,null erp_pos,77 id_interface,null stat_date,null stat_userid,null n_motalki,null n_pechi,611 stan,4900 werks,'4900_08' cex,'ПФ' vid_oz,'ЦХП' n_cex ,97010 kdpr,2 kromka,null travl,cdr.id_marki id_marki,
                               nvl(pl.id_ntd,pl.id_gost)  id_gostm,null id_gostt,null id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec,null date_of_postingr,cdr.id klus_id ,null object_type_id,null object_type_r,null marka,pl.plavka_id,0 status,null brigada_v,null brigada_r,line n_line,null subject_id_pzr,null subject_id_pzd,null m_sklad,1 prizn,null kds,null zagot,null vidslyab,null obrab,
                                null n_korob,ras_nplv(cp.num_plavki,4) god_plavki,null id_krat_lista,null n_krat_lista,null mesto_hranen_1,null mesto_hranen_2,to_char(num_matkart)  n_nakl,(select str_join( id_start)  from chp_hist where id_start!=id_finish and id_finish=cdr.id) id_svar_ru,null shifr_reglam,null vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr  
          from chp_postup cp
          left join chp_rul cr on (cp.id=cr.fk_id_postup )
          left join chp_dvig_rul cdr on (cr.id=cdr.fk_id_rul )
         left join plavka pl on pl.plavka_id=cp.plavka_id
         where  cp.cex_id=61100 and  NVL (cdr.pr_op, 0) <7  and   trunc(cdr.dres_data_enter)=ldate and dres_sm=nvl(lsmena,dres_sm);
         end if;
          -- Поступление обрези после дрессировки ZPP_CHP_101_DRESER_OTH
            if lid_interface=162 then 
         OPEN saprec FOR  
          select
          null id,trunc(cdr.dres_data_enter,'dd') date_of_posting,last_minute_of_smena(cdr.dres_data_enter,dres_sm) date_with_time,dres_sm smena,brig_po_smene(cdr.dres_data_enter,dres_sm) brigada,
                                   (select ozm_id from mdg where mdg_code='38.11.580000.00088')  subject_id,
                                null subject_id_add,'38.11.580000.00088' subject_idr,
                                null subject_id_addr,
                                (select object_id from sap_sklad_lpc where r3_number=  '0833') object_id,
                                to_number(cex_integro_info(61100,5,0,cdr.id,0,0,0,0,4))  object_id_add,
                                '0833'  object_idr,
                                cex_integro_info(61100,5,0,cdr.id,0,0,0,0,5)   object_id_addr,
                                9 process_id,960 system_id,1002  measure_unit_id, null account_id,null sd_ord,null sd_pos,
                                 (select naim from mdg where mdg_code='38.11.580000.00088') descr_ozm,
                               null dlina,cdr.shirina,cdr.stan_tolshina,abs(nvl(cdr.dres_ves_after,0)-nvl(cdr.dres_ves,0))  quantity,cp.num_plavki n_plavki,ras_nplv(cp.num_plavki,2) n_mnlz,cdr.num_partii n_partii,null nom_oper,null n_slitka,null n_slyaba, null  n_krata,null n_kolodca,null tip_izlognic,null id_slitka,null id_slyaba,cdr.id id_rulpf,null n_rulona,null n_pachki,null n_lista, to_char(cdr.num_rul)  n_rulpf,
                                null n_avto,null id_krata,null id_rulpach,null erp_doc,null erp_pos,162 id_interface,null stat_date,null stat_userid,null n_motalki,null n_pechi,611 stan,4900 werks,'4900_08' cex,'ПФ' vid_oz,'ЦХП' n_cex ,97010 kdpr,2 kromka,null travl,cdr.id_marki id_marki,
                               nvl(pl.id_ntd,pl.id_gost)  id_gostm,null id_gostt,null id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec,null date_of_postingr,cdr.id klus_id ,null object_type_id,null object_type_r,null marka,pl.plavka_id,0 status,null brigada_v,null brigada_r,line n_line,null subject_id_pzr,null subject_id_pzd,null m_sklad,1 prizn,null kds,null zagot,null vidslyab,null obrab,
                                null n_korob,ras_nplv(cp.num_plavki,4) god_plavki,null id_krat_lista,null n_krat_lista,null mesto_hranen_1,null mesto_hranen_2,to_char(num_matkart)  n_nakl,(select str_join( id_start)  from chp_hist where id_start!=id_finish and id_finish=cdr.id) id_svar_ru,null shifr_reglam,null vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr  
          from chp_postup cp
          left join chp_rul cr on (cp.id=cr.fk_id_postup )
          left join chp_dvig_rul cdr on (cr.id=cdr.fk_id_rul )
         left join plavka pl on pl.plavka_id=cp.plavka_id
         where  cp.cex_id=61100 and  NVL (cdr.pr_op, 0) <7  and   trunc(cdr.dres_data_enter)=ldate and dres_sm=nvl(lsmena,dres_sm) and nvl(cdr.dres_ves_after,0)-nvl(cdr.dres_ves,0)!=0;
         end if;
         -- Перемещение рулонов с дрессировки ZPP_CHP_311_DRESER
      if lid_interface=78 then 
         OPEN saprec FOR  
   select
          null id,trunc(cdr.dres_data_enter,'dd') date_of_posting,last_minute_of_smena(cdr.dres_data_enter,dres_sm) date_with_time,dres_sm smena,brig_po_smene(cdr.dres_data_enter,dres_sm) brigada,
                                 cex_integro_info(61100,5,0,cdr.id,0,0,0,0,1)  subject_id,
                                null subject_id_add,cex_integro_info(61100,5,0,cdr.id,0,0,0,0,2)  subject_idr,
                                null subject_id_addr,
                                 (select object_id from sap_sklad_lpc where r3_number= '0834')  object_id,
                                (select object_id from sap_sklad_lpc where r3_number=  '0831')  object_id_add,
                                '0834'  object_idr,
                                '0831' object_id_addr,
                                3 process_id,960 system_id,1002  measure_unit_id, null account_id,null sd_ord,null sd_pos,
                               cex_integro_info(61100,5,0,cdr.id,0,0,0,0,3)   descr_ozm,
                                null dlina,cdr.shirina,cdr.stan_tolshina,nvl(cdr.dres_ves_after,cdr.stan_ves_after)  quantity,cp.num_plavki n_plavki,ras_nplv(cp.num_plavki,2) n_mnlz,cdr.num_partii n_partii,null nom_oper,null n_slitka,null n_slyaba,null  n_krata,null n_kolodca,null tip_izlognic,null id_slitka,null id_slyaba,cdr.id id_rulpf,null n_rulona,null n_pachki,null n_lista, to_char(cdr.num_rul)  n_rulpf,
                                null n_avto,null id_krata,null id_rulpach,null erp_doc,null erp_pos,78 id_interface,null stat_date,null stat_userid,null n_motalki,null n_pechi,611 stan,4900 werks,'4900_08' cex,'ПФ' vid_oz,'ЦХП' n_cex ,97010 kdpr,2 kromka,1  travl,cdr.id_marki id_marki,
                                nvl(pl.id_ntd,pl.id_gost)  id_gostm,null id_gostt,null id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec,null date_of_postingr,cdr.id klus_id ,null object_type_id,null object_type_r,null marka,pl.plavka_id,0 status,null brigada_v,null brigada_r,line n_line,null subject_id_pzr,null subject_id_pzd,null m_sklad,1 prizn,null kds,null zagot,null vidslyab,null obrab,
                                null n_korob,ras_nplv(cp.num_plavki,4) god_plavki,null id_krat_lista,null n_krat_lista,null mesto_hranen_1,null mesto_hranen_2,to_char(num_matkart)  n_nakl,(select str_join(id_start)  from chp_hist where id_start!=id_finish and id_finish=cdr.id) id_svar_ru,null shifr_reglam,null vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr  
           from chp_postup cp
           left join chp_rul cr on (cp.id=cr.fk_id_postup )
           left join chp_dvig_rul cdr on (cr.id=cdr.fk_id_rul )
        --   left join chp_hist_per_rul ch on (cdr.id=ch.id_rul)
           left join plavka pl on pl.plavka_id=cp.plavka_id
          -- where  cp.cex_id=61100 and nvl(ch.id_naznach_old,0) in (5) and nvl(ch.id_naznach,0) in (69,70,71) and nvl(cdr.pr_op,0)=0 and trunc(ch.data_izm)=ldate and ch.smena_izm=nvl(lsmena,ch.smena_izm);
           where  cp.cex_id=61100 and  NVL (cdr.pr_op, 0) <7  and   trunc(cdr.dres_data_enter)=ldate and dres_sm=nvl(lsmena,dres_sm);
           end if;
          -- Перемещение рулонов с отделки на дрессировку ZPP_CHP_311_DRESER_VZ  
              if lid_interface=121 then 
         OPEN saprec FOR  
          select
           null id,trunc(ch.data_izm,'dd') date_of_posting,last_minute_of_smena(ch.data_izm,ch.smena_izm) date_with_time,ch.smena_izm smena,ch.brigada_izm brigada,
                                 cex_integro_info(61100,ch.id_naznach_old,0,cdr.id,0,0,0,0,1)  subject_id,
                                null subject_id_add,cex_integro_info(61100,ch.id_naznach_old,0,cdr.id,0,0,0,0,2)  subject_idr,
                                null subject_id_addr,
                                 (select object_id from sap_sklad_lpc where r3_number= '0831')  object_id,
                                (select object_id from sap_sklad_lpc where r3_number=  '0834')  object_id_add,
                                '0831'  object_idr,
                                '0834' object_id_addr,
                                3 process_id,976 system_id,1002  measure_unit_id, null account_id,null sd_ord,null sd_pos,
                                cex_integro_info(61100,ch.id_naznach_old,0,cdr.id,0,0,0,0,3)  descr_ozm,
                                null dlina,cdr.shirina,cdr.stan_tolshina,cdr.stan_ves_after  quantity,cp.num_plavki n_plavki,ras_nplv(cp.num_plavki,2) n_mnlz,cdr.num_partii n_partii,null nom_oper,null n_slitka,null n_slyaba,null  n_krata,null n_kolodca,null tip_izlognic,null id_slitka,null id_slyaba,cdr.id id_rulpf,null n_rulona,null n_pachki,null n_lista, to_char(cdr.num_rul)  n_rulpf,
                                null n_avto,null id_krata,null id_rulpach,null erp_doc,null erp_pos,121 id_interface,null stat_date,null stat_userid,null n_motalki,null n_pechi,611 stan,4900 werks,'4900_08' cex,'ПФ' vid_oz,'ЦХП' n_cex ,97010 kdpr,2 kromka,1  travl,cdr.id_marki id_marki,
                              nvl(pl.id_ntd,pl.id_gost) id_gostm,null id_gostt,null id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec,null date_of_postingr,cdr.id klus_id ,null object_type_id,null object_type_r,null marka,pl.plavka_id,0 status,null brigada_v,null brigada_r,null n_line,null subject_id_pzr,null subject_id_pzd,null m_sklad,1 prizn,null kds,null zagot,null vidslyab,null obrab,
                                null n_korob,ras_nplv(cp.num_plavki,4) god_plavki,null id_krat_lista,null n_krat_lista,null mesto_hranen_1,null mesto_hranen_2,to_char(num_matkart)  n_nakl,(select str_join( id_start)  from chp_hist where id_start!=id_finish and id_finish=cdr.id) id_svar_ru,null shifr_reglam,null vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr  
           from chp_postup cp
           left join chp_rul cr on (cp.id=cr.fk_id_postup )
           left join chp_dvig_rul cdr on (cr.id=cdr.fk_id_rul )
           left join chp_hist_per_rul ch on (cdr.id=ch.id_rul)
           left join plavka pl on pl.plavka_id=cp.plavka_id
           where  cp.cex_id=61100 and nvl(ch.id_naznach_old,0) in (69,70,71) and nvl(ch.id_naznach,0) in (5) and nvl(cdr.pr_op,0)=0 and trunc(ch.data_izm)=ldate and ch.smena_izm=nvl(lsmena,ch.smena_izm);
           end if;
           -- Списание рулонов и листов на отделку ZPP_CHP_261_OTDEL ???
             if lid_interface=79 then 
         OPEN saprec FOR  
          select
          null id,trunc(cpr.data_porezki,'dd') date_of_posting,last_minute_of_smena(cpr.data_porezki,cpr.smena_porezki) date_with_time,cpr.smena_porezki smena,cpr.brigada_porezki brigada,
                                  cex_integro_info(61100,cdr.fk_id_naznach,0,cdr.id,0,0,0,0,7)  subject_id,
                                null subject_id_add,cex_integro_info(61100,cdr.fk_id_naznach,0,cdr.id,0,0,0,0,8)  subject_idr,
                                null subject_id_addr,
                               to_number(cex_integro_info(61100,cdr.fk_id_naznach,0,cdr.id,0,0,0,0,4))  object_id,
                                case when cdr.shirina<1000 then  (select object_id from sap_sklad_lpc where r3_number=  '0835') else  (select object_id from sap_sklad_lpc where r3_number=  '0834')  end  object_id_add,
                               cex_integro_info(61100,cdr.fk_id_naznach,0,cdr.id,0,0,0,0,5)  object_idr,
                                 case when cdr.shirina<1000 then '0835' else '0834' end object_id_addr,
                                2 process_id,977 system_id,1002  measure_unit_id, null account_id,null sd_ord,null sd_pos,
                                 cex_integro_info(61100,cdr.fk_id_naznach,0,cdr.id,0,0,0,0,9)  descr_ozm,
                                cdr.dlina,cdr.shirina,cdr.stan_tolshina,
                                nvl(cdr.dres_ves_after,cdr.stan_ves_after) -round((select nvl(sum(ves/1000),0) from chp_porezka where fk_id_dvig_rul=cdr.id and nvl(pr_ostatok,0)=1),3)   quantity,
                                cp.num_plavki n_plavki,ras_nplv(cp.num_plavki,2) n_mnlz,cdr.num_partii n_partii,null nom_oper,null n_slitka,null n_slyaba, null  n_krata,null n_kolodca,null tip_izlognic,null id_slitka,null id_slyaba,cdr.id id_rulpf,null n_rulona,null n_pachki,null n_lista, to_char(cdr.num_rul)  n_rulpf,
                                null n_avto,null id_krata,null id_rulpach,null erp_doc,null erp_pos,79 id_interface,null stat_date,null stat_userid,null n_motalki,null n_pechi,611 stan,4900 werks,'4900_08' cex,'ПФ' vid_oz,'ЦХП' n_cex ,case when nvl(cdr.dlina,0)=0 then 97010 else 97000 end kdpr ,2 kromka,null travl,cdr.id_marki id_marki,
                               nvl(pl.id_ntd,pl.id_gost)  id_gostm,null id_gostt,null id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec,null date_of_postingr,cdr.id klus_id ,null object_type_id,null object_type_r,null marka,pl.plavka_id,0 status,null brigada_v,null brigada_r,line n_line,null subject_id_pzr,null subject_id_pzd,null m_sklad,1 prizn,null kds,null zagot,null vidslyab,null obrab,
                                null n_korob,ras_nplv(cp.num_plavki,4) god_plavki,null id_krat_lista,null n_krat_lista,null mesto_hranen_1,null mesto_hranen_2,to_char(num_matkart)  n_nakl,(select str_join(id_start)  from chp_hist where id_start!=id_finish and id_finish=cdr.id) id_svar_ru,null shifr_reglam,null vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr  
          from (select min(data_porezki) data_porezki,min(brigada_porezki) brigada_porezki,min(smena_porezki) smena_porezki,fk_id_dvig_rul,min(id) id  from chp_porezka where data_porezki=ldate and smena_porezki=nvl(lsmena,smena_porezki)   and nvl(pr_op,0)<4 and   id_agregata in(69,70,71)  and nvl(pr_nal,0)<4 and nvl(pr_s_br_rul,0)=0 and nvl(pr_s_rs,0)=0 and nvl(ves_1karm, nvl(ves_ne_att,ves))>1 group by fk_id_dvig_rul) cpr  
          join chp_dvig_rul cdr on cpr.fk_id_dvig_rul =cdr.id
          join chp_rul cr on (cr.id=cdr.fk_id_rul )
          join chp_postup cp on (cp.id=cr.fk_id_postup )
          left join plavka pl on pl.plavka_id=cp.plavka_id
          where  cp.cex_id=61100 ;
           
      end if;
           --Поступление рулонов и листов после отделки  ZPP_CHP_101_OTDEL
   if lid_interface=80 then 
         OPEN saprec FOR  
         select
          null id,trunc(cpr.data_porezki,'dd') date_of_posting,last_minute_of_smena(cpr.data_porezki,cpr.smena_porezki) date_with_time,cpr.smena_porezki smena,cpr.brigada_porezki brigada,
                                cex_integro_info(61100,cdr.fk_id_naznach,0,cdr.id,0,0,0,0,1)  subject_id,
                                null subject_id_add,cex_integro_info(61100,cdr.fk_id_naznach,0,cdr.id,0,0,0,0,2) subject_idr,
                                null subject_id_addr,
                                 (select object_id from sap_sklad_lpc where r3_number=  '0835') object_id,
                                to_number(cex_integro_info(61100,cdr.fk_id_naznach,0,cdr.id,0,0,0,0,4)) object_id_add,
                                 '0835'  object_idr,
                               cex_integro_info(61100,cdr.fk_id_naznach,0,cdr.id,0,0,0,0,5)  object_id_addr,
                                8 process_id,978 system_id,1002  measure_unit_id, null account_id,null sd_ord,null sd_pos,
                                cex_integro_info(61100,cdr.fk_id_naznach,0,cdr.id,0,0,0,0,3) descr_ozm,
                                cpr.dlina,cpr.shirina,cpr.tolshina,round(nvl(cpr.ves_1karm, nvl(cpr.ves_ne_att,cpr.ves))/1000 ,3)  quantity,cp.num_plavki n_plavki,ras_nplv(cp.num_plavki,2) n_mnlz,cpr.num_partii n_partii,null nom_oper,null n_slitka,null n_slyaba, null  n_krata,null n_kolodca,null tip_izlognic,null id_slitka,null id_slyaba,cdr.id id_rulpf,
                                 case when nvl(cpr.dlina,0)=0 then case when line_no is not null then line_no||'-'||cpr.num_rul_pach else  to_char(cpr.num_rul_pach) end else null end n_rulona,
                                case when nvl(cpr.dlina,0)!=0 then case when line_no is not null then line_no||'-'||cpr.num_rul_pach else to_char(cpr.num_rul_pach) end else null end n_pachki,
                                null n_lista, 
                                to_char(cdr.num_rul)  n_rulpf,
                                null n_avto,null id_krata,cpr.id id_rulpach,null erp_doc,null erp_pos,80 id_interface,null stat_date,null stat_userid,null n_motalki,null n_pechi,611 stan,4900 werks,'4900_08' cex,'ПФ' vid_oz,'ЦХП' n_cex ,case when nvl(cpr.dlina,0)=0 then 97010 else 97000 end kdpr ,decode(cpr.kromka,'НО',2,'О',1,0) kromka,null travl,cdr.id_marki id_marki,
                               nvl(pl.id_ntd,pl.id_gost)  id_gostm,null id_gostt,null id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec,null date_of_postingr,cpr.id klus_id ,null object_type_id,null object_type_r,null marka,pl.plavka_id,0 status,null brigada_v,null brigada_r,line_no  n_line,null subject_id_pzr,null subject_id_pzd,null m_sklad,1 prizn,null kds,null zagot,null vidslyab,null obrab,
                                null n_korob,ras_nplv(cp.num_plavki,4) god_plavki,null id_krat_lista,null n_krat_lista,null mesto_hranen_1,null mesto_hranen_2,to_char(num_matkart)  n_nakl,(select str_join(id_start)  from chp_hist where id_start!=id_finish and id_finish=cdr.id) id_svar_ru,null shifr_reglam,cpr.kromka vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr  
          from chp_porezka cpr  
          left join chp_dvig_rul cdr on cpr.fk_id_dvig_rul =cdr.id
          left join chp_rul cr on (cr.id=cdr.fk_id_rul )
          left join chp_postup cp on (cp.id=cr.fk_id_postup )
          left join plavka pl on pl.plavka_id=cp.plavka_id
          where  cp.cex_id=61100 and  cpr.data_porezki=ldate and cpr.smena_porezki=nvl(lsmena,cpr.smena_porezki) and nvl(cpr.pr_op,0)<=3  and  cpr.id_agregata in(69,70,71) and nvl(cpr.pr_ostatok,0)=0 and nvl(cpr.pr_nal,0)<=3  and nvl(cpr.pr_s_br_rul,0)=0 and nvl(cpr.pr_s_rs,0)=0 and nvl(cpr.ves_1karm, nvl(cpr.ves_ne_att,cpr.ves))>1;
   end if;
           --Списание полосы на порезку ZPP_CHP_261_POREZ ZPP_CHP_101_POREZ ???
      if lid_interface=81 then 
         OPEN saprec FOR  
           select 
           null id,trunc(cpr.data_porezki,'dd') date_of_posting,last_minute_of_smena(cpr.data_porezki,cpr.smena_porezki) date_with_time,cpr.smena_porezki smena,cpr.brigada_porezki brigada,
                                cex_integro_info(61100,cdr.fk_id_naznach,0,cdr.id,0,0,0,0,7)  subject_id,
                                null subject_id_add, cex_integro_info(61100,cdr.fk_id_naznach,0,cdr.id,0,0,0,0,8) subject_idr,
                                null subject_id_addr,
                                to_number(cex_integro_info(61100,cdr.fk_id_naznach,0,cdr.id,0,0,0,0,4)) object_id,
                              (select object_id from sap_sklad_lpc where r3_number= '0835') object_id_add,
                              cex_integro_info(61100,cdr.fk_id_naznach,0,cdr.id,0,0,0,0,5)  object_idr,
                                '0835'   object_id_addr,
                                2 process_id,963 system_id,1002  measure_unit_id, null account_id,null sd_ord,null sd_pos,
                              cex_integro_info(61100,cdr.fk_id_naznach,0,cdr.id,0,0,0,0,9)  descr_ozm,
                                cdr.dlina,cdr.shirina,cdr.stan_tolshina,
                                nvl(cdr.dres_ves_after,cdr.stan_ves_after)-round((select nvl(sum(ves/1000),0) from chp_porezka where fk_id_dvig_rul=cdr.id and nvl(pr_ostatok,0)=1),3)     quantity,cp.num_plavki n_plavki,pl.mnlz n_mnlz,cdr.num_partii n_partii,null nom_oper,null n_slitka,null n_slyaba,null  n_krata,null n_kolodca,null tip_izlognic,null id_slitka,null id_slyaba,cdr.id id_rulpf,null n_rulona,null n_pachki,null n_lista, to_char(cdr.num_rul)  n_rulpf,
                                null n_avto,null id_krata,null id_rulpach,null erp_doc,null erp_pos,81 id_interface,null stat_date,null stat_userid,null n_motalki,null n_pechi,611 stan,4900 werks,'4900_08' cex,'ПФ' vid_oz,'ЦХП' n_cex ,97010 kdpr,2 kromka,null  travl,cdr.id_marki id_marki,
                               nvl(pl.id_ntd,pl.id_gost)  id_gostm,null id_gostt,null id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec,null date_of_postingr,cdr.id klus_id ,null object_type_id,null object_type_r,null marka,pl.plavka_id,0 status,null brigada_v,null brigada_r,line  n_line,null subject_id_pzr,null subject_id_pzd,null m_sklad,1 prizn,null kds,null zagot,null vidslyab,null obrab,
                                null n_korob,ras_nplv(cp.num_plavki,4) god_plavki,null id_krat_lista,null n_krat_lista,null mesto_hranen_1,null mesto_hranen_2,to_char(num_matkart)  n_nakl,(select str_join( id_start)  from chp_hist where id_start!=id_finish and id_finish=cdr.id) id_svar_ru,null shifr_reglam,null vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr  
          from (select min(data_porezki) data_porezki,min(brigada_porezki) brigada_porezki,min(smena_porezki) smena_porezki,fk_id_dvig_rul,min(id) id  from chp_porezka where  data_porezki=ldate and smena_porezki=nvl(lsmena,smena_porezki)   and nvl(pr_op,0)<4 and nvl(pr_nal,0)<4  and   id_agregata in (82) and nvl(pr_s_br_rul,0)=0 and nvl(pr_s_rs,0)=0 and ves>1 group by fk_id_dvig_rul) cpr  
          join chp_dvig_rul cdr on cpr.fk_id_dvig_rul =cdr.id
          join chp_rul cr on (cr.id=cdr.fk_id_rul )
          join chp_postup cp on (cp.id=cr.fk_id_postup )
          left join plavka pl on pl.plavka_id=cp.plavka_id
        where cp.cex_id=61100 ;
end if;
           --Поступление ленты с порезки ZPP_CHP_101_POREZ
    if lid_interface=82 then 
         OPEN saprec FOR  
         select
         
          null id,trunc(cpr.data_porezki,'dd') date_of_posting,last_minute_of_smena(cpr.data_porezki,cpr.smena_porezki) date_with_time,cpr.smena_porezki smena,cpr.brigada_porezki brigada,
                                cex_integro_info(61100,cdr.fk_id_naznach,0,cdr.id,0,0,0,0,1)  subject_id,
                                null subject_id_add,
                               cex_integro_info(61100,cdr.fk_id_naznach,0,cdr.id,0,0,0,0,2) subject_idr,
                                null subject_id_addr,
                                (select object_id from sap_sklad_lpc where r3_number=  '0835') object_id,
                                to_number(cex_integro_info(61100,cdr.fk_id_naznach,0,cdr.id,0,0,0,0,4))  object_id_add,
                                '0835'  object_idr,
                             cex_integro_info(61100,cdr.fk_id_naznach,0,cdr.id,0,0,0,0,5)  object_id_addr,
                                8 process_id,964 system_id,1002  measure_unit_id, null account_id,null sd_ord,null sd_pos,
                               cex_integro_info(61100,cdr.fk_id_naznach,0,cdr.id,0,0,0,0,3)   descr_ozm,
                                cpr.dlina,cpr.shirina,cpr.tolshina,round(cpr.ves/1000,3)  quantity,cp.num_plavki n_plavki,ras_nplv(cp.num_plavki,2) n_mnlz,cpr.num_partii n_partii,null nom_oper,null n_slitka,null n_slyaba, null  n_krata,null n_kolodca,null tip_izlognic,null id_slitka,null id_slyaba,cdr.id id_rulpf,case when nvl(cpr.dlina,0)=0 then cpr.num_rul_pach else null end n_rulona,case when nvl(cpr.dlina,0)!=0 then cpr.num_rul_pach else null end n_pachki,null n_lista, to_char(cdr.num_rul)  n_rulpf,
                                null n_avto,null id_krata,cpr.id id_rulpach,null erp_doc,null erp_pos,82 id_interface,null stat_date,null stat_userid,null n_motalki,null n_pechi,611 stan,4900 werks,'4900_08' cex,'ПФ' vid_oz,'ЦХП' n_cex ,97010 kdpr,decode(cpr.kromka,'НО',2,'О',1,0) kromka,null travl,cdr.id_marki id_marki,
                               nvl(pl.id_ntd,pl.id_gost)  id_gostm,null id_gostt,null id_gosts,null num_plavki_kkc,null n_konv,null n_kovsha,null n_mixer,null prim,1 type_rec,null date_of_postingr,cpr.id klus_id ,null object_type_id,null object_type_r,null marka,pl.plavka_id,0 status,null brigada_v,null brigada_r,line_no  n_line,null subject_id_pzr,null subject_id_pzd,null m_sklad,1 prizn,null kds,null zagot,null vidslyab,null obrab,
                                cpr.num_met  n_korob,ras_nplv(cp.num_plavki,4) god_plavki,null id_krat_lista,null n_krat_lista,null mesto_hranen_1,null mesto_hranen_2,to_char(num_matkart)  n_nakl,(select str_join( id_start)  from chp_hist where id_start!=id_finish and id_finish=cdr.id) id_svar_ru,null shifr_reglam,cpr.kromka vid_kromki,null n_lot,null n_zak_isp,null n_stec,null stat_mii,null n_str_prokat,null vid_nagr  
          from chp_porezka cpr  
          left join chp_dvig_rul cdr on cpr.fk_id_dvig_rul =cdr.id
          left join chp_rul cr on (cr.id=cdr.fk_id_rul )
          left join chp_postup cp on (cp.id=cr.fk_id_postup )
          left join plavka pl on pl.plavka_id=cp.plavka_id
          where  cp.cex_id=61100 and  cpr.data_porezki=ldate and cpr.smena_porezki=nvl(lsmena,cpr.smena_porezki) and nvl(cpr.pr_op,0)<=3 and cpr.id_agregata in (82) and nvl(cpr.pr_ostatok,0)=0 and nvl(cpr.pr_s_br_rul,0)=0 and nvl(cpr.pr_s_rs,0)=0 and cpr.ves>1;
    end if;
       
       
        
         
   -- формирование строк для sap_integro_lpc
   IF not saprec%ISOPEN THEN
     null;
   else
      LOOP
        FETCH saprec INTO l_out;         
        EXIT WHEN saprec%NOTFOUND;
        
        -- определение ОЗМ
        if l_out.subject_idr is null then
           p_snp:= sap_snp_ozm(l_out.kdpr,l_out.prizn,l_out.id_marki,l_out.id_gostm,l_out.id_gostt,l_out.id_gosts,l_out.tolshina,l_out.shirina,l_out.tip_izlognic,l_out.travl,l_out.kromka,l_out.zagot,l_out.vidslyab,l_out.obrab);
           begin
              select  max(s.mdg_code),max(m.naim_kr),max(m.ozm_id)   into    l_out.subject_idr,l_out.descr_ozm,l_out.subject_id
              from spr_gp_mdg s,mdg m 
              where unik=p_snp and s.mdg_code=m.mdg_code and s.status=0;
            exception
              when no_data_found then  l_out.subject_idr:=null; l_out.descr_ozm:=null; l_out.subject_id:=0;
              when others then  l_out.subject_idr:=null; l_out.descr_ozm:=null; l_out.subject_id:=0;          
          End;
        end if;
                  
          if  l_out.id_interface =2  then
          if l_out.subject_idr is null then
          
           p_snp:= sap_snp_ozm2(l_out.kdpr,l_out.prizn,l_out.id_marki,l_out.id_gostm,l_out.id_gostt,l_out.id_gosts,l_out.tolshina,l_out.shirina,l_out.tip_izlognic,l_out.travl,l_out.kromka,l_out.zagot,l_out.vidslyab,l_out.obrab);
              select  max(s.mdg_code),max(m.naim_kr),max(m.ozm_id)   into    l_out.subject_idr,l_out.descr_ozm,l_out.subject_id
              from spr_gp_mdg s,mdg m 
              where unik=p_snp and s.mdg_code=m.mdg_code and s.status=0;
           end if;
          
          if l_out.subject_idr is not null   and l_out.process_id=8 then
           select  max(sz.object_id),max(sz.erp_number)  into    l_out.object_id_add,l_out.object_id_addr from sap_pr_zakaz sz
           where sz.object_type_id=20244  and l_out.date_of_posting>=date_start and l_out.date_of_posting<=date_end and sz.ozm=l_out.subject_idr;
          end if;
        
        end if;
           
            l_out.subject_id_add:=l_out.subject_id;
            l_out.subject_id_addr:=l_out.subject_idr;
            
            l_out.n_plavki_kkc:=ras_nplv(l_out.n_plavki,1);
            
            if nvl(l_out.object_id,0)=0 or nvl(l_out.object_id_add,0)=0 or nvl(l_out.subject_id,0)=0 or nvl(l_out.quantity,0)=0 or l_out.descr_ozm is null or  lid_interface in(35,36,101,141,37)  and l_out.n_partii is null    then
               l_out.status:=99;
               l_out.prim:='Ошибка в данных: нет обязательных данных (по складу,ОЗМ ,ПЗ заказу,тоннажу,партии)';
            else
               l_out.status:=0;
            end if;
            
            
         --    if lid_interface in(35,36,101,141)  and l_out.n_partii is null then
         --      l_out.status:=99;
         --      l_out.prim:='Ошибка в данных: нет обязательных данных (по складу,ОЗМ ,ПЗ заказу,тоннажу,партии)';
          -- end if; 
           
         k_date:=0;
          if l_out.id_interface in(5,11,14,62,65,67,71,74,77,80,82,161,162,31,35,37,16) then
              select max(ord_num),max(ord_poz),max(to_number(to_char(date_start,'yyyymm'))),max(nsnz),max(zak_numlot(nsnz,dpid,gdis,npoz)),max(zak_numspec(nsnz,dpid,gdis))  into l_out.sd_ord,l_out.sd_pos,k_date,l_out.n_zak_isp,l_out.n_lot,l_out.n_stec from sap_pr_zakaz where object_id=l_out.object_id_add;
              if to_number(to_char(l_out.date_of_posting,'yyyymm'))!=k_date then
               l_out.status:=99;
               l_out.prim:=l_out.prim||' Период действия заказа не соответствует периоду операции';
              end if;
          end if;
          if l_out.id_interface in(15,4,10,13,30,34,141,61,64,66,70,73,76,79,81) then
              select max(ord_num),max(ord_poz),max(to_number(to_char(date_start,'yyyymm'))),max(nsnz),max(zak_numlot(nsnz,dpid,gdis,npoz)),max(zak_numspec(nsnz,dpid,gdis))   into l_out.sd_ord,l_out.sd_pos,k_date,l_out.n_zak_isp,l_out.n_lot,l_out.n_stec from sap_pr_zakaz where object_id=l_out.object_id;
                if to_number(to_char(l_out.date_of_posting,'yyyymm'))!=k_date then
               l_out.status:=99;
               l_out.prim:=l_out.prim||' Период действия заказа не соответствует периоду операции';
              end if;
          end if;
          
           pipe row(l_out);
         
           
           if lid_interface in(14,5,11,31,35,44,62,65,67,71,74,77,80,82,37,16)  or  lid_interface =2 and l_out.process_id=8  then
            l_out.process_id:=6;
            if l_out.id_interface=44 then 
            if  l_out.object_type_id=20206 then
            l_out.nom_oper:='1300';
            else 
            if l_out.kdpr=89200 then
            l_out.nom_oper:='1350';
            else
             l_out.nom_oper:='1360';
            end if;
            end if;
            else
             if l_out.id_interface in(31,16)
             then
               l_out.nom_oper:='1420';
               elsif l_out.id_interface=62  then
               if l_out.n_line=1 then
                l_out.nom_oper:='1480';
                l_out.kds:=0;
                else
                l_out.nom_oper:='1485';
                 l_out.kds:=4;
                end if;
                elsif l_out.id_interface in(65,14,80,82,37)  then
                l_out.nom_oper:='1520';
                 elsif l_out.id_interface=67 then
                l_out.nom_oper:='1450';
                 elsif l_out.id_interface=71  then
                l_out.nom_oper:='1580';
                 elsif l_out.id_interface=74  then
                 if l_out.n_line=1 then
                l_out.nom_oper:='1490';
                 l_out.kds:=0;
                else
                 l_out.nom_oper:='1490';
                 l_out.kds:=4;
                  end if;
                 elsif l_out.id_interface=77  then
                l_out.nom_oper:='1590';
               elsif l_out.id_interface=2  then
                l_out.nom_oper:='1390';
             else
              l_out.nom_oper:='1450';
              end if;
            end if;
          
            l_out.type_rec:=2;
            l_out.object_id:=l_out.object_id_add;
            l_out.object_idr:=l_out.object_id_addr;
            l_out.object_id_add:=-1;
            l_out.object_id_addr:='-1';
            pipe row(l_out);
            
               if l_out.id_interface in(5,11)  then 
                  l_out.nom_oper:='1440';
                  pipe row(l_out);
           end if;
            
           end if;   
        
      END LOOP;
      CLOSE saprec;
 end if; 
  end  form_sap_object;
  
  
   function form_sap_object_period(ldate_s in date, ldate_po in date, lid_interface in number,lagregat in number default 0)  return saprec_set pipelined
  is
  TYPE sapcur IS REF CURSOR  RETURN  sap_integro_lpc%ROWTYPE;
  saprec  sapcur;
  l_out  sap_integro_lpc%rowtype;
  begin
  
    if ldate_po - ldate_s between 0 and 31 then
  
        for i in 1..ldate_po-ldate_s +1
        loop
             OPEN saprec FOR     select * from table(SAP_INTEGRO.form_sap_object(ldate_s+i-1, null, lid_interface, nvl(lagregat,0)) ) ;
             loop
                 FETCH saprec INTO l_out;         
                 EXIT WHEN saprec%NOTFOUND;
                 pipe row(l_out);
             end loop;
            CLOSE saprec;
        end loop;
    
    end if;
  end  form_sap_object_period;
  
  
 end sap_integro;
/