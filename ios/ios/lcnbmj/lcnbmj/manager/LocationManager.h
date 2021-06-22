
//
//  Header.h
//  gameCommon
//
//  Created by  nbgame on 2019/5/22.
//  Copyright © 2019 nbsk. All rights reserved.
//

#ifndef LocationManager_H
#define LocationManager_H

#import <Foundation/NSObject.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager:NSObject<CLLocationManagerDelegate>
+(LocationManager*)getInstance;
- (void)initializeLocationService;

- (void)startUpdatingLocation;//开启定位监听
- (double)getLatitude;//获取纬度
- (double)getLongitude;//获取经度

@end

#endif /* LocationManager_H */

