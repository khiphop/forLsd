
//
// 推送中心
//

#ifndef NotificationCenterManager_H
#define NotificationCenterManager_H

#import <Foundation/NSObject.h>
#import "UserNotifications/UNUserNotificationCenter.h"

@interface NotificationCenterManager:NSObject<UNUserNotificationCenterDelegate>
+(NotificationCenterManager*)getInstance;
@end

#endif

