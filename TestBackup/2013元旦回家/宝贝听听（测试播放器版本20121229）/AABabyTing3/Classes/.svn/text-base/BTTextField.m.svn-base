//
//  BTTextField.m
//  AABabyTing3
//
//  Created by Wang Neo on 12-9-25.
//
//

#import "BTTextField.h"

#define HEXCOLORAL(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF000000) >> 24))/255.0 green:((float)((rgbValue & 0xFF0000) >> 16))/255.0 blue:((float)((rgbValue & 0xFF00) >> 8))/255.0  alpha:((float)(rgbValue & 0xFF))/255.0 ]


@implementation BTTextField
@synthesize type;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) drawPlaceholderInRect:(CGRect)rect {
    switch (type) {
        case SearchType:
            [[UIColor colorWithRed:210.0/255.0 green:163.0/255.0 blue:40.0/255.0 alpha:1.0f] setFill];
            [[self placeholder] drawInRect:rect withFont:[UIFont boldSystemFontOfSize:20]];
            break;
        case FeedBackTpe:
            [[UIColor colorWithRed:55.0/255.0 green:128.0/255.0 blue:189.0/255.0 alpha:1.0f] setFill];
            [[self placeholder] drawInRect:rect withFont:[UIFont systemFontOfSize:17]];
            break;
        default:
            break;
    }


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
