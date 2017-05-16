//index.js
//获取应用实例
var app = getApp()
Page({
  data: {
    motto: 'Hello World',
    userInfo: {}
  },
  onLoad() {
    
    function validator(target, validator) {
      return new Proxy(target, {
        _validator: validator,
        set(target, key, value, proxy) {
          if (target.hasOwnProperty(key)) {
            let va = this._validator[key]
            console.log('va',va)
            console.log('key',key)
            console.log('value',value)
            if (va(value)) {
              return Reflect.set(target, key, value, proxy)
            } else {
              throw Error(`不能设置${key}到${value}`)
            }
          } else {
            throw Error(`${key}不存在`)
          }
        }
      })
    }


    const personValidators = {
      name(val) {
        return typeof val === 'string'
      },
      age(val) {
        return typeof val === 'number' && val > 18
      }
    }

    class Preson {
      constructor(name, age) {
        this.name = name
        this.age = age
        return validator(this, personValidators)
      }
    }

   const person = new Preson('ddd',12,'dfds')
   person.dd = 'dfd'
   //person.name = 27




  }
})