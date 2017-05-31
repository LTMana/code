const file = require('../models/file.js')
const formidable = require('formidable')
const path = require('path')
const fs = require('fs')
const sd = require('silly-datetime')

// 首页
exports.showIndex = (req, res, next) => {

    file.getAllAlbums((err, allAlabums) => {
        if (err) {
            next()
            return
        }
        res.render('index', {
            "albums": allAlabums
        })
    })
}

// 相册页
exports.showAlbum = (req, res, next) => {

    const albumName = req.params.albumName

    file.getAllImagesByAlbumName(albumName, (err, imagesArray) => {

        if (err) {
            next()
            return
        }

        res.render('album', {
            "albumname": albumName,
            "images": imagesArray
        })

    })



}