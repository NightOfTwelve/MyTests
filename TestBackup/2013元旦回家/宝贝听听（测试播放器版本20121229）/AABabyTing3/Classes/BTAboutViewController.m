//
//  BTAboutViewController.m
//  AABabyTing3
//
//  Created by Zero on 8/29/12.
//
//

#import "BTAboutViewController.h"
//#import "BTWebView.h"
#import "BTWebViewController.h"
#import "BTUtilityClass.h"
@interface BTAboutViewController ()

@end

@implementation BTAboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.tableView.userInteractionEnabled = NO;
    NSString *versionStr = [NSString stringWithFormat:@"v%@",[BTUtilityClass getBundleVersion]];
    versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(225, 97, 100, 20)];
    [versionLabel setTextAlignment:UITextAlignmentLeft];
    [versionLabel setText:versionStr];
    versionLabel.font = [UIFont boldSystemFontOfSize:18];
    [versionLabel setBackgroundColor:[UIColor clearColor]];
    [versionLabel setTextColor:[UIColor colorWithRed:6.0/255.0 green:59.0/255.0 blue:104.0/255.0 alpha:1.0]];
    [_theView addSubview:versionLabel];
	
	CGRect bounds = [UIScreen mainScreen].bounds;
	self.view.frame = bounds;
	_theView.center = self.view.center;
}

- (void)viewDidUnload
{
	[self setTheView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.view.userInteractionEnabled = YES;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	self.view.userInteractionEnabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)mailClicked:(id)sender {
	NSURL *url = [NSURL URLWithString:@"mailto://sjkp@21kunpeng.com"];
	[[UIApplication sharedApplication] openURL:url];
}

- (IBAction)websiteClicked:(id)sender {
//	NSURL *url = [NSURL URLWithString:@"http://www.21kunpeng.com"];
//	[[UIApplication sharedApplication] openURL:url];
//	[BTWebView openUrlInWebView:@"http://www.21kunpeng.com"
//				 withTitle:@"官方网站"];
	BTWebViewController *webVC = [[BTWebViewController alloc] initWithUrl:@"http://www.21kunpeng.com"];
	webVC.title = @"官方网站";
	self.viewTitle.text = @"官方网站";
	[self.navigationController pushViewController:webVC animated:NO];
	[webVC release];
}

- (IBAction)tencentWeiboClicked:(id)sender {
//	NSURL *url = [NSURL URLWithString:@"http://ti.3g.qq.com/touch/iphone/index.jsp#guest_home/u=Qbabyting"];
//	[[UIApplication sharedApplication] openURL:url];
//	[BTWebView openUrlInWebView:@"http://ti.3g.qq.com/touch/iphone/index.jsp#guest_home/u=Qbabyting"
//				 withTitle:@"腾讯官方微博"];
	BTWebViewController *webVC = [[BTWebViewController alloc] initWithUrl:@"http://ti.3g.qq.com/touch/iphone/index.jsp#guest_home/u=Qbabyting"];
	webVC.title = @"腾讯官方微博";
	self.viewTitle.text = @"腾讯官方微博";
	[self.navigationController pushViewController:webVC animated:NO];
	[webVC release];
}

- (IBAction)sinaWeiboClicked:(id)sender {
//	NSURL *url = [NSURL URLWithString:@"http://weibo.com/qbabyting"];
//	[[UIApplication sharedApplication] openURL:url];
//	[BTWebView openUrlInWebView:@"http://weibo.com/qbabyting"
//				 withTitle:@"新浪官方微博"];
	BTWebViewController *webVC = [[BTWebViewController alloc] initWithUrl:@"http://weibo.com/qbabyting"];
	webVC.title = @"新浪官方微博";
	self.viewTitle.text = @"新浪官方微博";
	[self.navigationController pushViewController:webVC animated:NO];
	[webVC release];
}

-(void)dealloc {
    [_theView release];
    [super dealloc];
}
@end
