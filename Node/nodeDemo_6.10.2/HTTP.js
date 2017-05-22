'use strict'
const http = require('http')
const fs = require('fs')
const url = require('url')
const querystring = require('querystring')
http.createServer((requset, response) => {

  console.log(requset.url, requset.method)
  let urlObjc = url.parse(requset.url, true)
  if (urlObjc.pathname == '/htd' && requset.method == 'GET') {



    response.write(urlObjc.pathname)
    let dd = urlObjc.query
    response.write(dd.ddd)
    response.end();
  } else if (urlObjc.pathname == '/hello' && requset.method == 'POST') {

    let data = ''
    response.on('data', (chunk) => {
      console.log('ddddddddd')
      data += chunk
    })
    response.on('end', () => {
      console.log('endendend')
      let obj = querystring.parse(data)

      console.log('obj',obj)

      response.end()
    })




  } else if (urlObjc.pathname == '/mac.html' && requset.method == 'GET') {

    fs.readFile('./mac/index.html', 'utf8', (err, data) => {
      console.log(err)
      response.end(data)
    })


  }



}).listen(3000);