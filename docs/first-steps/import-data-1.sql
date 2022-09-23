\echo -- Importing Carrier data
\copy Carrier ( id, name, phone ) FROM 'shipper.csv' with ( format csv, header true, encoding 'utf8' ) ;
SELECT max(id) + 1 as maxid from Carrier ;
\gset
ALTER SEQUENCE carrier_id_seq restart with :maxid ;
INSERT into Carrier (name, phone) values ( 'DHL', '(503) 555-1234' ) ;

\echo -- Importing ProductCategory data
CREATE TEMPORARY TABLE temporarytable AS TABLE ProductCategory with no data ;
ALTER TABLE TemporaryTable ADD COLUMN Picture text ;
\copy TemporaryTable ( id, name, description, picture ) FROM 'category.csv' with ( format csv, header true, encoding 'utf8' )
ALTER TABLE TemporaryTable DROP COLUMN Picture ;
INSERT into ProductCategory (id, name, description) select id, name, description from TemporaryTable ;
DROP TABLE TemporaryTable ;
SELECT max(id) + 1 as maxid from ProductCategory;
\gset
ALTER SEQUENCE ProductCategory_id_seq restart with :maxid ;

\echo -- Importing Customer data
\copy Customer ( key, name, contactname, contacttitle,  address, city, region, postalcode, country, phone, fax ) FROM 'customer.csv' with ( format csv, header true, encoding 'utf8' ) ;
-- We don't need to adjust the ID column sequence counter, because the copy command does not supply values for it. 

\echo -- Importing Employee data
ALTER TABLE employee ADD COLUMN dummy1 text ;
ALTER TABLE employee ADD COLUMN dummy2 text ;
ALTER table employee ALTER COLUMN reportingParentID DROP not null ;
ALTER table employee ALTER COLUMN region DROP not null ;
\copy Employee ( id, lastname,  firstname, title, titleofcourtesy, birthdate, hiredate, address, city, region, postalcode, country, homephone, extension, dummy1, notes, reportingParentID, dummy2 ) FROM 'employee.csv' with ( delimiter ',' , format csv, header true, encoding 'utf8' , null 'NULL' ) ;
UPDATE employee set region=0 where region is null ;
UPDATE employee set reportingParentID=0 where reportingParentID is null ;
ALTER table employee ALTER COLUMN reportingParentID SET not null ;
ALTER table employee ALTER COLUMN region SET not null ;
ALTER TABLE employee DROP COLUMN dummy1 ;
ALTER TABLE employee DROP COLUMN dummy2 ;
SELECT max(id) + 1 as maxid from Employee ;
\gset
ALTER SEQUENCE employee_id_seq restart with :maxid ;

\echo -- Importing CustomerOrder data
CREATE TABLE temporarytable AS TABLE CustomerOrder WITH NO DATA ;
ALTER TABLE TemporaryTable ADD COLUMN CustomerKey varchar( 5 ) not null references Customer (key) ;
\copy TemporaryTable ( ID, CustomerKey, EmployeeID, OrderDate, RequiredDate, ShippedDate, CarrierID, ShippingCost, RecipientName, RecipientAddress, RecipientCity, RecipientRegion, RecipientPostalCode, RecipientCountry ) FROM 'customer-order.csv' with ( delimiter ',' , format csv, header true, encoding 'utf8', null 'NULL' ) ;
UPDATE TemporaryTable set CustomerID = ( select ID from Customer where Customer.key = TemporaryTable.CustomerKey );
UPDATE temporaryTable set rg=0 ;
UPDATE temporaryTable set recipientRegion=0 where recipientRegion is null ;
UPDATE temporaryTable set recipientPostalCode='' where recipientPostalCode is null ;
ALTER TABLE TemporaryTable DROP COLUMN CustomerKey ;
INSERT into CustomerOrder select * from TemporaryTable;
SELECT max(id) + 1 as maxid from CustomerOrder ;
\gset
ALTER SEQUENCE CustomerOrder_id_seq restart with :maxid ;
DROP TABLE TemporaryTable ;

\echo -- Importing Supplier data
\copy Supplier (id, name, contactName, contactTitle, address, city, region, postalCode, country, phone, fax, homepage ) FROM 'supplier.csv' with (format CSV, header true, encoding 'UTF8' )
SELECT max(id) + 1 as maxid from Supplier;
\gset
ALTER SEQUENCE supplier_id_seq restart with :maxid ;

\echo -- Importing Product data
\copy Product ( ID, Name, SupplierID, ProductCategoryID, UnitQuantity, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued ) FROM 'product.csv' with ( format csv, header true, encoding 'utf8' ) ;
SELECT max(id) + 1 as maxid from Product ;
\gset
ALTER SEQUENCE Product_id_seq restart with :maxid ;

\echo -- Importing CustomerOrderItem data
\copy CustomerOrderItem ( customerOrderID, productID, unitPrice, quantityOrdered, discount ) FROM 'customer-order-item.csv' with ( format csv, header true, encoding 'utf8' ) ;

\echo -- Importing Region data
\copy region ( id, name ) FROM 'region.csv' with ( format csv, header true, encoding 'utf8' ) ;
SELECT max(id) + 1 as maxid from Region;
\gset
ALTER SEQUENCE region_id_seq restart with :maxid ;

\echo -- Importing Territory data
\copy territory ( key, name, regionid ) FROM 'territory.csv' with ( delimiter ',' , format csv, header true, encoding 'utf8' ) ;

\echo -- Importing EmployeeTerritory data
CREATE TABLE temporarytable AS TABLE EmployeeTerritory WITH NO DATA ;
ALTER TABLE temporaryTable ADD COLUMN territoryKey varchar( 8 ) ;
\copy TemporaryTable ( employeeID, territoryKey ) from 'employee-territory.csv' with ( format csv, header true, encoding 'utf8' ) ;
UPDATE TemporaryTable set territoryID = ( select id from territory where territory.key = temporaryTable.territoryKey ) ;
INSERT into EmployeeTerritory SELECT EmployeeID, TerritoryID FROM TemporaryTable ;
DROP TABLE TemporaryTable ;
