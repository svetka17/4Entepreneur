CREATE OR REPLACE PACKAGE BODY ASUPPP.agregat AS

  FUNCTION pipe_a1 (zgod number,zmes number,zsklad number) RETURN a1 PIPELINED
   is
  begin
      for s in (
                   select d, kon,son,kp,sp,kr,sr, --kok,sok,
            SUM(kon+kp-kr) OVER ( ORDER BY 1 ROWS UNBOUNDED PRECEDING ) k, 
            SUM(son+sp-sr) OVER ( ORDER BY 1 ROWS UNBOUNDED PRECEDING ) s
             from 
            (
            select d, nvl(kon,0) kon, nvl(son,0) son, nvl(kp,0) kp, nvl(sp,0) sp, nvl(kr,0) kr, nvl(sr,0) sr /*, nvl(kon,0)+nvl(kp,0)-nvl(kr,0) kok, nvl(son,0)+nvl(sp,0)-nvl(sr,0) sok*/  from
            (SELECT to_date(nvl(zgod,0)*100+nvl(zmes,0),'yyyymm')-1 + level d --to_date('31.10.2014','dd.mm.yyyy')+LEVEL d
              FROM  dual 
            CONNECT BY LEVEL<abs(to_date(nvl(zgod,0)*100+nvl(zmes,0),'yyyymm')-1 - add_months(to_date(nvl(zgod,0)*100+nvl(zmes,0),'yyyymm'),1) )
            --add_months(to_date(nvl(zgod,0)*100+nvl(zmes,0),'yyyymm'),1) --to_date('01.12.2014','dd.mm.yyyy')
            ---to_date(nvl(zgod,0)*100+nvl(zmes,0),'yyyymm')-1 --to_date('31.10.2014','dd.mm.yyyy')
            ) a1,
            (select p.datd datdr, sum(p.kol) kr, sum(p.kol*p.price) sr from rasxod p where p.sklad=nvl(zsklad,0) and p.god=nvl(zgod,0) and p.mes=nvl(zmes,0) and p.kol is not null group by p.datd ) a2,
            (select pr.datd datdp, sum(p.kol) kp, sum(p.kol*p.price) sp from p_pri p, priord pr where pr.uniko(+)=p.uniko and p.sklad=nvl(zsklad,0) and p.god=nvl(zgod,0) and p.mes=nvl(zmes,0) and p.kol is not null group by pr.datd ) a3,
            (select to_number(to_char(to_date(nvl(zgod,0)*100+nvl(zmes,0),'yyyymm')-1,'yyyymmdd')) datdo,
            sum(tmc_ost_godmes_day(
             sklad, nnom,izgot, kod_grp, kod_pgr, kod_nn, price, ed, sh_zatr, kod_krid, invn, claim_uniko, to_number(to_char(to_date(nvl(zgod,0)*100+nvl(zmes,0),'yyyymm')-1,'yyyymmdd')), unik_chet, kol_smenka, uchenka, dkg, kolu,rezdok,zavod_n
            ) ) kon,
            sum(tmc_ostsum_godmes_day(
             sklad, nnom,izgot, kod_grp, kod_pgr, kod_nn, price, ed, sh_zatr, kod_krid, invn, claim_uniko, to_number(to_char(to_date(nvl(zgod,0)*100+nvl(zmes,0),'yyyymm')-1,'yyyymmdd')), unik_chet, kol_smenka, uchenka, dkg, kolu,rezdok,zavod_n
            ) ) son from ostat where sklad=nvl(zsklad,0)
            ) a4
            where to_date(a2.datdr(+),'yyyymmdd')=a1.d
            and to_date(a3.datdp(+),'yyyymmdd')=a1.d
            and to_date(a4.datdo(+),'yyyymmdd')=a1.d-1
            order by a1.d
            )
      ) loop
        pipe row ( type1(s.d,s.kon,s.son,s.kp,s.sp,s.kr,s.sr,s.k,s.s) );
      end loop;
    return;
  end;

FUNCTION pipe_a2 RETURN a2 PIPELINED
   is
  begin
      for s in (
                   select tmc , substr(trim(mdg),1,100) mdg, substr(trim(naim),1,1000) naim , substr(trim(naim_old),1,1000) naim_old, substr(trim(e),1,50) e, substr(trim(spr),1,100) spr , substr(trim(text_status),1,100) text_status, prigm , priprice , priprice_koe,ostgm ,ostprice ,ostprice_koe ,plangm ,planprice,planprice_koe
                   , notd, isp, substr(decode(isp,0,'',text_otvet(notd,isp)),1,300) tisp --,statnd_price
 from (

select s.unik tmc, s.mdg mdg, s.naim naim, s.naim_old naim_old, s.e e, s.spr spr, s.text_status text_status, pri.gm prigm, 
pri.pric_d priprice, s.notd notd, s.isp isp,

    case when pri.gm<200701 then
        pri.pric_d*3
      when pri.gm>=200701 and pri.gm<=200912
      then
         pri.pric_d*2
      when pri.gm>=201001 and pri.gm<=201212
      then
         pri.pric_d*1.5
         when pri.gm>=201301 and pri.gm<=201312  
      then
         pri.pric_d*1.25
      else
     pri.pric_d
    end priprice_koe,
ost.gm ostgm, 
ost.pric_d ostprice,
case when ost.gm<200701 then
    ost.pric_d*3
  when ost.gm>=200701 and ost.gm<=200912 
  then
     ost.pric_d*2
  when ost.gm>=201001 and ost.gm<=201212 
  then
     ost.pric_d*1.5
     when ost.gm>=201301 and ost.gm<=201312 
  then
     ost.pric_d*1.25
  else
 ost.pric_d
end ostprice_koe,

plan.gm plangm, 
plan.pric_d planprice,
case when plan.gm<200701 then
    plan.pric_d*3
  when plan.gm>=200701 and plan.gm<=200912
  then
     plan.pric_d*2
  when plan.gm>=201001 and plan.gm<=201212 
  then
     plan.pric_d*1.5
     when plan.gm>=201301 and plan.gm<=201312
  then
     plan.pric_d*1.25
  else
 plan.pric_d
end planprice_koe,  
/*
round(nvl(
    case when pri.gm<200701 then
        pri.pric_d*3
      when pri.gm>=200701 and pri.gm<=200912 
      then
         pri.pric_d*2
      when pri.gm>=201001 and pri.gm<=201212 
      then
         pri.pric_d*1.5
         when pri.gm>=201301 and pri.gm<=201312
      then
         pri.pric_d*1.25
      else
     pri.pric_d
    end,
    
    case when ost.gm<200701 then
    ost.pric_d*3
      when ost.gm>=200701 and ost.gm<=200912 
      then
         ost.pric_d*2
      when ost.gm>=201001 and ost.gm<=201212
      then
         ost.pric_d*1.5
         when ost.gm>=201301 and ost.gm<=201312
      then
         ost.pric_d*1.25
      else
     ost.pric_d
    end),2) statnd_price,*/  
    ROW_NUMBER() OVER
                    (partition by s.mdg ORDER BY 
                    nvl(
    case when pri.gm<200701 then
        pri.pric_d*3
      when pri.gm>=200701 and pri.gm<=200912 
      then
         pri.pric_d*2
      when pri.gm>=201001 and pri.gm<=201212
      then
         pri.pric_d*1.5
         when pri.gm>=201301 and pri.gm<=201312
      then
         pri.pric_d*1.25
      else
     pri.pric_d
    end,
    
    case when ost.gm<200701 then
    ost.pric_d*3
      when ost.gm>=200701 and ost.gm<=200912
      then
         ost.pric_d*2
      when ost.gm>=201001 and ost.gm<=201212
      then
         ost.pric_d*1.5
         when ost.gm>=201301 and ost.gm<=201312
      then
         ost.pric_d*1.25
      else
     ost.pric_d
    end)
                     desc) num1

   from 
        (
        select unik,notd,isp, mdg, naim, naim_old, text_ed(ed) e, status, TEXT_tmc_status(unik) text_status, 'покупное' spr  from spr_tmc where /*nvl(status,0)<>1 and */ mdg is not null
        union all
        select unik_tmc,zex notd, 0 isp, mdg, naim, naim_old, text_ed(ed), status, status_spr_hs(status) text_status, 'х/с' spr from spr_hs where mdg is not null and unik = SUBSTR (unik_tmc, 2) AND status >= 0
        --select unik, mdg, naim, naim_old, text_ed(ed) e from spr_tmc_all where mdg is not null
        ) s,

        (select tmc, gm, pric_d from (
        select tmc,  god*100+mes gm, pric_d, ROW_NUMBER() OVER
                    (partition by tmc ORDER BY god*100+mes desc, pric_d desc) num
        from p_pri where god<=extract(year from sysdate) and nvl(tmc,0)<>0 and sklad not in (0,84100) and nvl(izgot,0)<>7 and nvl(kol,0)>0 and ( nvl(unik_psop,0)<>0 or substr(sklad,1,3)=substr(nvl(izgot,0),1,3) )
        ) where num=1 ) pri,

        (select tmc, gm,   pric_d from 
        (select  tmc,  god*100+mes gm, nvl(sumak,0)/nvl(kolk,0) pric_d, ROW_NUMBER() OVER
                    (partition by tmc ORDER BY god*100+mes desc, nvl(sumak,0)/nvl(kolk,0) desc) num from tmc_ost_obor where god*100+mes<=extract(year from sysdate)*100+extract(month from sysdate) and
        (nvl(sumak,0)/nvl(kolk,0))>0 and nvl(kolk,0)>0 and nvl(tmc,0)<>0 --and tmc_zex_comp(zex)+is_sklad_cpp(substr(zex,1,3)*100)=1
        ) where num=1
        ) ost,

        (select tmc,  gm,  pric_d from 
        (select   tmc,  god*100+mes gm, price pric_d, ROW_NUMBER() OVER
                    (partition by tmc ORDER BY god*100+mes desc, price desc) num from spr_tmc_price_mes where nvl(god,0)<=extract(year from sysdate) and nvl(mes,0)<>0 and nvl(god,0)<>0 and 
        nvl(price,0)>0 and nvl(tmc,0)<>0 
        union all
        select to_number(9||tmc) tmc,  god*100+mes gm, price pric_d, ROW_NUMBER() OVER
                    (partition by tmc ORDER BY god*100+mes desc, price desc) num from hs_price where nvl(god,0)<=extract(year from sysdate) and nvl(mes,0)<>0 and nvl(god,0)<>0 and 
        nvl(price,0)>0 and nvl(tmc,0)<>0 
        ) where num=1
        ) plan         

where s.unik=pri.tmc(+) and s.unik=ost.tmc(+) and s.unik=plan.tmc(+)
) where num1=1

      ) loop
        pipe row ( type5(s.tmc , s.mdg , s.naim , s.naim_old , s.e , s.spr , s.text_status, s.prigm , s.priprice , s.priprice_koe,s.ostgm ,s.ostprice ,s.ostprice_koe ,s.plangm ,s.planprice,s.planprice_koe,s.notd,s.isp,s.tisp ) );
      end loop;
    return;
  end;
  
  FUNCTION pipe_a3 RETURN a3 PIPELINED
   is
  begin
      for s in (
                   select tmc , substr(trim(mdg),1,100) mdg, substr(trim(naim),1,1000) naim , substr(trim(naim_old),1,1000) naim_old, substr(trim(e),1,50) e, substr(trim(spr),1,100) spr , substr(trim(text_status),1,100) text_status, prigm , priprice , priprice_koe,ostgm ,ostprice ,ostprice_koe ,/*plangm ,planprice,planprice_koe ,*/stand_price
 from (

select s.unik tmc, s.mdg mdg, s.naim naim, s.naim_old naim_old, s.e e, s.spr spr, s.text_status text_status, pri.gm prigm, 
pri.pric_d priprice, 

    case when pri.gm<200701 then
        pri.pric_d*3
      when pri.gm>=200701 and pri.gm<=200912
      then
         pri.pric_d*2
      when pri.gm>=201001 and pri.gm<=201212
      then
         pri.pric_d*1.5
         when pri.gm>=201301 and pri.gm<=201312  
      then
         pri.pric_d*1.25
      else
     pri.pric_d
    end priprice_koe,
ost.gm ostgm, 
ost.pric_d ostprice,
case when ost.gm<200701 then
    ost.pric_d*3
  when ost.gm>=200701 and ost.gm<=200912 
  then
     ost.pric_d*2
  when ost.gm>=201001 and ost.gm<=201212 
  then
     ost.pric_d*1.5
     when ost.gm>=201301 and ost.gm<=201312 
  then
     ost.pric_d*1.25
  else
 ost.pric_d
end ostprice_koe,
/*
plan.gm plangm, 
plan.pric_d planprice,
case when plan.gm<200701 then
    plan.pric_d*3
  when plan.gm>=200701 and plan.gm<=200912
  then
     plan.pric_d*2
  when plan.gm>=201001 and plan.gm<=201212 
  then
     plan.pric_d*1.5
     when plan.gm>=201301 and plan.gm<=201312
  then
     plan.pric_d*1.25
  else
 plan.pric_d
end planprice_koe,  */

round(nvl(
    case when pri.gm<200701 then
        pri.pric_d*3
      when pri.gm>=200701 and pri.gm<=200912 
      then
         pri.pric_d*2
      when pri.gm>=201001 and pri.gm<=201212 
      then
         pri.pric_d*1.5
         when pri.gm>=201301 and pri.gm<=201312
      then
         pri.pric_d*1.25
      else
     pri.pric_d
    end,
    
    case when ost.gm<200701 then
    ost.pric_d*3
      when ost.gm>=200701 and ost.gm<=200912 
      then
         ost.pric_d*2
      when ost.gm>=201001 and ost.gm<=201212
      then
         ost.pric_d*1.5
         when ost.gm>=201301 and ost.gm<=201312
      then
         ost.pric_d*1.25
      else
     ost.pric_d
    end),2) stand_price, 
    ROW_NUMBER() OVER
                    (partition by s.mdg ORDER BY 
                    nvl(
    case when pri.gm<200701 then
        pri.pric_d*3
      when pri.gm>=200701 and pri.gm<=200912 
      then
         pri.pric_d*2
      when pri.gm>=201001 and pri.gm<=201212
      then
         pri.pric_d*1.5
         when pri.gm>=201301 and pri.gm<=201312
      then
         pri.pric_d*1.25
      else
     pri.pric_d
    end,
    
    case when ost.gm<200701 then
    ost.pric_d*3
      when ost.gm>=200701 and ost.gm<=200912
      then
         ost.pric_d*2
      when ost.gm>=201001 and ost.gm<=201212
      then
         ost.pric_d*1.5
         when ost.gm>=201301 and ost.gm<=201312
      then
         ost.pric_d*1.25
      else
     ost.pric_d
    end)
                     desc) num1

   from 
        (
        select unik, mdg, naim, naim_old, text_ed(ed) e, status, TEXT_tmc_status(unik) text_status, 'покупное' spr  from spr_tmc where mdg is not null
        union all
        select unik_tmc, mdg, naim, naim_old, text_ed(ed), status, status_spr_hs(status) text_status, 'х/с' spr from spr_hs where mdg is not null and unik = SUBSTR (unik_tmc, 2) AND status >= 0
        --select unik, mdg, naim, naim_old, text_ed(ed) e from spr_tmc_all where mdg is not null
        ) s,

        (select tmc, gm, pric_d from (
        select tmc,  god*100+mes gm, pric_d, ROW_NUMBER() OVER
                    (partition by tmc ORDER BY god*100+mes desc, pric_d desc) num
        from p_pri where god<=extract(year from sysdate) and nvl(tmc,0)<>0 and sklad not in (0,84100) and nvl(izgot,0)<>7 and nvl(kol,0)>0 and nvl(unik_psop,0)<>0
        ) where num=1 ) pri,

        (select tmc, gm,   pric_d from 
        (select   tmc,  god*100+mes gm, nvl(sumak,0)/nvl(kolk,0) pric_d, ROW_NUMBER() OVER
                    (partition by tmc ORDER BY god*100+mes desc, nvl(sumak,0)/nvl(kolk,0) desc) num from tmc_ost_obor where god<=extract(year from sysdate) and
        (nvl(sumak,0)/nvl(kolk,0))>0 and nvl(kolk,0)>0 and nvl(tmc,0)<>0 --and tmc_zex_comp(zex)+is_sklad_cpp(substr(zex,1,3)*100)=1
        ) where num=1
        ) ost /*,

        (select tmc,  gm,  pric_d from 
        (select   tmc,  god*100+mes gm, price pric_d, ROW_NUMBER() OVER
                    (partition by tmc ORDER BY god*100+mes desc, price desc) num from spr_tmc_price_mes where nvl(god,0)<=extract(year from sysdate) and nvl(mes,0)<>0 and nvl(god,0)<>0 and 
        nvl(price,0)>0 and nvl(tmc,0)<>0 
        ) where num=1
        ) plan         */

where s.unik=pri.tmc(+) and s.unik=ost.tmc(+) --and s.unik=plan.tmc(+)
) where num1=1

      ) loop
        pipe row ( type3(s.tmc , s.mdg , s.naim , s.naim_old , s.e , s.spr , s.text_status, s.prigm , s.priprice , s.priprice_koe,s.ostgm ,s.ostprice ,s.ostprice_koe /*,s.plangm ,s.planprice,s.planprice_koe*/,s.stand_price) );
      end loop;
    return;
  end;
  
   FUNCTION pipe_a4 (zgod number, zkv number, zgrp_buh number) RETURN a4 PIPELINED
   is
  begin
      for s in (
       select ost.tmc tmc, substr(trim(text_tmc(ost.tmc)),1,1000) n, substr(trim(text_ed(tmc_ed(ost.tmc))),1,50) e, dog.post okpo, substr(trim(text_firma(dog.post,0)),1,500) firma, dog.pr dog_price, ost.ocpp ocpp, ost.ozex ozex, cla.kv1 kol_kv1, cla.z2015 kol_god, to_char(to_date(dog.lastgod,'yyyymmdd'),'dd.mm.yyyy') date_dog from 
(
select tmc, sum(decode(is_sklad_cpp(sklad),1,kol,0)) ocpp, sum(decode(is_sklad_cpp(sklad),1,0,kol)) ozex
from ostat where kol>0 and GET_TMC_BUH(tmc)=nvl(zgrp_buh,0) and sklad not in (84100,0) and substr(sklad,4,10) not in ('33','55','66')
group by tmc, is_sklad_cpp(sklad)) ost,
(
select tmc,  sum(decode(to_number(to_char(to_date(god_spis*100+mes_spis,'yyyymm'),'q')),nvl(zkv,0),kol_spis-nvl(kol_vyd,0),0) ) kv1, sum(kol_spis-nvl(kol_vyd,0)) z2015  from claim 
where god=nvl(zgod,0) and GET_TMC_BUH(tmc)=nvl(zgrp_buh,0) and status>=0 and kol_spis-nvl(kol_vyd,0)>0 and nvl(god_spis,0)<>0 and nvl(mes_spis,0)<>0 group by tmc
) cla,
(select p.tmc tmc, d.kod_post post, max(p.price) keep (dense_rank first order by s.datd desc) pr, max(s.datd) keep (dense_rank first order by s.datd desc) lastgod 
from sop s, psop p, dogovor d where s.unik_d=d.unik_d and s.unik=p.unik and nvl(p.tmc,0)<>0 and GET_TMC_BUH(p.tmc)=nvl(zgrp_buh,0) and s.uniko is not null
 group by p.tmc, d.kod_post) dog
 where ost.tmc=cla.tmc and ost.tmc=dog.tmc            

      ) loop
        pipe row ( type4(s.tmc, s.n, s.e, s.okpo, s.firma, s.dog_price, s.ocpp, s.ozex, s.kol_kv1, s.kol_god, s.date_dog) );
      end loop;
    return;
  end;
  
   FUNCTION pipe_a5  RETURN a5 PIPELINED
   is
  begin
      for s in (        
 select s.unik unik , s.mdg mdg, substr(s.naim,1,1000) naim, substr(s.e,1,50) e, s.status status, substr(s.text_status,1,100) status_text, s.notd notd, s.isp isp, substr(text_otvet(s.notd,s.isp),1,300) tisp, o.kol kol, o.pric_d pric_d, ost.gm gm, ost.kolk kolk, ost.pric_d pricek
 from 
        (
        select iskl unik,tmc_notd(iskl)  notd,tmc_isp(iskl) isp, tmc_mdg_code(iskl) mdg, text_tmc(iskl) naim, text_ed(tmc_ed(iskl)) e, tmc_status(iskl) status, TEXT_tmc_status(iskl) text_status  
        from snp_mdg_iskl 
        where tmc_mdg_code(iskl) is null
         ) s,

        (select tmc, kol, pric_d from (
        select  tmc, sum(kol) kol, sum(decode(tmc_zex_comp(tmc),1,avg_price,price) *kol) pric_d
        from ostat where nvl(tmc,0)<>0 and sklad not in (0,84100) and nvl(kol,0)>0 group by tmc
        ) ) o,

        (select tmc, gm, kolk,  pric_d from 
        (select  tmc,  god*100+mes gm,kolk, nvl(sumak,0)/nvl(kolk,0) pric_d, ROW_NUMBER() OVER
                    (partition by tmc ORDER BY god*100+mes desc, nvl(sumak,0)/nvl(kolk,0) desc) num from tmc_ost_obor where god*100+mes>=extract(year from add_months(sysdate,-1))*100+extract(month from add_months(sysdate,-1)) and
        (nvl(sumak,0)/nvl(kolk,0))>0 and nvl(kolk,0)>0 and nvl(tmc,0)<>0 --and tmc_zex_comp(zex)+is_sklad_cpp(substr(zex,1,3)*100)=1
        ) where num=1
        ) ost
        where s.unik=o.tmc(+) and s.unik=ost.tmc(+)
      ) loop
        pipe row ( type2(s.unik, s.mdg, s.naim , s.e, s.status, s.status_text, s.gm, s.kolk, s.pricek, s.kol, s.pric_d, s.notd, s.isp, s.tisp) );
      end loop;
    return;
  end;
FUNCTION pipe_a6 (ud number, us number) RETURN a6 PIPELINED
   is
  begin
      for s in (
       select  
decode(row_number() over (partition by pos.tmc order by pos.tmc),1,pos.tmc,null) tmc, 
substr(decode(row_number() over (partition by pos.tmc order by pos.tmc),1,text_tmc(pos.tmc),null),1,2000) naim, 
decode(row_number() over (partition by pos.tmc order by pos.tmc),1,pos.kol,null) kol_spes,
substr(decode(row_number() over (partition by pos.tmc order by pos.tmc),1,text_ed(pos.ed),null),1,50) ed,
decode(row_number() over (partition by pos.tmc order by pos.tmc),1, 
nvl((select sum(nvl(kol,0)-nvl(kol_vyd,0)) from psop_pos_view_no_siz where tmc=p.tmc and (nvl(kol,0)-nvl(kol_vyd,0))>0 ),0)
,null) svego_raspr,
decode(row_number() over (partition by pos.tmc order by pos.tmc),1, 
nvl((select sum(nvl(kol_svob,0)) from ostat where tmc=p.tmc and tmc is not null and nvl(kol,0)>0 and nvl(kol_svob,0)>0
and sklad>0 
    and sklad<>84100
   and (nvl(rezdok,0)=1 or is_sklad_cpp(sklad)+is_sklad_cpp_zex(sklad)=1)
),0)
,null) svob_tek,
decode(row_number() over (partition by pos.tmc order by pos.tmc),1, 
nvl((select sum(nvl(kol,0)) from ostat where tmc=p.tmc and tmc is not null and nvl(kol,0)>0 and sklad>0 
    and sklad<>84100 and
  nvl(rezdok,0)=0 and is_sklad_cpp(sklad)+is_sklad_cpp_zex(sklad)<>1
),0)
,null) svob_tek_zex,
p.sklad sklad,
p.budget_kap/*substr(text_budget_claim(budget_kap),1,300)*/ statia,
p.kol-p.kol_vyd kol_rasp,
p.zex poluch,
p.date_poluch  date_pol,
substr(p.god_spis||p.mes_spis,1,100) date_spis,
P.date_r  date_raspr,
p.unik_claim uniko, 
null /*substr(decode(claims.status_text(claim_status(p.unik_claim)),'???','',claims.status_text(claim_status(p.unik_claim))),1,300)*/ stat_claim, 
null /*substr(decode(p.unik_sop,null,'',decode(p.unik_sop,1,'заявлено из остатка','закупка по сопр:'||p.unik_sop)),1,1000) */ sopr
 from (select tmc,ed,sum(kol) kol from pos where pos.unik_d=nvl(ud,0) and pos.unik_s=nvl(us,0) group by tmc,ed) pos, psop_pos_view_no_siz p
where 
pos.tmc=p.tmc(+) and p.unik_claim(+) is not null and nvl(p.ostat_unik(+),0)>0 and (nvl(p.kol(+),0)-nvl(p.kol_vyd(+),0))>0            

      ) loop
        pipe row ( type6(s.tmc,s.naim,s.kol_spes,s.ed,s.svego_raspr,s.svob_tek,s.svob_tek_zex,s.sklad,s.statia,s.kol_rasp,s.poluch,s.date_pol,s.date_spis,s.date_raspr,s.uniko,s.stat_claim,s.sopr ) );
      end loop;
    return;
  end;
END agregat;
/
