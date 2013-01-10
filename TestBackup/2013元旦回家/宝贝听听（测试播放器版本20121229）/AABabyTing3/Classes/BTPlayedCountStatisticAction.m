//
//  BTPlayedCountStatisticAction.m
//  AABabyTing3
//
//  Created by Zero on 9/5/12.
//
//

#import "BTPlayedCountStatisticAction.h"
#import "BTPlayedCountStatisticService.h"


@implementation BTPlayedCountStatisticAction

- (void)start {
	NSString *dataPath = [BTUtilityClass fileWithPath:RECORDPLAYCOUNT_PLIST_NAME];
    NSMutableArray *statisticsData = [NSMutableArray arrayWithContentsOfFile:dataPath];
//	CVLog(BTDFLAG_PlayedCountStatistics,@"statisticsData = %@",statisticsData);
//    DLog(@"statisticsData = %@",statisticsData);
	if (nil == statisticsData || 0 == statisticsData.count) {
		return;
	}
	_service = [[BTPlayedCountStatisticService alloc] initWithRequestInfo:statisticsData];
	_service.serviceDelegate = self;
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinish:) name:PLAYTIMES_UPLOAD_REQUEST_NOTIFICATION_CID object:_service];
	[super start];
}

- (void)dealloc {
//	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

- (void)receiveData:(NSDictionary *)data {
//	CDLog(BTDFLAG_PlayedCountStatistics,@"data:%@",data);
//    DLog(@"data:%@",data);
//	DLog(@"%@,data:%@",self,data);
	NSDictionary *userInfo = data;
	NSError *error = [userInfo valueForKey:NOTIFICATION_ERROR];
	if (error) {
//		DLog(@"播放次数统计上报返回出错:%@",error);
		return;
	}
	
	//清空统计文件
	NSString *dataPath = [BTUtilityClass fileWithPath:RECORDPLAYCOUNT_PLIST_NAME];
	NSMutableArray *array = [NSMutableArray array];
	[array writeToFile:dataPath atomically:YES];
	
	if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withData:)]) {
		[_actionDelegate onAction:self withData:nil];
	}
}

@end
