#import "WeChatManger.h"
#import "WXApi.h"
#import <conchRuntime.h>
#import "MyJSBridge.h"
#import "SDKManager.h"
#import "ViewController.h"

@implementation WeChatManger;

- (void) onReq:(BaseReq *)req
{
    //获取开放标签传递的extinfo数据逻辑
    if ([req isKindOfClass:[LaunchFromWXReq class]])
    {
        LaunchFromWXReq *launchReq = (LaunchFromWXReq *)req;
        
        WXMediaMessage *msg = launchReq.message;
        NSString *extinfo = msg.messageExt;
        
        [[SDKManager getInstance] setInfoFromWxOnLaunch: extinfo];
//        NSString* sJs = [NSString stringWithFormat:@"if(window.Laya && Laya.Browser)Laya.Browser.window.onLaunchFromWXReq('%@');",extinfo];
//        [MyJSBridge callRunJs:[NSString stringWithCString:[sJs UTF8String] encoding:NSUTF8StringEncoding]];
    }
    
}

- (void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendAuthResp class]])
    {
        SendAuthResp *temp = (SendAuthResp*)resp;
        if (temp.errCode== 0 && temp.code && temp.code.length != 0)
        {
            [MyJSBridge wxLoginCallBack:1 code:temp.code tip:@"登录成功!"];
        }
        else{
            [MyJSBridge wxLoginCallBack:0 code:@"" tip:@"登录失败!"];
        }
    }
    else if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        switch (resp.errCode) {
            case WXSuccess:
                [MyJSBridge wxShareCallBack:1 tip:@"分享成功!"];
                break;
            case WXErrCodeAuthDeny:
                [MyJSBridge wxShareCallBack:-1 tip:@"分享已取消!"];
                break;
            default:
                [MyJSBridge wxShareCallBack:0 tip:@"分享失败!"];
                break;
        }
    }
}

+ (void)weChatLogin
{
   if(![WeChatManger doIsWXAppInstalled])
   {
       [MyJSBridge wxLoginCallBack:-3 code:@"" tip:@"登陆失败！您未安装微信!"];
   }
   else
   {
       SendAuthReq* req = [[SendAuthReq alloc] init];
       req.scope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact"; // @"post_timeline,sns"
       req.state = @"nbgameLua";
       [WXApi sendReq:req completion:nil];
   }
}

+ (void)weChatShare:(NSString*) jsonParam
{
    NSData* data = [jsonParam dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if (json == nil) return;
    NSString *shareType = json[@"shareType"];
    if(![WeChatManger doIsWXAppInstalled])
    {
        [MyJSBridge wxShareCallBack:-3 tip:@"未安装微信!"];
    }

        
   NSString *shareTitle = json[@"shareTitle"];NSString *shareIcon = json[@"shareIcon"];
   NSString *shareDesc = json[@"shareDesc"];NSString *shareLink = json[@"shareLink"];
   NSString *shareImageData = json[@"shareImage"];
   if( shareTitle == nil || shareTitle.length < 1 ||
       shareIcon == nil || shareIcon.length < 1 ||
       shareDesc == nil || shareDesc.length < 1 ||
       shareLink == nil || shareLink.length < 1 )
   {
       [MyJSBridge wxShareCallBack:-5 tip:@"分享信息缺失!"];
   }
   else
   {
       int nRet = 0;
       if( [shareType isEqualToString:@"text"] )nRet = 1;
       else if ( [shareType isEqualToString:@"webView"] )nRet = 2;
       else if ( [shareType isEqualToString:@"img"] )nRet = 3;
       switch (nRet)
       {
          case 1:
          {
              //初始化一个WXWebpageObject对象，填写url
              WXWebpageObject *webpageObject = [WXWebpageObject object];
              webpageObject.webpageUrl = shareLink;
              //用WXWebpageObject对象初始化一个WXMediaMessage对象，填写标题，描述
              WXMediaMessage *message = [WXMediaMessage message];
              message.title = shareTitle;
              message.description = shareDesc;
              NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
              NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
              UIImage * shareImage = [UIImage imageNamed:icon];
              [message setThumbImage:shareImage];
              message.mediaObject = webpageObject;
              SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
              req.bText = NO;
              req.message = message;
              req.scene = WXSceneSession;
              [WXApi sendReq:req completion:nil];
              break;
          }
          case 2:
          {
              break;
          }
           case 3:
          {
              //UIImage *image = [[ViewController GetIOSViewController] getScreenShot];
              
              NSArray *array = [shareImageData componentsSeparatedByString:@","];
              NSData *ImageData = [[NSData alloc] initWithBase64EncodedString:array[1] options:NSDataBase64DecodingIgnoreUnknownCharacters];

              UIImage *image = [UIImage imageWithData:ImageData];

         
              // 下面就是组装要分享到微信的内容
              WXMediaMessage *message=[WXMediaMessage message];
              [message setThumbImage:image];
              WXImageObject *imageObject=[WXImageObject object];
              imageObject.imageData=UIImagePNGRepresentation(image);
              message.mediaObject=imageObject;

              SendMessageToWXReq *req=[[SendMessageToWXReq alloc]init];
              req.bText=NO;
              req.message=message;
              req.scene=WXSceneSession;
              [WXApi sendReq:req completion:nil];
              break;
          }
          default:{
              [MyJSBridge wxShareCallBack:-6 tip:@"不支持的分享类型！"];
              break;
          }
       }
       
   }
}


//微信sdk
- (BOOL)handleOpenURL:(NSURL *)url
{
    NSLog(@"url:%@",url);
    if ([[url scheme] isEqualToString:_wxId]){
        return [WXApi handleOpenURL:url delegate:(id)[WeChatManger sharedManager]];
    }
    else{
        return NO;
    }
}

- (BOOL)openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"url:%@",url);
    NSLog(@"sourceApplication:%@",sourceApplication);
    if ([[url scheme] isEqualToString:_wxId]){
        return [WXApi handleOpenURL:url delegate:(id)[WeChatManger sharedManager]];
    }
    return TRUE;
}

+(int)doIsWXAppInstalled
{
    BOOL isInstalled = [WXApi isWXAppInstalled];
    BOOL isSepport = [WXApi isWXAppSupportApi];
    if (isInstalled == YES && isSepport == YES)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}
-(void) initSDK:(NSString*) wxid{
    //向微信注册
    _wxId = wxid;
    [WXApi registerApp:_wxId universalLink:@"https://applesite.nbmj.cn/hcmj/"];
}

+(instancetype)sharedManager {
    
    static dispatch_once_t onceToken;
    
    static WeChatManger *instance;
    
    dispatch_once(&onceToken, ^{
        
        instance = [[WeChatManger alloc] init];
        
    });
    return instance;
}

@end
