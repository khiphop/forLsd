
//
//
//  sdk管理类
//
//

#include "SDKManager.h"
#import "MyJSBridge.h"
#include "LocationManager.h"
#import "AVSessionPlayer.h"
#import <conchRuntime.h>
#import "AFHTTPSessionManager.h"
#import "WeChatManger.h"
#import "alertBox/BlockUIAlertView.h"
#import "iap/IAPManager.h"
#import <sys/utsname.h>
#include "LocationManager.h"
//#import <UMCommon/UMCommon.h>


@interface SDKManager ()

@end

@implementation SDKManager

//获取实例
+ (SDKManager*) getInstance{
    static SDKManager* iap = nil;
    if (iap == nil){
        iap = [SDKManager alloc];
    }
    return iap;
}
//析构
- (void)dealloc
{
    NSLog(@">>>>>>>> SDKManager dealloc");
}

//初始化
-(instancetype)init
{
    [self initSDKAppID]; //初始化sdk的appid
    [[WeChatManger sharedManager] initSDK:_wxId]; //微信初始化
    [self initUM];
    return [super init];
}

//版本检测
- (void) initSDKAppID
{
    _pastedBoard = @"";
    _infoFromWxOnLaunch = @"";
    _appStoreId = @"1561297387";
    //_wxId = @"wxf17f504f6b31140a";
    _wxId = @"wx8ece088c88b8d7f5";
    _schemas = @"hcmj";
}

//初始化友盟
- (void) initUM
{
    //[UMConfigure initWithAppkey:@"60c974458a102159db68a962" channel:@"App Store"];
}

//初始化7鱼sdk
- (void) init7YuSdk
{
    
}

//初始化阿里云日志sdk
- (void) initAliyunLogSDK
{
    
}

//上传日志到阿里云
- (void) uploadLogToAliyun:(NSString *)logMsg
{
    
}

//检测更新
- (bool) checkUpdate
{
    return false;
}


//为了获取链接上的参数
- (BOOL)handleOpenURL:(NSURL *)url
{
    return false;
}

//为了获取链接上的参数
- (BOOL)openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return YES;
}

//清空链接参数和剪切板的缓存
-(void)clearPastedAndQuery
{

}

//设置来自微信的启动app数据
-(void)setInfoFromWxOnLaunch:(NSString*)strLaunchInfo
{
    
}

//获取剪切板上的字段
-(NSString*)getPastedBoardString
{
    return @"";
}

//获取版本号
-(int)getVersion
{
    return 0;
}

-(int) changeStringVersionToInt:(NSString*)strVersion
{
    return 0;
}

//开始录音
- (void)startRecord
{
   [[AVSessionPlayer defaultManager] recoderVoice:@"record"];
}

//停止录音
- (void)stopRecord
{
   [[AVSessionPlayer defaultManager] recoderVoiceEnd];
}

//录音成功
- (void)onRecordSucceed
{
    NSLog(@"-----录音成功！！！");
    NSString* sJs = [NSString stringWithFormat:@"onRecordSucceed();"];
    [[conchRuntime GetIOSConchRuntime] runJS:sJs];
}

//录音失败
- (void)onRecordFail:(int)nErrorID
{
    NSString* sJs = [NSString stringWithFormat:@"onRecordFail(%d);",nErrorID];
    [[conchRuntime GetIOSConchRuntime] runJS:sJs];
}

//上传音频
- (void)uploadVoice:(NSString*)strUrl gameID:(NSString*)strGameID roomUniqueCode:(NSString*)strRoomUniqueCode userID:(NSString*)strUserID
{
    
}

//苹果支付回调
- (void)onCallBack:(NSInteger)p_iRet reason:(NSString *)p_pReason retry:(Boolean)bRetry receipt:(NSString *)p_pReceipt orderid:(NSString *)p_pOrderid
{
}


//获取电量并监听电量变化
-(float)getPhoneBatteryLevelAndListen
{
    //拿到当前设备
    UIDevice * device = [UIDevice currentDevice];
    
    //是否允许监测电池
    //要想获取电池电量信息和监控电池电量 必须允许
    device.batteryMonitoringEnabled = true;
    
    //1、check
    /*
     获取电池电量
     0 .. 1.0. -1.0 if UIDeviceBatteryStateUnknown
     */
    float level = device.batteryLevel;
    NSLog(@"level = %lf",level);
    
    //2、monitor
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeBatteryLevel:) name:@"UIDeviceBatteryLevelDidChangeNotification" object:device];
    
    return level;
}

//移除电量监听
- (void)removeBatteryListen
{
    UIDevice * device = [UIDevice currentDevice];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceBatteryLevelDidChangeNotification" object:device];
}

// 电量变化
- (void)didChangeBatteryLevel:(id)sender
{
    //电池电量发生改变时调用
    UIDevice *myDevice = [UIDevice currentDevice];
    [myDevice setBatteryMonitoringEnabled:YES];
    float batteryLevel = [myDevice batteryLevel];
    
    
    //直接调用js方法更新电量
    NSString* sJs = [NSString stringWithFormat:@"if(typeof(updatePhoneBattery) == 'function')window.updatePhoneBattery(%f);",batteryLevel*100];
    NSLog(@"电池剩余比例：%@", sJs);
    [MyJSBridge callRunJs:[NSString stringWithCString:[sJs UTF8String] encoding:NSUTF8StringEncoding]];
    
}

-(bool)isIphoneX
{
    if (@available(iOS 11.0, *))
    {
        CGFloat a =  [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom;
        if(a > 0.0) return true;
    }
    return false;
}

- (NSString *)getNetworkType
{
    UIApplication *app = [UIApplication sharedApplication];
    id statusBar = nil;
    NSString *network = @"";
    if (@available(iOS 13.0, *)) {
        UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].keyWindow.windowScene.statusBarManager;
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        if ([statusBarManager respondsToSelector:@selector(createLocalStatusBar)]) {
            UIView *localStatusBar = [statusBarManager performSelector:@selector(createLocalStatusBar)];
            if ([localStatusBar respondsToSelector:@selector(statusBar)]) {
                statusBar = [localStatusBar performSelector:@selector(statusBar)];
            }
        }
#pragma clang diagnostic pop
        
        if (statusBar) {
//            UIStatusBarDataCellularEntry
            id currentData = [[statusBar valueForKeyPath:@"_statusBar"] valueForKeyPath:@"currentData"];
            id _wifiEntry = [currentData valueForKeyPath:@"wifiEntry"];
            id _cellularEntry = [currentData valueForKeyPath:@"cellularEntry"];
            if (_wifiEntry && [[_wifiEntry valueForKeyPath:@"isEnabled"] boolValue]) {
//                If wifiEntry is enabled, is WiFi.
                network = @"WIFI";
            } else if (_cellularEntry && [[_cellularEntry valueForKeyPath:@"isEnabled"] boolValue]) {
                NSNumber *type = [_cellularEntry valueForKeyPath:@"type"];
                if (type) {
                    switch (type.integerValue) {
                        case 0:
//                            无sim卡
                            network = @"NONE";
                            break;
                        case 1:
                            network = @"1G";
                            break;
                        case 4:
                            network = @"3G";
                            break;
                        case 5:
                            network = @"4G";
                            break;
                        default:
//                            默认WWAN类型
                            network = @"WWAN";
                            break;
                            }
                        }
                    }
                }
    }else {
        statusBar = [app valueForKeyPath:@"statusBar"];
        
        if ([[SDKManager getInstance] isIphoneX]) {
//            刘海屏
                id statusBarView = [statusBar valueForKeyPath:@"statusBar"];
                UIView *foregroundView = [statusBarView valueForKeyPath:@"foregroundView"];
                NSArray *subviews = [[foregroundView subviews][2] subviews];
                
                if (subviews.count == 0) {
//                    iOS 12
                    id currentData = [statusBarView valueForKeyPath:@"currentData"];
                    id wifiEntry = [currentData valueForKey:@"wifiEntry"];
                    if ([[wifiEntry valueForKey:@"_enabled"] boolValue]) {
                        network = @"WIFI";
                    }else {
//                    卡1:
                        id cellularEntry = [currentData valueForKey:@"cellularEntry"];
//                    卡2:
                        id secondaryCellularEntry = [currentData valueForKey:@"secondaryCellularEntry"];

                        if (([[cellularEntry valueForKey:@"_enabled"] boolValue]|[[secondaryCellularEntry valueForKey:@"_enabled"] boolValue]) == NO) {
//                            无卡情况
                            network = @"NONE";
                        }else {
//                            判断卡1还是卡2
                            BOOL isCardOne = [[cellularEntry valueForKey:@"_enabled"] boolValue];
                            int networkType = isCardOne ? [[cellularEntry valueForKey:@"type"] intValue] : [[secondaryCellularEntry valueForKey:@"type"] intValue];
                            switch (networkType) {
                                    case 0://无服务
                                    network = [NSString stringWithFormat:@"%@-%@", isCardOne ? @"Card 1" : @"Card 2", @"NONE"];
                                    break;
                                    case 3:
                                    network = [NSString stringWithFormat:@"%@-%@", isCardOne ? @"Card 1" : @"Card 2", @"2G/E"];
                                    break;
                                    case 4:
                                    network = [NSString stringWithFormat:@"%@-%@", isCardOne ? @"Card 1" : @"Card 2", @"3G"];
                                    break;
                                    case 5:
                                    network = [NSString stringWithFormat:@"%@-%@", isCardOne ? @"Card 1" : @"Card 2", @"4G"];
                                    break;
                                default:
                                    break;
                            }
                            
                        }
                    }
                
                }else {
                    
                    for (id subview in subviews) {
                        if ([subview isKindOfClass:NSClassFromString(@"_UIStatusBarWifiSignalView")]) {
                            network = @"WIFI";
                        }else if ([subview isKindOfClass:NSClassFromString(@"_UIStatusBarStringView")]) {
                            network = [subview valueForKeyPath:@"originalText"];
                        }
                    }
                }
                
            }else {
//                非刘海屏
                UIView *foregroundView = [statusBar valueForKeyPath:@"foregroundView"];
                NSArray *subviews = [foregroundView subviews];
                
                for (id subview in subviews) {
                    if ([subview isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
                        int networkType = [[subview valueForKeyPath:@"dataNetworkType"] intValue];
                        switch (networkType) {
                            case 0:
                                network = @"NONE";
                                break;
                            case 1:
                                network = @"2G";
                                break;
                            case 2:
                                network = @"3G";
                                break;
                            case 3:
                                network = @"4G";
                                break;
                            case 5:
                                network = @"WIFI";
                                break;
                            default:
                                break;
                        }
                    }
                }
            }
    }

    if ([network isEqualToString:@""]) {
        network = @"NO DISPLAY";
    }
    return network;
}

- (int)getSignalStrength
{
    
    int signalStrength = 0;
    if (@available(iOS 13.0, *)) {
        UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].keyWindow.windowScene.statusBarManager;
         
        id statusBar = nil;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        if ([statusBarManager respondsToSelector:@selector(createLocalStatusBar)]) {
            UIView *localStatusBar = [statusBarManager performSelector:@selector(createLocalStatusBar)];
            if ([localStatusBar respondsToSelector:@selector(statusBar)]) {
                statusBar = [localStatusBar performSelector:@selector(statusBar)];
            }
        }
#pragma clang diagnostic pop
        if (statusBar) {
            id currentData = [[statusBar valueForKeyPath:@"_statusBar"] valueForKeyPath:@"currentData"];
            id _wifiEntry = [currentData valueForKeyPath:@"wifiEntry"];
            id _cellularEntry = [currentData valueForKeyPath:@"cellularEntry"];
            if (_wifiEntry && [[_wifiEntry valueForKeyPath:@"isEnabled"] boolValue]) {
                // If wifiEntry is enabled, is WiFi.
                if ([_wifiEntry isKindOfClass:NSClassFromString(@"_UIStatusBarDataIntegerEntry")]) {
                // 层级：_UIStatusBarDataNetworkEntry、_UIStatusBarDataIntegerEntry、_UIStatusBarDataEntry
                    signalStrength = [[_wifiEntry valueForKey:@"displayValue"] intValue];
                }
            } else if (_cellularEntry && [[_cellularEntry valueForKeyPath:@"isEnabled"] boolValue]) {
                if ([_cellularEntry isKindOfClass:NSClassFromString(@"_UIStatusBarDataIntegerEntry")]) {
                // 层级：_UIStatusBarDataNetworkEntry、_UIStatusBarDataIntegerEntry、_UIStatusBarDataEntry
                    signalStrength = [[_cellularEntry valueForKey:@"displayValue"] intValue];
                }
            }
        }
    }else {
        if ([[SDKManager getInstance] isIphoneX]) {
            id statusBar = [[UIApplication sharedApplication] valueForKeyPath:@"statusBar"];
            id statusBarView = [statusBar valueForKeyPath:@"statusBar"];
            UIView *foregroundView = [statusBarView valueForKeyPath:@"foregroundView"];
            int signalStrength = 0;
            
            NSArray *subviews = [[foregroundView subviews][2] subviews];
            
            for (id subview in subviews) {
                if ([subview isKindOfClass:NSClassFromString(@"_UIStatusBarWifiSignalView")]) {
                    signalStrength = [[subview valueForKey:@"numberOfActiveBars"] intValue];
                    break;
                }else if ([subview isKindOfClass:NSClassFromString(@"_UIStatusBarStringView")]) {
                    signalStrength = [[subview valueForKey:@"numberOfActiveBars"] intValue];
                    break;
                }
            }
            return signalStrength;
        } else {
            //兼容性处理
            NSArray *subviews = nil;
            id statusBar = [[UIApplication sharedApplication] valueForKeyPath:@"statusBar"];
            if ([statusBar isKindOfClass:NSClassFromString(@"UIStatusBar_Modern")]) {
                subviews = [[[statusBar valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
            } else {
                subviews = [[statusBar valueForKey:@"foregroundView"] subviews];
            }
    
            NSString *dataNetworkItemView = nil;
            int signalStrength = 3;

            for (id subview in subviews) {
                
                if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]] && [[self getNetworkType] isEqualToString:@"WIFI"] && ![[self getNetworkType] isEqualToString:@"NONE"]) {
                    dataNetworkItemView = subview;
                    signalStrength = [[dataNetworkItemView valueForKey:@"_wifiStrengthBars"] intValue];
                    break;
                }
                if ([subview isKindOfClass:[NSClassFromString(@"UIStatusBarSignalStrengthItemView") class]] && ![[self getNetworkType] isEqualToString:@"WIFI"] && ![[self getNetworkType] isEqualToString:@"NONE"]) {
                    dataNetworkItemView = subview;
//                    signalStrength = [[dataNetworkItemView valueForKey:@"_signalStrengthRaw"] intValue];
                    signalStrength = [[dataNetworkItemView valueForKey:@"_signalStrengthBars"] intValue];
                    break;
                }
            }
            return signalStrength;
        }
    }
    return signalStrength;
}

//获取手机型号
- (NSString *)getIphoneType
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
       
    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceModel isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([deviceModel isEqualToString:@"iPhone10,1"])   return @"iPhone_8";
    if ([deviceModel isEqualToString:@"iPhone10,4"])   return @"iPhone_8";
    if ([deviceModel isEqualToString:@"iPhone10,2"])   return @"iPhone_8_Plus";
    if ([deviceModel isEqualToString:@"iPhone10,5"])   return @"iPhone_8_Plus";
    if ([deviceModel isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([deviceModel isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    if ([deviceModel isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
    if ([deviceModel isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
    if ([deviceModel isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
    if ([deviceModel isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max";
    if ([deviceModel isEqualToString:@"iPhone12,1"])   return @"iPhone 11";
    if ([deviceModel isEqualToString:@"iPhone12,3"])   return @"iPhone 11 Pro";
    if ([deviceModel isEqualToString:@"iPhone12,5"])   return @"iPhone 11 Pro Max";
    if ([deviceModel isEqualToString:@"iPhone12,8"])   return @"iPhone SE2";
    if ([deviceModel isEqualToString:@"iPhone13,1"])   return @"iPhone 12 mini";
    if ([deviceModel isEqualToString:@"iPhone13,2"])   return @"iPhone 12";
    if ([deviceModel isEqualToString:@"iPhone13,3"])   return @"iPhone 12 Pro";
    if ([deviceModel isEqualToString:@"iPhone13,4"])   return @"iPhone 12 Pro Max";
    if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceModel isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([deviceModel isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([deviceModel isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([deviceModel isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([deviceModel isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([deviceModel isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([deviceModel isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";

    if ([deviceModel isEqualToString:@"AppleTV2,1"])      return @"Apple TV 2";
    if ([deviceModel isEqualToString:@"AppleTV3,1"])      return @"Apple TV 3";
    if ([deviceModel isEqualToString:@"AppleTV3,2"])      return @"Apple TV 3";
    if ([deviceModel isEqualToString:@"AppleTV5,3"])      return @"Apple TV 4";

    if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
    return deviceModel;
}

//保存二维码到相册
-(int)saveImageToPhotoAlbum:(NSString*)strImageData
{
    NSArray *array = [strImageData componentsSeparatedByString:@","];
    if(!array) return -1;
    
    NSData *ImageData = [[NSData alloc] initWithBase64EncodedString:array[1] options:NSDataBase64DecodingIgnoreUnknownCharacters];
    if(!ImageData) return -2;

    UIImage *image = [UIImage imageWithData:ImageData];
    if(!image) return -3;
    
    //保存图片到相册
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, NULL);
    
    return 1;
}

//生成二维码
-(UIImage*)createQRcodeImage:(NSString*)strUrl
{
    //创建滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //设置属性为默认值
    [filter setDefaults];
    //设置内容
    [filter setValue:[strUrl dataUsingEncoding:NSUTF8StringEncoding] forKey:@"inputMessage"];
    CIImage *image =  [filter outputImage];
    image = [image imageByApplyingTransform:CGAffineTransformMakeScale(8, 8)];

    //这个image是保存不到相册的，需要绘制一下
    UIImage *img_qrcode = [UIImage imageWithCIImage:image];
        
    UIGraphicsBeginImageContext(img_qrcode.size);
    //  绘制二维码图片
    [img_qrcode drawInRect:CGRectMake(0, 0, img_qrcode.size.width, img_qrcode.size.height)];
    //  从图片上下文中取出图片
    img_qrcode  = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();//关闭上下文
    
    return img_qrcode;
}

//融合二维码到背景
-(UIImage*)composeQRcodeToBg:(UIImage*)img_qrcode
{
    //以1.png的图大小为底图
    UIImage *img_bg = [UIImage imageNamed:@"qrcode_bg.png"];
    if(!img_bg) return  NULL;
    CGImageRef imgRef_bg = img_bg.CGImage;
    CGFloat w1 = CGImageGetWidth(imgRef_bg);
    CGFloat h1 = CGImageGetHeight(imgRef_bg);
    CGImageRelease(imgRef_bg);
    
    //以1.png的图大小为画布创建上下文
    UIGraphicsBeginImageContext(CGSizeMake(w1, h1));
    [img_bg drawInRect:CGRectMake(0, 0, w1, h1)];//先把背景画到上下文中
    [img_qrcode drawInRect:CGRectMake(100, 100, img_qrcode.size.width, img_qrcode.size.height)];//再把二维码放在上下文中
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();//从当前上下文中获得最终图片
    UIGraphicsEndImageContext();//关闭上下文
    
    return resultImg;
}

@end

