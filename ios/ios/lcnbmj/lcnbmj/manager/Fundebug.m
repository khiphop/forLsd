//
//  Fundebug.m
//  gameCommon
//
//  Created by 吴学良 on 2020/4/7.
//  Copyright © 2020 nbsk. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "Fundebug.h"
#import <UIKit/UIKit.h>

//用于获取内网ip
//#include <ifaddrs.h>
//#include <arpa/inet.h>
//#include <net/if.h>
//
//#define IOS_CELLULAR    @"pdp_ip0"
//#define IOS_WIFI        @"en0"
//#define IP_ADDR_IPv4    @"ipv4"
//#define IP_ADDR_IPv6    @"ipv6"

@implementation Fundebug

+(Fundebug*) getInstance{
    static Fundebug* iap = nil;
    if (iap == nil){
        iap = [Fundebug alloc];
    }
    return iap;
}

-(void)initWithApiKey:(NSString *)apiKey
{
    _apiKey = apiKey;
}

-(void)setMetaData:(NSDictionary *)metaData
{
    _metaData = metaData;
}
-(void)setSilent:(bool)silent
{
    _silent = silent;
}
-(void)setAppVersion:(NSString *)appVersion
{
    _appVersion = appVersion;
}

-(void)notifyError:(NSString *)name stack:(NSString *)stack
{
    if(_silent)return;
    if(_apiKey == nil){
        NSLog(@"未配置fundebug的apikey。");
        return;
    }
    
    //配置fundeug url
    NSURL *url = [NSURL URLWithString:@"https://java.fundebug.net/event/"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 设置传输方法
    request.HTTPMethod = @"post";
    
    [request setValue:@"utf-8" forHTTPHeaderField:@"Accept-Charset"];
    [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc]init];
    dateFmt.dateFormat = @"EEE MMM dd hh:mm:ss YYYY";
    NSString *dateStr = [dateFmt stringFromDate:date];
    
    
    NSString *deviceName = [[UIDevice currentDevice] systemName];//手机系统名称
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];//手机系统版本号

    NSDictionary * dicInfo = [[NSBundle mainBundle] infoDictionary];
    NSString * appSDKName = [dicInfo objectForKey:@"DTSDKName"];//SDK 的版本。
            
    NSDictionary *params = @{
        @"notifierVersion":@"0.3.1",
        @"appVersion":_appVersion,
        @"apiKey": _apiKey,
        @"createTime": dateStr,
        @"metaData": _metaData,
        @"hostname": @"localhost",
        @"osName": deviceName,
        @"osArch": @"aarch64",
        @"runtimeVersion": systemVersion,
        @"runtimeName": @"IOS Runtime",
        @"osVersion": systemVersion,
        @"name":name,
        @"message":stack,
        @"type":@"uncaught",
        @"locale":@"zh_CN"
    };
    //这是设置请求体，把参数放进请求体(这部分的参数也叫请求参数)
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *paramJsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"发送的fundebug参数：%@", paramJsonStr);
    // 设置请求体
    request.HTTPBody = [paramJsonStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:
        ^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            if (connectionError) {
                NSLog(@"连接错误 %@", connectionError);
                return;
            }

            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (httpResponse.statusCode == 200 || httpResponse.statusCode == 304) {
                NSString *resdata = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"send to fundebug success !\n返回值：%@", resdata);
            } else {
                NSLog(@"服务器内部错误");
            }
        }];
}

////获取内网ip地址
//- (NSString *)getIPAddress:(BOOL)preferIPv4
//{
//    NSArray *searchArray = preferIPv4 ?
//                            @[ /*IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6,*/ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
//                            @[ /*IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4,*/ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
//
//    NSDictionary *addresses = [self getIPAddresses];
//
//    __block NSString *address;
//    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
//        {
//            address = addresses[key];
//            if(address) *stop = YES;
//        } ];
//    return address ? address : @"0.0.0.0";
//}
//
////获取所有相关IP信息
//- (NSDictionary *)getIPAddresses
//{
//    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
//
//    // retrieve the current interfaces - returns 0 on success
//    struct ifaddrs *interfaces;
//    if(!getifaddrs(&interfaces)) {
//        // Loop through linked list of interfaces
//        struct ifaddrs *interface;
//        for(interface=interfaces; interface; interface=interface->ifa_next) {
//            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
//                continue; // deeply nested code harder to read
//            }
//            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
//            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
//            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
//                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
//                NSString *type;
//                if(addr->sin_family == AF_INET) {
//                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
//                        type = IP_ADDR_IPv4;
//                    }
//                } else {
//                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
//                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
//                        type = IP_ADDR_IPv6;
//                    }
//                }
//                if(type) {
//                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
//                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
//                }
//            }
//        }
//        // Free memory
//        freeifaddrs(interfaces);
//    }
//    return [addresses count] ? addresses : nil;
//}

@end
