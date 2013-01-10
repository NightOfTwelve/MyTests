//
//  BTFeedback2ViewController.m
//  AABabyTing3
//
//  Created by Zero on 9/11/12.
//
//

#import "BTFeedback2ViewController.h"
#import "BTFeedbackView.h"

@interface BTFeedback2ViewController ()
{
	UIScrollView		*_scrollView;
}
@end

@implementation BTFeedback2ViewController
- (id)init
{
	self = [super init];
    if (self) {
		_scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
		_scrollView.userInteractionEnabled = YES;
		_scrollView.alwaysBounceVertical = YES;
		_scrollView.scrollEnabled = YES;
		_scrollView.delegate = self;
		
		BTFeedbackView *feedbackView = [[BTFeedbackView alloc] init];
		[_scrollView addSubview:feedbackView];
		[feedbackView release];
    }
    return self;
}

- (void)dealloc {
	[_scrollView release];
	[super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.view addSubview:_scrollView];
	self.tableView.userInteractionEnabled = NO;
	[self.view insertSubview:_ropeView belowSubview:_scrollView];
}

- (void)viewWillAppear:(BOOL)animated {
	actionState = ACTION_NOTNEED;
	[super viewWillAppear:animated];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat scrollDistance = offsetY -_lastScrollOffsetY;
    _lastScrollOffsetY = offsetY;
    _ropeViewHeight = _ropeViewHeight - scrollDistance;
    _ropeView.frame = CGRectMake(0,0, _ropeView.frame.size.width, _ropeViewHeight);
}

@end
