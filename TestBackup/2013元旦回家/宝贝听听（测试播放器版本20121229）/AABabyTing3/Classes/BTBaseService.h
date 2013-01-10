//
//  BTBaseService.h
//  BabyTingCoreEngine
//
//  Created by DL on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "BTRequestData.h"
#import "JSONKit.h"
#import "BTUtilityClass.h"
#import "BTServiceConstant.h"
#import "NSDictionary+ActionData.h"


@protocol BTReceiveDataDelegate <NSObject>
@optional
- (void)receiveData:(NSDictionary *)data;

@end

@interface BTBaseService : NSObject <ASIHTTPRequestDelegate> {
    NSString                    *_requestCID;
    double                      _requestTimeInterval;
    ASIHTTPRequest              *_request;
    id<BTReceiveDataDelegate>   _serviceDelegate;
}

@property (nonatomic,assign)	id<BTReceiveDataDelegate>	serviceDelegate;
@property (nonatomic,copy)		NSString					*requestCID;
@property (nonatomic,retain)	NSDate						*beginSendRequestDate;

- (void)sendServiceRequest;
- (void)defaultRequestMake;
- (NSData*)getPostData;
-(NSData *)convertData:(BTRequestData *)rd;
- (void)cancel;

//子类实现这个方法来响应网络请求的返回和错误(大多数情况在父类实现好了)
- (void)postData:(NSDictionary *)aUserInfo;
- (void)postNotificationWithUserInfo:(NSDictionary *)aUserInfo;//发消息给action层

//将返回的data转换成字典
- (NSDictionary *)convertResponseDictionaryFromData:(NSData *)data error:(NSError **)error;
//从返回的字典中解析出"ret"字段
- (int)getReturnValueFromResponseInfo:(NSDictionary *)info error:(NSError **)error;
- (int)getCIDValueFromResponseInfo:(NSDictionary *)info error:(NSError **)error;

@end
