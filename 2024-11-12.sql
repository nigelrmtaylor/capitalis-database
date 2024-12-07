

select * from pg_extension;

create extension btree_gist;

create extension periods;

CREATE TABLE example (
    id bigint,
    start_date date,
    end_date date
);

SELECT periods.add_period('example', 'validity', 'start_date', 'end_date');
SELECT periods.add_unique_key('example', ARRAY['id'], 'validity');

select * from example as of timestamp '2022-01-01';

CREATE TABLE person (
    id bigint,
    start_date date,
    end_date date
);

create table test1 (
  id serial primary key,
  status varchar (30) default 'on'
);
select periods.add_system_time_period ('test1', 'row_start', 'row_end');
select periods.add_system_versioning ('test1');

insert into test1 (status) values ('on');

insert into test1 (status) values ('off');

insert into test1 (status) values ('on');

SELECT * FROM test1__as_of (now ());

create table test2 (
  id serial primary key,
  status varchar (30) default 'on'
);

select periods.add_system_time_period ('test2', 'valid_from', 'valid_to');

select periods.add_system_versioning ('test2');

insert into test2 (status) values ('on');

update test2 set status = 'off' where id = 1;

update test2 set status = 'on' where id = 1;

SELECT * FROM test2__as_of (now ());

drop table customer
create table customer (
  id bigserial primary key,
  customer_number text,
  name text not null,
  customer_type text,
  valid_from timestamptz,
  valid_to timestamptz,
  known_from timestamptz,
  known_to timestamptz
);
SELECT periods.add_period('customer',
                          'validity',
                          'valid_from',
                          'valid_to');
SELECT periods.add_period('customer',
                          'knowledge',
                          'known_from',
                          'known_to');
select periods.add_system_time_period ('customer',
                                       'db_from',
                                       'db_to');
select periods.add_system_versioning ('customer');

SELECT periods.add_unique_key('customer',
                              ARRAY['id'],
                              'validity');
SELECT periods.add_unique_key('customer',
                              ARRAY['id'],
                              'knowledge');
SELECT periods.add_unique_key('customer',
                              ARRAY['name'],
                              'validity');
SELECT periods.add_unique_key('customer',
                              ARRAY['name'],
                              'knowledge');


insert into customer( customer_number, name, customer_type, valid_from, valid_to, known_from, known_to)
values('C100', 'John Doe',  'Silver', '2015-05-01','infinity', '2015-05-01','infinity')

update customer
set customer_type = 'Platinum',
    valid_from = '2015-11-18',
    valid_to = 'infinity'
where name = 'John Doe'

select *
from customer_history
where periods.contains( valid_from,
                        valid_to,
                        '2015-10-18')