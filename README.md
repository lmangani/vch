# vch

ClickHouse driver for V

## Library Usage
```
module main

import metrico.vch

fn main(){
    client := vch.new_client('http://clickhouse:8123')
    client.exec('SELECT 1')
}

```

## CLI Usage
```
CH_API="http://clickhouse:8123" CH_AUTH="default:password" vch -q "SHOW DATABASES" -f JSONEachRow
```
