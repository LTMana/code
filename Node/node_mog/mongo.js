const express = require('express')
const app = express()
const MongoClient = require('mongodb').MongoClient

app.get('/',(req,res)=>{
   const url = 'mongodb://localhost:27017/test'
   MongoClient.connect(url,(err,db)=>{
     if(err){
         console.log('数据库连接失败')
         return
     }
     console.log('Connected correctly to server')    
     db.collection('restaurants').insertOne({
       'name':'哈哈',
       'age':parseInt(Math.random() * 100 +10)
     },(err,result)=>{
        if(err){
            console.log('插入失败')
            return
        }
        console.log(result)
        res.send(result)
        db.close();
     })
   })
})


app.listen(3000)