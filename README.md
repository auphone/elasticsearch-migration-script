# Elasticsearch migration script
A simple migration script written in CoffeeScript.

## Install
```bash
cd elasticsearch-migration-script
npm install
```
## Configuration
Change the es configuration in `config.json`
```json
{
  "bulkSize": 1000,
  "origin": {
    "host": "localhost:9200",
    "version": "1.7",
    "index": "twitter",
    "type": "tweet"
  },
  "target": {
    "host": "localhost:9201",
    "version": "5.5",
    "index": "twitter",
    "type": "tweet"
  }
}
```
## Run the script
```bash
coffee index.coffee
```

Good luck!
