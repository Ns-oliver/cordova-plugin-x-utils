var exec = require('cordova/exec');

let Utils = {

    /**
     *  JS与原生交互工具
     * @param funcName 调用原生方法名
     * @param args JS传递给原生参数
     * @param success 原生回调成功函数
     * @param failed 原生回调失败函数
     */
    execNative:(funcName, args, success, failed)=>{
        exec(success, failed, "CDVUtils", funcName, args);
    }
}

module.exports = Utils;
