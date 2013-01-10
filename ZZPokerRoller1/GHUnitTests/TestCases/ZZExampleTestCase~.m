//
//  ZZExampleTestCase.m
//  ZZPokerRoller1
//
//  Created by Zero on 1/10/13.
//  Copyright (c) 2013 21kunpeng. All rights reserved.
//

#import "ZZExampleTestCase.h"
#import "ZZExample.h"

@implementation ZZExampleTestCase
- (void)test1 {
	ZZExample *e = [[[ZZExample alloc] init] autorelease];
	e.a = 1;
	GHAssertEquals(e.a, 1, nil);
//);	GHRunWhile(1);
//	GHFail(@"哈哈，你悲剧了！");
}
- (void)test2 {
	
}
@end
