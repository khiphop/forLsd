#import <UIKit/UIKit.h>
#import  <UserNotifications/UserNotifications.h>
#import "LaunchView.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate> 
{
@public
    UIBackgroundTaskIdentifier m_kBackgroundTask;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LaunchView *launchView;
@end
