//
//  BTStatisticBaseService.m
//  AABabyTing3
//
//  Created by Zero on 9/1/12.
//
// CheckIn && 统计上报走的服务器所用BaseService

#import "BTStatisticBaseService.h"
#import "BTBannerStatisticsReportService.h"

@implementation BTStatisticBaseService

- (NSMutableDictionary *)postCommonInfo {
	NSMutableDictionary *info = [NSMutableDictionary dictionary];
	return info;
}

- (void)defaultRequestMake {
//	CDLog(BTDFLAG_CHECKIN,@"CheckIn_IP:%@",DefaultServer_IP);
    NSURL *url = [NSURL URLWithString:DefaultServer_IP];
    _request = [[ASIHTTPRequest alloc] initWithURL:url];
    [_request setTimeOutSeconds:TIME_OUT_SECONDS];
//    _request.allowCompressedResponse = NO;
    _request.numberOfTimesToRetryOnTimeout = RETRY_COUNTS;
    _request.delegate = self;
	NSData *postData1 = [self getPostData];
	NSString *str = [[NSString alloc] initWithData:postData1 encoding:NSUTF8StringEncoding];
//	DLog(@"checkin:postData:%@",str);
	[str release];
    [_request appendPostData:postData1];
}

- (NSDictionary *)deviceInfo {
	UIDevice *device = [UIDevice currentDevice];
	CGSize size = [[UIScreen mainScreen] bounds].size;
    
    NSString *deviceType = [BTUtilityClass getDeviceVersion];
    
    NSArray *notSuportDevices = [NSArray arrayWithObjects:@"iPod1,1",@"iPod2,1",@"iPod3,1",@"iPhone1,1",@"iPhone1,2",@"iPhone2,1", nil];
    
    BOOL bIsNotRetina = NO;
    for (int i = 0; i < [notSuportDevices count]; i++) {
        if ([deviceType isEqualToString:[notSuportDevices objectAtIndex:i]]) {
            bIsNotRetina = YES;
            break;
        }
    }
    //checkin上传的是设备的分辨率
    CGSize pixel;
    if (bIsNotRetina) {
        pixel = CGSizeMake(size.width, size.height);
    }else{
        pixel = CGSizeMake(size.width*2, size.height*2);
    }

    NSDictionary *deviceInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                [device systemName],CHECKIN_REQUEST_DEVICE_SYSTEM_NAME,
                                [device systemVersion],CHECKIN_REQUEST_DEVICE_SYSTEM_VERSION,
                                [device model],CHECKIN_REQUEST_DEVICE_MODEL,
                                [device localizedModel],CHECKIN_REQUEST_DEVICE_LOCALIZED_MODEL,
                                [NSNumber numberWithInt:pixel.width],CHECKIN_REQUEST_DEVICE_SCREEN_WIDTH,
                                [NSNumber numberWithInt:pixel.height],CHECKIN_REQUEST_DEVICE_SCREEN_HEIGHT,nil];
	return deviceInfo;
}

#pragma mark -
#pragma mark ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request {
	NSError *error = nil;
    NSDictionary *responseDic = [self convertResponseDictionaryFromData:request.responseData error:&error];
	if (error == nil) {
		int ret = [self getReturnValueFromResponseInfo:responseDic error:&error];
		if (error == nil) {//此时可以正确得到"ret"返回的值
			if (ret == 100) {//服务器返回：成功
				[self postData:responseDic];
				return;
			} else {//服务器返回：失败
				error = [NSError errorWithDomain:ERROR_CODE_DOMAIN
											code:ERROR_CODE_REQUSETERROR
										userInfo:nil];
			}
		}
	}
	
	if (error == nil) {//未知错误
		error = [NSError errorWithDomain:ERROR_CODE_DOMAIN
									code:ERROR_CODE_UNKNOWNERROR
								userInfo:nil];
	}
	
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:error
														 forKey:NOTIFICATION_ERROR];
    [self postData:userInfo];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	
    //请求失败
    NSError *error = [NSError errorWithDomain:ERROR_CODE_DOMAIN
										 code:ERROR_CODE_REQUSETERROR
									 userInfo:nil];
    NSDictionary *userInfo = [NSDictionary
							  dictionaryWithObject:error
							  forKey:NOTIFICATION_ERROR];
    [self postData:userInfo];
}


@end
