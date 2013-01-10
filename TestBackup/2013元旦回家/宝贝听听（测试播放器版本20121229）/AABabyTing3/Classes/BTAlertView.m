//
//  BTAlertView.m
//  AABabyTing3
//
//  Created by Zero on 9/4/12.
//
//

#import "BTAlertView.h"

@implementation BTAlertView
@synthesize userInfo;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc {
	[userInfo release];
	[super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
