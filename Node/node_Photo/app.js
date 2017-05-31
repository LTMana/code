// 引入express框架
const express = require('express')
//创建express实例
const app = express()
// 控制器
const router = require('./controller')

// 设置模板引擎
app.set("view engine","ejs")

// 路由中间件，静态页面
app.use(express.static('./public'))
app.use(express.static('./uploads'))

// 首页
app.get("/",router.showIndex)
app.get("/:albumName",router.showAlbum)
// app.get("/up",router.showUp)
// app.post("/up",router.doPost)

//404
app.use((req,res)=>{
    res.render("err")
})

app.listen(3000)
