config = require './config.json'

# Easticsearch
ES = require 'elasticsearch'
originClient = new ES.Client
  apiVersion: config.origin.version
  host: config.origin.host
  log: null

targetClient = new ES.Client
  apiVersion: config.target.version
  host: config.target.host
  log: null

# Counter
@count = 0

# 1
run = =>
  originClient.search
    index: config.origin.index
    type: config.origin.type
    scroll: '30s'
    size: config.bulkSize
  , getMore

# 2
getMore = (err, res) =>
  return console.error err if err?

  { hits, total } = res.hits

  if total > @count
    @count += hits.length
    # call 3
    insert hits, (err) =>
      return config.error if err?
      console.log "Inserted: #{@count} / #{total}"
      # call 4
      scroll res
  else
    console.log 'DONE!'

# 3
insert = (hits, cb) ->
  body = []

  for hit in hits
    body.push
      index:
        _index: config.target.index
        _type: config.target.type
        _id: hit._id
    body.push hit._source

  targetClient.bulk
    body: body
  , (err, res) ->
    return cb err if err?
    cb null, res

# 4
scroll = (res) =>
  originClient.scroll
    scrollId: res._scroll_id
    scroll: '30s'
  , getMore

run()