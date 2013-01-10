//
//  BTRQDReport.m
//  AABabyTing3
//
//  Created by Zero on 9/6/12.
//
//

#import "BTRQDReport.h"
#import <Analytics/AnalyticsInterface.h>

@implementation BTRQDReport

+ (void)reportCid:(RequesrTypeCid)cid beginDate:(NSDate *)beginDate succeed:(BOOL)isSucceed {
    NSString *eventName = [BTRQDReport getEventNameWithRequestCid:cid];
	NSTimeInterval beginTime = [beginDate timeIntervalSince1970];
	NSDate *endDate = [NSDate date];
	NSTimeInterval endTime = [endDate timeIntervalSince1970];
	NSTimeInterval elapse = (endTime - beginTime) * 1000;//s -> ms
    [BTRQDReport reportUserAction:eventName isSucceed:isSucceed elapse:elapse size:0];
}

+ (void)reportUserAction:(NSString *)eventName{
	if(RQD_SWITCH){
		[AnalyticsInterface onUserAction:eventName
							   isSucceed:YES
								  elapse:0
									size:0
								  params:nil];
	}
}

+ (void)reportUserAction:(NSString *)eventName isSucceed:(BOOL) isSucceed elapse:(long)elapse size:(long)size{
	if(RQD_SWITCH){
		[AnalyticsInterface onUserAction:eventName
							   isSucceed:isSucceed
								  elapse:elapse
									size:size
								  params:nil];
	}
}

+ (NSString *)getEventNameWithRequestCid:(RequesrTypeCid)cid{
	switch (cid) {
		case cid_301:
			return cid301;
		case cid_302:
			return cid302;
		case cid_303:
			return cid303;
		case cid_304:
			return cid304;
		case cid_305:
			return cid305;
		case cid_306:
			return cid306;
		case cid_307:
			return cid307;
		case cid_308:
			return cid308;
		case cid_309:
			return cid309;
		case cid_310:
			return cid310;
		case cid_311:
			return cid311;
		case cid_312:
			return cid312;
		case cid_313:
			return cid313;
		case cid_315:
			return cid315;
		case cid_316:
			return cid316;
		case cid_317:
			return cid317;
		case cid_318:
			return cid318;
		case cid_319:
			return cid319;
		case cid_314:
		default:
			return @"";
	}
}

@end
