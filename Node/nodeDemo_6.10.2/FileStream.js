//大文件流模式传输
const fs = require('fs')

const rs = fs.createReadStream('./02-(了解)HYPageView介绍_iOS拓展班二期_直播项目.mp4')

const statu = fs.statSync('./02-(了解)HYPageView介绍_iOS拓展班二期_直播项目.mp4')
console.log('文件大小:', statu.size)

const ws = fs.createWriteStream('./demo.mp4')

//管子联通文件流          
//rs.pipe(ws)


var tempTotol = 0
//读文件流
rs.on('data', (chunk) => {
    tempTotol += chunk.length
    console.log('写入进度：', ((tempTotol / statu.size) * 100).toFixed(2) + '%')
    ws.write(chunk)
})


rs.on('end', () => {
    console.log('结束')
    ws.end
})