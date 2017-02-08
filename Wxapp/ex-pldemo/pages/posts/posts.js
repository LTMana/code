
var postsData = require('../../data/posts-data.js')

Page({
  data: {
    postList: null,
  },
  //事件处理函数
    onPostTap: function(event) {
      var postId = event.currentTarget.dataset.postid;
      wx.navigateTo( {
          url: 'post-detail/post-detail?id='+postId
      })
  },
  onSwiperItemTap:function(e){
    var postId = e.currentTarget.dataset.postid;
      wx.navigateTo( {
          url: 'post-detail/post-detail?id='+postId
      })
  },
  onLoad: function () {
    //从缓存中取本地数据
    this.data.postList = postsData.postList
  }
})
