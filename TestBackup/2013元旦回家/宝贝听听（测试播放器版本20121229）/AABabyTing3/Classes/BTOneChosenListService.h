//
//  BTOneChosenListService.h
//  AABabyTing3
//
//  Created by  on 12-9-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTBaseService.h"

@interface BTOneChosenListService : BTBaseService{
    
      NSInteger _bookId;
    NSInteger _lastStoryId;
//    NSInteger _requestCount;
}
@property (nonatomic,assign) NSInteger bookId;

-(id)initWithBookId:(int)bookId lastID:(NSInteger)lastID;

@end
