//index.js
//获取应用实例
Page({
  data: {

},
  bindViewTap: function() {
    wx.navigateTo({
      url: '../posts/posts'
    })
  },
    bindViewN: function() {
    wx.navigateTo({
      url: '../welcome/welcome'
    })
  },
});