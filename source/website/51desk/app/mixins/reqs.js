var sysval=require("../data/SystemValue");

var HOST=sysval.host;
var AJAX=function(config){
	if (!config.url) {
        return;
    }
    config.url=HOST+config.url;
    if (!config.type) {
    	config.type="POST";
    }
    if (!config.method) {
        config.method = true;
    }
    if(!config.accept){
    	config.accept="json";
    }
    var xmlhttp = initXMLhttp();
    xmlhttp.onreadystatechange = function() {
        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
            if (config.success) {
            	var resp= xmlhttp.responseText;
            	resp= (config.accept == "json") ? JSON.parse(resp) : resp;
                config.success(resp, xmlhttp.readyState);
            }
        }
    }
    var sendString = [],
        sendData = config.data;
    if( typeof sendData === "string" ){
        var tmpArr = String.prototype.split.call(sendData,'&');
        for(var i = 0, j = tmpArr.length; i < j; i++){
            var datum = tmpArr[i].split('=');
            sendString.push(encodeURIComponent(datum[0]) + "=" + encodeURIComponent(datum[1]));
        }
    }else if( typeof sendData === 'object' && !( sendData instanceof String || (FormData && sendData instanceof FormData) ) ){
        for (var k in sendData) {
            var datum = sendData[k];
            if( Object.prototype.toString.call(datum) == "[object Array]" ){
                for(var i = 0, j = datum.length; i < j; i++) {
                        sendString.push(encodeURIComponent(k) + "[]=" + encodeURIComponent(datum[i]));
                }
            }else{
                sendString.push(encodeURIComponent(k) + "=" + encodeURIComponent(datum));
            }
        }
    }
    sendString = sendString.join('&');
    if (config.type == "GET") {
        xmlhttp.open("GET", config.url + "?" + sendString, config.method);
        xmlhttp.send();
    }
    if (config.type == "POST") {
        xmlhttp.open("POST", config.url, config.method);
        xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        xmlhttp.send(sendString);
    }
}
function initXMLhttp() {

    var xmlhttp;
    if (window.XMLHttpRequest) {
        //code for IE7,firefox chrome and above
        xmlhttp = new XMLHttpRequest();
    } else {
        //code for Internet Explorer
        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
    }

    return xmlhttp;
}
module.exports=AJAX;
