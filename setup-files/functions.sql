/*
andrew henry
12/17/2018
yam database
*/

-- used for logging username changes
create or replace function username_change()
  returns trigger as
$func$
begin
-- we do not need to perform any checks on account
-- since the current_name field is unique
  --code for insert
  if  (tg_op = 'INSERT') then
        insert into username_change(username, current_account_id) 
        values(new.username, new.account_id);
  end if;

  --code for update
  if  (tg_op = 'UPDATE') then
        insert into username_change(username, current_account_id, old_account_id) 
        values(new.username, new.account_id, old.account_id);
  end if;
return new;
end;
$func$
  language plpgsql volatile;

create trigger username_change_trigger
after insert or update on account
for each row 
execute procedure username_change();


-- used for updating scores on posts
create or replace function update_score()
  returns trigger as
$func$
begin
     -- code for insert
     -- no scores currently recorded for insert
     if  (tg_op = 'INSERT') then
        if (new.vote_type = 'up') then 
          update post
          set post_score = post_score + 1
          where post_id = new.post_id;
        end if;

        if (new.vote_type = 'down') then 
          update post
          set post_score = post_score - 1
          where post_id = new.post_id;
        end if;
     end if;

     -- code for update
     if  (tg_op = 'UPDATE') then

        -- old score was null, update new score
        if(old.vote_type is null) THEN
          if (new.vote_type = 'up') then 
            update post
            set post_score = post_score + 1
            where post_id = new.post_id;
          end if;

          if (new.vote_type = 'down') then 
            update post
            set post_score = post_score - 1
            where post_id = new.post_id;
          end if;
        end if;

        -- old score was up
        if(old.vote_type = 'up') THEN
          --downvote from upvote
          if (new.vote_type = 'down') then 
            update post
            set post_score = post_score - 2
            where post_id = new.post_id;
          end if;

          -- undid upvote
          if (new.vote_type is null) then 
            update post
            set post_score = post_score - 1
            where post_id = new.post_id;
          end if;
        end if;

        -- old score was down
        if(old.vote_type = 'down') THEN
          -- new score is up
          if (new.vote_type = 'up') then 
            update post
            set post_score = post_score + 2
            where post_id = new.post_id;
          end if;

          -- undid the downvote
          if (new.vote_type is null) then 
            update post
            set post_score = post_score + 1
            where post_id = new.post_id;
          end if;
        end if;
     end if;
return new;
end;
$func$
  language plpgsql volatile;

create trigger update_score_trigger
after insert or update on vote
for each row 
execute procedure update_score();

-- Function used for creating an account
create or replace function create_account(in in_username varchar(100), in in_device_id varchar(255))
returns bigint as 
$func$
declare 
 v_account_id bigint := -1;
begin
  insert into account(username)
  values (in_username) returning account_id into v_account_id;

  insert into device_link(device_id, account_id)
  values (in_device_id, v_account_id);

  insert into account_roles(account_id)
  values (v_account_id);

  return v_account_id;
end;
$func$
  language plpgsql volatile;


-- Function used for getting all the post ids for a subscription feed
CREATE OR REPLACE FUNCTION get_subscription_post_id(in in_account_id bigint)
RETURNS BIGINT[] AS 
$func$
DECLARE
 v_post_ids bigint[];
 rec record;
 temprow record;
begin 
    FOR temprow IN
        SELECT * FROM subscriptions where account_id = in_account_id
    LOOP
      FOR rec IN 
        select post_id
        from post_coords
        where ST_Distance_Sphere(loc_data::geometry, ST_MakePoint(ST_Y(temprow.loc_data::geometry), ST_X(temprow.loc_data::geometry))) <= 10 * 1609.34
        LOOP
            v_post_ids = array_append(v_post_ids, rec.post_id);
        END LOOP;
    END LOOP;
    return v_post_ids;
end;
$func$
  language plpgsql volatile;