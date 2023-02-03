--
-- OASU  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   PASSW (Table)
--
CREATE OR REPLACE PACKAGE ASUNZ.OASU as
--
-- пакет для работы со свойствами
--
  function  GET_PROP(PROPERTY_NAME VarChar2) return VarChar2;
                                   -- получить значение свойства
                                   -- если такого нет, то null
                                   --
  procedure SET_PROP(PROPERTY_NAME VarChar2, PROPERTY_VALUE VarChar2);
                                   -- установить значение свойства
                                   --
  procedure INIT_USER_PROPERTIES(user_unik Integer);
                                   -- вызвать 1 раз при входе в систему для
                                   -- заполнения свойств пользователя. свойство "user_unik" должно
                                   -- быть заполнено до вызова INIT_USER_PROPERTIES
                                   --
  function LOGIN(USER_NAME VarChar2, USER_PASSWORD VarChar2) return Integer;
                                   -- выполнить вход в систему с присвоением всех properties
                                   -- 0 или null - не вошли, 1 - вошли

  type oasu_data is record(                                   
  	usr_name				passw.log_us%type,
  	usr_unik        passw.unik%type,
  	usr_menu_id     passw.menu_id%type,
  	usr_cex         passw.cex%type,
  	usr_kod_otv     passw.kod_otv%type,
  	usr_buro        passw.buro%type,
  	usr_is_boss     passw.boss%type,
  	usr_kod		      passw.kod%type,
	  
  	g_god						number,
  	g_mes						number
  );
  data oasu_data;
  
	function gD return oasu_data;
	procedure sD(d oasu_data);
	
end OASU;
/
