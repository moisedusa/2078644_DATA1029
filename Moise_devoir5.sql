DROP database IF EXISTS library3;
create database if not exists library3;
use library3;
DROP TABLE IF EXISTS authors;
CREATE TABLE authors (
au_id tinyint not null auto_increment primary key , 
au_lname varchar(50) not null,
au_fname varchar(50) not null,
phone varchar(20) not null unique,
adresse varchar(50) not null,
city varchar(50) not null,
state varchar(50) null,
country varchar(50) not null,
zip varchar(6) unique not null,
contract text,
email varchar(50) not null unique CHECK (email LIKE '%@%'),
CONSTRAINT phone CHECK (phone REGEXP '^\\+[0-9]{10,15}$'),
CONSTRAINT zip CHECK (zip REGEXP '^[A-Za-z][0-9][A-Za-z][0-9][A-Za-z][0-9]$')
);

DROP TABLE IF EXISTS publishers;
CREATE TABLE publishers(
pub_id tinyint primary key auto_increment,
pub_name varchar(50) unique ,
city varchar(50) not null,
state varchar(50) null,
country varchar(50) not null,
email varchar(50) not null unique CHECK (email LIKE '%@%')
);
DROP TABLE IF EXISTS jobs;
create table jobs(
job_id tinyint primary key auto_increment,
job_descr varchar(50)  not null,
min_lvl enum("stagiaire","junior","intermediaire","senior"),
max_lvl enum("stagiaire","junior","intermediaire","senior")
);

DROP TABLE IF EXISTS employees;
create table employees(
emp_id tinyint primary key not null auto_increment,
emp_name varchar(50) unique not null,
salary smallint ,
fname varchar(50) not null unique ,
lname varchar(50) not null unique,
job_id smallint not null references jobs(job_id),
pub_id smallint references publishers(pub_id),
pub_date date not null,
email varchar(50) unique not null CHECK (email LIKE '%@%')
);

DROP TABLE IF EXISTS titles;
create table titles(
title_id tinyint primary key auto_increment,
title varchar(100)  not null,
type  enum("roman","politique","science","histoire"),
pub_id smallint references publishers(pub_id)  ,
price float not null ,
advance float null ,
notes varchar(255),
pub_date date
);

DROP TABLE IF EXISTS redactions;
create table redactions(
au_id tinyint references authors(au_id)  ,
title_id tinyint references titles(title_id)  ,
au_ord  tinyint unique ,
royalty float not null
);

DROP TABLE IF EXISTS stores;
create table stores(
stor_id tinyint primary key not null auto_increment ,
stor_name varchar(50) unique not null ,
stor_adress varchar(50) not null,
city varchar(50) not null,
state varchar(50) null,
country varchar(50) not null
);

DROP TABLE IF EXISTS sales;
create table sales(
ord_num tinyint primary key not null auto_increment,
stor_id tinyint references stores(stor_id)  ,
title_id smallint references titles(title_id)  ,
ord_date  datetime,
qty int
);




