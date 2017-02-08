//index.js
//获取应用实例
var util = require('../../../utils/util.js')
var app = getApp()
Page({
  data: {
    movie:{},
  },
  //事件处理函数
  bindViewTap: function() {
    wx.navigateTo({
      url: '../logs/logs'
    })
  },
  onReady:function(){
      wx.setNavigationBarTitle({
        title: '电影详情'
      });
  },
  onLoad: function (options) {
    var movieId=options.id;
    this.getMovieDetail(movieId);
    console.log('onLoad')
    var that = this
    //调用应用实例的方法获取全局数据
    app.getUserInfo(function(userInfo){
      //更新数据
      that.setData({
        userInfo:userInfo
      })
    })
  },
  getMovieDetail:function(movieId){
    var movieUrl = app.globalData.doubanBase + "/v2/movie/subject/" + movieId;
    var that = this;
     wx.request({
        url:movieUrl,
        header: {
          'Content-Type': ''
        },
        success:function(res){
           var data = res.data;
           var director ={
             avatar:"",
             name:"",
             id:""
           }
           if(data.directors[0]!=null){
              if(data.directors[0].avatars!=null){
                  director.avatar = data.directors[0].avatars.large
                 
              }
              director.name = data.directors[0].name;
              director.id = data.directors[0].id;
           }
           var movie = {
             movieImg:data.images?data.images.large:"",
             country:data.countries[0],
             title: data.title,
             originalTitle: data.original_title,
             wishCount: data.wish_count,
             commentCount: data.comments_count,
             year:data.year,
             generes: data.genres.join("、"),
             stars: util.convertToStarsArray(data.rating.stars),
             score: data.rating.average,
             director:director,
             casts:util.convertToCastString(data.casts),
             castsInfo: util.convertToCastInfos(data.casts),
             summary:data.summary.substring(0,100)+"..."
           }
          that.setData({
            movie:movie
          })
        }
    })
  }
})
