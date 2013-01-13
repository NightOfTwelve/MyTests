//
//  BTStatisticsRecord.h
//  DemoStatistics
//
//  Created by Song Zhipeng on 1/13/13.
//  Copyright (c) 2013 Song Zhipeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BTStatisticsRecord : NSManagedObject

@property (nonatomic) int32_t eventID;
@property (nonatomic) int32_t targetID;
@property (nonatomic, retain) NSString * message;
@property (nonatomic) NSTimeInterval timestamp;

@end
