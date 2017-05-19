'use strict'
 const http = require('http')

http.createServer((requset, response) => {
  response.write('htdfdfdsfdsfds')
  response.end();

}).listen(3000);



// server.on('requset',(requset,response)=>{
//     console.log('dfdsfdsfdsfdsfds')
//     response.write('htdfdfdsfdsfds')
//     response.end();


// })


// server.listen(10625)