var app = getApp()
Page({
  data: {
    hasUserInfo: false
  },
  getUserInfo: function () {
    var that = this

    if (app.globalData.hasLogin === false) {
      wx.login({
        success: function(res){
          // success
          _loginJZYC(res)
        },
        fail: function() {
          // fail
        },
        complete: function() {
          // complete
        }
      })
      // wx.login({
      //   success: _getUserInfo
      // })
    } else {
      _getUserInfo()
    }

    function _loginJZYC(res) {
      demo: MD5('2015@applogin_')
      if(res.code){
        wx.request({
          url: 'http://wq.jd.com/mlogin/applogin/AppWXLogin',
          data: {
            code :res.code,
            uuid :'4805e31ceb324c2a90d831926b27daf3',
            checkcode :MD5('2015@applogin_'+res.code)
        },
          method: 'POST', 
        // header: {}, // 设置请求的 header
          success: function(res){
            // success
             console.log('获取用户登录态失败！' + res)
          },
          fail: function() {
            // fail
          },
          complete: function() {
          // complete
          }
      })
      }
    

    }
  },
  clear: function () {
    this.setData({
      hasUserInfo: false,
      userInfo: {}
    })
  }
})
