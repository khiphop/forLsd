#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "WXApi.h"

@interface WeChatManger:NSObject<WXApiDelegate>
+(int)doIsWXAppInstalled;
+(instancetype) sharedManager;
+(void)weChatLogin;
+(void)weChatShare:(NSString*) jsonParam;
-(void)initSDK:(NSString*) wxid;
-(BOOL)handleOpenURL:(NSURL *)url;
-(BOOL)openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
@property (nonatomic, nonatomic,retain) NSString *wxId;
@end
