//
//  BTProgressIndicator.m
//  AABabyTing3
//
//  Created by  on 12-8-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTProgressIndicator.h"

@implementation BTProgressIndicator

@synthesize progressView = _progressView;
@synthesize label = _label;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initProgressView{
    self.progressView = [[[BTProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault] autorelease];
    _progressView.frame = CGRectMake(0, self.frame.size.height*2/3, self.frame.size.width - 60, 8.0);
    _progressView.progress = 0.0f;
    [self addSubview:_progressView];
}
-(void)initLabel{
    _label = [[UILabel alloc] initWithFrame:CGRectMake(_progressView.frame.size.width+2, self.frame.size.height*2/3-5, 60, 15)];
    _label.textAlignment = UITextAlignmentLeft;
    _label.textColor = [UIColor colorWithRed:0.616 green:0.506 blue:0.373 alpha:1.0];
    //    _label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
    _label.font = [UIFont boldSystemFontOfSize:12.0];
    _label.backgroundColor = [UIColor clearColor];
    [self addSubview:_label];
}

-(void)initView{
    [self initProgressView];
    [self initLabel];
}

-(void)setProgress:(float)progress{
    [_progressView setProgress:progress];

    if (progress != 1.0) {
        int percent = progress * 100;
        _label.text = [NSString stringWithFormat:@"%d%%",percent];
        
    } 
}

-(void)dealloc{
    [_progressView release];
    _progressView  = nil;
    [_label release];
    _label = nil;
    [super dealloc];
}


@end
