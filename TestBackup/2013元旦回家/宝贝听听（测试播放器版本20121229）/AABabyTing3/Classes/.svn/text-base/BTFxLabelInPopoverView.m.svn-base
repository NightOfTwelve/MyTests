//
//  BTFxLabelInPopoverView.m
//  AABabyTing3
//
//  Created by Tiny on 12-11-27.
//
//

#define YELLOW_COLOR	([UIColor colorWithRed:0.98f green:0.72f blue:0.3f alpha:1.0f])
#define WHITE_COLOR		([UIColor whiteColor])

#import "BTFxLabelInPopoverView.h"

@implementation BTFxLabelInPopoverView
@synthesize underlineImageView = _underlineImageView;
@synthesize selected = _selected;

- (void)setSelected:(BOOL)selected {
	if (_selected != selected) {
		_selected = selected;
		UIImage *image = nil;
		if (_selected) {
			self.textColor = YELLOW_COLOR;
			image = [UIImage imageNamed:@"ranklist_menu_underline_selected.png"];
		} else {
			self.textColor = WHITE_COLOR;
			image = [UIImage imageNamed:@"ranklist_menu_underline.png"];
		}
		[_underlineImageView setImage:image];
	}
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor clearColor];
		self.font = [UIFont boldSystemFontOfSize:22];
		self.adjustsFontSizeToFitWidth = YES;
		self.minimumFontSize = 17.0;
		self.textAlignment = NSTextAlignmentCenter;
		self.userInteractionEnabled = YES;
		self.shadowOffset = CGSizeZero;
		self.shadowBlur = 4.0f;
		self.oversampling = 2;
		self.alpha = .9;
		self.textColor = WHITE_COLOR;
		
		UIImage *image = [UIImage imageNamed:@"ranklist_menu_underline.png"];
		_underlineImageView = [[UIImageView alloc] initWithImage:image];
		_underlineImageView.frame = CGRectMake(21, 36, 149, 1);
		[self addSubview:_underlineImageView];
		
		_selected = NO;
	}
	return self;
}

- (void)dealloc {
	[_underlineImageView release];
	[super dealloc];
}

@end
