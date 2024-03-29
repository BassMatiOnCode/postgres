\echo --- Creating table Region	
CREATE TABLE if not exists region (
	id integer PRIMARY KEY generated by default as identity ,
	rg integer not null default 0,
	name varchar(20) not null default '' 
	) ;

\echo --- Creating table Customer
CREATE TABLE if not exists customer (
	id integer PRIMARY KEY generated by default as identity ,
	rg integer not null default 0,
	key char( 5 ) unique ,
	name varchar(50) not null default '' ,
	contactname varchar(30) not null default '' ,
	contacttitle varchar(30) not null default '' ,
	address varchar(50) not null default '' ,
	city varchar(30) not null default '' ,
	region varchar(30) not null default '' ,
	postalcode varchar(10) not null default '' ,
	country varchar(30) not null default '' ,
	phone varchar(20) not null default '' ,
	fax varchar(20) not null default '' 
	) ;

\echo --- Creating table Territory	
CREATE TABLE if not exists territory (
	id integer PRIMARY KEY generated by default as identity ,
	rg integer not null default 0,
	key varchar(8) unique not null default '' ,
	name varchar(20) not null default '' ,
	regionid integer not null default 0 references region( id )
	) ;

\echo --- Creating table Shipper	
CREATE TABLE if not exists shipper (
	id integer PRIMARY KEY generated by default as identity ,
	rg integer not null default 0,
	name varchar(20) not null default '' ,
	phone varchar(20) not null default ''
	) ;
	
\echo --- Creating table Employee
CREATE TABLE if not exists employee (
	id integer PRIMARY KEY generated by default as identity ,
	rg integer not null default 0,
	lastname varchar(20) not null default '' ,
	firstname varchar(20) not null default '' ,
	title varchar(30) not null default '' ,
	titleofcourtesy varchar(20) not null default '' ,
	birthdate DATE not null default '0001-01-01' , 
	hiredate DATE not null default '0001-01-01' , 
	address varchar(50) not null default '' ,
	city varchar(20) not null default '' ,
	region varchar(30) not null default '' ,
	postalcode varchar(10) not null default '' ,
	country varchar(20) not null default '' ,
	homephone varchar(20) not null default '' ,
	extension varchar(5) not null default '' ,
	notes text not null default '' ,
	reportsto integer not null default 0 references employee( id )
	) ;
		
\echo --- Creating table EmployeeTerritory
CREATE TABLE IF NOT EXISTS employeeterritory (
	employeeid integer not null references employee( id ) ,
	territoryid integer not null references territory( id ) ,
	rg INTEGER not null default 0,
	primary key ( employeeid, territoryid )
	) ;

\echo --- Creating table Supplier
CREATE TABLE if not exists supplier (
	id integer PRIMARY KEY generated by default as identity ,
	rg integer not null default 0,
	name varchar(50) not null default '' ,
	contactname varchar(30) not null default '' ,
	contacttitle varchar(30) not null default '' ,
	address varchar(50) not null default '' ,
	city varchar(30) not null default '' ,
	region varchar(30) not null default '' ,
	postalcode varchar(10) not null default '' ,
	country varchar(20) not null default '' ,
	phone varchar(20) not null default '' ,
	fax varchar(20) not null default '' ,
	homepage varchar(100) not null default ''
	) ;

\echo --- Creating table CustomerOrder
CREATE TABLE if not exists customerorder (
    id integer PRIMARY KEY generated by default as identity ,
	rg integer not null default 0,
    customerid integer not null REFERENCES customer (id) on update cascade ,
    employeeid integer not null REFERENCES employee (id) on update cascade ,
	orderdate date not null default '0001-01-01' ,
	requireddate date not null default '0001-01-01' ,
	shippeddate date not null default '0001-01-01' ,
	shipperid integer not null default 0 references shipper (id) ,
	shippingcost money not null default 0, 
	destname varchar (50) not null default '' ,
	destaddress varchar (50) not null default '' ,
	destcity varchar (30) not null default '' ,
	destregion varchar(30) not null default '' ,
	destpostalcode varchar (10) not null default '' ,
	destcountry varchar (20) not null default '' 
    ) ;

\echo --- Creating table ProductCategory
CREATE TABLE if not exists productcategory (
	id integer PRIMARY KEY generated by default as identity ,
	rg integer not null default 0,
	name varchar(20) not null default '' ,
	description text not null default '' 
	) ;

\echo --- Creating table Product
CREATE TABLE if not exists product (
	id integer PRIMARY KEY generated by default as identity ,
	rg integer not null default 0,
	name varchar(50) not null default '' ,
	supplierid integer not null references supplier( id ) on update cascade ,
	productcategoryid integer not null references productcategory( id ) on update cascade ,
	unitquantity varchar (30) not null default '' ,
	unitprice money not null default 0 ,
	unitsinstock real not null default 0.0 ,
	unitsonorder real not null default 0.0 ,
	reorderlevel real not null default 0.0 ,
	discontinued integer not null default 0
	) ;

\echo --- Creating table CustomerOrderItem
CREATE TABLE if not exists customerorderitem (
	orderid integer not null REFERENCES customerOrder( id ) on update cascade on delete cascade,
	productid integer not null REFERENCES product( id ) on update cascade ,
	PRIMARY KEY ( orderid, productid ) ,
	rg integer not null default 0,
	unitprice money not null default 0 ,
	discount money not null default 0 ,
	quantityordered REAL not null default 0 ,
	quantitydelivered REAL not null default 0 
	) ;
