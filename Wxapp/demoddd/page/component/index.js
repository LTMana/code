//input.js
var util = require('../../util/util.js');
var pageObject = {
  //和页面进行数据绑定的变量
     data: {
        provinceArray: [],
        cityArray: [],
        countyArray: [],
        provinceIndex: 0,
        cityIndex: 0,
        countyIndex: 0
    },
    //全部临时变量
   ProID: '',
   CityID: '',
   cityArrayDemo: [],
   onLoad: function(options) {
    // Do some initialize when page load.
        var provinceArrayDemo = []
        for (var i = 0; i < util.provinceArray.length; ++i) {
          var item = util.provinceArray[i]
          provinceArrayDemo.push(item.name)
        }
        this.setData({
          provinceArray: provinceArrayDemo
        })
    },

  bindProvinceChange: function(e) {

    //先取省份里面的 ProID
     for (var i = 0; i < util.provinceArray.length; ++i) {
          var item = util.provinceArray[i]
          if (i==e.detail.value){
            this.ProID = item.ProID
            break
          }
      }
      this.cityArrayDemo = []
    //将城市里面里面的 ProID 组合在一起
      for (var i = 0; i < util.cityArray.length; ++i) {
          var item = util.cityArray[i]
          if (item.ProID==this.ProID){
            this.cityArrayDemo.push(item.name)
          }
      }
       this.setData({
          provinceIndex: e.detail.value,
          cityArray: this.cityArrayDemo,
      })
      // this.CityID = ''
  },
  bindCityChange: function(e) {
    //先取市里面的 ProID
    //  console.log(cityArray)

      for (var j = 0; j < util.cityArray.length; ++j) {
        var item = util.cityArray[j]
        if (item.name==this.cityArrayDemo[e.detail.value]){
          this.CityID = item.CityID
          break
        }
      }
    //将城市里面里面的 ProID 组合在一起
      var countyArrayDemo = []
      for (var i = 0; i < util.countyArray.length; ++i) {
          var item = util.countyArray[i]
          if (item.CityID==this.CityID){
            console.log(countyArrayDemo)
            countyArrayDemo.push(item.DisName)
          }
      }
      this.setData({
          countyArray: countyArrayDemo,
          cityIndex: e.detail.value,
          countyIndex: 0
      })
  },
  bindCountyChange: function(e) {
    this.setData({
      countyIndex: e.detail.value
    })
  }

}
Page(pageObject)


