'use strict'

var path = require('path')
//获取文件全路径
console.log(path.join('PathJoin:',__dirname,'1ddd.txt'))

//获取路径下的文件
console.log('PathBaseName:',path.basename(`/Users/liubotong/Desktop/GitProject/code/Node/nodeDemo_6.10.2/a/1.txt 
`) )
//获取不带后缀的文件名
console.log('PathBaseNamePre:',path.basename(`/Users/liubotong/Desktop/GitProject/code/Node/nodeDemo_6.10.2/a/1.txt`,'.txt'))
//获取文件夹路径
console.log('PathDirName:',path.dirname(`/Users/liubotong/Desktop/GitProject/code/Node/nodeDemo_6.10.2/a/1.txt 
`))

//获取文件后缀名
console.log('PathExtname:',path.extname(`/Users/liubotong/Desktop/GitProject/code/Node/nodeDemo_6.10.2/a/1.txt 
`))

