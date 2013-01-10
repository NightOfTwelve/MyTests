//
//  BTChosenStoryListController.m
//  AABabyTing3
//
//  Created by Neo Wang on 12-8-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTChosenStoryListController.h"
#import "BTStory.h"
#import "BTStoryCell.h"
#import "BTOneChosenListAction.h"
#import "BTOneChosenCategoryInfoView.h"
#import "BTStoryPlayerController.h"
#import "ParabolaView.h"
#import "BTDownLoadAlertView.h"

@interface BTChosenStoryListController ()

@end
@implementation BTChosenStoryListController

@synthesize headerData = _headerData , headerAction= _headerAction,listAction = _listAction;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc{
    [_headerView release];
    [_headerData release];
    [super dealloc];
}
- (id)initWithChosenID:(NSInteger)chosenID{
    self= [super init];
    if(self){
        //_bookInfo = [bookInfo retain];;
        
        _chosenID = chosenID;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _loadMoreFooterView.visible = YES;
    _doubleActionState = noRequest;
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated{
    //[super viewWillAppear:animated];
    if(actionState != ACTION_REQUESTFINISH &&actionState != ACTION_NOTNEED&&[self.tableView.visibleCells count]==0){
        _waitingHUB = [[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES] retain];
        _waitingHUB.frame = CGRectMake(self.navigationController.view.bounds.origin.x, self.navigationController.view.bounds.origin.y+61, self.navigationController.view.bounds.size.width,self.navigationController.view.bounds.size.height-61);
        [self.navigationController.view addSubview:_waitingHUB];
        _waitingHUB.delegate = self;
        _doubleActionState = noRequest;
        actionState = ACTION_SENDING;
        [self.headerAction start];
        [self.listAction start];
        
    }
    [self.tableView reloadData];
    //刷新全部下载按钮状态
    [self checkAllDownLoadButtonEnable];
    [self willAppearDid];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// 重写父类的方法（点击）
- (void)didSelectedAtObject:(id)object {
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
}
- (void)doCell:(UITableViewCell *)cell {
    UIView *view = [cell viewWithTag:TAG_NEW_FLAG];
    if (view) {
        view.hidden = YES;
    }
}
// 重写父类的方法（更新cell）
- (void)updateTableViewCell:(UITableViewCell *)cell withObject:(id)object {
    BTStoryCell *storyCell = (BTStoryCell *)cell;
    BTStory *storyData = (BTStory *)object;
    storyCell.storyData = storyData;
    storyCell.storyDelegate=self;
    [storyCell setCellData];
    [storyCell setImageController:self];
    if(storyCell.tag == TAG_Last_Cell){
        [storyCell.backButton setImage:[UIImage imageNamed:@"myStory_cell_last_bg.png"] forState:UIControlStateNormal];
    }else {
        [storyCell.backButton setImage:[UIImage imageNamed:@"myStory_cell_bg.png"] forState:UIControlStateNormal];
    }
}

//单个故事下载动画
-(void)stroyDownloadAnimation:(BTStory *)storyData{
    int index = [self.itemArray indexOfObject:storyData];
    CGPoint point = [_tableView contentOffset];
    CGPoint startPoint = CGPointMake(32, index * 57 - point.y + 200);
    
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
//storyCell的下载回调函数
- (void)storyDownLoad:(BTStory *)storyData{
    
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
        //刷新全部下载按钮状态
        [self checkAllDownLoadButtonEnable];
    }

}

//全部下载点取消的回调
-(void)cancelAllDownloadRequest{
    [self releaseAction];
    bIsAllStoriesDownload = NO;
}

//整个合集下载
-(void)downloadOneChosen:(id)data{
//    DLog(@"整个合集下载");
    
    if ([BTUtilityClass isNetWorkNotAvailable]) {
        [[BTDownLoadManager sharedInstance] showNoNetWorkAlert];
        return;
    }
    
    if ([[BTDownLoadManager sharedInstance] showDownloadAlert]) {
        return;
    }
    
    [self performSelectorOnMainThread:@selector(showDownloadProgressAlert) withObject:nil waitUntilDone:NO];
    
    bIsAllStoriesDownload = YES;
    [self reloadTableViewDataSource];
}


//全部下载动画
-(void)allStroiesDownloadAnimation{
    
    CGPoint point = [_tableView contentOffset];
    CGPoint startPoint = CGPointMake(57,point.y + 100);
    
    UIView *headerView = [_tableView tableHeaderView];
    UIImageView *headerImageView = (UIImageView *)[headerView viewWithTag:TAG_HeaderNetImage];
    
    UIImage *image = headerImageView.image;
    if (image) {
        ParabolaView *parabola = [[ParabolaView alloc]initWithImg:image size:headerImageView.frame.size start:startPoint];
        [self.view addSubview:parabola];
        [parabola release];
        [parabola startRuning];
    }
    
}
//获取全部下载的故事信息
-(void)getDownloadAllStoriesInfo{
    
    if (bIsAllStoriesDownload) {
        [self reloadTableViewDataSource];
        float percent = [self.itemArray count]*1.0/self.countInNet;
        [[BTShowAllDownloaAlert sharedInstance] setDownloadProgress:percent];        
    }
    
    if([self.itemArray count]>=self.countInNet){
        if (bIsAllStoriesDownload) {
            int downLoadCount = 0;
            
            for (int i = 0; i < [_itemArray count]; i++) {
                BTStory *story = (BTStory *)[_itemArray objectAtIndex:i];
                if (![[BTDownLoadManager sharedInstance] isInMyStoryList:story] ) {
                    if([[BTDownLoadManager sharedInstance] isReachMaxLocalStoryCount]){
                        downLoadCount++;
                        [[BTDownLoadManager sharedInstance] addNewDownLoadTask:story];
                    }else{
                        [[BTDownLoadManager sharedInstance]showDownloadAlert];
                        break;
                    }
                }
            }
            [BTUtilityClass setTabBarBadgeNumber:downLoadCount];
            bIsAllStoriesDownload = NO;
            
            UIView *headerView = [_tableView tableHeaderView];
            UIButton *btn = (UIButton *)[headerView viewWithTag:TAG_ALL_STORY_DOWNLOAD_BUTTON];
            [btn setImage:[UIImage imageNamed:@"allHasDownloadBtn.png"] forState:UIControlStateNormal];
            [btn setEnabled:NO];
            
            [self allStroiesDownloadAnimation];
            [_tableView reloadData];
        }
        
    }
}
//上面的View上button点击全部下载的回调函数
- (void)newStoryAllDownload:(id)data{
//    DLog(@"新故事首发全部下载");
}
//如果有自定义的Cell，子类需要重写这个方法
- (UITableViewCell*) tableViewCellForRowAtIndexPath:(NSIndexPath *)indexPath cellIdentifier:(NSString*)identifier {
    UITableViewCell *cell = nil;
    if (cell == nil) { 
        NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"BTStoryCell" owner:nil options:nil];
        cell = [objs lastObject];
    }
    return cell;
}
- (void)onAction:(BTBaseAction *)action withData:(id)data{
//    DLog(@"%d",_doubleActionState);
    if([action isKindOfClass:[BTOneChosenListAction class]]){
        _doubleActionState++;
        if([data isKindOfClass:[NSMutableArray class]]){
            [self.itemArray addObjectsFromArray:data];
        }
        if([data isKindOfClass:[BTListInfo class]]){
            BTListInfo *info = (BTListInfo*)data;
            self.itemArray = info.result;
            self.countInNet = info.countInNet;    
        }
    }else if([action isKindOfClass:[BTOneChosenHeaderAction class]]){
        _doubleActionState++;
        self.headerData = data;
        NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"BTOneChosenCategoryInfoView" owner:nil options:nil];
        BTOneChosenCategoryInfoView *view = [objs lastObject];
        view.bookInformation = self.headerData;
        view.downloadDelegate = self;
        [view drawChosenView];
        [view setImageViewController:self];
        if(_headerView){
            [_headerView release];
        }
        _headerView = [view retain];
    }
    if(_doubleActionState >= twoRequest){
        actionState = ACTION_REQUESTFINISH;
        [self.view insertSubview:_ropeView belowSubview:self.tableView];
        self.tableView.tableHeaderView = _headerView;
        [self doneLoadingTableViewData];
        [self.tableView reloadData];
        [self releaseAction];
        [_waitingHUB hide:YES];
        
        if([self.itemArray count]>=self.countInNet){
            //_loadMoreFooterView.visible = NO;
            [_loadMoreFooterView removeFromSuperview];
            [self doneLoadingTableViewData];
            _loadMoreFooterView = nil;
        }
        
        if(bIsAllStoriesDownload){
            [self getDownloadAllStoriesInfo];
        }
        
        if ([[BTDownLoadManager sharedInstance] bIsLimitDownload] &&
            [[[[BTDownLoadManager sharedInstance] queue] operations] count]) {
            [ASIHTTPRequest setMaxBandwidthPerSecond:MAX_DOWNLOAD_BANDWIDTH_PER_SECOND];
        }
    }
    
    //刷新全部下载按钮状态
    [self checkAllDownLoadButtonEnable];
}

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    [self.listAction start];
	_reloading = YES;
	
}

- (void)releaseAction{
    if (_listAction) {
        _listAction.actionDelegate = nil;
        [_listAction cancel];
        [_listAction release];
        _listAction = nil;
        
    }
    if(_headerAction){
        _headerAction.actionDelegate = nil;
        [_headerAction cancel];
        [_headerAction release];
        _headerAction = nil;
    }
    if (_waitingHUB != nil) {
        [_waitingHUB hide:YES];
    }
    if(actionState == ACTION_SENDING){
        actionState = ACTION_NOT_BEGIN;
    }
}

- (void)retryAction:(id)sender{
    if(sender){
        UIButton *btn = (UIButton *)sender;
        [btn removeFromSuperview];
    }
    _waitingHUB = [[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES] retain];
    [self.navigationController.view addSubview:_waitingHUB];
    _waitingHUB.delegate = self;
    _doubleActionState = noRequest;
    [self.listAction start];
    [self.headerAction start];
    actionState = ACTION_SENDING;
}

- (BTOneChosenListAction *)listAction{
    if (_listAction == nil) {
        NSInteger lastID = 0;
        if([self.itemArray count]>0){
            BTStory *data = [self.itemArray lastObject];
            lastID = [data.storyId integerValue];
        }
        _listAction = [[BTOneChosenListAction alloc] initWithChosenID:_chosenID lastId:lastID len:[self.itemArray count]];
        _listAction.actionDelegate = self;
    }
    return _listAction;
}

- (BTOneChosenHeaderAction *)headerAction{
    if (_headerAction == nil) {
        _headerAction = [[BTOneChosenHeaderAction alloc] initWithListId:_chosenID];
        _headerAction.actionDelegate = self;
    }
    return _headerAction;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 57.0f;
}

@end
