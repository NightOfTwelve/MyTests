//
//  BTLocalStoriesCountAction.m
//  AABabyTing3
//
//  Created by Zero on 9/5/12.
//
//

#import "BTLocalStoriesCountAction.h"
#import "BTLocalStoriesCountService.h"
#import "LastSavedDateComparisonAndModification.h"

@interface BTLocalStoriesCountAction ()
@end

@implementation BTLocalStoriesCountAction

- (void)dealloc {
//	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

- (void)start {
	
	
	//判断今天是否成功上传过
	if ([LastSavedDateComparisonAndModification isLastReportedLocalStoryCountDateToday]) {
//		DLog(@"repeat report: count");
		return;
	}
	
	//获取本地故事数量
	NSString *localfilePath = [BTUtilityClass fileWithPath:LOCALSTORY_PLIST_NAME_NEW];
    NSMutableArray *localArray = [NSMutableArray arrayWithContentsOfFile:localfilePath];
	NSString *countOfLocalStoriesStr = [NSString stringWithFormat:@"%u",[localArray count]];
	DLog(@"Zero: countOfLocalStoriesStr = %u",[localArray count]);
	if ([countOfLocalStoriesStr isEqualToString:@""]) {
		//获取失败，不需要上报了
		DLog(@"Zero:get local story count failed!");
		return;
	}
	
	//"10"是本地故事上报的Key值
	NSDictionary *info = [NSDictionary dictionaryWithObject:countOfLocalStoriesStr
													 forKey:@"10"];
		
	_service = [[BTLocalStoriesCountService alloc] initWithRequestInfo:info];
	_service.serviceDelegate = self;

	[super start];
}

- (void)receiveData:(NSDictionary *)data {
	
	NSDictionary *userInfo = data;
	int ret = [[userInfo valueForKey:JSON_NAME_RET] intValue];
	if (ret == 100) {
		//成功上报，标记最后上报日期为今天
		[LastSavedDateComparisonAndModification setLastReportedLocalStoryCountDateToday];
		
		if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withData:)]) {
			[_actionDelegate onAction:self withData:userInfo];
		}
//		DLog(@"local stories count report succeed!");
	} else {
//		DLog(@"local stories count report failed!");
//		DLog(@"ret = %d",ret);
		if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withError:)]) {
			NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"本地故事数量上报出错啦" forKey:@"kErrorMsg"];
			NSError *error = [NSError errorWithDomain:@"local stories count error" code:7735 userInfo:userInfo];
			[_actionDelegate onAction:self withError:error];
		}
	}
}

@end
