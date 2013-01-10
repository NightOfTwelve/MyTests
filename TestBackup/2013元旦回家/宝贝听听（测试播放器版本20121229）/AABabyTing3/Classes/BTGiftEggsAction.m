//
//  BTGiftEggsAction.m
//  AABabyTing3
//
//  Created by Zero on 9/2/12.
//
//  砸蛋Action

#import "BTGiftEggsAction.h"

@interface BTGiftEggsAction ()
@property (nonatomic, copy)	NSString *runUrlStr;
@end

@implementation BTGiftEggsAction
@synthesize requestUrlStr;
@synthesize runUrlStr;

//某一个故事播放“完成”
- (void)oneStoryHasPlayed {
	
	//得到砸蛋活动
	NSString *filePath = [BTUtilityClass fileWithPath:GIFT_EGGS_PLIST_NAME];
	NSMutableDictionary *gift = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
	if (!gift) {
		return;
	}
	
//	DLog(@"gift1 = %@",gift);
	
	//判断是否在活动有效期内
	NSTimeInterval nowTime = [BTUtilityClass nowTimeDouble];
	NSTimeInterval startTime = [[gift valueForKey:GIFT_EGGS_START_TIME] doubleValue];
	NSTimeInterval endTime = [[gift valueForKey:GIFT_EGGS_END_TIME] doubleValue];
	if (nowTime < startTime || nowTime > endTime) {
		return;
	}

	//判断任务数是否已达上限
	int maxTimes = [[gift numberForKey:GIFT_EGGS_MISSION_MAX] intValue];
	int curTimes = [[gift numberForKey:GIFT_EGGS_MISSION_DONE] intValue];
//	DLog(@"mission:%d/%d",curTimes,maxTimes);
	if (curTimes >= maxTimes) {
		return;
	}
	
	//判断当前完成歌曲数是否已达上限（若已达上限，说明上次的请求并没有返回）
	int playedCountMax = GIFT_EGGS_PLAYED_COUNT_MAX;
	int playedCount = [[gift numberForKey:GIFT_EGGS_PLAYED_COUNT] intValue];
//	DLog(@"played:%d/%d",playedCount,playedCountMax);
	if (playedCount >= playedCountMax) {
		return;//那这次你听的就作废了呗~谁让你长了一双测试的手，你这属于作弊啊孩纸~哈哈
	}
	
	
	//判断是否完成任务
	playedCount ++;
	if (playedCount < playedCountMax) {
		[gift setValue:[NSNumber numberWithInt:playedCount]
				forKey:GIFT_EGGS_PLAYED_COUNT];
		[gift writeToFile:filePath atomically:YES];
		return;
	}
	
	
//	//此时任务已完成（playedCount >= playedCountMax）
//	{
//		
//		NSString *lastDateStr = [rightGiftInfo valueForKey:GIFT_EGGS_LAST_MISSION_DATE];
//		if ([BTUtilityClass isNowDateEqualsToDateString:lastDateStr]) {
//			return;
//		}
//		
//		playedCount %= playedCountMax;
//		curTimes++;
//		[rightGiftInfo setValue:[NSNumber numberWithInt:playedCount] forKey:GIFT_EGGS_PLAYED_COUNT];
//		[rightGiftInfo setValue:[NSNumber numberWithInt:curTimes] forKey:GIFT_EGGS_MISSION_DONE];
//		[rightGiftInfo setValue:[[NSDate date] stringValue] forKey:GIFT_EGGS_LAST_MISSION_DATE];
//		[gifts setValue:rightGiftInfo forKey:rightKey];
//		[gifts writeToFile:filePath atomically:YES];
//	}
	
	
	//尝试与服务器通信，询问是否有砸蛋机会
//	DLog(@"gift2 = %@",gift);
	self.requestUrlStr = [gift stringForKey:GIFT_EGGS_REQUEST_OPPORTUNITY_URl];
	self.runUrlStr = [gift stringForKey:GIFT_EGGS_RUN_URL];
	[self start];
}

//请求询问是否有砸蛋机会
- (void)start {
	
	_service = [[BTGiftEggsBaseService alloc] initWithRequestUrlStr:self.requestUrlStr];
	_service.serviceDelegate = self;
	_service.requestCID = GIFT_EGGS_NOTIFICATION;
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(didFinish:)
												 name:GIFT_EGGS_NOTIFICATION
											   object:_service];
	[super start];
}

//请求结束
- (void)didFinish:(NSNotification *)notification {
	
	
	//清空播放计数
	NSString *filePath = [BTUtilityClass fileWithPath:GIFT_EGGS_PLIST_NAME];
	NSMutableDictionary *gift = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
	if (!gift) {
		return;
	}
	[gift setValue:[NSNumber numberWithInt:0] forKey:GIFT_EGGS_PLAYED_COUNT];
	[gift writeToFile:filePath atomically:YES];
	
	//得到是否应该
	NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:notification.userInfo];
//	DLog(@"GiftEggsReturn：%@",userInfo);
	NSError *error = [userInfo valueForKey:NOTIFICATION_ERROR];
	if (error) {
		//联网失败
//		DLog(@"error:%@",error);
		if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withError:)]) {
			[_actionDelegate onAction:self withError:error];
		}
		return;
	}
	
	//以下为联网成功的处理：
	//重置“重试/取消”标识
	[[self class] resetRetryCancelFlag];
	
	[userInfo setValue:self.runUrlStr forKey:GIFT_EGGS_RUN_URL];
	if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withData:)]) {
		[_actionDelegate onAction:self withData:userInfo];
	}
}

- (void)dealloc {
	[requestUrlStr release];
	[runUrlStr release];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

#pragma mark - “重试/取消”标识位
//重置“重试/取消”标识
+ (void)resetRetryCancelFlag {
	NSString *giftPath = [BTUtilityClass fileWithPath:GIFT_EGGS_PLIST_NAME];
	NSMutableDictionary *gift = [NSMutableDictionary dictionaryWithContentsOfFile:giftPath];
	[gift setValue:[NSNumber numberWithBool:NO] forKey:GIFT_EGGS_RETRY_CANCEL_FLAG];
	[gift writeToFile:giftPath atomically:YES];
}

//获取“重试/取消”标识
//若联网失败时，此标识为YES，不提示“重试/取消”；反之，则提示。
+ (BOOL)getRetryCancelFlag {
	NSString *giftPath = [BTUtilityClass fileWithPath:GIFT_EGGS_PLIST_NAME];
	NSMutableDictionary *gift = [NSMutableDictionary dictionaryWithContentsOfFile:giftPath];
	BOOL ret = [[gift valueForKey:GIFT_EGGS_RETRY_CANCEL_FLAG] boolValue];
	return ret;
}

//设置“重试/取消”标识
+ (void)setRetryCancelFlag {
	NSString *giftPath = [BTUtilityClass fileWithPath:GIFT_EGGS_PLIST_NAME];
	NSMutableDictionary *gift = [NSMutableDictionary dictionaryWithContentsOfFile:giftPath];
	[gift setValue:[NSNumber numberWithBool:YES] forKey:GIFT_EGGS_RETRY_CANCEL_FLAG];
	[gift writeToFile:giftPath atomically:YES];
}
@end
