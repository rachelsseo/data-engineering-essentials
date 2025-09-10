import os
import duckdb

input_file = "https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2025-01.parquet"

def duckdb_read_parquet(input_file):

    con = None

    try:
        # Connect to local DuckDB instance
        con = duckdb.connect(database='transform.duckdb', read_only=False)


    except Exception as e:
        print(f"An error occurred: {e}")


if __name__ == "__main__":
    duckdb_read_parquet(input_file)