//
//  BTRequestData.h
//  AABabyTing3
//
//  Created by  on 12-8-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTRequestData : NSObject
    
@property (nonatomic,copy)		NSNumber					*cid;                                   //请求命令
@property (nonatomic,copy)		NSNumber					*stamp;                                 //时间戳
@property (nonatomic,copy)		NSString					*machine;                               //移动设备类型
@property (nonatomic,copy)		NSString					*version;                               //交互协议版本号
@property (nonatomic,copy)		NSString					*identifier;                            //客户端的唯一标识
@property (nonatomic,copy)		NSString					*os;                                    //ios系统版本号
@property (nonatomic,copy)		NSNumber					*channel;                               //下载的渠道号
@property (nonatomic,retain)	NSMutableDictionary			*request;								//请求的数据（默认：字典）
@property (nonatomic,retain)	NSMutableArray				*requestArray;							//请求的数据（数组）
@property (nonatomic,copy)      NSNumber                    *appName;                               //应用的名字

- (id)initWithCid:(NSInteger)cid;
@end
