//
//  BTOneRadioStoryListService.h
//  AABabyTing3
//
//  Created by Wang Neo on 12-9-3.
//
//

#import "BTBaseService.h"

@interface BTOneRadioStoryListService : BTBaseService{
    NSInteger _radioID;
    NSInteger _requestCount;
    NSArray *_historyArray;
}

- (id)initWithRadioID:(NSInteger)radioID history:(NSArray *)history requestCount:(NSInteger)count;
@end
