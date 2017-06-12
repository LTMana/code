const MongoClient = require('mongodb').MongoClient
const settings = require("../settings.js")

function _connectDB(callback) {
    const url = settings.dburl
    MongoClient.connect(url, (err, db) => {
        callback(err, db)
    })
}

//插入数据库
exports.insertOne = (collectionName, json, callback) => {
    _connectDB((err, db) => {
        db.collection(collectionName).insertOne(json, (err, result) => {
            if(err){
                console.log('错误',err)
            }
            callback(err, result)
            db.close()
        })
    })
}
exports.find = (collectionName = null, callback, json = {}, args = {}) => {

    if (collectionName == null) {
        throw new Error('collectionName参数不能为空');
    }
    var skipnumber = args.pageamount * args.page || 0;
    var limit = args.pageamount || 0;
    var sort = args.sort || {};
    let result = [];
    _connectDB((err, db) => {

        let cursor = db.collection(collectionName).find(json).skip(skipnumber).limit(limit).sort(sort)
        cursor.each((err, doc) => {
            if (err) {
                callback(err, null)
                db.close()
                return
            }
            if (doc != null) {
                result.push(doc)
            } else {

                callback(null, result)
                db.close();
            }

        })

    })

}

exports.deleteMany = (collectionName, json, callback) => {

    _connectDB((err, db) => {
        db.collection(collectionName).deleteMany(json, (err, results) => {
            callback(err, results)
            db.close()
        })
    })

}


exports.updateMany = (collectionName, json1, json2, callback) => {

     db.collection(collectionName).updateMany(json1,json2,(err,results)=>{

         callback(err,results)
         db.close()

     })

}

exports.getAllCount = (collectionName,callback)=>{
     
     _connectDB((err,db)=>{      
        db.collection(collectionName).count({}).then(count =>{
          callback(count)
          db.close()
        })
     })

}