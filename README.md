# vch

ClickHouse driver for V

## Library Usage
```v
module main

import  vch

fn main(){
    client := vch.new_client('http://clickhouse:8123', 'default:password')
    client.exec('SELECT 1')
}

```

## CLI Usage
```bash
CH_API="http://clickhouse:8123" CH_AUTH="default:password" vch -q "SHOW DATABASES" -f JSONEachRow
```
