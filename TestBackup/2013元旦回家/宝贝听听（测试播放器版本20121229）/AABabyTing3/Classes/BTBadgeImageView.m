//
//  BTBadgeImageView.m
//  AABabyTing3
//
//  Created by Dora on 12-11-28.
//
//

#import "BTBadgeImageView.h"

@implementation BTBadgeImageView

- (id)initWithText:(NSString *)text font:(UIFont *)font {
    UIImage *image = [UIImage imageNamed:@"downLoadNum.png"];
    image = [image stretchableImageWithLeftCapWidth:13 topCapHeight:5];
    
    CGSize size = [text sizeWithFont:font];
    size.width += 18;
    size.height = 23;
    CGRect frame = CGRectZero;
    frame.size = size;
    self = [super initWithFrame:frame];
    if (self) {
        self.image = image;
        [self addSubview:[self textLabel:text font:font]];
    }
    return (self);
}

- (UILabel *)textLabel:(NSString *)text font:(UIFont *)font {
    CGSize size = [text sizeWithFont:font];

    CGRect bounds = CGRectMake(0 , -1.0, size.width+15+2 , 21);
    UILabel *label = [[[UILabel alloc] initWithFrame:bounds] autorelease];
    label.text = text;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = font;
    label.textAlignment = UITextAlignmentCenter;
        
    return label;
}

@end

