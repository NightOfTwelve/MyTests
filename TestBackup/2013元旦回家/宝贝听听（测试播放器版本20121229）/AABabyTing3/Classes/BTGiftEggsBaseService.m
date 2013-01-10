//
//  BTGiftEggsBaseService.m
//  AABabyTing3
//
//  Created by Zero on 9/2/12.
//
//

#import "BTGiftEggsBaseService.h"

@interface BTGiftEggsBaseService ()
@property (nonatomic, copy)	NSString *requestUrlStr;
@end

@implementation BTGiftEggsBaseService
@synthesize requestUrlStr;

- (id)initWithRequestUrlStr:(NSString *)aUrlStr {
	if (self = [super init]) {
		self.requestUrlStr = aUrlStr;
	}
	return self;
}

- (void)defaultRequestMake {
	
    NSURL *url = [NSURL URLWithString:self.requestUrlStr];
	_request = [[ASIHTTPRequest alloc] initWithURL:url];
    [_request setTimeOutSeconds:TIME_OUT_SECONDS];
//    _request.allowCompressedResponse = NO;
    _request.numberOfTimesToRetryOnTimeout = RETRY_COUNTS;
    _request.delegate = self;
    [_request appendPostData:[self getPostData]];
}

- (void)dealloc {
	[requestUrlStr release];
	[super dealloc];
}



- (BOOL)isStringZeroOrOne:(NSString *)str {
	return (str!=nil
			&& [str isKindOfClass:[NSString class]]
			&& ([str isEqualToString:@"0"] || [str isEqualToString:@"1"])
			);
}
- (NSString *)convertResponseStringFromData:(NSData *)data error:(NSError **)error {
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
	@finally {
		if (*error != nil) {
			return nil;
		}
	}
	
	NSString *str = nil;
	@try {
		str = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
		if (![self isStringZeroOrOne:str]) {//请求失败
			*error = [NSError errorWithDomain:ERROR_CODE_DOMAIN
										 code:ERROR_CODE_REQUSETERROR
									 userInfo:nil];
			str = nil;
		}
	}
	@catch (NSException *exception) {//未知错误
		*error = [NSError errorWithDomain:ERROR_CODE_DOMAIN
									 code:ERROR_CODE_UNKNOWNERROR
								 userInfo:nil];
		str = nil;
	}
	
	return str;
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    NSData *data = [request responseData];
	NSError *error = nil;
	NSString *str = [self convertResponseStringFromData:data error:&error];
	NSDictionary *userInfo = nil;
	if (error == nil) {
		if (str != nil) {
			userInfo = [NSDictionary dictionaryWithObject:str forKey:GIFT_EGGS_RETURN];
		} else {
			error = [NSError errorWithDomain:ERROR_CODE_DOMAIN
											code:ERROR_CODE_UNKNOWNERROR
										userInfo:nil];
			userInfo = [NSDictionary dictionaryWithObject:error forKey:NOTIFICATION_ERROR];
		}
		
	} else {
		userInfo = [NSDictionary dictionaryWithObject:error forKey:NOTIFICATION_ERROR];
	}
	
	[self postNotificationWithUserInfo:userInfo];
}
- (void)requestFailed:(ASIHTTPRequest *)request{
    NSError *error = [NSError errorWithDomain:ERROR_CODE_DOMAIN
										 code:ERROR_CODE_REQUSETERROR
									 userInfo:nil];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:error
														 forKey:NOTIFICATION_ERROR];
    [self postNotificationWithUserInfo:userInfo];
}
@end
