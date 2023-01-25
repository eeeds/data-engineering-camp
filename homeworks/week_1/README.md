## Week 1 Homework

In this homework we'll prepare the environment 
and practice with Docker and SQL


## Question 1. Knowing docker tags

Run the command to get information on Docker 

```docker --help```

Now run the command to get help on the "docker build" command

Which tag has the following text? - *Write the image ID to the file* 

- `--imageid string`
- `--iidfile string`
- `--idimage string`
- `--idfile string`

Type `docker image build --help` and you'll see it.

## Answer: `--iidfilestring`

## Question 2. Understanding docker first run 

Run docker with the python:3.9 image in an interactive mode and the entrypoint of bash.
Now check the python modules that are installed ( use pip list). 
How many python packages/modules are installed?

- 1
- 6
- 3
- 7

Write the dockerfile as follows:
```docker
FROM python:3.9
WORKDIR /app

ENTRYPOINT [ "bash" ]
```
- Build it:
    ```docker build -t hw1:v00 .```

- Run it:
    ```docker run -it hw1:v00```

- Run `pip list` and you'll see three packages: pip, setuptools and wheel.
# Prepare Postgres

Run Postgres and load data as shown in the videos
We'll use the green taxi trips from January 2019:

```wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-01.csv.gz```

You will also need the dataset with zones:

```wget https://s3.amazonaws.com/nyc-tlc/misc/taxi+_zone_lookup.csv```

Download this data and put it into Postgres (with jupyter notebooks or with a pipeline)

[Code here](../../week_1_basics_n_setup/notebook.ipynb)
## Question 3. Count records 

How many taxi trips were totally made on January 15?

Tip: started and finished on 2019-01-15. 

Remember that `lpep_pickup_datetime` and `lpep_dropoff_datetime` columns are in the format timestamp (date and hour+min+sec) and not in date.

- 20689
- 20530
- 17630
- 21090
Query:
```sql
SELECT COUNT(*) FROM green_taxi_data
WHERE CAST(lpep_pickup_datetime AS DATE)='2019-01-15' AND CAST(lpep_dropoff_datetime AS DATE)= '2019-01-15';
```
Answer: 20530
## Question 4. Largest trip for each day

Which was the day with the largest trip distance
Use the pick up time for your calculations.

- 2019-01-18
- 2019-01-28
- 2019-01-15
- 2019-01-10

Query:
```sql
SELECT MAX(trip_distance) AS trip_distance, CAST(lpep_pickup_datetime AS DATE) AS pickup_time
FROM green_taxi_data
GROUP BY 2
ORDER BY 1 DESC;
```
Answer: 2019-01-15
## Question 5. The number of passengers

In 2019-01-01 how many trips had 2 and 3 passengers?
 
- 2: 1282 ; 3: 266
- 2: 1532 ; 3: 126
- 2: 1282 ; 3: 254
- 2: 1282 ; 3: 274

Query:
```sql
SELECT COUNT(*) AS number_of_trips, passenger_count
FROM green_taxi_data
WHERE CAST(lpep_pickup_datetime AS DATE)= '2019-01-01'
AND passenger_count BETWEEN 2 AND 3
GROUP BY 2;
```

Answer: 2:1282, 3:254


## Question 6. Largest tip

For the passengers picked up in the Astoria Zone which was the drop off zone that had the largest tip?
We want the name of the zone, not the id.

Note: it's not a typo, it's `tip` , not `trip`

- Central Park
- Jamaica
- South Ozone Park
- Long Island City/Queens Plaza

Query:
```sql
SELECT MAX(tip_amount) as max_tip, z2."Zone"
FROM green_taxi_data gtd
INNER JOIN zones z 
ON gtd."PULocationID"=z."LocationID"
INNER JOIN zones z2 ON gtd."DOLocationID" = z2."LocationID"
WHERE z."Zone" LIKE '%Astoria%'
GROUP BY 2
ORDER BY 1 DESC;
```

Answer: Long Island City/Queens Plaza


## Submitting the solutions

* Form for submitting: [form](https://forms.gle/EjphSkR1b3nsdojv7)
* You can submit your homework multiple times. In this case, only the last submission will be used. 

Deadline: 26 January (Thursday), 22:00 CET


## Solution

We will publish the solution here