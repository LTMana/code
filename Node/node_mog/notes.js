const express = require("express");
const app = express();
const db = require("./model/db.js");
const formidable = require('formidable');
const ObjectId = require('mongodb').ObjectID;

app.set('view engine', 'ejs')

app.use(express.static('./public'))

app.get('/', (req, res, next) => {

    db.getAllCount('liuyanben', (count) => {

        res.render('index', {
            'pageamount': Math.ceil(count / 20)
        })

    })


})
app.get("/du", function (req, res, next) {
    //可以接受一个参数
    var page = parseInt(req.query.page);

    db.find("liuyanben", function (err, result) {
        res.json({
            "result": result
        });
    }, {}, {
        "sort": {
            "shijian": -1
        },
        "pageamount": 20,
        "page": page
    });
});

app.post('/tijiao', (req, res, next) => {

    let form = new formidable.IncomingForm();

    form.parse(req, (err, fields) => {
        db.insertOne('liuyanben', {
            "xingming": fields.xingming,
            "liuyan": fields.liuyan,
            "shijian": new Date()
        }, (err, result) => {
            if (err) {
                res.send({
                    'result': -1
                })
                return
            }
            res.json({
                'result': 1
            })

        })
    })
})



app.listen(3000)