//index.js
//获取应用实例
var util = require('../../utils/util.js')
var app = getApp();
Page({
  data: {
    inTheaters:{},
    comingSoon:{},
    top250:{},
    containerShow:true,
    searchPannelShow:false,
    searchResult:{},
  },
  //事件处理函数
  bindViewTap: function() {
    wx.navigateTo({
      url: '../logs/logs'
    })
  },
  onLoad: function () {
    var b=2;
    var inTheatersUrl = app.globalData.doubanBase + "/v2/movie/in_theaters?count=3&start=0";
    this.getMovieListData(inTheatersUrl,"正在热映","inTheaters");

    var comingSoonUrl = app.globalData.doubanBase + "/v2/movie/coming_soon?count=3&start=0";
    this.getMovieListData(comingSoonUrl, "即将上映", "comingSoon");

    var top250url = app.globalData.doubanBase + "/v2/movie/top250?count=3&start=0";
    this.getMovieListData(top250url, "Top250", "top250");
  },

  onShow:function(){

  },

  onBindFocus:function(event){
      this.setData({
      containerShow:false,
      searchPannelShow:true
    });
  },

  onCancleImgTap:function(event){
    this.setData({
      containerShow:true,
      searchPannelShow:false
    })
  },

  onMoreTap:function(event){
    var category = event.currentTarget.dataset.category;
    wx.navigateTo( {
        url: 'more-movie/more-movie?category='+category
    })
  },

  onBindChange:function(event){
    var text = event.detail.value;
    var searchUrl = app.globalData.doubanBase + "/v2/movie/search?q=" + text;
    this.getMovieListData(searchUrl, "", "searchResult");
  },

  onMovieTap:function(event){
    var movieId = event.currentTarget.dataset.movieid;
      wx.navigateTo( {
          url: 'movie-detail/movie-detail?id='+movieId
      })
  },

  onReady:function(){
       wx.setNavigationBarTitle({
        title: '光与影'
      });
  },

  // onShow:function(){
  //      wx.setNavigationBarTitle({
  //       title: '光与影'
  //     });
  // },
  
  getMovieListData:function(url,title, settedKey){
    var that = this;
    wx.request({
        url:url,
        header: {
          'Content-Type': ''
        },
        success:function(res){
          that.processDoubanData(res.data,title, settedKey);
        }
    })
  },
  processDoubanData:function(moviesDouban,columnTitle,settedKey){
      var movies = [];
      for(var subject in moviesDouban.subjects){
        var title = moviesDouban.subjects[subject].title;
        var titleLength = title.length;
        if(titleLength>=6){
           title = title.substring(0,6)+ '...';
        }
         var temp = {
            stars: util.convertToStarsArray(moviesDouban.subjects[subject].rating.stars),
            average: moviesDouban.subjects[subject].rating.average,
            title: title,
            coverageUrl: moviesDouban.subjects[subject].images.large,
            movieId:moviesDouban.subjects[subject].id
         };
         movies.push(temp);
      }
      var readyData = {
        title: columnTitle,
        movies:movies
      }
      var data = {}
      data[settedKey] = readyData;
      this.setData(data)
  }
})
