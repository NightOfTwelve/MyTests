//
//  BTMystoriesController.m
//  BabyTingUpgraded
//
//  Created by  on 12-8-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "BTPlayerManager.h"
#import "BTMystoriesController.h"
#import "BTMyStroyCell.h"
#import "BTMyStoryDownloadCell.h"
#import "BTDownLoadManager.h"
#import "BTUtilityClass.h"
#import "BTStoryPlayerController.h"
#import "BTAppDelegate.h"
#import "BTTabBarController.h"
#import "BTProgressIndicator.h"
#import "BTPlayerManager.h"
#import "BTDownLoadAlertView.h"
#import "BTLocalSortViewController.h"

@interface BTMystoriesController (private)
-(void)sendUpateStoryInfoRequest;
-(NSMutableArray *)getStoryIdArrayBySortField;
@end

@implementation BTMystoriesController

@synthesize editButton = _editButton;
@synthesize sortButton = _sortButton;
@synthesize popc = _pop;
@synthesize selectedSortIndex = _selectedSortIndex;
@synthesize arrowDirectionUp = _arrowDirectionUp;
@synthesize arrowImageView = _arrowImageView;
@synthesize storyUpdateAction = _storyUpdateAction;
@synthesize sortRequestIds = _sortRequestIds;

#define Tag_RopeView                777
#define Tag_NoStory_Alert           888
#define Tag_LocalStory_Count        999
#define Tag_Delete_Button           1111

#pragma mark - View lifecycle

- (void)dealloc {
    [_downloadList release];
    [_localList release];
    [_editButton release];
    [_sortButton release];
    [_popc release];
    [_arrowImageView release];
    [_storyUpdateAction release];
    [_sortRequestIds release];
    [super dealloc];
}

//编辑按钮
-(void)editorButtonPressed:(id)sender{
        
    if (!bIsEditing) {
        [self.editButton setImage:[UIImage imageNamed:@"myStory_done.png"] forState:UIControlStateNormal];
    }else{
        [self.editButton setImage:[UIImage imageNamed:@"myStory_editor.png"] forState:UIControlStateNormal];
    }
    bIsEditing = !bIsEditing;
    [self.tableView reloadData];
    
	if (_popc.popoverVisible) {
		self.arrowDirectionUp = NO;
		[_popc dismissPopoverAnimated:YES];
    }
}

-(void)refreshView:(id)sender{
    //切换到3G从后台回来时
    if ([BTUtilityClass checkIsWifiDownload]) {
        [[[BTDownLoadManager sharedInstance] queue] cancelAllOperations];
        
        for (BTStory *story in _downloadList) {
            story.state = StoryStatePausing;
        }
    }

    if ([BTDownLoadManager sharedInstance].bIsLimitDownload) {
        [ASIHTTPRequest setMaxBandwidthPerSecond:MAX_DOWNLOAD_BANDWIDTH_PER_SECOND];
    }
    
    [self generateDataSource];
    [_tableView reloadData];
}

//判断是否要显示界面顶部长绳视图
-(void)checkIfShowTopRopeView{
    
    if ([_downloadList count] == 0 && [_localList count] == 0) {
        UIView *rope = [self.view viewWithTag:Tag_RopeView];
        if (rope) {
            [rope removeFromSuperview];
        }
        
        UIView *alertView = [self.view viewWithTag:Tag_NoStory_Alert];
        if (!alertView) {
            UIImageView *noStoryAlert = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noLocalStoryAlert.png"]];
            [noStoryAlert setFrame:CGRectMake(0, 40, self.view.frame.size.width, 360)];
            noStoryAlert.tag = Tag_NoStory_Alert;
            [self.view addSubview:noStoryAlert];
            [noStoryAlert release];
        }
        
    }else{
        if (![self.view viewWithTag:Tag_RopeView]) {
            _ropeView.tag = Tag_RopeView;
            [self.view insertSubview:_ropeView belowSubview:self.tableView];
        }
        
        UIView *alertView = [self.view viewWithTag:Tag_NoStory_Alert];
        if (alertView) {
            [alertView removeFromSuperview];
        }
    }
}

//创建tableView所需的数据
-(void)generateDataSource{
    if (_downloadList) {
        [_downloadList release];
        _downloadList = nil;
    }
    if (_localList) {
        [_localList release];
        _localList = nil;
    }
    _downloadList = [[BTDownLoadManager sharedInstance].downLoadingStorys retain];
    _localList = [[BTDownLoadManager sharedInstance].localStorys retain];
	
    switch (_selectedSortIndex) {
        case 0:
            [self sortByDownload];
            break;
        case 1:
            [self sortByAlbumid];
            break;
        case 2:
            [self sortByPlayCounts];
            break;
        default:
            break;
    }
    
    localStoryCount = [_downloadList count] + [_localList count];
}

//显示本地故事的数量
-(void)showLocalStoryCount{
    
    int maxCount = [[BTUserDefaults valueForKey:CONFIGURATION_MAX_LOCAL_STORY] intValue];
    
    if (![self.tableView viewWithTag:Tag_LocalStory_Count]) {
        UILabel *localCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 20.0f, self.tableView.frame.size.width, 20.0f)];
        localCountLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        localCountLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        localCountLabel.textColor = [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0];
        localCountLabel.backgroundColor = [UIColor clearColor];
        localCountLabel.textAlignment = UITextAlignmentCenter;
        localCountLabel.tag = Tag_LocalStory_Count;
        localCountLabel.text = [NSString stringWithFormat:@"本地故事数量:%d/%d",localStoryCount,maxCount];
        [self.tableView addSubview:localCountLabel];
        [localCountLabel release];
    }else{
        
        UILabel *localCountLabel = (UILabel *)[self.tableView viewWithTag:Tag_LocalStory_Count];
        localCountLabel.text = [NSString stringWithFormat:@"本地故事数量:%d/%d",localStoryCount,maxCount];
    }
    
    if (localStoryCount == 0) {
        UILabel *localCountLabel = (UILabel *)[self.tableView viewWithTag:Tag_LocalStory_Count];
        [localCountLabel removeFromSuperview];
    }
}

//显示编辑按钮
-(void)showEditorButton{

    if ([_downloadList count] == 0 && [_localList count] == 0) {
        [self.editButton setHidden:YES];
        bIsEditing = NO;
    }else{
        [self.editButton setHidden:NO];
    }
    
}

//添加删除按钮
-(void)addDeleteButtonToCell:(UITableViewCell *)cell{
    UIButton *delBtn = [[UIButton alloc] initWithFrame:CGRectMake(245, 7, 70, 44)];
    [delBtn setImage:[UIImage imageNamed:@"myStory_cell_delete_btn.png"] forState:UIControlStateNormal];
    [delBtn addTarget:self action:@selector(deleteStory:) forControlEvents:UIControlEventTouchUpInside];
    delBtn.tag = Tag_Delete_Button;
    [cell.contentView addSubview:delBtn];
    delBtn.hidden = YES;
	[delBtn release];
}

#pragma mark-
#pragma mark 排序所用到的方法

//添加排序按钮到标题栏
-(void)addSortButtonToTopView{
    
    self.sortButton = [[[UIButton alloc] initWithFrame:CGRectMake(80,10,160,51)] autorelease];
	_sortButton.backgroundColor = [UIColor clearColor];
	[_sortButton addTarget:self action:@selector(sortButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
	BTAppDelegate *appDelegate = (BTAppDelegate *)[UIApplication sharedApplication].delegate;
	UIWindow *window = appDelegate.window;
	[window addSubview:_sortButton];
    
    UIImage *image = [UIImage imageNamed:@"ranklist_label_popoverArrowDown.png"];
    self.arrowImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(145-15, 30, 16, 12)] autorelease];
    _arrowImageView.image = image;
    [self.sortButton addSubview:_arrowImageView];
}

//删除排序按钮
-(void)removeSortButton{
    [_sortButton removeFromSuperview];
    self.sortButton = nil;
    self.arrowImageView = nil;
}

//排序按钮响应事件
-(void)sortButtonClicked:(UIButton *)button{
    [BTRQDReport reportUserAction:EventLocalStorySortTitleClicked];
    if (_popc == nil) {
        NSMutableArray *titles = [NSMutableArray arrayWithObjects:@"按下载顺序排列",@"按专辑顺序排列",@"按播放次数排列",nil];
		BTLocalSortViewController *contentVC = [[BTLocalSortViewController alloc] initWithSortTitles:titles];
		contentVC.selectedIndex = self.selectedSortIndex;
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
		self.arrowDirectionUp = YES;
		
		//调整弹出的popover位置
		CGRect rect = button.frame;
		rect.origin.y -= 20;
		rect.origin.x += 5;
		
		[_popc presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
	}
    
}

//设置下拉箭头方向
-(void)setArrowDirectionUp:(BOOL)arrowDirectionUp {
	
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

//按故事故事专辑id降序排序
-(void)sortByAlbumid{
	[BTRQDReport reportUserAction:EventLocalStorySortByCategoryOrderClicked];
    [_localList sortUsingDescriptors:[NSArray arrayWithObjects:
                                      [NSSortDescriptor sortDescriptorWithKey:KEY_STORY_ALBUMID ascending:NO],
                                      [NSSortDescriptor sortDescriptorWithKey:@"categoryName" ascending:YES selector:@selector(localizedStandardCompare:)],
                                      [NSSortDescriptor sortDescriptorWithKey:KEY_STORY_ORDERBY ascending:YES],
                                      [NSSortDescriptor sortDescriptorWithKey:@"storyId" ascending:NO selector:@selector(localizedStandardCompare:)],
                                      nil]];
    CDLog(BTDFLAG_LOCAL_SORT,@"################################");
    for (int i = 0; i < [_localList count]; i++) {
        BTStory *story = [_localList objectAtIndex:i];
        CDLog(BTDFLAG_LOCAL_SORT,@"albumid = %d,orderby = %d,categoryName = %@,storyid = %@",story.albumid,story.orderby,story.categoryName,story.storyId);
    }
}

//按点击下载的先后顺序排列
-(void)sortByDownload{
	[BTRQDReport reportUserAction:EventLocalStorySortByDownloadOrderClicked];
    [_localList sortUsingDescriptors:[NSArray arrayWithObjects:
                                      [NSSortDescriptor sortDescriptorWithKey:KEY_STORY_DOWNLOAD_STAMP ascending:NO],
                                      [NSSortDescriptor sortDescriptorWithKey:KEY_STORY_ORDERBY ascending:YES],
                                      nil]];
    
    CDLog(BTDFLAG_LOCAL_SORT,@"--------------------------------");
    for (int i = 0; i < [_localList count]; i++) {
        BTStory *story = [_localList objectAtIndex:i];
        CDLog(BTDFLAG_LOCAL_SORT,@"downloadStamp = %d,orderby = %d,",story.downloadStamp,story.orderby);
    }
}

//按故事的播放次数降序排列
-(void)sortByPlayCounts{
	[BTRQDReport reportUserAction:EventLocalStorySortByPlaybackCountOrderClicked];
    [_localList sortUsingDescriptors:[NSArray arrayWithObjects:
                                      [NSSortDescriptor sortDescriptorWithKey:KEY_STORY_PLAYCOUNTS ascending:NO],
                                      [NSSortDescriptor sortDescriptorWithKey:@"storyId" ascending:NO selector:@selector(localizedStandardCompare:)],
                                      nil]];
    
    CDLog(BTDFLAG_LOCAL_SORT,@"++++++++++++++++++++++++++++++++");
    for (int i = 0; i < [_localList count]; i++) {
        BTStory *story = [_localList objectAtIndex:i];
        CDLog(BTDFLAG_LOCAL_SORT,@"playCounts = %d,storyid = %@",story.playCounts,story.storyId);

    }
}

//点击某一排序的delegate
-(void)didSelectedAtIndex:(NSInteger)selectedIndex{
    self.arrowDirectionUp = NO;
    self.selectedSortIndex = selectedIndex;
    [BTUserDefaults setLocalSortIndex:_selectedSortIndex];
    [self generateDataSource];

    if (_popc) {
		[_popc dismissPopoverAnimated:YES];
	}
    [_tableView reloadData];
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

#pragma mark-
#pragma mark WEPopoverControllerDelegate
-(void)popoverControllerDidDismissPopover:(WEPopoverController *)popoverController {
	self.arrowDirectionUp = NO;
}

-(BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)popoverController {
	return YES;
}

#pragma mark- 
#pragma mark 315请求albumid和orderby

//通过“KEY_STORY_INFO_IS_UPDATED”字段判断是否要请求排序字段
-(NSMutableArray *)getStoryIdArrayBySortField{
    
    NSMutableArray *requestIds = [NSMutableArray array];
    
    NSString *plistPath = [BTUtilityClass fileWithPath:LOCALSTORY_PLIST_NAME_NEW];
    NSMutableArray *localStories = [NSMutableArray arrayWithContentsOfFile:plistPath];

    for (int i = 0; i < [localStories count]; i ++) {
        NSMutableDictionary *dic = [localStories objectAtIndex:i];
        BOOL isUpdated = [[dic objectForKey:KEY_STORY_INFO_IS_UPDATED] boolValue];
        if (!isUpdated) {
            int intId = [[dic objectForKey:KEY_STORY_ID] intValue];
            NSNumber *numberId = [NSNumber numberWithInt:intId];
            [requestIds addObject:numberId];
        }
    }
    
    return requestIds;
}

//发送315请求
-(void)sendUpateStoryInfoRequest{
    CDLog(BTDFLAG_LOCAL_SORT,@"requestIds = %@",_sortRequestIds);
    BOOL isNetworkAvailable = ![BTUtilityClass isNetWorkNotAvailable];
    if (isNetworkAvailable && _storyUpdateAction == nil) {
        BTStoryUpdateAction *action = [[BTStoryUpdateAction alloc] initWithRequestIds:_sortRequestIds];
        self.storyUpdateAction = action;
        _storyUpdateAction.actionDelegate = self;
        [_storyUpdateAction start];
        [action release];
    }
    
}
//315 delegate
-(void)onAction:(BTBaseAction *)action withData:(id)data{
    if (action == self.storyUpdateAction) {
        NSMutableDictionary *responseDic = [(NSMutableDictionary *)data retain];
        self.storyUpdateAction = nil;
        
        NSMutableArray *foundIds = [responseDic objectForKey:@"foundIds"];
        CDLog(BTDFLAG_LOCAL_SORT,@"foundIds = %@",foundIds);
        NSMutableArray *notFoundIds = [responseDic objectForKey:@"notFoundIds"];//请求排序字段的id中也有下架的故事，在@"notfound"字段中返回无数据的故事id数组
        CDLog(BTDFLAG_LOCAL_SORT,@"notFoundIds = %@",notFoundIds);
        [responseDic release];
        
        NSString *plistPath = [BTUtilityClass fileWithPath:LOCALSTORY_PLIST_NAME_NEW];
        NSMutableArray *localStories = [NSMutableArray arrayWithContentsOfFile:plistPath];
        
        //下架的故事id从请求数组中删除
        for (int i = 0; i < [notFoundIds count]; i ++) {
            NSNumber *notFoundId = [notFoundIds objectAtIndex:i];
            CDLog(BTDFLAG_LOCAL_SORT,@"315请求下架的故事storyid = %@,",notFoundId);
            for (int j = 0; j < [localStories count]; i++) {
                NSMutableDictionary *dic = [localStories objectAtIndex:i];
                int searchId = [[dic objectForKey:KEY_STORY_ID] intValue];
                if (searchId == [notFoundId intValue]) {
                    [dic setValue:[NSNumber numberWithBool:YES] forKey:KEY_STORY_INFO_IS_UPDATED];
                }
            }
            
            [_sortRequestIds removeObject:notFoundId];
        }
        
        CDLog(BTDFLAG_LOCAL_SORT,@"315请求下架id删除_sortRequestIds = %@,",_sortRequestIds);
        
        //返回数据的故事id从请求数组中删除
        for (int j = 0; j < [foundIds count]; j++) {
            BTStory *story = [foundIds objectAtIndex:j];
            for (int i = 0; i < [localStories count]; i++) {
                NSMutableDictionary *dic = [localStories objectAtIndex:i];
                NSString *sid = [dic objectForKey:KEY_STORY_ID];
                if ([story.storyId isEqualToString:sid]) {
                    [_sortRequestIds removeObject:[NSNumber numberWithInt:[sid intValue]]];
                    CDLog(BTDFLAG_LOCAL_SORT,@"315成功返回的故事数据storyid = %@,albumid = %d,orderby = %d",story.storyId,story.albumid,story.orderby);
                    [dic setValue:[NSNumber numberWithInteger:story.albumid] forKey:KEY_STORY_ALBUMID];
                    [dic setValue:[NSNumber numberWithInteger:story.orderby] forKey:KEY_STORY_ORDERBY];
                    [dic setValue:story.categoryName forKey:KEY_STORY_CATEGORY_NAME];
                    [dic setValue:[NSNumber numberWithBool:YES] forKey:KEY_STORY_INFO_IS_UPDATED];
                }
            }
        }
        [localStories writeToFile:plistPath atomically:YES];
        
        CDLog(BTDFLAG_LOCAL_SORT,@"315返回成功id删除_sortRequestIds = %@,",_sortRequestIds);
        
        if ([_sortRequestIds count] > 0) {
            [self sendUpateStoryInfoRequest];
        }
    }
}

- (void)onAction:(BTBaseAction*) action withError:(NSError*)error{
    if (action == self.storyUpdateAction) {
        self.storyUpdateAction = nil;
    }
}

#pragma mark-
#pragma mark viewAppear

-(void)viewDidLoad{
    [super viewDidLoad];
	
	self.viewTitle.text = @"本地故事";
	
    actionState = ACTION_NOTNEED;
    
    _loadMoreFooterView.visible = NO;
    
    bIsEditing = NO;
    
    self.selectedSortIndex = [BTUserDefaults localSortIndex];
    
    self.sortRequestIds = [self getStoryIdArrayBySortField];
}

-(void)viewWillAppear:(BOOL)animated{
    
    if ([_sortRequestIds count] > 0) {
        [self sendUpateStoryInfoRequest];
    }
    
    [super viewWillAppear:animated];
    [self refreshView:nil];

    BTAppDelegate *appDelegate = (BTAppDelegate *)[UIApplication sharedApplication].delegate;
    self.editButton = appDelegate.navView.editButton;
    [self.editButton remoteAllTargetAndActionsForControlEvents:UIControlEventTouchUpInside];    
    [self.editButton addTarget:self action:@selector(editorButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.editButton.hidden = NO;
    self.backButton.hidden = YES;
    
    [BTDownLoadManager sharedInstance].progressDelegate = self;

    [self checkIfShowTopRopeView];
    [self showLocalStoryCount];
    [self showEditorButton];
    [self addSortButtonToTopView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(modifyPlayStoryPlayingStatus:)
                                                 name:NOTIFICATION_PLAY_STORY object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshView:)
                                                 name:NOTIFICATION_REFRESH_MYSTORY_VIEW object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshView:)
                                                 name:@"UIApplicationWillEnterForegroundNotification" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [BTDownLoadManager sharedInstance].progressDelegate = nil;
    bIsEditing = NO;

    [self.tableView setEditing:NO];
    [self.editButton setImage:[UIImage imageNamed:@"myStory_editor.png"] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_PLAY_STORY object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_REFRESH_MYSTORY_VIEW object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIApplicationWillEnterForegroundNotification" object:nil];
}

-(void)modifyPlayStoryPlayingStatus:(NSNotification *)sender {
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.editButton.hidden = YES;
    [self removeSortButton];
	if (_popc.popoverVisible) {
		self.arrowDirectionUp = NO;
		[_popc dismissPopoverAnimated:YES];
    }
}

- (BTMyStoryDownloadCell*) findDownloadCellByStory:(BTStory*)story {
    BTMyStoryDownloadCell *downloadCell = nil;
    int storyIndex = [_downloadList indexOfObject:story];
    NSArray *visibleCells = [_tableView visibleCells];
    for (UITableViewCell *cell in visibleCells) {
        NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
        if ([cell isKindOfClass:[BTMyStoryDownloadCell class]] && indexPath.section == 0 && indexPath.row == storyIndex ) {
            downloadCell = (BTMyStoryDownloadCell*)cell;
            break;
        }
    }
    return downloadCell;
    
}

#pragma mark -
#pragma mark BTStroyProgressDelegate
- (void)setProgress:(float)newProgress story:(BTStory*)story {
    
    BTMyStoryDownloadCell *storyCell = [self findDownloadCellByStory:story];
    [storyCell setProgress:newProgress];
}

- (void)storyDownloadStarted:(BTStory*)story {
    
}

- (void)storyDownloadFinished:(BTStory*)story {
    [self generateDataSource];
    [_tableView reloadData];
}

- (void)storyDownloadError:(BTStory*)story {
    
    BTMyStoryDownloadCell *storyCell = [self findDownloadCellByStory:story];
    [storyCell update];

}

#pragma mark -
#pragma mark update cell

- (void)updateDownloadCell:(BTMyStoryDownloadCell *)cell withIndexPath:(NSIndexPath *)indexPath{
    
    [cell.bgButton setImage:[UIImage imageNamed:@"myStory_cell_bg.png"] forState:UIControlStateNormal];

    if([_downloadList count] > 0) {
        if (indexPath.row == [_downloadList count]-1 && [_localList count] == 0) {
            [cell.bgButton setImage:[UIImage imageNamed:@"myStory_cell_last_bg.png"] forState:UIControlStateNormal];
        }
    }
    BTStory *story =[_downloadList objectAtIndex:indexPath.row];
    if ([BTUtilityClass checkIsWifiDownload]) {
        story.state = StoryStatePausing;
    }
    //更新cell信息
    cell.story = story;
    [cell update];
    [cell setimageViewController:self];
}

- (void)updateLocalCell:(BTMyStroyCell *)cell withIndexPath:(NSIndexPath *)indexPath{
    
    [cell.bgButton setImage:[UIImage imageNamed:@"myStory_cell_bg.png"] forState:UIControlStateNormal];
    
    if ([_localList count] > 0) {
        if (indexPath.row == [_localList count]-1) {
            [cell.bgButton setImage:[UIImage imageNamed:@"myStory_cell_last_bg.png"] forState:UIControlStateNormal];
        }
    }
    BTStory *story =[_localList objectAtIndex:indexPath.row];
    
    //更新cell信息
    cell.story = story;
    [cell update];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    static NSString *downloadCell = @"myStoryDownloadCell";
    static NSString *localCell = @"myStoryCell";

    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:downloadCell];
        if (cell == nil) {
            cell = [[[BTMyStoryDownloadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:downloadCell] autorelease];
            [self addDeleteButtonToCell:cell];
        }
        [self updateDownloadCell:(BTMyStoryDownloadCell*)cell withIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:localCell];
        if (cell == nil) {
            cell = [[[BTMyStroyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:localCell] autorelease];
            [self addDeleteButtonToCell:cell];
        }
        [self updateLocalCell:(BTMyStroyCell*)cell withIndexPath:indexPath];
    }

    UIButton *btn = (UIButton *)[cell.contentView viewWithTag:Tag_Delete_Button];
    
    if (bIsEditing) {
        btn.hidden = NO;
    }else{
        btn.hidden = YES;
    }
    
    return cell;
}

-(void)deleteStory:(UIButton *)btn{
        
    BTMyStroyCell *buttonCell = (BTMyStroyCell *)[[btn superview] superview];
    NSIndexPath* pathOfTheCell = [_tableView indexPathForCell:buttonCell];
    NSInteger sectionOftheCell = [pathOfTheCell section];
    BTStory *story = buttonCell.story;
    
    if (sectionOftheCell == 0) {
        [_downloadList removeObject:story];
        [[BTDownLoadManager sharedInstance] removeRequestFromQueue:story];
    }else{
        [_localList removeObject:story];
        [[BTDownLoadManager sharedInstance] removeStoryFromLocal:story];
    }

    localStoryCount = [_downloadList count] + [_localList count];
    [self checkIfShowTopRopeView];
    [self showLocalStoryCount];
    [self showEditorButton];
    [self.tableView reloadData];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return [_downloadList count];
    } else {
        return [_localList count];
    }
}

-(void)showWifiDownloadOnlyAlert{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"仅在wifi网络下才能开始下载!\n如需修改，请设置【更多】中的【仅wifi下载故事】功能"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"设置", nil];
    [alert show];
    [alert release];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        BTAppDelegate *delegate = (BTAppDelegate *)[UIApplication sharedApplication].delegate;
        UIButton *btn = [delegate.tabCtr.tabBarItems objectAtIndex:3];
        [delegate.tabCtr tabChanged:btn];
    }
    
}

#pragma mark -
#pragma UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (bIsEditing) {
        return;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) { //downloading story
        BTMyStoryDownloadCell *cell = (BTMyStoryDownloadCell *)[tableView cellForRowAtIndexPath:indexPath];
        BTStory *story =[_downloadList objectAtIndex:indexPath.row];
        if ([BTUtilityClass checkIsWifiDownload]) {
            story.state = StoryStatePausing;
            [self showWifiDownloadOnlyAlert];
        }

        if (story.state == StoryStateWaiting || story.state == StoryStateDownLoading) {
            story.state = StoryStatePausing;
            [[BTDownLoadManager sharedInstance] pauseRequestWithStory:story];
        } else if (story.state == StoryStatePausing || story.state == StoryStateFailed) {
            if (![BTUtilityClass checkIsWifiDownload]) {
                story.state = StoryStateWaiting;
                [[BTDownLoadManager sharedInstance] addNewDownLoadTask:story];
            }
        } 
        [cell update];
    } else {
        BTStoryPlayerController *playerCtr = [BTPlayerManager sharedInstance].storyPlayer;
        BOOL bIsExist = [[self.navigationController viewControllers] containsObject:playerCtr];
        if (bIsExist) {
            CDLog(BTDFLAG_PRESS_PLAYING_CRASH,@"防止重复push");
            return;
        }
        playerCtr.bIsBackToCurrentPlayingLayer = NO;
        playerCtr.playList = _localList;
        playerCtr.playingStoryIndex = indexPath.row;
        playerCtr.storyType = StoryType_Local;
        [self.navigationController pushViewController:playerCtr animated:YES];
        [playerCtr playStory];
//        [storyList release];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 57.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}


@end
