//
//  LocationManager.m
//  gameCommon
//
//  Created by  star楼 on 2019/9/28.
//  Copyright © 2019 nbsk. All rights reserved.
//

#include "LocationManager.h"

@interface LocationManager ()<CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;//定位服务管理类
    CLGeocoder * _geocoder;//初始化地理编码器
    
    CLLocationDegrees _latitude;
    CLLocationDegrees _longitude;
}

@end

@implementation LocationManager

+ (LocationManager*) getInstance{
    static LocationManager* iap = nil;
    if (iap == nil){
        iap = [LocationManager alloc];
    }
    return iap;
}

- (void)initializeLocationService {
    // 初始化定位管理器
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager requestWhenInUseAuthorization];
    //[_locationManager requestAlwaysAuthorization];//iOS8必须，这两行必须有一行执行，否则无法获取位置信息，和定位
    // 设置代理
    _locationManager.delegate = self;
    // 设置定位精确度到米
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // 设置过滤器为无
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    // 开始定位
    [_locationManager startUpdatingLocation];//开始定位之后会不断的执行代理方法更新位置会比较费电所以建议获取完位置即时关闭更新位置服务
    //初始化地理编码器
    //_geocoder = [[CLGeocoder alloc] init];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{

    NSLog(@"GPS:=%lu",(unsigned long)locations.count);
    CLLocation * location = locations.lastObject;
    // 纬度
    _latitude = location.coordinate.latitude;
    // 经度
    _longitude = location.coordinate.longitude;
    
    [_locationManager stopUpdatingLocation];//不用的时候关闭更新位置服务
}

//开启定位监听
- (void)startUpdatingLocation
{
    [_locationManager startUpdatingLocation];
}

//获取纬度
- (double)getLatitude
{
    return _latitude;
}

//获取经度
- (double)getLongitude
{
    return _longitude;
}

@end
