//
//  BTRecord.h
//  TestCoreData
//
//  Created by Song Zhipeng on 1/6/13.
//  Copyright (c) 2013 Song Zhipeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BTRecord : NSManagedObject

@property (nonatomic) int32_t eventID;
@property (nonatomic) int32_t targetID;
@property (nonatomic) int32_t value;
@property (nonatomic) int32_t timeStamp;

+ (NSArray *)findByEventID:(int32_t)anEventID
			   andTargetID:(int32_t)aTargetID
			  andTimeStamp:(int32_t)aTimeStamp
					 error:(NSError **)anError;

@end
