//
//  BTNavButton.m
//  AABabyTing3
//
//  Created by Wang Neo on 12-9-12.
//
//

#import "BTNavButton.h"

@implementation BTNavButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setExclusiveTouch:YES];
    }
    return self;
}

- (void)remoteAllTargetAndActionsForControlEvents:(UIControlEvents)event{
    NSSet *targetSets = [self allTargets];
    NSArray *targetArrays = [targetSets allObjects];
    for(id target in targetArrays){
        [self removeTarget:target action:NULL forControlEvents:event];
    }
}

- (void)dealloc{
    [super dealloc];
}


@end
