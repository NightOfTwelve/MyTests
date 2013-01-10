//
//  BTChosenAction.h
//  AABabyTing3
//
//  Created by Neo Wang on 12-8-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTBaseAction.h"

@interface BTChosenAction : BTBaseAction
{
    NSInteger                       _homeID;
    NSInteger                       _len;
    NSInteger                       _latID;
}
- (id)initWithHomeID:(NSInteger )homeID visibleLen:(NSInteger)len lastID:(NSInteger)lastID;

@end
