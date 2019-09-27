let fs = require('fs')

let express = require('express')
let app = express()

app.use('/', express.static('public'))

app.get('/data', function(req, resp){
    let data = fs.readFileSync('dev_data/dummy.json')
    resp.send(data)
})

app.get('/mongo', function(req, resp) {
    let mongoClient = require('mongodb').MongoClient;
    let client = new mongoClient('mongodb://localhost:27017');
    client.connect().then(() => {
        let db = client.db('NLBClusterMonitor');
        let coll = db.collection('status');
        coll.aggregate([
            {
                "$lookup": {
                    "from": "clusters",
                    "localField": "cluster_id",
                    "foreignField": "_id",
                    "as": "cluster"
                }
            }
        ]).toArray().then( x => {
            resp.send({"servers":x});
        });
        
    }).catch(e => {
        console.log(e);
        resp.sendStatus(404);
    });
})

app.listen(9001, function() {
    console.log('Hey we\'re running - go to localhost:9001 - Press Ctrl+C to end instance')
})
