insert into test_table
values(1);

select create_account('andrew_dev', 'andrew_dev_device');

select create_account('andrew_dev2', 'andrew_dev_device2');

insert into post(post_type, content_body, author_id)
values('post', 'auto gen post 1', 1);

insert into post(post_type, content_body, author_id)
values('post', 'auto gen post 2', 1);

insert into post(post_type, content_body, author_id)
values('post', 'auto gen post 3', 2);

insert into post(post_type, content_body, author_id)
values('post', 'auto gen post 4', 2);

insert into post(post_type, content_body, author_id)
values('post', 'auto gen post 5', 2);

insert into post(post_type, content_body, parent_id, author_id)
values('post', 'auto gen comment 1', 1, 2);


insert into vote(post_id, vote_type, account_id)
values(1, 'up', 1) 
ON CONFLICT (post_id, account_id) DO UPDATE 
SET vote_type = excluded.vote_type;

insert into vote(post_id, vote_type, account_id)
values(1, 'up', 2) 
ON CONFLICT (post_id, account_id) DO UPDATE 
SET vote_type = excluded.vote_type;