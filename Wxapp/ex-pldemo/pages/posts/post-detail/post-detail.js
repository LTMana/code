
var postsData = require('../../../data/posts-data.js')


var app = getApp()
Page({
    data: {
        musicImg: {},
        music: null,
        postData: null,
        isPlayingMusic: false,
        collected: false,
        currentPostId: -1
    },

    onLoad: function (options) {

        this.data.currentPostId = options.id;

        var that = this;
        var posts = postsData.postList;

        //onLoad里如果是同步方法，则不需要setData
        this.data.postData = posts[options.id];

        var postsCollected = wx.getStorageSync("posts_collected");
        if (postsCollected) {
            if (postsCollected[options.id]) {
                this.setData({
                    collected: postsCollected[options.id]
                })
            }
        }
        else {
            postsCollected = {};
            postsCollected[options.id] = false;
            wx.setStorageSync('posts_collected', postsCollected);
        }
    },

    //事件处理函数
    onMusicTap: function (event) {
        var that = this;
        if (that.data.isPlayingMusic) {
            wx.pauseBackgroundAudio();
            that.setData({
                isPlayingMusic: false
            })
        }
        else {
            var currentPostId = this.data.currentPostId
            var posts = postsData.postList
            console.log(posts[currentPostId].music.coverImg)

            wx.playBackgroundAudio({
                // 一定要确保这个歌曲可以播放，否则会出bug，整个项目会死掉
                dataUrl: posts[currentPostId].music.url,
                title: posts[currentPostId].music.title,
                coverImgUrl: posts[currentPostId].music.coverImg,

                success: function () {
                    that.setData({
                        isPlayingMusic: true
                    })

                },
                complete: function () {
                    wx.onBackgroundAudioPlay(function (event) {
                        that.setData({
                            isPlayingMusic: true
                        })
                    })

                    wx.onBackgroundAudioPause(function (event) {
                        that.setData({
                            isPlayingMusic: false
                        })
                    })
                }
            });
        }
    },

    onReady: function () {
        wx.setNavigationBarTitle({
            title: '阅读'
        });
    },

    onCollectionTap: function (event) {
        this.getPostsCollectedSync();
    },



    // getStorage的同步写法
    getPostsCollectedSync: function () {
        var postsCollected = wx.getStorageSync("posts_collected");
        if (postsCollected) {
            postsCollected[this.data.currentPostId] = !postsCollected[this.data.currentPostId]
        }
        else {
            postsCollected[this.data.currentPostId] = true;
        }
        this.setData({
            "collected": postsCollected[this.data.currentPostId]
        })
        wx.setStorageSync("posts_collected", postsCollected);
        wx.setStorageSync("posts_collected", postsCollected);
        wx.showToast({
            title: this.data.collected ? "收藏成功" : "取消成功",
            duration: 1000,
            icon: "success"
        })
    },

    // getStorage的异步写法
    onCollecgetPostsCollectedAsy: function () {
        var that = this;
        wx.getStorage({
            key: 'posts_collected',
            success: function (res) {
                var postsCollected = res.data;
                if (postsCollected) {
                    postsCollected[that.data.currentPostId] = !postsCollected[that.data.currentPostId]
                }
                else {
                    postsCollected = {}
                    postsCollected[that.data.currentPostId] = true;
                }
                that.setData({
                    "collected": postsCollected[that.data.currentPostId]
                })
                wx.setStorageSync("posts_collected", postsCollected);
                wx.showToast({
                    title: that.data.collected ? "收藏成功" : "取消成功",
                    duration: 1000,
                    icon: "success"
                })
            },
            fail: function (e) {
                wx.showToast({
                    title: "收藏失败",
                    duration: 1000
                })
            },
            complete: function () {
                // complete
            }
        })
    },

    onShareTap: function (event) {
        wx.showActionSheet({
            //数组最大值为为6
            itemList: [
                "微信好友",
                "微博好友",
                "朋友圈",
                "QQ"
            ],
            itemColor: "#1F4BA5",
            success: function (res) {
                //res.cancel  res.tapIndex
                wx.showModal({
                    title: "分享到" + res.tapIndex + "号",
                    content: "小程序做不到分享，微信什么时候给这个接口？"
                })
            }
        })
    }
})
