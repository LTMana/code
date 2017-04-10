
// var jq = require('./jquery-3.2.0.slim.min.js')

// console.log(jq)
// function want() {
//     console.log('想要执行的代码');
// }

// function fn(want) {
//     // 将想要执行的代码放入队列中，根据事件循环的机制，我们就不用非得将它放到最后面了，由你自由选择
//     //want && setTimeout(want,0);
//     console.log('这里表示执行了一大堆各种代码');

//     return new Promise(function (resolve, reject) {

//         if (typeof want === 'function') {
//             resolve(want)
//         } else {
//             reject('TypeError' + want + '不是一个函数')
//         }
//     })
//     //常规执行方法
//     //want && typeof want ==='function' && want()
// }



// fn(want).then(function (dd) {
//     dd();
// })

// fn('ddd').catch(function (err) {
//     console.log(err)
// })


// function fn1(num) {

//     return new Promise(function (resolve, reject) {
//             if (typeof num == 'number') {
//                 resolve();
//             } else {
//                 reject();
//             }
//         })
//         .then(function () {
//             console.log('参数是一个number值');
//         })
//         .then(null, function () {
//             console.log('参数不是一个number值');
//         }) //写法等同于catch

// }

// fn1(2)


// function fn2(num) {

//     return new Promise(function (resolve, reject) {
//         if (typeof num == 'number') {
//             resolve(num);
//         } else {
//             reject('TypeError');
//         }
//     })

// }


// fn2(2).then(function (num) {

//         console.log('first:' + num)

//         return num + 1

//     }).then(function (num) {
//         console.log('second: ' + num);
//         return num + 1;
//     })
//     .then(function (num) {
//         console.log('third: ' + num);
//         return num + 1;
//     });


 var url = 'https://hq.tigerbrokers.com/fundamental/finance_calendar/getType/2017-02-26/2017-06-10'

 function getJSON(url) {
    return new Promise((resolve, reject)=> {
        var XHR = new XMLHttpRequest();
        XHR.open('GET', url, true);
        XHR.send();

        XHR.onreadystatechange = function() {
            if (XHR.readyState == 4) {
                if (XHR.status == 200) {
                    try {
                        var response = JSON.parse(XHR.responseText);
                        resolve(response);
                    } catch (e) {
                        reject(e);
                    }
                } else {
                    reject(new Error(XHR.statusText));
                }
            }
        }
    })
}

// getJSON(url).then(resp => console.log(resp));


var url = 'https://hq.tigerbrokers.com/fundamental/finance_calendar/getType/2017-02-26/2017-06-10';
var url1 = 'https://hq.tigerbrokers.com/fundamental/finance_calendar/getType/2017-03-26/2017-06-10';
 
function renderAll() {
    return Promise.all([getJSON(url), getJSON(url1)]);
}

function renderRace() {
    return Promise.race([getJSON(url), getJSON(url1)]);
}

 
renderAll().then(value=>console.log(value))
renderRace().then(value=>console.log(value))