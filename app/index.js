let fs = require('fs')

let express = require('express')
let app = express()

app.use('/', express.static('public'))

app.get('/data', function(req, resp){
    let data = fs.readFileSync('dev_data/dummy.json')
    resp.send(data)
})

app.listen(9001, function() {
    console.log('Hey we\'re running - go to localhost:9001 - Press Ctrl+C to end instance')
})
