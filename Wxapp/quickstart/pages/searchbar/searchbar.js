Page({
    data: {
        inputShowed: false,
        inputVal: "",
        path: {
            "resultCode": "200",
            "description": "数据返回成功",
            "userId": "10010",
            "city": [
                {
                    character: "A",
                    cityList: [
                        {
                            BoardId: "100_103_12",
                            BoardName: "安庆火车站",
                            cityCode: "210100",
                            cityName: "沈阳",
                            pinYin: "anqinghuochezhan",
                            initial: "aqhcz"
                        }, {
                            BoardId: "100_103_12",
                            BoardName: "安顺市场",
                            cityCode: "210100",
                            cityName: "沈阳",
                            pinYin: "anshunshichang",
                            initial: "assc"


                        }


                    ]
                },
                {
                    character: "B",
                    cityList: [
                        {
                            BoardId: "100_103_12",
                            BoardName: "北京公园",
                            cityCode: "210100",
                            cityName: "沈阳",
                            pinYin: "beijinggongyuan",
                            initial: "bjgy"
                        },
                        {
                            BoardId: "100_103_12",
                            BoardName: "北京地铁",
                            cityCode: "210100",
                            cityName: "沈阳",
                            pinYin: "beijingditie",
                            initial: "bjdt"
                        },
                        {
                            BoardId: "100_103_12",
                            BoardName: "白城馅饼地铁",
                            cityCode: "210100",
                            cityName: "沈阳",
                            pinYin: "baichengxianbing",
                            initial: "bcxb"
                        }, {
                            BoardId: "100_103_12",
                            BoardName: "北顺地铁",
                            cityCode: "210100",
                            cityName: "沈阳",
                            pinYin: "beishunditie",
                            initial: "bsdt"
                        },

                    ]
                }


            ]

        }

    },
    showInput: function () {
        this.setData({
            inputShowed: true
        });
    },
    hideInput: function () {
        this.setData({
            inputVal: "",
            inputShowed: false
        });
    },
    clearInput: function () {
        this.setData({
            inputVal: ""
        });
    },
    inputTyping: function (e) {
        this.search(e.detail.value);

        this.setData({
            inputVal: e.detail.value
        });
    },
    search: function (c) {
        var tp = [];
        var citylist = this.data.path.city
        for (var i = 0; i < citylist.length; i++) {
            var list = citylist[i].cityList;
            var character = citylist[i].character;
            for (var j = 0; j < list.length; j++) {
                var bool = list[j].BoardName.indexOf(c)
                var bool1 = list[j].pinYin.indexOf(c)
                var bool2 = list[j].initial.indexOf(c)
                var bool3 = character.indexOf(c)
                //console.log(bool);
                if (bool >= 0 || bool1 >= 0 || bool2 >= 0 || bool3>=0) {
                    var dd = {
                        character: citylist[i].character,
                        citylists: list[j]
                    };
                    tp.push(dd);                
                }
            }
        }
        //console.log(tp);
        this.setData({
            serchresult: tp
        })

    }
});