drop table Customers;
drop table fakedata;
drop table fakedata_unordered;

create Table Customers (
	firstName varchar2(40) not null,
	lastName varchar2(40) not null,
	address varchar2(200) not null,
	creditCard number(16) not null unique,
	phoneNumber number(9) not null
)

create Table fakedata (
	firstName varchar2(15) not null,
	lastName varchar2(20) not null,
	address varchar2(100) not null
)

create Table fakedata_unordered (
	firstName varchar2(15) not null,
	lastName varchar2(20) not null,
	address varchar2(100) not null
)

create Table logtable (
  created date, 
  type number,
  text varchar2(200)
)