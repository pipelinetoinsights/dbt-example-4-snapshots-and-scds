import dlt
import requests
from datetime import datetime, timezone
from typing import Iterator, Dict


@dlt.resource(name="fuel_prices", write_disposition="replace")
def fuel_price_data() -> Iterator[Dict]:
    response = requests.get(
        "https://projectzerothree.info/api.php?format=json", allow_redirects=True
    )
    response.raise_for_status()
    data = response.json()

    updated_at = datetime.fromtimestamp(data["updated"], tz=timezone.utc).isoformat()

    for region in data.get("regions", []):
        for price in region.get("prices", []):
            record = {
                "region": region["region"],
                "suburb": price["suburb"],
                "state": price["state"],
                "type": price["type"],
                "price": price["price"],
                "name": price["name"],
                "postcode": price["postcode"],
                "lat": price["lat"],
                "lng": price["lng"],
                "updated_at": updated_at,
            }
            yield record


@dlt.source
def fuel_price_source():
    return fuel_price_data


if __name__ == "__main__":
    pipeline = dlt.pipeline(
        pipeline_name="fuel_price_pipeline",
        destination="duckdb",
        dataset_name="raw_data",
    )
    load_info = pipeline.run(fuel_price_source())
    print(load_info)
