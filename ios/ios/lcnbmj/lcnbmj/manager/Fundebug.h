//
//  BSFundebug.h
//  gameCommon
//
//  Created by 吴学良 on 2020/4/14.
//  Copyright © 2020 nbsk. All rights reserved.
//

#ifndef Fundebug_h
#define Fundebug_h

#import <Foundation/NSObject.h>

@interface Fundebug:NSObject
{
    NSString *_apiKey;
}
+(Fundebug*)getInstance;
-(void)initWithApiKey:(NSString *)apiKey;
-(void)setMetaData:(NSDictionary *)metaData;
-(void)setSilent:(bool)silent;
-(void)setAppVersion:(NSString *)appVersion;
-(void)notifyError:(NSString *)name stack:(NSString *)stack;

@property (nonatomic) NSDictionary *metaData;
@property (nonatomic) bool silent;
@property (nonatomic) NSString *appVersion;

@end

#endif /* Fundebug_h */
