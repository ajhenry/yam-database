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
  if  (tg_op = 'insert') then
        insert into username_change(name, current_account_id) 
        values(new.current_username, new.account_id);
  end if;

  --code for update
  if  (tg_op = 'update') then
        insert into username_change(name, current_account_id, old_account_id) 
        values(new.currentname, new.account_id, old.account_id);
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
     if  (tg_op = 'insert') then
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
     if  (tg_op = 'update') then

        -- old score was null, update new score
        if(old.post_type is null) THEN
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
        if(old.post_type = 'up') THEN
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
        if(old.post_type = 'down') THEN
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