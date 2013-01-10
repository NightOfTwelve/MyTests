//
//  BTTokenReportAction.m
//  AABabyTing3
//
//  Created by Zero on 9/9/12.
//
//

#import "BTTokenReportAction.h"
#import "BTTokenReportService.h"

@interface BTTokenReportAction ()
@property (nonatomic, copy)			NSString	*theToken;
@end

@implementation BTTokenReportAction
@synthesize theToken;

- (id)initWithToken:(NSString *)token {
	self = [super init];
	if (self) {
		self.theToken = token;
	}
	return (self);
}

- (void)dealloc {
	self.theToken = nil;
	[super dealloc];
}

- (void)start {
	
	//获取老Token
	NSString *udToken = [BTUserDefaults valueForKey:PUSH_TOKEN_UPLOAD];
	//该Token已经上报成功过
	if ([self.theToken isEqualToString: udToken]) {
//		DLog(@"token was already uploaded!");
		return;
	}

	//创建service并发送
	_service = [[BTTokenReportService alloc] initWithToken:self.theToken];
	_service.serviceDelegate = self;
	[super start];
}

- (void)receiveData:(NSDictionary *)data {
	NSError *error = [super onError:data];
	if (nil == error) {
		[BTUserDefaults setValue:self.theToken forKey:PUSH_TOKEN_UPLOAD];
//		DLog(@"push token uploaded succeed!");
		if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withData:)]) {
			[_actionDelegate onAction:self withData:nil];
		}
	}
}

@end
