const http = require('http')
const fs = require('fs')
const server = http.createServer((req, res) => {
  console.log("服务器启动")
  if (req.url == '/yuan') {
    fs.readFile('./text.html', (err, data) => {
      res.writeHead(200, {
        "content-type": "text/html;charset=UTF-8"
      })
      res.end(data)
    })
  } else if (req.url == '/fang') {
    res.writeHead(200, {
      "content-type": "text/html;charset=UTF-8"
    })
    res.end('<h1>我是一个标题</h1>')
  } else if (req.url == '/linkedin-icon.png') {

    fs.readFile('./linkedin-icon.png', (err, data) => {

      res.writeHead(200, {
        "content-type": "image/png"
      })

      res.end(data)

    })
  }
})

server.listen(3000, "127.0.0.1")