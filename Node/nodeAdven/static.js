const http = require('http')
const url = require('url')
const fs = require('fs')

http.createServer((req, res) => {
    
    let pathname = url.parse(req.url).pathname
    if(pathname == '/favicon.ico'){
        return
    }



    fs.readFile('./web1' + pathname, (err, data) => {

        if (err) {
            throw err
        }

        res.end(data)


    })


   if (req.url = '/favicon.ico') {
        return
    }

}).listen(3000, '127.0.0.1')