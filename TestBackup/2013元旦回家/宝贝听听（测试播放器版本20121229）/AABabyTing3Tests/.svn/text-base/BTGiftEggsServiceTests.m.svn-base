//
//  BTGiftEggsServiceTests.m
//  AABabyTing3
//
//  Created by Zero on 12/6/12.
//
//	砸蛋service测试

#import "BTGiftEggsServiceTests.h"
#import "BTGiftEggsBaseService.h"
#import "MockASIHTTPRequest.h"
#import "BTGiftEggsTestAction.h"
@interface BTGiftEggsServiceTests()
@property(nonatomic,assign) int test;
@end
@implementation BTGiftEggsServiceTests

//成功
- (void)testBTGiftEggsBaseService_requestFinished_Suc {
	NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
	MockASIHTTPRequest *request = [MockASIHTTPRequest requestWithURL:url];
	request.fakeData = [NSData dataWithBytes:"1" length:1];
	BTGiftEggsBaseService *service = [[[BTGiftEggsBaseService alloc] init] autorelease];
	service.requestCID = GIFT_EGGS_NOTIFICATION;
	BTGiftEggsTestAction *action = [[[BTGiftEggsTestAction alloc] init] autorelease];
	[service requestFinished:request];
	[self wait:.5];
	STAssertTrue(action.finished, nil);
	STAssertEqualObjects(action.data, @"1", nil);
}

//失败
- (void)testBTGiftEggsBaseService_requestFinished_Fail {
	NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
	MockASIHTTPRequest *request = [MockASIHTTPRequest requestWithURL:url];
	request.fakeData = [NSData dataWithBytes:"0" length:1];
	BTGiftEggsBaseService *service = [[[BTGiftEggsBaseService alloc] init] autorelease];
	service.requestCID = GIFT_EGGS_NOTIFICATION;
	BTGiftEggsTestAction *action = [[[BTGiftEggsTestAction alloc] init] autorelease];
	[service requestFinished:request];
	[self wait:.5];
	STAssertTrue(action.finished, nil);
	STAssertEqualObjects(action.data, @"0", nil);
}

//异常
- (void)testBTGiftEggsBaseService_requestFinished_Error {
	for (int i=0; i<10; i++) {
		NSUInteger ran = arc4random()%(INT_MAX-2)+2;
		char cstr[1024];
		sprintf(cstr, "%d",ran);
		NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
		MockASIHTTPRequest *request = [MockASIHTTPRequest requestWithURL:url];
		request.fakeData = [NSData dataWithBytes:cstr length:strlen(cstr)];
		BTGiftEggsBaseService *service = [[[BTGiftEggsBaseService alloc] init] autorelease];
		service.requestCID = GIFT_EGGS_NOTIFICATION;
		BTGiftEggsTestAction *action = [[[BTGiftEggsTestAction alloc] init] autorelease];
		[service requestFinished:request];
		[self wait:.5];
		STAssertTrue(action.finished, nil);
		STAssertNotNil(action.error, nil);
		STAssertEqualObjects(action.error.code, ERROR_CODE_REQUSETERROR, nil);
	}
}

@end
