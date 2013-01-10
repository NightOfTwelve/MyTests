//
//  BTHotStoryListController.m
//  AABabyTing3
//
//  Created by Neo Wang on 12-8-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTHotStoryListController.h"
#import "BTHotStoryAction.h"
#import "BTHotStoryCell.h"
#import "BTStory.h"
#import "BTConstant.h"
#import "BTStoryPlayerController.h"
#import "ParabolaView.h"
#import "BTDownLoadAlertView.h"
#import "WEPopoverController.h"

@interface BTHotStoryListController ()
@property (nonatomic, retain) WEPopoverController *popc;
@property (nonatomic, retain) UIButton *titleButton;
@property (nonatomic, retain) NSMutableArray *rankCategories;
@property (nonatomic, assign) NSInteger selectedRankIndex;
@property (nonatomic, assign) NSInteger lastId;
@property (nonatomic, retain) UIImageView *arrowImageView;
//@property (nonatomic, assign) BOOL isFirstCome;
//@property (nonatomic, assign) CGPoint tableViewNormalCenter;
@end

@implementation BTHotStoryListController

- (void)popoverControllerDidDismissPopover:(WEPopoverController *)popoverController {
	self.arrowDirectionUp = NO;
}
- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)popoverController {
	return YES;
}

- (void)setArrowDirectionUp:(BOOL)arrowDirectionUp {
	CDLog(BTDFLAG_RANKLIST,@"arrowDir:%@->%@",(_arrowDirectionUp?@"上":@"下"),(arrowDirectionUp?@"上":@"下"));
	
	UIImage *image = nil;
	if (arrowDirectionUp) {
		image = [UIImage imageNamed:@"ranklist_label_popoverArrowUp.png"];
	} else {
		image = [UIImage imageNamed:@"ranklist_label_popoverArrowDown.png"];
	}
	
	if (_arrowDirectionUp != arrowDirectionUp) {
		CGFloat rotation = 0.f;
		if (_arrowDirectionUp) {//原方向向上
			//从上到下，顺时针
			rotation = M_PI-0.01;
		} else {
			//从下到上，逆时针
			rotation = -(M_PI-0.01);
		}
		CGFloat duration = .2;
		[UIView animateWithDuration:duration animations:^{
			CGAffineTransform transform = CGAffineTransformMakeRotation(rotation);
			_arrowImageView.transform = transform;
		} completion:^(BOOL b){
			_arrowImageView.transform = CGAffineTransformIdentity;
			_arrowImageView.image = image;
		}];
		_arrowDirectionUp = arrowDirectionUp;
	} else {
		_arrowImageView.image = image;
	}
}

- (void)dealloc {
	self.arrowImageView = nil;
	self.rankCategories = nil;
	[_titleButton release];
	[_popc release];
	[super dealloc];
}

- (id)initWithHomeData:(NSInteger)DataID{
    self = [super init];
    if(self){
        _homeID = DataID;
		
		self.rankCategories = [NSMutableArray arrayWithObjects:
							   [BTRankCategory rankCategoryWithRequestId:Request_Rank_ID_Today andName:@"日排行榜"]
							   ,[BTRankCategory rankCategoryWithRequestId:Request_Rank_ID_Week andName:@"周排行榜"]
							   ,[BTRankCategory rankCategoryWithRequestId:Request_Rank_ID_Month andName:@"月排行榜"]
							   ,[BTRankCategory rankCategoryWithRequestId:Request_Rank_ID_Total andName:@"总排行榜"]
							   , nil];
		
#warning 是否记住上次用户打开的榜分类 @song
		self.selectedRankIndex = 1;//默认为“本周”
    }
    return self;
}

- (void)didSelectedAtIndex:(NSInteger)selectedIndex {
	CDLog(BTDFLAG_RANKLIST_BUG,@"1111");
//	[self returnToTop];
    //0：日  1：周   2：月    3：总
    
    switch (selectedIndex) {
        case 0:
            [BTRQDReport reportUserAction:EventDailyRankClicked];
            break;
        case 1:
            [BTRQDReport reportUserAction:EventWeekRankClicked];
            break;
        case 2:
            [BTRQDReport reportUserAction:EventMonthRankClicked];
            break;
        case 3:
            [BTRQDReport reportUserAction:EventTotalRankClicked];
            break;
        default:
            break;
    }
	
    [_ropeView removeFromSuperview];
	self.itemArray = [NSMutableArray array];
	[self.tableView reloadData];
	
	self.arrowDirectionUp = NO;
	self.selectedRankIndex = selectedIndex;
	[self releaseAction];
	UIView *view = [self.view viewWithTag:TAG_Retry_Button];
	if(view){
		[view removeFromSuperview];
	}
	if (_waitingHUB == nil) {
		_waitingHUB = [[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES] retain];
		_waitingHUB.frame = CGRectMake(self.navigationController.view.bounds.origin.x, self.navigationController.view.bounds.origin.y+61, self.navigationController.view.bounds.size.width,self.navigationController.view.bounds.size.height-61);
		[self.navigationController.view addSubview:_waitingHUB];
		_waitingHUB.delegate = self;
	}
	
	[_waitingHUB show:YES];
	
	self.action.actionType = defaultAction;
	CDLog(BTDFLAG_RANKLIST_BUG,@"3333");
	[self.action start];
	
	actionState = ACTION_SENDING;
	
//	CGRect bounds = [UIScreen mainScreen].bounds;
//	CGPoint centerHidden = _tableViewNormalCenter;
//	centerHidden.y -= bounds.size.height;
//	
//	[UIView animateWithDuration:0.3 animations:^{
//		self.tableView.center = centerHidden;
//    } completion:^(BOOL finished){
//		CDLog(BTDFLAG_RANKLIST_BUG,@"2222");
//		self.itemArray = [NSMutableArray array];
//		[self.tableView reloadData];
//		self.arrowDirectionUp = NO;
//		self.selectedRankIndex = selectedIndex;
//		[self releaseAction];
//		UIView *view = [self.view viewWithTag:TAG_Retry_Button];
//		if(view){
//			[view removeFromSuperview];
//		}
//		if (_waitingHUB == nil) {
//			_waitingHUB = [[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES] retain];
//			_waitingHUB.frame = CGRectMake(self.navigationController.view.bounds.origin.x, self.navigationController.view.bounds.origin.y+61, self.navigationController.view.bounds.size.width,self.navigationController.view.bounds.size.height-61);
//			[self.navigationController.view addSubview:_waitingHUB];
//			_waitingHUB.delegate = self;
//		}
//		
//		[_waitingHUB show:YES];
//		
//		self.action.actionType = defaultAction;
//		CDLog(BTDFLAG_RANKLIST_BUG,@"3333");
//		[self.action start];
//		
//		actionState = ACTION_SENDING;
//    }];
	
	if (_popc) {
		[_popc dismissPopoverAnimated:YES];
	}
}

//列表返回到顶端
- (void)returnToTop {
    CDLog(NeoRankList,@"执行");
	[self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
//	CGRect sectionRect = [self.tableView rectForSection:0];
//	[self.tableView scrollRectToVisible:sectionRect animated:YES];
}

- (void)titleButtonClicked:(UIButton *)button {
	CILog(BTDFLAG_RANKLIST,@"");
	if (_popc == nil) {
		BTPopoverContentViewController *contentVC = [[BTPopoverContentViewController alloc] initWithRankCategories:self.rankCategories];
		contentVC.selectedIndex = self.selectedRankIndex;
		contentVC.delegate = self;
		_popc = [[WEPopoverController alloc] initWithContentViewController:contentVC];
		_popc.delegate = self;
		[contentVC release];
		[_popc setPopoverContentSize:CGSizeMake(200, 44*4+20)];
	}
	
	if (_popc.popoverVisible) {
		self.arrowDirectionUp = NO;
		[_popc dismissPopoverAnimated:YES];
	} else {
        [BTRQDReport reportUserAction:EventRankTitleClicked];
		self.arrowDirectionUp = YES;
		
		//调整弹出的popover位置
		CGRect rect = button.frame;
		rect.origin.y -= 20;
		rect.origin.x += 5;
		
		[_popc presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
	
	//下面部分注释先保留，待调查 by Zero 2012-11-08
//	BTAppDelegate *appDelegate = (BTAppDelegate *)[UIApplication sharedApplication].delegate;
//	UIWindow *window = appDelegate.window;
	
//	UIView *view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
////	view.backgroundColor = [UIColor redColor];
//	view.userInteractionEnabled = NO;
////	[self.view insertSubview:view aboveSubview:self.tableView];
//	[window addSubview:view];
////	[window insertSubview:view belowSubview:self.viewTitle];
//	[window bringSubviewToFront:view];
	
	
	
	
//	[window bringSubviewToFront:popc.view];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _loadMoreFooterView.visible = YES;
	
//	//三角箭头
//	{
//		self.arrowDirectionUp = NO;
//	}
}

- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
}
- (void)viewWillAppear:(BOOL)animated{
//	CDLog(BTDFLAG_RANKLIST_BUG,@"reset _isFirstCome");
//	_isFirstCome = YES;
//	_tableViewNormalCenter = self.tableView.center;
	CDLog(BTDFLAG_RANKLIST,@"actionState:%d",actionState);
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modifyPlayStoryPlayingStatus:) name:NOTIFICATION_PLAY_STORY object:nil];
	
	[self updateTitleLabel];

	
	self.titleButton = [[[UIButton alloc] initWithFrame:CGRectMake(80,10,160,51)] autorelease];
	_titleButton.backgroundColor = [UIColor clearColor];
	[_titleButton addTarget:self action:@selector(titleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
	BTAppDelegate *appDelegate = (BTAppDelegate *)[UIApplication sharedApplication].delegate;
	UIWindow *window = appDelegate.window;
	[window addSubview:_titleButton];
	
	//三角箭头
	{
		if (_arrowImageView == nil) {
			UIImage *image = [UIImage imageNamed:@"ranklist_label_popoverArrowDown.png"];
			_arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(145-15, 30, 16, 12)];
			_arrowImageView.image = image;
			[self.titleButton addSubview:_arrowImageView];
		}
	}
}
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_PLAY_STORY object:nil];
	CDLog(BTDFLAG_RANKLIST,@"****");
	self.arrowImageView = nil;
	[_titleButton removeFromSuperview];
	self.titleButton = nil;
	
	if (_popc && _popc.popoverVisible) {
		[_popc dismissPopoverAnimated:YES];
	}
}

-(void)modifyPlayStoryPlayingStatus:(NSNotification *)sender {
    [self.tableView reloadData];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//单个故事下载动画
-(void)stroyDownloadAnimation:(BTStory *)storyData{
    int index = [self.itemArray indexOfObject:storyData];
    CGPoint point = [_tableView contentOffset];
    CGPoint startPoint = CGPointMake(52, index * 57 - point.y + 85);
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@_storyIcon",THREE20_DIRECTORY,storyData.storyId];
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    if (!image) {

        NSString *path = [NSString stringWithFormat:@"bundle://story_cell_default.png"];
        image = TTIMAGE(path);
    }
    if (image) {
        ParabolaView *parabola = [[ParabolaView alloc]initWithImg:image size:CGSizeMake(41, 41) start:startPoint];
        [self.view addSubview:parabola];
        [parabola release];
        [parabola startRuning];
    }
}

//点击故事下载
- (void)storyDownload:(BTStory *)storyData{
//    DLog(@"热门故事下载%@",storyData.title);
    
    if ([BTUtilityClass isNetWorkNotAvailable]) {
        [[BTDownLoadManager sharedInstance] showNoNetWorkAlert];
        return;
    }
    
    if ([[BTDownLoadManager sharedInstance] showDownloadAlert]) {
        return;
    }
    
    storyData.bIsInLocal = YES;
    [self.tableView reloadData];
    
    if (![[BTDownLoadManager sharedInstance] isInMyStoryList:storyData]) {
        [[BTDownLoadManager sharedInstance] addNewDownLoadTask:storyData];
        [BTUtilityClass setTabBarBadgeNumber:1];
        [self stroyDownloadAnimation:storyData]; 
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 57.0f;
}

// 重写父类的方法（点击）
- (void)didSelectedAtObject:(id)object {
//    DLog(@"进入到播放界面333");
    
    BTStoryPlayerController *playerCtr = [BTPlayerManager sharedInstance].storyPlayer;
    BOOL bIsExist = [[self.navigationController viewControllers] containsObject:playerCtr];
    if (bIsExist) {
        CDLog(BTDFLAG_PRESS_PLAYING_CRASH,@"防止重复push");
        return;
    }
    playerCtr.bIsBackToCurrentPlayingLayer = NO;
    playerCtr.playList = self.itemArray;
    playerCtr.playingStoryIndex = [self.itemArray indexOfObject:object];
    playerCtr.storyType = StoryType_Net;
    
    [self.navigationController pushViewController:playerCtr animated:YES];
    
    [playerCtr playStory];
    BTStory *story = (BTStory *)object;
    story.isNew = NO;
//    [playerCtr release];
}
- (void)doCell:(UITableViewCell *)cell {
    UIView *view = [cell viewWithTag:TAG_NEW_FLAG];
    if (view) {
        view.hidden = YES;
    }
}
// 重写父类的方法（更新cell）
- (void)updateTableViewCell:(UITableViewCell *)cell withObject:(id)object {
    BTHotStoryCell *hotStoryCell = (BTHotStoryCell *)cell;
    BTStory *storyData = (BTStory *)object;
    NSInteger index = [self.itemArray indexOfObject:storyData];
    storyData.rankNum = index + 1;
    hotStoryCell.storyData = storyData;
    hotStoryCell.hotDownloadDelegate = self;
    [hotStoryCell drawCell];
    [hotStoryCell setImageController:self];
    if(hotStoryCell.tag == TAG_Last_Cell){
        [hotStoryCell.backButton setImage:[UIImage imageNamed:@"myStory_cell_last_bg.png"] forState:UIControlStateNormal];
    }else {
        [hotStoryCell.backButton setImage:[UIImage imageNamed:@"myStory_cell_bg.png"] forState:UIControlStateNormal];
    }
    
    
    switch (hotStoryCell.tag) {
        case TAG_First_Cell:
            hotStoryCell.rankBackView.image = [UIImage imageNamed:@"oneStory.png"];
            break;
        case TAG_Second_Cell:
            hotStoryCell.rankBackView.image = [UIImage imageNamed:@"twoStory.png"];
            break;
        case TAG_Third_Cell:
            hotStoryCell.rankBackView.image = [UIImage imageNamed:@"threeStory.png"];
            break;
        default:
            break;
    }
}


//如果有自定义的Cell，子类需要重写这个方法
- (UITableViewCell*) tableViewCellForRowAtIndexPath:(NSIndexPath *)indexPath cellIdentifier:(NSString*)identifier {
    UITableViewCell *cell = nil;
    if (cell == nil) {
        NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"BTHotStoryCell" owner:nil options:nil];
        cell = [objs lastObject];
    }
    return cell;
}

- (BTBaseAction*)action {
    if (_baseAction == nil) {
		BTRankCategory *rankCategory = self.rankCategories[self.selectedRankIndex];
		NSInteger rankId = rankCategory.requestId;
		NSInteger lastId = rankCategory.lastId;
		CDLog(BTDFLAG_RANKLIST,@"rankID:%d",rankId);
        _baseAction = [[BTHotStoryAction alloc] initWithHomeID:_homeID lastID:lastId rankId:rankId];
        _baseAction.actionDelegate = self;
    }
    return _baseAction;
}

- (void)onAction:(BTBaseAction *)action withData:(id)data {
    if (![data isKindOfClass:[BTListInfo class]]) {
		CELog(BTDFLAG_ALWAYS_PRINT,@"排行榜Action返回数据类型错误!(%@)",data);
		return;
	}
 	BTListInfo *ranklist = (BTListInfo *)data;
	BTRankCategory *rankCategory = self.rankCategories[self.selectedRankIndex];
	BTStory *story = [ranklist.result lastObject];
	rankCategory.lastId = [story.storyId integerValue];
	
//	BOOL isNextPage = (action.actionType == nextPageAction);
	
	[super onAction:action withData:data];
	[self updateTitleLabel];
	
//	[self showList:isNextPage];
}

//- (void)showList:(BOOL)isNextPageActionReturn {
//	if (isNextPageActionReturn) {
//		CDLog(BTDFLAG_RANKLIST_BUG,@"5555");
//		return;
//	}
//	
//	if (_isFirstCome) {
//		CDLog(BTDFLAG_RANKLIST_BUG,@"6666");
//		_isFirstCome = NO;
//		self.tableView.center = _tableViewNormalCenter;
//		return;
//	}
//	
//	CDLog(BTDFLAG_RANKLIST_BUG,@"7777");
//	CDLog(BTDFLAG_RANKLIST_BUG,@"dataSource:%@",self.itemArray);
//	
//	_ropeView.hidden = YES;
//	CGRect bounds = [UIScreen mainScreen].bounds;
//	CGPoint centerHidden = _tableViewNormalCenter;
//	centerHidden.y -= bounds.size.height;
//	self.tableView.center = centerHidden;
//	[UIView animateWithDuration:0.3 animations:^{
//		self.tableView.center = _tableViewNormalCenter;
//    } completion:^(BOOL finished){
//		_ropeView.hidden = NO;
//    }];
//}

- (void)onAction:(BTBaseAction *)action withError:(NSError *)error {
	if (action.actionType != nextPageAction) {
		self.itemArray = [NSMutableArray array];
		[self.tableView reloadData];
	}
	[super onAction:action withError:error];
	[self updateTitleLabel];
}

- (void)updateTitleLabel {
	BTRankCategory *rankCategory = self.rankCategories[self.selectedRankIndex];
	self.viewTitle.text = rankCategory.name;
}

@end
