//
//  BTListViewController.m
//  AABabyTing3
//
//  Created by He baochen on 12-8-14.
//
//

#import "BTListViewController.h"
#import "MBProgressHUD.h"
#import "BTUtilityClass.h"
#import "BTAppDelegate.h"


@interface BTListViewController ()

@end

@implementation BTListViewController
@synthesize itemArray = _itemArray,itemDictionary = _itemDictionary,waitingHUB = _waitingHUB;
@synthesize action = _baseAction,countInNet = _countInNet;


- (id)init{
    self = [super init];
    if(self){
        //_bIsActionComplete = NO;
        actionState = ACTION_NOT_BEGIN;
        //_viewTitle = [[FXLabel alloc] initWithFrame:CGRectMake(80,20,160,51)];
        _ropeView = [[BTRopeView alloc] initWithFrame:CGRectMake(0, 0, 320, 61)];
        _lastScrollOffsetY = 0.0f;
        _ropeViewHeight  = 61.0f;
        _itemArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    [_ropeView release];
    [_itemArray release];
    [_waitingHUB release];
    [_itemDictionary release];
    [self releaseAction];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(actionState != ACTION_REQUESTFINISH&&actionState != ACTION_NOTNEED &&[self.tableView.visibleCells count]==0){
        _waitingHUB = [[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES] retain];
        _waitingHUB.frame = CGRectMake(self.navigationController.view.bounds.origin.x, self.navigationController.view.bounds.origin.y+61, self.navigationController.view.bounds.size.width,self.navigationController.view.bounds.size.height-61);
        [self.navigationController.view addSubview:_waitingHUB];
        _waitingHUB.delegate = self;
        actionState = ACTION_SENDING;
        [self.action start];
        self.action.actionType = defaultAction;
        
    }
}

- (void)removeErrTips{
    UIView *tip1 = [self.view viewWithTag:TAG_Retry_Button];
    if(tip1){
        [tip1 removeFromSuperview];
    }
    UIView *tip2 = [self.view viewWithTag:TAG_NONetWork_Button];
    if(tip2){
        [tip2 removeFromSuperview];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(actionState != ACTION_REQUESTFINISH &&actionState != ACTION_REQUESTERROR&&actionState != ACTION_NOTNEED){
        actionState = ACTION_NOT_BEGIN;
    }
    [self removeErrTips];
    [self releaseAction];
    [self doneLoadingTableViewData];
}

- (void)viewDidLoad{
    [super viewDidLoad];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    return [_itemArray count];
}

//如果有自定义的Cell，子类需要重写这个方法
- (UITableViewCell*) tableViewCellForRowAtIndexPath:(NSIndexPath *)indexPath cellIdentifier:(NSString*)identifier {
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    return cell;
}

- (void) updateTableViewCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSObject *obj = [self objectAtIndexPath:indexPath];

    switch (indexPath.row) {
        case 0:
            cell.tag = TAG_First_Cell;
            break;
        case 1:
            cell.tag = TAG_Second_Cell;
            break;
        case 2:
            cell.tag = TAG_Third_Cell;
            break;
        default:
            cell.tag = TAG_Default_Cell;
            break;
    }
    if(indexPath.row == [_itemArray count]-1){
        cell.tag = TAG_Last_Cell;
    }
    [self updateTableViewCell:cell withObject:obj];
    
    


}

#pragma mark -
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSObject *obj = [self objectAtIndexPath:indexPath];
    if (cellSelected) {
    [self didSelectedAtObject:obj];
        cellSelected = NO;
    }
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        [self doCell:cell];
    }
    
}


//点击某一条目后，处理相关cell界面
- (void)doCell:(UITableViewCell *)cell{
    
}
#pragma mark -
//从数组中拿到业务对象
- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    id obj = nil;
    if (indexPath.row < [_itemArray count]) {
        obj = [_itemArray objectAtIndex:indexPath.row];
    }
    return obj;
}

// 子类重写这个方法实现点击Row
- (void)didSelectedAtObject:(id)object {
#warning
}

// 子类重写这个方法实现更新Cell
- (void)updateTableViewCell:(UITableViewCell *)cell withObject:(id)object {
#warning
}

#pragma mark BTBaseActionDelegate
/*
 NSError的userInfo属性包括两个Key
 kAlertType:Controller根据这个类型来显示提示框的类型，或者不显示
 kErrorMsg:错误的文字描述，面向的，用户友好的
 */
- (void)onAction:(BTBaseAction*) action withError:(NSError*)error{
	CDLog(BTDFLAG_RANKLIST,@"ListViewController.m-->error:%@",error);
    actionState = ACTION_REQUESTERROR;
    [self releaseAction];
    [_waitingHUB hide:YES];
    
    [self doneLoadingTableViewData];
    [self.tableView reloadData];
    [self doneLoadingTableViewData];
    if([error.domain isEqualToString:ERROR_CODE_DOMAIN]&&error.code == ERROR_CODE_NONETWORK){
        //没有网络
        if([[self.tableView visibleCells]count] == 0){//数据失效之后，重新拉取的时候，如果没有网络，不给任何提示。（主要是在首界面和故事分类这2个根目录下会产生这样的问题。）
            UIButton * retryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            retryBtn.frame = CGRectMake(0, 40, 320, 370);
            [retryBtn setBackgroundImage:[UIImage imageNamed:@"noNetWorkBg.png"] forState:UIControlStateNormal];
            [retryBtn addTarget:self action:@selector(retryAction:) forControlEvents:UIControlEventTouchUpInside];
            retryBtn.tag = TAG_Retry_Button;
            [self.view addSubview:retryBtn];
        }
    }else{
        if([[self.tableView visibleCells]count]== 0){
            UIButton * retryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            retryBtn.frame = CGRectMake(0, 40, 320, 370);
            [retryBtn setBackgroundImage:[UIImage imageNamed:@"netWorkFail.png"] forState:UIControlStateNormal];
            [retryBtn addTarget:self action:@selector(retryAction:) forControlEvents:UIControlEventTouchUpInside];
            retryBtn.tag = TAG_NONetWork_Button;
            //retryBtn.tag = TAG_Retry_Button;
            [self.view addSubview:retryBtn];
        }
    }
}

- (void)onAction:(BTBaseAction*) action withData:(id)data  {
    actionState = ACTION_REQUESTFINISH;
    if([data isKindOfClass:[NSMutableArray class]]){
        self.itemArray = data;
    }else if([data isKindOfClass:[NSMutableDictionary class]]){
        NSMutableArray *arrayList = [data objectForKey:@"ArrayList"];
        self.itemArray = arrayList;
        self.itemDictionary = data;
    }else if([data isKindOfClass:[BTListInfo class]]){
		CDLog(BTDFLAG_RANKLIST,@"data is BTListInfo");
        BTListInfo *info = (BTListInfo*)data;
        self.itemArray = info.result;
        self.countInNet = info.countInNet;
    }
    if(self.itemArray.count==0){
        [self releaseAction];
        [_waitingHUB hide:YES];
        [self requestNullData];
        return;
    }
    if(!_ropeView.superview){
        [self.view insertSubview:_ropeView belowSubview:self.tableView];
    }
    [self doneLoadingTableViewData];
    [self.tableView reloadData];
    [self releaseAction];
    [_waitingHUB hide:YES];
    
    if([self.itemArray count]>=self.countInNet){
//        _loadMoreFooterView.visible = NO;
        [_loadMoreFooterView removeFromSuperview];
        //[self.tableView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
        [self doneLoadingTableViewData];
        _loadMoreFooterView = nil;
    } else {
		if (_loadMoreFooterView == nil) {
			_loadMoreFooterView = [[LoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0.0f, self.tableView.contentSize.height, self.tableView.frame.size.width, self.tableView.bounds.size.height)];
			_loadMoreFooterView.delegate = self;
			_loadMoreFooterView.visible = YES;
			_loadMoreFooterView.backgroundColor = [UIColor clearColor];
			[self.tableView addSubview:_loadMoreFooterView];
			_loadMoreFooterView.tag = pullUpdateViewTag;
		}
	}
}
#pragma mark -
- (void)retryAction:(id)sender{
    if(sender){
        UIButton *btn = (UIButton *)sender;
        [btn removeFromSuperview];
    }
    _waitingHUB = [[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES] retain];
    [self.navigationController.view addSubview:_waitingHUB];
    _waitingHUB.delegate = self;
    [self.action start];
    actionState = ACTION_SENDING;
}

- (void)requestNullData{
    DLog(@"kong");
}

#pragma mark -
- (void) releaseAction {
    if (_baseAction != nil) {
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

// 子类重写这个方法,创建具体的BTBaseAction的子类
- (BTBaseAction*)action {

    if (_baseAction == nil) {
        _baseAction = [[BTBaseAction alloc] init];
        _baseAction.actionDelegate = self;
    }
    return _baseAction;
}


- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[_waitingHUB removeFromSuperview];
	[_waitingHUB release];
	_waitingHUB = nil;
}


//判断全部下载按钮的状态
-(void)checkAllDownLoadButtonEnable {
    UIView *headerView = [_tableView tableHeaderView];
    UIButton *btn = (UIButton *)[headerView viewWithTag:TAG_ALL_STORY_DOWNLOAD_BUTTON];
    
    BOOL flag = NO;
    
    for (int i = 0; i < [_itemArray count]; i++) {
        BTStory *story = [_itemArray objectAtIndex:i];
        if (![[BTDownLoadManager sharedInstance] isInMyStoryList:story]) {
            //可全部下载 
            flag = YES;
            break;
        }   
    }
    
    if (flag) {
        [btn setImage:[UIImage imageNamed:@"allDownloadBtn.png"] forState:UIControlStateNormal];
        [btn setEnabled:YES];
    } else {
        [btn setImage:[UIImage imageNamed:@"allHasDownloadBtn.png"] forState:UIControlStateNormal];
        [btn setEnabled:NO];
    }
}


-(void)showDownloadProgressAlert{
    [[BTShowAllDownloaAlert sharedInstance] showAlert];
    [BTShowAllDownloaAlert sharedInstance].delegate = self;
    [[BTShowAllDownloaAlert sharedInstance] setDownloadProgress:0];
}

#pragma mark -

#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    self.action.actionType = nextPageAction;
    [self.action start];
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;

	[_loadMoreFooterView loadMoreScrollViewDataSourceDidFinishedLoading:self.tableView];
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	[super scrollViewDidScroll:scrollView];
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat scrollDistance = offsetY -_lastScrollOffsetY;
    _lastScrollOffsetY = offsetY;
    _ropeViewHeight = _ropeViewHeight - scrollDistance;
    _ropeView.frame = CGRectMake(0,0, _ropeView.frame.size.width, _ropeViewHeight);
	[_loadMoreFooterView loadMoreScrollViewDidScroll:scrollView];	
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
	[_loadMoreFooterView loadMoreScrollViewDidEndDragging:scrollView];
	
}

- (void)loadMoreTableFooterDidTriggerRefresh:(LoadMoreTableFooterView *)view {
    
	[self reloadTableViewDataSource];
	//[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    
}

- (BOOL)loadMoreTableFooterDataSourceIsLoading:(LoadMoreTableFooterView *)view {
	return _reloading;
}




@end
