-- Delete all user objects using this procedure

BEGIN
    FOR cur_rec IN (
        SELECT object_name, object_type
        FROM user_objects
        WHERE object_type IN ('TABLE', 'VIEW', 'PACKAGE', 'PROCEDURE', 'FUNCTION', 'SEQUENCE')
    )
    LOOP
    BEGIN
        IF cur_rec.object_type = 'TABLE' THEN
            EXECUTE IMMEDIATE 'DROP ' || cur_rec.object_type || ' "' || cur_rec.object_name || '" CASCADE CONSTRAINTS';
        ELSE
            EXECUTE IMMEDIATE 'DROP ' || cur_rec.object_type || ' "' || cur_rec.object_name || '"';
        END IF;
        EXCEPTION
        WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('FAILED: DROP ' || cur_rec.object_type || ' "' || cur_rec.object_name || '"' );
    END;
    END LOOP;
END;
/

/*
BEGIN
    -- Dropping Tables
    FOR i in (select 'DROP TABLE ' || table_name || ' CASCADE CONSTRAINTS' tbl from user_tables) 
    loop
        EXECUTE immediate i.tbl;
    END loop;
    
    -- Dropping Sequences
    FOR i in (select 'DROP SEQUENCE ' || sequence_name || '' seq from user_sequences) 
    loop
        EXECUTE immediate i.seq;
    END loop;

    -- Dropping Triggers
    FOR i in (select 'DROP TRIGGER ' || trigger_name || '' trig from user_triggers) 
    loop
        EXECUTE immediate i.trig;
    END loop;

    -- Dropping Procedures
    FOR i in (select 'DROP PROCEDURE ' || object_name || '' proc from user_procedures) 
    loop
        EXECUTE immediate i.proc;
    END loop;
END;
/
*/