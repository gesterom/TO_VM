DELIMITER $$$
CREATE OR REPLACE PROCEDURE exec(
    in func varchar(64),
    in tab varchar(64),
    out output varchar(64)
)
BEGIN
    IF func = 'COUNT' THEN
        set output = ( SELECT COUNT(*) FROM osoba GROUP BY tab);
    ELSEIF func = 'GROUP_CONCAT' THEN
            IF tab != 'id' THEN
                set @temp  = CONCAT( 'SELECT GROUP_CONCAT(', tab ,') INTO @out FROM osoba ;');
                PREPARE stmp FROM @temp;
                EXECUTE stmp ;
                set output = @out;
            END IF;
    END IF;
END;$$$
DELIMITER ;
