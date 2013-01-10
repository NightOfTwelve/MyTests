//
//  BTBannerTests.m
//  AABabyTing3
//
//  Created by Zero on 11/27/12.
//
//

#import "BTBannerTests.h"
#import "BTBannerView.h"
#import "BTAppDelegate.h"
#import "BTHomeListViewController.h"

@implementation BTBannerTests
//_暂时不执行该测试方法
- (void)_test001_BannerView {
//	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:5.]];
	BTHomeListViewController *homeVC = [[BTHomeListViewController alloc] init];
	BTBannerView *view = [[BTBannerView alloc] initWithDelegate:homeVC];
	BTAppDelegate *delegate = (BTAppDelegate *)[UIApplication sharedApplication].delegate;
	[delegate.window addSubview:view];
//	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:5.]];
	
	NSArray *banners = @[
		@{
			POPULARIZ_ID:@1,
			POPULARIZ_IMG_URL:@"http://t1.baidu.com/it/u=207847978,3076148716&fm=24&gp=0.jpg",
			POPULARIZ_RUN_URL:@"http://www.baidu.com",
			POPULARIZ_START_TIME:@0,
			POPULARIZ_END_TIME:@(INTMAX_MAX),
			POPULARIZ_TYPE:@(POPULARIZ_TYPE_BANNER),
		},
		@{
			POPULARIZ_ID:@2,
			POPULARIZ_IMG_URL:@"http://t1.baidu.com/it/u=207847978,3076148716&fm=24&gp=0.jpg",
			POPULARIZ_RUN_URL:@"http://www.baidu.com",
			POPULARIZ_START_TIME:@0,
			POPULARIZ_END_TIME:@(INTMAX_MAX),
			POPULARIZ_TYPE:@(POPULARIZ_TYPE_BANNER),
		},
	];
	NSNotification *notif = [NSNotification notificationWithName:@"" object:nil userInfo:@{@"allBanners":banners}];
	[view performSelector:@selector(checkinFinish:) withObject:notif];
}

@end
