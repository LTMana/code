const fs = require('fs')

//文件夹名字的数组
exports.getAllAlbums = function (callback) {
    fs.readdir('./uploads', (err, files) => {
        if (err) {
            callback('没有找到uploads文件', null);
            return;
        }
        var allAlbums = [];
    
            (function iterator(i) {
                if (i == files.length) {
                    console.log(allAlbums)
                    callback(null, allAlbums)
                    return
                }
                fs.stat('./uploads/' + files[i], (err, stats) => {
                    if (err) {
                        callback('找不到文件' + files[i], null)
                        return
                    }
                    if (stats.isDirectory()) {
                        allAlbums.push(files[i])
                    }
                    iterator(i + 1)
                })

            })(0);
    })
}

exports.getAllImagesByAlbumName = (albumName, callback) => {

    fs.readdir('./uploads/' + albumName, (err, files) => {
        if (err) {
            callback('没有找到uploads文件', null)
            return
        }
        var allImages = [];

        (function iterator(i) {
            if (i == files.length) {
                console.log(allImages)
                callback(null, allImages)
                return
            }
            fs.stat(`./uploads/${albumName}/${files[i]}`, (err, stats) => {
                if (err) {
                    callback('找不到文件' + files[i], null)
                    return
                }
                if (stats.isFile()) {
                    allImages.push(files[i])
                }
                iterator(i + 1)
            })
        })(0);
    })
}