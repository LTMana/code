//index.js
//获取应用实例
var app = getApp()
Page({
  data: {
    motto: 'Hello World',
    userInfo: {},
    url: 'http://img02.tooopen.com/images/20150928/tooopen_sy_143912755726.jpg',
    indexCode: null
  },
  //事件处理函数
  bindViewTap: function () {
    wx.navigateTo({
      url: '../logs/logs'
    })
  },
  onLoad: function () {

    // "http://img02.tooopen.com/images/20150928/tooopen_sy_143912755726.jpg",        "http://img06.tooopen.com/images/20160818/tooopen_sy_175866434296.jpg",
    // "http://img06.tooopen.com/images/20160818/tooopen_sy_175833047715.jpg",







  },
  dd: function (code, proSrc, src) {
    var that = this;
    if (!wx.getStorageSync('boardInfo')) {

      var a = {};
      wx.setStorageSync('boardInfo', a);

    }


    if (this.data.indexCode === code) {
      var b = wx.getStorageSync('boardInfo')
      that.setData({
        url: b[code]

      })

    } else {


      wx.downloadFile({
        url: proSrc, //仅为示例，并非真实的资源
        type: 'image',
        success: function (res) {
          var tempFilePath = res.tempFilePath
          wx.saveFile({
            tempFilePath: tempFilePath,
            success: function (res) {
              var b = wx.getStorageSync('boardInfo')
              b[code] = res.savedFilePath
              wx.setStorageSync('boardInfo', b);

              that.setData({
                url: b[code]
              })
            }
          })


        }

      })


    }
    this.data.indexCode = code;
  },

  aaaa: function () {

    this.dd('1', this.data.url)
  }
})
