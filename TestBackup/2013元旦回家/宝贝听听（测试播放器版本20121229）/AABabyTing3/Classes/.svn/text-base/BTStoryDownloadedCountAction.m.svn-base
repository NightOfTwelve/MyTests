//
//  BTStoryDownloadedCountAction.m
//  AABabyTing3
//
//  Created by Zero on 9/5/12.
//
//

#import "BTStoryDownloadedCountAction.h"
#import "BTStoryDownloadedCountService.h"
#import "LastSavedDateComparisonAndModification.h"

@implementation BTStoryDownloadedCountAction

- (void)start {
	
	
	//判断今天是否成功上传过
	if ([LastSavedDateComparisonAndModification isLastReportedLocalStoryIDsDateToday]) {
//		DLog(@"repeat report: count");
		return;
	}
	NSString *filePath = [BTUtilityClass fileWithPath:STORY_DOWNED_COUNT_PLIST_NAME];
	NSDictionary *info = [NSDictionary dictionaryWithContentsOfFile:filePath];
	//如果没有需要上报的
//	DLog(@"story downloded count action : info:%@",info);
	if ([info count] == 0) {
//		DLog(@"no need report!");
		return;
	}
	
	_service = [[BTStoryDownloadedCountService alloc] initWithRequestInfo:info];
	_service.serviceDelegate = self;
//	_service.requestCID = STORY_DOWNLOADED_COUNT_FINISH_NOTIFICATION;
//	[[NSNotificationCenter defaultCenter]
//	 addObserver:self
//	 selector:@selector(didFinish:)
//	 name:STORY_DOWNLOADED_COUNT_FINISH_NOTIFICATION
//	 object:_service];
	
	[super start];
}

- (void)receiveData:(NSDictionary *)data {
	
	NSDictionary *userInfo = data;
	int ret = [[userInfo numberForKey:JSON_NAME_RET] intValue];
	if (ret == 100) {
		//成功上报，标记最后上报日期为今天
		[LastSavedDateComparisonAndModification setLastReportedLocalStoryIDsDateToday];
		//清空累计数据
		NSString *filePath = [BTUtilityClass fileWithPath:STORY_DOWNED_COUNT_PLIST_NAME];
		NSDictionary *info = [NSDictionary dictionary];
		[info writeToFile:filePath atomically:YES];
		
		if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withData:)]) {
			[_actionDelegate onAction:self withData:userInfo];
		}
//		DLog(@"story downloaded count report succeed!");
	} else {
//		DLog(@"story downloaded count report failed!");
//		DLog(@"ret = %d",ret);
		if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withError:)]) {
			NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"故事下载次数上报出错啦" forKey:@"kErrorMsg"];
			NSError *error = [NSError errorWithDomain:@"local stories count error" code:7736 userInfo:userInfo];
			[_actionDelegate onAction:self withError:error];
		}
	}
}


@end
