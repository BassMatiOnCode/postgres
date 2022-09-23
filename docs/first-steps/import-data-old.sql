COPY location (id, locationid, nkey, name, description) FROM 'D:\github\tut-pg\first-steps\location.csv' DELIMITER ',' CSV HEADER ;
COPY item (id, locationid, nkey, name, description) FROM 'D:\github\tut-pg\first-steps\item.csv' DELIMITER ',' CSV HEADER ;
