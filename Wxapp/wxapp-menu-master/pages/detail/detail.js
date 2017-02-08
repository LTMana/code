var app = getApp();
Page({
  data:{
      menu: [],
  },
  onLoad:function(options){
      var _this = this;
      var id = options.id;
      //进行网络请求，根据id获取菜谱详情
      wx.request({
          url: 'http://apis.juhe.cn/cook/queryid?key=' + app.AppKey + '&id=' + id,
          success: function(res) {
              console.log(res.data);
              var menu = res.data.result.data[0];
              _this.setData({
                  menu: menu
              })
          }
      })
  }
})