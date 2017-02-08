
var app = getApp()
var util = require('../../../utils/util.js')
Page({
  data: {
    movies:{},
    isEmpty:true,
    totalCount: 0,
    requestUrl: {},
    navigateTitle:"",
  },
  onLoad: function (options) {
     var category = options.category;
     this.data.navigateTitle = category;
     switch(category){
         case "正在热映":
            var inTheatersUrl = app.globalData.doubanBase + "/v2/movie/in_theaters";
            this.data.requestUrl = inTheatersUrl;
            this.getMovieListData(inTheatersUrl,"正在热映","movies");
            break;
         case "即将上映":
            var comingSoonUrl = app.globalData.doubanBase + "/v2/movie/coming_soon";
            this.data.requestUrl = comingSoonUrl;
            this.getMovieListData(comingSoonUrl,"即将上映","movies");
            break;
         case "Top250":
            var top250url = app.globalData.doubanBase + "/v2/movie/top250";
            this.data.requestUrl = top250url;
            this.getMovieListData(top250url, "Top250", "movies");
            break;
     } 
  },

  onPullDownRefresh:function(){
    wx.showNavigationBarLoading()
    var nextUrl = this.data.requestUrl + "?start=0" + "&count=20";
    this.getMovieListData(nextUrl, "Top250", "movies");
  },

  onReady:function(){
      wx.setNavigationBarTitle({
        title:  this.data.navigateTitle
      });
      
      wx.showNavigationBarLoading()
  },

  onScrollLower:function(event){
    //显示正在加载的图标
    wx.showNavigationBarLoading()
    var nextUrl = this.data.requestUrl + "?start=" + this.data.totalCount + "&count=20";
    this.getMovieListData(nextUrl, "Top250", "movies");
  },

  onMovieTap:function(event){
    var movieId = event.currentTarget.dataset.movieid;
      wx.navigateTo( {
          url: '../movie-detail/movie-detail?id='+movieId
      })
  },
  getMovieListData:function(url,title, settedKey){
    var that = this;
    wx.request({
        url:url,
        header: {
          'Content-Type': ''
        },
        success:function(res){
          that.processDoubanData(res.data,title, settedKey);
          wx.stopPullDownRefresh();
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
      var tempMovies = {}
      // 加载的新页数据需要同已有的数据合并后再一同绑定到页面
      if(!this.data.isEmpty){
         tempMovies = this.data.movies.movies.concat(movies);
      }
      else{
         tempMovies = movies;
         this.data.isEmpty = false;
      }
      var readyData = {
        title: columnTitle,
        movies:tempMovies
      }
      var data = {};
      data[settedKey] = readyData;
      this.setData(data)
      this.data.totalCount += 20;

      //加载完毕后取消正在加载的图标
      wx.hideNavigationBarLoading()
  }
})
