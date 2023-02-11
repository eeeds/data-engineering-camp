--CREATE EXTERNAL TABLE
CREATE OR REPLACE EXTERNAL TABLE `trips_data_all.external_fhv_2019`
OPTIONS (
  format = 'CSV',
  uris = ['gs://dtc_data_lake_extreme-surge-375913/data/fhv/*']
);
--Q1
SELECT count(*) FROM `extreme-surge-375913.trips_data_all.fhv_2019` ;

--Q2
select count(distinct (Affiliated_base_number)) from trips_data_all.fhv_2019;

select count(distinct (Affiliated_base_number)) from trips_data_all.external_fhv_2019;

--Q3
SELECT COUNT(*) FROM trips_data_all.fhv_2019
WHERE PUlocationID IS NULL AND DOlocationID IS NULL;

--Q4
--Partition on pickup_datetime Cluster on affiliated_base_number
CREATE OR REPLACE TABLE trips_data_all.pickup_
PARTITION BY DATE(pickup_datetime)
CLUSTER BY Affiliated_base_number AS
SELECT * FROM extreme-surge-375913.trips_data_all.fhv_2019;

--Q5

select count(distinct Affiliated_base_number) from `trips_data_all.fhv_2019`
WHERE CAST(pickup_datetime AS DATE) BETWEEN '2019-03-01' AND '2019-03-31';

select count(distinct Affiliated_base_number) from `trips_data_all.pickup_`
WHERE CAST(pickup_datetime AS DATE) BETWEEN '2019-03-01' AND '2019-03-31';
