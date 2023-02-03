CREATE OR REPLACE package body SERVICEDESK.servicedesk_pkg is

  function check_role(p_role in varchar2) return boolean
  is
  begin
    return p_role is not null and trim(upper(p_role)) in (
      'CSR',
      'CSRMANAGER',
      'COORDINATOR',
      'SPECIALIST',
      'ITMANAGER');
  end;

  function is_csr(p_role in varchar2) return boolean
  is
  begin
    return trim(upper(p_role)) = 'CSR';
  end;

  function is_csr_manager(p_role in varchar2) return boolean
  is
  begin
    return trim(upper(p_role)) = 'CSRMANAGER';
  end;

  function is_coordinator(p_role in varchar2) return boolean
  is
  begin
    return trim(upper(p_role)) = 'COORDINATOR';
  end;

  function is_specialist(p_role in varchar2) return boolean
  is
  begin
    return trim(upper(p_role)) = 'SPECIALIST';
  end;

  function is_it_manager(p_role in varchar2) return boolean
  is
  begin
    return trim(upper(p_role)) = 'ITMANAGER';
  end;

  function get_user_center(p_user in spr_people.cod_people%type)
    return service_center.id%type
  is
    cursor user_center_c(p_user in spr_people.cod_people%type) is
      select id from service_center where manager = p_user
      union all
      select center from csr where code = p_user;
    l_result service_center.id%type;
  begin
    open user_center_c(p_user);
    fetch user_center_c into l_result;
    close user_center_c;
    return l_result;
  end;

  procedure check_role_ex(p_role in varchar2)
  /** Если роль некорректна, выдаёт исключение с кодом -20001 */
  is
  begin
    if not check_role(p_role) then
      raise_application_error(-20001, 'Некорректная роль - "' || p_role || '"!');
    end if;
  end;

  function get_access_level(p_request in request.id%type,
    p_user in spr_people.cod_people%type,
    p_role in varchar2) return varchar2
  is
    r request%rowtype;
    l_result varchar2(10) := 'NOTHING';
  begin
    check_role_ex(p_role);
    if is_it_manager(p_role) then
      l_result := 'EDIT';
    else
    null;
      select * into r from request where id = p_request;
      case r.status
        when 'OPENED' then
          if is_csr(p_role) or is_csr_manager(p_role) then
            l_result := 'EDIT';
            else l_result := 'VIEW';
            end if;
        when 'SUSPENDED' then
          if is_csr(p_role) or is_csr_manager(p_role) then
            l_result := 'EDIT';
            else l_result := 'VIEW';
              end if;
        when 'ESCALATED' then
          if is_csr(p_role) or is_csr_manager(p_role) then
            l_result := 'EDIT';
            else l_result := 'VIEW';
              end if;
        when 'TRANSFERRED' then
          if is_csr(p_role) or is_csr_manager(p_role)
              or r.coordinator = p_user then
            l_result := 'EDIT';
            else l_result := 'VIEW';
             end if;
        when 'ACCEPTED' then
          if is_csr(p_role) or is_csr_manager(p_role)
              or r.coordinator = p_user then
            l_result := 'EDIT';
            else l_result := 'VIEW';
             end if;
        when 'APPOINTED' then
          if is_csr(p_role) or is_csr_manager(p_role)
              or r.coordinator = p_user
              or r.specialist = p_user then
            l_result := 'EDIT';
            else l_result := 'VIEW';
              end if;
        when 'SPEC_FINISHED' then
          if is_csr(p_role) or is_csr_manager(p_role)
              or r.coordinator = p_user then
            l_result := 'EDIT';
            else l_result := 'VIEW';
             end if;
        when 'FINISHED' then
          if is_csr(p_role) or is_csr_manager(p_role) then
            l_result := 'EDIT';
            else l_result := 'VIEW';
             end if;
        when 'CLOSED' then
          if is_csr(p_role) or is_csr_manager(p_role) then
            l_result := 'EDIT';
            else l_result := 'VIEW';
            end if;
      end case;
    end if;
    return l_result;
    EXCEPTION 
             WHEN NO_DATA_FOUND THEN 
             return l_result;
  end;

  procedure log_action(p_request in request.id%type,
    p_user in spr_people.cod_people%type,
    p_role in varchar2,
    p_action in varchar2,
    p_descript in varchar2 := null,
    p_coordinator in spr_people.cod_people%type := null,
    p_specialist in spr_people.cod_people%type := null)
  is
  begin
    insert into action(request, performer, performer_role,
        performed, type, descript, coordinator, specialist)
      values (p_request, p_user, p_role, sysdate, p_action, p_descript,
        p_coordinator, p_specialist);
  end;

  function get_program_email return varchar2
  is
  begin
    return 'programm_service@mmk.net';
  end;

  procedure enotify_action(p_request in request.id%type,
    p_user in spr_people.cod_people%type,
    p_role in varchar2,
    p_action in varchar2,
    p_descript in varchar2 := null)
  is
    l_subject varchar2(100) := '[SERVICEDESK-NOTIFY] ';
    l_do_notify boolean := false;
    l_user_fio spr_people.fio_people%type;
    l_body varchar2(8000);
    l_pfx varchar2(8000);
    l_recipient varchar2(100);

    function role_name return varchar2
    is
    begin
      if is_csr(p_role) then
        return 'Оператор СД';
      elsif is_csr_manager(p_role) then
        return 'Менеджер СД';
      elsif is_coordinator(p_role) then
        return 'Координатор';
      elsif is_specialist(p_role) then
        return 'Специалист';
      else
        return null;
      end if;
    end;

  begin
      for r in (
      select 
          sr.user_email,
          sr.coordinator,
          spc.email as coordinator_email,
          sr.specialist,
          sps.email as specialist_email,
          sr.reply_to_user,
          scsr.email as csr_email,
          spm.email as csrm_email,
          SR.DESCRIPT,
          SR.USER_FIO||' '||SR.USER_PHONE USER_FIO,
          asuppp.text_podr(SR.USER_ZEX) podr,
          sr.IT_USLUGA
        from request sr
          left join spr_people spc on spc.cod_people = coordinator
          left join spr_people sps on sps.cod_people = specialist
          left join spr_people scsr on scsr.cod_people = sr.csr
          left join service_center sc on sr.center = sc.id
          left join spr_people spm on sc.manager = spm.cod_people
        where sr.id = p_request)
    loop
      case p_action
          --Оповещения об эскалации убраны
          when 'ESCALATE' then
          l_do_notify := false;
          l_subject := l_subject || ' эскалация запроса';
          l_recipient := r.csrm_email;
        when 'DE-ESCALATE' then
          l_do_notify := true;
          l_subject := l_subject || ' возврат запроса в сервис-деск';
          l_recipient := r.csr_email;
        when 'TRANSFER' then
          l_do_notify := true;
          l_subject := l_subject || ' назначение координатора запроса';                  
          l_recipient := r.coordinator_email;
        when 'REJECT' then
          l_do_notify := true;
          l_subject := l_subject || ' отклонение запроса';
          l_body := 'Причина: ' || p_descript || chr(10);
          if is_coordinator(p_role) then
            -- уведомить CSR
            l_recipient := r.csr_email;
          elsif is_specialist(p_role) then
            l_do_notify := true;
            -- уведомить координатора
            l_recipient := r.coordinator_email;
          end if;
        when 'APPOINT' then
          l_do_notify := true;
          l_subject := l_subject || ' назначение специалиста на разрешение запроса';
          l_recipient := r.specialist_email;
        when 'FINISH' then
          l_do_notify := true;
          l_subject := l_subject || ' завершение запроса';
          l_body := 'Ответ пользователю: ' || nvl(r.reply_to_user, '-') || chr(10);
        --if is_coordinator(p_role) then
            -- уведомить CSR
           -- l_recipient := r.csr_email;
          --elsif is_specialist(p_role) then
          if is_specialist(p_role) then 
           -- уведомить координатора
            l_recipient := r.coordinator_email;
            /*
            if r.coordinator=79478 then
              l_pfx := ' Завершить: http://oas:7778/oasupsp/psp_sd?act=FINISH&id='||p_request;
            end if;
            */
          end if;
        else null;
      end case;
      
      if p_action = 'TRANSFER' or (p_action ='REJECT' and is_specialist(p_role)) then      
        if r.coordinator=79478 then
          /*
            select '<br>Специалисты: <br>'||asuppp.str_join('<a href="http://oas:7778/oasupsp/psp_sd?act=APPOINT&id='
            ||p_request||'&ppl='||cod_people||'">'||fio_people||'</a><br>')
            */
            select '

Специалисты:
'||asuppp.str_join('
'||fio_people||' http://hpoas.mmk.local:8888/oasupsp/psp_sd?act=APPOINT&id='||p_request||'&ppl='||cod_people)
            into l_pfx 
            from spr_people 
            where zex = 69600 and kod_role IS NULL and (buro = 7 /*or cod_people=79299*/); 
        end if;
      end if;
      
      if p_action = 'APPOINT' and r.coordinator=79478 then
        l_pfx := '
        
--------------------------------------------------------------------------------------------        
Нужны изменения (отправить в редмайн): http://hpoas.mmk.local:8888/oasupsp/psp_sd_redmine?r='||p_request||'&a=1
--------------------------------------------------------------------------------------------';
      end if;      

      if r.IT_USLUGA>0 then
        l_body := '        
        '||text_it_usluga(r.it_usluga)||'        
        '||l_body;
      end if;
      
      if l_do_notify then
        select fio_people
          into l_user_fio
          from spr_people
          where cod_people = p_user;
        l_body :=
          'Номер запроса: ' || p_request || chr(10)
          || 'Предыдущий участник: ' || l_user_fio || ' (' || role_name || ')' || chr(10)
          || l_body||
          chr(10)||r.descript||chr(10)||r.USER_FIO||', '||r.podr||l_pfx;
        --Убрал оповещения по e-mail пока не разберусь о чем же надо оповещать. 
        --Вернул оповещения по e-mail (специалистам надо видеть) 
        --Кроме курганского, для него осталась только эскалация.
        IF (p_action='ESCALATE') or (p_action != 'ESCALATE' and l_recipient != 'ksa@mmk.net' )
        THEN 
        send_email_from_pl_sql.send_email_without_attachment(
          get_program_email,
          l_recipient,
          l_subject||' '||p_request,
          l_body);
        END IF;
      end if;
    end loop;
  end;

 procedure enotify_action_new(p_request in request.id%type,
    p_user in spr_people.cod_people%type,
    p_role in varchar2,
    p_action in varchar2,
    p_descript in varchar2 := null)
  is
    l_subject varchar2(100) := '[SERVICEDESK-NOTIFY] ';
    l_do_notify boolean := false;
    l_user_fio spr_people.fio_people%type;
    l_body varchar2(8000);
    l_recipient varchar2(100);
     l_recipient_dop varchar2(100);

  begin
      for r in (
      select 
              sr.id, 
              sr.csr,
              sr.user_email,
              sr.user_email_dop,
              sr.coordinator,
              spc.email as coordinator_email,
              sr.specialist,
              sps.email as specialist_email,
              sr.reply_to_user,
              to_char(received,'Day ')||to_char(received, 'DD.MM, HH24:MI') received,
              sc.email as csr_email,
              SR.USER_PHONE,
              spm.email as csrm_email,
              SR.DESCRIPT,
              SR.USER_FIO USER_FIO,
              asuppp.text_podr(SR.USER_ZEX) podr,
              sr.IT_USLUGA, 
              decode(sr.user_location,null,null, 'Расположение: '||sr.user_location) raspoloj,
              spo.fio_people csr_fio,
              sps.fio_people specialist_fio,
              spc.fio_people coordinator_fio,
              decode(decode(sr.type,'INCIDENT',decode(to_char(incident_ustran_period),'+000 00:00:00.000000',null,to_char(sysdate+incident_ustran_period, 'HH24:MI DD.MM')),
              'NEW_SERVICE',decode(to_char(new_ustran_period),'+000 00:00:00.000000',null,to_char(sysdate+new_ustran_period, 'HH24:MI DD.MM')),
              'SUBSCRIBE',decode(to_char(subscribe_ustran_period),'+000 00:00:00.000000',null,to_char(sysdate+subscribe_ustran_period, 'HH24:MI DD.MM')),
              'INFO',decode(to_char(info_ustran_period),'+000 00:00:00.000000',null,to_char(sysdate+info_ustran_period, 'HH24:MI DD.MM'))),null,null,'Специалист службы технической поддержки свяжется с Вами до '||decode(sr.type,'INCIDENT',decode(to_char(incident_ustran_period),'+000 00:00:00.000000',null,to_char(sysdate+incident_ustran_period, 'HH24:MI DD.MM')),
              'NEW_SERVICE',decode(to_char(new_ustran_period),'+000 00:00:00.000000',null,to_char(sysdate+new_ustran_period, 'HH24:MI DD.MM')),
              'SUBSCRIBE',decode(to_char(subscribe_ustran_period),'+000 00:00:00.000000',null,to_char(sysdate+subscribe_ustran_period, 'HH24:MI DD.MM')),
              'INFO',decode(to_char(info_ustran_period),'+000 00:00:00.000000',null,to_char(sysdate+info_ustran_period, 'HH24:MI DD.MM')))) date_ustran,
               decode(svt.ind_num ||' '||svt_dop.ind_num,null,null,'Индивидуальный номер СВТ: '||' '||svt.ind_num ||' '||svt_dop.ind_num) svt,
              nvl(decode(nvl(itu.new_usl_id,0),0,ITU.code,(select IT_USLUGA.code from it_usluga where it_usluga.id=it_usluga.new_usl_id)),itu.code)||' - '||itu.name kod_uslugi,
             (select name from request_source where SR.source=request_source.id)||' '||source_id istochnik
        from request sr
              left join spr_people spc on spc.cod_people = coordinator
              left join spr_people sps on sps.cod_people = specialist
              left join service_center sc on sr.center = sc.id
              left join spr_people spm on sc.manager = spm.cod_people
              left join spr_people spo on sr.csr = spo.cod_people
              left join it_usluga itu on sr.it_usluga = itu.id
              left join asunz.svt on sr.oborud=svt.id_svt
              left join asunz.svt svt_dop on sr.oborud_dop=svt_dop.id_svt
      where sr.id = p_request)
    loop
      case p_action
         --Открытие запроса
         when 'OPEN' then
          l_do_notify := true;
          l_subject := l_subject || ' Открытие запроса';
          l_recipient := r.user_email;
          l_recipient_dop := r.user_email_dop;
          l_body := 'Уважаемый пользователь, ' || r.user_fio || '.' || chr(10) ||
           '' || chr(10) ||
          'Ваш запрос зарегистрирован в Отделе поддержки пользователей.' ||  chr(10) ||
          'Регистрационный номер запроса: ' || r.id || '. ' ||  'Этот номер необходимо сохранить для ссылок на Ваш запрос и справок по нему.' || chr(10) ||
          'Источник: '||r.istochnik||chr(10)||
          'Код услуги:  '||r.kod_uslugi|| chr(10)||
           r.date_ustran || chr(10) ||
          '' || chr(10) ||
          'Дата/Время регистрации запроса: ' || r.received || chr(10) ||
          'Описание: ' || r.descript || chr(10) ||
          r.svt|| chr(10) ||
          r.raspoloj || chr(10) ||
          'Телефон: ' || r.user_phone || chr(10) ||
          'Электронная почта: ' || r.user_email || chr(10) ||
           '' || chr(10) ||
           'Со всеми вопросами и за справкой Вы можете обратиться в Отдел поддержки пользователей по телефону 1-06 или письмом на e-mail:' || chr(10) ||
           'ServiceDesk@ilyichsteel.com, указав вышеперечисленный Регистрационный номер.' ||  chr(10) ||
           '' || chr(10)  ||
            'С уважением,' || chr(10) ||
            'Диспетчер Отдела поддержки пользователей:' || chr(10) ||
            r.csr_fio || chr(10); 
          --Закрытие запроса
          when 'CLOSED' then
          l_do_notify := true;
          l_subject := l_subject || ' Закрытие запроса';
          l_recipient := r.user_email;
          l_recipient_dop := r.user_email_dop;
          if  r.specialist is not null  then
          l_body := 'Уважаемый пользователь, ' ||  r.user_fio || '.' || chr(10) ||
                 '' || chr(10) ||
                 'Специалист Службы технической поддержки провел работы по заявленному Вами запросу' || chr(10) ||
                 '' || chr(10) ||
                 'Регистрационный номер: ' || r.id || chr(10) ||
                 'Дата/Время регистрации запроса:: ' || r.received || chr(10) ||
                  'Источник: '||r.istochnik||chr(10)||
                  'Код услуги:  '||r.kod_uslugi|| chr(10)||
                 'Заявленный симптом: ' || r.descript || chr(10) ||
                 r.svt || chr(10) ||
                 'Решение: ' || r.reply_to_user || '' || chr(10) ||
                 'Запрос выполнен специалистом: ' || r.specialist_fio || chr(10) ||
                  '' || chr(10) ||
                  'Если у Вас возникнут дополнительные вопросы или Вы недовольны качеством выполненных по Вашему запросу работ, пожалуйста, свяжитесь с Отделом поддержки пользователей по телефону 1-06 или письмом на e-mail:' || chr(10) || 
                  'sd.feedback@ilyichsteel.com, указав вышеперечисленный Регистрационный номер.' ||  chr(10) ||
                  '' || chr(10) ||
                  'С уважением,' || chr(10) ||
                  'Диспетчер Отдела поддержки пользователей:'  || chr(10) ||
                  r.csr_fio || chr(10);
                   elsif  r.coordinator is not null and  r.specialist is null then
                  l_body := 'Уважаемый пользователь, ' ||  r.user_fio || '.' || chr(10) ||
                 '' || chr(10) ||
                 'Специалист Службы технической поддержки провел работы по заявленному Вами запросу' || chr(10) ||
                 '' || chr(10) ||
                 'Регистрационный номер: ' || r.id || chr(10) ||
                 'Дата/Время регистрации запроса: ' || r.received || chr(10) ||
                  'Источник: '||r.istochnik||chr(10)||
                  'Код услуги:  '||r.kod_uslugi|| chr(10)||
                 'Заявленный симптом: ' || r.descript || chr(10) ||
                 r.svt || chr(10) ||
                 'Решение: ' || r.reply_to_user || '' || chr(10) ||
                 'Запрос выполнен специалистом: ' || r.coordinator_fio || chr(10) ||
                  '' || chr(10) ||
                  'Если у Вас возникнут дополнительные вопросы или Вы недовольны качеством выполненных по Вашему запросу работ, пожалуйста, свяжитесь с Отделом поддержки пользователей по телефону 1-06 или письмом на e-mail:' || chr(10) || 
                  'sd.feedback@ilyichsteel.com, указав вышеперечисленный Регистрационный номер.' ||  chr(10) ||
                  '' || chr(10) ||
                  'С уважением,' || chr(10) ||
                  'Диспетчер Отдела поддержки пользователей:'  || chr(10) ||
                  r.csr_fio || chr(10);
                  else 
                  l_body := 'Уважаемый пользователь, ' ||  r.user_fio || '.' || chr(10) ||
                 '' || chr(10) ||
                 'Специалист Службы технической поддержки провел работы по заявленному Вами Инциденту' || chr(10) ||
                 '' || chr(10) ||
                 'Регистрационный номер: ' || r.id || chr(10) ||
                 'Дата/Время регистрации запроса: ' || r.received || chr(10) ||
                 'Источник: '||r.istochnik||chr(10)||
                 'Код услуги:  '||r.kod_uslugi|| chr(10)||
                 'Заявленный симптом: ' || r.descript || chr(10) ||
                 r.svt || chr(10) ||
                 'Решение: ' || r.reply_to_user || '' || chr(10) ||
                 'Запрос выполнен диспетчером: ' || r.csr_fio || chr(10) ||
                  '' || chr(10) ||
                  'Если у Вас возникнут дополнительные вопросы или Вы недовольны качеством выполненных по Вашему запросу работ, пожалуйста, свяжитесь с Отделом поддержки пользователей по телефону 1-06 или письмом на e-mail:' || chr(10) || 
                  'sd.feedback@ilyichsteel.com, указав вышеперечисленный Регистрационный номер.' ||  chr(10) ||
                  '' || chr(10) ||
                  'С уважением,' || chr(10) ||
                  'Диспетчер Отдела поддержки пользователей:'  || chr(10) ||
                  r.csr_fio || chr(10);
          end if;
          else null;
                end case;
     
        IF (p_action='OPEN') or (p_action = 'CLOSED')
        THEN 
        send_email_from_pl_sql.send_email_without_attachment(
          /*get_program_email*/ null,
          l_recipient,
          l_subject||' '||p_request,
          l_body);
        END IF;
             IF l_recipient_dop is not null THEN
           send_email_from_pl_sql.send_email_without_attachment(
          /*get_program_email*/ null,
          l_recipient_dop,
          l_subject||' '||p_request,
          l_body);
          END IF;
     -- end if;
    end loop;
  end;
  
  procedure unautorized_error(p_module in varchar2,
    p_request in request.id%type,
    p_user in spr_people.cod_people%type,
    p_role in varchar2,
    p_action in varchar2)
  is
  begin
    std.debug_message(p_module,
      'UNAUTORIZED ACCESS: p_action = ' || p_action || '; '
      || 'p_request = ' || p_request || '; '
      || 'p_user = ' || p_user || '; '
      || 'p_role = ' || p_role);
    raise_application_error(-20002, 'Вы не имеете права выполнять '
      || 'данное действие над указанным запросом!');
  end;

  procedure request_status_transition(
    p_performer_role in varchar2,
    p_action in varchar2,
    p_status in out varchar2,
    p_coordinator in out number,
    p_specialist in out number,
    p_closed in out date,
    p_next_coordinator in number := null,
    p_next_specialist in number := null)
  is
  begin
    case p_action
      when 'SUSPEND' then
        p_coordinator := null;
        p_specialist := null;
        p_status := 'SUSPENDED';
      when 'RESUME' then
        if servicedesk_pkg.is_csr(p_performer_role) then
          p_status := 'OPENED';
        else
          p_status := 'ESCALATED';
        end if;
      when 'ESCALATE' then
        p_status := 'ESCALATED';
      when 'DE-ESCALATE' then
        p_status := 'OPENED';
      when 'TRANSFER' then
        p_coordinator := p_next_coordinator;
        p_specialist := null;
        p_status := 'TRANSFERRED';
      when 'CLOSE' then
        p_status := 'CLOSED';
        p_closed := sysdate;
      when 'ACCEPT' then
        p_status := 'ACCEPTED';
      when 'REJECT' then
        if servicedesk_pkg.is_coordinator(p_performer_role) then
          p_coordinator := null;
          p_specialist := null;
          p_status := 'OPENED';
        elsif servicedesk_pkg.is_specialist(p_performer_role) then
          p_specialist := null;
          p_status := 'ACCEPTED';
        end if;
      when 'APPOINT' then
        p_specialist := p_next_specialist;
        p_status := 'APPOINTED';
      when 'FINISH' then
        if servicedesk_pkg.is_coordinator(p_performer_role) then
          p_status := 'FINISHED';
        elsif servicedesk_pkg.is_specialist(p_performer_role) then
          p_status := 'SPEC_FINISHED';
        end if;
      /*when 'CLOSE' then
        p_status := 'CLOSED';*/
      when 'OPEN' then
        p_status := 'OPENED';
      when 'CLOSED' then
        p_status := 'OPENED';
    end case;
  end;

  procedure request_transition(p_request in request.id%type,
    p_user in spr_people.cod_people%type,
    p_role in varchar2,
    p_action in varchar2,
    p_coordinator in spr_people.cod_people%type := null,
    p_specialist in spr_people.cod_people%type := null,
    p_cause in varchar2 := null)
  is
    r request%rowtype;
  begin
    check_role_ex(p_role);
    select * into r from request where id = p_request;
    if is_action_authorized(p_request, p_action, p_user, p_role) then
      request_status_transition(p_role, p_action,
        r.status, r.coordinator, r.specialist, r.closed,
        p_coordinator, p_specialist);
      update request
        set status = r.status,
          coordinator = r.coordinator,
          specialist = r.specialist,
          closed = r.closed,
          EMAIL_REJECT = case when p_action='REJECT' then 
            null
          else EMAIL_REJECT end,
          reply_to_user = case when p_action='FINISH' then 
          /*nvl(*/p_cause/*, decode(r.coordinator, 79478, 'Консультация', null)* */
          else reply_to_user end 
        where id = r.id;
      log_action(p_request, p_user, p_role, p_action, p_cause, p_coordinator, p_specialist);
      enotify_action(p_request, p_user, p_role, p_action, p_cause);
      enotify_action_new(p_request, p_user, p_role, p_action);
          else
      unautorized_error('request_transition', p_request, p_user, p_role, p_action);
    end if;
  end;

  procedure request_suspend(p_request in request.id%type,
    p_user in spr_people.cod_people%type,
    p_role in varchar2,
    p_cause in varchar2)
  is
  begin
    if p_cause is null then
      raise_application_error(-20001, 'Должна быть указана причина приостановки!');
    end if;
    request_transition(p_request, p_user, p_role, 'SUSPEND', p_cause => p_cause);
  end;

  procedure request_resume(p_request in request.id%type,
    p_user in spr_people.cod_people%type,
    p_role in varchar2)
  is
  begin
    request_transition(p_request, p_user, p_role, 'RESUME');
  end;

  procedure request_escalate(p_request in request.id%type,
    p_user in spr_people.cod_people%type,
    p_role in varchar2)
  is
  begin
    request_transition(p_request, p_user, p_role, 'ESCALATE');
  end;

  procedure request_deescalate(p_request in request.id%type,
    p_user in spr_people.cod_people%type,
    p_role in varchar2,
    p_cause in varchar2 := NULL)
  is
  begin
    request_transition(p_request, p_user, p_role, 'DE-ESCALATE',p_cause => p_cause);
  end;

  procedure request_transfer(p_request in request.id%type,
    p_user in spr_people.cod_people%type,
    p_role in varchar2,
    p_coordinator in spr_people.cod_people%type,
    p_cause in varchar2 := NULL)
  is
  begin
    if p_coordinator is null then
      raise_application_error(-20001, 'Должен быть указан координатор!');
    end if;
    request_transition(p_request, p_user, p_role, 'TRANSFER',
      p_coordinator => p_coordinator,p_cause => p_cause);
  end;

  procedure request_close(p_request in request.id%type,
    p_user in spr_people.cod_people%type,
    p_role in varchar2)
  is
  begin
    request_transition(p_request, p_user, p_role, 'CLOSE');
  end;
  
      procedure request_closed(p_request in request.id%type,
    p_user in spr_people.cod_people%type,
    p_role in varchar2
    )
  is
  begin
    request_transition(p_request, p_user, p_role, 'CLOSED');
  end;
  
    procedure request_open(p_request in request.id%type,
    p_user in spr_people.cod_people%type,
    p_role in varchar2)
  is
  begin
    request_transition(p_request, p_user, p_role, 'OPEN');
 end;

  procedure request_accept(p_request in request.id%type,
    p_user in spr_people.cod_people%type,
    p_role in varchar2)
  is
    r request%rowtype;
  begin
    request_transition(p_request, p_user, p_role, 'ACCEPT');
  end;

  procedure request_reject(p_request in request.id%type,
    p_user in spr_people.cod_people%type,
    p_role in varchar2,
    p_cause in varchar2)
  is
  begin
    if p_cause is null then
      raise_application_error(-20001, 'Должна быть указана причина отказа!');
    end if;
    request_transition(p_request, p_user, p_role, 'REJECT', p_cause => p_cause);
  end;

  procedure request_appoint(p_request in request.id%type,
    p_user in spr_people.cod_people%type,
    p_role in varchar2,
    p_specialist in spr_people.cod_people%type)
  is
  begin
    request_transition(p_request, p_user, p_role, 'APPOINT',
      p_specialist => p_specialist);
  end;

  procedure request_finish(p_request in request.id%type,
    p_user in spr_people.cod_people%type,
    p_role in varchar2,
    p_cause in varchar2)
  is
  begin
    request_transition(p_request, p_user, p_role, 'FINISH', p_cause => p_cause);
  end;

  function is_action_authorized(p_request in request.id%type,
    p_action in varchar2,
    p_user in spr_people.cod_people%type,
    p_role in varchar2) return boolean
  is
    r request%rowtype;
    l_center_manager service_center.manager%type;
    l_center service_center.id%type;
  begin
    check_role_ex(p_role);
    select * into r from request where id = p_request;
    if p_action = 'ESCALATE' then
      return is_csr(p_role) and r.status = 'OPENED';
    elsif p_action = 'DE-ESCALATE' then
      begin
        select manager into l_center_manager
          from service_center where id = r.center;
        return l_center_manager = p_user and r.status = 'ESCALATED';
      exception
        when no_data_found then
          return false;
      end;
    elsif p_action = 'SUSPEND' then
              /*    begin
                            if is_csr(p_role) then
                              select center into l_center
                                from csr where code = p_user;
                              return l_center = r.center and r.status = 'OPENED';
                            elsif is_csr_manager(p_role) then
                              select id into l_center
                                from service_center where manager = p_user;
                              return l_center = r.center and r.status = 'ESCALATED';
                            else
                              return false;
                            end if;
                  exception
                    when no_data_found then
                      return false;
                  end;*/return false;
    elsif p_action = 'RESUME' then
      begin
        if is_csr(p_role) then
          select center into l_center
            from csr where code = p_user;
        elsif is_csr_manager(p_role) then
          select id into l_center
            from service_center where manager = p_user;
        else
          return false;
        end if;
        return l_center = r.center and r.status = 'SUSPENDED';
      exception
        when no_data_found then
          return false;
      end;
    elsif p_action = 'TRANSFER' then
      return (is_csr(p_role) and r.status = 'OPENED')
      /*csr-менеджер может отпралять запрос на доработку полсе координатора Красильников А.С. 11.02.2014*/
      or (is_csr(p_role) and r.status in ('FINISHED'))
        or (is_csr_manager(p_role) and r.status = 'ESCALATED')
        or (is_it_manager(p_role) and r.status = 'ESCALATED');
    elsif p_action = 'CLOSE'  then
      return
        /* csr может закрыть только открытый запрос */
        is_csr(p_role) and r.status = 'OPENED'
        /* csr-менеджер может закрыть эскалированный запрос */
        or is_csr_manager(p_role) and r.status = 'ESCALATED'
        /* csr и его менеджер могут закрыть выполненный запрос */
        or (is_csr(p_role) or is_csr_manager(p_role)) and r.status = 'FINISHED';
    elsif p_action = 'CLOSED'  then
      return
        /* csr может закрыть только открытый запрос */
        is_csr(p_role) and r.status = 'OPENED'
        /* csr-менеджер может закрыть эскалированный запрос */
        or is_csr_manager(p_role) and r.status = 'ESCALATED'
        /* csr и его менеджер могут закрыть выполненный запрос */
        or (is_csr(p_role) or is_csr_manager(p_role)) and r.status = 'FINISHED';
    elsif p_action = 'OPEN'  then
      return
        /* csr может закрыть только открытый запрос */
        is_csr(p_role) and r.status = 'OPENED'
        /* csr-менеджер может закрыть эскалированный запрос */
        or is_csr_manager(p_role) and r.status = 'ESCALATED'
        /* csr и его менеджер могут закрыть выполненный запрос */
        or (is_csr(p_role) or is_csr_manager(p_role)) and r.status = 'FINISHED';
     elsif p_action = 'ACCEPT' then
      /* координатор может принять запрос, который был переведён на него */
      return is_coordinator(p_role) and r.status = 'TRANSFERRED'
        and r.coordinator = p_user;
    elsif p_action = 'REJECT' then
      return
        /* координатор может отклонить запрос, который был переведён на него
           (и, возможно, был уже принят и назначен на исполнителя) */
        is_coordinator(p_role) and r.status in ('TRANSFERRED', 'ACCEPTED', 'APPOINTED')
        and r.coordinator = p_user
        /* специалист может отклонить запрос, который координатор назначил ему */
        or is_specialist(p_role) and r.status = 'APPOINTED' and r.specialist = p_user;
    elsif p_action = 'APPOINT' then
      return
        /* координатор может назначить запрос, который был переведён на него,
           принят им, либо уже назначен им исполнителю (переназначить запрос) */
        is_coordinator(p_role) and r.status in ('TRANSFERRED', 'ACCEPTED', 'APPOINTED')
        and r.coordinator = p_user;
    elsif p_action = 'FINISH' then
      return
        /* завершён координатором */
        is_coordinator(p_role) and r.status in ('TRANSFERRED', 'ACCEPTED', 'SPEC_FINISHED', 'APPOINTED')
        and r.coordinator = p_user
        /* завершён специалистом */
        or is_specialist(p_role) and r.status = 'APPOINTED' and r.specialist = p_user;
    else
      raise_application_error(-20001, 'Некорректное действие - "' || p_action || '"!');
    end if;
  end;

  function is_action_authorized_sql(p_request in request.id%type,
    p_action in varchar2,
    p_user in spr_people.cod_people%type,
    p_role in varchar2) return integer
  is
  begin
    if is_action_authorized(p_request, p_action, p_user, p_role) then
      return 1;
    else
      return 0;
    end if;
  end;

  function is_request_expired(p_request in request.id%type)
    return boolean
  is
    l_time_spent number :=
    (p_request);
  begin
    if l_time_spent is null then
      return false;
    else
      return l_time_spent >= 1.0;
    end if;
  end;

  function is_request_expired_sql(p_request in request.id%type)
    return integer
  is
  begin
    if is_request_expired(p_request) then
      return 1;
    else
      return 0;
    end if;
  end;

  function is_request_expired_response(p_request in request.id%type)
    return boolean
  is
    l_received request.received%type;
    l_response_time date;
    l_closed request.closed%type;
    l_type request.type%type;
    l_it_usluga request.it_usluga%type;
    l_interval it_usluga.info_ustran_period%type;
  begin
    select received, closed, type, it_usluga
      into l_received, l_closed, l_type, l_it_usluga
      from request
      where id = p_request;
    l_response_time := servicedesk_pkg.request_response_time(p_request);
    if l_type is null or l_it_usluga is null then
      return false;
    else
      select
        decode(l_type,
          'INFO', info_react_period,
          'SUBSCRIBE', subscribe_react_period,
          'NEW_SERVICE', new_react_period,
          'INCIDENT', incident_react_period)
        into l_interval
        from it_usluga
        where id = l_it_usluga;
      return nvl(l_response_time, sysdate) > l_received + l_interval;
    end if;
  end;

  function is_request_expired_resp_sql(p_request in request.id%type)
    return integer
  is
  begin
    if is_request_expired(p_request) then
      return 1;
    else
      return 0;
    end if;
  end;

  function request_type_title(p_type in varchar2) return varchar2
  is
  begin
    return
      case p_type
        when 'INCIDENT' then 'Инцидент'
        when 'INFO' then 'Запрос информации'
        when 'SUBSCRIBE' then 'Запрос на обслуживание'
        when 'NEW_SERVICE' then 'Запрос на новую услугу'
      end;
  end;

  function request_status_title(p_status in varchar2) return varchar2
  is
  begin
    return
      case p_status
        when 'OPENED' then 'Открыт'
        when 'SUSPENDED' then 'Приостановлен'
        when 'ESCALATED' then 'Эскалирован'
        when 'TRANSFERRED' then 'Назначен координатор'
        when 'ACCEPTED' then 'Принят координатором'
        when 'APPOINTED' then 'Назначен специалист'
        when 'SPEC_FINISHED' then 'Выполнен специалистом'
        when 'FINISHED' then 'Выполнен'
        when 'CLOSED' then 'Закрыт'
        else 'Неизвестно'
      end;
  end;

  function request_was_transferred(p_id in request.id%type) return boolean
  is
    l_cnt integer;
  begin
    select count(*) into l_cnt
      from action
      where request = p_id and type = 'TRANSFER';
    return l_cnt > 0;
  end;

  function request_was_transferred_sql(p_id in request.id%type) return integer
  is
  begin
    if request_was_transferred(p_id) then
      return 1;
    else
      return 0;
    end if;
  end;

  function request_solved_by_csr(p_id in request.id%type) return boolean
  is
    l_cnt integer;
    l_status request.status%type;
  begin
    select count(*) into l_cnt
      from action
      where request = p_id and type = 'TRANSFER';
    select status into l_status from request where id = p_id;
    return l_cnt = 0 and l_status = 'CLOSED';
  end;

  function request_solved_by_csr_sql(p_id in request.id%type) return integer
  is
  begin
    if request_solved_by_csr(p_id) then
      return 1;
    else
      return 0;
    end if;
  end;

  function request_in_work(p_id in request.id%type) return boolean
  is
    l_status request.status%type;
  begin
    select status into l_status from request sr where id = p_id;
    return l_status not in ('OPENED', 'ESCALATED', 'TRANSFERRED', 'ACCEPTED');
  end;

  function request_in_work_sql(p_id in request.id%type) return integer
  is
  begin
    if request_in_work(p_id) then
      return 1;
    else
      return 0;
    end if;
  end;

  function request_response_time(p_id in request.id%type) return date
  is
    l_date date;
  begin
    for r in (
      select performed
        from action
        where request = p_id and type in ('APPOINTED', 'FINISHED')
        order by performed
    )
    loop
      l_date := r.performed;
      exit;
    end loop;
    if l_date is null then
      select closed into l_date from request where id = p_id;
    end if;
    return l_date;
  end;

  
  
FUNCTION request_work_time_new (p_id request.ID%TYPE)
   RETURN long_interval_t
IS
   l_total   long_interval_t := INTERVAL '0 0:0:0.0' DAY TO SECOND;
BEGIN
   /*Из таблиц REQUEST и ACTION сделаем полную таблицу истории*/
   WITH history AS
        (SELECT 'RECEIVED' r_type, request.received r_date
           FROM request
          WHERE ID = p_id
         UNION ALL
         SELECT action.TYPE r_type, action.performed r_date
           FROM action
          WHERE request = p_id AND TYPE != 'CLOSE'
         UNION ALL
         SELECT 'CLOSED' r_type, NVL (closed, SYSDATE) r_date
           FROM request
          WHERE ID = p_id)
   SELECT NUMTODSINTERVAL (SUM (end_date - start_date), 'DAY') AS time_spent
     INTO l_total
     FROM ( /*Историю преобразуем в интервалы*/
            SELECT r_type AS start_type, r_date AS start_date,
                  LEAD (r_type) OVER (ORDER BY r_date) AS end_type,
                  LEAD (r_date) OVER (ORDER BY r_date) AS end_date
             FROM history)
    WHERE   /*Исключим интервалы простоя, и последнюю троку (её не с чем соединять LEAD'у)*/
            end_type IS NOT NULL AND start_type != 'SUSPEND';

   RETURN (l_total);
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN ( INTERVAL '0 0:0:0.0' DAY TO SECOND);
   WHEN OTHERS
   THEN
      std.debug_message('servicedesk_plk.request_work_time_new', 
                          sqlerrm);
      RAISE;
END request_work_time_new;
     
  function request_work_time(p_id in request.id%type)
    return long_interval_t
  is
    l_total long_interval_t := interval '0 0:0:0.0' day to second;
    l_date date;
    l_resumed boolean := false;
  begin
    for r1 in (
      select id,received, closed
        from request
        where id = p_id
    )
    loop
      l_date := r1.received;
      for r2 in (
        select 'manual',
        type, 
        performed
        from action
        where request = r1.id and-- type <> 'CLOSED'
        type in ('SUSPEND','RESUME')

        union all

        select 
        --выходной день целиком
        'holiday full',
        decode(a,0.00001,'SUSPEND','RESUME'),
        nbd+a 
        from request, asuppp.not_bank_days b,
        (select 0.00001 a from dual union all select 0.99999 a from dual) 
        where id=r1.id
        and
        (nbd+a between REQUEST.RECEIVED and nvl(REQUEST.CLOSED,sysdate))

        union all

        select
        --приняли в выходной
        'received on holday',
        'SUSPEND',
        received
        from request, asuppp.not_bank_days b 
        where id=r1.id
        and
        (received between nbd and nbd+0.9999)


        union all

        select 
        'closed on holiday',
        --закрыли или сейчас в выходной
        'RESUME',
        nvl(REQUEST.CLOSED,sysdate)
        from request, asuppp.not_bank_days b 
        where id=r1.id
        and
        (nvl(REQUEST.CLOSED,sysdate) between nbd and nbd+0.9999)








        union all

        select
        'received in morning',
        --приняли в рабочий день ночью-утром
        decode(a,0,'SUSPEND','RESUME'),
        decode(a,0,received,to_date(to_char(received,'yyyymmdd')||'0800','yyyymmddhh24mi'))
        from request, (select 0 a from dual union all select 1 a from dual)
        where id=r1.id
        and to_char(received,'yyyymmdd') not in (select to_char(nbd,'yyyymmdd') from ASUPPP.NOT_BANK_DAYS)
        and received < to_date(to_char(received,'yyyymmdd')||'0800','yyyymmddhh24mi') 

        union all

        select
        'received in evening - evening time',
        --приняли в рабочий день вечером
        decode(a,0,'SUSPEND','RESUME'),
        decode(a,0,received,to_date(to_char(received+1,'yyyymmdd')||'0000','yyyymmddhh24mi'))
        from request, (select 0 a from dual union all select 1 a from dual)
        where id=r1.id
        and to_char(received,'yyyymmdd') not in (select to_char(nbd,'yyyymmdd') from ASUPPP.NOT_BANK_DAYS)
        and received > to_date(to_char(received,'yyyymmdd')||'1630','yyyymmddhh24mi') 

        union all

        select
        'received in evening - morn time',
        --приняли в рабочий день вечером - утро
        decode(a,0,'SUSPEND','RESUME'),
        decode(a,0,to_date(to_char(received+1,'yyyymmdd')||'0000','yyyymmddhh24mi'), to_date(to_char(received+1,'yyyymmdd')||'0800','yyyymmddhh24mi'))
        from request, (select 0 a from dual union all select 1 a from dual)
        where id=r1.id
        and to_char(received,'yyyymmdd') not in (select to_char(nbd,'yyyymmdd') from ASUPPP.NOT_BANK_DAYS)
        and received > to_date(to_char(received,'yyyymmdd')||'1630','yyyymmddhh24mi')



        union all

        select 
        'whole evening',
        --вечер-ночь буднего дня целиком
        decode(a,0,'SUSPEND','RESUME'),
        decode(a,0,
          to_date(to_char(received+d,'yyyymmdd')||'1630','yyyymmddhh24mi'), 
          to_date(to_char(received+d,'yyyymmdd')||'2359','yyyymmddhh24mi'))
        from request, 
        (select rownum-1 d from request q where rownum < 100) q,
        (select 0 a from dual union all select 1 a from dual) 
        where id=r1.id
        and d < nvl(closed, sysdate)-received 
        and to_char(received+d,'yyyymmdd') not in (select to_char(nbd,'yyyymmdd') from ASUPPP.NOT_BANK_DAYS)
        --new--------------------------------------------------------------------------------------------------------------------------------------------new  --если приостановили вручную больше чем на сутки, то whole evening за это время не брать, условие, скажем так, не идеально
               and (   (select count(performed) from action where request=r1.id and type='SUSPEND') = 0 or 
                    decode(a,0,
              to_date(to_char(received+d,'yyyymmdd')||'1630','yyyymmddhh24mi'), 
              to_date(to_char(received+d,'yyyymmdd')||'2359','yyyymmddhh24mi')) not between (select max(performed) from action where request=r1.id and type='SUSPEND')  and (select max(performed) from action where request=r1.id and type='RESUME')  
        )
        --new--------------------------------------------------------------------------------------------------------------------------------------------new

        union all

        select 
        'whole evening morn',
        --вечер-ночь буднего дня целиком
        decode(a,0,'SUSPEND','RESUME'),
        decode(a,0,
          to_date(to_char(received+d+1,'yyyymmdd')||'0001','yyyymmddhh24mi'), 
          to_date(to_char(received+d+1,'yyyymmdd')||'0800','yyyymmddhh24mi'))
        from request, 
        (select rownum-1 d from request q where rownum < 100) q,
        (select 0 a from dual union all select 1 a from dual) 
        where id=r1.id
        and d+1 < nvl(closed, sysdate)-received 
        and to_char(received+d+1,'yyyymmdd') not in (select to_char(nbd,'yyyymmdd') from ASUPPP.NOT_BANK_DAYS)
        
                --new--------------------------------------------------------------------------------------------------------------------------------------------new  --если приостановили вручную больше чем на сутки, то whole evening за это время не брать, условие, скажем так, не идеально
               and (   (select count(performed) from action where request=r1.id and type='SUSPEND') = 0 or 
                    decode(a,0,
          to_date(to_char(received+d+1,'yyyymmdd')||'0001','yyyymmddhh24mi'), 
          to_date(to_char(received+d+1,'yyyymmdd')||'0800','yyyymmddhh24mi')) not between (select max(performed) from action where request=r1.id and type='SUSPEND')  and (select max(performed) from action where request=r1.id and type='RESUME')  
        )
        --new--------------------------------------------------------------------------------------------------------------------------------------------new
         


        order by 3
      )
      loop
        exit when r2.performed > nvl(r1.closed,sysdate); 
                  
        if r2.type = 'RESUME' then
          l_date := r2.performed;
        else
          begin
            l_total := l_total + numtodsinterval(r2.performed - l_date, 'DAY');
          exception
            when others then null;
          end;
          
          l_date := r2.performed;
        end if;
        l_resumed := r2.type = 'SUSPEND';
        dbms_output.put_line('1:l_total = ' || l_total);
        
      end loop;
      if not l_resumed then
      begin
--        l_total := l_total + numtodsinterval(nvl(r1.closed, sysdate) - l_date, 'DAY');
        null;
        exception
            when others then null;
            end;
      end if;
      dbms_output.put_line('2:l_total = ' || l_total);
      exit;
    end loop;
    dbms_output.put_line('3:l_total = ' || l_total);
    return l_total;
  end;

  function request_time_spent(p_id in request.id%type) return number
  is
    l_ustran_period long_interval_t;
    l_ustran_period_s integer;
    l_work_time_s integer;
    l_time_spent number;

    function dsinterval_to_seconds(p_interval in long_interval_t) return integer
    is
    begin
      return extract(second from p_interval) +
        60 * (extract(minute from p_interval)  +
          60 * (extract(hour from p_interval) +
            24 * extract(day from p_interval)));
    end;

  begin
    select
        case sr.type
          when 'INFO' then iu.info_ustran_period
          when 'SUBSCRIBE' then iu.subscribe_ustran_period
          when 'NEW_SERVICE' then iu.new_ustran_period
          when 'INCIDENT' then iu.incident_ustran_period
        end
      into l_ustran_period
      from request sr
        join it_usluga iu on iu.id = sr.it_usluga
      where sr.id = p_id;
    l_ustran_period_s := dsinterval_to_seconds(l_ustran_period);
    l_work_time_s := dsinterval_to_seconds(request_work_time(p_id));
    if nvl(l_ustran_period_s, 0) <> 0 then
      l_time_spent := l_work_time_s / l_ustran_period_s;
    else
      l_time_spent := null;
    end if;
    return l_time_spent;
  exception
    when no_data_found then return null;
  end;


  function request_last_suspend_cause(p_id  in request.id%type) return varchar2
  is
  begin
    for r in (
      select descript
        from action
        where request = p_id and type = 'SUSPEND'
        order by performed desc)
    loop
      return r.descript;
    end loop;
    return null;
  end;

  function request_base_priority(p_id in request.id%type) return integer
  is
    -- по умолчанию приоритет самый низкий
    l_result integer := 5;
    l_role varchar2(50);
  begin
    -- установим приоритет в соответствии с ИТ-услугой
    begin
      select iu.priority
        into l_result
        from request sr
          join it_usluga iu on sr.it_usluga = iu.id
        where
          sr.id = p_id;
    exception
      when no_data_found then null;
    end;
    select spr.naim_role
      into l_role
      from request sr
        left join spr_people_role spr on spr.kod = sr.user_dolz
      where
        sr.id = p_id;
    if l_role = 'Начальник цеха' then
      l_result := l_result - 2;
    elsif l_role  = 'Начальник бюро' then
      l_result := l_result - 1;
    end if;
    if l_result < 1 then
      l_result := 1;
    end if;
    return l_result;
  end;

  function request_priority(p_id in request.id%type) return integer
  is
    l_result integer := request_base_priority(p_id);
    l_time_spent number := request_time_spent(p_id);

  begin
    if l_time_spent is not null then
      if l_time_spent >= 1 then
        l_result := 1;
      elsif l_time_spent > 0.8 then
        l_result := l_result - 1;
      end if;
    end if;
    if l_result < 1 then
      l_result := 1;
    end if;
    return l_result;
  end;

  function active_request_query(p_user in spr_people.cod_people%type,
    p_role in varchar2, p_all_available in integer := 0) return request_view_t pipelined
  is
    r request_view_r;
    l_leave boolean;
    l_center service_center.id%type;
    l_center_s service_center.id%type;
    l_status_weight pls_integer := 0;
  begin
     l_center_s := case when p_user  in (79473,19401,79352,79400,79313,79498,79434,79370,79375,35416,82752,79303) then '335' 
     when p_user in (79512,79340,79278,79338,79507,79354,79490,79398,79479,79407,79284,54609,82415,79281) then '7'
     else get_user_center(p_user) end; --Красильников А.С. 30.08.2013
    l_center := case when p_user  in (79473,19401,79352,79400,79313,79498,79434,79370,79375,35416,82752,79303) then '32' 
    when p_user in (79512,79340,79278,79338,79507,79303,79354,79490,79398,79479,79407,79284,54609,82415,79281) then '34'
    else get_user_center(p_user) end; --Красильников А.С. 30.08.2013
   -- l_center := get_user_center(p_user);
    for sr in (
      select sr.id,
          sr.center as center_id,
          sc.name as center,
          sr.received,
          0 as from_user_id,
          sr.user_fio as from_user,
          decode(sr.user_unik,null,slug1.naim,k.naimz) as from_user_zex,
          --slug1.naim as from_user_zex,
          sr.status,
          sr.type,
          sr.coordinator as coordinator_id,
          csp.fio_people as coordinator,
          sr.specialist as specialist_id,
          ssp.fio_people as specialist,
          scsr.fio_people as oper,
          iu.name as it_usluga,
          sr.descript,
          so.inven_number,
          SR.QUICKLY
        from request sr
          left join kadr k on k.unink = sr.user_unik
          left join slug1 on slug1.nums = sr.user_zex
          left join spr_people csp on csp.cod_people = sr.coordinator
          left join spr_people ssp on ssp.cod_people = sr.specialist
          left join spr_people scsr on scsr.cod_people = sr.csr
          left join it_usluga iu on iu.id = sr.it_usluga
          left join service_center sc on sc.id = sr.center
          left join oborud so on so.id = sr.oborud
       --  left join asunz.svt so on so.id_svt = sr.oborud
        where (p_all_available = 1 or closed is null)
          and get_access_level(sr.id, p_user, p_role) in ('EDIT', 'VIEW')
        --  order by sr.received desc
    ) loop
      if is_csr(p_role) then
        l_leave := sr.center_id in (l_center,l_center_s) and (
          p_all_available = 1
          or sr.status <> 'CLOSED'
          );
        l_status_weight := case sr.status
                             when 'OPENED' then 1
                             when 'FINISHED' then 2
                             when 'SUSPENDED' then 3
                             when 'ESCALATED' then 4
                             when 'SPEC_FINISHED' then 5
                             when 'TRANSFERRED' then 6
                             when 'ACCEPTED' then 7
                             when 'APPOINTED' then 8
                             else 0
                           end;
      elsif is_csr_manager(p_role) then
        l_leave := sr.center_id in (l_center,l_center_s) and (
          p_all_available = 1
          or sr.status in ('ESCALATED', 'FINISHED', 'SUSPENDED'));
        l_status_weight := case sr.status
                             when 'ESCALATED' then 1
                             when 'FINISHED' then 2
                             when 'SUSPENDED' then 3
                             else 0
                           end;
      elsif is_coordinator(p_role) then
        l_leave := sr.status in ('TRANSFERRED', 'ACCEPTED', 'APPOINTED', 'SPEC_FINISHED')
          and sr.coordinator_id = p_user;
        l_status_weight := case sr.status
                             when 'TRANSFERRED' then 1
                             when 'SPEC_FINISHED' then 2
                             when 'ACCEPTED' then 3
                             when 'APPOINTED' then 4
                             else 0
                           end;
      elsif is_specialist(p_role) then
        l_leave := sr.status in ('APPOINTED') and sr.specialist_id = p_user;
      elsif is_it_manager(p_role) then
        l_leave := true;
      end if;
      if l_leave then
        r.id := sr.id;
        r.center := sr.center;
        r.received := sr.received;
        r.from_user := sr.from_user;
        r.from_user_zex := sr.from_user_zex;
        r.status := request_status_title(sr.status);
        r.type := request_type_title(sr.type);
        r.it_usluga := sr.it_usluga;
        r.coordinator := sr.coordinator;
        r.specialist := sr.specialist;
        r.oper := sr.oper;
        r.inven_number := sr.inven_number;
        r.is_expired := is_request_expired_sql(sr.id);
        r.descript := sr.descript;
        r.sort_rank := request_priority(r.id) * 10 + l_status_weight;
        r.quickly := sr.quickly;
        pipe row (r);
      end if;
    end loop;
  end;

  function last_request_query(p_csr in spr_people.cod_people%type) return request_view_t pipelined
  is
    r request_view_r;
  begin
    for sr in (
      select sr.id,
          sr.center as center_id,
          sc.name as center,
          sr.received,
          0 as from_user_id,
          sr.user_fio as from_user,
          decode(sr.user_unik,null,slug1.naim,k.naimz) as from_user_zex,
          --slug1.naim as from_user_zex,
          sr.status,
          sr.type,
          sr.coordinator as coordinator_id,
          csp.fio_people as coordinator,
          sr.specialist as specialist_id,
          ssp.fio_people as specialist,
          iu.name as it_usluga,
          sr.descript,
          so.inven_number,
          SR.QUICKLY
        from request sr
          left join kadr k on k.unink = sr.user_unik
          left join slug1 on slug1.nums = sr.user_zex
          left join spr_people csp on csp.cod_people = sr.coordinator
          left join spr_people ssp on ssp.cod_people = sr.specialist
          left join it_usluga iu on iu.id = sr.it_usluga
          left join service_center sc on sc.id = sr.center
          left join oborud so on so.id = sr.oborud
          --left join asunz.svt so on so.id_svt = sr.oborud
        where sr.csr = p_csr
        order by sr.received desc
    ) loop
      r.id := sr.id;
      r.center := sr.center;
      r.received := sr.received;
      r.from_user := sr.from_user;
      r.from_user_zex := sr.from_user_zex;
      r.status := request_status_title(sr.status);
      r.type := request_type_title(sr.type);
      r.it_usluga := sr.it_usluga;
      r.coordinator := sr.coordinator;
      r.specialist := sr.specialist;
      r.inven_number := sr.inven_number;
      r.is_expired := is_request_expired_sql(sr.id);
      r.descript := sr.descript;
      r.quickly := sr.quickly;
      pipe row (r);
    end loop;
  end;
  
   function center_request_query(p_user in spr_people.cod_people%type) return request_view_t pipelined --Красильников А.С. 04.09.2013 добавил эту функцию
  is
    r request_view_r;
     l_center service_center.id%type;
  begin
  l_center := get_user_center(p_user);
    for sr in (
      select sr.id,
          sr.center as center_id,
          sc.name as center,
          sr.received,
          0 as from_user_id,
          sr.user_fio as from_user,
          decode(sr.user_unik,null,slug1.naim,k.naimz) as from_user_zex,
          --slug1.naim as from_user_zex,
          sr.status,
          sr.type,
          sr.coordinator as coordinator_id,
          csp.fio_people as coordinator,
          sr.specialist as specialist_id,
          ssp.fio_people as specialist,
          iu.name as it_usluga,
          sr.descript,
          so.inven_number
        from request sr
          left join kadr k on k.unink = sr.user_unik
          left join slug1 on slug1.nums = sr.user_zex
          left join spr_people csp on csp.cod_people = sr.coordinator
          left join spr_people ssp on ssp.cod_people = sr.specialist
          left join it_usluga iu on iu.id = sr.it_usluga
          left join service_center sc on sc.id = sr.center
          left join oborud so on so.id = sr.oborud
          --left join asunz.svt so on so.id_svt = sr.oborud
        where sr.center = l_center
                order by sr.received desc
    ) loop
      r.id := sr.id;
      r.center := sr.center;
      r.received := sr.received;
      r.from_user := sr.from_user;
      r.from_user_zex := sr.from_user_zex;
      r.status := request_status_title(sr.status);
      r.type := request_type_title(sr.type);
      r.it_usluga := sr.it_usluga;
      r.coordinator := sr.coordinator;
      r.specialist := sr.specialist;
      r.inven_number := sr.inven_number;
      r.is_expired := is_request_expired_sql(sr.id);
      r.descript := sr.descript;
      pipe row (r);
    end loop;
  end;

  procedure periods_for_usluga(p_it_usluga in it_usluga.id%type,
    p_type in request.type%type,
    p_react_period out varchar2, 
    p_ustran_period out varchar2,
    p_tip_out number default 0)
  is
  begin
    if p_it_usluga is not null and p_type is not null and nvl(p_tip_out,0) = 0 then
      select std.dsinterval_readable(
                  case p_type
                      when 'INFO' then info_react_period
                      when 'SUBSCRIBE' then subscribe_react_period
                      when 'NEW_SERVICE' then new_react_period
                      when 'INCIDENT' then incident_react_period
                  end),
              std.dsinterval_readable(
                  case p_type
                      when 'INFO' then info_ustran_period
                      when 'SUBSCRIBE' then subscribe_ustran_period
                      when 'NEW_SERVICE' then new_ustran_period
                      when 'INCIDENT' then incident_ustran_period
                  end)
          into p_react_period, p_ustran_period
          from it_usluga
          where id = p_it_usluga;
    
    elsif p_it_usluga is not null and p_type is not null and p_tip_out = 1 then
      select to_char(
                  case p_type
                      when 'INFO' then info_react_period
                      when 'SUBSCRIBE' then subscribe_react_period
                      when 'NEW_SERVICE' then new_react_period
                      when 'INCIDENT' then incident_react_period
                  end),
              
                 to_char(case p_type
                      when 'INFO' then info_ustran_period
                      when 'SUBSCRIBE' then subscribe_ustran_period
                      when 'NEW_SERVICE' then new_ustran_period
                      when 'INCIDENT' then incident_ustran_period
                  end)
          into p_react_period, p_ustran_period
          from it_usluga
          where id = p_it_usluga;
          
    end if;
  end;

  procedure request_restore_to_date(p_request in out request%rowtype,
    p_date in date)
  is
  begin
    p_request.status := 'OPENED';
    p_request.coordinator := null;
    p_request.specialist := null;
    for r in (
      select *
        from action
        where request = p_request.id and performed <= p_date
        order by performed)
    loop
      request_status_transition(r.performer_role,
        r.type,
        p_request.status,
        p_request.coordinator,
        p_request.specialist,
        p_request.closed,
        r.coordinator,
        r.specialist);
    end loop;
  end;

  /** статус запроса на определённую дату */
  function request_status_for_date(p_id in request.id%type, p_date in date)
    return request.status%type
  is
    l_request request%rowtype;
  begin
    select * into l_request from request where id = p_id;
    l_request.status := 'OPENED';
    l_request.coordinator := null;
    l_request.specialist := null;
    if l_request.received > p_date then
      return null;
    else
      for r in (
        select *
          from action
          where request = p_id and performed <= p_date
          order by performed)
      loop
        request_status_transition(r.performer_role,
          r.type,
          l_request.status,
          l_request.coordinator,
          l_request.specialist,
          l_request.closed,
          r.coordinator,
          r.specialist);
      end loop;
      return l_request.status;
    end if;
  end;


  function period_requests_query(
    p_lower_date in date,
    p_upper_date in date) return request_t pipelined
  is
  begin
    for r in (
      select *
        from request
        where (p_lower_date is null or received >= p_lower_date)
          and (p_upper_date is null or received <= p_upper_date))
    loop
      if p_upper_date is not null then
        request_restore_to_date(r, p_upper_date);
        pipe row (r);
      end if;
    end loop;
  end;

  function summary_report_query(p_period_start in date, p_period_end in date)
    return summary_report_t pipelined
  is
    l_result summary_report_t := summary_report_t();
    l_index pls_integer;
    l_action action%rowtype;
    l_prev_period_start date;

    cursor last_action_during_period_c(p_request number,
        p_action in varchar2,
        p_start in date := null,
        p_end in date := null) is
      select *
        from action sa
        where sa.type = p_action
          and sa.performed between p_start and p_end
          and sa.request = p_request
        order by sa.performed desc;

    procedure add_participant(p_buro in varchar2,
      p_ispol spr_people.fio_people%type,
      p_ispol_code spr_people.cod_people%type,
      p_role varchar2,
      p_service_center integer)
    is
    begin
      l_result.extend;
      l_result(l_result.last).buro := p_buro;
      l_result(l_result.last).ispol := p_ispol;
      l_result(l_result.last).ispol_code := p_ispol_code;
      l_result(l_result.last).role := p_role;
      l_result(l_result.last).service_center := p_service_center;
/*      l_result(l_result.last).active_due_period_start := 0;
      l_result(l_result.last).registered_during_period := 0;
      l_result(l_result.last).closed_during_period := 0;
      l_result(l_result.last).closed_during_prev_period := 0;
      l_result(l_result.last).active_due_period_end := 0;*/
    end;

    function find_record(p_ispol_code in pls_integer,
      p_role varchar2, p_center in pls_integer ) return pls_integer
    is
    begin
      for i in l_result.first .. l_result.last
      loop
        if l_result(i).ispol_code = p_ispol_code
            and l_result(i).role = p_role
            and l_result(i).service_center = p_center then
          return i;
        end if;
      end loop;
      return null;
    end;

    function find_first_record(p_role varchar2, p_center in pls_integer ) return pls_integer
    is
    begin
      for i in l_result.first .. l_result.last
      loop
        if l_result(i).role = p_role and l_result(i).service_center = p_center then
          return i;
        end if;
      end loop;
      return null;
    end;

    procedure inc(p_value in out number)
    is
    begin
      p_value := nvl(p_value, 0) + 1;
    end;

    procedure add_id(l_ids in out varchar2, l_id in integer)
    is
    begin
      if l_ids is null then
        l_ids := l_id;
      else
        l_ids := l_ids || ',' || l_id;
      end if;
    end;

  begin
    for r in (
      select id, 'Центр сервисной поддержки - ' || name as name, manager, fio_people
        from service_center
          join spr_people on manager = cod_people)
    loop
      add_participant(r.name, r.fio_people, r.manager, 'CSRMANAGER', r.id);
      add_participant(r.name, 'ВСЕ ОПЕРАТОРЫ', 0, 'CSR', r.id);
      for r2 in (
        select cod_people, fio_people
          from csr
            left join spr_people on cod_people = code
          where center = r.id)
      loop
        add_participant(r.name, r2.fio_people, r2.cod_people, 'CSR', r.id);
      end loop;
    end loop;
    -- добавить обычные бюро
    for r in (
      select kod_buro,
          nvl(trim(short_name), trim(name)) as buro,
          spr_people.fio_people,
          nachalnik
        from spr_buro
          join spr_people on cod_people = nachalnik
        where kod_otd = 69600 and name <> '-')
    loop
      add_participant(r.buro, r.fio_people, r.nachalnik, 'COORDINATOR', 0);
      for r2 in (
        select cod_people, fio_people
          from spr_people
          where zex = 69600 and buro = r.kod_buro and is_new = 1)
      loop
        add_participant(r.buro, r2.fio_people, r2.cod_people, 'SPECIALIST', 0);
      end loop;
    end loop;

    l_prev_period_start := p_period_start - (p_period_end - p_period_start);
    for r in (
      select *
        from request)
    loop
      if r.received <= p_period_start then
        request_restore_to_date(r, p_period_start);
        if r.status in ('OPENED', 'FINISHED', 'SUSPENDED') then
          l_index := find_record(0, 'CSR', r.center);
          if l_index is not null then
            inc(l_result(l_index).active_due_period_start);
            add_id(l_result(l_index).active_due_period_start_ids, r.id);
          end if;
        elsif r.status = 'ESCALATED' then
          l_index := find_first_record('CSRMANAGER', r.center);
          if l_index is not null then
            inc(l_result(l_index).active_due_period_start);
            add_id(l_result(l_index).active_due_period_start_ids, r.id);
          end if;
        elsif r.status in ('TRANSFERRED', 'ACCEPTED', 'SPEC_FINISHED') then
          l_index := find_record(r.coordinator, 'COORDINATOR', 0);
          if l_index is not null then
            inc(l_result(l_index).active_due_period_start);
            add_id(l_result(l_index).active_due_period_start_ids, r.id);
          end if;
        elsif r.status in ('APPOINTED') then
          l_index := find_record(r.specialist, 'SPECIALIST', 0);
          if l_index is not null then
            inc(l_result(l_index).active_due_period_start);
            add_id(l_result(l_index).active_due_period_start_ids, r.id);
          end if;
        end if;
      end if;

      if r.received >= p_period_start and r.received <= p_period_end then
        l_index := find_record(r.csr, 'CSR', r.center);
        if l_index is not null then
          inc(l_result(l_index).registered_during_period);
          add_id(l_result(l_index).registered_during_period_ids, r.id);
        else
          l_index := find_record(r.csr, 'CSRMANAGER', r.center);
          if l_index is not null then
            inc(l_result(l_index).registered_during_period);
            add_id(l_result(l_index).registered_during_period_ids, r.id);
          end if;
        end if;
      end if;

      open last_action_during_period_c(r.id, 'ESCALATE', p_period_start, p_period_end);
      fetch last_action_during_period_c into l_action;
      if last_action_during_period_c%found then
        l_index := find_first_record('CSRMANAGER', r.center);
        if l_index is not null then
          inc(l_result(l_index).registered_during_period);
          add_id(l_result(l_index).registered_during_period_ids, r.id);
        end if;
      end if;
      close last_action_during_period_c;

      open last_action_during_period_c(r.id, 'CLOSE', p_period_start, p_period_end);
      fetch last_action_during_period_c into l_action;
      if last_action_during_period_c%found then
        l_index := find_record(l_action.performer, 'CSR', r.center);
        if l_index is null then
          l_index := find_record(l_action.performer, 'CSRMANAGER', r.center);
        end if;
        if l_index is not null then
          inc(l_result(l_index).closed_during_period);
          add_id(l_result(l_index).closed_during_period_ids, r.id);
        end if;
      end if;
      close last_action_during_period_c;

      open last_action_during_period_c(r.id, 'CLOSE', l_prev_period_start, p_period_start - 0.005);
      fetch last_action_during_period_c into l_action;
      if last_action_during_period_c%found then
        l_index := find_record(l_action.performer, 'CSR', r.center);
        if l_index is null then
          l_index := find_record(l_action.performer, 'CSRMANAGER', r.center);
        end if;
        if l_index is not null then
          inc(l_result(l_index).closed_during_prev_period);
          add_id(l_result(l_index).closed_during_prev_period_ids, r.id);
        end if;
      end if;
      close last_action_during_period_c;

      open last_action_during_period_c(r.id, 'FINISH', p_period_start, p_period_end);
      fetch last_action_during_period_c into l_action;
      if last_action_during_period_c%found then
        l_index := find_record(l_action.performer, l_action.performer_role, 0);
        if l_index is not null then
          inc(l_result(l_index).closed_during_period);
          add_id(l_result(l_index).closed_during_period_ids, r.id);
        end if;
      end if;
      close last_action_during_period_c;


      if r.received <= p_period_end then
        request_restore_to_date(r, p_period_end);
        if r.status in ('OPENED', 'FINISHED', 'SUSPENDED') then
          l_index := find_record(0, 'CSR', r.center);
          if l_index is not null then
            inc(l_result(l_index).active_due_period_end);
            add_id(l_result(l_index).active_due_period_end_ids, r.id);
          end if;
        elsif r.status = 'ESCALATED' then
          l_index := find_first_record('CSRMANAGER', r.center);
          if l_index is not null then
            inc(l_result(l_index).active_due_period_end);
            add_id(l_result(l_index).active_due_period_end_ids, r.id);
          end if;
        elsif r.status in ('TRANSFERRED', 'ACCEPTED', 'SPEC_FINISHED') then
          l_index := find_record(r.coordinator, 'COORDINATOR', 0);
          if l_index is not null then
            inc(l_result(l_index).active_due_period_end);
            add_id(l_result(l_index).active_due_period_end_ids, r.id);
          end if;
        elsif r.status in ('APPOINTED') then
          l_index := find_record(r.specialist, 'SPECIALIST', 0);
          if l_index is not null then
            inc(l_result(l_index).active_due_period_end);
            add_id(l_result(l_index).active_due_period_end_ids, r.id);
          end if;
        end if;

        open last_action_during_period_c(r.id, 'TRANSFER', p_period_start, p_period_end);
        fetch last_action_during_period_c into l_action;
        if last_action_during_period_c%found then
          l_index := find_record(l_action.performer, 'COORDINATOR', 0);
          if l_index is not null then
            inc(l_result(l_index).registered_during_period);
            add_id(l_result(l_index).registered_during_period_ids, r.id);
          end if;
        end if;
        close last_action_during_period_c;

        open last_action_during_period_c(r.id, 'APPOINT', p_period_start, p_period_end);
        fetch last_action_during_period_c into l_action;
        if last_action_during_period_c%found then
          l_index := find_record(l_action.performer, 'SPECIALIST', 0);
          if l_index is not null then
            inc(l_result(l_index).registered_during_period);
            add_id(l_result(l_index).registered_during_period_ids, r.id);
          end if;
        end if;
        close last_action_during_period_c;

      end if;

    end loop;

    declare
      a pls_integer;
      b pls_integer;
    begin
      for i in l_result.first .. l_result.last
      loop
        if is_coordinator(l_result(i).role) or is_specialist(l_result(i).role) then
          a := nvl(l_result(i).closed_during_period, 0);
          b := nvl(l_result(i).active_due_period_end, 0);
          if a <> 0 or b <> 0 then
            l_result(i).productivity_percent := a * 100 / (a + b);
          end if;
        end if;
        pipe row (l_result(i));
      end loop;
    end;
  end;
  
 /* Formatted on 2011/08/02 08:58 (Formatter Plus v4.8.8) */
PROCEDURE make_note (p_request_id NUMBER, p_cod_people NUMBER, p_message CLOB)
IS
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   MERGE INTO request_notes rn
      USING (SELECT p_request_id AS request, p_cod_people AS cod_people, p_message AS note
               FROM DUAL) d
      ON (rn.request = d.request AND rn.cod_people = d.cod_people)
      WHEN MATCHED THEN
         UPDATE
            SET rn.note = d.note
      WHEN NOT MATCHED THEN
         INSERT (rn.request, rn.cod_people, rn.note)
         VALUES (d.request, d.cod_people, d.note);
      COMMIT;
END make_note;
  

end servicedesk_pkg;
/
