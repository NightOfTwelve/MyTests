//
//  BTSplashService.m
//  闪屏相关文件。
//
//  Created by vicky on 8/31/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

// =========================================
// ** Import **
// =========================================
#import "BTSplashService.h"

// =========================================
// ** Class **
// =========================================
@implementation BTSplashService
// =========================================
// ** 初始化 **
// =========================================
/**
 * 初始化
 */
- (id)init{
    self = [super init];
    if(self) {
    }
    return self;
}

// =========================================
// ** ASIHTTPRequest相关请求 **
// =========================================
/**
 * 发送ASIHTTPRequest请求
 * 参数：splashInfo ：［in］要请求的闪屏信息。包括url：用来告知ASIHTTPRequest资源链接。
 */
- (void)downloadSplash:(NSDictionary *)splashInfo{
    NSString *downloadURL = [splashInfo objectForKey:SPLASH_DOWNLOAD_URL];
    NSURL *url = [NSURL URLWithString:downloadURL];
    _request =  [[ASIHTTPRequest alloc] initWithURL:url];
    [_request setTimeOutSeconds:TIME_OUT_SECONDS];
    _request.numberOfTimesToRetryOnTimeout = RETRY_COUNTS;
    _request.delegate = self;
    [_request startAsynchronous];	//发送请求
}

/**
 * 请求失败
 */
- (void)requestFailed:(ASIHTTPRequest *)request{
    NSError *error = [NSError errorWithDomain:DOWNLOAD_PIC_ERROR_DOMAIN 
                                         code:DOWNLOAD_PIC_ERROR_CODE 
                                     userInfo:nil];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:error 
                                                         forKey:NOTIFICATION_ERROR];
    [self postNotificationWithUserInfo:userInfo];
}

/**
 * 请求成功
 */
- (void)requestFinished:(ASIHTTPRequest *)request{
    NSData *data            = [request responseData];
    NSDictionary *imgInfo   = [NSDictionary dictionaryWithObject:data forKey:NOTIFICATION_PICDATA];
    [self postNotificationWithUserInfo:imgInfo];
}

@end

