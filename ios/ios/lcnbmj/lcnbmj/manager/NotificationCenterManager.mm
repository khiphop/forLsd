//
//  NotificationCenterManager.m

#import <UIKit/UIKit.h>
#include "NotificationCenterManager.h"
#import "Foundation/NSNotification.h"
#import "UserNotifications/UNUserNotificationCenter.h"

@interface NotificationCenterManager ()<UNUserNotificationCenterDelegate>
{
   
}

@end

@implementation NotificationCenterManager

+ (NotificationCenterManager*) getInstance{
    static NotificationCenterManager* iap = nil;
    if (iap == nil){
        iap = [NotificationCenterManager alloc];
    }
    return iap;
}



@end
