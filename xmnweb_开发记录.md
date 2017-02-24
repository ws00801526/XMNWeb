### XMNWeb 开发记录

1. 只支持iOS8+系统, 目前使用了WKWebView 进行网页展示
2. 支持NSHTTPCookie 本地读取,使用,方便讲NSHTTPCookie 配置到WKWebView中
3. 支持全局配置WKWebView相关的 请求超时时间,请求同步定义
4. 支持WebController 上展示加载进度条, 可配置进度条颜色
5. 支持JSBridge, 支持JSBridge回调, 支持使用JSAction 进行拓展


#### XMNWeb/Core 模块

提供基础的XMNWebController模块

生成` XMNWebController`


#### XMNWeb/Bridge 模块

提供JS 与 原生间交互功能, 利用`XMNJSBridgeAction`进行拓展

主要利用了WKWebView执行JS方法的核心功能完成交互

``` 

// 初始化方法, 提供config参数, 原生读取文本后,拼接上config参数

(function(config) {

    config = config || {};


    //执行内部初始化方法, 提供root, factory两个参数
    (function(root, factory) {
        //从配置中 读取interface 名称
        var interface = config["interface"];
        if (interface && !root[interface]) {
            root[interface] = factory();

            //添加readyEvent事件完成监听, 主要用于UIWebView无法知道 mainFrame什么时候渲染完成
            //UIWebView需要监听到此方法后 配置Bridge
            var eventName = config["readyEvent"];
            var document = root['document'];
            if (eventName && document) {
                var readyEvent = document.createEvent('Events');
                readyEvent.initEvent(eventName);
                document.dispatchEvent(readyEvent);
            }
        }
    }(this, function() {

        //用来存储callback方法
        var _callbacks = [];
        //callback方法对应的key值
        var _callbackIndex = 1000;
        //消息队列, js调用invoke方法后, 先存储到_messageQueue队列中, 等待原生调用_messageQueue方法从队列中去除
        var _messageQueue = [];
        //原生需要监听的invoke scheme ,原生需要监听此链接
        var _invokeScheme = config['invokeScheme'];

        var Bridge = {

            //为window提供invoke方法, 
            /**
             * 为window提供invoke方法
             * @param  {[String]}   name     [invoke action名称,在元素中会被解析成XMNJSBridgeMessage.action]
             * @param  {[JSONObject]}   params   [参数,在原生中会被解析成XMNJSBridgeMessage.paramaters]
             * @param  {Function} callback [回调方法, 存储在_callbacks数组中,等待原生回调]
             */
            invoke: function(name, params, callback) {

                //校验, name 必须是string 类型
                if (typeof name !== 'string') {
                    return;
                }
                //
                if (!params) {
                    params = {};
                }
                //获取callback存储key
                var callbackID = (_callbackIndex++).toString();

                if (callback) {
                    //存储callback
                    _callbacks[callbackID] = callback;
                }


                var message = {
                    action: name,
                    params: params,
                    callback_id: callbackID
                }
                //存储mesage 
                _messageQueue.push(message);
                //执行invoke scheme
                location.href = _invokeScheme;
            },

            _messageQueue: function() {
                //将_messageQueue转换成字符串, 传递给原生
                var ret = JSON.stringify(_messageQueue);
                _messageQueue = [];
                return ret;
            },

            /**
             * [_handleMessage 提供给原生进行回调]
             * @param  {[type]} message [对应的message]
             * @return {[type]}         [description]
             */
            _handleMessage: function(message) {
                if (!message) {
                    return;
                }
                var callbackID = message.callback_id;
                if (!callbackID) {
                    return;
                }

                var callback = _callbacks[callbackID];

                if (callback) {
                    var params = message.params;
                    var success = !message.failed;

                    callback(params, success);
                }
            }
        };

        return Bridge;
    }));
})
```

