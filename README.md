<img src='https://user-images.githubusercontent.com/1423657/147935343-598c7dfd-1412-4bad-9ac6-636994810443.png' style="margin-left:-10px" width=180>

[![vlang-build](https://github.com/lmangani/vch/actions/workflows/v.yml/badge.svg)](https://github.com/lmangani/vch/actions/workflows/v.yml)

# vch

HTTP ClickHouse driver for V

#### Status
- Functional _(exec, ping)_
- Experimental, Basic & Untested. Do _not_ use this in production

## Library Usage
```v
module main

import vch

fn main(){
    client := vch.new_client('http://clickhouse:8123', 'default:password')
    client.exec('SELECT 1')
}

```

## CLI Usage
```bash
CH_API="http://clickhouse:8123" CH_AUTH="default:password" vch -q "SHOW DATABASES" -f JSONEachRow
```
