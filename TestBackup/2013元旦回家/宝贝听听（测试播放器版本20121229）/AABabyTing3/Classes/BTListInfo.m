//
//  BTListInfo.m
//  AABabyTing3
//
//  Created by Wang Neo on 12-9-5.
//
//

#import "BTListInfo.h"

@implementation BTListInfo

- (NSInteger)countInDataManager {
	return _result.count;
}

- (id)init{
    self = [super init];
    if(self){
        _result = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc{
    [_result release];
    [super dealloc];
}

@end
