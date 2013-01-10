//
//  BTTableViewController.m
//  AABabyTing3
//
//  Created by He baochen on 12-8-14.
//
//

#import "BTTableViewController.h"
#import "Only320Network.h"
#import "BTDownLoadAlertView.h"
#import "BTWebViewController.h"
#import "BTAppDelegate.h"
#import "BTStoryPlayerController.h"
#import "BTRadioPlayerController.h"
#import "BTPlayerManager.h"
#import "BTBaseCell.h"

const NSInteger kTagAlertGetOppo	= 201;		//获得砸蛋机会的alert

@interface BTTableViewController ()
- (UITableViewCell*) tableViewCellForRowAtIndexPath:(NSIndexPath *)indexPath cellIdentifier:(NSString*)identifier;
@end

@implementation BTTableViewController
@synthesize clearsSelectionOnViewWillAppear = _clearsSelectionOnViewWillAppear;
@synthesize tableView = _tableView;
@synthesize viewTitle = _viewTitle,playingButton = _playingButton,backButton = _backButton;
@synthesize titleStr;


- (void)dealloc {
	[titleStr release];
	[_tableView release];
	_tableView = nil;
	[_loadMoreFooterView release];
	//[_viewTitle release];
	[super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		//监听砸蛋通知
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(showGiftEggsWebView:)
													 name:GIFT_EGGS_SHOW_NOTIFICATION
												   object:nil];
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSArray *visibleCells = [_tableView visibleCells];
    for (BTBaseCell  *cell in visibleCells) {
//        BTNetImageView *view = (BTNetImageView *)[cell viewWithTag:TAG_NetImage];
//        [view stopLoading];
        [cell.baseNetImageView stopLoading];
    }
    
    UIView *headerView = [_tableView tableHeaderView];
    BTNetImageView *headerImageView = (BTNetImageView *)[headerView viewWithTag:TAG_HeaderNetImage];
    [headerImageView stopLoading];
//    [[NSNotificationCenter defaultCenter] postNotificationName:viewWillDisAppearNotification object:nil userInfo:[NSDictionary dictionaryWithObject:self forKey:@"controller"]];
}

- (void)viewDidLoad{
    [super viewDidLoad];
	if (_tableView == nil) {
        CGRect rect = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height - 7);
		_tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
		_tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		_tableView.separatorColor = [UIColor clearColor];
		_tableView.showsVerticalScrollIndicator = NO;
		//    _tableView.frame = CGRectMake(0, 61, self.view.bounds.size.width, self.view.bounds.size.height-61);
		_tableView.dataSource = self;
		_tableView.delegate = self;
		[self.view addSubview:_tableView];
	}
    
    if (_loadMoreFooterView == nil) {
		CDLog(BTDFLAG_RANKLIST,@"if (_loadMoreFooterView == nil) {");
		_loadMoreFooterView = [[LoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0.0f, self.tableView.contentSize.height, self.tableView.frame.size.width, self.tableView.bounds.size.height)];
		_loadMoreFooterView.delegate = self;
        _loadMoreFooterView.visible = NO;
        _loadMoreFooterView.backgroundColor = [UIColor clearColor];
		[self.tableView addSubview:_loadMoreFooterView];
        _loadMoreFooterView.tag = pullUpdateViewTag;
	}
	// Do any additional setup after loading the view.
	[self initListUI];
    [self initChildUI];
}

- (void)viewDidUnload{
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_clearsSelectionOnViewWillAppear) {
        [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:animated];
    }
    
    [self willAppearDid];
}

- (void)willAppearDid{
    //[self.tableView reloadData];
    NSArray *visibleCells = [_tableView visibleCells];
    for (BTBaseCell *cell in visibleCells) {
        //BTNetImageView *view = (BTNetImageView *)[cell viewWithTag:TAG_NetImage];
        //[view reload];
        [cell.baseNetImageView reload];
    }
    UIView *headerView = [_tableView tableHeaderView];
    BTNetImageView *headerImageView = (BTNetImageView *)[headerView viewWithTag:TAG_HeaderNetImage];
    [headerImageView reload];
        cellSelected = YES;
//    [[NSNotificationCenter defaultCenter] postNotificationName:viewWillAppearNotification object:nil userInfo:[NSDictionary dictionaryWithObject:self forKey:@"controller"]];
    BTAppDelegate  *appDelegate = (BTAppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.navView.delegate = self;
    self.backButton = appDelegate.navView.backButton;
    self.viewTitle = appDelegate.navView.titleLabel;
    self.playingButton = appDelegate.navView.playingButton;
    self.playingButton.hidden = YES;
    self.backButton.hidden = NO;
//    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(press:)];
//    [self.viewTitle addGestureRecognizer:tap];
//    [tap release];
    [self.playingButton remoteAllTargetAndActionsForControlEvents:UIControlEventTouchUpInside];
    [self.backButton remoteAllTargetAndActionsForControlEvents:UIControlEventTouchUpInside];
    [self.backButton addTarget:self action:@selector(backButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.playingButton addTarget:self action:@selector(playingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.viewTitle.text = self.navigationController.visibleViewController.title;
    
    
    
    if (self.playingButton) {
        if ([BTPlayerManager sharedInstance].controler_play_mode != PLAY_MODEL_NONE) {
            _playingButton.hidden = NO;
        }
    }
}


- (void)labelPress:(id)sender{
   [self.tableView scrollRectToVisible:CGRectMake(0, 0, _tableView.frame.size.width, _tableView.frame.size.height) animated:YES];
}

#pragma mark UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 5)] autorelease];
    return footView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [self tableViewCellForRowAtIndexPath:indexPath cellIdentifier:CellIdentifier];
    }
    
    [self updateTableViewCell:cell atIndexPath:indexPath];
    return cell;
}

- (UITableViewCell*) tableViewCellForRowAtIndexPath:(NSIndexPath *)indexPath cellIdentifier:(NSString*)identifier {
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    return cell;
}

- (void) updateTableViewCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
}



/*此处这么写，在滑动的时候，不发网络请求，在滑动结束之后，在发请求*/


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [TTURLRequestQueue mainQueue].suspended = YES;
    CDLog(Neoadd,@"YES");
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(!decelerate){
        //减速
        [TTURLRequestQueue mainQueue].suspended = NO;
        CDLog(Neoadd,@"NO");
    }
    
    
    CDLog(Neoadd,@"1.decelerate = %d",decelerate);
}


- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    [TTURLRequestQueue mainQueue].suspended = NO;
    CDLog(Neoadd,@"did");
}


- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    [TTURLRequestQueue mainQueue].suspended = YES;
    CDLog(Neoadd,@"should");
    return YES;

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //减速停止
    [TTURLRequestQueue mainQueue].suspended = NO;
    CDLog(Neoadd,@"2.scrollViewDidEndDecelerating ");
}

#pragma mark -
#pragma mark LoadMoreTableFooterDelegate Methods

#pragma mark -
- (void)initChildUI{
#warning 子类自己实现上面的两个Button及实现方法   可重写
//	DLog(@"super initChildUI");
    self.backButton.hidden = NO;
}

#pragma mark - View lifecycle

-(void)initListUI{
//    DLog(@"super initListUI");
    self.tableView.backgroundColor = [UIColor clearColor];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 61)];
    self.tableView.tableHeaderView = headerView;
    [headerView release];
    

}

- (void)backButtonPress:(id)sender{
    if([[self.navigationController viewControllers] count]>1){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)playingButtonPressed:(id)sender{
//    DLog(@"进入到播放界面444");
    CDLog(BTDFLAG_PRESS_PLAYING_CRASH,@"1111");
	[BTRQDReport reportUserAction:EventPlayingButtonClicked];
    //DLog(@"controler_play_mode:%d",[BTPlayerManager sharedInstance].controler_play_mode);
    if ([BTPlayerManager sharedInstance].controler_play_mode == PLAY_MODEL_STORY) {
        BTStoryPlayerController *playerCtr = [BTPlayerManager sharedInstance].storyPlayer;
        playerCtr.bIsBackToCurrentPlayingLayer = YES;
        BOOL bIsExist = [[self.navigationController viewControllers] containsObject:playerCtr];
        if (!bIsExist) {
            [self.navigationController pushViewController:playerCtr animated:YES];
            CDLog(BTDFLAG_PRESS_PLAYING_CRASH,@"2222");
        }
    } else if ([BTPlayerManager sharedInstance].controler_play_mode == PLAY_MODEL_RADIO){
        BTRadioPlayerController *radioCtr = [BTPlayerManager sharedInstance].radioPlayer;
        radioCtr.bIsBackToCurrentPlayingLayer = YES;
        BOOL bIsExist = [[self.navigationController viewControllers] containsObject:radioCtr];
        if (!bIsExist) {
            [self.navigationController pushViewController:radioCtr animated:YES];
            CDLog(BTDFLAG_PRESS_PLAYING_CRASH,@"3333");
        }
    }

    //self.viewTitle.text = @"正在播放";
}

#pragma mark -
#pragma mark Alert Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
	if (alertView.tag == kTagAlertGetOppo) {
		if (buttonIndex == 0) {
			return;
		}
		NSDictionary *userInfo = ((BTAlertView *)alertView).userInfo;
//		DLog(@"userInfo:%@",userInfo);
		NSString *urlStr = [userInfo valueForKey:GIFT_EGGS_RUN_URL];
//		DLog(@"urlStr = %@",urlStr);
		BTWebViewController *webVC = [[BTWebViewController alloc] initWithUrl:urlStr];
		self.titleStr = @"活动";
		webVC.title = @"活动";
        //		self.viewTitle.text = @"砸蛋";
		self.viewTitle.hidden = NO;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_EGG_VIEW_WILL_APPEAR object:nil];
        
		[self.navigationController pushViewController:webVC animated:YES];
		[webVC release];
		return;
	}
	if(buttonIndex == 1){
        [self retryAction:nil];
    }
}

- (void)retryAction:(id)sender {
	
}

#pragma mark - 砸蛋通知的处理函数
- (void)showGiftEggsWebView:(NSNotification *)notification {
	BTAppDelegate *appDelegate = (BTAppDelegate *)[UIApplication sharedApplication].delegate;
//	DLog(@"self = %@",self);
	UIViewController *selectedVC = ((UINavigationController *)(appDelegate.tabCtr.selectedViewController)).visibleViewController;
//	DLog(@"selectedVC = %@",selectedVC);
	if (selectedVC != self) {
		return;
	}
	
	BTAlertView *alert = [[BTAlertView alloc] initWithTitle:@"恭喜你获得一次抽奖机会！"
													message:@"大奖等你拿！"
												   delegate:self
										  cancelButtonTitle:@"取消"
										  otherButtonTitles:@"去看看",nil];
	alert.userInfo = notification.userInfo;
	alert.tag = kTagAlertGetOppo;
	[alert show];
	[alert release];
}


@end
