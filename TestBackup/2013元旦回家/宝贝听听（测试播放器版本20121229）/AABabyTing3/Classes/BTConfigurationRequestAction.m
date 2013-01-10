//
//  BTConfigurationRequestAction.m
//  AABabyTing3
//
//  Created by Zero on 9/9/12.
//
//

#import "BTConfigurationRequestAction.h"
#import "BTConfigurationRequestService.h"


@implementation BTConfigurationRequestAction

- (void)start {
//	//若没有值，则赋初始值
//	NSNumber *numMaxLocal = [BTUserDefaults valueForKey:CONFIGURATION_MAX_LOCAL_STORY];
//	if (nil == numMaxLocal) {
//		[BTUserDefaults setInteger:100
//							forKey:CONFIGURATION_MAX_LOCAL_STORY];//默认为100首上限
//	}
    
    [BTUtilityClass configeMaxLocalStoriesCount];
	
	NSNumber *numNextReqTime = [BTUserDefaults valueForKey:CONFIGURATION_NEXT_REQUEST_TIME];
	if (nil == numNextReqTime) {
		[BTUserDefaults setInteger:24*3600
							forKey:CONFIGURATION_NEXT_REQUEST_TIME];//默认为24小时
	}
	BOOL ask = NO;
	id lastDate = [BTUserDefaults valueForKey:CONFIGURATION_LAST_REQUEST_TIME];
    if (lastDate == nil) {
        ask = YES;
    } else {
        id interVal = [BTUserDefaults valueForKey:CONFIGURATION_NEXT_REQUEST_TIME];
        if (interVal == nil) {
            ask = YES;
        }else {
            NSDate *date = [NSDate date];
            double time = [date timeIntervalSince1970];
            int value = (int)time;
            int lastValue = [lastDate intValue];
            int interValue = [interVal intValue];
            if (value > lastValue + interValue) {
                ask = YES;
            }
        }
    }
	
	if (!ask) {
		return;
	}
	
	_service = [[BTConfigurationRequestService alloc] init];
	_service.serviceDelegate = self;
	[super start];
}

- (void)dealloc {
	[_service release];
	_service = nil;
	[super dealloc];
}

#pragma mark -
/*
 "max_local_story" = 100;		//本地允许的最大故事数
 "next_change_res" = 14400;		//316
 "next_clear_catch" = 14400;	//清空dataManager
 "next_req_time" = 86400;		//302
*/
- (void)receiveData:(NSDictionary *)data {
	NSError *error = [super onError:data];
	if (nil == error) {
		//成功
		NSDate *date = [NSDate date];
		double time = [date timeIntervalSince1970];
		int nowTime = (int)time;
		NSNumber *value = [NSNumber numberWithInt:nowTime];
		[BTUserDefaults setValue:value forKey:CONFIGURATION_LAST_REQUEST_TIME];
		
		
		NSDictionary *reponseDic = [data dictionaryForKey:CONFIGURATION_RESPONSE];
		
		NSNumber *maxLocalStory = [reponseDic numberForKey:CONFIGURATION_MAX_LOCAL_STORY];
		[BTUserDefaults setValue:maxLocalStory forKey:CONFIGURATION_MAX_LOCAL_STORY];
		
		NSNumber *nextReqTime = [reponseDic numberForKey:CONFIGURATION_NEXT_REQUEST_TIME];
		[BTUserDefaults setValue:nextReqTime forKey:CONFIGURATION_NEXT_REQUEST_TIME];
		
		NSNumber *resUpdateTime = [reponseDic numberForKey:CONFIGURATION_RESOURCE_UPDATE];
		[BTUserDefaults setValue:resUpdateTime forKey:CONFIGURATION_RESOURCE_UPDATE];
		
		NSNumber *clearData = [reponseDic numberForKey:CONFIGURATION_CLEAR_DATA_MANAGER];
		[BTUserDefaults setValue:clearData forKey:CONFIGURATION_CLEAR_DATA_MANAGER];
		
		if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withData:)]) {
			[_actionDelegate onAction:self withData:data];
		}
	}
}

@end
