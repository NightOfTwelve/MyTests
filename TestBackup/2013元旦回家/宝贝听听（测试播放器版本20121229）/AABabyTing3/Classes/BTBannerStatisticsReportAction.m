//
//  BTBannerStatisticsReportAction.m
//  AABabyTing3
//
//  Created by Zero on 11/3/12.
//
//

#import "BTBannerStatisticsReportAction.h"
#import "BTBannerClickedStatisticsAction.h"
#import "BTBannerStatisticsReportService.h"

@implementation BTBannerStatisticsReportAction
- (void)start {
	NSString *filePath = [BTBannerClickedStatisticsAction filePath];
	NSDictionary *info = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
	CDLog(BTDFLAG_BANNER,@"to report:%@",info);
	//如果没有需要上报的
	if (info==nil || info.count==0) {
		CDLog(BTDFLAG_BANNER,@"nothing to report.");
		return;
	}
	
	_service = [[BTBannerStatisticsReportService alloc] initWithRequestInfo:info];
	_service.serviceDelegate = self;
	
	[super start];
}

- (void)receiveData:(NSDictionary *)data {
	NSError *error = data[NOTIFICATION_ERROR];
	if (error == nil) {//成功
		//清空累计数据
		NSString *filePath = [BTBannerClickedStatisticsAction filePath];
		NSMutableDictionary *info = [NSMutableDictionary dictionary];
		[NSKeyedArchiver archiveRootObject:info toFile:filePath];
		
		if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withData:)]) {
			[_actionDelegate onAction:self withData:nil];//此处数据不需要抛给上层（上层没有使用）
		}
	} else {//失败
		if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withError:)]) {
			[_actionDelegate onAction:self withError:nil];//此处不抛错误（上层没有使用）
		}
	}
}
@end
