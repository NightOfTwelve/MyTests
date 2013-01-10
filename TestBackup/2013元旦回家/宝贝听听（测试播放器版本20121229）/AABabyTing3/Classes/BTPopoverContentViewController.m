//
//  BTPopoverContentViewController.m
//  testPopoverController
//
//  Created by Zero on 11/6/12.
//  Copyright (c) 2012 songzhipeng. All rights reserved.
//

#import "BTPopoverContentViewController.h"

#define YELLOW_COLOR	([UIColor colorWithRed:0.98f green:0.72f blue:0.3f alpha:1.0f])
#define WHITE_COLOR		([UIColor whiteColor])

@implementation BTRankCategory
+ (id)rankCategoryWithRequestId:(NSInteger)theRequestId andName:(NSString *)theName {
	return [[[[self class] alloc] initWithRequestId:theRequestId andName:theName] autorelease];
}
- (id)initWithRequestId:(NSInteger)theRequestId andName:(NSString *)theName {
	self = [super init];
	if (self) {
		self.name = theName;
		_requestId = theRequestId;
		self.lastId = 0;
	}
	return (self);
}
- (void)dealloc {
	[_name release];
	[super dealloc];
}
@end//@implementation BTRankCategory


#pragma mark - 定制FXLabel

@interface BTRankLabel : FXLabel
@property (nonatomic,assign)	BOOL selected;
@end

@interface BTRankLabel ()
@property (nonatomic,retain)	UIImageView *underlineImageView;
@end
@implementation BTRankLabel
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


#pragma mark - BTPopoverContentViewController

@interface BTPopoverContentViewController ()
@property (nonatomic, retain)	NSMutableArray *labels;
@property (nonatomic, retain)	NSMutableArray *rankCategories;
@end

@implementation BTPopoverContentViewController

- (void)dealloc {
	//删除label上的gesture，需要手动删除么？有没有简单的方法？
	self.labels = nil;
	self.rankCategories = nil;
	[super dealloc];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
	//如果点击“已选中项”，刷新当前页面
	
	if (self.labels != nil) {
		//取消选中状态
		{
			BTRankLabel *label = self.labels[_selectedIndex];
			label.selected = NO;
		}
		
		//设置选中状态
		{
			BTRankLabel *label = self.labels[selectedIndex];
			label.selected = YES;
		}
	}
	
	_selectedIndex = selectedIndex;

}

- (id)initWithRankCategories:(NSMutableArray *)rankCategories{
	if (self = [super init]) {
		self.rankCategories = rankCategories;
	}
	return (self);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.view.backgroundColor = [UIColor clearColor];
	UIImage *bgImage = [UIImage imageNamed:@"ranklist_menu_background.png"];
	UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
	bgImageView.frame = CGRectMake(0, 0, 191, 188);
	[self.view addSubview:bgImageView];
	[bgImageView release];
	
	self.labels = [NSMutableArray arrayWithCapacity:4];
	for (int i=0; i<4; i++) {
		BTRankLabel *label = [[BTRankLabel alloc] initWithFrame:CGRectMake(0, 15+i*40, 191, 40)];
		BTRankCategory *rankCategory = self.rankCategories[i];
		label.text = rankCategory.name;
		label.tag = i;
		label.selected = (i == self.selectedIndex);
		
		UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureFrom:)];
		[label addGestureRecognizer:tapGes];
		[tapGes release];
		
		[self.view addSubview:label];
		[self.labels addObject:label];
		[label release];
	}
}

- (void)handleTapGestureFrom:(UITapGestureRecognizer *)tapGes {
	self.selectedIndex = tapGes.view.tag;
	//通知排行榜ViewController切换
	if (_delegate && [_delegate respondsToSelector:@selector(didSelectedAtIndex:)]) {
		CDLog(BTDFLAG_RANKLIST,@"_selectedIndex:%d",_selectedIndex);
		[_delegate didSelectedAtIndex:_selectedIndex];
	}
}

#undef YELLOW_COLOR
#undef WHITE_COLOR

@end
