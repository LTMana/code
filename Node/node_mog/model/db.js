const MongoClient = require('mongodb').MongoClient

function _connectDB(callback) {
    const url = 'mongodb://localhost:27017/test'
    MongoClient.connect(url, (err, db) => {
        callback(err, db)
    })
}

//插入数据库
exports.insertOne = (collectionName, json, callback) => {
    _connectDB((err, db) => {
        db.collection(collectionName).insertOne(json, (err, result) => {
            callback(err, result)
            db.close()
        })
    })
}