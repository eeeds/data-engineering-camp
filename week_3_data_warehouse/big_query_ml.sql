-- SELECT THE COLUMNS INTERESTED FOR YOU
SELECT passenger_count, trip_distance, PULocationID, DOLocationID, payment_type, fare_amount, tolls_amount, tip_amount
FROM `trips_data_all.rides` WHERE fare_amount != 0;

-- CREATE A ML TABLE WITH APPROPRIATE TYPE (We are going to predict tip_amount)
CREATE OR REPLACE TABLE `trips_data_all.yellow_tripdata_ml` (
`passenger_count` INTEGER,
`trip_distance` FLOAT64,
`PULocationID` STRING,
`DOLocationID` STRING,
`payment_type` STRING,
`fare_amount` FLOAT64,
`tolls_amount` FLOAT64,
`tip_amount` FLOAT64
) AS (
SELECT passenger_count, trip_distance, cast(PULocationID AS STRING), CAST(DOLocationID AS STRING),
CAST(payment_type AS STRING), fare_amount, tolls_amount, tip_amount
FROM `trips_data_all.yellow_tripdata_partitoned` WHERE fare_amount != 0
);



-- CREATE MODEL WITH DEFAULT SETTING
CREATE OR REPLACE MODEL `trips_data_all.tip_model`
OPTIONS
(model_type='linear_reg',
input_label_cols=['tip_amount'],
DATA_SPLIT_METHOD='AUTO_SPLIT') AS
SELECT
*
FROM
`trips_data_all.yellow_tripdata_ml`
WHERE
tip_amount IS NOT NULL;


-- CHECK FEATURES
SELECT * FROM ML.FEATURE_INFO(MODEL `trips_data_all.tip_model`);

-- EVALUATE THE MODEL
SELECT
*
FROM
ML.EVALUATE(MODEL `trips_data_all.tip_model`,
(
SELECT
*
FROM
`trips_data_all.yellow_tripdata_ml`
WHERE
tip_amount IS NOT NULL
));


-- PREDICT THE MODEL
SELECT
*
FROM
ML.PREDICT(MODEL `trips_data_all.tip_model`,
(
SELECT
*
FROM
`trips_data_all.yellow_tripdata_ml`
WHERE
tip_amount IS NOT NULL
));


-- PREDICT AND EXPLAIN
SELECT
*
FROM
ML.EXPLAIN_PREDICT(MODEL `trips_data_all.tip_model`,
(
SELECT
*
FROM
`trips_data_all.yellow_tripdata_ml`
WHERE
tip_amount IS NOT NULL
), STRUCT(3 as top_k_features));


-- HYPER PARAM TUNNING
CREATE OR REPLACE MODEL `trips_data_all.tip_hyperparam_model`
OPTIONS
(model_type='linear_reg',
input_label_cols=['tip_amount'],
DATA_SPLIT_METHOD='AUTO_SPLIT',
num_trials=5,
max_parallel_trials=2,
l1_reg=hparam_range(0, 20),
l2_reg=hparam_candidates([0, 0.1, 1, 10])) AS
SELECT
*
FROM
`trips_data_all.yellow_tripdata_ml`
WHERE
tip_amount IS NOT NULL;