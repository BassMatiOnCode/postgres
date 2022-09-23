\echo -- Creating database functions and procedures

CREATE or replace FUNCTION incrementRowGen ( ) returns trigger as $$ BEGIN
-- Increment row generation counter in a record.
IF new.rg is null OR old.rg + 1 = new.rg THEN
	new.rg := old.rg + 1 ;
	return new ;
ELSE
	return null ;
END IF ; 
END ; $$ LANGUAGE PLPGSQL ;
