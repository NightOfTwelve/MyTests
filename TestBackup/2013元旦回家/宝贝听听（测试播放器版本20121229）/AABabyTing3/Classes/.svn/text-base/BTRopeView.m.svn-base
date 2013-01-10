//
//  BTRopeView.m
//  AABabyTing3
//
//  Created by Neo Wang on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTRopeView.h"

@implementation BTRopeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)dealloc{
    [_ropeView release];
    [super dealloc];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    _ropeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ropeView.png"]];
    _ropeView.frame = CGRectMake(0, 10, 320, self.frame.size.height);
    [self addSubview:_ropeView];
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    _ropeView.frame = CGRectMake(0, 10, 320, self.frame.size.height);
    //_imgRight.frame = CGRectMake(304, 0, 320, self.frame.size.height);
}

@end
