(function(){if(!this.require){var t={},e={},n=function(i,s){var u,a,c=o(s,i),h=o(c,"./index");if(u=e[c]||e[h])return u;if(a=t[c]||t[c=h])return u={id:c,exports:{}},e[c]=u.exports,a(u.exports,function(t){return n(t,r(c))},u),e[c]=u.exports;throw"module "+i+" not found"},o=function(t,e){var n,o,r=[];n=/^\.\.?(\/|$)/.test(e)?[t,e].join("/").split("/"):e.split("/");for(var i=0,s=n.length;s>i;i++)o=n[i],".."==o?r.pop():"."!=o&&""!=o&&r.push(o);return r.join("/")},r=function(t){return t.split("/").slice(0,-1).join("/")};this.require=function(t){return n(t,"")},this.require.define=function(e){for(var n in e)t[n]=e[n]},this.require.modules=t,this.require.cache=e}return this.require}).call(this),this.require.define({javascript_config:function(t,e,n){(function(){var t;t=function(){function t(){}return t.config=function(t,e){return t.SetIndentWidth(4),t.RegisterMatching("(",")"),t.RegisterMatching("[","]"),t.RegisterMatching("{","}"),e.getSession().setMode("ace/mode/javascript"),e.getSession().setTabSize(4),e.getSession().setUseSoftTabs(!0)},t.multiLineCallback=function(){return!1},t.webSocketUrl=function(t){return t+"/eval/javascript"},t}(),n.exports=t}).call(this)}}),this.require.define({ruby_config:function(t,e,n){(function(){var t,e,o;e=function(){function t(){}return t.config=function(t,e){return t.SetIndentWidth(2),t.RegisterMatching("(",")"),t.RegisterMatching("[","]"),t.RegisterMatching("{","}"),e.getSession().setMode("ace/mode/ruby"),e.getSession().setTabSize(2),e.getSession().setUseSoftTabs(!0)},t.multiLineCallback=function(){return!1},t.webSocketUrl=function(t){return t+"/eval/ruby"},t}(),t=["begin","module","def","class","if","unless","case","for","while","until","do"],o=/\s+|\d+(?:\.\d*)?|"(?:[^"]|\\.)*"|'(?:[^']|\\.)*'|\/(?:[^\/]|\\.)*\/|[-+\/*]|[<>=]=?|:?[a-z@$][\w?!]*|[{}()\[\]]|\.[\w\s]+|[^\w\s]+/gi,n.exports=e}).call(this)}}),this.require.define({websocket_evaulator:function(t,e,n){(function(){var t,e=function(t,e){return function(){return t.apply(e,arguments)}};t=function(){function t(t,n,o,r){var i=this;this.onReady=n,this.onMessage=o,this.onError=r,this.evaulate=e(this.evaulate,this),this.ws=new WebSocket(t),this.ws.onopen=function(){return console.info("connection opened"),i.onReady()},this.ws.onmessage=function(t){var e,n;return e=t.data?JSON.parse(t.data):{status:"error",message:"no response"},e?"ok"!==e.status?"error"===e.status?(console.error("error, event=",t),n=e.message?e.message:"Unknown error: "+t,i.failedWithMessage(n)):"info"===e.status?(console.info("server: ",e.message),i.onMessage(e.message)):(console.error("unknown error, event=",t),i.failedWithMessage("unknown error: "+t)):i.success?(i.success(e.result),i.success=null):void 0:(console.error("unexpected data format",t),i.failedWithMessage("unexpected data format: "+t))},this.ws.onclose=function(){return i.failedWithMessage("Connection closed.")},this.ws.onerror=function(t){return console.log("connection error",t),i.failedWithMessage("Connection error!")}}return t.prototype.evaulate=function(t,e,n){var o,r;return r={command:"eval",source:t},o=JSON.stringify(r),this.success=e,this.failure=n,this.ws.send(o)},t.prototype.failedWithMessage=function(t){return console.error(t),this.failure?(this.failure(t),this.failure=null):this.onError(t)},t}(),n.exports=t}).call(this)}}),this.require.define({application:function(t,e,n){(function(){var t,o,r,i,s=function(t,e){return function(){return t.apply(e,arguments)}};o=e("javascript_config"),r=e("ruby_config"),i=e("websocket_evaulator"),t=function(){function t(t,e){var n=this;this.websocketUrl=t,this.language=e,this.onError=s(this.onError,this),this.onMessage=s(this.onMessage,this),this.onReady=s(this.onReady,this),this.onInput=s(this.onInput,this),this.prompt=s(this.prompt,this),this.getConfigurator=s(this.getConfigurator,this),this.getLanguage=s(this.getLanguage,this),this.setLanguage=s(this.setLanguage,this),console.log("[ConsoleController] websocket: "+this.websocketUrl+", language="+this.language),this.jqConsole=$("#console").jqconsole("Connecting to "+t+"\n","> ",".."),this.editor=ace.edit("editor"),this.editor.commands.addCommand({name:"Evaulate",bindKey:{win:"Ctrl-Enter",mac:"Command-Enter"},exec:function(t){var e;return e=t.getValue(),n.jqConsole.Write(e+"\n","jqconsole-input"),n.onInput(e)},readOnly:!0}),this.getConfigurator().config(this.jqConsole,this.editor),this.evaulator=new i(this.getConfigurator().webSocketUrl(this.websocketUrl),this.onReady,this.onMessage,this.onError)}return t.prototype.setLanguage=function(t){return this.language=t},t.prototype.getLanguage=function(){return this.language},t.prototype.getConfigurator=function(){if("javascript"===this.language)return o;if("ruby"===this.language)return r;throw new Error("unsupported language: "+this.language)},t.prototype.prompt=function(){return this.jqConsole.Prompt(!0,this.onInput,this.getConfigurator().multiLineCallback,!1)},t.prototype.onInput=function(t){var e,n,o=this;return n=function(t){return o.onMessage(t),o.prompt()},e=function(t){return o.onError(t),o.prompt()},this.evaulator.evaulate(t,n,e)},t.prototype.onReady=function(){return this.prompt()},t.prototype.onMessage=function(t){return this.jqConsole.Write(t+"\n","jqconsole-output")},t.prototype.onError=function(t){return this.jqConsole.Write(t+"\n","jqconsole-error")},t}(),n.exports=function(){var e,n,o;return n="%%WEBSOCKET_URL%%",e="%%LANGUAGE%%",n.match("^%%WEBSOCKET_")&&(n="ws://localhost:3300"),e.match("^%%LANGUAGE")&&(e="ruby"),o=new t(n,e),o.prompt()}}).call(this)}});