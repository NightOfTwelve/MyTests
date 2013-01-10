//
//  BTStoryPlayedAction.m
//  AABabyTing3
//
//  Created by Zero on 8/31/12.
//
//	某个故事播放50%之后进行的处理类

#import "BTStoryPlayedAction.h"
#import "BTGiftEggsAction.h"
#import "BTWebViewController.h"

const NSInteger kTagAlertRetry		= 202;		//重试的alert

@interface BTStoryPlayedAction ()
@property (nonatomic, retain)	BTGiftEggsAction	*action;
@property (nonatomic, copy)		NSString			*giftEggsRunUrlStr;
@end

@implementation BTStoryPlayedAction
@synthesize action;
@synthesize giftEggsRunUrlStr;

- (void)start:(NSString *)storyId {
	[BTUtilityClass recordStoryPlayCount:storyId];
	
	action = [[BTGiftEggsAction alloc] init];
	action.actionDelegate = self;
	[action oneStoryHasPlayed];
}

- (void)dealloc {
	[action release];
	[giftEggsRunUrlStr release];
	[super dealloc];
}

#pragma mark - BTBaseActionDelegate
- (void)onAction:(BTBaseAction *)action withData:(id)data {
//	[BTGiftEggsAction resetRetryCancelFlag];//重置标识
	
	NSDictionary *userInfo = data;
	NSInteger ret = [[userInfo valueForKey:GIFT_EGGS_RETURN] integerValue];
	self.giftEggsRunUrlStr = [userInfo valueForKey:GIFT_EGGS_RUN_URL];
	if (0 == ret) {
		//成功，任务完成次数+1
		NSString *filePath = [BTUtilityClass fileWithPath:GIFT_EGGS_PLIST_NAME];
		NSMutableDictionary *gift = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
		if (gift) {
			int curTimes = [[gift valueForKey:GIFT_EGGS_MISSION_DONE] intValue];
			curTimes++;
			NSNumber *value = [NSNumber numberWithInt:curTimes];
			[gift setValue:value forKey:GIFT_EGGS_MISSION_DONE];
			[gift writeToFile:filePath atomically:YES];
		}
		
		//发送成功通知
		[[NSNotificationCenter defaultCenter] postNotificationName:GIFT_EGGS_SHOW_NOTIFICATION object:nil userInfo:userInfo];
	} else {
		//失败
	}
}

- (void)onAction:(BTBaseAction *)action withError:(NSError *)error {
	//重试
	if (![BTGiftEggsAction getRetryCancelFlag]) {
		[self alertRetry];
	}
}



#pragma mark - alert
- (void)alertRetry {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接失败！"
													message:@"连接网络后可获得抽奖机会！"
												   delegate:self
										  cancelButtonTitle:@"取消"
										  otherButtonTitles:@"重试", nil];
	alert.tag = kTagAlertRetry;
	[alert show];
	[alert release];
}

//重试
- (void)retryAlertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (buttonIndex) {
		case 0: {//@"取消"
			[BTGiftEggsAction setRetryCancelFlag];//设置“重试/取消”标识
			break;
		}
		case 1: {//@"重试"
			[action start];
			break;
		}
		default:
			break;
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (alertView.tag) {
		case kTagAlertRetry: {//重试
			[self retryAlertView:alertView clickedButtonAtIndex:buttonIndex];
			break;
		}
		default: {
			break;
		}
	}
}


@end
