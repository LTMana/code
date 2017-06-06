//使用DAO模块
const express = require('express')
const app = express()
const db = require('./model/db.js')

app.get('/', (req, res) => {
    db.insertOne('teacher', {
        'name': '小明'
    }, (err, result) => {
        if (err) {
            console.log('插入失败')
            return
        }
        res.send('插入成功')
    })
})

app.get('/du', (req, res) => {

    let page = parseInt(req.query.page)

    db.find('teacher', (err, result) => {
        if (err) {
            console.log(err)
        }
        res.send(result)

        console.log(result.length)

    },
    {},
    {'pageamount':1,'page':0}
    );
})

app.listen(3000)