//
//  BTCategoryListController.m
//  AABabyTing3
//
//  Created by Neo Wang on 12-8-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTCategoryListController.h"
#import "BTCategoryData.h"
#import "BTCategoryAction.h"
#import "BTBigCategoryCell.h"
#import "BTBookListController.h"
#import "BTDataManager.h"
#import "BTUtilityClass.h"
#import "BTSearchListView.h"
#import "BTDownLoadAlertView.h"

@interface BTCategoryListController()

@end

@implementation BTCategoryListController

- (void)dealloc{
    [_historyRecord release];
    [super dealloc];
}

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
    _loadMoreFooterView.visible = YES;
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)initChildUI{
    [super initChildUI];
    //self.viewTitle.text = @"宝贝听听";
    self.viewTitle.text = @"故事分类";
    self.title =@"故事分类";
}

#pragma mark -
#pragma mark searchDelegate

- (void)setCellEnable:(BOOL)enable{
    NSArray *cells = [self.tableView visibleCells];
    for(UITableViewCell *cell in cells){
        [cell setUserInteractionEnabled:enable];
    }
}

- (void)maskViewTap:(id)sender{
    BTSearchView *view = (BTSearchView *)self.tableView.tableHeaderView;
    [view cancelButtonPressed:nil];
}

-(void)searchViewAppear{
    self.tableView.scrollEnabled = NO;
    if(!_maskView){
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 118, 320, 300)];
        [self.view addSubview:_maskView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskViewTap:)];
        tap.delegate = self;
        [_maskView addGestureRecognizer:tap];
        [tap release];
        [_maskView release];        
    }
    [self setCellEnable:NO];
}

-(void)searchViewDisappear:(NSString *)keyWord{
    self.tableView.scrollEnabled = YES;
    [self setCellEnable:YES];
    if(_maskView){
        [_maskView removeFromSuperview];
        _maskView = nil;
    }
    if(keyWord == nil){
        return;
    }
    if([keyWord isEqualToString:@""]&&keyWord.length==0){
        [[BTDownLoadAlertView sharedAlertView] showDownLoadCompleteAlertWithString:@"请输入搜索内容"];
        [BTDownLoadAlertView showAlert];
        return;
    }
    _historyRecord = [keyWord retain];
    [keyWord release];
    BTSearchListView *searchView =  [[BTSearchListView alloc] initWithKeyWord:_historyRecord];
    searchView.title = @"搜索结果";
    self.viewTitle.text = @"搜索结果";
    [self.navigationController pushViewController:searchView animated:YES];
	[searchView release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    BTSearchView   *view = (BTSearchView *)self.tableView.tableHeaderView;
    if([view isKindOfClass:[BTSearchView class]]){
        _historyRecord = [[view textFieldContent] retain];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tableView.scrollEnabled = YES;
    UIView *aboveView = [self.view viewWithTag:TAG_Retry_Button];
    if(aboveView){
        [aboveView removeFromSuperview];
    }
    if(self.backButton) {
        self.backButton.hidden = YES;
    }
    
    if(actionState!=ACTION_SENDING){
        self.waitingHUB = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        [self.navigationController.view addSubview:self.waitingHUB ];
        self.waitingHUB.frame = CGRectMake(self.navigationController.view.bounds.origin.x, self.navigationController.view.bounds.origin.y+61, self.navigationController.view.bounds.size.width,self.navigationController.view.bounds.size.height-61);
        self.waitingHUB .delegate = self ;
        self.action.actionType = defaultAction;
        actionState = ACTION_SENDING;
        [self.action start];
        
    }
    UIView *view = [self.view viewWithTag:pullUpdateViewTag];
    
    BTDataManager *manger = [BTDataManager shareInstance];
    
#warning 使用dataManger    待考虑
    if(!view && manger.bigCategoryArrayInfo.countInNet!= self.countInNet){
        if (_loadMoreFooterView == nil) {
            _loadMoreFooterView = [[LoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0.0f, self.tableView.contentSize.height, self.tableView.frame.size.width, self.tableView.bounds.size.height)];
            _loadMoreFooterView.delegate = self;
            _loadMoreFooterView.visible = YES;
            _loadMoreFooterView.backgroundColor = [UIColor clearColor];
            _loadMoreFooterView.tag = pullUpdateViewTag;
            [self.tableView addSubview:_loadMoreFooterView];
        }

    }
}

// 重写父类的方法（点击）
- (void)didSelectedAtObject:(id)object {

    BTCategoryData *data = (BTCategoryData *)object;
    BTBookListController *bookListController = [[BTBookListController alloc] initWithCategoryID:data.categoryID type:data.type];
    bookListController.title = data.title;
    self.viewTitle.text = data.title;
    [self.navigationController pushViewController:bookListController animated:YES];
    [bookListController release];

    
}

// 重写父类的方法（更新cell）
- (void)updateTableViewCell:(UITableViewCell *)cell withObject:(id)object {
    BTBigCategoryCell *categoryCell = (BTBigCategoryCell *)cell;
    BTCategoryData *categoryData = (BTCategoryData *)object;
    [categoryCell setImageController:self];
    [categoryCell drawCell:categoryData];
    //DLog(@"categoryData.title = %@",categoryData.title);
    if(cell.tag == TAG_Last_Cell){
        [categoryCell.backButton setImage:[UIImage imageNamed:@"lastBigCategoryCell.png"] forState:UIControlStateNormal];
    }else {
        [categoryCell.backButton setImage:[UIImage imageNamed:@"bigCategoryCell.png"] forState:UIControlStateNormal];
    }
    
}


//如果有自定义的Cell，子类需要重写这个方法
- (UITableViewCell*) tableViewCellForRowAtIndexPath:(NSIndexPath *)indexPath cellIdentifier:(NSString*)identifier {
    UITableViewCell *cell = nil;
    if (cell == nil) {
        NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"BTBigCategoryCell" owner:nil options:nil];
        cell = [objs lastObject];
    }
    return cell;
}

- (BTBaseAction*)action {
    if (_baseAction == nil) {
        NSInteger lastID = 0;
        if([self.itemArray count]>0){
            BTCategoryData *data = [self.itemArray lastObject];
            lastID = data.categoryID;
        }
        _baseAction = [[BTCategoryAction alloc] initWithLastID:lastID len:[self.itemArray count]];
        _baseAction.actionDelegate = self;
    }
    return _baseAction;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85.0f;
}


- (void)loadMoreTableFooterDidTriggerRefresh:(LoadMoreTableFooterView *)view {
    
	[self reloadTableViewDataSource];
	//[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    
}

- (BOOL)loadMoreTableFooterDataSourceIsLoading:(LoadMoreTableFooterView *)view {
	return _reloading;
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

- (void)onAction:(BTBaseAction *)action withData:(id)data{
    [super onAction:action withData:data];
    BTSearchView *searchView = [[BTSearchView alloc] initWithFrame:CGRectMake(0, 0, 320, 57+61)];
    searchView.delegate = self;
    if(_historyRecord != nil && ![_historyRecord isEqualToString:@""]){
        [searchView setSearchState:_historyRecord];
    }
    self.tableView.tableHeaderView = searchView;
    [searchView release];
}
@end
