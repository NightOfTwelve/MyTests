//
//  BTRQDReport.h
//  AABabyTing3
//
//  Created by Zero on 9/6/12.
//
//

//
//  BTRQDReport.h
//  BabyTing
//
//  Created by Neo on 12-5-17.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTRQDConstant.h"

//区分不同的request的cid
typedef enum {
	cid_301 = 301,
	cid_302 = 302,
	cid_303 = 303,
	cid_304 = 304,
	cid_305 = 305,
	cid_306 = 306,
	cid_307 = 307,
	cid_308 = 308,
	cid_309 = 309,
	cid_310 = 310,
	cid_311 = 311,
	cid_312 = 312,
	cid_313 = 313,
	cid_314 = 314,
	cid_315 = 315,
	cid_316 = 316,
	cid_317 = 317,
	cid_318 = 318,
	cid_319 = 319,
	cid_none = 999
}RequesrTypeCid;

@interface BTRQDReport : NSObject {
	
}

+ (void)reportCid:(RequesrTypeCid)cid beginDate:(NSDate *)beginDate succeed:(BOOL)isSucceed;

+ (void)reportUserAction:(NSString *)eventName;

+ (void)reportUserAction:(NSString *)eventName isSucceed:(BOOL) isSucceed elapse:(long) elapse size:(long)size;

+ (NSString *)getEventNameWithRequestCid:(RequesrTypeCid)cid;

@end
