//
//  BTCheckinManager.h
//  BabyTingiPad
//
//  Created by  on 12-8-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTCheckinManager : NSObject{
    
    NSArray *popularizes;   //运营位信息
    NSArray *recommends;    //微博活动信息
    NSArray *splashs;       //闪屏信息
    int updateType;         //版本更新信息 0:没有新版本; 1:有新版本，旧版本可用; 2:有新版本，旧版本不可用，强制更新   
    NSString *updateUrl;    //强制更新的url
    NSDictionary *necessarySoftData;
}

@property (nonatomic, retain) NSArray *popularizes;
@property (nonatomic, retain) NSArray *recommends;
@property (nonatomic, retain) NSArray *splashs;
@property (nonatomic, assign) int updateType;
@property (nonatomic, copy) NSString *updateUrl;
@property (nonatomic, retain) NSDictionary *necessarySoftData;

+(BTCheckinManager *)shareInstance;
+(void)destroyInstance;

@end
