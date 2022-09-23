\echo --- Importing Supplier data
COPY supplier (id, name, contactname, contacttitle, address, city, region, postalcode, country, phone, fax, homepage ) FROM 'D:\github\bassmati-on-code\postgres\docs\first-steps\supplier.csv' with (DELIMITER ',' , FORMAT CSV, HEADER true, ENCODING 'UTF8' )
SELECT max(id) + 1 as maxid from supplier;
\gset
ALTER SEQUENCE supplier_id_seq restart with :maxid ;

\echo --- Importing Customer data
COPY customer ( key, name, contactname, contacttitle,  address, city, region, postalcode, country, phone, fax ) FROM 'D:\github\bassmati-on-code\postgres\docs\first-steps\customer.csv' with ( delimiter ',' , format csv, header true, encoding 'utf8' ) ;
SELECT max(id) + 1 as maxid from customer;
\gset
ALTER SEQUENCE customer_id_seq restart with :maxid ;

\echo --- Importing ProductCategory data
ALTER TABLE ProductCategory ADD COLUMN dummy text ;
INSERT into ProductCategory ( id, name ) values ( 0, 'undefined' ) ;
COPY ProductCategory ( id, name, description, dummy ) FROM 'D:\github\bassmati-on-code\postgres\docs\first-steps\category.csv' with ( delimiter ',' , format csv, header true, encoding 'utf8' ) ;
ALTER TABLE ProductCategory DROP COLUMN dummy ;
SELECT max(id) + 1 as maxid from ProductCategory;
\gset
ALTER SEQUENCE ProductCategory_id_seq restart with :maxid ;

\echo --- Importing Region data
INSERT INTO region ( id, name ) values ( 0, 'Undefined' );
COPY region ( id, name ) FROM 'D:\github\bassmati-on-code\postgres\docs\first-steps\region.csv' with ( delimiter ',' , format csv, header true, encoding 'utf8' ) ;
SELECT max(id) + 1 as maxid from region;
\gset
ALTER SEQUENCE region_id_seq restart with :maxid ;

\echo --- Importing Territory data
INSERT into territory ( id, key, name, regionid ) values ( 0, '0', 'Undefined', 0 ) ;
INSERT into territory ( id, key, name, regionid ) values ( 9, '9', 'Other', 0 ) ;
ALTER sequence territory_id_seq restart with 10 ;
COPY territory ( key, name, regionid ) FROM 'D:\github\bassmati-on-code\postgres\docs\first-steps\territory.csv' with ( delimiter ',' , format csv, header true, encoding 'utf8' ) ;
SELECT max(id) + 1 as maxid from territory;
\gset
ALTER SEQUENCE territory_id_seq restart with :maxid ;

\echo --- Importing Carrier data
COPY Carrier ( id, name, phone ) FROM 'D:\github\bassmati-on-code\postgres\docs\first-steps\shipper.csv' with ( delimiter ',' , format csv, header true, encoding 'utf8' ) ;
SELECT max(id) + 1 as maxid from Carrier ;
\gset
ALTER SEQUENCE shipper_id_seq restart with :maxid ;
INSERT into Carrier (name, phone) values ( 'DHL', '(503) 555-1234' ) ;

\echo --- Importing Employee data
ALTER table employee ADD COLUMN dummy1 text ;
ALTER table employee ADD COLUMN dummy2 text ;
ALTER table employee ALTER COLUMN reportsto drop not null ;
ALTER table employee ALTER COLUMN region drop not null ;
COPY employee ( id, lastname,  firstname, title, titleofcourtesy, birthdate, hiredate, address, city, region, postalcode, country, homephone, extension, dummy1, notes, reportsto, dummy2 ) FROM 'D:\github\bassmati-on-code\postgres\docs\first-steps\employee.csv' with ( delimiter ',' , format csv, header true, encoding 'utf8' , null 'NULL' ) ;
UPDATE employee set region='' where region is null ;
UPDATE employee set reportsto=0 where reportsto is null ;
ALTER table employee ALTER COLUMN region set not null ;
ALTER table employee ALTER COLUMN reportsto set not null ;
ALTER TABLE employee DROP COLUMN dummy1 ;
ALTER TABLE employee DROP COLUMN dummy2 ;
SELECT max(id) + 1 as maxid from employee ;
\gset
ALTER SEQUENCE employee_id_seq restart with :maxid ;

\echo --- Importing EmployeeTerritory data
CREATE TABLE	temporarytable (
	employeeid integer not null references employee( id ) ,
	territorykey varchar(8) not null references territory( key ) ,
	territoryid integer references territory( id ) ,
	primary key ( employeeid, territorykey )
	) ;
COPY TemporaryTable ( employeeid, territorykey ) FROM 'D:\github\bassmati-on-code\postgres\docs\first-steps\employee-territory.csv' with ( delimiter ',' , format csv, header true, encoding 'utf8' , null 'NULL' ) ;
UPDATE TemporaryTable set TerritoryID = ( select id from Territory where Territory.Key = TemporaryTable.TerritoryKey ) ;
INSERT into EmployeeTerritory SELECT EmployeeID, TerritoryID FROM TemporaryTable ;
DROP TABLE TemporaryTable ;

\echo --- Importing Supplier data
ALTER TABLE supplier ALTER COLUMN region DROP not null ;
ALTER TABLE supplier ALTER COLUMN fax DROP not null ;
ALTER TABLE supplier ALTER COLUMN homepage DROP not null ;
COPY supplier( id, name, contactName, contactTitle, address, city, region, postalCode, country, phone, fax, homePage ) FROM 'D:\github\bassmati-on-code\postgres\docs\first-steps\supplier.csv' with ( delimiter ',' , format csv, header true, encoding 'utf8', null 'NULL' ) ;
SELECT max(id) + 1 as maxid from supplier ;
\gset
ALTER SEQUENCE supplier_id_seq restart with :maxid ;
UPDATE supplier set region=0 where region is null ;
UPDATE supplier set fax=0 where fax is null ;
UPDATE supplier set homepage=0 where homepage is null ;
ALTER TABLE supplier ALTER COLUMN region SET not null ;
ALTER TABLE supplier ALTER COLUMN fax SET not null ;
ALTER TABLE supplier ALTER COLUMN homepage SET not null ;

\echo --- Importing CustomerOrder data
CREATE TABLE temporarytable AS TABLE CustomerOrder WITH NO DATA ;
ALTER TABLE TemporaryTable ADD COLUMN CustomerKey varchar( 5 ) not null references Customer (key) ;
ALTER TABLE TemporaryTable ALTER COLUMN DestRegion DROP not null ;
ALTER TABLE TemporaryTable ALTER COLUMN CustomerID DROP not null ;
COPY TemporaryTable ( ID, CustomerKey, EmployeeID, OrderDate, RequiredDate, ShippedDate, ShipperID, ShippingCost, DestName, DestAddress, DestCity, DestRegion, DestPostalCode, DestCountry ) FROM 'D:\github\bassmati-on-code\postgres\docs\first-steps\customer-order.csv' with ( delimiter ',' , format csv, header true, encoding 'utf8', null 'NULL' ) ;
UPDATE TemporaryTable set DestRegion='' where DestRegion is null ;
UPDATE TemporaryTable set CustomerID = ( select ID from Customer where Customer.key = TemporaryTable.CustomerKey );
UPDATE TemporaryTable set DestPostalCode='' where DestPostalCode is null;
UPDATE TemporaryTable set ShippedDate='001-01-01' where ShippedDate is null;
UPDATE TemporaryTable set rg=0 ;
ALTER TABLE TemporaryTable DROP COLUMN CustomerKey ;
INSERT into CustomerOrder select * from TemporaryTable;
SELECT max(id) + 1 as maxid from CustomerOrder ;
\gset
ALTER SEQUENCE CustomerOrder_id_seq restart with :maxid ;
DROP TABLE TemporaryTable ;

\echo --- Importing Product data
\copy Product ( ID, Name, SupplierID, ProductCategoryID, UnitQuantity, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued ) FROM 'product.csv' with ( format csv, header true, encoding 'utf8' ) ;
SELECT max(id) + 1 as maxid from Product ;
\gset
ALTER SEQUENCE Product_id_seq restart with :maxid ;

\echo --- Importing CustomerOrderItem data
COPY CustomerOrderItem ( orderID, productID, unitPrice, quantityOrdered, discount ) FROM 'D:\github\bassmati-on-code\postgres\docs\first-steps\customer-order-item.csv' with ( delimiter ',' , format csv, header true, encoding 'utf8' ) ;
