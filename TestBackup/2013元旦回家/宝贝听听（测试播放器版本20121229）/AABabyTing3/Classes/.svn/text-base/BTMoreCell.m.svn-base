//
//  BTMoreCell.m
//  AABabyTing3
//
//  Created by Zero on 8/25/12.
//
//

#import "BTMoreCell.h"
#import "FXLabel.h"

@implementation BTMoreCell
@synthesize backButton = _backButton;
@synthesize myTextLabel,cellTag;

- (void)dealloc{
    [myTextLabel release];
    [_backButton release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(0, 0, 320, 57);
        [self insertSubview:_backButton atIndex:0];
		
		FXLabel *label = [[FXLabel alloc] initWithFrame:CGRectMake(60, 19, 200, 20)];
		label.backgroundColor = [UIColor clearColor];
		label.font = [UIFont boldSystemFontOfSize:17];
		label.textColor = [UIColor colorWithRed:6.0/255.0 green:59.0/255.0 blue:104.0/255.0 alpha:1.0];
		label.textAlignment = UITextAlignmentLeft;
		[self insertSubview:label aboveSubview:_backButton];
		myTextLabel = label;
		[label release];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    _backButton.highlighted = highlighted;
}

@end
