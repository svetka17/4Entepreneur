--
-- OASU  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY ASUNZ.OASU as
  type TProperties is table of VarChar2(256)
    index by VarChar2(32);
  Properties  TProperties;
  function GET_PROP(PROPERTY_NAME VarChar2) return VarChar2 is
  begin
    return Properties(PROPERTY_NAME);
    exception
      when others then
        return null;
  end;
  procedure SET_PROP(PROPERTY_NAME VarChar2, PROPERTY_VALUE VarChar2) is
  begin
    Properties(PROPERTY_NAME) := PROPERTY_VALUE;
  end;

  procedure INIT_USER_PROPERTIES(user_unik Integer) is
    CURSOR mycursor IS
      select prop_name, prop_value
      from menu_prop_values
      where user_id = user_unik;
  begin
    for REC8 in mycursor loop
      SET_PROP(REC8.prop_name, REC8.prop_value);
    end loop;
    exception
      when others then null;
  end;

  function LOGIN(USER_NAME  VarChar2, USER_PASSWORD VarChar2) return Integer is
    user_unik       passw.unik%type;
    user_menu_id    passw.menu_id%type;
    user_cex        passw.cex%type;
    user_kod_otv    passw.kod_otv%type;
    user_buro       passw.buro%type;
    user_is_boss    passw.boss%type;
    user_kod      passw.kod%type;
  begin
    select UNIK,      MENU_ID,      CEX,      KOD_OTV,      BURO,      BOSS,         kod
      into user_unik, user_menu_id, user_cex, user_kod_otv, user_buro, user_is_boss, user_kod
      from passw
      where rtrim(passw.log_us) = user_name and rtrim(passw.pas) = USER_PASSWORD and status>=0;
    
    begin
      select UNIK,         MENU_ID,         CEX,         KOD_OTV,
      BURO,         BOSS,            kod
      into data.usr_unik,  data.usr_menu_id,  data.usr_cex,  data.usr_kod_otv,
      data.usr_buro,  data.usr_is_boss,  data.usr_kod
      from passw
      where rtrim(passw.log_us) = user_name and rtrim(passw.pas) = USER_PASSWORD and status>=0;
      data.usr_name := user_name;
    exception
      when others then null;
    end;

    if user_unik is null then
      return 0;
    else
      SET_PROP('user_name',    USER_NAME    );
      SET_PROP('user_unik',    user_unik    );
      SET_PROP('user_menu_id', user_menu_id );
      SET_PROP('user_cex',     user_cex     );
      SET_PROP('user_kod_otv', user_kod_otv );
      SET_PROP('user_buro',    user_buro    );
      SET_PROP('user_is_boss', user_is_boss );
      SET_PROP('user_kod',    user_kod );
      INIT_USER_PROPERTIES(user_unik);
      return 1;
    end if;
    exception
      when NO_DATA_FOUND then
        return 0;
  end;

  function gD return oasu_data is
  begin
   return data;
  end;

  procedure sD(d oasu_data) is
  begin
   data := d;
  end;

end OASU;
/
