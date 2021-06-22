
//
//  Header.h
//  sdk管理类
//
//  Created by  starLou on 2020/5/13.
//
//

#ifndef SDKManager_H
#define SDKManager_H

#import <Foundation/NSObject.h>
#import "iap/IAPManager.h"
@interface SDKManager:NSObject<JCIapProcessCtrlDelegate>
+(SDKManager*)getInstance;
- (instancetype)init;
- (BOOL)handleOpenURL:(NSURL *)url;
- (BOOL)openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
- (void)clearPastedAndQuery; //清空链接参数和剪切板的缓存
- (NSString*)getPastedBoardString;//获取剪切板上的字段
- (int)getVersion;//获取版本号
- (int) changeStringVersionToInt:(NSString*)strVersion;//将版本号转换成int
- (void)startRecord;//开始录音
- (void)stopRecord;//停止录音
- (void)onRecordSucceed;//录音成功
- (void)onRecordFail:(int)nErrorID;//录音失败
- (void)uploadVoice:(NSString*)strUrl gameID:(NSString*)strGameID roomUniqueCode:(NSString*)strRoomUniqueCode userID:(NSString*)strUserID;//上传音频
- (bool)checkUpdate;//检测更新
-(void)setInfoFromWxOnLaunch:(NSString*)strLaunchInfo;//设置来自微信的启动app数据
-(float)getPhoneBatteryLevelAndListen; //获取当前电量并实时监听电量变化
- (void)removeBatteryListen;//移除电量监听
- (void)didChangeBatteryLevel:(id)sender;//电量变化
-(bool)isIphoneX;
- (NSString *)getNetworkType;
- (int)getSignalStrength;
- (NSString *)getIphoneType;//获取手机型号
- (void) init7YuSdk;//初始化7鱼sdk
-(UIImage*)createQRcodeImage:(NSString*)strUrl;//生成二维码
-(UIImage*)composeQRcodeToBg:(UIImage*)img_qrcode;//融合二维码到背景
-(int)saveImageToPhotoAlbum:(NSString*)strImageData;//保存图片到相册
- (void) initAliyunLogSDK;//初始化阿里云日志sdk
- (void) uploadLogToAliyun:(NSString *)logMsg;//上传日志到阿里云
- (void) initUM;//初始化友盟


@property (nonatomic, nonatomic,copy) NSString *wxId;
@property (nonatomic, nonatomic,copy) NSString *umengId;
@property (nonatomic, nonatomic,copy) NSString *schemas;
@property (nonatomic, readonly,copy) NSString *pastedBoard;  //剪贴板标签，用于区分无用的内容
@property (nonatomic, readonly,copy) NSString *intnetquery;  //链接上的参数
@property (nonatomic, readonly,copy) NSString *infoFromWxOnLaunch;//微信端跳转到app时带过来的数据
@property (nonatomic, nonatomic,copy) NSString *appStoreId; 
@property (nonatomic, nonatomic) int nVersion;
@end

#endif /* SDKManager_H */


