//使用DAO模块
const express = require('express')
const app = express()
const db = require('./model/db.js')

app.get('/',(req,res)=>{
   db.insertOne('teacher',{'name':'小红'},(err,result)=>{
       if(err){
           console.log('插入失败')
           return
       }
       res.send('插入成功')
   })
})


app.listen(3000)