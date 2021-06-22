#import "AppDelegate.h"
#import "ViewController.h"
#import "conchRuntime.h"
#import "SDKManager.h"
#import "MyJSBridge.h"
#import "WXApi.h"
#import "WeChatManger.h"
//#include "NotificationCenterManager.h"

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] ;
    ViewController* pViewController  = [[ViewController alloc] init];
    _window.rootViewController = pViewController;
    [_window makeKeyAndVisible];
    
     _launchView = [[LaunchView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_window.rootViewController.view addSubview:_launchView.view];
    
    
    //============================================================  推送 start  =================================================================
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0)
//    {
//        UNUserNotificationCenter * center = [UNUserNotificationCenter currentNotificationCenter];
//
//        [center setDelegate: [NotificationCenterManager getInstance]];
//
//        UNAuthorizationOptions type =   UNAuthorizationOptionBadge|UNAuthorizationOptionSound|UNAuthorizationOptionAlert;
//
//        [center requestAuthorizationWithOptions:type completionHandler:^(BOOL granted, NSError *     _Nullable error) {
//
//          if (granted) {
//              //DBLog(@"注册成功");
//          }else{
//             //DBLog(@"注册失败");
//          }
//
//      }];
//
//    }
//    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
//    {
//
//        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |
//
//        UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
//
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
//
//        [application registerUserNotificationSettings:settings];
//
//    }
//    else
//    {//ios8一下
//        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
//
//        UIRemoteNotificationTypeSound |
//         
//        UIRemoteNotificationTypeAlert;
//
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
//    }
//
//    // 注册获得device Token
//    [application registerForRemoteNotifications];
    //============================================================  推送 end  =================================================================
    
    [[SDKManager getInstance] init]; //初始化SDKManager
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    m_kBackgroundTask = [application beginBackgroundTaskWithExpirationHandler:^{
        if(m_kBackgroundTask != UIBackgroundTaskInvalid )
        {
            NSLog(@">>>>>backgroundTask end");
            [application endBackgroundTask:m_kBackgroundTask];
            m_kBackgroundTask = UIBackgroundTaskInvalid;
        }
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [MyJSBridge isWindowFocus:false];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [MyJSBridge isWindowFocus:true];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSLog(@"url:%@",url);
    return [[SDKManager getInstance] handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"url:%@",url);
    NSLog(@"sourceApplication:%@",sourceApplication);
    
    return [[SDKManager getInstance] openURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler
{
    return [WXApi handleOpenUniversalLink:userActivity delegate:[WeChatManger sharedManager]];
}

// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSMutableString * devices_token = [NSMutableString stringWithFormat:@"%@",deviceToken];
    
    NSLog(@"devices_token： -- %@",devices_token);
}

// 注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"注册deviceToken失败： -- %@",error);
}

@end
