CREATE OR REPLACE package SERVICEDESK.servicedesk_pkg is

  type request_view_r is record (
    id request.id%type,
    center service_center.name%type,
    received request.received%type,
    from_user spr_people.fio_people%type,
    from_user_zex varchar2(200),
    status varchar2(50),
    type varchar2(50),
    it_usluga varchar2(200),
    coordinator spr_people.fio_people%type,
    specialist spr_people.fio_people%type,
    oper spr_people.fio_people%type,
    inven_number oborud.inven_number%type,
    is_expired integer,
    descript request.descript%type,
    sort_rank integer,
    quickly integer
  );
  type request_view_t is table of request_view_r;

  type request_t is table of request%rowtype;

  type summary_report_r is record (
    service_center integer,
    buro varchar2(200),
    ispol spr_people.fio_people%type,
    ispol_code spr_people.cod_people%type,
    role varchar2(20),
    active_due_period_start integer,
    active_due_period_start_ids varchar2(4000),
    registered_during_period integer,
    registered_during_period_ids varchar2(4000),
    closed_during_period integer,
    closed_during_period_ids varchar2(4000),
    closed_during_prev_period integer,
    closed_during_prev_period_ids varchar2(4000),
    active_due_period_end integer,
    active_due_period_end_ids varchar2(4000),
    productivity_percent integer
  );
  type summary_report_t is table of summary_report_r;

  subtype short_interval_t is interval day(2) to second;
  subtype long_interval_t is interval day(3) to second;

  /**
      ���������, �������� �� �������� p_role ���������� �����.

      ����������� ��������� ��������� ��������: CSR, CSRMANAGER,
      COORDINATOR, SPECIALIST.
  */
  function check_role(p_role in varchar2) return boolean;
 procedure check_role_ex(p_role in varchar2);
  function is_csr(p_role in varchar2) return boolean;
  function is_csr_manager(p_role in varchar2) return boolean;
  function is_coordinator(p_role in varchar2) return boolean;
  function is_specialist(p_role in varchar2) return boolean;
  function is_it_manager(p_role in varchar2) return boolean;

  function get_user_center(p_user in spr_people.cod_people%type)
    return service_center.id%type;
  /**
      ���������, ����� ����� �� ��������� � ������� ����� �������� �
      ��������� �����.

      <code>NOTHING</code>
  */
   function get_program_email return varchar2;
  function get_access_level(p_request in request.id%type,
    p_user in spr_people.cod_people%type,
    p_role in varchar2) return varchar2;
  function is_request_expired(p_request in request.id%type)
    return boolean;
  function is_request_expired_sql(p_request in request.id%type)
    return integer;
  function is_request_expired_response(p_request in request.id%type)
    return boolean;
  function is_request_expired_resp_sql(p_request in request.id%type)
    return integer;
  /** ��������: ������������ ������� */
  procedure request_suspend(p_request in request.id%type,
    p_user in spr_people.cod_people%type,
    p_role in varchar2,
    p_cause in varchar2);
  /** ��������: ������������� ������� */
  procedure request_resume(p_request in request.id%type,
    p_user in spr_people.cod_people%type,
    p_role in varchar2);
  /** ��������: ��������� ������� */
  procedure request_escalate(p_request in request.id%type,
    p_user in spr_people.cod_people%type,
    p_role in varchar2);
  /** ��������: ��-��������� ������� */
  procedure request_deescalate(p_request in request.id%type,
    p_user in spr_people.cod_people%type,
    p_role in varchar2,
    p_cause in varchar2 := NULL);
  /** ��������: �������� ������� ������������ */
  procedure request_transfer(p_request in request.id%type,
    p_user in spr_people.cod_people%type,
    p_role in varchar2,
    p_coordinator in spr_people.cod_people%type,
    p_cause in varchar2 := NULL);
  /** ��������: �������� ������� */
  procedure request_close(p_request in request.id%type,
    p_user in spr_people.cod_people%type,
    p_role in varchar2);
  /** ��������: �����������/���������� ������������ �� ������� */
    procedure request_open(p_request in request.id%type,
    p_user in spr_people.cod_people%type,
    p_role in varchar2);
  /** ��������: �������� ��������� ������ */
    procedure request_closed(p_request in request.id%type,
    p_user in spr_people.cod_people%type,
    p_role in varchar2);
    /**��������� � �������� */
    procedure request_status_transition(
    p_performer_role in varchar2,
    p_action in varchar2,
    p_status in out varchar2,
    p_coordinator in out number,
    p_specialist in out number,
    p_closed in out date,
    p_next_coordinator in number := null,
    p_next_specialist in number := null);
     procedure enotify_action_new(p_request in request.id%type,
    p_user in spr_people.cod_people%type,
    p_role in varchar2,
    p_action in varchar2,
    p_descript in varchar2 := null);
  procedure enotify_action(p_request in request.id%type,
    p_user in spr_people.cod_people%type,
    p_role in varchar2,
    p_action in varchar2,
    p_descript in varchar2 := null);
      procedure unautorized_error(p_module in varchar2,
    p_request in request.id%type,
    p_user in spr_people.cod_people%type,
    p_role in varchar2,
    p_action in varchar2);
      procedure request_transition(p_request in request.id%type,
    p_user in spr_people.cod_people%type,
    p_role in varchar2,
    p_action in varchar2,
    p_coordinator in spr_people.cod_people%type := null,
    p_specialist in spr_people.cod_people%type := null,
    p_cause in varchar2 := null);
      procedure log_action(p_request in request.id%type,
    p_user in spr_people.cod_people%type,
    p_role in varchar2,
    p_action in varchar2,
    p_descript in varchar2 := null,
    p_coordinator in spr_people.cod_people%type := null,
    p_specialist in spr_people.cod_people%type := null);
  procedure request_reject(p_request in request.id%type,
    p_user in spr_people.cod_people%type,
    p_role in varchar2,
    p_cause in varchar2);
  /** ��������: �����������/���������� ��������� ������ */
  procedure request_accept(p_request in request.id%type,
    p_user in spr_people.cod_people%type,
    p_role in varchar2);
  /** ��������: ���������� ����������� �� ������� ������� */
  procedure request_appoint(p_request in request.id%type,
    p_user in spr_people.cod_people%type,
    p_role in varchar2,
    p_specialist in spr_people.cod_people%type);
  /** ��������: ���������� ������ �������������/������������ */
  procedure request_finish(p_request in request.id%type,
    p_user in spr_people.cod_people%type,
    p_role in varchar2,
    p_cause in varchar2);
  /** ����� �� ������������ p_user � ����� p_role ����� ���������
      �������� p_action �� ��������� � ������� p_request */
  function is_action_authorized(p_request in request.id%type,
    p_action in varchar2,
    p_user in spr_people.cod_people%type,
    p_role in varchar2) return boolean;
  function is_action_authorized_sql(p_request in request.id%type,
    p_action in varchar2,
    p_user in spr_people.cod_people%type,
    p_role in varchar2) return integer;

  /** ������������ �������� ������ �������. */
  function request_type_title(p_type in varchar2) return varchar2;
  /** ������������ �������� ��������� �������. */
  function request_status_title(p_status in varchar2) return varchar2;
  /** ������� �� ������ �� ������� �����������. */
  function request_was_transferred(p_id in request.id%type) return boolean;
  function request_was_transferred_sql(p_id in request.id%type) return integer;
  /** ��� �� ������ ����� �� ������ �����������. */
  function request_solved_by_csr(p_id in request.id%type) return boolean;
  function request_solved_by_csr_sql(p_id in request.id%type) return integer;
  /** ����������,  "� ������" ������ ��� ���. */
  function request_in_work(p_id in request.id%type) return boolean;
  function request_in_work_sql(p_id in request.id%type) return integer;
  /** ���������� ����� ������� �� ������. */
  function request_response_time(p_id in request.id%type) return date;
  /** ���������� ����� ���������� ������� */
  function request_work_time(p_id in request.id%type) return long_interval_t;
  /** ���������� ����� ���������� ������� ����� �������*/
  FUNCTION request_work_time_new (p_id request.ID%TYPE) RETURN long_interval_t;
  /** ���������� ��������� �������, ������������ �� ������ ������, � �������,
      ���������� �� ������ ��� �������� �������� SLA */
  function request_time_spent(p_id in request.id%type) return number;
  /** ������� ������� ��������� ������������ ���������� ������� */
  function request_last_suspend_cause(p_id  in request.id%type) return varchar2;
  /** ������� ��������� �������, �������� SLA, ������������ � ������������ ������� */
  function request_priority(p_id in request.id%type) return integer;
  /** ������ ������� �� ����������� ���� */
  function request_status_for_date(p_id in request.id%type, p_date in date)
    return request.status%type;

  /** ������ ��������, ���������� ��� �������� ������������ */
  function active_request_query(p_user in spr_people.cod_people%type,
    p_role in varchar2, p_all_available in integer := 0) return request_view_t pipelined;
  function last_request_query(p_csr in spr_people.cod_people%type) return request_view_t pipelined;
  function center_request_query(p_user in spr_people.cod_people%type) return request_view_t pipelined;

  procedure periods_for_usluga(p_it_usluga in it_usluga.id%type,
    p_type in request.type%type,
    p_react_period out varchar2, 
    p_ustran_period out varchar2,
    p_tip_out number default 0);


  function period_requests_query(p_lower_date in date,
      p_upper_date in date)
    return request_t pipelined;

  function summary_report_query(p_period_start in date, p_period_end in date)
    return summary_report_t pipelined;
    /*������ ������� � �������
    @param p_request - ID ������� �� �. REQUEST
    @param p_cod_people - �������, �������� �������
    @param p_message - ���� �������*/
  Procedure make_note(p_request_id number,p_cod_people number, p_message clob);
    end servicedesk_pkg;
/
