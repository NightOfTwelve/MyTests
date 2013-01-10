//
//  BTMoreController.m
//  BabyTingUpgraded
//
//  Created by  on 12-8-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "Reachability.h"
#import "BTMoreController.h"
#import "BTMoreCell.h"
#import "BTWebViewController.h"
#import "BTAboutViewController.h"
#import "BTUpdateSoftwareAction.h"
//#import "BTFeedback2ViewController.h"
#import "BTFeedback2ViewController.h"
#import "BTBadgeView.h"
#import "BTPlayerManager.h"
#import "BTDownLoadManager.h"
#import "BTMoreData.h"
#import "BTCheckinManager.h"
#import "BTBadgeImageView.h"
#import "BTAppDelegate.h"
const NSInteger kCellTagBegin		= 1700;
const NSInteger kSwitchTag          = 2000;

enum {
    kTagWifi = 0,
    kTagCache,
    kTagNewVersion,
    kTagFiveStar,
    kTagFeedback,
    kTagWeibo,
    kTagAbout,
    kTagCount
};

@interface BTMoreController()

@property (nonatomic, assign)	BOOL						bCanUpdate;
@property (nonatomic, retain)	BTFeedback2ViewController	*fbVC;

@end

@implementation BTMoreController
@synthesize bCanUpdate;
@synthesize fbVC;

#pragma mark - @proerty
- (void)setBCanUpdate:(BOOL)bCanUpdate1 {
	bCanUpdate = bCanUpdate1;
    BTAppDelegate *app =(BTAppDelegate *)[UIApplication sharedApplication].delegate;
    UIButton *btn=[app.tabCtr.tabBarItems objectAtIndex:3];
    UIView *view = [btn viewWithTag:TAG_BADGE_ORIGIN+3];
    if (view) {
        if (!bCanUpdate1) {
            [view removeFromSuperview];
        }
    
    }
    
}

#pragma mark - ViewLifeCycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {

    [_moreItemArray release];
    [_updateUrl release];
	self.fbVC = nil;
	[super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */

- (void)viewWillAppear:(BOOL)animated {
    //	[super viewWillAppear:animated];
    [self willAppearDid];
	if(actionState != ACTION_REQUESTFINISH &&actionState != ACTION_REQUESTERROR &&actionState != ACTION_NOTNEED){
        [self.action start];
        actionState = ACTION_SENDING;
    }
	  _updateUrl = [[BTCheckinManager shareInstance].updateUrl retain];
	self.backButton.hidden = YES;
	//self.backButton.enabled = NO;
	self.tableView.userInteractionEnabled = YES;
	self.view.userInteractionEnabled = YES;
    _moreItemArray = [[NSMutableArray alloc] init];
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"仅wifi网络下载故事",@"本地缓存信息",@"升级到新版本",@"给个5星支持一下",@"意见反馈",@"访问官方微博",@"关于宝贝听听",nil];
    for (int i= 0; i<[array count]; i++) {
        _moreData = [[BTMoreData alloc] init];//存储更多界面每一行数据
        _moreData.name = [array objectAtIndex:i];
        _moreData.moreTag = (kTagWifi+i);
        [_moreItemArray addObject:_moreData];
        [_moreData release];
        
    }
    //四种显示（1，苹果下&&更新 2，苹果下&&非更新 3，非苹果下&&更新 4，非苹果下&&不更新）
    if (DOWNLOAD_CHANNEL_FLAG  ==FROM_APP_STORE) {
        if (!self.bCanUpdate) {
            [_moreItemArray removeObjectAtIndex:2];//苹果下&&非更新
         }
    }else{
            [_moreItemArray removeObjectAtIndex:3];//非苹果下(移除5星下载)
        if (!self.bCanUpdate) {
            [_moreItemArray removeObjectAtIndex:2];//非苹果下&&不更新
        }
        
    }
    [_tableView reloadData];
    
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	self.view.userInteractionEnabled = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self releaseAction];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.viewTitle.text = @"更多";
    self.title = @"更多";
	
	self.view.backgroundColor = [UIColor clearColor];
	
    //	NSString *executableFile = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey];
	//获取当前build号
    //    NSString *versionStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    //	NSString *versionText = [NSString stringWithFormat:@"当前版本:v%@",versionStr];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground:) name:@"UIApplicationWillEnterForegroundNotification" object:nil];
	[self.view insertSubview:_ropeView belowSubview:self.tableView];
	
	self.tableView.userInteractionEnabled = YES;
	self.view.userInteractionEnabled = YES;
}
-(void)willEnterForeground:(id)sender{

    cellSelected = YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	self.tableView.userInteractionEnabled = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark UITableViewDelegate && UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 57.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_moreItemArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString * const cellId = @"moreCell";
	BTMoreCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellId];
	if (cell == nil) {
		cell = [[[BTMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
	}

    if (indexPath.row == [_moreItemArray count]-1){
        [cell.backButton setImage:[UIImage imageNamed:@"moreCellBoard2.png"] forState:UIControlStateNormal];
    }else{
        [cell.backButton setImage:[UIImage imageNamed:@"moreCellBoard.png"] forState:UIControlStateNormal];
    }

      BTMoreData *moredata=[_moreItemArray objectAtIndex:indexPath.row];
      	cell.myTextLabel.text =moredata.name ;//列表显示内容
        cell.cellTag = moredata.moreTag; //cellTag

    //添加仅在wifi下载的开关
    if (indexPath.row == 0) {
        if (![cell.contentView viewWithTag:kSwitchTag]) {
            UIButton *switchBtn = [[[UIButton alloc] initWithFrame:CGRectMake(240, 7, 57, 44)] autorelease];
            switchBtn.tag = kSwitchTag;
            [switchBtn setImage:[UIImage imageNamed:@"more_wifi_only_switch_off.png"] forState:UIControlStateNormal];
            [switchBtn setImage:[UIImage imageNamed:@"more_wifi_only_switch_on.png"] forState:UIControlStateSelected];
            switchBtn.adjustsImageWhenHighlighted = NO;
            [cell.contentView addSubview:switchBtn];
            [switchBtn addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
	[self updateTableViewCell:cell withObject:nil];
	
	return cell;
}

- (void)switchValueChanged:(UIButton *)btn{
    BOOL bIsSelect = btn.selected;
    
    if (bIsSelect) {
        [btn setSelected:NO];
        [BTUserDefaults setBool:NO forKey:USERDAUFLT_SWITCH_STATUS_WIFI_ONLY];
    }else{
        [BTUserDefaults setBool:YES forKey:USERDAUFLT_SWITCH_STATUS_WIFI_ONLY];
		[BTRQDReport reportUserAction:EventMoreLayerWifiButtonClicked];
        [btn setSelected:YES];
        if ([BTUtilityClass checkIsWifiDownload]) {
            [[[BTDownLoadManager sharedInstance] queue] cancelAllOperations];
        }
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (cellSelected) {
    BTMoreCell *cell=(BTMoreCell *)[tableView cellForRowAtIndexPath:indexPath];
	NSURL *url ;
	switch (cell.cellTag) {
		case kTagWifi: {  //仅wifi网络下载故事
            return;
			break;
		}
        case kTagCache:{
            [self clearLocalCache];
            break;
        }
		case kTagNewVersion: {	//@"版本升级"
            [BTRQDReport reportUserAction:EventMoreLayerUpdateSoftwareButtonClicked];
			if (self.bCanUpdate) {
                if (_updateUrl) {
                   url = [NSURL URLWithString:_updateUrl];
                }else{
                   url = [NSURL URLWithString:@"http://itunes.apple.com/cn/app/bao-bei-ting-ting/id480111612?mt=8"];
                }
				[[UIApplication sharedApplication] openURL:url];
			} 
			
			break;
		}
		case kTagFiveStar: {	//@"给个5星支持一下"
			[BTRQDReport reportUserAction:EventMoreLayerFiveStarSupportItButtonClicked];
			NSUInteger appleID = 480111612;
			NSString *urlStr = [NSString stringWithFormat:
                                @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",
                                appleID ];
			NSURL *url = [NSURL URLWithString:urlStr];
			[[UIApplication sharedApplication] openURL:url];
			break;
		}
		case kTagFeedback: {	//@"意见反馈"
            
			[BTRQDReport reportUserAction:EventMoreLayerFeedbackButtonClicked];
			self.backButton.hidden = NO;
			self.backButton.enabled = YES;
			if (fbVC) {
				self.fbVC = nil;
			}
			fbVC = [[BTFeedback2ViewController alloc] init];
			self.viewTitle.text = @"意见反馈";
			fbVC.title = @"意见反馈";
			[self.navigationController pushViewController:fbVC animated:YES];

			break;
		}
        case kTagWeibo:{ // @“官方微博”
            [BTRQDReport reportUserAction:EventMoreLayerOfficalWeiboButtonClicked];
			BTWebViewController *webVC = [[BTWebViewController alloc] initWithUrl:@"http://ti.3g.qq.com/touch/iphone/index.jsp#guest_home/u=Qbabyting"];
			webVC.title = @"官方微博";
			self.viewTitle.text = @"官方微博";
			self.backButton.hidden = NO;
			self.backButton.enabled = YES;
			[self.navigationController pushViewController:webVC animated:YES];
			[webVC release];
            break;
        }
        case kTagAbout:{
            //@"关于宝贝听听"
            [BTRQDReport reportUserAction:EventMoreLayerAboutButtonClicked];
			self.backButton.hidden = NO;
			self.backButton.enabled = YES;
			BTAboutViewController *aboutViewC = [[BTAboutViewController alloc] initWithNibName:@"BTAboutViewController"
																						bundle:nil];
			self.viewTitle.text = @"关于";
			aboutViewC.title = @"关于";
			[self.navigationController pushViewController:aboutViewC animated:YES];
			[aboutViewC release];
         break;
        
        
        }
		default:
			break;
	}
        cellSelected = NO;
    }
}

- (void) alertView:(UIAlertView *)alertview clickedButtonAtIndex:(NSInteger)buttonIndex{
    //    DLog(@"alertView ＝ %@",alertview.title);
    [alertview dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

- (void)updateTableViewCell:(UITableViewCell *)cell withObject:(id)object {
        BTMoreCell *moreCell = (BTMoreCell *)cell;
    
	if (moreCell.cellTag == kTagNewVersion) {//新版本cell上标示
        UIImageView *new_versionImageView = [[UIImageView alloc] init];
        new_versionImageView.frame =  CGRectMake(170, 21.5, 42, 16);
        new_versionImageView.image = [UIImage imageNamed:@"new_homePage.png"];
        [cell addSubview:new_versionImageView];
        //2012.11.29 nate edit 释放的时间点有问题
        [new_versionImageView release];
		new_versionImageView.hidden = !self.bCanUpdate;
	}
    //2012.11.29 nate Add start 解决内存泄漏
    //[new_versionImageView release];
    //2012.11.29 nate Add end
    
    if ([cell.contentView viewWithTag:kSwitchTag]) {
        UIButton *swBtn = (UIButton *)[cell.contentView viewWithTag:kSwitchTag];
        BOOL switchStatus = [BTUserDefaults boolForKey:USERDAUFLT_SWITCH_STATUS_WIFI_ONLY];
        if (switchStatus) {
            [swBtn setSelected:YES];
        }else{
            [swBtn setSelected:NO];
        }
    }
}

#pragma mark - BTBaseActionDelegate
- (void)onAction:(BTBaseAction*) action withError:(NSError*)error {
    //	DLog(@"%s,error = %@",__FUNCTION__,error);
}

- (void)onAction:(BTBaseAction*) action withData:(id) data {
	actionState = ACTION_REQUESTFINISH;
	self.bCanUpdate = [((NSNumber *)data) boolValue];
    //	DLog(@"onAction:withData:%@",data);
	[self releaseAction];
}


-(BTBaseAction *)action{
    if (_baseAction == nil) {
        _baseAction = [[BTUpdateSoftwareAction alloc] init];
        _baseAction.actionDelegate = self;
    }
    return _baseAction;
}

- (void) releaseAction {
    if (_baseAction) {
        _baseAction.actionDelegate = nil;
        [_baseAction cancel];
        [_baseAction release];
        _baseAction = nil;
		
    }
    if (_waitingHUB != nil) {
        [_waitingHUB hide:YES];
    }
    if(actionState == ACTION_SENDING){
        actionState = ACTION_NOT_BEGIN;
    }
}

#pragma mark - 本地缓存 to Neo
- (void)clearLocalCache {
    BTCacheCleanController *con = [[BTCacheCleanController alloc] init];
    con.title = @"本地缓存信息";
    con.viewTitle.text = @"本地缓存信息";
    [self.navigationController pushViewController:con animated:YES];
    [con release];
}

@end
