//
//  BTHotStoryAction.h
//  AABabyTing3
//
//  Created by Neo Wang on 12-8-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTBaseAction.h"

@interface BTHotStoryAction : BTBaseAction
@property (nonatomic, assign)	NSInteger homeID;
@property (nonatomic, assign)	NSInteger lastID;
@property (nonatomic, assign)	NSInteger rankID;
- (id)initWithHomeID:(NSInteger)homeID lastID:(NSInteger)lastID rankId:(NSInteger)rankID;

@end
