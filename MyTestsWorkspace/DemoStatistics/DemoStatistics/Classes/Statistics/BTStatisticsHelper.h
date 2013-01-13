//
//  BTStatisticsHelper.h
//  DemoStatistics
//
//  Created by Song Zhipeng on 1/13/13.
//  Copyright (c) 2013 Song Zhipeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTStatisticsHelper : NSObject

+ (BOOL)addRecordWithEventID:(NSInteger)anEventID
					targetID:(NSInteger)aTargetID;

+ (BOOL)addRecordWithEventID:(NSInteger)anEventID
					targetID:(NSInteger)aTargetID
					 message:(NSString *)aMessage;

@end
