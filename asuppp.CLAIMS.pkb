CREATE OR REPLACE PACKAGE BODY ASUPPP.claims
AS
   function get_temp_uo return number
   is
   begin
   return nvl(temp_uo,0);
   end get_temp_uo;
   function get_tmc(uc number) return number
   is
   begin
   for s in (select nvl(tmc,0) t from claim where
  uniko=uc) loop
    return s.t;
  end loop;
  return 0;
   end get_tmc;

    function get_godmes_spis(uc number) return number
   is
   begin
   for s in (select nvl(god_spis,0)*100+nvl(mes_spis,0) t from claim_all where
  uniko=uc) loop
    return s.t;
  end loop;
  return 0;
   end get_godmes_spis;

       function get_godmes_before_perenos(uc number) return number
   is
   begin
   for s in (select nvl(god_ish,0)*100+nvl(mes_ish,0) t, nvl(god,0)*100+nvl(mes,0) tt from claim where
  uniko=uc) loop
    if s.t<>s.tt then
    return  s.t;
    else
    return 0;
    end if;
  end loop;
  return 0;
   end get_godmes_before_perenos;
       function get_godmes_pol(uc number) return number
   is
   begin
   for s in (select nvl(god,0)*100+nvl(mes,0) t from claim where
  uniko=uc) loop
    return s.t;
  end loop;
  return 0;
   end get_godmes_pol;

      function get_notd(uc number) return number
   is
   begin
   for s in (select nvl(notd,0) t from claim where
  uniko=uc) loop
    return s.t;
  end loop;
  return 0;
   end get_notd;

     function get_isp(uc number) return number
   is
   begin
   for s in (select nvl(isp,0) t from claim where
  uniko=uc) loop
    return s.t;
  end loop;
  return 0;
   end get_isp;

function get_kod_krid(uc number) return number
   is
   begin
   for s in (select kod_krid t from claim_all where
  uniko=uc) loop
    return s.t;
  end loop;
  return null;
   end get_kod_krid;

   function get_invn(uc number) return number
   is
   begin
   for s in (select invn t from claim_all where
  uniko=uc) loop
    return TO_NUMBER_SILENT(s.t);
  end loop;
  return null;
   end  get_invn;


    function get_budget(uc number) return number
   is
   begin
   for s in (select nvl(budget,0) t from claim where
  uniko=uc) loop
    return s.t;
  end loop;
  return null;
   end get_budget;

    function get_mol(uc number) return number
   is
   begin
   for s in (select nvl(mol,nvl(zex_poluch,zex) ) t from claim where
  uniko=uc) loop
    return s.t;
  end loop;
  return null;
   end get_mol;

     function get_gost(uc number) return varchar2
   is
   begin
   for s in (select gost t from claim where
  uniko=uc) loop
    return s.t;
  end loop;
  return null;
   end get_gost;

   function get_sh_zatr(uc number) return number
   is  shz number;
   begin
   for s in (select nvl(budget,0) t, nvl(kod_krid,0) tt from claim where  uniko=uc) loop

        if s.t<>6 then
    return s.t;
    else
      for ss in (select trim(substr(prizn_kap,-2,2)) pk from spr_krid where unik=s.tt)
      loop
        if ss.pk='15' then return 15; end if;
        if ss.pk='16' then return 16; end if;
        return null;
      end loop;
   end if;

  end loop;
  return null;
   end get_sh_zatr;



   function get_sh_zatr_kr(b number, kr number) return number
   is  shz number;
   begin
    if b<>6 then
      return b;
    else
      for ss in (select trim(substr(prizn_kap,-2,2)) pk from spr_krid where unik=kr)
      loop
        if ss.pk='15' then return 15; end if;
        if ss.pk='16' then return 16; end if;
        return null;
      end loop;
      return null;
   end if;

  end get_sh_zatr_kr;



      function get_status(uc number) return number
   is
   begin
   for s in (select nvl(status,0) t from claim where
  uniko=uc) loop
    return s.t;
  end loop;
  return 0;
   end get_status;

   function get_nam(uc number) return varchar2
   is
   begin
   for s in (select nam_nn t from claim where
  uniko=uc) loop
    return s.t;
  end loop;
  return '';
   end get_nam;

   function get_zex(uc number) return number
   is
   begin
   for s in (select nvl(zex,0) t from claim where
  uniko=uc) loop
    return s.t;
  end loop;
  return 0;
   end get_zex;

      function get_god(uc number) return number
   is
   begin
   for s in (select nvl(god,0) t from claim where
  uniko=uc) loop
    return s.t;
  end loop;
  return 0;
   end get_god;

   function get_mes(uc number) return number
   is
   begin
   for s in (select nvl(mes,0) t from claim where
  uniko=uc) loop
    return s.t;
  end loop;
  return 0;
   end get_mes;

      function get_qvart(uc number) return number
   is
   begin
   for s in (select to_number(to_char(to_date(nvl(god,0)*100+nvl(mes,0),'yyyymm'),'q')) t from claim where
  uniko=uc) loop
    return s.t;
  end loop;
  return 0;
   end get_qvart;
      function get_otvet(uc number) return number
   is
   begin
   for s in (select nvl(otvet,0) t from claim where
  uniko=uc) loop
    return s.t;
  end loop;
  return 0;
   end get_otvet;

      function get_subshet(uc number) return number
   is
   begin/*
   for s in (select nvl(syb_chet,0) t from spr_mot where
  cod_people=get_otvet(uc)) loop
    return s.t;
  end loop;
  */
  return 0;
   end get_subshet;
      function get_kol(uc number) return number
   is
   begin
   for s in (select nvl(kol,0) t from claim where
  uniko=uc) loop
    return s.t;
  end loop;
  return 0;
   end get_kol;

        function get_kol_ztrb(uc number) return number
   is
   begin
   for s in (select nvl(kol_cl_ztrb,0) t from claim where
  uniko=uc) loop
    return s.t;
  end loop;
  return 0;
   end get_kol_ztrb;

  function get_kol_svobodno_vydano(uc number) return number
    is
  begin
    for s in (
      select nvl(sum(nvl(kol2,0) 
       - nvl((select sum(nvl(pp.kol2,0)) from psop_pos pp where pp.unik_Raspr_p=psop_pos.unik_raspr),0)
       ),0)
      t 
      from psop_pos/*_view */ 
      where
        unik_claim=uc and unik_pos=1 and nvl(unik_raspr_p,0)=0 
    ) loop
      return s.t;
    end loop;
    
    return 0;
    
  end get_kol_svobodno_vydano;

         function get_kol_vyd(uc number) return number
   is
   begin
   for s in (select nvl(kol_vyd,0) t from claim where
  uniko=uc) loop
    return s.t;
  end loop;
  return 0;
   end get_kol_vyd;

            function get_kol_ztrb_vyd(uc number) return varchar2
   is
   begin
   for s in (select nvl(kol_cl_ztrb,0)||'/'||nvl(kol_vyd,0) t from claim where
  uniko=uc) loop
    return s.t;
  end loop;
  return '';
   end get_kol_ztrb_vyd;

   function get_kol_dog(uc number) return number
   is
   begin
   for s in (select nvl(kol_dog,0)+nvl(kol_vyd,0) t from claim where
  uniko=uc) loop
    return s.t;
  end loop;
  return 0;
   end get_kol_dog;

      function get_kol_dog_(uc number) return number
   is
   begin
   for s in (select nvl(kol_dog,0) t from claim where
  uniko=uc) loop
    return s.t;
  end loop;
  return 0;
   end get_kol_dog_;

            function get_ost_vyd(uc number) return number
   is
   begin
   for s in (select nvl(kol,0)-nvl(kol_vyd,0) t from claim where
  uniko=uc) loop
    return s.t;
  end loop;
  return 0;
   end get_ost_vyd;

  function status_text(s number) return varchar2
  as
  begin
    if s = 0 then
      return 'Действующая';
    elsif s=-1 then
      return 'Ошибка при загрузке';
    elsif s=-2 then
      return 'Порция удалена';
    elsif s=-3 then
      return 'Исключена корр.заявкой';
    elsif s=-4 then
      return 'Черновик';
    elsif s=-5 then
      return 'Бюджетный контроль';
    elsif s=-6 then
      return 'Ресурсный отдел';
    elsif s=-7 then
      return 'Согласовано р.о.';
    elsif s=1 then
      return 'Запрос на исключение';
    elsif s=2 then
      return 'Черновик к исключению';
    elsif s=-8 then
      return 'После р.о. нарушает лимит';
    elsif s=-9 then
      return 'Не подписано';
    elsif s=10 then
      return 'Просрочена к закупке';
    elsif s=5 then
      return 'Непроф./РО';
    elsif s=6 then
      return 'В цеху-требование';
    elsif s=7 then
      return 'В цеху-транзит';
    elsif s=8 then
      return 'На ЦПП';
    elsif s=-11 then
      return 'Отложена (отриц.лимит)';
    elsif s=-12 then
      return 'Запрещена (некорректная заявка)';
    elsif s=-13 then
      return 'Отказ (снижение затрат)';
     elsif s=-14 then
      return 'Согласование ПБО';
    elsif s=-15 then
      return 'Согласование УпиКНЗ';
    elsif s=-16 then
      return 'На утверждении комиссии';
    elsif s=-20 then
      return 'хоз.способ в проработке, не подтвержден цехом';
      elsif s=-50 then
      return 'хоз.способ ссылка в unik=uniko(квартальная)/была квартальная unik=2(квартал)';
    elsif s=-44 then
      return 'согласование СО';
    elsif s=-45 then
      return 'Отдел ремонтов';
    elsif s=-46 then
      return 'на согласовании УНиД';
    elsif s=-80 then
      return 'На согласовании УИТ (расходники)';
    elsif s=-90 then
      return 'На согласовании УИТ (ИТ оборудование)';
    elsif s=-95 then
      return 'На согласовании ЦТиС';
    elsif s=-91 then
      return 'На согласовании по направленю';
          elsif s=11 then
      return 'отправлена в СЗ';
    elsif s=12 then
      return 'отправлена в ЦЗ';
    elsif s=13 then
      return 'принята СЗ';
    elsif s=14  then
      return 'протокол выдан СЗ';
    elsif s=15 then
      return 'протокол выдан ЦЗ';
    elsif s=16 then
      return 'приостановлено СЗ';
    elsif s=3 then
      return 'точность планирования (исключение)';
    elsif s=4 then
      return 'точность планирования (возврат)';
    elsif s=-92 then
      return 'Согласование отделом по соц. вопросам';
    else
      return '???';
    end if;
  end;


  function priem_allowed return number as
  begin
    if nvl(oasu.get_prop('claim_obk'),0)
      +nvl(oasu.get_prop('claim_io'),0)
      +nvl(oasu.get_prop('claim_ob'),0)
      +nvl(oasu.get_prop('claim_obna'),0) > 0
    then
      return 1;
    else
      return 0;
    end if;
    /*
    if oasu.get_prop('user_cex') in (69912, 69948, 69939) then
      return 1;
    else
      return 0;
    end if;
    */
  end;

  function view_all_zex return number as
  begin
    if
     oasu.get_prop('user_cex') in
      (69600, 67700, 68800, 69920, 69912,
       69948, 69939, 69914, 69918, 69906,
       69000, 69936,69913) then
      return 1;
    else
      return 0;
    end if;
  end;

  function is_res_otdel return number as
  begin
    return nvl(oasu.get_prop('claim_ro'),0);
    /*
    if oasu.get_prop('user_cex') in (69914, 69906, 69918, 69927, 69920) then
      return 1;
    else
      return 0;
    end if;
    */
  end;

  function is_otdrem return number as
  begin
    return nvl(oasu.get_prop('claim_or'),0);
    /*
    if oasu.get_prop('user_cex') in (69920) then
      return 1;
    else
      return 0;
    end if;
    */
  end;

  function nepof(zex number) return number as
  begin
    for s in (
      select neprof from slug1 where nums=zex
    ) loop
        return s.neprof;
    end loop;
    return 0;
  end;

  function neprof_cl(zex number) return number as
  begin
    for s in (
      select neprof_claim from slug1 where nums=zex
    ) loop
        return s.neprof_claim;
    end loop;
    return 0;
  end;

  function check_limit(p_zex number, p_budg95 number, p_god number, p_mes number,p_kod_limit number) return number as
    res number;
  begin
    res:=0;
    for s in (
    select nvl(sum(s),0) ss from (
    select -sum(nvl(sum_isp,sum_spis)) s
    from claim where god_spis=p_god and mes_spis=p_mes and zex=p_zex and status>=0
    and budg95=p_budg95 and budg95 not in (75,100,200) and budget in
    (select b.unik from spr_budget_claim b where b.limited=1 and nvl(b.gr_limit,0)=p_kod_limit)
    union all
    select suma from limit_budget, SPR_LIMIT_BUDGET where zakspis=0 and poksob=1
    and LIMIT_BUDGET.KOD_LIMIt=SPR_LIMIT_BUDGET.unik
    and god=p_god and mes=p_mes and budg_type=p_budg95 and zex=p_zex and nvl(gr_limit,0)=p_kod_limit)
    )
    loop
     res:=s.ss;
    end loop;

    return res;
  end;


  procedure job_Restore_claims(p_zex number, p_budg95 number, p_god number, p_mes number, p_kod_limit number default null) as
     ostlim number;
     o number;
  begin
     return;
     -- было решено автоматическое восстановление не происходит !!!

     ostlim := CLAIMS.CHECK_LIMIT(p_zex, p_budg95, p_god, p_mes,p_kod_limit);
--        DBMS_OUTPUT.PUT_LINE(ostlim);

        loop
            exit when ostlim <=0;

            for q in (
              select claim.rowid, sum_spis from claim, spr_budget_claim
              where zex=p_zex and budg95=p_budg95 and god_spis=p_god and mes_spis=p_mes
              and sum_spis<ostlim
              and nvl(nvl(sum_isp,sum_spis),0)<>0
              and status=-11
              and claim.budget=spr_budget_claim.unik
              and spr_budget_claim.limited=1
              and spr_budget_claim.limit=nvl(p_kod_limit,spr_budget_claim.limit)
              and rownum<2
              order by datreg asc
            ) loop
              update claim set status=0 where rowid=q.rowid;
              --commit;
            end loop;
            o := CLAIMS.CHECK_LIMIT(p_zex, p_budg95, p_god, p_mes,p_kod_limit);
            exit when o=ostlim;
            ostlim := o;
        end loop;
  end;

  procedure job_Restore_claims as
  begin
  /*
  for s in (
    select distinct zex, budg95, god_spis, mes_spis from claim where status=-11
  ) loop
    CLAIMS.JOB_RESTORE_CLAIMS(s.zex, s.budg95, s.god_spis, s.mes_spis);
  end loop;
  */
  null;
end;

  procedure Kill_Claims_for_Limit(p_zex number, p_b95 number, p_god number, p_mes number,p_kod_limit number) as
     ostlim number;
     o number;
    begin
      ostlim := CLAIMS.CHECK_LIMIT(p_zex, p_b95, p_god, p_mes,p_kod_limit);

       loop
           exit when ostlim >=0;

           for q in (
             select claim.status, claim.uniko,claim.rowid, nvl(claim.sum_isp, sum_spis) sum_spis from claim, spr_budget_claim
             where zex=p_zex and budg95=p_b95 and god_spis=p_god and mes_spis=p_mes
             and nvl(nvl(sum_isp,sum_spis),0)<>0
             and status in (0,10)
             and budg95 not in (100,75,200)
             and claim.budget=spr_budget_claim.unik
             and spr_budget_claim.limited=1
             and rownum<2
             and nvl(kol_dog,0)=0
             and nvl((select count(*) from psop_pos where unik_claim=claim.uniko),0)=0
             and SPR_BUDGET_CLAIM.GR_LIMIT=p_kod_limit
             and nvl(claim.unik,0)=0
             and nvl(avar,0)<>1
             and nvl(claim.sum_isp, sum_spis)>0
             --and svazka is not null
             order by datreg desc
           ) loop
              update claim set status=-11 where rowid=q.rowid;
              INSERT INTO ASUNZ.CLAIM_ST_HIST (
                 UNIKO, STATUS, WHO,
                 STAT, PRICH, STATUS_WAS)
              VALUES (q.uniko,
               -11,
               null,
               sysdate,
               'Превышение лимита - автоматически отложена',
               q.status);
              end loop;
            o := CLAIMS.CHECK_LIMIT(p_zex, p_b95, p_god, p_mes,p_kod_limit);
            exit when o=ostlim;
            ostlim := o;
        end loop;
    end;


    procedure job_Kill_Claims_for_Limit
     as
    begin
      for s in (
        select distinct god, mes, zex, budg_type, SPR_LIMIT_BUDGET.GR_LIMIT
        from limit_budget, SPR_LIMIT_BUDGET where date_korr is not null and l_check=0
        and LIMIT_BUDGET.KOD_LIMIT=SPR_LIMIT_BUDGET.UNIK
      ) loop
        if CLAIMS.CHECK_LIMIT(s.zex, s.budg_type, s.god, s.mes, s.gr_limit) < 0 then
          CLAIMS.KILL_CLAIMS_FOR_LIMIT(s.zex, s.budg_type, s.god, s.mes, s.gr_limit);
        end if;
        update limit_budget set l_check=1
        where date_korr is not null and l_check=0;
      end loop;
      commit;
    end;

    procedure job_Prosroch as
     cm number;
     cg number;
     nm number;
     ng number;
     nmc number;
     ngc number;
     ndp date;
     lims number;
     nella number(9);
     npp number;
    begin

      return;

      npp := 1;
      cm := to_char(sysdate,'mm');
      cg := to_char(sysdate,'yyyy');
      nm := to_char(add_months(sysdate,1), 'mm');
      ng := to_char(add_months(sysdate,1), 'yyyy');

      if cm in (3, 6, 9, 12) then
      -- квартал!
        for s in (
          select * from claim where god_spis=cg and mes_spis=cm and status=0 and nvl(kol_dog,0)=0
          and budg95<>100
          and budget not in (6,11)
          and isp<>0
        ) loop
          INSERT INTO ASUNZ.CLAIM_AUTO_CHANGES (
            CLAIM_UNIKO, CHDATE, GOD_OLD,
            MES_OLD, GOD_NEW, MES_NEW,
            DATEP_OLD, DATEP_NEW, PRIM, ella_old, ella_new)
          VALUES (s.uniko,sysdate,s.god_spis,s.MES_spis,null,null,s.date_poluch,
            null, 'Незаконтрактованные в конце квартала -> просроченные', s.ella, s.ella);
          update claim set status=10 where claim.uniko=s.uniko;
        end loop;
      end if;

      for s in (
        select * from claim
        where god=cg and mes=cm and status=0
        and budg95<>100
          and isp<>0
        --невыполненные
        and (
          cm not in (3, 6, 9, 12) or budget in (6,11)
          --внутри квартала или КР/ИД
        )
      ) loop
      -- перенос даты получения на месяц перёд для заявок которые ещё не в цеху;
      -- если необходимо - перенести и дату списания, тогда и лимиты тоже перенести

        ndp := to_date(to_char(add_months(s.date_poluch,1),'yyyymm')||'01','yyyymmdd');

        if to_char(ndp,'yyyymm') > s.god_spis*100+s.mes_spis then
        -- если необходимо - перенести также и списание
          nmc := to_char(ndp,'mm');
          ngc := to_char(ndp,'yyyy');
          nella := '5'||lpad(nmc,2,'0')||lpad(npp,6,'0'); npp := npp+1;

          if is_budget_limited(s.budget)=1 then
            -- для лимитируемых статей - взять с собой деньги
            insert into limit_budget (god, mes, zex, kod_limit, suma, prim, budg_type, zakspis, date_korr, poksob)
            values (s.god_spis, s.mes_spis, s.zex, budget_limit(s.budget),
            -s.sum_spis, 'Автоперенос внутри квартала, заявка '||s.uniko,
            s.budg95, 0, sysdate, 1);

            insert into limit_budget (god, mes, zex, kod_limit, suma, prim, budg_type, zakspis, date_korr, poksob)
            values (ngc, nmc, s.zex, budget_limit(s.budget),
            s.sum_spis, 'Автоперенос внутри квартала, заявка '||s.uniko,
            s.budg95, 0, sysdate, 1);
          end if;

        else
          nmc := s.mes_spis;
          ngc := s.god_spis;
        end if;

        update claim set god_spis=ngc, mes_spis=nmc, date_poluch=ndp, ella = nvl(nella, ella)
        where claim.uniko=s.uniko;

        INSERT INTO ASUNZ.CLAIM_AUTO_CHANGES (
          CLAIM_UNIKO, CHDATE, GOD_OLD,
          MES_OLD, GOD_NEW, MES_NEW,
          DATEP_OLD, DATEP_NEW, PRIM, ella_old, ella_new)
        VALUES (s.uniko,sysdate,s.god_spis,s.MES_spis,ngc,nmc,s.date_poluch,
          ndp, 'Перенос невыполненных внутри квартала', s.ella, nella);
      end loop;


      -- внутри квартала или снаружи - перенос списания для позиций которые уже приехали на ЦПП,
      -- должны быть списаны в этом месяце, но их ещё не забрали
      for s in (
        select * from claim where god_spis=cg and mes_spis=cm and status=8
          and isp<>0
        and budg95<>100
      ) loop
        ndp := s.date_poluch;

        nmc := to_char(add_months(to_date(s.god_spis*100+s.mes_spis,'yyyymm'),1),'mm');
        ngc := to_char(add_months(to_date(s.god_spis*100+s.mes_spis,'yyyymm'),1),'yyyy');

        nella := '5'||lpad(nmc,2,'0')||lpad(npp,6,'0'); npp := npp+1;

        INSERT INTO ASUNZ.CLAIM_AUTO_CHANGES (
          CLAIM_UNIKO, CHDATE, GOD_OLD,
          MES_OLD, GOD_NEW, MES_NEW,
          DATEP_OLD, DATEP_NEW, PRIM, ella_old, ella_new)
        VALUES (s.uniko,sysdate,s.god_spis,s.MES_spis,ngc,nmc,s.date_poluch,
          ndp, 'Автоперенос - лежит на ЦПП, не успели забрать', s.ella, nella);

        update claim set god_spis=ngc, mes_spis=nmc, date_poluch=ndp, ella=nvl(nella, ella)
        where claim.uniko=s.uniko;

        if is_budget_limited(s.budget)=1 then
          if cm in (3, 6, 9, 12) then
          -- если статья лимитиуемая, но перенос - за границу квартала:
            lims := CLAIMS.CHECK_LIMIT(s.zex, s.budg95, ngc, nmc, 0);
            if lims < 0 then
              -- если в первом месяце следующего квартала стало нехватать денег,
              -- то взять их из последего месяца квартала

              insert into limit_budget (god, mes, zex, kod_limit, suma, prim, budg_type, zakspis, date_korr, poksob)
              values (ngc, nmc+2, s.zex, budget_limit(s.budget),
              lims, 'Заём из третьего месяца следующего квартала, заявка '||s.uniko,
              s.budg95, 0, sysdate, 1);

              insert into limit_budget (god, mes, zex, kod_limit, suma, prim, budg_type, zakspis, date_korr, poksob)
              values (ngc, nmc, s.zex, budget_limit(s.budget),
              -lims, 'Заём из третьего месяца следующего квартала, заявка '||s.uniko,
              s.budg95, 0, sysdate, 1);

              CLAIMS.KILL_CLAIMS_FOR_LIMIT(s.zex, s.budg95, ngc, nmc+2, 0);
              --если нужно то поубивать заявки в конце квартала которым нехватило
            end if;

          else
          -- для лимитируемых статей - взять с собой деньги, если это внутри квартала
            insert into limit_budget (god, mes, zex, kod_limit, suma, prim, budg_type, zakspis, date_korr, poksob)
            values (s.god_spis, s.mes_spis, s.zex, budget_limit(s.budget),
            -s.sum_spis, 'Автоперенос - лежит на ЦПП, не успели забрать, заявка '||s.uniko,
            s.budg95, 0, sysdate, 1);

            insert into limit_budget (god, mes, zex, kod_limit, suma, prim, budg_type, zakspis, date_korr, poksob)
            values (ngc, nmc, s.zex, budget_limit(s.budget),
            s.sum_spis, 'Автоперенос - лежит на ЦПП, не успели забрать, заявка '||s.uniko,
            s.budg95, 0, sysdate, 1);
          end if;
        end if;

      end loop;


      -- перенос законтрактованных не попавших под другие правила за границу квартала
      if cm in (3, 6, 9, 12) then
        for s in (
          select * from claim where god_spis=cg and mes_spis=cm and status=0 and kol_dog>0
           and isp<>0
         and budg95<>100
        ) loop
          ndp := to_date(to_char(add_months(s.date_poluch,1),'yyyymm')||'01','yyyymmdd');

          nmc := to_char(add_months(to_date(s.god_spis*100+s.mes_spis,'yyyymm'),1),'mm');
          ngc := to_char(add_months(to_date(s.god_spis*100+s.mes_spis,'yyyymm'),1),'yyyy');

          nella := '5'||lpad(nmc,2,'0')||lpad(npp,6,'0'); npp := npp+1;

          INSERT INTO ASUNZ.CLAIM_AUTO_CHANGES (
            CLAIM_UNIKO, CHDATE, GOD_OLD,
            MES_OLD, GOD_NEW, MES_NEW,
            DATEP_OLD, DATEP_NEW, PRIM, ella_old, ella_new)
          VALUES (s.uniko,sysdate,s.god_spis,s.MES_spis,ngc,nmc,s.date_poluch,
            ndp, 'Автоперенос законтрактованных в новый квартал', s.ella, nella);

          update claim set god_spis=ngc, mes_spis=nmc, date_poluch=ndp, ella=nvl(nella, ella)
          where claim.uniko=s.uniko;

          if is_budget_limited(s.budget)=1 then
            -- если статья лимитиуемая, но перенос - за границу квартала:
            lims := CLAIMS.CHECK_LIMIT(s.zex, s.budg95, ngc, nmc, 0);
            if lims < 0 then
              -- если в первом месяце следующего квартала стало нехватать денег,
              -- то взять их из последего месяца квартала

              insert into limit_budget (god, mes, zex, kod_limit, suma, prim, budg_type, zakspis, date_korr, poksob)
              values (ngc, nmc+2, s.zex, budget_limit(s.budget),
              lims, 'Перенос законтрактованных: заём из третьего месяца следующего квартала, заявка '||s.uniko,
              s.budg95, 0, sysdate, 1);

              insert into limit_budget (god, mes, zex, kod_limit, suma, prim, budg_type, zakspis, date_korr, poksob)
              values (ngc, nmc, s.zex, budget_limit(s.budget),
              -lims, 'Перенос законтрактованных: заём из третьего месяца следующего квартала, заявка '||s.uniko,
              s.budg95, 0, sysdate, 1);

              CLAIMS.KILL_CLAIMS_FOR_LIMIT(s.zex, s.budg95, ngc, nmc+2, 0);
              --если нужно то поубивать заявки в конце квартала которым нехватило
            end if;

          end if;

        end loop;
      end if;

    end;

    function zex_comp(z number) return number as
    begin
      if substr(z,1,3) in ('605', '610', '613', '611','601','696','602','603','634','666',
      '667','668','669','670','671','672'
      ,'624','628' ,'673','698','627','697','606'
      ,'641','680' ,'607','625','589','664'
      ,'694','630','676','539'
      ,'674'
      ,'695','638','639'
      ,'693','692','631','656','608','629','635'
      ,'675','830','833',
      '316','585','653','804','642','313','818','317','311','688',
      '780','319',
      '315','314','501','588','640','805','808','813','816','819','820','831','834'
      ) then
        return 1;
      end if;
            if z in (71501,75301/*,78001,78002,78003,78004,78005*/) then return 1; end if;
      return 0;
    end;

    procedure Cancel_Perenos(up number) as
    begin
      delete from limit_budget l where L.UNIK_PERENOS=up;
      for s in (
        select A.* from CLAIM_AUTO_CHANGES a where a.unik=up
      ) loop

        update claim set god_spis=s.GOD_OLD, mes_spis=s.MES_OLD, date_poluch=s.DATEP_OLD,
        god=to_char(s.DATEP_OLD,'yyyy'),
        mes=to_char(s.DATEP_OLD,'mm'),
        ella = s.ella_old, status=10
        where claim.uniko=s.claim_uniko;

        INSERT INTO ASUNZ.CLAIM_ST_HIST (
           UNIKO, STATUS, WHO,
           STAT, PRICH, STATUS_WAS)
        VALUES (s.claim_uniko,
         10,
         null,
         sysdate,
         'Автоперенос: отмена автопереноса',
         0);

      end loop;

      delete from CLAIM_AUTO_CHANGES where unik=up;
    end;

    function zex_sklad(z number, s number) return number as
    begin
      if
          (z=64100 and s in (70100,70200,70300))
       or (z=68000 and s in (70400))
       or (z=63600 and s in (77800))
        or (z=63700 and s in (78800))
--       or (z=66600 and s in (79100))
       or (z=69915 and s in (81800))
       or (z=58500 and s in (77900, 69948, 69964))
       or (substr(z,1,3)=699 and s in (58500))
--       or (z=67100 and s in (79100, 78600))
       or (z=69300 and s in (69200))
       or (z=62000 and s in (58700))
       or (z=60800 and s in (58700))
       or (z=58700 and s in (60800))
       or (z=67700 and s in (67701, 67702, 67703, 67700, 69700))
       or (z=69909 and s in (80400))
       or (z=69920 and s in (82000))
       or (z=69925 and s in (80500))
       or (z=69970 and s in (58500))
       or (z=66400 and s in (58700))
       or (z=62000 and s in (58700))
       or (z=69942 and s in (83100))
       or (z=69940 and s in (83000))
       or (z=64800 and s in (58600))
--       or (z=63400 and s in (74700))
       or (z=69000 and s in (82100))
       or (z=69900 and s in (69914,69906,69918,81800,80400))
       or (z=66400 and s in (58700))
       or (z=68800 and s in (80300))
       or (z=66000 and s in (78900))
       or (z=54000 and s in (58700))
       or (z=68900 and s in (31500))
--       or (z=66600 and s in (67100,67000,66900,67200,79100,78600))
       or (z=58500 and s in (69951))
      then
        return 1;
      end if;

     if z = s then
       return 1;
     end if;

     return 0;
    end;

      function zex_sklad_cpp(z number, s number) return number as
    begin
      if
          (substr(z,1,3)='696' and substr(s,1,3) in ('711'))
       or (substr(z,1,3)='634' and substr(s,1,3) in ('747'))
     --  or (substr(z,1,3)='539' and substr(s,1,3) in ('704'))
       or (substr(z,1,3)='539' and substr(s,1,3) in ('701','702','703','708','704'))
      then
        return 1;
      end if;

     if z = s then
       return 1;
     end if;

     return 0;
    end;

    function sklad_cpp_on_zex(z number) return number as
    begin
      if substr(z,1,3)='696' then return 71100; end if;
      if substr(z,1,3)='634' then return 74700; end if;
      if substr(z,1,3)='674' then return 78000; end if;
      if substr(z,1,3)='671' then return 79100; end if;
      if substr(z,1,3)='666' then return 79100; end if;
      if substr(z,1,3)='680' then return 70400; end if;
     return 0;
    end;

    procedure uslugi_prices(g number)
     as
     pp number;
    begin
      for s in (
        select spr_tmc.unik from spr_Tmc, sprpgr
        where spr_tmc.kod_grp=sprpgr.kod_grp
        and spr_tmc.kod_pgr=sprpgr.kod_pgr
        and SPRPGR.IS_USLUGI=1
      ) loop
        for mm in 1 .. 12 loop
          select max(price) into pp from SPR_TMC_PRICE_MES where tmc=s.unik and god=g and mes=mm;
          if nvl(pp,0) <> 1 then
            delete from spr_tmc_price_mes where tmc=s.unik and god=g and mes=mm;
            insert into spr_tmc_price_mes (tmc, god, mes, price) values (s.unik, g, mm, 1);
          end if;
        end loop;
      end loop;
    end;

    function uslugi_grp  return number as begin return 302; end;
    function uslugi_pgr  return number as begin return 1; end;
    function uslugi_notd return number as begin return 69920; end;
    function uslugi_isp  return number as begin return 18; end;

    function budg_io(b number) return number
     as
    begin
      if b in (6,11) then return 1; else return 0; end if;
    end;


    procedure autoPerenos_2012_nkk
    as
    begin
      claims_autoPerenos;
    end;

   function perenos_chop(uo number) return number
   -- возвращает номер отделённой (новой) заявки, которую нужно переносить
    as
    cl claim%rowtype;
    pb pos_budget%rowtype;
    kk number;
   begin
    for s in (
      select rowid, uniko from claim_autoperenos where skl > 0.0001
      and CLAIM_AUTOPERENOS.UNIKO=uo
    ) loop
      select * into cl from claim where rowid=s.rowid;
      kk := 0;
      -- 1. kk=количество по заявке которую нужно переносить,
      -- которое незаконтрактовано и непривязано
      kk := nvl(cl.kol_spis,0) - nvl(cl.kol_dog,0);
      select nvl(kk - nvl(sum(nvl(kol2,0)),0),0)
      into kk
      from psop_pos where unik_claim=cl.uniko and unik_sop=1;

      -- 2. прибавляем к kk количество законтрактованное но незавезённое
      select nvl(kk,0)
      + nvl(
             sum(pos_budget.kol -
                 (select nvl(
                              sum(
                                 decode(
                                  nvl(psop_pos.kol2,0),
                                  0,
                                  psop_pos.kol,
                                  psop_pos.kol2
                                 )
                              )
                         ,0)
                  from PSOP_POS, psop
                  where PSOP_POS.UNIK_CLAIM=CL.UNIKO
                  and PSOP_POS.UNIK_POS=PSOP.UNIK_POS
                  and PSOP.UNIK_DOG=POS.UNIK
                 )
                ),
           0)
      into kk
      from pos, pos_budget
      where POS_BUDGET.CLAIM_UNIKO=cl.uniko
      and POS_BUDGET.UNIK=POS.UNIK
      and nvl(POS.TOLERANCE_KOL_MINUS, pos.kol) > nvl(POS.KOL_ZAVOZ,0);

      if kk > 0 then
        if cl.sum_spis>0 then
          cl.sum_spis := cl.sum_spis/cl.kol_spis * kk;
        end if;
        cl.kol_spis := kk;
        cl.kol := kk;
        cl.kol_sklad := 0; --всегда ноль т.к. эта "отрезанная" заявка - и есть то, что не заехало, нет на складе
        cl.kol_dog := 0; --дог обнуляем т.к. позже будем вставлять pos_budget, он сам здесь отразится
        cl.kol_vyd := 0;
        cl.status := 0;

        select ASUNZ.SQ_CLAIM.nextval into cl.uniko from dual;

        insert into CLAIM values cl;
        INSERT INTO ASUNZ.CLAIM_ST_HIST (
           UNIKO, STATUS, WHO,
           STAT, PRICH, STATUS_WAS)
        VALUES (cl.uniko,
         0,
         null,
         sysdate,
         'Автоперенос: отделение от частично исполненой заявки №'||s.uniko,
         0);

        update claim
        set kol_spis=kol_spis-kk, kol=kol-kk,
        sum_spis=sum_spis-cl.sum_spis,
        status=decode(kol_sklad, kol_spis, 6, status)
        where rowid=s.rowid;

        INSERT INTO ASUNZ.CLAIM_AUTO_CHANGES (
          CLAIM_UNIKO, CHDATE, GOD_OLD,
          MES_OLD, GOD_NEW, MES_NEW,
          DATEP_OLD, DATEP_NEW, PRIM, ella_old, ella_new)
        VALUES (s.uniko,sysdate,cl.god_spis,cl.MES_spis,cl.god_spis,cl.MES_spis, cl.date_poluch,
          cl.date_poluch, 'Разделение заявки для частичного переноса '||s.uniko||' > '||cl.uniko, cl.ella, cl.ella);

        INSERT INTO ASUNZ.CLAIM_ST_HIST (
           UNIKO, STATUS, WHO,
           STAT, PRICH, STATUS_WAS)
        VALUES (s.uniko,
         0,
         null,
         sysdate,
         'Автоперенос: отделена неисполненная часть в №'||cl.uniko,
         0);

        STD.DEBUG_MESSAGE('claims.autoperenos.chop',s.uniko||'   '||cl.uniko);

        for q in (
          select pos_budget.kol pbk,
            (select
              nvl(
                sum(
                  decode(
                    nvl(psop_pos.kol2,0)
                    ,0,
                    psop_pos.kol,
                    psop_pos.kol2
                  )
                )
              ,0)
             from PSOP_POS, psop
             where PSOP_POS.UNIK_CLAIM=s.UNIKO --s.uniko!! т.к. в cl уже новая заявка,
             --отрезанный кусок, а здесь мы смотрим привязки старой
             and PSOP_POS.UNIK_POS=PSOP.UNIK_POS
             and PSOP.UNIK_DOG=POS.UNIK) z,
             pos.unik
          from pos, pos_budget
          where POS_BUDGET.CLAIM_UNIKO=s.uniko -- s.!! см выше
          and POS_BUDGET.UNIK=POS.UNIK
          and nvl(POS.TOLERANCE_KOL_MINUS, pos.kol) > nvl(POS.KOL_ZAVOZ,0)
        ) loop
          STD.DEBUG_MESSAGE('claims.autoperenos.chop',s.uniko||'   '||cl.uniko||' '||q.z||' '||q.pbk);
          if q.z < q.pbk then
            select * into pb from pos_budget
            where POS_BUDGET.UNIK=q.unik and POS_BUDGET.CLAIM_UNIKO=s.uniko
            and kol>0;

            update pos_budget set kol=q.z, stat2=sysdate, prim_change='Автоперенос: часть кол-ва отделена'
            where POS_BUDGET.UNIK=q.unik and POS_BUDGET.CLAIM_UNIKO=s.uniko
            and kol>0;

            pb.claim_uniko := cl.uniko;
            pb.kol := q.pbk-q.z;
            pb.stat2 := sysdate;
            pb.prim_change := 'Автоперенос: отделённая заявка';
            insert into POS_BUDGET values pb;
          end if;
        end loop;
      end if;

      return cl.uniko;
    end loop;
    return null;
   end;

   procedure perenos(uc number, gm date, s_lim number default 1)
      as
      ndp date;
      nmc number;
      ngc number;
      nella number;
      un_per number;
      lims number;
    begin
      for s in (
        select * from claim where uniko=uc
      ) loop
          ndp := to_date(to_char(gm,'yyyymm')||'15','yyyymmdd');

          if s.god_spis*100+s.mes_spis < to_char(ndp,'yyyymm') then
            nmc := to_char(gm,'mm');
            ngc := to_char(gm,'yyyy');
            if s.ella<10000000 then
              nella := '5'||lpad(s.mes_spis,2,'0')||lpad(s.ella,6,'0');
            else
              nella := s.ella;
            end if;
          else
            nmc := s.mes_spis;
            ngc := s.god_spis;
            nella := s.ella;
          end if;

          INSERT INTO ASUNZ.CLAIM_AUTO_CHANGES (
            CLAIM_UNIKO, CHDATE, GOD_OLD,
            MES_OLD, GOD_NEW, MES_NEW,
            DATEP_OLD, DATEP_NEW, PRIM, ella_old, ella_new)
          VALUES (s.uniko,sysdate,s.god_spis,s.MES_spis,ngc,nmc,s.date_poluch,
            ndp, 'Автоперенос', s.ella, nella)
          returning unik into un_per;

          update claim set god_spis=ngc, mes_spis=nmc, date_poluch=ndp, ella=nvl(nella, ella)
          , god=to_char(ndp, 'yyyy'), mes=to_char(ndp, 'mm'),
          date_poluch_ish=nvl(date_poluch_ish, date_poluch), status=decode(status,10,0, status)
          where claim.uniko=s.uniko;

          if s_lim=1 then
            if is_budget_limited(s.budget)=1 and nmc<>s.mes_spis then

              if nmc in (4,7,10,1) then
                -- если статья лимитиуемая и перенос - за границу квартала:
                lims := CLAIMS.CHECK_LIMIT(s.zex, s.budg95, ngc, nmc, 0);
                if lims < 0 then
                  -- если в первом месяце следующего квартала стало нехватать денег,
                  -- то взять их из последего месяца квартала
                  insert into limit_budget (god, mes, zex, kod_limit, suma, prim, budg_type, zakspis, date_korr,
                  poksob, unik_perenos)
                  values (ngc, nmc+2, s.zex, budget_limit(s.budget),
                  lims, 'Автоперенос, заявка '||s.uniko,
                  s.budg95, 0, sysdate, 1, un_per);

                  insert into limit_budget (god, mes, zex, kod_limit, suma, prim, budg_type, zakspis, date_korr,
                  poksob, unik_perenos)
                  values (ngc, nmc, s.zex, budget_limit(s.budget),
                  -lims, 'Автоперенос, заявка '||s.uniko,
                  s.budg95, 0, sysdate, 1, un_per);

                  CLAIMS.KILL_CLAIMS_FOR_LIMIT(s.zex, s.budg95, ngc, nmc+2, 0);
                  --если нужно то поубивать заявки в конце квартала которым нехватило
                end if;
              else
                -- статья лимитуремая, но перенос - в рамках квартала - просто взять с собой деньги
                insert into limit_budget (god, mes, zex, kod_limit, suma, prim, budg_type, zakspis, date_korr,
                poksob, unik_perenos)
                values (s.god_spis, s.mes_spis, s.zex, budget_limit(s.budget),
                -s.sum_spis, 'Автоперенос, заявка '||s.uniko,
                s.budg95, 0, sysdate, 1, un_per);

                insert into limit_budget (god, mes, zex, kod_limit, suma, prim, budg_type, zakspis, date_korr,
                poksob, unik_perenos)
                values (ngc, nmc, s.zex, budget_limit(s.budget),
                s.sum_spis, 'Автоперенос, заявка '||s.uniko,
                s.budg95, 0, sysdate, 1, un_per);
              end if;

            end if;
          end if;
      end loop;
    end;

    procedure correct_pos_budget (uo number)
      as
      t number;
    begin
        loop
          select max(nvl(kol_spis,0)) into t from claim where uniko=uo and status>=0;
          select sum(kol)-t into t from pos_budget
          where POS_BUDGET.CLAIM_UNIKO=uo;

          exit when t<=0;

          update pos_budget set kol =
            case
              when kol>t then t
              else kol-t
            end
          where POS_BUDGET.CLAIM_UNIKO=uo and kol>0 and rownum=1;
          --STD.DEBUG_MESSAGE('claims.correct_pos_budget','uc:'||uo||' t:'||t);
        end loop;
    end;

    procedure notify_mails
    as
      p number;
      d date;
      tt varchar2(4000);
      isp_m varchar2(1000);isp_n varchar2(1000);
    begin

      tt := null;
     /* for s in (
        select text_podr(zex,1) z, porz_unik p, count(*) ct
        from claim
        where status=-45
        and kol_spis>0
        group by zex, porz_unik
        order by zex, porz_unik
      ) loop
      exit when length(tt)>3900;
        tt := tt || s.z ||' порц. '||s.p||' число заявок: '||s.ct||'
';
      end loop;

      if length(tt)>2 then
        for s in (
          select distinct PASSW_PROPS.VALUE email from PASSW_MENU, PASSW_PROPS, passw
          where passw_menu.menu_id=66005 and PASSW.UNIK=PASSW_MENU.USR_ID
          and PASSW_PROPS.USR_ID=PASSW_MENU.USR_ID
          and PASSW.UNIK=PASSW_MENU.USR_ID
          and PASSW_PROPS.PROP='email'
        ) loop
            ASUPPP.SEND_EMAIL_FROM_PL_SQL.SEND_EMAIL_WITHOUT_ATTACHMENT(
            'programm_service@mmk.net',
            s.email,
            'Заявки ожидающие согласования (отдел ремонтов)',tt
            );
        end loop;
      end if;*/

      /*tt:='Для получения более детальной информации пройдите по ссылке: '||chr(13)||chr(10)||'http://oas:7778/oasupsp/!psp_sql2xl?id=617&st_w='||to_char('-4')||'&st_s='||to_char('-45');
         for s in (
          select distinct PASSW_PROPS.VALUE email from PASSW_MENU, PASSW_PROPS, passw
          where passw_menu.menu_id=66005 and PASSW.UNIK=PASSW_MENU.USR_ID
          and PASSW_PROPS.USR_ID=PASSW_MENU.USR_ID
          and PASSW.UNIK=PASSW_MENU.USR_ID
          and PASSW_PROPS.PROP='email'
        ) loop
         ASUPPP.SEND_EMAIL_FROM_PL_SQL.SEND_EMAIL_WITHOUT_ATTACHMENT(
          'programm_service@mmk.net',
          s.email,
          'Заявки ожидающие согласования (отдел ремонтов)',tt);
      end loop;*/
        /*
       tt:='Для получения более детальной информации пройдите по ссылке: '||chr(13)||chr(10)||'http://oas:7778/oasupsp/!psp_sql2xl?id=617&st_w='||to_char('-45')||'&st_s='||to_char('-46');
         for s in (
          select distinct PASSW_PROPS.VALUE email from PASSW_MENU, PASSW_PROPS, passw
          where passw_menu.menu_id=66014 and PASSW.UNIK=PASSW_MENU.USR_ID
          and PASSW_PROPS.USR_ID=PASSW_MENU.USR_ID
          and PASSW.UNIK=PASSW_MENU.USR_ID
          and PASSW_PROPS.PROP='email'
        ) loop
         ASUPPP.SEND_EMAIL_FROM_PL_SQL.SEND_EMAIL_WITHOUT_ATTACHMENT(
          'programm_service@mmk.net',
          s.email,
          'Заявки ожидающие согласования (УТНД)',tt);
      end loop;
        */
        
     for sl IN (
       /* select distinct slug_sogl,
        decode(slug_sogl, 69600, decode(kod_grp, 154,2,1),0) m
        from claim where status=-91*/
         select distinct slug_sogl,
        --decode(slug_sogl, 69600, decode(kod_grp, 154,2,1),0) m
        0 as m
        from claim where status=-91
        union all select distinct slug_sogl,decode(slug_sogl, 69600, decode(kod_grp, 154,2,1),0) m
        from claim where slug_sogl=69600 and status=-91
      ) loop
        tt := null;
        for s in (
         /* select text_podr(zex) z, porz_unik p,
          count(*) ct
          from claim
          where status=-91 and slug_sogl=sl.slug_sogl
          and decode(sl.slug_sogl, 69600, decode(kod_grp, 154,2,1),0)=sl.m
          group by zex, porz_unik, decode(sl.slug_sogl, 69600, decode(kod_grp, 154,2,1),0)
          order by zex, porz_unik*/
         select text_podr(zex) z, porz_unik p,
          count(*) ct
          from claim
          where status=-91 and slug_sogl=sl.slug_sogl
          and decode(sl.slug_sogl, 69600, decode(sl.m,0,0,decode(kod_grp, 154,2,1)),0)=sl.m
          group by zex, porz_unik,decode(sl.slug_sogl, 69600, decode(sl.m,0,0,decode(kod_grp, 154,2,1)),0)
          order by zex, porz_unik 
          
        ) loop
          tt := tt || s.z ||' порц. '||s.p||' число заявок: '||s.ct||'
  ';
        end loop;

        if length(tt)>2 then
          for se in (
            select distinct PASSW_PROPS.VALUE email from PASSW_MENU, PASSW_PROPS, passw
            where passw_menu.menu_id=66020 and PASSW.UNIK=PASSW_MENU.USR_ID
            and PASSW.CEX=sl.slug_sogl  and PASSW.CEX<>69600
            and PASSW_PROPS.USR_ID=PASSW_MENU.USR_ID
            and PASSW.UNIK=PASSW_MENU.USR_ID
            and PASSW_PROPS.PROP='email'
           /* union all
            select 'oleg.merkulov@ilyichsteel.com' from dual where sl.slug_sogl=69600 and sl.m=1*/
            union all
            select 'vadim.shopin@ilyichsteel.com' from dual where sl.slug_sogl=69600 and sl.m=0
            union all
            select 'oleg.merkulov@ilyichsteel.com' from dual where sl.slug_sogl=69600 and sl.m=1
            union all
            select 'Vasiliy.Khudoleev@ilyichsteel.com' from dual where sl.slug_sogl=69600 and sl.m=1
            union all
            select 'marina.miroshnichenk@ilyichsteel.com' from dual where sl.slug_sogl=69600 and sl.m=2
          ) loop
              ASUPPP.SEND_EMAIL_FROM_PL_SQL.SEND_EMAIL_WITHOUT_ATTACHMENT(
              'programm_service@mmk.net',
              se.email,
              'Заявки ожидающие согласования (служба по направлению)',tt
              );
          end loop;
        end if;

      end loop;


             for q in (select distinct notd, isp from claim where uniko in (select uniko from claim_st_hist where (status=33) and to_date(stat,'dd.mm.yyyy')=to_date(sysdate-1,'dd.mm.yyyy')))
               loop
                      tt:=null;
                    /*   for w in (select c.num_zakup, h.uniko, h.prich from claim_st_hist h, claim c where c.notd=q.notd and c.isp=q.isp and  c.uniko=h.uniko and  status_was=13 and h.status=301 and to_date(stat,'dd.mm.yyyy')=to_date(sysdate-1,'dd.mm.yyyy') order by 1,2)
                        loop
                                  tt := tt ||' на стадии "приостановлена" № заявки на закупку: '||w.num_zakup||' № заявки: '||w.uniko||' по причине '||w.prich||chr(13)||chr(10);
                       end loop;*/
                        for w in (select c.num_zakup, h.uniko, h.prich from claim_st_hist h, claim c where c.notd=q.notd and c.isp=q.isp and  c.uniko=h.uniko and  h.status=33  and to_date(stat,'dd.mm.yyyy')=to_date(sysdate-1,'dd.mm.yyyy') order by 1,2)
                        loop
                                  tt := tt ||' на стадии "отказать СЗ" № заявки на закупку: '||w.num_zakup||' № заявки: '||w.uniko||' отклонена по причине '||w.prich||chr(13)||chr(10);
                       end loop;           
                          for ss in (
                                       select OTVET.EMAIL_MMK,otvet.email_boss from otvet where 
                                       otvet.kod=q.notd and otvet.kodfam=q.isp
                                       and email_mmk is not null
                                    ) loop
                                      ASUPPP.SEND_EMAIL_FROM_PL_SQL.SEND_EMAIL_WITHOUT_ATTACHMENT(
                                      'programm_service@mmk.net',
                                      ss.email_mmk||','||ss.email_boss,
                                      -- 'olga.yakushenko@ilyichsteel.com',
                                      'Заявки, отклоненные СЗ ',
                                        tt||chr(13)||chr(10)
                                      );
                                    end loop;
                end loop;
                
                            for q in (select distinct isp_sz from claim where status in (11,13,16))
               loop
               tt:=null;
                     for w in (select claims.status_text(status) as st,  num_zakup, count(uniko) as count_u from claim where isp_sz=q.isp_sz and status in (11,13,16) group by isp_sz,claims.status_text(status),  num_zakup order by 1,2,3)
                          loop
                                  tt := substr(tt || w.st ||' № заявки на закупку: '||w.num_zakup||' число заявок: '||w.count_u||chr(13)||chr(10),1,4000);
                          end loop;
                          select email,fam||' '||name||' '||otch into isp_m,isp_n from kadr where unink=q.isp_sz;
                           ASUPPP.SEND_EMAIL_FROM_PL_SQL.SEND_EMAIL_WITHOUT_ATTACHMENT(
                           'programm_service@mmk.net',
                          isp_m,
                         -- 'olga.yakushenko@ilyichsteel.com',
                           'Заявки на исполнителе СЗ '||isp_n,tt||chr(13)||chr(10));
               end loop;
    /*
      for s in (
        select distinct tmc, to_char(date_poluch,'yyyymm') d, notd, isp
        from claim where status=-4
      ) loop
       select count(*), max(last_notify) into p, d
       from spr_tmc_price_mes
       where tmc=s.tmc and s.d=god*100+mes;

       if p=0 then
         insert into spr_tmc_price_mes (god, mes, tmc, price_exp)
         values (substr(s.d,1,4), substr(s.d,5,2), s.tmc, 0);
       else
         if sysdate-d > 1 then
            for ss in (
               select OTVET.EMAIL_MMK from otvet where
               otvet.kod=s.notd and otvet.kodfam=s.isp
               and email_mmk is not null
            ) loop
              ASUPPP.SEND_EMAIL_FROM_PL_SQL.SEND_EMAIL_WITHOUT_ATTACHMENT(
              'programm_service@mmk.net',
              ss.email_mmk,
              'Цены',
--                'Цех: '||s.zex||' '||text_podr(s.zex)||chr(13)||chr(10)
--                ||s.tmc||' '||text_tmc(s.tmc)||chr(13)||chr(10)
--                ||'Дата получения: '||s.date_poluch||chr(13)||chr(10)
--                ||'Кол-во: '||s.kol
' '
              );
            end loop;
         end if;
       end if;

      end loop;
     */
     null;
    end;

    function zk_now(cl_date date, d date default sysdate) return number
    -- идёт ли сейчас (или в указанную дату) заявочная кампания; 0 - нет; 1 - да
    as
    n number;
    begin
     select count(*) into n from claim_grafik where  to_char(cl_date,'q')||to_char(cl_date,'yyyy')=kv||god and d between date_zagr_n and (date_zagr_k+1);
      if n>0 then
       --add_months(trunc(cl_date,'q'),-2)-1 and add_months(trunc(cl_date,'q'),-2)+15 then
        return 1;
      else
        return 0;
      end if;
    end;

    function auto_close_by_cpp(uo number, ch number default 0, p_tmc number default null, p_kol number default null, p_tip number default 0) return number
    as
      k number;
      kk number;
      kkk number:=0;
      fr number;
      ptmc number;
    begin
      return claims_auto_close_by_cpp(uo, ch, p_tmc, p_kol,p_tip);
      /*
      if uo>0 then
        select nvl(kol_spis,0)-nvl(kol_sklad,0), tmc into k, ptmc from claim where uniko=uo;
        if k=0 then
          return null;
        end if;
      else
        ptmc := p_tmc;
      end if;

      for z in (
        select ptmc tmc, 1 k, 0 z from dual
        union all
        select tmc_zamena tmc, koeff, UNIK z from SPR_TMC_ZAMENA
        where tmc_zak=ptmc and nvl(state,0)=0
      ) loop

        for s in (
          select o.sklad, o.nnom, o.kod_grp, o.kod_pgr, o.kod_nn, o.izgot, o.invn,
          o.price, nvl(c.kol_spis, p_kol)*Z.K kol_spis, c.budget, c.zex, c.notd, c.isp, o.tmc, o.kol,
          o.ed
          from ostat o, (select z.tmc a, claim.* from claim where claim.uniko=uo) c, spr_tmc ss
          where
          z.tmc=o.tmc
          and o.tmc=ss.unik
          and o.tmc=c.a(+)
          and ss.ed=o.ed
          and (is_sklad_cpp(o.sklad)=1 ) -- or (c.zex=69600 and o.sklad=71100))
          and o.kol>0
          order by o.kol asc
        ) loop

          select nvl(sum(nvl(kol,0)-nvl(kol_vyd,0)),0) into k from psop_pos_view
          where
          tmc=s.tmc and kod_grp=s.kod_grp
          and kod_pgr=s.kod_pgr and kod_nn=s.kod_nn
          and price=s.price and nnom=s.nnom and ed=s.ed
          and nvl(izgot,0)=nvl(s.izgot,0)
          and nvl(invn,0)=nvl(s.invn,0)
          and sklad=s.sklad --? 16/07/2012
          and kol>kol_vyd;

          kk:=nvl(k,0) - nvl(kkk,0);

          if kk<0 then kk := 0; end if;

          fr := s.kol-kk;

          if fr>s.kol then fr:=s.kol; end if;
          if fr<0 then fr:=0; end if;

          if fr>=s.kol_spis then
            --
            if ch=0 then
              if z.z>0 then
                update claim
                set
                  price=s.price,
                  sum_spis=s.price*kol_spis,
                  kol_spis=s.kol_spis,
                  snp_zamena=z.z,
                  tmc=z.tmc,
                  tip=2
                  where uniko=uo;
              else
                update claim set price=s.price, sum_spis=s.price*kol_spis, tip=2 where uniko=uo;
              end if;

              insert into psop_pos (sklad, unik_claim,unik_pos,kol,kol2,budget,zex,tmc,unik_sop,notd,isp,
              kod_grp,kod_pgr,kod_nn,price,nnom,
              stat1,stat2, invn, izgot, ed)
              values (s.sklad, uo,1,s.kol_spis,s.kol_spis,s.budget,s.zex,s.tmc,1,s.notd,s.isp,
              s.kod_grp,s.kod_pgr,s.kod_nn,s.price,s.nnom,
              'автоматическое закрытие с ЦC',sysdate, s.invn, s.izgot, s.ed);
            end if;

            return s.price;
          end if;
        end loop;
      end loop;
      if ch=0 then
        update claim set tip=0 where uniko=uo;
      end if;
      return null;
      */
    end;


     procedure auto_close_by_cpp_zex(uo number, ch number default 0)
    as
      k number;
      kk number;
      kkk number:=0;
      fr number;
    begin
      claims_auto_close_by_cpp_zex(uo, ch);
      return;
      /*
      select nvl(kol_spis,0)-nvl(kol_sklad,0) into k from claim where uniko=uo;
      if k=0 then
        return;
      end if;

      for s in (
        select o.sklad, o.nnom, o.kod_grp, o.kod_pgr, o.kod_nn, o.izgot, o.invn,
        o.price, c.kol_spis, c.budget, c.zex, c.notd, c.isp, c.tmc, o.kol,
        o.ed from ostat o, claim c
        where c.uniko=uo
        and c.tmc=o.tmc
        and c.ed=o.ed
        and c.price=o.price
        and c.kod_grp=o.kod_grp and c.kod_pgr=o.kod_pgr and c.kod_nn=o.kod_nn
        and o.sklad=claims.sklad_cpp_on_zex(claims.get_zex(uo))  --(is_sklad_cpp(o.sklad)=1 or (c.zex=69600 and o.sklad=71100))
        and o.kol>0 and nvl(c.tip,0)=1
        order by nnom asc, kol asc
      ) loop

        select nvl(sum(nvl(kol,0)-nvl(kol_vyd,0)),0) into k from psop_pos_view
        where
        tmc=s.tmc and kod_grp=s.kod_grp
        and kod_pgr=s.kod_pgr and kod_nn=s.kod_nn
        and price=s.price and nnom=s.nnom and ed=s.ed
        and nvl(invn,0)=nvl(s.invn,0)
        and nvl(izgot,0)=nvl(s.izgot,0) and sklad=s.sklad
        and kol>kol_vyd;
      --  kk:=nvl(k,0) - nvl(kkk,0);

       -- if kk<0 then kk := 0; end if;

        fr := s.kol-k;

        if fr>s.kol then fr:=s.kol; end if;
        if fr<0 then fr:=0; end if;

        if fr>=s.kol_spis then
          --
        --  if ch=0 then
            insert into psop_pos (sklad, unik_claim,unik_pos,kol,kol2,budget,zex,tmc,unik_sop,notd,isp,
            kod_grp,kod_pgr,kod_nn,price,nnom,
            stat1,stat2, invn, izgot, ed)
            values (s.sklad, uo,1,s.kol_spis,fr,s.budget,s.zex,s.tmc,1,s.notd,s.isp,
            s.kod_grp,s.kod_pgr,s.kod_nn,s.price,s.nnom,
            'автоматическое закрытие с цехового склада '||s.sklad,sysdate, s.invn, s.izgot, s.ed);
          --end if;

        --  update claim set sum_spis=s.price*kol_spis where uniko=uo;

          return;
        end if;
      end loop;
     -- update claim set tip=0 where uniko=uo;
     */
    end;

    function tip_text(t number) return varchar2
     as
    begin
      if    t = 0 then return 'Закупка';
      elsif t = 1 then return 'Списание со склада цеха';
      elsif t = 2 then return 'Списание с центрального склада';
      elsif t = 3 then return 'Списание с неснижаемого запаса';
      end if;
      return '?';
    end;

    function mol_slugba(p_zex number, p_mol number) return number parallel_enable
     as
    begin
      for s in (
        select slugba s
        from tmc_poluch
        where substr(zex,1,3)||kod = substr(p_zex,1,3)||p_mol
      ) loop
        return s.s;
      end loop;
      return null;
    end;

    function slug_sogl_snp(p_snp number) return number
      as
    begin
      for s in (
        select slug from claim_sogl_snp where snp=p_snp
      ) loop
        return s.slug;
      end loop;

      for s in (
        SELECT slug from CLAIM_SOGL_SNP, spr_tmc where unik=p_snp and kod_grp=grp and kod_PGR=pgr
        and CLAIM_SOGL_SNP.SNP is null
      ) loop
        return s.slug;
      end loop;

      for s in (
        SELECT slug from CLAIM_SOGL_SNP, spr_tmc where unik=p_snp and kod_grp=grp and pgr is null
      ) loop
        return s.slug;
      end loop;

      return null;
    end;

    function check_normativ_ost_grn(p_zex number, p_godp number, p_mesp number,
      p_sum_spistm number
    -- сумма списания по заявке в том же месяце ( должна быть 0 для псо и 0 если списание в другом месяце)
    )
     return number as
     normativ number;
     gmbuh number;
     fakt number;
     faktcpp number;
     plan_sp number;
     plan_pol number;
     plan_sp_hs number;
     plan_pol_hs number;
     no_ost1 number;
     no_ost0 number;no_ost2 number;
     ost number;
    begin
       if p_zex in (66600,66700,66800,66900,67000,67100,67200) then

        select nvl(sum(suma),0) into normativ
        from zex_norm_ost_grn
        where
         zex in (66600,66700,66800,66900,67000,67100,67200)
         and god*100+mes<=p_godp*100+p_mesp
         and nvl(god_po*100+mes_po, 999999)>=p_godp*100+p_mesp ;

          select min(gmbuh) into gmbuh from (
          select max(GOD*100+mes) as  gmbuh,zex  from SKLAD_BLOCK4normativ
          where  zex in (666,667,668,669,670,671,672)
          and SKLAD_BLOCK4normativ.STATE=1 group by zex);

           SELECT nvl(SUM(suma),0)  into fakt
           FROM tmc_ost_obor4normativ
           WHERE god * 100 + mes = gmbuh and
           zex in (666,667,668,669,670,671,672);

           select nvl(sum(su),0)
           into faktcpp
           from zex_sum_ost_cpp
           where  zex in (66600,66700,66800,66900,67000,67100,67200)
           and god*100+mes=to_char(add_months(to_date(gmbuh,'yyyymm'),0),'yyyymm');

           /*select nvl(sum(kol*avg_price),0) into no_ost1 from ostat  where rezdok=1 and substr(sklad,1,3)  in (666,667,668,669,670,671,672)  and kol>0;
           select nvl(sum(kol*avg_price),0) into no_ost0 from ostat   where rezdok=0 and substr(sklad,1,3)=izgot and nvl(claim_uniko,0)>0
           and substr(sklad,1,3)  in (666,667,668,669,670,671,672)       and kol>0;*/
           
           select nvl(sum(kol*decode(claims.zex_comp(sklad),1,avg_price,price)),0) into no_ost1  from ostat  where rezdok=1 and substr(sklad,1,3)  in (666,667,668,669,670,671,672)  and kol>0;   
                    
           select nvl(sum((nvl(kol2,0)-nvl(kol_vyd,0))*decode(claims.zex_comp(o.sklad),1,avg_price,o.price)),0)  into no_ost0
           from ostat o,psop_pos s   where o.rezdok=1 and substr(o.sklad,1,3)  in (666,667,668,669,670,671,672) and o.kol>0 and o.unik=s.ostat_unik and substr(s.zex,1,3) not in (666,667,668,669,670,671,672) and kol2>0;
           
           select nvl(sum((nvl(kol2,0)-nvl(kol_vyd,0))*decode(claims.zex_comp(o.sklad),1,avg_price,o.price)),0)  into no_ost2
           from ostat o,psop_pos s   where o.rezdok=1 and substr(o.sklad,1,3)  in (666,667,668,669,670,671,672) and o.kol>0 and o.unik=s.ostat_unik and substr(s.zex,1,3) in (666,667,668,669,670,671,672) and kol2>0;
           
           ost:=nvl(fakt,0)-nvl(no_ost0,0)-nvl(no_ost2,0);
           no_ost1:=nvl(no_ost1,0)-nvl(no_ost2,0)-nvl(no_ost0,0);  
           
              select nvl(sum(decode(tip,3,nvl(kol*price_ost,0),nvl(kol_isp*price,0))),0) +nvl(p_sum_spistm,0)
              into plan_sp_hs
              from claim_hs c,hs_price h
              where
              c.shifr_snp=h.tmc(+) and  extract(year from data_pol)=h.god(+) and  extract(month from data_pol)=h.mes(+) 
              and god_sp*100+mes_sp between to_char(add_months(to_date(gmbuh,'yyyymm'),0),'yyyymm')
              and p_godp*100+p_mesp --and zex=p_zex
              and zex in (66600,66700,66800,66900,67000,67100,67200)
             -- and substr(nvl(zex_poluch,1),1,1)<>7
              and  (status>=0)
              --and TMC_IS_OS(tmc)=0 and TMC_IS_USLUGI(tmc)=0
              and kod_st_zat not in (1,6,11,15,16,14)
              and budg<>100
              and spr_hs_vid(shifr_snp)<>2
              and (TMC_IS_OS(shifr_snp)=0 or TMC_IS_OS(shifr_snp) is null) and (TMC_IS_USLUGI(shifr_snp)=0 or TMC_IS_USLUGI(shifr_snp) is null);
              
               select nvl(sum((decode(tip,3,nvl(kol*price_ost,0),nvl(kol_isp*price,0)))*
                (case
                  when kol_isp <= kol_sklad then 0
                  when kol_sklad is null or kol_sklad=0 then 1
                  else (kol_isp-kol_sklad)/kol_isp
                end)
              ),0)+nvl(p_sum_spistm,0)
              into plan_pol_hs
              from claim_hs c,hs_price h
              where
               c.shifr_snp=h.tmc(+) and  extract(year from data_pol)=h.god(+) and  extract(month from data_pol)=h.mes(+) 
              and to_char(data_pol,'yyyymm') between to_char(add_months(to_date(gmbuh,'yyyymm'),0),'yyyymm')
              and p_godp*100+p_mesp --and zex=p_zex
              and zex in (66600,66700,66800,66900,67000,67100,67200)
              and  (status>=0) 
             -- and TMC_IS_OS(tmc)=0 and TMC_IS_USLUGI(tmc)=0
              and kod_st_zat not in (6,11,15,16,14)
              and budg<>100
              and spr_hs_vid(shifr_snp)<>2
              and (TMC_IS_OS(shifr_snp)=0 or TMC_IS_OS(shifr_snp) is null) and (TMC_IS_USLUGI(shifr_snp)=0 or TMC_IS_USLUGI(shifr_snp) is null);
              
                    select nvl(sum(sum_spis),0)+nvl(p_sum_spistm,0)
                      into plan_sp
                      from claim
                      where
                      god_spis*100+mes_spis between to_char(add_months(to_date(gmbuh,'yyyymm'),0),'yyyymm')
                      and p_godp*100+p_mesp and zex=66600
                     -- and substr(nvl(zex_poluch,1),1,1)<>7
                      and ( (status>=0) or (status in (-45,-5,-7,-91,-6,-44,-46,-14,-15,-16)))
                      and TMC_IS_OS(tmc)=0 and TMC_IS_USLUGI(tmc)=0
                      and budget not in (1,6,11,15,16,14);
                      
                            select nvl(sum(sum_spis*
                            (case
                              when kol_spis <= kol_sklad then 0
                              when kol_sklad is null or kol_sklad=0 then 1
                              else (kol_spis-kol_sklad)/kol_spis
                            end)
                          ),0)+nvl(p_sum_spistm,0)
                          into plan_pol
                          from claim
                          where
                          to_char(date_poluch,'yyyymm') between to_char(add_months(to_date(gmbuh,'yyyymm'),0),'yyyymm')
                          and p_godp*100+p_mesp and zex=66600
                          and ( (status>=0) or (status in (-45,-5,-7,-91,-6,-44,-46,-14,-15,-16)))
                          and TMC_IS_OS(tmc)=0 and TMC_IS_USLUGI(tmc)=0
                          and (select count(*) from claim a where a.zex_poluch=p_zex
                                      and to_char(a.date_poluch,'yyyymm')=p_godp*100+p_mesp and budget=14
                                      and a.tmc=claim.tmc)=0
                          and budget not in (6,11,15,16,14);

       else

           select nvl(sum(suma),0) into normativ
           from zex_norm_ost_grn
           where zex=p_zex
           and god*100+mes<=p_godp*100+p_mesp
           and nvl(god_po*100+mes_po, 999999)>=p_godp*100+p_mesp ;

           select max(GOD*100+mes) into gmbuh from SKLAD_BLOCK4normativ
           where
           zex=decode(substr(p_zex,4,2),00,substr(p_zex,1,3),p_zex)
           and SKLAD_BLOCK4normativ.STATE=1;

            SELECT nvl(SUM(suma),0)  into fakt
            FROM tmc_ost_obor4normativ
            WHERE god * 100 + mes = gmbuh and
            zex=decode(substr(p_zex,4,2),00,substr(p_zex,1,3),p_zex);

           select nvl(sum(su),0)  into faktcpp
           from zex_sum_ost_cpp
           where  zex=p_zex
           and god*100+mes=to_char(add_months(to_date(gmbuh,'yyyymm'),0),'yyyymm');

          /* select nvl(sum(kol*decode(claims.zex_comp(sklad),1,avg_price,price)),0) into no_ost1 from ostat
           where rezdok=1 and substr(sklad,1,3)=substr(p_zex,1,3)  and kol>0;
           select nvl(sum(kol*decode(claims.zex_comp(sklad),1,avg_price,price)),0) into no_ost0 from ostat
           where rezdok=0 and substr(sklad,1,3)=izgot and nvl(claim_uniko,0)>0 and substr(sklad,1,3)=substr(p_zex,1,3) and kol>0;*/
           select nvl(sum(kol*decode(claims.zex_comp(sklad),1,avg_price,price)),0) into no_ost1  from ostat  where rezdok=1 and substr(sklad,1,3)=substr(p_zex,1,3) and kol>0;   
           
           select nvl(sum((nvl(kol2,0)-nvl(kol_vyd,0))*decode(claims.zex_comp(o.sklad),1,avg_price,o.price)),0)  into no_ost0
           from ostat o,psop_pos s   where o.rezdok=1 and substr(o.sklad,1,3)=substr(p_zex,1,3) and o.kol>0 and o.unik=s.ostat_unik and substr(s.zex,1,3)<>substr(o.sklad,1,3) and kol2>0;    
                  
           select nvl(sum((nvl(kol2,0)-nvl(kol_vyd,0))*decode(claims.zex_comp(o.sklad),1,avg_price,o.price)),0)  into no_ost2
           from ostat o,psop_pos s   where o.rezdok=1 and substr(o.sklad,1,3)=substr(p_zex,1,3) and o.kol>0 and o.unik=s.ostat_unik and substr(s.zex,1,3)=substr(o.sklad,1,3) and kol2>0;
           
           ost:=nvl(fakt,0)-nvl(no_ost0,0)-nvl(no_ost2,0);
           no_ost1:=nvl(no_ost1,0)-nvl(no_ost2,0) - nvl(no_ost0,0);        
           
            select nvl(sum(decode(tip,3,nvl(kol*price_ost,0),nvl(kol_isp*price,0))),0) +nvl(p_sum_spistm,0)
              into plan_sp_hs
              from claim_hs c,hs_price h
              where
              c.shifr_snp=h.tmc(+) and  extract(year from data_pol)=h.god(+) and  extract(month from data_pol)=h.mes(+) 
              and god_sp*100+mes_sp between to_char(add_months(to_date(gmbuh,'yyyymm'),0),'yyyymm')
              and p_godp*100+p_mesp and zex=p_zex
             -- and zex in (66600,66700,66800,66900,67000,67100,67200)
             -- and substr(nvl(zex_poluch,1),1,1)<>7
              and (status>=0)
              --and TMC_IS_OS(tmc)=0 and TMC_IS_USLUGI(tmc)=0
              and kod_st_zat not in (1,6,11,15,16,14)
              and budg<>100
              and spr_hs_vid(shifr_snp)<>2
              and (TMC_IS_OS(shifr_snp)=0 or TMC_IS_OS(shifr_snp) is null) and (TMC_IS_USLUGI(shifr_snp)=0 or TMC_IS_USLUGI(shifr_snp) is null);
              
               select nvl(sum((decode(tip,3,nvl(kol*price_ost,0),nvl(kol_isp*price,0)))*
                (case
                  when kol_isp <= kol_sklad then 0
                  when kol_sklad is null or kol_sklad=0 then 1
                  else (kol_isp-kol_sklad)/kol_isp
                end)
              ),0)+nvl(p_sum_spistm,0)
              into plan_pol_hs
              from claim_hs c,hs_price h
              where
               c.shifr_snp=h.tmc(+) and  extract(year from data_pol)=h.god(+) and  extract(month from data_pol)=h.mes(+) 
              and to_char(data_pol,'yyyymm') between to_char(add_months(to_date(gmbuh,'yyyymm'),0),'yyyymm')
              and p_godp*100+p_mesp and zex=p_zex
              --and zex in (66600,66700,66800,66900,67000,67100,67200)
              and  (status>=0)
             -- and TMC_IS_OS(tmc)=0 and TMC_IS_USLUGI(tmc)=0
              and kod_st_zat not in (6,11,15,16,14)
              and budg<>100
              and spr_hs_vid(shifr_snp)<>2
              and (TMC_IS_OS(shifr_snp)=0 or TMC_IS_OS(shifr_snp) is null) and (TMC_IS_USLUGI(shifr_snp)=0 or TMC_IS_USLUGI(shifr_snp) is null);
              
                    select nvl(sum(sum_spis),0)+nvl(p_sum_spistm,0)
                      into plan_sp
                      from claim
                      where
                      god_spis*100+mes_spis between to_char(add_months(to_date(gmbuh,'yyyymm'),0),'yyyymm')
                      and p_godp*100+p_mesp and zex=p_zex
                     -- and substr(nvl(zex_poluch,1),1,1)<>7
                      and ( (status>=0) or (status in (-45,-5,-7,-91,-6,-44,-46,-14,-15,-16)))
                      and TMC_IS_OS(tmc)=0 and TMC_IS_USLUGI(tmc)=0
                      and budget not in (1,6,11,15,16,14);
                      
                  select nvl(sum(sum_spis*
                    (case
                      when kol_spis <= kol_sklad then 0
                      when kol_sklad is null or kol_sklad=0 then 1
                      else (kol_spis-kol_sklad)/kol_spis
                    end)
                  ),0)+nvl(p_sum_spistm,0)
                  into plan_pol
                  from claim
                  where
                  to_char(date_poluch,'yyyymm') between to_char(add_months(to_date(gmbuh,'yyyymm'),0),'yyyymm')
                  and p_godp*100+p_mesp and zex=p_zex
                  and ( (status>=0) or (status in (-45,-5,-7,-91,-6,-44,-46,-14,-15,-16)))
                  and TMC_IS_OS(tmc)=0 and TMC_IS_USLUGI(tmc)=0
                  and (select count(*) from claim a where a.zex_poluch=p_zex
                              and to_char(a.date_poluch,'yyyymm')=p_godp*100+p_mesp and budget=14
                              and a.tmc=claim.tmc)=0
                  and budget not in (6,11,15,16,14);

       end if;
/*
      select nvl(sum(sum_spis),0)+nvl(p_sum_spistm,0)
      into plan_sp
      from claim
      where
      god_spis*100+mes_spis between to_char(add_months(to_date(gmbuh,'yyyymm'),0),'yyyymm')
      and p_godp*100+p_mesp and zex=p_zex
     -- and substr(nvl(zex_poluch,1),1,1)<>7
      and ( (status>=0) or (status in (-45,-5,-7,-91,-6,-44,-46)))
      and TMC_IS_OS(tmc)=0 and TMC_IS_USLUGI(tmc)=0
      and budget not in (1,6,11,15,16,14);*/

    /*   select nvl(sum(suma_normzap),0)+nvl(p_sum_spistm,0)
      into plan_sp
      from claim_limbudg_fakt
      where
      god*100+mes between to_char(add_months(to_date(gmbuh,'yyyymm'),0),'yyyymm')
      and p_godp*100+p_mesp and zex=p_zex
     -- and substr(nvl(zex_poluch,1),1,1)<>7
      and budget not in (1,6,11,15,16,14);
      */

     /* select nvl(sum(sum_spis*
        (case
          when kol_spis <= kol_sklad then 0
          when kol_sklad is null or kol_sklad=0 then 1
          else (kol_spis-kol_sklad)/kol_spis
        end)
      ),0)+nvl(p_sum_spistm,0)
      into plan_pol
      from claim
      where
      to_char(date_poluch,'yyyymm') between to_char(add_months(to_date(gmbuh,'yyyymm'),0),'yyyymm')
      and p_godp*100+p_mesp and zex=p_zex
      and ( (status>=0) or (status in (-45,-5,-7,-91,-6,-44,-46)))
      and TMC_IS_OS(tmc)=0 and TMC_IS_USLUGI(tmc)=0
      and (select count(*) from claim a where a.zex_poluch=p_zex
                  and to_char(a.date_poluch,'yyyymm')=p_godp*100+p_mesp and budget=14
                  and a.tmc=claim.tmc)=0
      and budget not in (6,11,15,16,14);*/

      /*
      STD.DEBUG_MESSAGE('check_normativ_ost_grn', 'norm '||normativ ||' fakt '||fakt
      ||' cpp '||faktcpp||' plansp '|| plan_sp||' planpol '||plan_pol);
      */

      --return normativ - (fakt +faktcpp - plan_sp + plan_pol - plan_sp_hs + plan_pol_hs) - nvl(no_ost1,0) + nvl(no_ost0,0);
      return normativ - (ost +faktcpp - plan_sp + plan_pol - plan_sp_hs + plan_pol_hs);
    end;
    procedure fill_zex_sum_ost_cpp
     as
    begin
      delete from zex_sum_ost_cpp where god*100+mes=to_char(sysdate,'yyyymm');

      insert into zex_sum_ost_cpp
      (zex, sklad, god, mes, su)
      select zex, sklad, to_char(sysdate,'yyyy'), to_char(sysdate,'mm'), sum(su)
      from ZEX_OSTLIM_SUM
      group by zex, sklad;
    end;

    function get_ap_date return date
     as
    begin
      return nvl(ap_date,sysdate);
    end;
    
    procedure set_ap_date(d date)
     as
    begin
      ap_date := d;
    end;
  
    function get_ap_dogon return number
     as
    begin
      return nvl(ap_dogon,0);
    end;
    
    procedure set_ap_dogon(d number)
     as
    begin
      ap_dogon := d;
    end;
    
    procedure ap_init
     as
    begin
      for q in (
        select * from CLAIM_AUTOPERENOS_SETTINGS
      ) loop
        if q.next_time - sysdate < q.secondary_date-sysdate then
         CLAIMS.SET_AP_DATE(q.next_time);
         CLAIMS.SET_AP_DOGON(0);
        else
         CLAIMS.SET_AP_DATE(add_months(q.secondary_date,-1));
         CLAIMS.SET_AP_DOGON(1);
        end if;
      end loop;
    end;
    
function otd_neisp(uo number) return varchar2 as          -- отделение неисполенной части
    cl claim%rowtype;
    kk number;
    r varchar2(1000);
        begin
            select * into cl from claim where uniko=uo;
            claims.temp_uo := null;
            kk := nvl(cl.kol_spis,0) - nvl(cl.kol_dog,0);
            select kk - nvl(sum(kol2),0) into kk from psop_pos where unik_sop=1 and unik_claim=cl.uniko and nvl(unik_raspr_p,0)=0;
            if kk<=0 then
                r := 'Всё количество по заявке - в исполнении';
                elsif  nvl(kk,0)=nvl(cl.kol_spis,0) then r := 'Заявка не исполнена - нечего отделять';
                else
                if cl.sum_spis>0 then
                  cl.sum_spis := cl.sum_spis/cl.kol_spis * kk;
                end if;  
                cl.kol_spis := kk;
                cl.kol := kk;
                cl.kol_sklad := 0;
                cl.kol_dog := 0;
                cl.kol_vyd := 0;
                cl.prichina:=null;
                select ASUNZ.SQ_CLAIM.nextval into cl.uniko from dual;
                claims.temp_uo := cl.uniko;
                
                insert into CLAIM values cl;
                INSERT INTO ASUNZ.CLAIM_ST_HIST (UNIKO, STATUS, WHO,STAT, PRICH, STATUS_WAS) 
                VALUES (cl.uniko, cl.status, null,sysdate,'Отделение неисполненной части от №'||uo,cl.status);
                  
                update claim
                set kol_spis=kol_spis-kk, kol=kol-kk,
                sum_spis=sum_spis-cl.sum_spis,
                status=decode(kol_sklad, kol_spis, 6, status)
                where uniko=uo;
                    
                 INSERT INTO ASUNZ.CLAIM_ST_HIST (UNIKO, STATUS, WHO, STAT, PRICH, STATUS_WAS) 
                 select uniko, status, null, sysdate, 'Отделенна неисполненная часть в №'||cl.uniko, cl.status from CLAIM where uniko=uo;
            end if;
return r;
end;
procedure otd_nedop(uo number)  as          -- отделение недопоставленной (но законтрактованной) части заявки
    cl claim%rowtype;
    pb_rt pos_budget%rowtype;
    kk number;
        begin
            claims.temp_uo := null;
          
              for d in (
                select pos_budget.unik, pos_budget.kol, pos.unik_d,
                  pos_budget.kol - (
                    select nvl(sum(nvl(psop_pos.kol,0)),0)
                    from psop_pos, psop
                    where psop_pos.unik_pos=psop.unik_pos
                    and PSOP_POS.UNIK_CLAIM=uo
                    and PSOP.UNIK_DOG=pos_budget.unik
                    and PSOP.PSOP_VIRT is null              
                  ) os
                from pos_budget, pos
                where POS_BUDGET.CLAIM_UNIKO=uo
                and POS_BUDGET.unik=POS.unik
              ) loop
                if d.os>0 then
                  select * into cl from claim where uniko=uo;
                  
                  kk := d.os;
                 if nvl(cl.kol_spis,0)>nvl(kk,0) then begin
                      if cl.sum_spis>0 then
                        cl.sum_spis := cl.sum_spis/cl.kol_spis * kk;
                      end if;  
                      cl.kol_spis := kk;
                      cl.kol := kk;
                      cl.kol_sklad := 0;
                      cl.kol_dog := 0;
                      cl.kol_vyd := 0;
                      cl.prichina:=null;                  
                      select ASUNZ.SQ_CLAIM.nextval into cl.uniko from dual;
                                                                                
                      insert into CLAIM values cl;

                      select * into pb_rt from pos_budget where unik=d.unik and claim_uniko=uo;
                      pb_rt.claim_uniko := cl.uniko;
                      pb_rt.kol := kk;
                      insert into pos_budget values pb_rt;
                      update pos_budget set kol=kol-kk where unik=d.unik and claim_uniko=uo;
                      
                      INSERT INTO ASUNZ.CLAIM_ST_HIST (UNIKO, STATUS, WHO, STAT, PRICH, STATUS_WAS) 
                      VALUES (cl.uniko, cl.status, null, sysdate,'Отделение недопоставки по дог.'||d.unik_d||'('||d.unik||')'||' от №'||uo, cl.status);
                                    
                      update claim
                      set kol_spis=kol_spis-kk, kol=kol-kk,
                      sum_spis=sum_spis-cl.sum_spis,
                      status=decode(kol_sklad, kol_spis, 6, status)
                      where uniko=uo;
                                                                  
                      INSERT INTO ASUNZ.CLAIM_ST_HIST (UNIKO, STATUS, WHO, STAT, PRICH, STATUS_WAS) 
                      select uniko, status, null, sysdate, 'Отделенна недопоставка по дог.'||d.unik_d||'('||d.unik||')'||' в №'||cl.uniko, cl.status
                       from CLAIM where uniko=uo;
                       
                      claims.temp_uo := cl.uniko; 
                  end;
                  end if;
                 
                end if;
              end loop;
end;

END claims;
/
