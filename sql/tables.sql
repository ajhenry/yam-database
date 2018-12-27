/*
andrew henry
12/17/2018
yam database
*/
--set all constaints deferred;

-- test table for connectivity checks
create table test_table(
    test_key int default 1
);

-- used for checking for emails
create domain email_field as citext
check ( value ~ '^[a-za-z0-9.!#$%&''*+/=?^_`{|}~-]+@[a-za-z0-9](?:[a-za-z0-9-]{0,61}[a-za-z0-9])?(?:\.[a-za-z0-9](?:[a-za-z0-9-]{0,61}[a-za-z0-9])?)*$' );


-- account (since user is a reserved word :| ) table
create table account(
    account_id bigserial primary key,
    email email_field,
    password bytea,
    name varchar(254),
    current_username varchar(100) unique not null  
);

-- username change event table
create table username_change(
    username_change_id bigserial primary key,
    username varchar(100),
    current_account_id bigint references account(account_id) deferrable initially immediate,
    old_account_id bigint references account(account_id) default null,
    update_time timestamp default CURRENT_TIMESTAMP
);

-- used for storing device id's to a user
create table device_link(
    device_id varchar(255) primary key,
    account_id bigint references account(account_id),
    creation_date timestamp default CURRENT_TIMESTAMP,
    update_date timestamp default CURRENT_TIMESTAMP
);

-- view used for grabbing account info for a given device
create view account_info as
    select * 
    from account a
    natural join device_link dl;


-- table for posts/comments
create table post(
    post_id bigserial primary key,
    post_type varchar(10) check(post_type in ('comment', 'post')),
    content_title varchar(100),
    content_body varchar(400) not null,
    resource_type varchar(6) check(resource_type in ('video', 'image', 'gif', 'other')),
    resource_url varchar(2085),
    parent_id bigint references post(post_id),
    author_id bigint references account(account_id),
    current_author_name varchar(100),
    current_author_image varchar(2085),
    post_date timestamp default CURRENT_TIMESTAMP,
    post_score bigint default 0
);

-- store location data about posts
create table post_coords(
    post_id bigint references post(post_id),
    loc_data geography
);

-- create an index based on the location for faster lookup
create index on post_coords using gist (loc_data);

-- table for storing votes on posts
create table vote(
    vote_id bigserial primary key,
    post_id bigint references post(post_id),
    vote_type varchar(6) check(vote_type in ('up', 'down', null)),
    account_id bigint references account(account_id)
);