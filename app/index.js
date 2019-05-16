let express = require('express')
let app = express()

app.get('/', function(req, resp) {
  resp.send('hello world')
})

app.listen(9001, function() {
    console.log('Hey we\'re running')
})
