//
//  BTHomeListViewController.m
//  AABabyTing3
//
//  Created by Neo Wang on 12-8-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTHomeListViewController.h"
#import "BTHomeData.h"
#import "Only320Network.h"
#import "BTChildrenRadioController.h"
#import "BTNewStoryListController.h"
#import "BTHotStoryListController.h"
#import "BTWellChosenListController.h"
#import "BTSotfWareListController.h"
#import "BTPlayerManager.h"
#import "BTStoryPlayerController.h"
#import "BTAppDelegate.h"
#import "BTWebViewController.h"
#import "BTStoryPlayerController.h"
#import "BTRadioData.h"
#import "BTChosenStoryListController.h"
#import "BTNecessarySoftController.h"
#import "BTRadioPlayerController.h"
@implementation BTHomeListViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc{
    [_bannerView release];
    [super dealloc];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    _bannerView = [[BTBannerView alloc] initWithDelegate:self];
	// Do any additional setup after loading the view.
}

- (void)initChildUI{
    [super initChildUI];
    //self.viewTitle.text = @"宝贝听听";
    self.viewTitle.text = @"宝贝听听";
    self.title =@"宝贝听听";
}

- (void)viewDidUnload{
    [super viewDidUnload];
	[_bannerView release];
	_bannerView = nil;
    // Release any retained subviews of the main view.
}
//重写父类的方法，因为首界面的数据更新机制和其他界面不一样，需要实时的更新
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIView *aboveView = [self.view viewWithTag:TAG_Retry_Button];
    if(aboveView){
        [aboveView removeFromSuperview];
    }
    self.backButton.hidden = YES;
    if(actionState!=ACTION_SENDING){
        self.waitingHUB = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        [self.navigationController.view addSubview:self.waitingHUB ];
        self.waitingHUB.frame = CGRectMake(self.navigationController.view.bounds.origin.x, self.navigationController.view.bounds.origin.y+61, self.navigationController.view.bounds.size.width,self.navigationController.view.bounds.size.height-61);
        self.waitingHUB .delegate = self ;
         actionState = ACTION_SENDING;
        [self.action start];
        
        
       
    }
    [self.tableView reloadData];
}
// 重写父类的方法（点击）
- (void)didSelectedAtObject:(id)object {
    BTHomeData *homeData = (BTHomeData *)object;
    m_homeData = homeData;
    NSString *type = homeData.type;
    
    //----------tiny modify begin--------------
    NSString *key = [NSString stringWithFormat:@"%@_home",homeData.homeID];
    [BTUtilityClass setBookIsOld:key];
    homeData.isNew = NO;
    
//    NSString *homeID = homeData.homeID;
//    NSString *newFlagForHome = [NSString stringWithFormat:@"%@%@",homeID,@"_new"];
//    NSString *newSelectedForHome = [NSString stringWithFormat:@"%@%@",homeData.homeID,@"_selected"];
//    [[NSUserDefaults standardUserDefaults] setValue:@"old" forKey:newFlagForHome];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:newSelectedForHome];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    //----------tiny modify end-----------------
    
//    switch (type) {
//        case 0:
//            [self enterRadioController:homeData];
//            break;
//        case 1:
//            [self enterNewStoryListController:homeData];
//            break;
//        case 2:
//            [self enterHotStoryListController:homeData];
//            break;
//        case 3:
//            [self enterGreatStoryListController:homeData];
//            break;
//        case 4:
//            [self enterParentSoftWareController:homeData];
//            break;
//        default:
//            break;
//    }
    if([type isEqualToString:@"radio"]){
        [self enterRadioController:homeData];
    }else if([type isEqualToString:@"newstory"]){
        [self enterNewStoryListController:homeData];
    }else if([type isEqualToString:@"rankstory"]){
        [self enterHotStoryListController:homeData];
    }else if([type isEqualToString:@"collection"]){
        [self enterGreatStoryListController:homeData];
    }else if([type isEqualToString:@"operate"]){
        [self enterParentSoftWareController:homeData];
    }else if ([BTUtilityClass isNetUrl:type]){
        [self enterWebView:homeData];
    }
}

//进入网页
- (void)enterWebView:(BTHomeData *)homedata{
//    BTWebViewController *webVC = [[BTWebViewController alloc] initWithUrl:homedata.type];
//    webVC.title = homedata.category;
//    self.viewTitle.text = homedata.category;
//    self.backButton.hidden = NO;
//    self.backButton.enabled = YES;
//    [self.navigationController pushViewController:webVC animated:YES];
}

//儿童故事电台
- (void)enterRadioController:(BTHomeData *)homeData{
	[BTRQDReport reportUserAction:EventHomeLayerRadioButtonClicked];
    NSInteger homeID = [homeData.homeID integerValue];
    BTChildrenRadioController *radioController = [[BTChildrenRadioController alloc] initWithHomeData:homeID];
    self.viewTitle.text=homeData.category;
    radioController.title = homeData.category;
    [self.navigationController pushViewController:radioController animated:YES];
    [radioController release];
}
//新故事首发
- (void)enterNewStoryListController:(BTHomeData *)homeData{
	[BTRQDReport reportUserAction:EventHomeLayerNewStoriesButtonClicked];
    NSInteger homeID = [homeData.homeID integerValue];
    BTNewStoryListController *newStoryListController = [[BTNewStoryListController alloc] initWithHomeData:homeID];
    self.viewTitle.text = homeData.category;
    newStoryListController.title = homeData.category;
    [self.navigationController pushViewController:newStoryListController animated:YES];
    [newStoryListController release];

}
//热门故事榜单
- (void)enterHotStoryListController:(BTHomeData *)homeData{
	[BTRQDReport reportUserAction:EventHomeLayerHotStoriesButtonClicked];
	NSInteger homeID = [homeData.homeID integerValue];
    BTHotStoryListController *hotStoryListController = [[BTHotStoryListController alloc] initWithHomeData:homeID];
    self.viewTitle.text = homeData.category;
    hotStoryListController.title = homeData.category;
    [self.navigationController pushViewController:hotStoryListController animated:YES];
    [hotStoryListController release];

}
//精选故事合集
- (void)enterGreatStoryListController:(BTHomeData *)homeData{
	[BTRQDReport reportUserAction:EventHomeLayerCollectionButtonClicked];
    NSInteger homeID = [homeData.homeID integerValue];
    BTWellChosenListController *wellChosenListController = [[BTWellChosenListController alloc] initWithHomeData:homeID];
    self.viewTitle.text = homeData.category;
    wellChosenListController.title = homeData.category;
    [self.navigationController pushViewController:wellChosenListController animated:YES];
    [wellChosenListController release];

}
//父母必备软件
- (void)enterParentSoftWareController:(BTHomeData *)homeData{
//    [BTRQDReport reportUserAction:EventHomeLayerRecommendSoftwareButtonClicked];
//    BTSotfWareListController *softwareListController = [[BTSotfWareListController alloc] init];
//    self.viewTitle.text=homeData.category;
//    softwareListController.title = homeData.category;
//    [self.navigationController pushViewController:softwareListController animated:YES];
//    [softwareListController release];
    
    [BTRQDReport reportUserAction:EventHomeLayerRecommendSoftwareButtonClicked];
    
//    NSString *unZipFolder = [[BTUtilityClass getBabyStoryFolderPath] stringByAppendingPathComponent:@"parent"];
    NSString *unZipFolder = [BTUtilityClass fileWithPath:@"parent"];
    NSString *path = [[NSBundle bundleWithPath:unZipFolder] pathForResource:@"index" ofType:@"html"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        BTNecessarySoftController *sc = [[BTNecessarySoftController alloc] init];
        [sc openWithHtmlFile:@"index"];
        [self.navigationController pushViewController:sc animated:YES];
        [sc release];
    }else{
        BTSotfWareListController *softwareListController = [[BTSotfWareListController alloc] init];
        self.viewTitle.text=homeData.category;
        softwareListController.title = homeData.category;
        [self.navigationController pushViewController:softwareListController animated:YES];
        [softwareListController release];
    }
    
}
// 重写父类的方法（更新cell）
- (void)updateTableViewCell:(UITableViewCell *)cell withObject:(id)object {
    BTHomeCell *homeCell = (BTHomeCell *)cell;
    BTHomeData *homeData = (BTHomeData *)object;
    homeCell.titleLabel.text = homeData.category;
    homeCell.descLabel.text = homeData.describe;
//    //是否显示new标签
//    NSString *newFlagForHome = [NSString stringWithFormat:@"%@%@",homeData.homeID,@"_new"];
//    NSString *newSelectedForHome = [NSString stringWithFormat:@"%@%@",homeData.homeID,@"_selected"];
//    NSString *judgeNew = [[NSUserDefaults standardUserDefaults] objectForKey:newFlagForHome];
//    NSString *selectedNew = [[NSUserDefaults standardUserDefaults] objectForKey:newSelectedForHome];
//    if ([judgeNew isEqualToString:@"old"] ){//&& [selectedNew isEqualToString:@"YES"]) {
//        homeCell.theNewFlagPic.hidden = YES;
//    }else{
//        if ([selectedNew isEqualToString:@"YES"]) {
//            homeCell.theNewFlagPic.hidden = YES;
//        }else{
//            homeCell.theNewFlagPic.hidden = NO;
//        }
//    }
    
    //是否显示new标签
    [homeCell drawCell:homeData];
    //homeCell.frame = CGRectMake(17, 11, 40, 40);
    NSString *type = homeData.type;
    homeCell.netImageView.viewController=self;
    homeCell.netImageView.tag = TAG_NetImage;
    if([type isEqualToString:@"radio"]){
        homeCell.netImageView.defaultImage = TTIMAGE(@"bundle://radio_type.png");
    }else if([type isEqualToString:@"newstory"]){
        homeCell.netImageView.defaultImage = TTIMAGE(@"bundle://newStory_type.png");
    }else if([type isEqualToString:@"rankstory"]){
        homeCell.netImageView.defaultImage = TTIMAGE(@"bundle://hotStory_type.png");
    }else if([type isEqualToString:@"collection"]){
        homeCell.netImageView.defaultImage = TTIMAGE(@"bundle://chosen_type.png");
    }else if([type isEqualToString:@"operate"]){
        homeCell.netImageView.defaultImage = TTIMAGE(@"bundle://parentSoft_type.png");
    }
    //homeCell.netImageView.type = type_home_icon;
    homeCell.netImageView.suffix = [BTUtilityClass getPicSuffix:type_home_icon picVersion:homeData.picVersion];
    homeCell.netImageView.urlPath = homeData.iconURL;
    

    if(homeCell.tag == TAG_Last_Cell){
        [homeCell.backButton setImage:[UIImage imageNamed:@"lastHomeCell.png"] forState:UIControlStateNormal];
    }else {
        [homeCell.backButton setImage:[UIImage imageNamed:@"homeCell.png"] forState:UIControlStateNormal];
    }
}
//如果有自定义的Cell，子类需要重写这个方法
- (UITableViewCell*) tableViewCellForRowAtIndexPath:(NSIndexPath *)indexPath cellIdentifier:(NSString*)identifier {
    UITableViewCell *cell = nil;
    if (cell == nil) {
        NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"BTHomeCell" owner:nil options:nil];
        cell = [objs lastObject];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65.0f;
}
//TODO: 这部分的设计需要重新考虑一下
- (BTBaseAction*)action {
    if (_baseAction == nil) {
        _baseAction = [[BTHomeAction alloc] init];
        _baseAction.actionDelegate = self;
    }
    return _baseAction;
}

#pragma mark -
#pragma mark BTOpenURLDelegate
/**
 * 运营跳转
 * type = 2／3时为运营跳转范围
 */
- (void)bannerOpenURL:(NSDictionary *)oneBannerInfo {
	
//	DLog(@"OneBannerInfo:%@",oneBannerInfo);
    int         type             = [[oneBannerInfo objectForKey:POPULARIZ_TYPE] intValue];//type = 2时为运营
    NSString	*activationStr   = [oneBannerInfo objectForKey:POPULARIZ_RUN_URL];
    NSURL       *urlActivationTo = [NSURL URLWithString:[activationStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSString    *activationToStr = [urlActivationTo scheme];    //大分类
    if (2 == type) {//运营
        if ([activationToStr isEqualToString:@"http"]) {
            // ---------------------------------
            // 打开网络,网址：url = activationStr
            // ---------------------------------
			//todo test
            NSString *urlStr = activationStr;//打开的url跳转地址
			BTWebViewController *webVC = [[BTWebViewController alloc] initWithUrl:urlStr];
			webVC.title             = @"活动";
			self.viewTitle.text     = @"活动";
            self.backButton.hidden  = NO;
			self.backButton.enabled = YES;
            if (webVC != nil) {
                [self.navigationController pushViewController:webVC animated:YES];
                [webVC release];
            }
        }
        else if([activationToStr isEqualToString:@"Self"]){
            // --------
            //  本地
            // --------
            //故事列表
            if ([[urlActivationTo host] isEqualToString:@"album"]) {//某个专辑
                NSArray *pathComponents = [activationStr pathComponents];
                if ([pathComponents count] > 3) {
                    NSString *storyListID       = [pathComponents objectAtIndex:2];
                    NSString *storyListTitle    = [pathComponents objectAtIndex:3];
//                    DLog(@"storyListTitle = %@",storyListTitle);
                    //push页面
                    BTOneBookStoryListController *bookListController = [[BTOneBookStoryListController alloc] initWithAlbumidID:storyListID];
                    self.viewTitle.text             = storyListTitle;
                    bookListController.title        = storyListTitle;
                    if (bookListController    != nil) {
                        [self.navigationController pushViewController:bookListController animated:YES];
                        [bookListController release];
                    }
                    
                }
            }
            else if([[urlActivationTo host] isEqualToString:@"collection"]){//某个合集
                NSArray *pathComponents = [activationStr pathComponents];
                if ([pathComponents count] > 3) {
                   NSString *bookListID         = [pathComponents objectAtIndex:2];
                    NSString *bookListTitle     = [pathComponents objectAtIndex:3];
                    int bookListintID           = [bookListID intValue];
//                    DLog(@"%d",bookListintID);
//                    DLog(@"%@",bookListTitle);
                    //push页面
                    BTChosenStoryListController *bookChosenController = [[BTChosenStoryListController alloc] initWithChosenID:bookListintID];
                    self.viewTitle.text               = bookListTitle;
                    bookChosenController.title        = bookListTitle;
                    if (bookChosenController    != nil) {
                        [self.navigationController pushViewController:bookChosenController animated:YES];
                        [bookChosenController release];
                    }
                }
            }
            //主列表（首页的子菜单单页)
            else if([[urlActivationTo host] isEqualToString:@"mainlist"])
            {
                NSArray *pathComponents = [activationStr pathComponents];
//                DLog(@"pathComponents = %@",pathComponents);
                 if ([pathComponents count] > 4) {  //防止url错误
                     if ([[pathComponents objectAtIndex:4] isEqualToString:@"collection"]) {// 精选故事合集
                         int bookListintID              = [[pathComponents objectAtIndex:2] intValue];  //id
                         NSString *goodBookListTitle    = [pathComponents objectAtIndex:3];             //title
                         //push页面
                         BTWellChosenListController *wellChosenListController = [[BTWellChosenListController alloc] initWithHomeData:bookListintID];
                         self.viewTitle.text            = goodBookListTitle;
                         wellChosenListController.title = goodBookListTitle;
                         if (wellChosenListController != nil) {
                             [self.navigationController pushViewController:wellChosenListController animated:YES];
                             [wellChosenListController release];
                         }
                     }
                     else if ([[pathComponents objectAtIndex:4] isEqualToString:@"newstory"]) {// 新故事首发  
                         int newListintID               = [[pathComponents objectAtIndex:2] intValue];//id
                         NSString *newBookListTitle     = [pathComponents objectAtIndex:3];           //title
                         //push页面
                         BTNewStoryListController *newStoryListController = [[BTNewStoryListController alloc] initWithHomeData:newListintID];
                         self.viewTitle.text = newBookListTitle;
                         newStoryListController.title = newBookListTitle;
                         if (newStoryListController != nil) {
                             [self.navigationController pushViewController:newStoryListController animated:YES];
                             [newStoryListController release];
                         }
                     }
                     else if ([[pathComponents objectAtIndex:4] isEqualToString:@"rankstory"]) {// 故事排行榜   
                         int rankListintID              = [[pathComponents objectAtIndex:2] intValue];//id
                         NSString *rankBookListTitle    = [pathComponents objectAtIndex:3];           //title
                         //push页面
                         BTHotStoryListController *hotStoryListController = [[BTHotStoryListController alloc] initWithHomeData:rankListintID];
                         self.viewTitle.text = rankBookListTitle;
                         hotStoryListController.title = rankBookListTitle;
                         if (hotStoryListController != nil) {
                             [self.navigationController pushViewController:hotStoryListController animated:YES];
                             [hotStoryListController release];
                         }
                     }
                     else if ([[pathComponents objectAtIndex:4] isEqualToString:@"operate"]) {// 父母必备 
                         NSString *operateBookListTitle = [pathComponents objectAtIndex:3];  //title
//                         DLog(@"%@",operateBookListTitle);
                         //push页面
                         BTSotfWareListController *softwareListController = [[BTSotfWareListController alloc] init];
                         self.viewTitle.text=operateBookListTitle;
                         softwareListController.title = operateBookListTitle;
                         [self.navigationController pushViewController:softwareListController animated:YES];
                         [softwareListController release];
                     }
                     else if ([[pathComponents objectAtIndex:4] isEqualToString:@"radio"]) {// 儿童故事电台 
                         int radioBookListintID         = [[pathComponents objectAtIndex:2] intValue];//id
                         NSString *radioBookListTitle   = [pathComponents objectAtIndex:3];           //title
                         //push页面
                         BTChildrenRadioController *radioController = [[BTChildrenRadioController alloc] initWithHomeData:radioBookListintID];
                         self.viewTitle.text    = radioBookListTitle;
                         radioController.title  = radioBookListTitle;
                         if (radioController != nil) {
                             [self.navigationController pushViewController:radioController animated:YES];
                             [radioController release];
                         }
                     }
                 }
            }
            //某电台
            else if([[urlActivationTo host] isEqualToString:@"radio"])
            {
                NSArray *pathComponents = [activationStr pathComponents];
                if ([pathComponents count] > 1) {
                    NSString *someRadioID   = [pathComponents objectAtIndex:2];
                    //push页面
                    BTRadioData *radio = [[BTRadioData alloc] init];
                    radio.radioID      = someRadioID;
                    
                    
                    BTRadioPlayerController *radioCtr = [BTPlayerManager sharedInstance].radioPlayer;
                    BOOL bIsExist = [[self.navigationController viewControllers] containsObject:radioCtr];
                    if (bIsExist) {
                        //2012.11.29 nate add 内存泄漏
                        [radio release];
                        //2012.11.29 nate end
                        CDLog(BTDFLAG_PRESS_PLAYING_CRASH,@"防止重复push");
                        return;
                    }
                    radioCtr.bIsBackToCurrentPlayingLayer = NO;
                    radioCtr.storyType = StoryType_Radio;
                    radioCtr.radio = radio;
                    [self.navigationController pushViewController:radioCtr animated:YES];
                    [radioCtr startRequestRadio];
                    
					[radio release];
                }
            }
            //专辑列表
            else if([[urlActivationTo host] isEqualToString:@"albumlist"])
            {
                NSArray *pathComponents = [activationStr pathComponents];
//                DLog(@"pathComponents = %@",pathComponents);
                if ([pathComponents count] > 4) {
                    NSString *albumType     = [pathComponents objectAtIndex:2];
                    NSString *albumID       = [pathComponents objectAtIndex:3];
                    NSString *albumTitle    = [pathComponents objectAtIndex:4];
                    int      albumIDint     = [albumID intValue];
//                    DLog(@"albumIDint = %d",albumIDint);
//                    DLog(@"albumType = %@",albumType);
//                    DLog(@"albumTitle = %@",albumTitle);
                    //push页面
                    BTBookListController *booklistController = [[BTBookListController alloc] initWithCategoryID:albumIDint type:albumType];
                    self.viewTitle.text    = albumTitle;
                    booklistController.title  = albumTitle;
                    if (booklistController != nil) {
                        [self.navigationController pushViewController:booklistController animated:YES];
                        [booklistController release];
                    }     
                }
            }
        }
        else {
            return;
        }  
    }
    else if (3 == type){//砸蛋活动
            // ---------------------------------
            // 打开网络,网址：url = activationStr
            // ---------------------------------
			BTWebViewController *webVC = [[BTWebViewController alloc] initWithUrl:activationStr];//打开的url跳转地址
			webVC.title             = @"活动";
			self.viewTitle.text     = @"活动";
            self.backButton.hidden  = NO;
			self.backButton.enabled = YES;
            if (webVC != nil) {
                [self.navigationController pushViewController:webVC animated:YES];
                [webVC release];
            }
    }
    else{
        return;
    }
}

- (void)onAction:(BTBaseAction *)action withData:(id)data{
    if([data isKindOfClass:[BTListInfo class]]){
        NSArray *typeArr =[NSArray arrayWithObjects:@"radio",@"newstory",@"rankstory",@"collection",@"operate", nil];
        BTListInfo *info = (BTListInfo*)data;
        NSMutableArray *tmpArr = info.result;
        NSMutableArray *dealArr = [NSMutableArray array];
        for (BTHomeData *homeData in tmpArr) {
            if([self isExist:typeArr str:homeData.type]){
                [dealArr addObject:homeData];
            }
        }
        BTListInfo *listInfo = [[[BTListInfo alloc] init] autorelease];
        listInfo.result = dealArr;
        listInfo.countInNet= info.countInNet;
        self.tableView.tableHeaderView = _bannerView;
        [super onAction:action withData:listInfo];
    }
}
- (void)requestNullData{
    self.tableView.tableHeaderView = nil;
    UIButton * retryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    retryBtn.frame = CGRectMake(0, 40, 320, 370);
    [retryBtn setBackgroundImage:[UIImage imageNamed:@"netWorkFail.png"] forState:UIControlStateNormal];
    [retryBtn addTarget:self action:@selector(retryAction:) forControlEvents:UIControlEventTouchUpInside];
    retryBtn.tag = TAG_NONetWork_Button;
    //retryBtn.tag = TAG_Retry_Button;
    [self.view addSubview:retryBtn];
}
- (void)onAction:(BTBaseAction *)action withError:(NSError *)error{
    [super onAction:action withError:error];
}

- (BOOL)isExist:(NSArray *)arr str:(NSString *)str{
    if([arr isKindOfClass:[NSArray class]]&& [str isKindOfClass:[NSString class]]){
        for(NSString *tmpStr in arr){
            if([tmpStr isEqualToString:str]){
                return YES;
            }
        }
    }
    return NO;
}
@end
