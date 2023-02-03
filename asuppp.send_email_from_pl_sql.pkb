CREATE OR REPLACE PACKAGE BODY ASUPPP.SEND_EMAIL_FROM_PL_SQL IS
procedure send_email_with_attachment
        ( sender_email_address         varchar2,  -- Must be single E-mail address
          recipient_email_addresses    varchar2,  
          email_subject                varchar2,
          email_body_text              varchar2,
          email_attachment_text        clob,      -- No restriction on size of text
          email_attachment_file_name   varchar2,
          p_charset varchar2 default 'Windows-1251',
          p_contenttype varchar2 default 'text/plain'
        )
 IS
   c                                   utl_tcp.connection;
   rc                                  binary_integer;
   v_next_column                       binary_integer;
   v_recipient_email_length            binary_integer;
   v_recipient_email_addresses         varchar2 (500);
   v_single_recipient_email_addr       varchar2 (100);
   -- Variables to divide the CLOB into buflen character segments to write to the file
   buflen integer := 10000;
   j                                   binary_integer;
   current_position                    binary_integer  :=1;
   email_attachment_text_segment       clob;
   ra RAW(30000);
 BEGIN
   v_recipient_email_addresses := recipient_email_addresses; 
   v_recipient_email_length    := length(v_recipient_email_addresses);
   v_recipient_email_addresses := v_recipient_email_addresses||',';  -- Add comma for the last asddress
   v_next_column  := 1;
   if instr(v_recipient_email_addresses, ',')  = 0 then   
     -- Single E-mail address
     v_single_recipient_email_addr := v_recipient_email_addresses;
     v_recipient_email_length := 1;
   end if;
   -- Open the SMTP port 25 on UWA mailhost local machine
   --c := utl_tcp.open_connection(remote_host =>'10.205.9.34', remote_port => 25, charset => 'CL8MSWIN1251');
   c := utl_tcp.open_connection(remote_host =>'10.205.9.30', remote_port => 25, charset => 'UTF8');
   -- Performs handshaking with the SMTP Server.  HELO is the correct spelling.
   -- DO NOT CHANGE.  Causes problems. 
   rc := utl_tcp.write_line(c, 'HELO localhost');       
   dbms_output.put_line(utl_tcp.get_line(c, TRUE));
   while v_next_column <= v_recipient_email_length 
   loop
     -- Process Multiple E-mail addresses in the loop OR single E-mail address once.
     v_single_recipient_email_addr  := 
       substr( v_recipient_email_addresses, v_next_column,
               instr(v_recipient_email_addresses, ',',v_next_column) -v_next_column
             );
     v_next_column := instr(v_recipient_email_addresses,',',v_next_column)+1;
     rc := utl_tcp.write_line(c, 'MAIL FROM: '||sender_email_address); -- MAIL BOX SENDING THE EMAIL
     dbms_output.put_line(utl_tcp.get_line(c, TRUE));
     rc := utl_tcp.write_line(c, 'RCPT TO: '||v_single_recipient_email_addr);   -- MAIL BOX RECIEVING THE EMAIL
     dbms_output.put_line(utl_tcp.get_line(c, TRUE));
     rc := utl_tcp.write_line(c, 'DATA');                       -- START EMAIL MESSAGE BODY
     dbms_output.put_line(utl_tcp.get_line(c, TRUE));
     rc := utl_tcp.write_line(c, 'Date: '||to_char(current_timestamp, 'Dy, dd Mon yyyy hh24:mi:ss TZH"00"', 'NLS_DATE_LANGUAGE=ENGLISH'));
     rc := utl_tcp.write_line(c, 'From: '||sender_email_address);
     rc := utl_tcp.write_line(c, 'MIME-Version: 1.0');
     rc := utl_tcp.write_line(c,'Content-Type: text/plain; charset='||p_charset); 
     rc := utl_tcp.write_line(c,'Content-Transfer-Encoding: 8bit');
     rc := utl_tcp.write_line(c, 'To: '||v_single_recipient_email_addr);
     rc := utl_tcp.write_line(c, 'Subject: '||email_subject);
     rc := utl_tcp.write_line(c, 'Content-Type: multipart/mixed;');  -- INDICATES THAT THE BODY CONSISTS OF MORE THAN ONE PART
     rc := utl_tcp.write_line(c, ' boundary="-----SECBOUND"');       -- SEPERATOR USED TO SEPERATE THE BODY PARTS
     rc := utl_tcp.write_line(c,'');                                -- DO NOT REMOVE THIS BLANK LINE - MIME STANDARD
     rc := utl_tcp.write_line(c, '-------SECBOUND');
     rc := utl_tcp.write_line(c, 'Content-Type: text/plain');        -- 1ST BODY PART. EMAIL TEXT MESSAGE
     rc := utl_tcp.write_line(c, 'Content-Transfer-Encoding: 7bit');
     rc := utl_tcp.write_line(c,'');
     rc := utl_tcp.write_line(c, email_body_text);                   -- TEXT OF EMAIL MESSAGE
     rc := utl_tcp.write_line(c,'');
     rc := utl_tcp.write_line(c, '-------SECBOUND');
     rc := utl_tcp.write_line(c, 'Content-Type: '||p_contenttype||';');       -- 2ND BODY PART.
     rc := utl_tcp.write_line(c, ' name="' ||email_attachment_file_name || '"');
     rc := utl_tcp.write_line(c, 'Content-Transfer_Encoding: 8bit');
     rc := utl_tcp.write_line(c, 'Content-Disposition: attachment;');-- INDICATES THAT THIS IS AN ATTACHMENT
     rc := utl_tcp.write_line(c,'');
     -- Divide the CLOB into 32000 character segments to write to the file.
     -- Even though SUBSTR looks for 32000 characters, UTL_TCP.WRITE_LINE does not blank pad it.
     current_position := 1;
     j  := (round(length(email_attachment_text))/buflen) + 1;
     dbms_output.put_line('j= '||j||' length=  '||length(email_attachment_text));        
     for i in 1..j 
     loop
       email_attachment_text_segment := substr(email_attachment_text, current_position, buflen);
       --email_attachment_text_segment := DBMS_LOB.SUBSTR(email_attachment_text, buflen, current_position);
       --email_attachment_text_segment := convert(email_attachment_text_segment, 'CL8MSWIN1251');
--       email_attachment_text_segment := convert(email_attachment_text_segment, 'UTF8','CL8ISO8859P5');
       --CL8MSWIN1251
       --CL8ISO8859P5
       email_attachment_text_segment := email_attachment_text_segment;
       rc := UTL_TCP.WRITE_TEXT(c, email_attachment_text_segment);
       --  rc := utl_tcp.write_line(c, ra);
       current_position := current_position + buflen;
     end loop;
     --rc := utl_tcp.write_line(c, email_attachment_text);
     rc := utl_tcp.write_line(c, '-------SECBOUND--');
     rc := utl_tcp.write_line(c,'');
     rc := utl_tcp.write_line(c, '.');                            -- END EMAIL MESSAGE BODY
     dbms_output.put_line(utl_tcp.get_line(c, TRUE));
     dbms_output.put_line('***** Single E-mail= '||v_single_recipient_email_addr||'  '||v_next_column); 
   end loop;
   rc := utl_tcp.write_line(c, 'QUIT');                         -- ENDS EMAIL TRANSACTION
   dbms_output.put_line(utl_tcp.get_line(c, TRUE));
   utl_tcp.close_connection(c);                                 -- CLOSE SMTP PORT CONNECTION
exception
  when others then
    utl_tcp.close_connection(c);
    raise;
END;      --  of Procedure SEND_EMAIL_WITH_ATTACHMENT
procedure send_email_without_attachment
        ( sender_email_address         varchar2,  -- Must be single E-mail address
          recipient_email_addresses    varchar2,  
          email_subject                varchar2,
          email_body_text              varchar2
        )
 IS
   sender varchar2(2000); 
 BEGIN
   sender := sender_email_address;
   if sender is null then
     for q in (
      select PASSW.EMAIL from passw where unik=oasu.get_prop('user_unik')
     ) loop
       sender := q.email;
     end loop;
   end if;
   
   if sender is null then
     sender := 'programm_service@mmk.net';
   end if;
 
   send_email(sender, recipient_email_addresses, email_subject, email_body_text);
   
   INSERT INTO ASUNZ.EMAILS_BUFFER (
   sender_email_address, RECIPIENT_EMAIL_ADDRESSES, EMAIL_SUBJECT, 
   EMAIL_BODY_TEXT, SENT, added) 
   VALUES ( sender,
   recipient_email_addresses,
   email_subject,
   email_body_text,
   sysdate,
   sysdate);
   
   begin
    send_leftovers;
   exception
    when others then null;
   end;
   
 exception
   when others then
     INSERT INTO ASUNZ.EMAILS_BUFFER (
     sender_email_address, RECIPIENT_EMAIL_ADDRESSES, EMAIL_SUBJECT, 
     EMAIL_BODY_TEXT, SENT, added) 
     VALUES (sender ,
     recipient_email_addresses,
     email_subject,
     email_body_text,
     null,
     sysdate);   
     
     STD.DEBUG_MESSAGE('send_email_without_attachment', DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
 END;         --  of Procedure SEND_EMAIL_WITHOUT_ATTACHMENT
  

 procedure send_leftovers is
  n number;
  in_use exception;  pragma exception_init(in_use, -54);
 begin
   loop    
     n := 0;
     for s in (
        select emails_buffer.*, rowid from EMAILS_BUFFER where sent is null and pending is null
        and rownum<2
     ) loop
       begin
         for q in (
           select * from emails_buffer where rowid=s.rowid for update-- nowait
         ) loop
           update emails_buffer set pending=sysdate where rowid=s.rowid;
           send_email(s.sender_email_address, s.recipient_email_addresses, s.email_subject, s.email_body_text);
           update emails_buffer set sent=sysdate where rowid=s.rowid;
           commit;
         end loop;
         n := 1; 
--       exception
--         when in_use then null;
       end;
     end loop;
     exit when n=0;
   end loop;
 end;

procedure send_email
        ( sender_email_address         varchar2,  -- Must be single E-mail address
          recipient_email_addresses    varchar2,  
          email_subject                varchar2,
          email_body_text              varchar2
        )
 IS
   c                                   utl_tcp.connection;
   rc                                  binary_integer;
   v_next_column                       binary_integer;
   v_recipient_email_length            binary_integer;
   v_recipient_email_addresses         varchar2 (2000);
   v_single_recipient_email_addr       varchar2 (100);
   crlf        VARCHAR2(2)  := chr(13)||chr(10);
 BEGIN  
   v_recipient_email_addresses := recipient_email_addresses; 
   v_recipient_email_length    := length(v_recipient_email_addresses);
   v_recipient_email_addresses := v_recipient_email_addresses||',';  --Add comma for the last asddress
   v_next_column  := 1;
   if instr(v_recipient_email_addresses, ',')  = 0 then   
     -- Single E-mail address
     v_single_recipient_email_addr := v_recipient_email_addresses;
     v_recipient_email_length := 1;
   end if;
   -- open the SMTP port 25 on UWA mailhost local machine
   c := utl_tcp.open_connection(remote_host =>'10.205.9.34', remote_port => 25, charset => 'CL8MSWIN1251');
   dbms_output.put_line(utl_tcp.get_line(c, TRUE));
   -- Performs handshaking with the SMTP Server.  HELO is the correct spelling.
   -- DO NOT CHANGE.  Causes problems.
   rc := utl_tcp.write_line(c, 'HELO localhost');
   dbms_output.put_line(utl_tcp.get_line(c, TRUE));
   while v_next_column <= v_recipient_email_length 
   loop
     -- Process Multiple E-mail addresses in the loop or single E-mail address once.
     v_single_recipient_email_addr  := 
       substr( v_recipient_email_addresses, v_next_column,
               instr(v_recipient_email_addresses, ',',v_next_column) -v_next_column              );
     v_next_column := instr(v_recipient_email_addresses,',',v_next_column)+1;    
     rc := utl_tcp.write_line(c, 'MAIL FROM: '||sender_email_address);
     dbms_output.put_line(utl_tcp.get_line(c, TRUE));
     rc := utl_tcp.write_line(c, 'RCPT TO: '||v_single_recipient_email_addr);
     dbms_output.put_line(utl_tcp.get_line(c, TRUE));
     rc := utl_tcp.write_line(c, 'DATA');                   -- Start E-mail message body
     dbms_output.put_line(utl_tcp.get_line(c, TRUE));
     rc := utl_tcp.write_line(c, 'Date: '||to_char(current_timestamp, 'Dy, dd Mon yyyy hh24:mi:ss TZH"00"', 'NLS_DATE_LANGUAGE=ENGLISH'));
     rc := utl_tcp.write_line(c, 'From: '||sender_email_address);
     rc := utl_tcp.write_line(c, 'MIME-Version: 1.0');
     rc := utl_tcp.write_line(c,'Content-Type: text/plain; charset=Windows-1251'); 
     rc := utl_tcp.write_line(c,'Content-Transfer-Encoding: 8bit');
     rc := utl_tcp.write_line(c, 'To: '||v_single_recipient_email_addr);
     rc := utl_tcp.write_line(c, 'Subject: '||email_subject);
     rc := utl_tcp.write_line(c,''); 
     rc := utl_tcp.write_line(c,''); 
     rc := utl_tcp.write_line(c, email_body_text);
     rc := utl_tcp.write_line(c, '\\\ Сообщение отправлено автоматически программным обеспечением корпоративной информационной системы ');
--     rc := utl_tcp.write_line(c, 'Войти в систему: http://oas:7778/forms/frmservlet?form=frmLogin.fmx');
     rc := utl_tcp.write_line(c, '.');                      -- End of E-mail message body
     dbms_output.put_line(utl_tcp.get_line(c, TRUE));
     dbms_output.put_line('***** Single E-mail= '||v_single_recipient_email_addr||'  '||v_next_column); 
   end loop;
   rc := utl_tcp.write_line(c, 'QUIT');      -- End E-mail transaction
   dbms_output.put_line(utl_tcp.get_line(c, TRUE));
   utl_tcp.close_connection(c);                           -- Close the connection
 END;         --  of Procedure SEND_EMAIL_WITHOUT_ATTACHMENT


END;         --  of Specification for Package SEND_EMAIL_FROM_PL_SQL
/
