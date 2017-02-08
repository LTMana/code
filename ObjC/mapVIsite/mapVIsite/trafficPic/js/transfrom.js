/**
 * 思路 1、通过宽高初始化界面结构。 2、创建轮播图IMG对象，此时用空白图片把IMG撑起来，并保存IMG对象。显示正在加载进度条。
 * 3、对本地存储进行逻辑处理，并跳转到上次显示的简图位置，记录当前图像位置。 4、开始定时刷新定时器。 5、每次跳转轮播图时，记录当前图像位置。
 */
var REQAROUNDURL = "http://mobile.trafficeye.com.cn:8000/api/v4/combinedPage";
var paramDemo = '{"area":[{"city":"北京","city_code":"110000","route_id":"0010_103_001","route_name":"全市路况","timep":""},{"city":"北京","city_code":"110000","route_id":"0010_106_016","route_name":"奥体森林公园-安立路","timep":""},{"city":"北京","city_code":"110000","route_id":"0010_106_004","route_name":"北师大周边","timep":"","isLocal":0},{"city":"北京","city_code":"110000","route_id":"0010_106_015","route_name":"北苑路","timep":""},{"city":"北京","city_code":"110000","route_id":"0010_106_023","route_name":"北京奥体中心","timep":""},{"city":"北京","city_code":"110000","route_id":"0010_106_021","route_name":"保福寺","timep":""},{"city":"北京","city_code":"110000","route_id":"0010_106_020","route_name":"巴沟","timep":""},{"city":"北京","city_code":"110000","route_id":"0010_106_017","route_name":"北沙滩","timep":""},{"city":"北京","city_code":"110000","route_id":"0010_106_027","route_name":"白石桥-甘家口","timep":""}],"width":320,"height":460,"density":"2.0","url":"http://mobile.trafficeye.com.cn:8088/GraphicService_trafficeye/v1/getPic/","lon":"116.37313","lat":"39.835876","isLocal":"0"}';
var REQTIMESTAMPURL = "https://mobile.trafficeye.com.cn:18088/V4GraphicService_trafficeye/getPic";
var REQPICURL = "https://newte.trafficeye.com.cn/TEGateway/c15550d9b28d2497197ac8cd6df385ec/Graphic/?bizcode=TRAFFICEYE";
var newIntence = "http://newte.sh.1251225243.clb.myqcloud.com/TEGateway/123456/GraphicbyGeo.xml/?bizcode=TRAFFICEYE&geofilter=1&radius=3000&customerid=trafficeye&version=1401&sort=1";
var newInnt = "http://newte.sh.1251225243.clb.myqcloud.com/TEGateway/c15550d9b28d2497197ac8cd6df385ec/GraphicbyGeo.xml/?bizcode=TRAFFICEYE&geofilter=1&pos={position}&radius=3000&sort=1&customerid=trafficeye&version=1401";
// 上bar和下bar的高度之和
var imgOffsetW = 20;
var imgOffsetH = 0;
var slideNum = 0;
var clickslideNum = 0;
var currentLon, currentLlat;
var click = 0;
var isLocal = "1";
var localStore = window.localStorage, undefinedType = void 0,

// 判断浏览器是否支持本地存储
isEnableStore = "localStorage" in window && localStore !== null
		&& localStore !== undefinedType;
var ARRORALL = "show_arround_flag";
var LUNINDEX = "LunIndex";
var STOREKEY = "traffic_jiantu";
var CLICKFLAG = "clickflag";
// 交通简图容器元素对象
var trafficContainerElem = document.getElementById("trafficContainer");
// 交通简图容器背景图片元素对象
var trafficBgImgElem = document.getElementById("trafficBgImg");
// 轮播图视口容器元素对象
var mySwipeElem = document.getElementById("mySwipe");
// 轮播图列表容器元素对象
var indexConElem = $("#indexCon");
// 轮播图焦点列表容器元素对象
var tabNavElem = $("#tabNav");
// 根据不同的areaKey，保存相关城市区域的信息
var areas = {};
var temp_areaKey = "";
var save_areaKey = "";
var cityCodes = [];
// 保存设备信息
var deviceInfo = {};
var inited = false;
// 城市区域类
function area() {
	this.city = "";
	this.cityCode = "";
	this.routeId = "";
	this.routeName = "";
	// 与area对象一一对应的唯一ID，并以键值对的形式存放在areas对象中。
	this.key = "";
	// 与轮播焦点一一对应的下标，起始点是0。
	this.tabIndex = 0;
	// 简图相关元素对象ID集合
	this.elemIds = [];
	this.elems = {};
	// isLoaded为true时：表示加载完最新简图，并同步在页面上更新完时间戳。反之没有。
	this.isLoaded = false;
	this.timep = "";
	this.imageUrlPrefix = "";
};
area.prototype = {
	addActiveClass : function() {
		this.elems[this.elemIds[6]].setAttribute("class", "active");
	},
	removeActiveClass : function() {
		this.elems[this.elemIds[6]].setAttribute("class", "");
	},
	/**
	 * 根据时间戳判断，是否处置标志位。
	 * 
	 * @param {String}
	 *            timep
	 */
	resetIsLoadedByTimep : function(timep) {
		if (timep && this.timep != timep) {
			this.timep = timep;
			this.isLoaded = false;
		}
	},
	loadImage : function() {
		var x2js = new X2JS();
		var me = this;
		if (!me.isLoaded) {
			var flag1 = getFlag();
			var areaKey = getAreaKey();
			var area;
			if (areaKey && areas[areaKey]) {
				area = areas[areaKey];
			}
			var imageUrl;// = me.imageUrlPrefix + "&timep=" + getDateTime();
			// if (flag1 == "imgCity" || !flag1) {
			if (flag1 == "imgLonlat" && area.routeName == "全市路况"&&isLocal=="1") {
				// alert("加载周边简图");

//				var inData = {};
//
//				inData.citycode = area.cityCode;
//				inData.lon = 116.37313;
//				inData.lat = 39.835876;
//				var sdasda = REQTIMESTAMPURL + "&pos=" + inData.lat + ","
//						+ inData.lon// bulidSendUrl("combinedPage", inData);
//				sdasda = newInnt.replace("{position}", inData.lat + ","
//						+ inData.lon);
				var sdasda = REQTIMESTAMPURL + "?lat=" + currentLat + "&lon="
						+ currentLon;
				// sdasda = "js/simplePic.xml"
				console.log(sdasda);

				var url = "";
				var timepElemInx = this.elemIds[2];
				var imgElemInx = this.elemIds[4];
				var loadingElemInx = this.elemIds[5];
				$
						.ajax({
							type : 'get',
							url : sdasda,
							dataType : 'jsonp',
							success : function(data) {
								imageUrl=data.url;
                              
                              if(data.code == "160006"){
                              alert("当前位置无周边简图");
                              }
                              
                                console.log(imageUrl);
								imageUrl = imageUrl.replace("{token}",
										"simplePic")
								var timepElem = me.elems[timepElemInx];
								var imgElem = me.elems[imgElemInx];
								var loadingElem = me.elems[loadingElemInx];
								timepElem.innerHTML = "---";
								imgElem.style.display = "none";
								loadingElem.style.display = "";
								var image = new Image();
								image.onload = function() {
									me.isLoaded = true;
									imgElem.src = imageUrl;
									// alert(imageUrl);
									imgElem.style.display = "";
									loadingElem.style.display = "none";
									timepElem.innerHTML = me.timep;
									imageUrl = null;
									image.onload = null;
									image.onerror = null;
									image = null;
								};
								image.onerror = function() {
									me.isLoaded = false;
									imageUrl = null;
									image.onload = null;
									image.onerror = null;
									image = null;
									//alert("加载简图失败");
								};
								image.src = imageUrl;
								// alert(imageUrl);

							},
							error : function(xmlHttpReq, textStatus,
									errorThrown) {
								alert('加载数据失败!请稍后重试');
							},
						});
			}else{
				imageUrl = me.imageUrlPrefix + "&timep=" + getDateTime();
				var timepElem = me.elems[this.elemIds[2]];
				var imgElem = me.elems[this.elemIds[4]];
				var loadingElem = me.elems[this.elemIds[5]];
				timepElem.innerHTML = "---";
				imgElem.style.display = "none";
				loadingElem.style.display = "";
				var image = new Image();
				image.onload = function() {
					me.isLoaded = true;
					imgElem.src = imageUrl;
					// alert(imageUrl);
					imgElem.style.display = "";
					loadingElem.style.display = "none";
					timepElem.innerHTML = me.timep;
					imageUrl = null;
					image.onload = null;
					image.onerror = null;
					image = null;
				};
				image.onerror = function() {
					me.isLoaded = false;
					imageUrl = null;
					image.onload = null;
					image.onerror = null;
					image = null;
					// alert("加载简图失败");
				};
				image.src = imageUrl;
			}
//			if (flag1 == "imgCity" || !flag1 || flag1 == "imgLonlat"
//					&& area.routeName != "全市路况") {
//				imageUrl = me.imageUrlPrefix + "&timep=" + getDateTime();
//				var timepElem = me.elems[this.elemIds[2]];
//				var imgElem = me.elems[this.elemIds[4]];
//				var loadingElem = me.elems[this.elemIds[5]];
//				timepElem.innerHTML = "---";
//				imgElem.style.display = "none";
//				loadingElem.style.display = "";
//				var image = new Image();
//				image.onload = function() {
//					me.isLoaded = true;
//					imgElem.src = imageUrl;
//					// alert(imageUrl);
//					imgElem.style.display = "";
//					loadingElem.style.display = "none";
//					timepElem.innerHTML = me.timep;
//					imageUrl = null;
//					image.onload = null;
//					image.onerror = null;
//					image = null;
//				};
//				image.onerror = function() {
//					me.isLoaded = false;
//					imageUrl = null;
//					image.onload = null;
//					image.onerror = null;
//					image = null;
//					// alert("加载简图失败");
//				};
//				image.src = imageUrl;
//				// alert(imageUrl);
//			}

		}
	}
};

/*
 * window.onscroll = function() { window.scrollTo(0, 0) };
 */

/**
 * 返回毫秒级时间戳
 * 
 * @return {Int}
 */
function getDateTime() {
	return new Date().getTime();
};

/**
 * 通过在本地存储中保存城市区域key值，记录当前显示简图对应的城市信息
 * 
 * @param {String}
 *            key
 */
function saveAreaKey(key) {
	if (isEnableStore) {
		localStore.setItem(STOREKEY, key);
	}
};
// /**
// * 保存显示的是全市简图，还是周边简图，1_1表示全市简图_滚轮下标为1，2_2表示周边简图_滚轮下标为2
// *
// * @param key
// */
// function saveAroOrAll(key) {
// if (isEnableStore) {
// localStore.setItem(ARRORALL, key);
// }
// }
function saveLunIndex(key) {
	if (isEnableStore) {
		localStore.setItem(LUNINDEX, key);
	}
}
function getLunIndex() {
	if (isEnableStore) {
		return localStore.getItem(LUNINDEX);
	} else {
		return false;
	}
};
/**
 * 保存点击标志：imgcity:点击城市简图，imgLonlat:周边简图
 * 
 * @param imgCity
 */
function saveFlag(imgCity) {
	localStore.setItem(CLICKFLAG, imgCity);
};
function getFlag() {
	if (isEnableStore) {
		return localStore.getItem(CLICKFLAG);
	} else {
		return false;
	}
};
/**
 * 返回在本地存储中保存城市区域key值
 * 
 * @return {String/Boolean}
 */
function getAreaKey() {
	if (isEnableStore) {
		return localStore.getItem(STOREKEY);
	} else {
		return false;
	}
};
/**
 * 返回在本地存储中保存全市简图还是周边简图的标志 1_1表示全市简图_滚轮下标为1，2_2表示周边简图_滚轮下标为2
 * 
 * @return {String/Boolean}
 */
function getAroOrAllKey() {
	if (isEnableStore) {
		return localStore.getItem(ARRORALL);
	} else {
		return false;
	}
};
/**
 * 通过简图唯一ID，获取简图唯一Key
 * 
 * @param {String}
 *            routeId
 * @return {String}
 */
function generalAreaKey(routeId) {
	return "routeid_" + routeId;
};

/**
 * 添加城市区域请求结果数据
 * 
 * @param {Array}
 *            data
 */
function addAreaData(data) {
	for (var i = 0, len = data.length; i < len; i++) {
		var obj = new area();
		obj.city = data[i].city;
		obj.cityCode = data[i].city_code;
		obj.routeId = data[i].route_id;
		obj.routeName = data[i].route_name;
		var key = generalAreaKey(obj.routeId);
		obj.key = key;
		areas[key] = obj;
		cityCodes.push(data[i].city_code);
	}
};

/**
 * 通过传输简图信息初始化简图界面
 * 
 * @param {String}
 *            param JSON字符串
 */
function initByParam(param) {
    console.log("transfromjs" + param);
	if (param) {
		// JSON字符串对象化
		var paramObj = $.parseJSON(param);
		if (paramObj) {
			var areaData = paramObj.area;
			var width = paramObj.width;
			var height = document.body.clientHeight - 45 || paramObj.height;
			var pixelRatio = paramObj.density || 1;
			currentLon = paramObj.lon;
			currentLat = paramObj.lat;
			isLocal = paramObj.isLocal;
			if (areaData && areaData.length > 0) {
				setContainer(width, height);
				deviceInfo["width"] = width;
				deviceInfo["height"] = height;
				deviceInfo["density"] = pixelRatio;
				addAreaData(areaData);

				initHtml(areas, deviceInfo, areaData);

				initEvents();
				initSwipe();
				inited = true;
				getTime();
				startTimer();
				bindLi();
			}
		}
	}
};

/**
 * 设置容器大小
 * 
 * @param {Int}
 *            width
 * @param {Int}
 *            height
 */
function setContainer(width, height) {
	var trafficContainerW = width || 320;
	var trafficContainerH = height || 360;
	trafficContainerElem.style.width = trafficContainerW + "px";
	trafficContainerElem.style.height = trafficContainerH + "px";
	trafficBgImgElem.style.width = trafficContainerW + "px";
	trafficBgImgElem.style.height = trafficContainerH + "px";
	trafficBgImgElem.style.display = "";
	trafficBgImgElem.style.opacity = 0;
	// mySwipeElem.style.top = -trafficContainerH + "px";
	mySwipeElem.style.top = -trafficContainerH + "px";
	deviceInfo["width"] = trafficContainerW;
	deviceInfo["height"] = trafficContainerH;
};

/**
 * 生成轮播图DOM结构HTML
 * 
 * @param {String}
 *            key 城市简图唯一ID
 * @param {String}
 *            area 城市区域名称
 * @param {String}
 *            city 城市名称
 * @param {int}
 *            imageW 简图图片宽度
 * @param {int}
 *            imageH 简图图片高度
 */
function generalHtml(key, area, city, imageW, imageH) {
	var areaElemId = "area_" + key;
	var cityElemId = "city_" + key;
	var timeElemId = "time_" + key;
	var shareElemId = "share_" + key;
	var imgElemId = "img_" + key;
	var loadingElemId = "loading_" + key;
	var liElemId = "li_" + key;

	var htmls = [];
	htmls.push("<div   class='wgay'  key='" + key + "' id='imgArea1'>");
	htmls.push("<div  class='t'>");
	htmls.push("<div style='height:30px;width:100%;'>");
    
    
	/*
	 * htmls.push("<span class='area'><strong id='" + areaElemId + "'>" + area + "</strong></span>");
	 */
	if (city == "全市路况" && isLocal == "1") {
		var flag1 = getFlag();
		if (!flag1 || flag1 == "imgCity") {
			var name = "全市路况";
			htmls
					.push("<span style=\"color:#000000\" class='area'><strong id='"
							+ cityElemId
							+ "'>"
							+ name
							+ "</strong></span></div>");
		} else {
			if (flag1 == "imgLonlat") {
				var name = "周边路况";
				htmls
						.push("<span style=\"color:#000000\" class='area'><strong id='"
								+ cityElemId
								+ "'>"
								+ name
								+ "</strong></span></div>");
			}
		}
	} else {
		htmls.push("<span style=\"color:#000000\" class='area'><strong id='"
				+ cityElemId + "'>" + city + "</strong></span></div>");
	}
	/*
	 * htmls.push("<span style=\"color:#000000\" class='area'><strong id='" +
	 * cityElemId + "'>" + city + "</strong></span></div>");
	 */
	htmls
			.push("<div class='aa'><div style='height:30px;line-height:30px;padding-left:50x;color:#000000;float:left'>发布时间：<span id ='"
					+ timeElemId + "'>---</span></div>");
	if (city == "全市路况" && isLocal == "1") {
		var flag1 = getFlag();
		if (!flag1 || flag1 == "imgCity") {
			htmls
					.push("<a class=\"button white  bigrounded\" onClick=\"showImgAroud()\" style=\"margin-right:30px;float:right\">周边路况</a>");
		} else {
			if (flag1 == "imgLonlat") {
				htmls
						.push("<a class=\"button white  bigrounded\" onClick=\"showImgCity()\"style=\"margin-right:30px;float:right\">全市路况</a>");
			}
		}

	}

	htmls.push("</div>");
	htmls.push("<div class='wimg' style='width:" + imageW + "px;height:"
			+ imageH + "px;text-align:center;'>");
	var high = imageW * 315 / 385;
	// alert("" + high);
	htmls.push("<img id='" + imgElemId
			+ "' src='images/blank.gif' style='width:" + imageW + "px;height:"
			+ high + "px;overflow:hidden;'/>");
	htmls
			.push("<b id ='"
					+ loadingElemId
					+ "'style='margin:0 auto;position:absolute;top:50%;left:30%;'>正在努力加载中...</b>");

	htmls.push("</div><div class='ly'></div>");

	var tabHtmls = [ "<li id='" + liElemId + "'></li>" ];

	return {
		html : htmls.join(""),
		tabHtml : tabHtmls.join(""),
		elemIds : [ areaElemId, cityElemId, timeElemId, shareElemId, imgElemId,
				loadingElemId, liElemId ]
	};
};
/**
 * 初始化页面结构
 * 
 * @param {Object}
 *            data 简图信息
 * @param {Object}
 *            deviceInfo 设备信息
 */
function initHtml(data, deviceInfo, areaData) {
    var index = 0;
    var imageW = deviceInfo.width - imgOffsetW;
    var imageH = deviceInfo.height - imgOffsetH;
    // var imageH=imageW*0.9;
    var density = deviceInfo.density;
    var urlSuffix = "?width=" + Math.floor(imageW * density) + "&height="
    + Math.floor(imageH * density);
    /* 获取滚动条当前位置 */
    var areaKey = getAreaKey();
    var areaKey2 = getAreaKey();
    var nowId = "routeid_" + areaData[0].route_id;
    if (!areaKey || areaKey != nowId) {
        areaKey = nowId;
    }
    if(!data[areaKey2]){
        areaKey2 = nowId;
    }
    var nowArea = data[areaKey];
    var nowAreaForhttp = data[areaKey2];
    //console.log("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm+             +areaKey: "+nowArea)
    //console.log("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm+             +areaKey: "+areaKey2)
    //console.log("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm+             +areaKey: "+nowAreaForhttp)
    sentCityName(nowAreaForhttp);
    // setBtn1Visual(nowArea);
    var inx = getAroOrAllKey();	for ( var k in data) {
		var key = k;
		var area = data[k];
		area.tabIndex = index;
		if (index == 0) {
			temp_areaKey = key;
		}
		var obj = generalHtml(key, area.city, area.routeName, imageW, imageH);
		indexConElem.append(obj.html);
		tabNavElem.append(obj.tabHtml);
		area.elemIds = obj.elemIds;
		area.elems = initElems(area.elemIds);
		index++;
		// alert("加载全市简图");
		var url1 = "";
		if (area.cityCode == "000000000") {
			url1 = REQPICURL + urlSuffix + "&no=" + area.routeId;
		} else {
			url1 = REQPICURL
					+ "&adcode="
					+ area.cityCode
					+ "&id="
					+ area.routeId
					+ "&format=png&&width=385&height=315&customerid=trafficeye&version=1501";
		}
		area.imageUrlPrefix = url1;

	}
}

/**
 * 初始化元素
 * 
 * @param {Array}
 *            elemIds 元素ID集合
 * @return {Object}
 */
function initElems(elemIds) {
	var elems = {};
	for (var i = 0, len = elemIds.length; i < len; i++) {
		var elemId = elemIds[i];
		elems[elemId] = document.getElementById(elemId);
	}
	return elems;
};

/**
 * 初始化事件监听器
 */
function initEvents() {
	for ( var key in areas) {
		var area = areas[key];
		if (area) {
			var shareElem = area.elems[area.elemIds[3]];
			if (shareElem) {
				shareElem.addEventListener("touchstart", function(evt) {
					evt.target.src = "images/icon_share_pressed.png";
				});

				shareElem.addEventListener("touchend", function(evt) {
					var elemId = evt.target.id;
					var areaKey = elemId.substring(elemId.indexOf("_") + 1,
							elemId.length);
					window.share.shareMethod(areas[areaKey].city + " "
							+ areas[areaKey].routeName);
					evt.target.src = "images/icon_share.png";
				});
			}
		}
	}
};

/**
 * 初始化轮播图
 */
function initSwipe() {

	// 延迟请求时间戳定时器
	var timer = null;
	if (isEnableStore) {
		var areaKey = getAreaKey();
		if (areaKey && areas[areaKey]) {
			slideNum = areas[areaKey].tabIndex;
		} else {
			slideNum = 0;
			saveAreaKey(temp_areaKey);
			areaKey = temp_areaKey;
		}
		if (areas[areaKey]) {
			areas[areaKey].addActiveClass();
			save_areaKey = areaKey;
		}
	}
	   console.log("当前城市名："+area.cityCode);
	    Swipe(mySwipeElem, {
		startSlide : slideNum,
		continuous : true,
		disableScroll : false,
        draggable: false,
        continuous: true,
        stopPropagation: false,
		auto : 3000,

		callback : function(index, elem) {
			console.log(index,elem);
			saveLunIndex(index);
			var key = elem.getAttribute("key");
			if (areas[save_areaKey]) {
				areas[save_areaKey].removeActiveClass();
			}
			if (areas[key]) {
				areas[key].addActiveClass();
				save_areaKey = key;
				saveAreaKey(save_areaKey);
			}

		},
		// transitionEnd用于整体轮播图动画结束后触发的回调函数
		transitionEnd : function(index, elem) {
			var key = elem.getAttribute("key");
			saveAreaKey(key);
			if (timer) {
				window.clearTimeout(timer);
				timer = null;
			}
			var area = areas[key];
			if (area.timep) {
				// 如果已记录过时间戳，表示已经加载过图幅，需要做延迟请求
				timer = setTimeout(function() {
					getTime();
				}, 30000);
			} else {
				// 如果没有记录过时间戳，表示当前简图从来没有加载过，应该及时请求
				getTime();
			}
			console.log("当前城市名：" + area.city);
			// 把当前城市名称发给webview
			sentCityName(area);
			// setBtn1Visual(area);

		}
	});
};
/**
 * 回掉函数，返回一个城市名
 */
function sentCityName(area) {
	// 把当前城市名称发给webview
	if (navigator.userAgent.match(/android/i)) {
		window.JSAndroidBridge.sendCityName(area.city);
	} else if (navigator.userAgent.match(/iphone/i)
			|| navigator.userAgent.match(/ipad/i)) {
        window.location.href = ("objc:??sendCityName::?" +area.routeId);
        
        
       	} else {
		//alert("调用修改用户信息接口,PC不支持.");
	}
}
/**
 * 获取最新简图时间戳
 */
function getTime() {
	var areaKey = getAreaKey();
	var area = areas[areaKey];
	var param = "?";
	var cityCode = area.cityCode;
	var routeId = area.routeId;
	if (cityCode == "000000000") {
		param = param + "no=" + routeId;
	} else {
		param = param + "cityId=" + cityCode + "&id=" + routeId;
	}
	var reqUrl = REQTIMESTAMPURL + param;
	// alert(reqUrl);
	$.ajax({
		url : reqUrl,
		type : 'get',
		dataType : 'jsonp',
		jsonp : 'callback',
		// timeout:3000,
		error : function(XMLHttpRequest, textStatus, errorThrown) {
			alert("网络不给力,数据请求超时！");
		},
		success : function(result) {
			// 201505271355
			// 2015-05-27 14:10:00
			var timeps = result.timestamp;
			if (timeps) {
				// 截取时分时间戳
				// var time = timeps.substring(11, 16);
				var time = timeps.substring(8, 10) + ":"
						+ timeps.substring(10, 12);
				var routeId = result.rootId;
				var key = generalAreaKey(routeId);
				var area = areas[key];
				area.resetIsLoadedByTimep(time);
				area.loadImage();
			}
		}
	});
};

function backClick() {
	window.location.href = "objc://gotoPrePage";
}// 返回
/**
 * 刷新简图信息
 */
function reflesh() {
	if (inited) {
		getTime();
	}
};

/**
 * 定时刷新简图信息
 */
function startTimer() {
	setInterval(function() {
		reflesh();
	}, 5 * 60 * 1000);
};
/**
 * 显示全市简图 当前滚轮位置 当前经纬度位置
 */
function showImgAll() {
	var ss = getLunIndex();
	if (ss) {

		saveAroOrAll("1_" + ss);
	} else {
		saveAroOrAll("1_" + 1);
	}
	location.reload();

}
// /**
// * 显示周边见图 当前滚轮位置
// */
// function showImgAroud() {
// var ss = getLunIndex();
// if (ss) {
//
// saveAroOrAll("2_" + ss);
// } else {
// saveAroOrAll("2_" + 1);
// }
// location.reload();
// }
/**
 * 生成请求地址 server请求服务 options请求参数
 */
function bulidSendUrl(server, inData) {
	var url = REQAROUNDURL;
	if (server == "adminZoneQuery") {
		url = "http://mobile.trafficeye.com.cn:8092/AdminZoneQuery_trafficeye/q";
	}
	// 个人信息

	var data = {
		"ua" : "",
		"pid" : "",
		"uid" : "",
		"lon" : inData.lon,
		"lat" : inData.lat,
		"width" : 590,
		"type" : 2,
		"code" : inData.citycode,
		"isLoc" : 0,

	};
	/*
	 * //添加服务参数 for(var k in options){ data[k] = options[k]; }
	 */
	// 格式化请求参数
	var reqParams = httpData2Str(data);
	var reqUrl = url + reqParams;
	return reqUrl;
};
/**
 * Http请求参数数据对象转换成字符串
 * 
 * @param {JSON
 *            Object} data
 */
function httpData2Str(data) {
	var strs = [ "?" ];
	if (data) {
		for ( var key in data) {
			strs.push(key + "=" + data[key] + "&");
		}
	}
	var timer = "callback=?&timer=" + getDateTime();
	strs.push(timer);
	return strs.join("");
};
/**
 * 监听li事件
 */
function bindLi() {
	$('li').on('click', function(i) {
		
		click = 1;
		clickslideNum = $(this).index();
		var i = 0;
		for ( var key in areas) {
			if (i == clickslideNum) {

				saveAreaKey(key);
				break;
			}
			i++;
		}
		saveLunIndex(clickslideNum);
		if (areas[save_areaKey]) {
			areas[save_areaKey].removeActiveClass();
		}
		if (areas[key]) {
			areas[key].addActiveClass();
			save_areaKey = key;
			saveAreaKey(save_areaKey);
		}
		location.reload();
	});
};
/**
 * 显示城市简图
 */
function showImgCity() {
	// 保存点击事件记录
	var imgCity = "imgCity";
	saveFlag(imgCity);
	var parm = "city";
	// sendRequest(parm);
	location.reload();
}
/**
 * 显示周边简图按钮
 */
function showImgAroud() {
	var imgLonlat = "imgLonlat";
	saveFlag(imgLonlat);
	var parm = "lonlat";
	// sendRequest(parm);
	location.reload();
}
/**
 * 点击城市简图或城市简图显示按钮，请求本地，要求重新给我一次请求参数
 */
function sendRequest(parm) {
	if (city) {// 把当前城市名称发给webview
		var parm = city;
		if (navigator.userAgent.match(/android/i)) {
			window.JSAndroidBridge.sendRequest(parm);
		} else if (navigator.userAgent.match(/iphone/i)
				|| navigator.userAgent.match(/ipad/i)) {
            
			window.location.href = ("objc:??sendRequest::?" + parm);
		} else {
			alert("调用修改用户信息接口,PC不支持.");
		}
	}
}
$(function() {
	initByParam(paramDemo);
	$(".t").css("color", "#181818");
	$(".wgay").css("background", "none");
});
