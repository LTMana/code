function GetDateStr(AddDayCount) { 
var dd = new Date(); 
dd.setDate(dd.getDate()+AddDayCount);//获取AddDayCount天后的日期 
var y = dd.getFullYear(); 
var m = dd.getMonth()+1;//获取当前月份的日期 
var d = dd.getDate(); 
return y+"-"+m+"-"+d; 
} 

console.log("前天："+GetDateStr(-2)); 
console.log("<br />昨天："+GetDateStr(16)); 
console.log("<br />今天："+GetDateStr(0)); 
console.log("<br />明天："+GetDateStr(1)); 
console.log("<br />后天："+GetDateStr(2)); 
console.log("<br />大后天："+GetDateStr(3)); 