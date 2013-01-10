//
//  ZZRecord.h
//  ZZPokerRoller1
//
//  Created by Zero on 1/10/13.
//  Copyright (c) 2013 21kunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ZZRecord : NSManagedObject

@property (nonatomic) int32_t id;
@property (nonatomic, copy) NSString * message;
@property (nonatomic) NSTimeInterval timestamp;

@end
