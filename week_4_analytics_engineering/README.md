# Week 4: Analytics Engineering 
Goal: Transforming the data loaded in DWH to Analytical Views developing a [dbt project](taxi_rides_ny/README.md).
[Slides](https://docs.google.com/presentation/d/1xSll_jv0T8JF4rYZvLHfkJXYqUjPtThA/edit?usp=sharing&ouid=114544032874539580154&rtpof=true&sd=true)

## Prerequisites
We will build a project using dbt and a running data warehouse. 
By this stage of the course you should have already: 
- A running warehouse (BigQuery or postgres) 
- A set of running pipelines ingesting the project dataset (week 3 completed): [Datasets list](https://github.com/DataTalksClub/nyc-tlc-data/)
    * Yellow taxi data - Years 2019 and 2020
    * Green taxi data - Years 2019 and 2020 
    * fhv data - Year 2019. 

_Note:_
  *  _A quick hack has been shared to load that data quicker, check instructions in [week3/extras](https://github.com/DataTalksClub/data-engineering-zoomcamp/tree/main/week_3_data_warehouse/extras)_
  * _If you recieve an error stating "Permission denied while globbing file pattern." when attemting to run fact_trips.sql this video may be helpful in resolving the issue_ 
 
 :movie_camera: [Video](https://www.youtube.com/watch?v=kL3ZVNL9Y4A)
    
### Setting up dbt for using BigQuery (Alternative A - preferred)
You will need to create a dbt cloud account using [this link](https://www.getdbt.com/signup/) and connect to your warehouse [following these instructions](https://docs.getdbt.com/docs/dbt-cloud/cloud-configuring-dbt-cloud/cloud-setting-up-bigquery-oauth). More detailed instructions in [dbt_cloud_setup.md](dbt_cloud_setup.md)

_Optional_: If you feel more comfortable developing locally you could use a local installation of dbt as well. You can follow the [official dbt documentation](https://docs.getdbt.com/dbt-cli/installation) or follow the [dbt with BigQuery on Docker](docker_setup/README.md) guide to setup dbt locally on docker. You will need to install the latest version (1.0) with the BigQuery adapter (dbt-bigquery). 

### Setting up dbt for using Postgres locally (Alternative B)
As an alternative to the cloud, that require to have a cloud database, you will be able to run the project installing dbt locally.
You can follow the [official dbt documentation](https://docs.getdbt.com/dbt-cli/installation) or use a docker image from oficial [dbt repo](https://github.com/dbt-labs/dbt/). You will need to install the latest version (1.0) with the postgres adapter (dbt-postgres).
After local installation you will have to set up the connection to PG in the `profiles.yml`, you can find the templates [here](https://docs.getdbt.com/reference/warehouse-profiles/postgres-profile)
## Content
### Introduction to analytics engineering
 * What is analytics engineering?
 * ETL vs ELT 
 * Data modeling concepts (fact and dim tables)

 :movie_camera: [Video](https://www.youtube.com/watch?v=uF76d5EmdtU&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=32)

 > Data Loading -> Data Storing (cloud data warehouses) -> Data modelling (dbt) -> Data presentation (BI Tools)



### What is dbt? 
 * Intro to dbt 

 :movie_camera: [Video](https://www.youtube.com/watch?v=4eCouvVOJUw&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=33)
### Starting a dbt project
#### Alternative a: Using BigQuery + dbt cloud
 * Starting a new project with dbt init (dbt cloud and core)
 * dbt cloud setup
 * project.yml

 :movie_camera: [Video](https://www.youtube.com/watch?v=iMxh6s_wL4Q&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=34)

 Working on this [repository](https://github.com/eeeds/ny_taxi_rides_zoomcamp)
 
#### Alternative b: Using Postgres + dbt core (locally)
 * Starting a new project with dbt init (dbt cloud and core)
 * dbt core local setup
 * profiles.yml
 * project.yml

 :movie_camera: [Video](https://www.youtube.com/watch?v=1HmL63e-vRs&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=35)
### Development of dbt models
 * Anatomy of a dbt model: written code vs compiled Sources
 * Materialisations: table, view, incremental, ephemeral  
 * Seeds, sources and ref  
 * Jinja and Macros 
 * Packages 
 * Variables

 :movie_camera: [Video](https://www.youtube.com/watch?v=UVI30Vxzd6c&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=36)

_Note: This video is shown entirely on dbt cloud IDE but the same steps can be followed locally on the IDE of your choice_

We defined a `schema.yml` file where we have stored our sources.

Then we called in our model as follows:
  
  ```sql
{{ config(materialized="view") }} 

select * from {{ source("staging", "rides-green") }}
```
You can run the project with the following command:
  
  ```bash
dbt run
```

### Create Macros
We will create a macro to get the description of the payment type. In the folder `macros` create a new file called `get_payment_type_description.sql`
```sql

 {#
    This macro returns the description of the payment_type 
#}

{% macro get_payment_type_description(payment_type) -%}

    case {{ payment_type }}
        when 1 then 'Credit card'
        when 2 then 'Cash'
        when 3 then 'No charge'
        when 4 then 'Dispute'
        when 5 then 'Unknown'
        when 6 then 'Voided trip'
    end

{%- endmacro %}
```
We can import macros that are in dbt by default, create a `package.yml` file and then import the macros, for instance:
```yaml

packages:
  - package: dbt-labs/dbt_utils
    version: 0.8.0
```
### Install dependencies
Run `dbt deps`.
### Vars
We can pass variables to our build command, on the code we can add a few lines that we're going to select if the condition is true/false:
```sql
{% if var('is_test_run', default=true) %}

  limit 100

{% endif %}
```
We can pass the variable in the command line:
```bash
dbt run --m <model.sql> --var 'is_test_run: false'
```

### Data
We will use `taxi_zone_lookup.csv` file. We have to create a file inside the `seeds` folder and then run `dbt seed`.

Add this piece of code in `dbt_project.yml` file:
```yaml
seeds: 
    taxi_rides_ny:
        taxi_zone_lookup:
            +column_types:
                locationid: numeric
```
Refresh the column types with:
```bash
dbt seed --full-refresh
```
### Testing and documenting dbt models
 * Tests  
 * Documentation 

 :movie_camera: [Video](https://www.youtube.com/watch?v=UishFmq1hLM&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=37)

_Note: This video is shown entirely on dbt cloud IDE but the same steps can be followed locally on the IDE of your choice_

In the `.yml` file you define your documentation and different tests, for instance:
```yaml
models:
    - name: stg_green_tripdata
      description: >
        Trip made by green taxis, also known as boro taxis and street-hail liveries.
        Green taxis may respond to street hails,but only in the areas indicated in green on the
        map (i.e. above W 110 St/E 96th St in Manhattan and in the boroughs).
        The records were collected and provided to the NYC Taxi and Limousine Commission (TLC) by
        technology service providers. 
      columns:
          - name: tripid
            description: Primary key for this table, generated with a concatenation of vendorid+pickup_datetime
            tests:
                - unique:
                    severity: warn
                - not_null:
                    severity: warn
          - name: VendorID 
            description: > 
                A code indicating the TPEP provider that provided the record.
                1= Creative Mobile Technologies, LLC; 
                2= VeriFone Inc.
          - name: pickup_datetime 
            description: The date and time when the meter was engaged.
          - name: dropoff_datetime 
            description: The date and time when the meter was disengaged.
          - name: Passenger_count 
            description: The number of passengers in the vehicle. This is a driver-entered value.
          - name: Trip_distance 
            description: The elapsed trip distance in miles reported by the taximeter.
          - name: Pickup_locationid
            description: locationid where the meter was engaged.
            tests:
              - relationships:
                  to: ref('taxi_zone_lookup')
                  field: locationid
                  severity: warn
          - name: dropoff_locationid 
            description: locationid where the meter was engaged.
            tests:
              - relationships:
                  to: ref('taxi_zone_lookup')
                  field: locationid
          - name: RateCodeID 
            description: >
                The final rate code in effect at the end of the trip.
                  1= Standard rate
                  2=JFK
                  3=Newark
                  4=Nassau or Westchester
                  5=Negotiated fare
                  6=Group ride
          - name: Store_and_fwd_flag 
            description: > 
              This flag indicates whether the trip record was held in vehicle
              memory before sending to the vendor, aka “store and forward,”
              because the vehicle did not have a connection to the server.
                Y= store and forward trip
                N= not a store and forward trip
          - name: Dropoff_longitude 
            description: Longitude where the meter was disengaged.
          - name: Dropoff_latitude 
            description: Latitude where the meter was disengaged.
          - name: Payment_type 
            description: >
              A numeric code signifying how the passenger paid for the trip.
            tests: 
              - accepted_values:
                  values: "{{ var('payment_type_values') }}"
                  severity: warn
                  quote: false
          - name: payment_type_description
            description: Description of the payment_type code
          - name: Fare_amount 
            description: > 
              The time-and-distance fare calculated by the meter.
              Extra Miscellaneous extras and surcharges. Currently, this only includes
              the $0.50 and $1 rush hour and overnight charges.
              MTA_tax $0.50 MTA tax that is automatically triggered based on the metered
              rate in use.
          - name: Improvement_surcharge 
            description: > 
              $0.30 improvement surcharge assessed trips at the flag drop. The
              improvement surcharge began being levied in 2015.
          - name: Tip_amount 
            description: > 
              Tip amount. This field is automatically populated for credit card
              tips. Cash tips are not included.
          - name: Tolls_amount 
            description: Total amount of all tolls paid in trip.
          - name: Total_amount 
            description: The total amount charged to passengers. Does not include cash tips.

    - name: stg_yellow_tripdata
      description: > 
        Trips made by New York City's iconic yellow taxis. 
        Yellow taxis are the only vehicles permitted to respond to a street hail from a passenger in all five
        boroughs. They may also be hailed using an e-hail app like Curb or Arro.
        The records were collected and provided to the NYC Taxi and Limousine Commission (TLC) by
        technology service providers. 
      columns:
          - name: tripid
            description: Primary key for this table, generated with a concatenation of vendorid+pickup_datetime
            tests:
                - unique:
                    severity: warn
                - not_null:
                    severity: warn
          - name: VendorID 
            description: > 
                A code indicating the TPEP provider that provided the record.
                1= Creative Mobile Technologies, LLC; 
                2= VeriFone Inc.
          - name: pickup_datetime 
            description: The date and time when the meter was engaged.
          - name: dropoff_datetime 
            description: The date and time when the meter was disengaged.
          - name: Passenger_count 
            description: The number of passengers in the vehicle. This is a driver-entered value.
          - name: Trip_distance 
            description: The elapsed trip distance in miles reported by the taximeter.
          - name: Pickup_locationid
            description: locationid where the meter was engaged.
            tests:
              - relationships:
                  to: ref('taxi_zone_lookup')
                  field: locationid
                  severity: warn
          - name: dropoff_locationid 
            description: locationid where the meter was engaged.
            tests:
              - relationships:
                  to: ref('taxi_zone_lookup')
                  field: locationid
                  severity: warn
          - name: RateCodeID 
            description: >
                The final rate code in effect at the end of the trip.
                  1= Standard rate
                  2=JFK
                  3=Newark
                  4=Nassau or Westchester
                  5=Negotiated fare
                  6=Group ride
          - name: Store_and_fwd_flag 
            description: > 
              This flag indicates whether the trip record was held in vehicle
              memory before sending to the vendor, aka “store and forward,”
              because the vehicle did not have a connection to the server.
                Y= store and forward trip
                N= not a store and forward trip
          - name: Dropoff_longitude 
            description: Longitude where the meter was disengaged.
          - name: Dropoff_latitude 
            description: Latitude where the meter was disengaged.
          - name: Payment_type 
            description: >
              A numeric code signifying how the passenger paid for the trip.
            tests: 
              - accepted_values:
                  values: "{{ var('payment_type_values') }}"
                  severity: warn
                  quote: false
          - name: payment_type_description
            description: Description of the payment_type code
          - name: Fare_amount 
            description: > 
              The time-and-distance fare calculated by the meter.
              Extra Miscellaneous extras and surcharges. Currently, this only includes
              the $0.50 and $1 rush hour and overnight charges.
              MTA_tax $0.50 MTA tax that is automatically triggered based on the metered
              rate in use.
          - name: Improvement_surcharge 
            description: > 
              $0.30 improvement surcharge assessed trips at the flag drop. The
              improvement surcharge began being levied in 2015.
          - name: Tip_amount 
            description: > 
              Tip amount. This field is automatically populated for credit card
              tips. Cash tips are not included.
          - name: Tolls_amount 
            description: Total amount of all tolls paid in trip.
          - name: Total_amount 
            description: The total amount charged to passengers. Does not include cash tips.

```
We can define variables in the `dbt_project.yml` file.
```yml
vars:
  payment_type_values: [1, 2, 3, 4, 5, 6]
```
Run the tests:
```bash
dbt test
```
If you want to build everything, you can use the command `build`, for instance:
```bash
dbt build
```
Generate documentation with :
```bash
dbt docs generate
```

### Deploying a dbt project
#### Alternative a: Using BigQuery + dbt cloud
 * Deployment: development environment vs production 
 * dbt cloud: scheduler, sources and hosted documentation

 :movie_camera: [Video](https://www.youtube.com/watch?v=rjf6yZNGX8I&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=38)
  
- Create a Production enviroment
- Create a job that includes `dbt seed, dbt run and dbt test`


#### Alternative b: Using Postgres + dbt core (locally)
 * Deployment: development environment vs production 
 * dbt cloud: scheduler, sources and hosted documentation

 :movie_camera: [Video](https://www.youtube.com/watch?v=Cs9Od1pcrzM&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=39)

### Visualising the transformed data
 * Google data studio 
 * [Metabase (local installation)](https://www.metabase.com/)

 :movie_camera: [Google data studio Video](https://www.youtube.com/watch?v=39nLTs74A3E&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=42) 
 
 :movie_camera: [Metabase Video](https://www.youtube.com/watch?v=BnLkrA7a6gM&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=43) 

 
### Advanced knowledge:
 * [Make a model Incremental](https://docs.getdbt.com/docs/building-a-dbt-project/building-models/configuring-incremental-models)
 * [Use of tags](https://docs.getdbt.com/reference/resource-configs/tags)
 * [Hooks](https://docs.getdbt.com/docs/building-a-dbt-project/hooks-operations)
 * [Analysis](https://docs.getdbt.com/docs/building-a-dbt-project/analyses)
 * [Snapshots](https://docs.getdbt.com/docs/building-a-dbt-project/snapshots)
 * [Exposure](https://docs.getdbt.com/docs/building-a-dbt-project/exposures)
 * [Metrics](https://docs.getdbt.com/docs/building-a-dbt-project/metrics)

## Homework 

More information [here](homework.md)

## Community notes

Did you take notes? You can share them here.

* [Notes by Alvaro Navas](https://github.com/ziritrion/dataeng-zoomcamp/blob/main/notes/4_analytics.md)
* [Sandy's DE learning blog](https://learningdataengineering540969211.wordpress.com/2022/02/17/week-4-setting-up-dbt-cloud-with-bigquery/)
* Add your notes here (above this line)

## Useful links
- [Visualizing data with Metabase course](https://www.metabase.com/learn/visualization/)
- 