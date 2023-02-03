--
-- SEND_EMAIL_FROM_PL_SQL  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--
CREATE OR REPLACE PACKAGE ASUPPP.SEND_EMAIL_FROM_PL_SQL IS
procedure send_email_with_attachment
        ( sender_email_address         varchar2,  -- Must be single E-mail address
          recipient_email_addresses    varchar2,
          email_subject                varchar2,
          email_body_text              varchar2,
          email_attachment_text        clob,      -- No restriction on size of text
          email_attachment_file_name   varchar2,
          p_charset varchar2 default 'Windows-1251',
          p_contenttype varchar2 default 'text/plain'
        );
procedure send_email_without_attachment
        ( sender_email_address         varchar2,  -- Must be single E-mail address
          recipient_email_addresses    varchar2,
          email_subject                varchar2,
          email_body_text              varchar2
        );
procedure send_email
        ( sender_email_address         varchar2,  -- Must be single E-mail address
          recipient_email_addresses    varchar2,
          email_subject                varchar2,
          email_body_text              varchar2
        );
procedure send_leftovers;        
END;      ----    of Specification for Package SEND_EMAIL_FROM_PL_SQL
/
