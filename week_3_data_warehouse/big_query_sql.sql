
-- Query public available table
SELECT station_id, name FROM
    bigquery-public-data.new_york_citibike.citibike_stations
LIMIT 100;

-- Creating external table referring to gcs path
CREATE OR REPLACE EXTERNAL TABLE `extreme-surge-375913.trips_data_all.external_yellow_tripdata`
OPTIONS (
  format = 'parquet',
  uris = ['gs://dtc_data_lake_extreme-surge-375913/data/yellow/yellow_tripdata_2019-*.parquet', 'gs://dtc_data_lake_extreme-surge-375913/data/yellow/yellow_tripdata_2020-*.parquet']
);

-- Check yello trip data
SELECT * FROM extreme-surge-375913.trips_data_all.external_yellow_tripdata limit 10;

-- Create a non partitioned table from external table (partition reduces time)
CREATE OR REPLACE TABLE extreme-surge-375913.trips_data_all.yellow_tripdata_non_partitoned AS
SELECT * FROM extreme-surge-375913.trips_data_all.external_yellow_tripdata;
 

-- Create a partitioned table from external table
CREATE OR REPLACE TABLE extreme-surge-375913.trips_data_all.yellow_tripdata_partitoned
PARTITION BY
  DATE(tpep_pickup_datetime) AS
SELECT * FROM extreme-surge-375913.trips_data_all.external_yellow_tripdata;


-- Impact of partition
-- Scanning 343.62 MB of data
SELECT DISTINCT(VendorID)
FROM extreme-surge-375913.trips_data_all.yellow_tripdata_non_partitoned
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-06-01' AND '2019-06-30';

-- Scanning ~464 B of DATA
SELECT DISTINCT(VendorID)
FROM extreme-surge-375913.trips_data_all.yellow_tripdata_partitoned
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-06-01' AND '2019-06-30';

-- Let's look into the partitons
SELECT table_name, partition_id, total_rows
FROM `extreme-surge-375913.trips_data_all.INFORMATION_SCHEMA.PARTITIONS`
WHERE table_name = 'yellow_tripdata_partitoned'
ORDER BY total_rows DESC;


-- Creating a partition and cluster table
CREATE OR REPLACE TABLE extreme-surge-375913.trips_data_all.yellow_tripdata_partitoned_clustered
PARTITION BY DATE(tpep_pickup_datetime)
CLUSTER BY VendorID AS
SELECT * FROM extreme-surge-375913.trips_data_all.external_yellow_tripdata;


-- Query scans 944B
SELECT count(*) as trips
FROM extreme-surge-375913.trips_data_all.yellow_tripdata_partitoned
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-06-01' AND '2020-12-31'
  AND VendorID=1;

-- Query scans 0B
SELECT count(*) as trips
FROM extreme-surge-375913.trips_data_all.yellow_tripdata_partitoned_clustered
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-06-01' AND '2020-12-31'
  AND VendorID=1;
