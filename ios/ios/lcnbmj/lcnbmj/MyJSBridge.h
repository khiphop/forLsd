#import <Foundation/NSObject.h>

@interface MyJSBridge: NSObject

+(void)callBackToJs:(NSString*)strFunc param:(NSString*)param;
+(void)callRunJs:(NSString*)strCode;

+(void)quitApp;
+(void)openWebView:(NSString*)strUrl;//打开网页
+(void)isWindowFocus:(bool)bFouce;//是否从其它界面切换回app
+(void)getIntentQuery; //获取url上的参数
+(void)doCopyStringToPasteboard:(NSString*)strUrl;//添加内容到剪贴板
+(void)getPhoneInfo;//获取手机信息
+(void)getLocationData;//获取地理位置信息
+(void)isInstalledWx;//是否安装微信
+(void)wxLogin:(NSString*) jsonParam;//微信登录
+(void)wxShare:(NSString*) jsonParam;//微信分享
+(void)wxLoginCallBack:(int)act code:(NSString*)code tip:(NSString*)tip; //微信登录回调
+(void)wxShareCallBack:(int)act tip:(NSString*)tip;//微信分享回调
+(void)startRecord;//开始录音
+(void)stopRecord;//结束录音
+(void)uploadVoice:(NSString*)jsonParam;//上传音频
+(void)uploadVoiceCallBack:(NSNumber*)frtn path:(NSString*)path;//上传音频回调
+(void)doIosZF:(NSString*)jsonParam;
+(void)iosPayCallBack:(NSInteger)p_iRet reason:(NSString *)p_pReason receipt:(NSString *)p_pReceipt orderid:(NSString *)p_pOrderid;
+(void)finishIosZF;
+(void)retryIosZF;
+(void)reportError:(NSString*)jsonParam;//报告错误信息到fundebug
+(void)getAppVersion;//获取app的版本号
+(void)registerBatteryElectricity;//注册电量监听
+(void)unregisterBatteryElectricity;//移除电量监听
+(void)getNetWorkInfo;//获取网络信号信息
+(void)config7YuService:(NSString*)jsonParam;//配置7鱼客服用户数据
+(void)show7YuService:(NSString*)userName;//显示7鱼客服页面
+(void)saveImageToPhotoAlbum:(NSString*)strImageData;//保存图片到相册
+(void)jumpToSystemSettingPage;//跳转到系统设置页面
@end
