--
-- DBF2ORA  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY ASUPPP.DBF2ORA
AS
   -- MIGHT HAVE TO CHANGE ON YOUR PLATFORM!!!
   -- CONTROLS THE BYTE ORDER OF BINARY INTEGERS READ IN
   -- FROM THE FOXPRO FILE
   BIG_ENDIAN CONSTANT   BOOLEAN DEFAULT TRUE ;

   TYPE DBF_HEADER
   IS
      RECORD (
         VERSION      VARCHAR2 (25),                  -- FOXPRO VERSION NUMBER
         YEAR         INT,                     -- 1 BYTE INT YEAR, ADD TO 1900
         MONTH        INT,                                     -- 1 BYTE MONTH
         DAY          INT,                                       -- 1 BYTE DAY
         NO_RECORDS   INT,                       -- NUMBER OF RECORDS IN FILE,
         -- 4 BYTE INT
         HDR_LEN      INT,                     -- LENGTH OF HEADER, 2 BYTE INT
         REC_LEN      INT,                       -- NUMBER OF BYTES IN RECORD,
         -- 2 BYTE INT
         NO_FIELDS    INT                                  -- NUMBER OF FIELDS
      );

   TYPE FIELD_DESCRIPTOR
   IS
      RECORD (
         NAME       VARCHAR2 (11),
         TYPE       CHAR (1),
         LENGTH     INT,                                      -- 1 BYTE LENGTH
         DECIMALS   INT                                        -- 1 BYTE SCALE
      );

   TYPE FIELD_DESCRIPTOR_ARRAY
   IS
      TABLE OF FIELD_DESCRIPTOR
         INDEX BY BINARY_INTEGER;

   TYPE ROWARRAY
   IS
      TABLE OF VARCHAR2 (4000)
         INDEX BY BINARY_INTEGER;

   G_CURSOR              BINARY_INTEGER DEFAULT DBMS_SQL.OPEN_CURSOR ;

   -- FUNCTION TO CONVERT A BINARY UNSIGNED INTEGER
   -- INTO A PLSQL NUMBER
   FUNCTION TO_INT (P_DATA IN VARCHAR2)
      RETURN NUMBER
   IS
      L_NUMBER   NUMBER DEFAULT 0 ;
      L_BYTES    NUMBER DEFAULT LENGTH (P_DATA) ;
   BEGIN
      IF (BIG_ENDIAN)
      THEN
         FOR I IN 1 .. L_BYTES
         LOOP
            L_NUMBER :=
               L_NUMBER
               + ASCII (SUBSTR (P_DATA, I, 1)) * POWER (2, 8 * (I - 1));
         END LOOP;
      ELSE
         FOR I IN 1 .. L_BYTES
         LOOP
            L_NUMBER :=
               L_NUMBER
               + ASCII (SUBSTR (P_DATA, L_BYTES - I + 1, 1))
                 * POWER (2, 8 * (I - 1));
         END LOOP;
      END IF;

      RETURN L_NUMBER;
   END TO_INT;

   FUNCTION MYTRIM (P_STR IN VARCHAR2)
      RETURN VARCHAR2
   IS
      I       NUMBER;
      J       NUMBER;
      V_RES   VARCHAR2 (100);
   BEGIN
      FOR I IN 1 .. 11
      LOOP
         IF ASCII (SUBSTR (P_STR, I, 1)) = 0
         THEN
            J := I;
            EXIT;
         END IF;
      END LOOP;

      V_RES := SUBSTR (P_STR, 1, J - 1);
      RETURN V_RES;
   END MYTRIM;

   PROCEDURE GET_HEADER (P_BFILE          IN     BFILE,
                         P_BFILE_OFFSET   IN OUT NUMBER,
                         P_HDR            IN OUT DBF_HEADER,
                         P_FLDS           IN OUT FIELD_DESCRIPTOR_ARRAY)
   IS
      L_DATA              VARCHAR2 (100);
      L_HDR_SIZE          NUMBER DEFAULT 32 ;
      L_FIELD_DESC_SIZE   NUMBER DEFAULT 32 ;
      L_FLDS              FIELD_DESCRIPTOR_ARRAY;
   BEGIN
      P_FLDS := L_FLDS;
      L_DATA :=
         UTL_RAW.CAST_TO_VARCHAR2 (
            DBMS_LOB.SUBSTR (P_BFILE, L_HDR_SIZE, P_BFILE_OFFSET)
         );
      P_BFILE_OFFSET := P_BFILE_OFFSET + L_HDR_SIZE;
      P_HDR.VERSION := ASCII (SUBSTR (L_DATA, 1, 1));
      P_HDR.YEAR := 1900 + ASCII (SUBSTR (L_DATA, 2, 1));
      P_HDR.MONTH := ASCII (SUBSTR (L_DATA, 3, 1));
      P_HDR.DAY := ASCII (SUBSTR (L_DATA, 4, 1));
      P_HDR.NO_RECORDS := TO_INT (SUBSTR (L_DATA, 5, 4));
      P_HDR.HDR_LEN := TO_INT (SUBSTR (L_DATA, 9, 2));
      P_HDR.REC_LEN := TO_INT (SUBSTR (L_DATA, 11, 2));
      P_HDR.NO_FIELDS :=
         TRUNC ( (P_HDR.HDR_LEN - L_HDR_SIZE) / L_FIELD_DESC_SIZE);

      FOR I IN 1 .. P_HDR.NO_FIELDS
      LOOP
         L_DATA :=
            UTL_RAW.CAST_TO_VARCHAR2 (
               DBMS_LOB.SUBSTR (P_BFILE, L_FIELD_DESC_SIZE, P_BFILE_OFFSET)
            );
         P_BFILE_OFFSET := P_BFILE_OFFSET + L_FIELD_DESC_SIZE;
         /*
         P_FLDS(I).NAME := RTRIM(SUBSTR(L_DATA,1,11),CHR(0));
         P_FLDS(I).TYPE := SUBSTR( L_DATA, 12, 1 );
         P_FLDS(I).LENGTH := ASCII( SUBSTR( L_DATA, 17, 1 ) );
         P_FLDS(I).DECIMALS := ASCII(SUBSTR(L_DATA,18,1) );
         */
         P_FLDS (I).NAME := MYTRIM (SUBSTR (L_DATA, 1, 11));
         P_FLDS (I).TYPE := SUBSTR (L_DATA, 12, 1);
         P_FLDS (I).LENGTH := ASCII (SUBSTR (L_DATA, 17, 1));
         P_FLDS (I).DECIMALS := ASCII (SUBSTR (L_DATA, 18, 1));
      END LOOP;

      P_BFILE_OFFSET :=
         P_BFILE_OFFSET + MOD (P_HDR.HDR_LEN - L_HDR_SIZE, L_FIELD_DESC_SIZE);
   END GET_HEADER;

   FUNCTION BUILD_INSERT (P_TNAME    IN VARCHAR2,
                          P_CNAMES   IN VARCHAR2,
                          P_FLDS     IN FIELD_DESCRIPTOR_ARRAY)
      RETURN VARCHAR2
   IS
      L_INSERT_STATEMENT   LONG;
   BEGIN
      L_INSERT_STATEMENT := 'insert into ' || P_TNAME || '(';

      IF (P_CNAMES IS NOT NULL)
      THEN
         L_INSERT_STATEMENT := L_INSERT_STATEMENT || P_CNAMES || ') values (';
      ELSE
         FOR I IN 1 .. P_FLDS.COUNT
         LOOP
            IF (I <> 1)                                                  --???
            THEN
               L_INSERT_STATEMENT := L_INSERT_STATEMENT || ',';
            END IF;

            L_INSERT_STATEMENT :=
               L_INSERT_STATEMENT || '"' || P_FLDS (I).NAME || '"';
         END LOOP;

         L_INSERT_STATEMENT := L_INSERT_STATEMENT || ') values (';
      END IF;

      FOR I IN 1 .. P_FLDS.COUNT
      LOOP
         IF (I <> 1)                                                     --???
        THEN
            L_INSERT_STATEMENT := L_INSERT_STATEMENT || ',';
        END IF;

         IF (P_FLDS (I).TYPE = 'D')
         THEN
            L_INSERT_STATEMENT :=
               L_INSERT_STATEMENT || 'to_date(:bv' || I || ',''yyyymmdd'' )';
         ELSE
            L_INSERT_STATEMENT := L_INSERT_STATEMENT || ':bv' || I;
         END IF;
      END LOOP;

      L_INSERT_STATEMENT := L_INSERT_STATEMENT || ')';
      RETURN L_INSERT_STATEMENT;
   END BUILD_INSERT;

   FUNCTION GET_ROW (P_BFILE          IN     BFILE,
                     P_BFILE_OFFSET   IN OUT NUMBER,
                     P_HDR            IN     DBF_HEADER,
                     P_FLDS           IN     FIELD_DESCRIPTOR_ARRAY)
      RETURN ROWARRAY
   IS
      L_DATA   VARCHAR2 (4000);
      L_ROW    ROWARRAY;
      L_N      NUMBER DEFAULT 2 ;
   BEGIN
      L_DATA :=
           UTL_RAW.CAST_TO_VARCHAR2 (
              DBMS_LOB.SUBSTR (P_BFILE, P_HDR.REC_LEN, P_BFILE_OFFSET)
           );
      P_BFILE_OFFSET := P_BFILE_OFFSET + P_HDR.REC_LEN;
      L_ROW (0) := SUBSTR (L_DATA, 1, 1);

      FOR I IN 1 .. P_HDR.NO_FIELDS
      LOOP
         L_ROW (I) := RTRIM (LTRIM (SUBSTR (L_DATA, L_N, P_FLDS (I).LENGTH)));

         IF (P_FLDS (I).TYPE = 'F' AND L_ROW (I) = ',')
         THEN
            L_ROW (I) := NULL;
         END IF;
         
         if p_flds(i).type in ('F', 'N') then
            L_ROW (I) := replace(l_row(i), '.', ',');
          --  STD.DEBUG_MESSAGE('dbftoora',L_ROW(I)||' '||p_flds(i).name);
         end if;
         
         l_row (i) := CONVERT(l_row(i), 'CL8ISO8859P5', 'RU8PC866');--CL8MSWIN1251
 
         
         L_N := L_N + P_FLDS (I).LENGTH;
      END LOOP;

      RETURN L_ROW;
   END GET_ROW;
   
      FUNCTION GET_ROW_ (P_BFILE          IN     BFILE,
                     P_BFILE_OFFSET   IN OUT NUMBER,
                     P_HDR            IN     DBF_HEADER,
                     P_FLDS           IN     FIELD_DESCRIPTOR_ARRAY)
      RETURN ROWARRAY
   IS
      L_DATA   VARCHAR2 (4000);
      L_ROW    ROWARRAY;
      L_N      NUMBER DEFAULT 2 ;
   BEGIN
      L_DATA :=
           UTL_RAW.CAST_TO_VARCHAR2 (
              DBMS_LOB.SUBSTR (P_BFILE, P_HDR.REC_LEN, P_BFILE_OFFSET)
           );
           dbms_output.put_line(l_data);
           
      P_BFILE_OFFSET := P_BFILE_OFFSET + P_HDR.REC_LEN;
      L_ROW (0) := SUBSTR (L_DATA, 1, 1);

      FOR I IN 1 .. P_HDR.NO_FIELDS
      LOOP
         L_ROW (I) := RTRIM (LTRIM (SUBSTR (L_DATA, L_N, P_FLDS (I).LENGTH)));

         IF (P_FLDS (I).TYPE = 'F' AND L_ROW (I) = ',')
         THEN
            L_ROW (I) := NULL;
         END IF;
         
         if p_flds(i).type in ('F', 'N') then
            L_ROW (I) := replace(l_row(i), '.', ',');
          --  STD.DEBUG_MESSAGE('dbftoora',L_ROW(I)||' '||p_flds(i).name);
         end if;
         
        l_row (i) := CONVERT(l_row(i),  'CL8ISO8859P5', 'CL8MSWIN1251');--CL8MSWIN1251
 
         
         L_N := L_N + P_FLDS (I).LENGTH;
      END LOOP;

      RETURN L_ROW;
   END GET_ROW_;

   PROCEDURE SHOW (P_HDR      IN DBF_HEADER,
                   P_FLDS     IN FIELD_DESCRIPTOR_ARRAY,
                   P_TNAME    IN VARCHAR2,
                   P_CNAMES   IN VARCHAR2,
                   P_BFILE    IN BFILE)
   IS
      L_SEP   VARCHAR2 (1) DEFAULT ',' ;

      PROCEDURE P (P_STR IN VARCHAR2)
      IS
         L_STR   LONG DEFAULT P_STR ;
      BEGIN
         WHILE (L_STR IS NOT NULL)
         LOOP
            DBMS_OUTPUT.PUT_LINE (SUBSTR (L_STR, 1, 250));
            L_STR := SUBSTR (L_STR, 251);
         END LOOP;
      END;
   BEGIN
      P ('/*');
      P ('Size of FoxPro File: ' || DBMS_LOB.GETLENGTH (P_BFILE));
      P ('FoxPro Header Information: ');
      P (CHR (9) || 'Version = ' || P_HDR.VERSION);
      P (CHR (9) || 'Year = ' || P_HDR.YEAR);
      P (CHR (9) || 'Month = ' || P_HDR.MONTH);
      P (CHR (9) || 'Day = ' || P_HDR.DAY);
      P (CHR (9) || '#Recs = ' || P_HDR.NO_RECORDS);
      P (CHR (9) || 'Hdr Len = ' || P_HDR.HDR_LEN);
      P (CHR (9) || 'Rec Len = ' || P_HDR.REC_LEN);
      P (CHR (9) || '#Fields = ' || P_HDR.NO_FIELDS);
      P (CHR (10) || '-Data Fields:');

      FOR I IN 1 .. P_HDR.NO_FIELDS
      LOOP
         P(   'Field('
           || I
           || ') '
           || 'Name = "'
           || P_FLDS (I).NAME
           || '", '
           || 'Type = '
           || P_FLDS (I).TYPE
           || ', '
           || 'Len = '
           || P_FLDS (I).LENGTH
           || ', '
           || 'Scale= '
           || P_FLDS (I).DECIMALS);
      END LOOP;

      P (CHR (10) || 'Insert We would use:');
      P (BUILD_INSERT (P_TNAME, P_CNAMES, P_FLDS));
      P (CHR (10) || 'Table that could be created to hold data:');
      P ('*/');
      P ('create table ' || P_TNAME);
      P ('(');

      FOR I IN 1 .. P_HDR.NO_FIELDS
      LOOP
         IF (I = P_HDR.NO_FIELDS)
         THEN
            L_SEP := ')';
         END IF;

         DBMS_OUTPUT.PUT (CHR (9) || '"' || P_FLDS (I).NAME || '" ');

         IF (P_FLDS (I).TYPE = 'D')
         THEN
            P ('date' || L_SEP);
         ELSIF (P_FLDS (I).TYPE = 'F')
         THEN
            P ('float' || L_SEP);
         ELSIF (P_FLDS (I).TYPE = 'N')
         THEN
            IF (P_FLDS (I).DECIMALS > 0)
            THEN
               P(   'number('
                 || P_FLDS (I).LENGTH
                 || ','
                 || P_FLDS (I).DECIMALS
                 || ')'
                 || L_SEP);
            ELSE
               P ('number(' || P_FLDS (I).LENGTH || ')' || L_SEP);
            END IF;
         ELSE
            P ('varchar2(' || P_FLDS (I).LENGTH || ')' || L_SEP);
         END IF;
      END LOOP;

      P ('/');
   END SHOW;

   PROCEDURE LOAD_TABLE (P_DIR      IN VARCHAR2,
                         P_FILE     IN VARCHAR2,
                         P_TNAME    IN VARCHAR2,
                         P_CNAMES   IN VARCHAR2 DEFAULT NULL ,
                         P_SHOW     IN BOOLEAN DEFAULT FALSE )
   IS
      L_BFILE    BFILE;
      L_OFFSET   NUMBER DEFAULT 1 ;
      L_HDR      DBF_HEADER;
      L_FLDS     FIELD_DESCRIPTOR_ARRAY;
      L_ROW      ROWARRAY;
   BEGIN
      L_BFILE := BFILENAME (P_DIR, P_FILE);
      DBMS_LOB.FILEOPEN (L_BFILE);
      GET_HEADER (L_BFILE,
                  L_OFFSET,
                  L_HDR,
                  L_FLDS);

      IF (P_SHOW)
      THEN
         SHOW (L_HDR,
               L_FLDS,
               P_TNAME,
               P_CNAMES,
               L_BFILE);
      ELSE
         DBMS_SQL.PARSE (G_CURSOR,
                         BUILD_INSERT (P_TNAME, P_CNAMES, L_FLDS),
                         DBMS_SQL.NATIVE);

         FOR I IN 1 .. L_HDR.NO_RECORDS
         LOOP
            L_ROW :=
               GET_ROW (L_BFILE,
                        L_OFFSET,
                        L_HDR,
                        L_FLDS);

            IF (L_ROW (0) <> '*')                         --??? DELETED RECORD
            THEN
               FOR I IN 1 .. L_HDR.NO_FIELDS
               LOOP
                  DBMS_OUTPUT.put_line (
                     l_flds (i).name || ' = ' || l_row (i)
                  );
                  DBMS_SQL.BIND_VARIABLE (G_CURSOR,
                                          ':bv' || I,
                                          L_ROW (I),
                                          4000);
               END LOOP;

               IF (DBMS_SQL.EXECUTE (G_CURSOR) <> 1)                       --??
               THEN
                  RAISE_APPLICATION_ERROR (-20001,
                                           'Insert failed ' || SQLERRM);
               END IF;
            END IF;
         END LOOP;
      END IF;

      DBMS_LOB.FILECLOSE (L_BFILE);
   EXCEPTION
      WHEN OTHERS
      THEN
         IF (DBMS_LOB.ISOPEN (L_BFILE) > 0)
         THEN
            DBMS_LOB.FILECLOSE (L_BFILE);
         END IF;

         RAISE;
   END LOAD_TABLE;
   
      PROCEDURE LOAD_TABLE_PIB (P_DIR      IN VARCHAR2,
                         P_FILE     IN VARCHAR2,
                         P_TNAME    IN VARCHAR2,
                         P_CNAMES   IN VARCHAR2 DEFAULT NULL ,
                         P_SHOW     IN BOOLEAN DEFAULT FALSE )
   IS
      L_BFILE    BFILE;
      L_OFFSET   NUMBER DEFAULT 1 ;
      L_HDR      DBF_HEADER;
      L_FLDS     FIELD_DESCRIPTOR_ARRAY;
      L_ROW      ROWARRAY;
   BEGIN
      L_BFILE := BFILENAME (P_DIR, P_FILE);
      DBMS_LOB.FILEOPEN (L_BFILE);
      GET_HEADER (L_BFILE,
                  L_OFFSET,
                  L_HDR,
                  L_FLDS);

      IF (P_SHOW)
      THEN
         SHOW (L_HDR,
               L_FLDS,
               P_TNAME,
               P_CNAMES,
               L_BFILE);
      ELSE
         DBMS_SQL.PARSE (G_CURSOR,
                     --   convert( 
                        BUILD_INSERT (P_TNAME, P_CNAMES, L_FLDS),
                       --  'CL8ISO8859P5'), --CL8MSWIN1251
                         DBMS_SQL.NATIVE);

         FOR I IN 1 .. L_HDR.NO_RECORDS
         LOOP
            L_ROW :=
               GET_ROW_ (L_BFILE,
                        L_OFFSET,
                        L_HDR,
                        L_FLDS);

            IF (L_ROW (0) <> '*')                         --??? DELETED RECORD
            THEN
               FOR I IN 1 .. L_HDR.NO_FIELDS
               LOOP
                  DBMS_OUTPUT.put_line (
                     l_flds (i).name || ' = ' || l_row (i)
                  );
                  DBMS_SQL.BIND_VARIABLE (G_CURSOR,
                                          ':bv' || I,
                                          L_ROW (I),
                                          4000);
               END LOOP;

               IF (DBMS_SQL.EXECUTE (G_CURSOR) <> 1)                       --??
               THEN
                  RAISE_APPLICATION_ERROR (-20001,
                                           'Insert failed ' || SQLERRM);
               END IF;
            END IF;
         END LOOP;
      END IF;

      DBMS_LOB.FILECLOSE (L_BFILE);
   EXCEPTION
      WHEN OTHERS
      THEN
         IF (DBMS_LOB.ISOPEN (L_BFILE) > 0)
         THEN
            DBMS_LOB.FILECLOSE (L_BFILE);
         END IF;

         RAISE;
   END LOAD_TABLE_PIB;
END DBF2ORA;
/
