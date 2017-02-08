var app = getApp()
Page( {
    data: {
        // titles:["小楼昨夜又秋风","当我们在谈论经济学时时，我们在谈论什么"],
        // contents:[]
        // // contents:[],
        // userInfo: {}
    },
    //事件处理函数
    onReady: function() {
        var c = 2;
    },
    onLoad: function() {
        console.log( 'onLoad' )
        var that = this
        //调用应用实例的方法获取全局数据
        app.getUserInfo( function( userInfo ) {
            //更新数据
            that.setData( {
                userInfo: userInfo
            })
        })
    },
    onShow:function(){
        var c = 1;
    }
})
