/*
Andrew Henry
12/17/2018
Yam Database
*/

-- Used for checking username changes
CREATE OR REPLACE FUNCTION UserNameChange()
  RETURNS trigger AS
$func$
DECLARE
    _currentUsernameCount INTEGER := 0;
begin
SELECT count(Id) INTO _currentUsernameCount
FROM Account
WHERE CurrentName = NEW.CurrentName;

if _currentUsernameCount = 0 then
     --code for Insert
     if  (TG_OP = 'INSERT') then
           SET CONSTRAINTS ALL DEFERRED;
           INSERT INTO UsernameChange(Name, CurrentUserId) 
           VALUES(NEW.CurrentName, NEW.Id);
     end if;

     --code for update
     if  (TG_OP = 'UPDATE') then
           INSERT INTO UsernameChange(Name, CurrentUserId, OldUserId) 
           VALUES(NEW.CurrentName, NEW.Id, OLD.Id);
     end if;
end if;
return new;
end;
$func$
  LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER mytrigger
BEFORE INSERT OR UPDATE ON Account
FOR EACH ROW 
EXECUTE PROCEDURE UserNameChange();