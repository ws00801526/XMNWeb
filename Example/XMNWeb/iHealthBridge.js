(function(config) {
	window.iHealthBridge = {

		/*获取当前app版本*/
		app_version: config['version'],
		/*获取当前app名称*/
		app_name: config['name'],
		/*获取当前app的平台*/
		app_platform: config['platform'],

		/*打开一个新的webView 加载url*/
		/**
		 * [goWebView 打开一个新的webView 加载url]
		 * @param  {[String]}   url      [需要加载的URL地址]
		 * @param  {[JSONObject or JSONString]}   param    [相关配置]
		 *                         				destory : 是否销毁当前界面
		 * @param  {Function} callback [回调方法]
		 */
		goWebView: function(url, param, callback) {

			var p = this.__parseParam(param);
			p['mode'] = 0;
			p['url'] = url;
			window.XMNJSBridge.invoke('URLRoute', p, callback);
		},


		/**
		 * [goBack 关闭webView方法]
		 * @param  {[JSONObject or JSONString]}   param    [配置]
		 * 		 needRefresh : 是否需要刷新界面			  默认0
		 *       inweb	:  是否只在当前web中检索历史记录  默认0
		 * @param  {Function} callback [回调方法]
		 */
		goBack: function(param, callback) {

			var p = this.__parseParam(param);
			p['mode'] = 1;
			window.XMNJSBridge.invoke('URLRoute', p, callback);
		},

		/**
		 * [goHistory 调用原生功能, 进行回退功能]
		 * @param  {[Object or JSONString]}   param    [跳转配置包含下列参数]
		 *         url : 需要回调的url 路径				  必传		如果不传 此方法 = goBack
		 *         needRefresh : 是否需要刷新界面			  默认0
		 *         inweb	:  是否只在当前web中检索历史记录  默认0
		 *         
		 * @param  {Function} callback [回调方法]
		 */
        goHistory:function(param, callback) {

			var p = this.__parseParam(param);
			p['mode'] = 2;
			window.XMNJSBridge.invoke('URLRoute', p, callback);
 		},
		
		goLogin: function(param, callback) {

			var p = this.__parseParam(param);
			p['mode'] = 3;
			window.XMNJSBridge.invoke('URLRoute', p, callback);
		},

		__parseParam: function(param) {

			if (param == null) {
				return {}
			}

			if (typeof(param) === 'string') {
				return JSON.parse(param);
			}

			return param;
		}
	};
})
