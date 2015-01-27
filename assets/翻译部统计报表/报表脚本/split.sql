CREATE OR REPLACE TYPE type_str_split IS TABLE OF VARCHAR2 (4000);

CREATE OR REPLACE FUNCTION fn_split (p_str IN VARCHAR2, p_delimiter IN VARCHAR2)
    RETURN type_str_split
IS
    j INT := 0;
    i INT := 1;
    len INT := 0;
    len1 INT := 0;
    str VARCHAR2 (4000);
    str_split type_str_split := type_str_split ();
BEGIN
    len := LENGTH (p_str);
    len1 := LENGTH (p_delimiter);

    WHILE j < len
    LOOP
        j := INSTR (p_str, p_delimiter, i);

        IF j = 0
        THEN
            j := len;
             str := SUBSTR (p_str, i);
             str_split.EXTEND;
             str_split (str_split.COUNT) := str;

            IF i >= len
            THEN
                EXIT;
            END IF;
        ELSE
            str := SUBSTR (p_str, i, j - i);
            i := j + len1;
            str_split.EXTEND;
            str_split (str_split.COUNT) := str;
        END IF;
    END LOOP;

    RETURN str_split;
END fn_split;
/

