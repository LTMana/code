const MongoClient = require('mongodb').MongoClient

function _connectDB(callback) {
    const url = 'mongodb://localhost:27017/itcast'
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

// exports.find = (collectionName, json = {}, args = {}, callback) => {

//     let call; //回调函数
//     if (typeof json == 'function') {
//         call = json
//         var skipnumber = 0;
//         var limit = 0;
//         var sort = {};
//         var findJson = {}
//     } else if (typeof args == 'function') {

//         var findJson = json
//         call = args
//         var skipnumber =  0;
//         var limit =  0;
//         var sort =  {};

//     } else {
//         var findJson = json
//         var skipnumber = args.pageamount * args.page || 0;
//         var limit = args.pageamount || 0;
//         var sort = args.sort || {};
//         call = callback
//     }

//     let result = [];
//     _connectDB((err, db) => {

//         let cursor = db.collection(collectionName).find(findJson).skip(skipnumber).limit(limit).sort(sort)
//         cursor.each((err, doc) => {
//             if (err) {
//                 call(err, null)
//                 db.close()
//                 return
//             }
//             if (doc != null) {
//                 result.push(doc)
//             } else {

//                 call(null, result)
//                 db.close();
//             }

//         })

//     })



// }


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