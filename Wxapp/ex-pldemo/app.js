//app.js
App( {
  onLaunch: function() {
    var data = wx.getStorageSync('posts_collected');
    if(!data){
      // 如果没有缓存数据，则写入缓存数据
       wx.setStorageSync("posts_collected", {});
    }
  },
  getUserInfo:function(cb){
    var that = this
    if(this.globalData.userInfo){
      typeof cb == "function" && cb(this.globalData.userInfo)
    }else{
      //调用登录接口
      wx.login({
        success: function () {
          wx.getUserInfo({
            success: function (res) {
              that.globalData.userInfo = res.userInfo
              typeof cb == "function" && cb(that.globalData.userInfo)
            }
          })
        }
      })
    }
  },
  globalData: {
    userInfo: null,
    doubanBase: "https://api.douban.com"
  }
})