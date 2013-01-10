//
//  BTHotStoryService.h
//  AABabyTing3
//
//  Created by  on 12-9-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTBaseService.h"

@interface BTHotStoryService : BTBaseService
@property (nonatomic, assign)	NSInteger	homeID;
@property (nonatomic, assign)	NSInteger	lastID;
@property (nonatomic, assign)	NSInteger	rankID;
- (id)initWithHomeID:(NSInteger)homeID lastID:(NSInteger)lastID rankID:(NSInteger)rankID;
@end
