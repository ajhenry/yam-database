insert into test_table
values(1);

insert into account(current_username)
values('banana');

insert into account(current_username) 
values('andrew-dev') 
returning account_id;

insert into device_link(device_id, account_id)
values('andrew-dev-phone', 
    (
        select account_id
        from account
        where current_username = 'andrew-dev'
    )
);

