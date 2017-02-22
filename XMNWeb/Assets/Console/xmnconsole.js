 (function (config) {
  
  window.__WeiboDebugConsole = {
  stringifyObject: function(object) {
  
  return window.pretty(object);
  }
  };
  
  if (!window.console) return;
  function isNumber(n) {
  return !isNaN(parseFloat(n)) && isFinite(n);
  }
  function __logWithParams(params) {
  var interfaceName = config && config['bridge'];
  if (interfaceName && window[interfaceName]) {
  window[interfaceName].invoke('privateConsoleLog', params);
  }
  }
  function __updateParams(params, error) {
  var stack = error.stack;
  do {
  if (!stack.length) break;
  
  var caller = stack.split("\n")[1];
  
  if (!caller) break;
  
  var info = caller;
  
  var at_index = caller.indexOf("@");
  
  if (at_index < 0 || at_index + 1 >= caller.length) {
  info = caller;
  } else {
  info = caller.substring(at_index + 1, caller.length);
  }
  
  // catch errors
  (function () {
   
   window.addEventListener('error', function (event) {
                           var params = {
                           'func': 'error',
                           'args': [event.message],
                           'file': event.filename,
                           'colno': event.colno,
                           'lineno': event.lineno,
                           };
                           __logWithParams(params);
                           });
   }());
  })
