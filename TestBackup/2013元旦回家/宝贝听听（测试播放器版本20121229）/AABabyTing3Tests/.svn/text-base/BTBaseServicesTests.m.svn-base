//
//  BTServiceTests.m
//  AABabyTing3
//
//  Created by Zero on 12/4/12.
//
//

#import "BTBaseServicesTests.h"
#import "BTBaseService.h"
#import "BTStatisticBaseService.h"
#import "BTTestAction.h"
#import "MockASIHTTPRequest.h"

#define MAX_DATA_CASE				(100)	//数据用例数上限
#define CHECKIN_SUCCESS_RET			(100)	//CHECKIN服务器成功返回值
#define BABYSTORY_SUCCESS_RET		(0)		//列表服务器成功返回值
#define RANDOM_CASE_REPEAT_COUNT	(5)	//随机数据测试次数

@implementation BTBaseServicesTests

#pragma mark - 正确的返回“成功”
- (void)test001_ResponseData_Right {
	BTBaseService *service = [[[BTBaseService alloc] init] autorelease];
	for (int i=0; i<MAX_DATA_CASE; i++) {
		NSString *methodName = [NSString stringWithFormat:@"successfulData%d",i];
		SEL sel = NSSelectorFromString(methodName);
		if ([self respondsToSelector:sel]) {
			NSError *error = nil;
			NSData *data = [self performSelector:sel];
			NSDictionary *dic = [service convertResponseDictionaryFromData:data error:&error];
			STAssertNil(error, nil);
			if (error == nil) {
				int ret = [service getReturnValueFromResponseInfo:dic error:&error];
				STAssertNil(error, nil);
				if (error == nil) {
					STAssertEquals(ret, CHECKIN_SUCCESS_RET, nil);
				}
			}
		} else {
			break;
		}
	}
}
- (NSData *)successfulData0 {
	NSDictionary *dic = @{@"ret" : @(100)};
	return [dic JSONData];
}
- (NSData *)successfulData1 {
	NSDictionary *dic = @{@"ret" : @"100"};
	return [dic JSONData];
}
- (NSData *)successfulData2 {
	NSDictionary *dic = @{
		@"ret" : @(100)
		,@"data" : @(123)
	};
	return [dic JSONData];
}
- (NSData *)successfulData3 {
	NSDictionary *dic = @{
		@"ret" : @"100"
		,@"data" : @(123)
	};
	return [dic JSONData];
}

#pragma mark - 异常返回1（json解析出错）
- (void)test002_ResponseData_Error1 {
	BTBaseService *service = [[[BTBaseService alloc] init] autorelease];
	for (int i=0; i<MAX_DATA_CASE; i++) {
		NSString *methodName = [NSString stringWithFormat:@"error1Data%d",i];
		SEL sel = NSSelectorFromString(methodName);
		if ([self respondsToSelector:sel]) {
			NSError *error = nil;
			NSData *data = [self performSelector:sel];
			[service convertResponseDictionaryFromData:data error:&error];
			STAssertNotNil(error, nil);
		} else {
			break;
		}
	}
}
- (NSData *)error1Data0 {
	return nil;
}
- (NSData *)error1Data1 {
	return [NSData dataWithBytes:"" length:0];
}
- (NSData *)error1Data2 {
	return [NSData data];
}
- (NSData *)error1Data3 {
	return [@"test" dataUsingEncoding:NSUTF8StringEncoding];
}
- (NSData *)error1Data4 {
	return [@"test" dataUsingEncoding:NSASCIIStringEncoding];
}
- (NSData *)error1Data5 {
	return [@"test" dataUsingEncoding:NSUTF32StringEncoding];
}

#pragma mark - 正确的返回“失败”
- (void)test003_ResponseData_Wrong {
	BTBaseService *service = [[[BTBaseService alloc] init] autorelease];
	for (int i=0; i<MAX_DATA_CASE; i++) {
		NSString *methodName = [NSString stringWithFormat:@"failedData%d",i];
		SEL sel = NSSelectorFromString(methodName);
		if ([self respondsToSelector:sel]) {
			for (int i=0; i<RANDOM_CASE_REPEAT_COUNT; i++) {//每次随即生成的用例反复执行n次
				NSError *error = nil;
				NSData *data = [self performSelector:sel];
				NSDictionary *dic = [service convertResponseDictionaryFromData:data error:&error];
				STAssertNil(error, nil);
				if (error == nil) {
					int ret = [service getReturnValueFromResponseInfo:dic error:&error];
					STAssertNil(error, nil);
					if (error == nil) {
						BOOL b = (ret != CHECKIN_SUCCESS_RET);
						STAssertTrue(b, nil);
					}
				}
			}
		} else {
			break;
		}
	}
}
- (NSData *)failedData0 {
	int ran = -1;
	do {
		ran = arc4random()%INT_MAX;
	} while (ran == CHECKIN_SUCCESS_RET);
	
	NSDictionary *dic = @{@"ret" : @(ran)};
	return [dic JSONData];
}
- (NSData *)failedData1 {
	int ran = -1;
	do {
		ran = arc4random()%INT_MAX;
	} while (ran == CHECKIN_SUCCESS_RET);
	NSString *str = [NSString stringWithFormat:@"%d",ran];
	
	NSDictionary *dic = @{@"ret" : str};
	return [dic JSONData];
}

#pragma mark - 异常返回2（没有"ret"字段）
- (void)test004_ResponseData_Error2 {
	BTBaseService *service = [[[BTBaseService alloc] init] autorelease];
	for (int i=0; i<MAX_DATA_CASE; i++) {
		NSString *methodName = [NSString stringWithFormat:@"error2Data%d",i];
		SEL sel = NSSelectorFromString(methodName);
		if ([self respondsToSelector:sel]) {
			NSError *error = nil;
			NSData *data = [self performSelector:sel];
			NSDictionary *dic = [service convertResponseDictionaryFromData:data error:&error];
			STAssertNil(error, nil);
			if (error == nil) {
				[service getReturnValueFromResponseInfo:dic error:&error];
				STAssertNotNil(error, @"error should not be nil");
			}
		} else {
			break;
		}
	}
}
- (NSData *)error2Data0 {
	NSDictionary *dic = @{@"ret_not_found" : @(CHECKIN_SUCCESS_RET)};
	return [dic JSONData];
}
- (NSData *)error2Data1 {
	NSDictionary *dic = @{@"ret_not_found" : @"100"};
	return [dic JSONData];
}
- (NSData *)error2Data2 {
	NSDictionary *dic = @{@"ret" : [NSNull null]};
	return [dic JSONData];
}

#pragma mark - requestFinished:方法测试
- (void)test011_BaseRequestFinished_Suc {
	for (int i=0; i<MAX_DATA_CASE; i++) {
		BTTestAction *action = [[[BTTestAction alloc] init] autorelease];
		BTBaseService *service = [[[BTBaseService alloc] init] autorelease];
		service.serviceDelegate = action;
		NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
		MockASIHTTPRequest *request = [MockASIHTTPRequest requestWithURL:url];
		NSString *methodName = [NSString stringWithFormat:@"BaseDataSuc%d",i];
		SEL sel = NSSelectorFromString(methodName);
		if ([self respondsToSelector:sel]) {
			request.fakeData = [self performSelector:sel];
			[service requestFinished:request];
			[self wait];
			STAssertNil(action.error, @"error:%@,info:%@",action.error,action.info);
			STAssertNotNil(action.info, @"error:%@,info:%@",action.error,action.info);
		} else {
			break;
		}
	}
}
- (void)test012_CheckinRequestFinished_Suc {
	for (int i=0; i<MAX_DATA_CASE; i++) {
		BTTestAction *action = [[[BTTestAction alloc] init] autorelease];
		BTStatisticBaseService *service = [[[BTStatisticBaseService alloc] init] autorelease];
		service.serviceDelegate = action;
		NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
		MockASIHTTPRequest *request = [MockASIHTTPRequest requestWithURL:url];
		NSString *methodName = [NSString stringWithFormat:@"successfulData%d",i];
		SEL sel = NSSelectorFromString(methodName);
		if ([self respondsToSelector:sel]) {
			request.fakeData = [self performSelector:sel];
			[service requestFinished:request];
			[self wait];
			STAssertNil(action.error, @"error:%@,info:%@",action.error,action.info);
			STAssertNotNil(action.info, @"error:%@,info:%@",action.error,action.info);
		} else {
			break;
		}
	}
}
- (NSData *)BaseDataSuc0 {
	NSDictionary *dic = @{@"ret" : @(0)};
	return [dic JSONData];
}
- (NSData *)BaseDataSuc1 {
	NSDictionary *dic = @{@"ret" : @"0"};
	return [dic JSONData];
}
- (NSData *)BaseDataSuc2 {
	NSDictionary *dic = @{
	@"ret" : @(0)
	,@"data" : @(123)
	};
	return [dic JSONData];
}
- (NSData *)BaseDataSuc3 {
	NSDictionary *dic = @{
	@"ret" : @"0"
	,@"data" : @(123)
	};
	return [dic JSONData];
}

- (void)test013_BaseRequestFinished_Failed1 {
	for (int i=0; i<MAX_DATA_CASE; i++) {
		BTTestAction *action = [[[BTTestAction alloc] init] autorelease];
		BTBaseService *service = [[[BTBaseService alloc] init] autorelease];
		service.serviceDelegate = action;
		NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
		MockASIHTTPRequest *request = [MockASIHTTPRequest requestWithURL:url];
		NSString *methodName = [NSString stringWithFormat:@"BaseDataFailed1_%d",i];
		SEL sel = NSSelectorFromString(methodName);
		if ([self respondsToSelector:sel]) {
			for (int i=0; i<RANDOM_CASE_REPEAT_COUNT; i++) {
				request.fakeData = [self performSelector:sel];
				[service requestFinished:request];
				[self wait];
				STAssertNotNil(action.error, @"error:%@,info:%@",action.error,action.info);
				STAssertNotNil(action.info, @"error:%@,info:%@",action.error,action.info);
				NSError *error = nil;
				int ret = [service getReturnValueFromResponseInfo:action.info error:&error];
				STAssertNil(error, @"error:%@",error);
				BOOL b = (ret != BABYSTORY_SUCCESS_RET);
				STAssertTrue(b, @"ret:%d",ret);
			}
		} else {
			break;
		}
	}
}
- (NSData *)BaseDataFailed1_0 {
	int ran = -1;
	do {
		ran = arc4random()%INT_MAX;
	} while (ran == BABYSTORY_SUCCESS_RET);
	
	NSDictionary *dic = @{@"ret" : @(ran)};
	return [dic JSONData];
}
- (NSData *)BaseDataFailed1_1 {
	int ran = -1;
	do {
		ran = arc4random()%INT_MAX;
	} while (ran == BABYSTORY_SUCCESS_RET);
	NSString *str = [NSString stringWithFormat:@"%d",ran];
	
	NSDictionary *dic = @{@"ret" : str};
	return [dic JSONData];
}

- (void)test014_CheckinRequestFinished_Failed1 {
	for (int i=0; i<MAX_DATA_CASE; i++) {
		BTTestAction *action = [[[BTTestAction alloc] init] autorelease];
		BTStatisticBaseService *service = [[[BTStatisticBaseService alloc] init] autorelease];
		service.serviceDelegate = action;
		NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
		MockASIHTTPRequest *request = [MockASIHTTPRequest requestWithURL:url];
		NSString *methodName = [NSString stringWithFormat:@"failedData0%d",i];
		SEL sel = NSSelectorFromString(methodName);
		if ([self respondsToSelector:sel]) {
			for (int i=0; i<RANDOM_CASE_REPEAT_COUNT; i++) {
				request.fakeData = [self performSelector:sel];
				[service requestFinished:request];
				[self wait];
				STAssertNotNil(action.error, @"error:%@,info:%@",action.error,action.info);
				STAssertNotNil(action.info, @"error:%@,info:%@",action.error,action.info);
				NSError *error = nil;
				int ret = [service getReturnValueFromResponseInfo:action.info error:&error];
				STAssertNil(error, @"error:%@",error);
				BOOL b = (ret != CHECKIN_SUCCESS_RET);
				STAssertTrue(b, @"ret:%d",ret);
			}
		} else {
			break;
		}
	}
}

- (void)test015_CheckinRequestFinished_Error1 {
	for (int i=0; i<MAX_DATA_CASE; i++) {
		BTTestAction *action = [[[BTTestAction alloc] init] autorelease];
		BTStatisticBaseService *service = [[[BTStatisticBaseService alloc] init] autorelease];
		service.serviceDelegate = action;
		NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
		MockASIHTTPRequest *request = [MockASIHTTPRequest requestWithURL:url];
		NSString *methodName = [NSString stringWithFormat:@"error1Data%d",i];
		
		SEL sel = NSSelectorFromString(methodName);
		if ([self respondsToSelector:sel]) {
			request.fakeData = [self performSelector:sel];
			[service requestFinished:request];
			[self wait];
			STAssertNotNil(action.error, @"error:%@,info:%@",action.error,action.info);
		} else {
			break;
		}
	}
}

- (void)test016_BaseRequestFinished_Error1 {
	for (int i=0; i<MAX_DATA_CASE; i++) {
		BTTestAction *action = [[[BTTestAction alloc] init] autorelease];
		BTBaseService *service = [[[BTBaseService alloc] init] autorelease];
		service.serviceDelegate = action;
		NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
		MockASIHTTPRequest *request = [MockASIHTTPRequest requestWithURL:url];
		NSString *methodName = [NSString stringWithFormat:@"error1Data%d",i];
		
		SEL sel = NSSelectorFromString(methodName);
		if ([self respondsToSelector:sel]) {
			request.fakeData = [self performSelector:sel];
			[service requestFinished:request];
			[self wait];
			STAssertNotNil(action.error, @"error:%@,info:%@",action.error,action.info);
		} else {
			break;
		}
	}
}

//TODO: 暂时不知道该怎么测：
//	ERROR_CODE_JSONPASERINTERNALERROR
//	ERROR_CODE_CID_TYPE_ERROR
- (void)test017_RequestFinished_Error2 {
	[self _test_RequestFinished_Error2WithTestDataIndex:17 errorCode:ERROR_CODE_RESPONSENULL];
	
}
- (void)test018_RequestFinished_Error3 {
	[self _test_RequestFinished_Error2WithTestDataIndex:18 errorCode:ERROR_CODE_JSONPASERERROR];

}
- (void)test019_RequestFinished_Error4 {
	[self _test_RequestFinished_Error2WithTestDataIndex:19 errorCode:ERROR_CODE_RESNOFOUND];

}
- (void)test020_RequestFinished_Error5 {
	[self _test_RequestFinished_Error2WithTestDataIndex:20 errorCode:ERROR_CODE_RET_IS_NSNULL];

}
- (void)test021_RequestFinished_Error6 {
		[self _test_RequestFinished_Error2WithTestDataIndex:21 errorCode:ERROR_CODE_CID_TYPE_ERROR];
}


//ERROR_CODE_RESPONSENULL
- (NSData *)data017_0 {
	return nil;
}
- (NSData *)data017_1 {
	return [NSData data];
}
- (id)data017_3 {
	return [[[NSObject alloc] init] autorelease];
}

//ERROR_CODE_JSONPASERERROR
- (NSData *)data018_0 {
	return [@[]JSONData];
}
- (NSData *)data018_1 {
	return [@"" JSONData];
}

//ERROR_CODE_RESNOFOUND
- (NSData *)data019_0 {
	return [@{@"not_found_ret":@"lalala"} JSONData];
}
- (NSData *)data019_1 {
	return [@{@"olala":@"lala"} JSONData];
}

//ERROR_CODE_RET_IS_NSNULL
- (NSData *)data020_0 {
	return [@{@"ret":[NSNull null]} JSONData];
}

- (void)_test_RequestFinished_Error2WithTestDataIndex:(int)index errorCode:(NSInteger)code {
	for (int i=0; i<MAX_DATA_CASE; i++) {
		BTTestAction *action = [[[BTTestAction alloc] init] autorelease];
		BTBaseService *service1 = [[[BTBaseService alloc] init] autorelease];
		service1.serviceDelegate = action;
		BTStatisticBaseService *service2 = [[[BTStatisticBaseService alloc] init] autorelease];
		service2.serviceDelegate = action;
		NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
		MockASIHTTPRequest *request = [MockASIHTTPRequest requestWithURL:url];
		NSString *methodName = [NSString stringWithFormat:@"data%03d_%d",index,i];
		
		SEL sel = NSSelectorFromString(methodName);
		if ([self respondsToSelector:sel]) {
			request.fakeData = [self performSelector:sel];
			[service1 requestFinished:request];
			[self wait];
			STAssertNotNil(action.error, nil);
			NSError *error = action.error;
			int errorCode = error.code;
			STAssertEquals(errorCode, code, nil);
			
			[service2 requestFinished:request];
			[self wait];
			STAssertNotNil(action.error, nil);
			error = action.error;
			errorCode = error.code;
			STAssertEquals(errorCode, code, nil);
		} else {
			break;
		}
	}
}
@end
