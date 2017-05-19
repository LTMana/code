'use strict'

const promise1 = new Promise((suc, err) => {

    setTimeout(function () {
        suc('dfdfdsfdsfdsfdsfsd')
    }, 2000)


})



const promise2 = promise1.then(dd => {
    console.log('1', dd)
    return new Promise((suc, err) => {
        setTimeout(function () {
            suc('wewqewqeqw')
        }, 2000)
    })
})
const promise3 = promise2.then(aa => {


    console.log('2', aa)

    return 'mmmmmmmm'




})


promise3.then(cc => {

    console.log('3', cc)
})