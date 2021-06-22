#import "MyJSBridge.h"
#import "AppDelegate.h"
#import <conchRuntime.h>
#import "SDKManager.h"
#include "LocationManager.h"
#import "WeChatManger.h"
#import "iap/IAPManager.h"
#import "ViewController.h"

@implementation MyJSBridge

+(void) callBackToJs:(NSString*)strFunc param:(NSString*)param{
    [[conchRuntime GetIOSConchRuntime] callbackToJSWithClassName:NSStringFromClass(self.class) methodName:strFunc ret:param];
}
+(void) callRunJs:(NSString*)strCode{
    [[conchRuntime GetIOSConchRuntime] runJS:strCode];
}

+(void)quitApp
{
    exit(0);
}

//打开网页
+(void)openWebView:(NSString*)strUrl
{
    NSURL* nsUrl = [NSURL URLWithString:strUrl];
    [[UIApplication sharedApplication] openURL:nsUrl];
}

//是否从其它界面切换回app
+(void)isWindowFocus:(bool)bFouce
{
    if(bFouce)
    {
        [[LocationManager getInstance] startUpdatingLocation];
        [self callRunJs:@"if(window.Laya && Laya.Browser && Laya.Browser.window.onWindowFouceChange)Laya.Browser.window.onWindowFouceChange(true);"];
    }
    else
    {
        [self callRunJs:@"if(window.Laya && Laya.Browser && Laya.Browser.window.onWindowFouceChange)Laya.Browser.window.onWindowFouceChange(false);"];
    }
}

//获取url上的参数
+(void)getIntentQuery
{
    NSString* strQuery =  [[SDKManager getInstance] infoFromWxOnLaunch]; //先取微信端启动app带过来的数据
    if(strQuery.length < 1) strQuery = [[SDKManager getInstance] intnetquery];//再去取链接上的
    if(strQuery.length < 1) strQuery = [[SDKManager getInstance] getPastedBoardString]; //最后取剪切板上的数据
    [self callBackToJs:@"getIntentQuery" param:strQuery];
    [[SDKManager getInstance] clearPastedAndQuery]; //用完就清除
}

//添加内容到剪贴板
+(void)doCopyStringToPasteboard:(NSString*)strUrl
{
   
}

//获取手机信息
+(void)getPhoneInfo
{
    
}

//获取地理位置信息
+(void)getLocationData
{
  
}

//获取手机电量
+(void)getPhoneBatteryLevel
{
    
}

//是否安装微信
+(void)isInstalledWx
{
    
}

//微信登录
+(void)wxLogin:(NSString*) jsonParam
{
    [WeChatManger weChatLogin];
}

//微信分享
+(void)wxShare:(NSString*) jsonParam
{
    [WeChatManger weChatShare :jsonParam];
}

//微信登录回调
+(void)wxLoginCallBack:(int)act code:(NSString*)code tip:(NSString*)tip
{
    NSString *strBack = [NSString stringWithFormat:@"{\"act\": %d,\"code\":\"%@\", \"tip\":\"%@\"}",act, code,tip];
    [self callBackToJs:@"wxLogin:" param:strBack];
}

//微信分享回调
+(void)wxShareCallBack:(int)act tip:(NSString*)tip
{
    NSString *strBack = [NSString stringWithFormat:@"{\"act\": %d, \"tip\":\"%@\"}",act,tip];
    [self callBackToJs:@"wxShare:" param:strBack];
}

//开始录音
+(void)startRecord
{
    
}

//结束录音
+(void)stopRecord
{
    
}

//上传音频
+(void)uploadVoice:(NSString*)jsonParam
{
    
}

//上传音频回调
+(void)uploadVoiceCallBack:(NSNumber*)frtn path:(NSString*)path{
    
}


//苹果内购
+(void)doIosZF:(NSString*)jsonParam
{
    
}

+(void)iosPayCallBack:(NSInteger)p_iRet reason:(NSString *)p_pReason receipt:(NSString *)p_pReceipt orderid:(NSString *)p_pOrderid
{
    
}

+(void)finishIosZF
{
    
}

+(void)retryIosZF
{
    
}

+(void)getAppVersion
{
    
}

+(void)reportError:(NSString*)jsonParam
{
    
}

//注册电量监听
+(void)registerBatteryElectricity
{
    
    
}

//移除电量监听
+(void)unregisterBatteryElectricity
{
    
}

//获取网络信号信息
+(void)getNetWorkInfo
{
    
}

//配置7鱼客服用户数据
+(void)config7YuService:(NSString*)jsonParam
{
    
}

//显示7鱼客服页面
+(void)show7YuService:(NSString*)userName
{
    
}

//检测更新app版本
+(void)updateAppVersion
{
    
}

//保存图片到相册
+(void)saveImageToPhotoAlbum:(NSString*)strImageData
{
    
}

//跳转到系统设置页面
+(void)jumpToSystemSettingPage
{
    
}

@end


