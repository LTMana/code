var fs = require('fs')


//把内容写个文件，无文件则创建文件
fs.appendFile('./1ddd.txtdd', '你好世界', 'utf8', err => {

    if (err) {
        throw `文件写入错误${err}`
    }
})

//创建文件夹
fs.mkdir('./a', err => {

})


//读取文件
fs.readFile('./a/1.txt', 'utf8', (err, data) => {
    console.log('ReadFile:', data)
})

//读取文件夹

fs.readdir('./b', (err, files) => {
    console.log('ReadDir:', files)
    

})

//判断文件夹或文件路径是否存在
fs.access('./acvc', (err) => {
    console.log('acessErr:', err)
})

//判断是文件夹还是文件(stats还是获取大小时间等信息)
fs.stat('./a', (err, stats) => {
    if (stats.isDirectory()) {
        console.log('文件夹')
    } else {
        console.log('不是文件夹')
    }
})