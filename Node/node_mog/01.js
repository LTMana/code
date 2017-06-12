//使用DAO模块
const express = require('express')
const app = express()
const db = require('./model/db.js')

app.get('/charu', (req, res) => {
    
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

    }, {}, {
        "pageamount": 1,
        "page": page
    });
})

app.get('/shan', (req, res) => {

    let name = req.query.name
    db.deleteMany('teacher', {
        'name': name
    }, (err, result) => {

        if (err) {
            console.log(err)
        }
        res.send(result)
    })

})

app.get('/xiugai', (req, res) => {
    db.updateMany('teacher', {

        }


    )


})

app.listen(3000)