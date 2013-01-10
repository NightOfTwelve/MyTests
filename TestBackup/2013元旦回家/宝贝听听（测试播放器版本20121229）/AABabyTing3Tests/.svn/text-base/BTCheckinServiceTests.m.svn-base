//
//  BTCheckinServiceTests.m
//  AABabyTing3
//
//  Created by Zero on 12/6/12.
//
//

#import "BTCheckinServiceTests.h"
#import "BTCheckinService.h"
#import "BTTestAction.h"

@implementation BTCheckinServiceTests
/*
 *	由于Checkin Service只处理了正常逻辑，对于出错暂无测试
 */

//正常逻辑
- (void)test001_NormalSendAndReceiveCheckinRequest {
	BTTestAction *action = [[[BTTestAction alloc] init] autorelease];
	BTCheckinService *service = [[[BTCheckinService alloc] init] autorelease];
	service.serviceDelegate = action;
	[service sendServiceRequest];
	[self wait:5];
	STAssertTrue(action.finished, @"网络太慢了，无法测试此处逻辑");
	int ret = [action.info intValue];
	STAssertEquals(ret, 100, @"Checkin成功后的返回值应该是100");
}
@end
