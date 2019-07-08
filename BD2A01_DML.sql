set echo on 
set linesize 300 
set pagesize 500 
spool C:\Users\Maria\Desktop\etap3_bd2_poprawa\BD2A01_DML.LIS 

insert into luki values(4,'lukCD',140,3,1,4,1);
insert into luki values(5, 'lukAC', 150, NULL, NULL, 3,1);

insert into oferty values(4,1,'kWh',0.57,DATE '2018-01-09',NULL,NULL,NULL,1,4);
insert into oferty values(NULL,1,'kWh',0.57,DATE '2018-01-09',NULL,NULL,NULL,1,1);
insert into oferty values(5,1,'kWh',0.57,DATE '2018-01-09',NULL,NULL,NULL,1,5);

UPDATE oferty
SET CENA_ZA_JEDNOSTKE_MIARY = 0.56
WHERE ID_OFERTY = 2;

UPDATE oferty
SET CENA_ZA_JEDNOSTKE_MIARY = NULL
WHERE ID_OFERTY = 4;

DELETE FROM oferty WHERE ID_OFERTY=1;
DELETE FROM wezly WHERE ID_WEZLA=1;
DELETE FROM luki WHERE ID_LUKU=2;

spool off 