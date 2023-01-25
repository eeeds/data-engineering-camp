#!/usr/bin/env python

import pandas as pd
from sqlalchemy import create_engine
from time import time 
import argparse
import os 

def main(params):
    user = params.user
    password = params.password
    host = params.host
    port = params.port
    db = params.db
    table_name = params.table_name
    url = params.url
    #donwload parquet file
    file_name = "output.parquet"
    os.system(f"wget {url} - O {file_name}")
    df = pd.read_parquet(url, engine="pyarrow")
    #Create engine
    engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')
    df = pd.read_parquet(f'yellow_tripdata_2021-01.parquet', engine="pyarrow")
    ## Change data type
    df.tpep_dropoff_datetime = pd.to_datetime(df.tpep_dropoff_datetime)
    df.tpep_pickup_datetime = pd.to_datetime(df.tpep_pickup_datetime)

    df.to_sql(name = 'yellow_taxi_data', con = engine, if_exists='replace')

parser = argparse.ArgumentParser(description= "Ingest CSV data to Postgres")

#user, password, host, port, database name, table name
#url of the csv

parser.add_argument('--user', help='user name for postgres')
parser.add_argument('--password', help='password name for postgres')
parser.add_argument('--host', help='host name for postgres')
parser.add_argument('--port', help='port name for postgres')
parser.add_argument('--db', help='database name for postgres')
parser.add_argument('--table_name', help='table name for postgres')
parser.add_argument('--url', help='url of the csv')


args = parser.parse_args()


if __name__ == "__main__":
    main(args)








