## Fuel Price Analytics Project (dlt + DuckDB + dbt)

This project is designed to demonstrate the use of dbt snapshots and Slowly Changing Dimension Type II (SCD-II) using 
- [11-Seven API](https://projectzerothree.info/api.html) as data source, 
- [dlt](https://dlthub.com/) for data ingesions, 
- [DuckDB](https://duckdb.org/) for data storage,
- [dbt](https://www.getdbt.com/) for data transformation. 

It is structured with production-level standards.

---

## Project Components

### 1. **Data Ingestion with dlt**

We use dlt to extract current fuel prices and load them into a DuckDB database with `replace` write disposition.

#### Key Features:
- Fetches data from 11-Seven API.
- Uses `write_disposition="replace"` since we keep the history in dbt snapshot.
- Saves records into `raw_data.fuel_prices` in DuckDB (`fuel_price_pipeline.duckdb`).

#### Run the pipeline:

```bash
python dlt_pipeline.py
```

#### Test data ingestion:

You can use `./data_ingestion/test_query.ipynb` or any other DuckDB connection to validate the data is ingested.

### 2. **Data Transformation with dbt**

The dbt project builds a robust mdoelling layer using a modular structure.

| Layer        | Folder         | Description                                                 |
| ------------ | -------------- | ----------------------------------------------------------- |
| Staging      | `models/stg`   | Renames and formats raw data from source                    |
| Snapshot     | `snapshots/`   | Tracks changes to fuel prices using dbt snapshot            |
| Intermediate | `models/int`   | Computes historical price changes and filters latest prices |
| Marts        | `models/marts` | Aggregated metrics for downstream consumption               |

#### Running the dbt Project

#### 1. Install dependencies

```bash
pip install -r requirements.txt
```

#### 2. Set up dbt Profile

Update ~/.dbt/profiled.yml with correct DuckDB path.

#### 3. Run dbt Models

```bash
# Create snapshot history
dbt snapshot

# Run all models
dbt run

# Test model integrity
dbt test
```

Or you can simply run all with single command:

```bash
dbt build
```

## Notes

- The snapshot uses check strategy based on the price column.

- The latest prices are extracted by filtering where dbt_valid_to IS NULL.

- DuckDB is used locally for simplicity and portability. It can be easily replaced with BigQuery, Postgres, or Snowflake in production.
