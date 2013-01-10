//
//  BTCheckinService.m
//  BabyTingiPad
//
//  Created by  on 12-8-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTCheckinService.h"
#import "BTUtilityClass.h"
#import "BTConstant.h"
#import "JSONKit.h"

@implementation BTCheckinService

- (NSData*)getPostData {
	NSDictionary *deviceInfo = self.deviceInfo;
    NSDictionary *requestInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                 deviceInfo, CHECKIN_REQUEST_DEVICE_INFO,
                                 @"", CHECKIN_REQUEST_STATISTICS,
                                 NEVER_UPDATE, CHECKIN_REQUEST_LAST_UPDATE_DATE,nil];
    
    NSData *data = [BTUtilityClass requestPacking:REQUEST_NAME_CHECKIN withInfo:requestInfo];
	
    CVLog(BTDFLAG_SERVICE_CHECKIN_PRINT,@"checkin send message:%@",[data UTF8String]);
	
    return data;
}

-(void)requestFinished:(ASIHTTPRequest *)request{
    NSData *responseData = request.responseData;
	NSError *error = nil;
    
	CVLog(BTDFLAG_SERVICE_CHECKIN_PRINT,@"checkin receive message:%@",[responseData UTF8String]);
	
	NSDictionary *responseDic = [self convertResponseDictionaryFromData:responseData error:&error];
	if (error == nil) {
		int errorCode = [self getReturnValueFromResponseInfo:responseDic error:&error];
		switch (errorCode) {
            case 100://成功
                if (_serviceDelegate!=nil
					&& [_serviceDelegate respondsToSelector:@selector(receiveData:)]){
                    [_serviceDelegate receiveData:responseDic];
                }
                return;
            case 111:
                error = [NSError errorWithDomain:CHECKIN_ERROR_CODE_DOMAIN code:CHECKIN_ERROR_CODE_PARAMETERERROR userInfo:nil];
                break;
            case 112:
                error = [NSError errorWithDomain:CHECKIN_ERROR_CODE_DOMAIN code:CHECKIN_ERROR_CODE_PARAMETERFOMATEERROR userInfo:nil];
                break;
            case 600:
                error = [NSError errorWithDomain:CHECKIN_ERROR_CODE_DOMAIN code:CHECKIN_ERROR_CODE_NORESOURCE userInfo:nil];
                break;
            case 601:
                error = [NSError errorWithDomain:CHECKIN_ERROR_CODE_DOMAIN code:CHECKIN_ERROR_CODE_NOLIMIT userInfo:nil];
                break;
            case 700:
                error = [NSError errorWithDomain:CHECKIN_ERROR_CODE_DOMAIN code:CHECKIN_ERROR_CODE_SERVERERROR userInfo:nil];
                break;
            case 701:
                error = [NSError errorWithDomain:CHECKIN_ERROR_CODE_DOMAIN code:CHECKIN_ERROR_CODE_REQUSETNOREQUEST userInfo:nil];
                break;
            case 702:
                error = [NSError errorWithDomain:CHECKIN_ERROR_CODE_DOMAIN code:CHECKIN_ERROR_CODE_REQUSETEBUSY userInfo:nil];
                break;
            default:
				error = [NSError errorWithDomain:CHECKIN_ERROR_CODE_DOMAIN code:CHECKIN_ERROR_CODE_RESPONSENULL userInfo:nil];
                break;
        }
	}
	
	if (error != nil) {
		//TODO: 请求失败
	}
}

-(void)requestFailed:(ASIHTTPRequest *)request{
	//TODO: 请求失败
}

@end
