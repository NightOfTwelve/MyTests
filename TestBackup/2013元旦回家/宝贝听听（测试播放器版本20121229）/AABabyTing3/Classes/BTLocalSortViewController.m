//
//  BTLocalSortViewController.m
//  AABabyTing3
//
//  Created by Tiny on 12-11-27.
//
//

#import "BTLocalSortViewController.h"

@implementation BTLocalSortViewController
@synthesize labels = _labels;
@synthesize sortTitles = _sortTitles;
@synthesize delegate = _delegate;

- (id)initWithSortTitles:(NSMutableArray *)titles{
    
    self = [super init];
    if (self) {
        self.sortTitles = titles;
    }
    return self;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
	//如果点击“已选中项”，刷新当前页面
	
	if (self.labels != nil) {
		//取消选中状态
		{
			BTFxLabelInPopoverView *label = [_labels objectAtIndex:_selectedIndex];
			label.selected = NO;
		}
		
		//设置选中状态
		{
			BTFxLabelInPopoverView *label = [_labels objectAtIndex:selectedIndex];
			label.selected = YES;
		}
	}
	
	_selectedIndex = selectedIndex;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
	UIImage *bgImage = [UIImage imageNamed:@"ranklist_menu_background.png"];
	UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
	bgImageView.frame = CGRectMake(0, 0, 191, 148);
	[self.view addSubview:bgImageView];
	[bgImageView release];
	
	self.labels = [NSMutableArray arrayWithCapacity:[_sortTitles count]];
	for (int i=0; i<[_sortTitles count]; i++) {
		BTFxLabelInPopoverView *label = [[BTFxLabelInPopoverView alloc] initWithFrame:CGRectMake(0, 15+i*40, 191, 40)];
		label.text = [_sortTitles objectAtIndex:i];
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

	if (_delegate && [_delegate respondsToSelector:@selector(didSelectedAtIndex:)]) {
		[_delegate didSelectedAtIndex:_selectedIndex];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [_labels release];
    self.labels = nil;
    [_sortTitles release];
    [super dealloc];
}

@end
