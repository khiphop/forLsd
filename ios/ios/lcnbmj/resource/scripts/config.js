var loadingView = (function () {
    function loadingView() {
        this.sOS = conchConfig.getOS();
        if (this.sOS == "Conch-ios") {
            this.bridge = PlatformClass.createClass("JSBridge");
        }
        else if (this.sOS == "Conch-android") {
            this.bridge = PlatformClass.createClass("demo.JSBridge");
        }
    }
    Object.defineProperty(loadingView.prototype, "loadingAutoClose", {
        get: function () {
            return this._loadingAutoClose;
        },
        set: function (value) {
            this._loadingAutoClose = value;
        },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(loadingView.prototype, "showTextInfo", {
        get: function () {
            return this._showTextInfo;
        },
        set: function (value) {
            this._showTextInfo = value;
            if (this.bridge) {
                if (this.sOS == "Conch-ios") {
                    this.bridge.call("showTextInfo:", value);
                }
                else if (this.sOS == "Conch-android") {
                    this.bridge.call("showTextInfo", value);
                }
            }
        },
        enumerable: true,
        configurable: true
    });
    loadingView.prototype.bgColor = function (value) {
        if (this.bridge) {
            if (this.sOS == "Conch-ios") {
                this.bridge.call("bgColor:", value);
            }
            else if (this.sOS == "Conch-android") {
                this.bridge.call("bgColor", value);
            }
        }
    };
    loadingView.prototype.setFontColor = function (value) {
        if (this.bridge) {
            if (this.sOS == "Conch-ios") {
                this.bridge.call("setFontColor:", value);
            }
            else if (this.sOS == "Conch-android") {
                this.bridge.call("setFontColor", value);
            }
        }
    };
    loadingView.prototype.setTips = function (value) {
        if (this.bridge) {
            if (this.sOS == "Conch-ios") {
                this.bridge.call("setTips:", value);
            }
            else if (this.sOS == "Conch-android") {
                this.bridge.call("setTips", value);
            }
        }
    };
    loadingView.prototype.loading = function (value) {
        if (this.bridge) {
            if (this.sOS == "Conch-ios") {
                this.bridge.call("loading:", value);
            }
            else if (this.sOS == "Conch-android") {
                this.bridge.call("loading", value);
            }
        }
    };
    loadingView.prototype.hideLoadingView = function () {
        this.bridge.call("hideSplash");
    };
    
    //自己的提示控件
    loadingView.prototype.showAlert = function () {
        this.bridge.call("showAlert:", "网络异常，请检查您的网络是否正常或是否开启蜂窝移动数据访问");
    };
    return loadingView;
}());

window.loadingView = new loadingView();
if(window.loadingView)
{
    //window.loadingView.hideLoadingView(); 
    window.loadingView.loadingAutoClose=false;//true代表当动画播放完毕，自动进入游戏。false为开发者手动控制
    window.loadingView.bgColor("#FFFFFF");//设置背景颜色
    window.loadingView.setFontColor("#000000");//设置字体颜色
    window.loadingView.setTips(["正在检查更新"]);
}
window.onLayaInitError=function(e)
{
	console.log("onLayaInitError error=" + e);
	//alert("加载游戏失败，可能由于您的网络不稳定，请退出重进");
    window.loadingView.showAlert();
}
