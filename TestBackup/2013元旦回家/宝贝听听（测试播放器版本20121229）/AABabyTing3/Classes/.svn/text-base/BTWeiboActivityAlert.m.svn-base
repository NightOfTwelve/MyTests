//
//  BTWeiboActivityAlert.m
//  BabyTing
//
//  Created by Neo Wang on 12-7-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTWeiboActivityAlert.h"

@implementation BTWeiboActivityAlert

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (id)initWithMessage:(NSString *)message runurl:(NSString *)runUrl{
    self = [super init];
    if(self){
        self.frame = CGRectMake(0, 0, WINDOW_HEIGHT, 320);
        
        activityStr = runUrl;
        
        UIView *cleanView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_HEIGHT, 320)];
        [cleanView setBackgroundColor:[UIColor blackColor]];
        [cleanView setAlpha:0.5];
		[self addSubview:cleanView];
		[cleanView release];
        
        UIView *popView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_HEIGHT, 320)] autorelease];
        popView.backgroundColor = [UIColor clearColor];
		[self addSubview:popView];
        
        UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weiboActBg.png"]];
        bgView.frame  = CGRectMake(56, 75, 368, 171);
        [popView addSubview:bgView];
        [bgView release];
        
        UIButton *backButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setFrame:CGRectMake(118, 230, 93, 33)];
        [backButton setImage:[UIImage imageNamed:@"weiboActClose.png"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(alertbackPress) forControlEvents:UIControlEventTouchUpInside];
        [popView addSubview:backButton];
        
        UIButton *actButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [actButton setFrame:CGRectMake(268, 230, 93, 33)];
        [actButton setImage:[UIImage imageNamed:@"weiboToAct.png"] forState:UIControlStateNormal];
        [actButton addTarget:self action:@selector(alertActPress) forControlEvents:UIControlEventTouchUpInside];
        [popView addSubview:actButton];
        

        
//        NSString *str = @"我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你我和你";
        UIFont *font = [UIFont fontWithName:LABEL_FONT_DEFAULT size:18];
        CGSize labelSize = [message sizeWithFont:font
                           constrainedToSize:CGSizeMake(288, MAXFLOAT) 
                                lineBreakMode:UILineBreakModeCharacterWrap];
        
        UIScrollView *popScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(103, 140, 288, 90)];
        popScrollView.backgroundColor = [UIColor clearColor];
       // popScrollView.contentSize = CGSizeMake(288, 110);
        [popScrollView setContentSize:CGSizeMake(labelSize.width, labelSize.height)];
        popScrollView.showsHorizontalScrollIndicator = NO;
        popScrollView.showsVerticalScrollIndicator = NO;
        if (labelSize.height > 90) {
            popScrollView.scrollEnabled = NO;
            popScrollView.pagingEnabled = NO;
        }else{
            popScrollView.pagingEnabled = YES;
            popScrollView.scrollEnabled = YES;
        }
        popScrollView.delegate=self;
        popScrollView.pagingEnabled = YES;
        popScrollView.scrollEnabled = YES;
        //popScrollView.backgroundColor = [UIColor blackColor];
        [popView addSubview:popScrollView];
        [popScrollView release];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,labelSize.width, labelSize.height)];
        //label.backgroundColor = [UIColor blackColor];
        UIColor *color = [UIColor colorWithRed:0.0f green:0.27f blue:0.47 alpha:1.0f];
        label.backgroundColor = [UIColor clearColor];
        label.text = message;
        label.textColor=color;
        label.font = font;
        label.numberOfLines = 0;
        label.lineBreakMode = UILineBreakModeCharacterWrap; 
        [popScrollView addSubview:label];
        [label release];
        
    }
    return self;
}

- (void)alertbackPress{
    [self removeFromSuperview];
}

- (void)alertActPress{
    [self removeFromSuperview];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:activityStr]];
}

@end
