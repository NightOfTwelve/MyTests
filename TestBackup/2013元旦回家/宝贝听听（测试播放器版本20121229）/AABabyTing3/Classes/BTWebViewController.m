//
//  BTWebViewController.m
//  AABabyTing3
//
//  Created by Zero on 9/4/12.
//
//

#import "BTWebViewController.h"
#import "BTAppDelegate.h"
#import "BTWebView.h"

const CGFloat kSpaceHeight = 44.0f;

@interface BTWebViewController ()
//@property (nonatomic, retain)	UIWebView	*theWebView;
@property (nonatomic,retain) BTWebView *theWebView;
@end

@implementation BTWebViewController

#pragma mark - 加载WebView
- (void)loadWebView:(NSString *)aUrlStr {
    
    //----------------modify by tiny begin :统一给webView添加等待和错误提示
    
//	if (nil == _theWebView) {
//		CGSize winSize = [UIScreen mainScreen].bounds.size;
//		_theWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kSpaceHeight, winSize.width, winSize.height-kSpaceHeight)];
//		CDLog(BTDFLAG_IPHONE5,@"self.view.frame.size.height:%f",self.view.frame.size.height);
//		CDLog(BTDFLAG_IPHONE5,@"%f",winSize.height);
//		_theWebView.scalesPageToFit = YES;
//		[self.view addSubview:_theWebView];
//	}
//	_theWebView.hidden = NO;
//	_theWebView.delegate = self;
//	
//	for (UIView *subview in [_theWebView subviews]) {
//		UIScrollView *scrollView = (UIScrollView*)subview;
//		scrollView.bounces = NO;
//	}
//	
//	NSURL *url = [NSURL URLWithString:aUrlStr];
//	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
//	[_theWebView loadRequest:urlRequest];
    
    if (nil == _theWebView) {
        CGSize winSize = [UIScreen mainScreen].bounds.size;
        _theWebView = [[BTWebView alloc] initWithFrame:CGRectMake(0, kSpaceHeight, winSize.width, winSize.height-kSpaceHeight - 20)];
        _theWebView.bIsNeedToShowWaiting = NO;
        [self.view addSubview:_theWebView];
    }

    //设置UIWebView边界不反弹
    for (id subview in [_theWebView.webView subviews]){
        if ([[subview class] isSubclassOfClass: [UIScrollView class]])
            ((UIScrollView *)subview).bounces = NO;
    }
	
    [_theWebView loadWebRequest:[NSURL URLWithString:aUrlStr]];
    
    //----------------modify by tiny end
}

#pragma mark - 设置url
- (void)setUrlStr:(NSString *)aUrlStr {
	[_urlStr release];
	_urlStr = [aUrlStr copy];
	[self loadWebView:_urlStr];
}

#pragma mark - 显示/隐藏下方的TabBar
- (void)setHideBottomBar:(BOOL)bHidden {
	BTAppDelegate *delegate = (BTAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.tabCtr.customTabBarView setHidden:bHidden];
	[delegate.tabCtr.customTabBarView setUserInteractionEnabled:!bHidden];
    [delegate hideTabBar:bHidden];
}

- (void)setHideBackButton:(BOOL)bHidden {
//	DLog(@"backButton:%@",self.backButton);
	self.backButton.hidden = bHidden;
	self.backButton.enabled = !bHidden;
}

#pragma mark - LifeCycle

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
////		[self loadWebView:nil];
//    }
//    return self;
//}

- (id)initWithUrl:(NSString *)aUrlStr {
	if (self = [super init]) {
//		self.view.frame = [UIScreen mainScreen].bounds;
		self.urlStr = aUrlStr;
	}
	return self;
}

- (void)dealloc {
	[_theWebView release];
	[_urlStr release];
	[super dealloc];
}

- (void)viewDidLoad
{
	
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	[self setHideBackButton:NO];
	[self setHideBottomBar:YES];
//	self.title = self.titleStr;
//	self.viewTitle = (FXLabel *)[self.navigationController.view viewWithTag:TAG_TitleView];
//	self.viewTitle.text = self.title = self.titleStr;
//	self.viewTitle.hidden = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	[self setHideBackButton:NO];
	[self setHideBottomBar:YES];
	self.viewTitle.hidden = NO;
	UIView *editButton  = [self.navigationController.view viewWithTag:TAG_EDITOR_BUTTON];
	if(editButton){
		editButton.hidden = YES;
	}
//	self.playingButton.hidden = YES;
//	UIButton *playingButton = (UIButton *)[self.navigationController.view viewWithTag:TAG_PLAYING_BUTTON];
	if (self.playingButton) {
		self.playingButton.hidden = YES;
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self setHideBottomBar:NO];
	
	UIView *editButton  = [self.navigationController.view viewWithTag:TAG_EDITOR_BUTTON];
	if(editButton){
		editButton.hidden = NO;
	}
	
//	UIButton *playingButton = (UIButton *)[self.navigationController.view viewWithTag:TAG_PLAYING_BUTTON];
	if (self.playingButton) {
		if ([BTPlayerManager sharedInstance].playList || [BTPlayerManager sharedInstance].storyType == StoryType_Radio) {
			self.playingButton.hidden = NO;
		}
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
