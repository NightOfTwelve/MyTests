//
//  BTBaseService.m
//  BabyTingCoreEngine
//
//  Created by DL on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTBaseService.h"
#import "BTRQDReport.h"
#import "BTDownLoadManager.h"
#import "KPTeaKeyGenerator.h"

@implementation BTBaseService

@synthesize serviceDelegate = _serviceDelegate;
@synthesize requestCID = _requestCID;
@synthesize beginSendRequestDate;

- (id)init {
    if ((self = [super init])) {
    }
    return self;
}

-(void)sendServiceRequest{
	//DLog(@"super sendServiceRequest");
    if(_request == nil){//如果在发请求，禁止重发
        [self defaultRequestMake];
        [_request startAsynchronous];
    } else {
//		NSError *error = [NSError errorWithDomain:ERROR_CODE_DOMAIN code:ERROR_CODE_ALREADY_EXIST userInfo:nil];
//		NSDictionary *userInfo = [NSDictionary dictionaryWithObject:error forKey:NOTIFICATION_ERROR];
//		[self postData:userInfo];
	}
}

- (void)defaultRequestMake {
    [ASIHTTPRequest setMaxBandwidthPerSecond:0];
    NSURL *url = [NSURL URLWithString:REQUEST_SERVER_NAME];
    _request = [[ASIHTTPRequest alloc] initWithURL:url];
	_request.teaKey = [KPTeaKeyGenerator teaKeyOfCID];
	_request.shouldTeaEncryptRequestBody = YES;
	_request.allowTeaEncryptedResponse = YES;
	//[[ASIHTTPRequest requestWithURL:url] retain];
    [_request setTimeOutSeconds:TIME_OUT_SECONDS];
//    _request.allowCompressedResponse = NO;        //ASIHttpRequest请求默认支持gzip格式的返回数据，3.0此处设置为不支持，3.1需要将此处注掉
    _request.numberOfTimesToRetryOnTimeout = RETRY_COUNTS;
    _request.delegate = self;
	NSData *postData1 = [self getPostData];
	
	{
		NSString *str = [[NSString alloc] initWithData:postData1 encoding:NSUTF8StringEncoding];
		CVLog(BTDFLAG_SERVICE_PRINT,@"send message:%@",str);
		[str release];
	}
	
    [_request appendPostData:postData1];
	self.beginSendRequestDate = [NSDate date];
}

//子类实现
- (NSData*)getPostData {
    return nil;
}

- (NSData *)convertData:(BTRequestData *)rd{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:rd.cid forKey:@"cid"];
    [dic setValue:rd.stamp forKey:@"stamp"];
    [dic setValue:rd.machine forKey:@"machine"];
    [dic setValue:rd.version forKey:@"version"];
    [dic setValue:rd.identifier forKey:@"identifier"];
    [dic setValue:rd.os forKey:@"os"];
    [dic setValue:rd.channel forKey:@"channel"];
    [dic setValue:rd.appName forKey:@"app"];
	
	//若不是字典数据，则认为是数组数据 (扩展 by Zero)
	if (rd.request != nil) {
		[dic setValue:rd.request forKey:@"request"];
	} else {
		[dic setValue:rd.requestArray forKey:@"request"];
	}
    
    NSData *data = [dic JSONData];
    return data;
}

- (void)cancel {
    _serviceDelegate = nil;
	if (_request != nil) {
        [_request clearDelegatesAndCancel];
		[_request release];
        _request = nil;
    }
}

- (void)postData:(NSDictionary *)aUserInfo {
    if (_serviceDelegate && [_serviceDelegate respondsToSelector:@selector(receiveData:)] ) {
        [_serviceDelegate receiveData:aUserInfo];
    }
}


#pragma mark -
#pragma mark ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request {
    NSData *responseData = request.responseData;
	
	CVLog(BTDFLAG_SERVICE_PRINT,@"responseData->UTF8:%@",[responseData UTF8String]);
	
	NSError *error = nil;
	NSDictionary *responseDic = [self convertResponseDictionaryFromData:responseData error:&error];
	if (error == nil) {
		int cid = [_requestCID intValue];
		if (cid != 0) {
			[BTRQDReport reportCid:cid beginDate:beginSendRequestDate succeed:YES];
		}	
			
		int ret = [self getReturnValueFromResponseInfo:responseDic error:&error];
		if (error == nil) {
			if (ret == 0) {//成功
				[self postData:responseDic];
				return;
			} else if (ret>0 && ret<200) {//参数错误
				error = [NSError errorWithDomain:ERROR_CODE_DOMAIN
											code:ERROR_CODE_PARAMETERERROR
										userInfo:nil];
			} else if (ret>=200&&ret<300) {//服务器故障
				error = [NSError errorWithDomain:ERROR_CODE_DOMAIN
											code:ERROR_CODE_SERVERERROR
										userInfo:nil];
			}
		}
	}
	
	if (error == nil) {
		error = [NSError errorWithDomain:ERROR_CODE_DOMAIN
									code:ERROR_CODE_UNKNOWNERROR
								userInfo:nil];
	}
    if (responseDic == nil) {
		responseDic = [NSDictionary dictionary];
	}
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
	[userInfo setValue:error forKey:NOTIFICATION_ERROR];
	[userInfo setValue:responseDic forKey:JSON_NAME_RET];
	
    [self postData:userInfo];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	//请求失败
    NSError *err = request.error;
    NSError *error;
    if ([err.domain isEqualToString:NetworkRequestErrorDomain]
	   && err.code == ASIConnectionFailureErrorType){
        error = [NSError errorWithDomain:ERROR_CODE_DOMAIN
									code:ERROR_CODE_NONETWORK
								userInfo:nil];
    } else {
		//RQD上报
		int cid = [_requestCID intValue];
		if (cid != 0) {
			[BTRQDReport reportCid:cid beginDate:beginSendRequestDate succeed:NO];
		}
        
		error = [NSError errorWithDomain:ERROR_CODE_DOMAIN
									code:ERROR_CODE_REQUSETERROR
								userInfo:nil];
    }
	
	if (error == nil) {
		error = [NSError errorWithDomain:ERROR_CODE_DOMAIN
									code:ERROR_CODE_UNKNOWNERROR
								userInfo:nil];
	}
	NSDictionary *userInfo = @{
		NOTIFICATION_ERROR : error
	};
    [self postData:userInfo];
}

/**
 * 发消息给action层
 */
- (void) postNotificationWithUserInfo:(NSDictionary *)aUserInfo {
    [[NSNotificationCenter defaultCenter] postNotificationName:_requestCID object:self userInfo:aUserInfo];
}

- (void)dealloc {
	[beginSendRequestDate release];
	[_request release];
    [_requestCID release];
	[super dealloc];
}

//将返回的data转换成字典
- (NSDictionary *)convertResponseDictionaryFromData:(NSData *)data
											  error:(NSError **)error {
	NSDictionary *dic = nil;
	*error = nil;
	@try {
		if (data==nil || data.length==0) {//长度为0
			*error = [NSError errorWithDomain:ERROR_CODE_DOMAIN
										 code:ERROR_CODE_RESPONSENULL
									 userInfo:nil];
		}
	}
	@catch (NSException *exception) {//不是NSData对象
		*error = [NSError errorWithDomain:ERROR_CODE_DOMAIN
									 code:ERROR_CODE_RESPONSENULL
								 userInfo:nil];
	}
	if (*error != nil) {
		return nil;
	}

	@try {
		dic = [BTUtilityClass jsonParser:data];
		if (dic == nil || ![dic isKindOfClass:[NSDictionary class]]) {//Json解析失败或结果非字典
			*error = [NSError errorWithDomain:ERROR_CODE_DOMAIN
										 code:ERROR_CODE_JSONPASERERROR
									 userInfo:nil];
		}
	}
	@catch (NSException *exception) {//捕获到的isKindOfClass和Json解析内部错误
		*error = [NSError errorWithDomain:ERROR_CODE_DOMAIN
									 code:ERROR_CODE_JSONPASERINTERNALERROR
								 userInfo:nil];
	}
	
	return dic;
}
//从返回的字典中解析出"ret"字段
- (int)getReturnValueFromResponseInfo:(NSDictionary *)info error:(NSError **)error{
	id ret = [info valueForKey:JSON_NAME_RET];
	if (ret == nil) {//服务器返回没有"ret"字段
		*error = [NSError errorWithDomain:ERROR_CODE_DOMAIN
									 code:ERROR_CODE_RESNOFOUND
								 userInfo:nil];
		return -1;
	}
	
	int returnValue = -1;
	@try {
		returnValue = [ret intValue];
	}
	@catch (NSException *exception) {//服务器返回的"ret"的值为NSNull对象
		*error = [NSError errorWithDomain:ERROR_CODE_DOMAIN
									 code:ERROR_CODE_RET_IS_NSNULL
								 userInfo:nil];
		returnValue = -1;
	}
	return returnValue;
}
- (int)getCIDValueFromResponseInfo:(NSDictionary *)info error:(NSError **)error {
	int ret = 0;
	@try {
		ret = [[info valueForKey:@"cid"] intValue];//若没有这个字段，返回0————正常，不认为出错
	}
	@catch (NSException *exception) {//valueForKey方法出错或intValue方法出错
		*error = [NSError errorWithDomain:ERROR_CODE_DOMAIN
									 code:ERROR_CODE_CID_TYPE_ERROR
								 userInfo:nil];
		ret = 0;
	}
	@finally {
		return ret;
	}
}
@end
