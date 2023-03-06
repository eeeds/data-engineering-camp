## Week 5: Batch Processing

### 5.1 Introduction

:movie_camera: [Introduction to Batch Processing](https://youtu.be/dcHe5Fl3MF8?list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)


:movie_camera: [Introduction to Spark](https://youtu.be/FhaqbEOuQ8U?list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)
- Data Processing Engine
- It can be used for batch jobs and streamings.

If you can't express something with SQL, use Spark.

### 5.2 Installation

Follow [these intructions](setup/) to install Spark:

* [Windows](setup/windows.md)
* [Linux](setup/linux.md)
* [MacOS](setup/macos.md)

And follow [this](setup/pyspark.md) to run PySpark in Jupyter

:movie_camera: [Installing Spark (Linux)](https://youtu.be/hqUbB9c8sKg?list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)
  

### 5.3 Spark SQL and DataFrames

:movie_camera: [First Look at Spark/PySpark](https://youtu.be/r_Sf6fCB40c?list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)   
   
:movie_camera: [Spark Dataframes](https://youtu.be/ti3aC1m3rE8?list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)

:movie_camera: [(Optional) Preparing Yellow and Green Taxi Data](https://youtu.be/CI3P4tAtru4?list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)

Script to prepare the Dataset [download_data.sh](code/download_data.sh)

**Note**: The other way to infer the schema (apart from pandas) for the csv files, is to set the `inferSchema` option to `true` while reading the files in Spark.

:movie_camera: [SQL with Spark](https://www.youtube.com/watch?v=uAlp2VuZZPY&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)


### 5.4 Spark Internals

:movie_camera: [Anatomy of a Spark Cluster](https://youtu.be/68CipcZt7ZA&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)

- Nowadays, they are on the same datacenter (spark cluster and data, executers now pull data from S3, GCS, etc.)

:movie_camera: [GroupBy in Spark](https://youtu.be/9qrDsY_2COo&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)

:movie_camera: [Joins in Spark](https://youtu.be/lu7TrqAWuH4&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)

If the datasets are very small, each executor will get a copy of the dataset (one large table and one small table). On the other hand, for two big tables we use merge sort join (reshuffling).

### 5.5 RDDs

Coming soon

### 5.6 Running Spark in the Cloud
-   5.6.1 Connecting to Google Cloud Storage

Uploading data to GCS:
```bash
gsutil -m cp -r code/data/pq/ gs://dtc_data_lake_extreme-surge-375913/pq
```
Download the jar for connecting to GCS to any location
```bash
gsutil cp gs://hadoop-lib/gcs/gcs-connector-hadoop3-2.2.5.jar gcs-connector-hadoop3-2.2.5.jar
```
-   5.6.2 [Creating a Local Spark Cluster](https://spark.apache.org/docs/latest/spark-standalone.html)
1. Go to your directory where spark is located.
2. Run ./sbin/start-master.sh
3. Follow the video...
-   5.6.3 Setting up a Dataproc Cluster
-   5.6.4 Connecting Spark to BigQuery

gcloud dataproc jobs submit pyspark --cluster=de-zoomcamp-cluster --region=southamerica-east1 --jars=gs://spark-lib/bigquery/spark-bigquery-latest_2.12.jar gs://dtc_data_lake_extreme-surge-375913/code/06_spark_sql_big_query.py -- --input_green=gs://dtc_data_lake_extreme-surge-375913/pq/code/data/pq/green/2020/* --input_yellow=gs://dtc_data_lake_extreme-surge-375913/pq/code/data/pq/yellow/2020/* --output=trips_data_all.reports-2020

gcloud dataproc jobs submit pyspark \
    --cluster=de-zoomcamp-cluster \
    --region=southamerica-east1 \
    --jars=gs://spark-lib/bigquery/spark-bigquery-latest_2.12.jar \
    gs://dtc_data_lake_extreme-surge-375913/code/06_spark_sql_bigquery.py \
    -- \
        --input_green=gs://dtc_data_lake_extreme-surge-375913/pq/code/data/pq/green/2020/*/ \
        --input_yellow=gs://dtc_data_lake_extreme-surge-375913/pq/code/data/pq/yellow/2020/*/ \
        --output=trips_data_all.reports-2020
### Homework


* [Homework](../cohorts/2023/week_5_batch_processing/homework.md)


## Community notes

Did you take notes? You can share them here.

* [Notes by Alvaro Navas](https://github.com/ziritrion/dataeng-zoomcamp/blob/main/notes/5_batch_processing.md)
* [Sandy's DE Learning Blog](https://learningdataengineering540969211.wordpress.com/2022/02/24/week-5-de-zoomcamp-5-2-1-installing-spark-on-linux/)
* [Notes by Alain Boisvert](https://github.com/boisalai/de-zoomcamp-2023/blob/main/week5.md)
* [Alternative : Using docker-compose to launch spark by rafik](https://gist.github.com/rafik-rahoui/f98df941c4ccced9c46e9ccbdef63a03) 
* Add your notes here (above this line)