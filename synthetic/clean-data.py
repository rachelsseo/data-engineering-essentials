import os
import duckdb

input_file = "https://s3.amazonaws.com/uvasds-systems/data/synthdata.parquet"

def clean_parquet():

    con = None

    try:
        # Connect to local DuckDB
        con = duckdb.connect(database='synthdata.duckdb', read_only=False)

        # Clear and ipmort
        con.execute(f"""
            -- SQL goes here
            DROP TABLE IF EXISTS synthdata;
            CREATE TABLE synthdata
                AS
            SELECT * FROM read_parquet('{input_file}');
        """)





    except Exception as e:
        print(f"An error occurred: {e}")


if __name__ == "__main__":
    clean_parquet()

