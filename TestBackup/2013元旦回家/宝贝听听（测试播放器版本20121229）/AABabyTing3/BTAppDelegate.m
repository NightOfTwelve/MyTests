//
//  BTAppDelegate.m
//  AABabyTing3
//
//  Created by Neo Wang on 12-8-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTAppDelegate.h"
#import "BTTestListViewController.h"
#import "BTCustomTabBarController.h"
#import "BTTabBarItem.h"
#import "BTHomePageController.h"
#import "BTCategoriesController.h"
#import "BTMystoriesController.h"
#import "BTMoreController.h"
#import "BTDataManager.h"
#import "BTUtilityClass.h"
#import "BTConstant.h"
#import "BTCheckinManager.h"
#import "BTLocalStoriesCountAction.h"
#import "BTStoryDownloadedCountAction.h"
#import "BTPlayedCountStatisticAction.h"
#import "BTRQDReport.h"
#import "BTTokenReportAction.h"
#import "BTConfigurationRequestAction.h"
#import <Analytics/AnalyticsInterface.h>
#import <Analytics/CrashReporter.h>
#import "BTGiftEggsAction.h"
#import "BTSearchAction.h"
#import "BTBannerStatisticsReportAction.h"
#import "BTRadioPlayerController.h"
#import "BTBannerRefresher.h"
#import "BTCacheCleanController.h"
#import "ZZRootViewController.h"


#define splashHolidayTime  4.0f
#define splashShowTime     1.0f
#define splashSHowFromBackTime 2.0f
#define splashFadeIn       0.0f
#define splashFadeOut      1.0f
#define splashDisappear    .3f
#define splashGuoduoFadeIn  0.0f
@interface BTAppDelegate ()
@property (nonatomic, retain) BTBannerStatisticsReportAction *bannerReportAction;
@property (nonatomic, retain) BTPlayedCountStatisticAction	*playedCountAction;
@property (nonatomic, retain) BTLocalStoriesCountAction		*localCountAction;
@property (nonatomic, retain) BTStoryDownloadedCountAction	*storyDownedAction;
@property (nonatomic, retain) BTTokenReportAction			*tokenReportAction;
@property (nonatomic, retain) BTConfigurationRequestAction	*configurationRequestAction;
@property (nonatomic, retain) NSDate						*startAppDate;
@property (nonatomic, retain) NSString						*lastDisplaySplashDate;

- (void)copyLocalStoryImageFromCacheToDocumentFolder;
- (void)renameLocalStory;
@end

@implementation BTAppDelegate
@synthesize window = _window;
@synthesize tabCtr = _tabCtr;
@synthesize playedCountAction, localCountAction, storyDownedAction,tokenReportAction;
@synthesize configurationRequestAction;
@synthesize startAppDate;
@synthesize lastDisplaySplashDate;
@synthesize navView= _navView;
@synthesize isFromBackground;
@synthesize isRenrenShareShowing;
@synthesize zwindow = _zwindow;

- (void)dealloc
{
	self.lastDisplaySplashDate = nil;
	self.startAppDate = nil;
	self.configurationRequestAction = nil;
	self.bannerReportAction = nil;
	self.tokenReportAction = nil;
	self.playedCountAction = nil;
	self.localCountAction = nil;
	self.storyDownedAction = nil;
    [testArray release];
    [_navView release];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [[BTDownLoadManager sharedInstance] destorySharedInstance];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [_window release];
    [_tabCtr release];
    [checkinAction release];
    [sourceUpdateAction release];
    [_splashAction release];
    [softAction release];
    softAction = nil;
    [self cleanSplashAction];
    [super dealloc];
}

- (void)didReceiveMemoryWarning{
    [[[BTDownLoadManager sharedInstance] downLoadingStorys] removeAllObjects];
    [[[BTDownLoadManager sharedInstance] localStorys] removeAllObjects];
    
}

- (void)startInitDataUnderSplash{
    //RQD
    if (RQD_SWITCH) {
		[AnalyticsInterface enableAnalytics:@"UIN" gatewayIP:nil];
		[AnalyticsInterface enableEventRecord:YES];
		[AnalyticsInterface enableSpeedTrack:YES];
	}
	
	if(CRASH_REPORT_SWITCH){
		[AnalyticsInterface	enableCrashReport:YES];
		[[CrashReporter sharedInstance] install:[BTUtilityClass cfUUIDfromKeyChain] uploadAtomatic:YES];
	}
    
    //向微信注册
	[WXApi registerApp:@"wx16b177292454fffc"];
	// 初始化连接人人API密钥
	[RMConnectCenter
	 initializeConnectWithAPIKey:@"9832da0b775e478bb2795b847be129de"
	 secretKey:@"72b3b16261be41a3b6ce6cd3ed4672b1"
	 appId:@"2080207"
	 mobileDelegate:self];
    
    
	//设置推送
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|
	 UIRemoteNotificationTypeBadge|
	 UIRemoteNotificationTypeSound];
    
    
    //初始化一些数据，创建一些程序必备的文件和升级处理
    [self initData];
    
    
    //初始化程序的基本UI
    [self initUIControllers];
    
    //第一次启动的时候发一个checkin的请求，然后在后台到前台的时候就不用发了。为了是版本升级清除banner的问题。
    [self sendCheckinRequest];
    //sleep(10);
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{	
	isFromBackground = NO;
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
//    [self.window makeKeyAndVisible];
	
	self.zwindow = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
	self.zwindow.rootViewController = [[[ZZRootViewController alloc] initWithNibName:@"ZZRootViewController" bundle:nil] autorelease];
	[self.zwindow makeKeyAndVisible];
    
    [self showSplash];
    
	self.lastDisplaySplashDate = [[NSDate date] stringValue];
    self.startAppDate = [NSDate date];
    
    //设定初始时间为启动时间
    NSDate  *date = [NSDate date];
    double nowTime = [date timeIntervalSince1970];
    _dataStartTime = nowTime;
    
    
	//锁屏显示插图需要
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
	NSString *token = [[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""]
                       stringByReplacingOccurrencesOfString:@">" withString:@""];
	[self pushTokenUpload:token];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    isFromBackground=YES;
	[BTFeedbackSingletonAction destorySharedInstance];
	[BTBannerRefresher destroySharedInstance];
	CDLog(BTDFLAG_NEW_FEEDBACK,@"11111");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    //记录离开时间
    //	[BTUserDefaults saveNowDateToUserDefaultsForKey:LAST_APP_DID_ENTER_BG_TIME];
	[BTFeedbackSingletonAction destorySharedInstance];
	[BTBannerRefresher destroySharedInstance];
	CDLog(BTDFLAG_NEW_FEEDBACK,@"22222");
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */

    
    //日期变更，认为是重新启动应用
	BOOL bDateChanged = ![BTUtilityClass isNowDateEqualsToDateString:lastDisplaySplashDate];
	if (bDateChanged) {
		[self displaySplash];
        //[self showSplash];
        
		self.lastDisplaySplashDate = [[NSDate date] stringValue];
	}
    
    
    //判断数据是否应该被清空。根据时间判断
    NSDate  *date = [NSDate date];
    double nowTime = [date timeIntervalSince1970];
    double loseTime = [[BTUserDefaults valueForKey:CONFIGURATION_CLEAR_DATA_MANAGER] doubleValue];
    if(nowTime - _dataStartTime >= loseTime){
        [BTDataManager destroyInstance];
        _dataStartTime = nowTime;
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    //解决4.3.3版本人人分享界面退出后界面上移的问题
    if ([[[UIDevice currentDevice] systemVersion] isEqualToString:@"4.3.3"] && isRenrenShareShowing) {
        UINavigationController *nav = (UINavigationController *)self.tabCtr.selectedViewController;
        UIViewController *visibleController = nav.topViewController;
        
        if ([visibleController isKindOfClass:[BTStoryPlayerController class]]) {
            _navView.frame = CGRectMake(0, -10, 320, 59);
            _tabCtr.customTabBarView.frame = CGRectMake(0,WINDOW_HEIGHT - 66, 320, 45);
        }
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
    
    //设置更新数量为0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
	
    //checkin
    if(isFromBackground){
        [self sendCheckinRequest];
        isFromBackground=NO;
    }
	//统计上报
	[self sendStatisticsReport];
	//cid=302，配置请求
	[self configurationRequest];
	
	//发送意见反馈
	[self sendFeedbackReport];
	
	//砸蛋重置
	[self resetGiftEggsCount];
	
	
    
    //记录程序启动时间点
    //    BOOL checkSpalsh = [[BTUserDefaults valueForKey:@"hasShownSplash"] boolValue];
    //	if (!checkSpalsh) {
    //	if (bDateChanged) {
    //
    //	}
    //	}
    
    //316协议
    if (sourceUpdateAction != nil) {
        sourceUpdateAction.actionDelegate = nil;
        [sourceUpdateAction cancel];
        [sourceUpdateAction release];
        sourceUpdateAction = nil;
    }
    sourceUpdateAction = [[BTSourceUpdateAction alloc] init];
    [sourceUpdateAction start];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
	[BTFeedbackSingletonAction destorySharedInstance];
	[BTBannerRefresher destroySharedInstance];
	CDLog(BTDFLAG_NEW_FEEDBACK,@"33333");
}

-(void)initUIControllers{
    
    
    
    //不动的UI   例如背景和上层的nav
    
    
    UIImageView *bgImageView = [BTUtilityClass createImageView:@"background.png"
                                                     withFrame:CGRectMake(0, 0, self.window.bounds.size.width, self.window.bounds.size.height)];
    [self.window addSubview:bgImageView];
    
    UIImageView *cloudImageView = [BTUtilityClass createImageView:@"background_cloud.png"
                                                        withFrame:CGRectMake(0, 0, self.window.bounds.size.width, self.window.bounds.size.height)];
    [self.window addSubview:cloudImageView];
    
    
    UIImageView *topBehindImageView = [BTUtilityClass createImageView:@"top_leaf_behind.png"
                                                            withFrame:CGRectMake(0, 0, self.window.bounds.size.width, 81)];
    [self.window addSubview:topBehindImageView];
    
    
    
    
    BTHomePageController * tabCtr = [[BTHomePageController alloc] init];
    tabCtr.title = @"首页";
    UINavigationController* navTabCtr = [[UINavigationController alloc] initWithRootViewController:tabCtr];
    //    navTabCtr.navigationBarHidden = YES;
    navTabCtr.navigationBarHidden = YES;
    [tabCtr release];
    
    BTCategoriesController * tabCtr1 = [[BTCategoriesController alloc] init];
    tabCtr1.title = @"故事分类";
    UINavigationController* navTabCtr1 = [[UINavigationController alloc] initWithRootViewController:tabCtr1];
    navTabCtr1.navigationBarHidden = YES;
    [tabCtr1 release];
    
    
    BTMystoriesController * tabCtr2 = [[BTMystoriesController alloc] init];
    tabCtr2.title = @"本地故事";
    UINavigationController* navTabCtr2 = [[UINavigationController alloc] initWithRootViewController:tabCtr2];
    navTabCtr2.navigationBarHidden = YES;
    [tabCtr2 release];
    
    
    BTMoreController * tabCtr3 = [[BTMoreController alloc] init];
    tabCtr3.title = @"软件信息";
    UINavigationController* navTabCtr3 = [[UINavigationController alloc] initWithRootViewController:tabCtr3];
    navTabCtr3.navigationBarHidden = YES;
    [tabCtr3 release];
    
    
    //
    //
    //    UIImageView *topBeforeImageView = [BTUtilityClass createImageView:@"top_leaf_before.png"
    //                                                            withFrame:CGRectMake(0, 0, self.window.bounds.size.width, 59)];
    //
    //    UIImageView *topBeforeImageView1 = [BTUtilityClass createImageView:@"top_leaf_before.png"
    //                                                             withFrame:CGRectMake(0, 0, self.window.bounds.size.width, 59)];
    //    UIImageView *topBeforeImageView2= [BTUtilityClass createImageView:@"top_leaf_before.png"
    //                                                            withFrame:CGRectMake(0, 0, self.window.bounds.size.width, 59)];
    //    UIImageView *topBeforeImageView3 = [BTUtilityClass createImageView:@"top_leaf_before.png"
    //                                                             withFrame:CGRectMake(0, 0, self.window.bounds.size.width, 59)];
    //
    //    topBeforeImageView.userInteractionEnabled = YES;
    //	topBeforeImageView1.userInteractionEnabled = YES;
    //	topBeforeImageView2.userInteractionEnabled = YES;
    //	topBeforeImageView3.userInteractionEnabled = YES;
    //
    //    [navTabCtr.view addSubview:topBeforeImageView];
    //    [navTabCtr1.view addSubview:topBeforeImageView1];
    //    [navTabCtr2.view addSubview:topBeforeImageView2];
    //    [navTabCtr3.view addSubview:topBeforeImageView3];
    
    
    //    [topBeforeImageView release];
    //    [topBeforeImageView1 release];
    //    [topBeforeImageView2 release];
    //    [topBeforeImageView3 release];
    
    
    NSArray * array = [NSArray arrayWithObjects:navTabCtr,navTabCtr1,navTabCtr2,navTabCtr3,nil];
    BTCustomTabBarController * ctr = [[BTCustomTabBarController alloc] init];
    self.tabCtr = ctr;
    [ctr release];
    
    _navView = [[BTNavView alloc] init];
    _navView.tag = navViewTag;
    [self.tabCtr.view addSubview:_navView];
    
    [_tabCtr setViewControllers:array animated:NO];
    _tabCtr.view.frame = CGRectMake(0, 0, 320, WINDOW_HEIGHT);
    _tabCtr.view.backgroundColor = [UIColor clearColor];
    _tabCtr.delegate = self;
    CDLog(BTDFLAG_ADD_STATUS_BAR,@"%@",NSStringFromCGRect([UIApplication sharedApplication].statusBarFrame));
    CDLog(BTDFLAG_ADD_STATUS_BAR,@"%@,%.0f",NSStringFromCGRect(_tabCtr.view.frame),WINDOW_HEIGHT);
    if ([_window respondsToSelector:@selector(setRootViewController:)]) {
		CDLog(BTDFLAG_SetRootViewcontroller,@"1");
        _window.rootViewController = _tabCtr;
    } else {
		CDLog(BTDFLAG_SetRootViewcontroller,@"2");
        [self.window addSubview:self.tabCtr.view];
    }
    
    
    [self tabBarController:_tabCtr didSelectViewController:[array objectAtIndex:0]];
    
    
    
    [navTabCtr release];
    [navTabCtr1 release];
    [navTabCtr2 release];
    [navTabCtr3 release];
    
    
    
    //将这些UI元素放到闪屏的下面
    
    UIView *splash = [self.window viewWithTag:Splash_Loading_Tag];
    [self.window bringSubviewToFront:splash];
    
}

- (void)sendFeedbackReport {
	CILog(BTDFLAG_NEW_FEEDBACK,@"发送意见反馈");
	BTFeedbackSingletonAction *fbAction = [BTFeedbackSingletonAction sharedInstance];
	fbAction.delegate = self;
	[fbAction reportAllRecords];
}

-(void)sendCheckinRequest{
    if(checkinAction != nil){
        [self releaseAction:checkinAction];
    }
    checkinAction = [[BTCheckinAction alloc] init];
    checkinAction.actionDelegate = self;
    [checkinAction start];
}

- (void) hideTabBar:(BOOL) hidden{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0];
    
    for(UIView *view in self.tabCtr.view.subviews)
    {
        CDLog(BTDFLAG_RENREN_SHARE,@"view = %@",view);
        
        if(view.tag == navViewTag){
            continue;
        }
        if([view isKindOfClass:[UITabBar class]])
        {
            if (hidden) {
                [view setFrame:CGRectMake(view.frame.origin.x, WINDOW_HEIGHT , view.frame.size.width, view.frame.size.height)];
            } else {
                [view setFrame:CGRectMake(view.frame.origin.x, WINDOW_HEIGHT-49 , view.frame.size.width, view.frame.size.height)];
            }
        }
        else
        {
            if (hidden) {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, WINDOW_HEIGHT)];
            } else {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, WINDOW_HEIGHT - 49)];
            }
        }
        
        CDLog(BTDFLAG_RENREN_SHARE,@"frame = %@",NSStringFromCGRect(view.frame));
    }
    
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark UITabBarController Delegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    //    BTTabBarController *tbController = (id)tabBarController;
    //    [tbController resetAllTabs];
    //
    //    NSArray *array = [tabBarController viewControllers];
    //    NSInteger index = [array indexOfObject:viewController];
    //    [tbController highlightTabAtIndex:index];
}
-(void)initData {
    id check = [BTUserDefaults valueForKey:CREATESTAMP];
    if (check == nil) {
        NSDate *date = [NSDate date];
        double time = [date timeIntervalSince1970];
        int value = (int)time;
        [BTUserDefaults setInteger:value forKey:CREATESTAMP];
    }
    id checkLastUpdate = [BTUserDefaults valueForKey:UPDATE_STAMP];
    if (checkLastUpdate == nil) {
        NSDate *date = [NSDate date];
        double time = [date timeIntervalSince1970];
        int value = (int)time;
        [BTUserDefaults setInteger:value forKey:UPDATE_STAMP];
    }
    id updateInterval = [BTUserDefaults valueForKey:CONFIGURATION_RESOURCE_UPDATE];
    if (updateInterval == nil) {
        [BTUserDefaults setInteger:0 forKey:CONFIGURATION_RESOURCE_UPDATE];
    }
    //生成“不备份”文件夹babyStory
    NSString *babyStory = [BTUtilityClass getBabyStoryFolderPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:babyStory])
    {
        [fileManager createDirectoryAtPath:babyStory withIntermediateDirectories:YES attributes:nil error:nil];
        [BTUtilityClass addSkipBackupAttributeToItemAtURL:[NSURL URLWithString:babyStory]];
    }
    
    //生成缓存文件夹
    NSString *cacheFolder = [BTUtilityClass getStoryCacheFolderPath];
    if(![fileManager fileExistsAtPath:cacheFolder])
    {
        [fileManager createDirectoryAtPath:cacheFolder withIntermediateDirectories:YES attributes:nil error:nil];
        [BTUtilityClass addSkipBackupAttributeToItemAtURL:[NSURL URLWithString:cacheFolder]];
    }
    
    //创建本地故事plist文件
    NSString *localPlistToPath =[BTUtilityClass fileWithPath:LOCALSTORY_PLIST_NAME_NEW];
    if (![[NSFileManager defaultManager] fileExistsAtPath:localPlistToPath]) {
        NSMutableArray *stories = [NSMutableArray array];
        [stories writeToFile:localPlistToPath atomically:YES];
    }
    NSString *filePath = [BTUtilityClass fileWithPath:NEWFLAG_PLIST_NAME];
    //如果不存在就创建
    if (![[NSFileManager defaultManager] fileExistsAtPath: filePath]) {
        NSMutableArray *dic = [NSMutableArray array];
        
        [BTUtilityClass writeDataToPlistFile:dic withFileName:@"hasReadStory"];
    }
    
    
    
    //故事书new标记
    NSString *filePathBook = [BTUtilityClass fileWithPath:BOOK_FILE_NAME];
    if(![[NSFileManager defaultManager] fileExistsAtPath:filePathBook]){
        NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
        [resultDic writeToFile:filePathBook atomically:YES];
        [resultDic release];
    }
    
    //版本兼容
    [self versionCompatible];
	
    //断点下载
    [[BTDownLoadManager sharedInstance] breakPointDownLoad];
    
    
    
}

//版本兼容
-(void)versionCompatible{
    
    //版本更新这个位置，如果加代码，需要考虑用户跨版本升级的情况，所以基本上不要写
    //if(currentInternalVersion == ####)类似的语句，应该做版本号的大小比对 应该写 > 或者 <
    //add By Neo
    
    
    NSString *currentVersion = [BTUtilityClass getBundleVersion];
    
    int currentInternalVersion = [BTUtilityClass getInternalBundleVersion];
    //    int checkCoverInternalVersion = [[BTUserDefaults valueForKey:USERDAUFLT_COVER_INTERNAL_VERSION_NUMBER] integerValue];
    //版本1
    int checkCoverInternalVersion = [BTUserDefaults internalVersion];
    //    //版本2
    //    BTUserDefaults *userDefault = [BTUserDefaults sharedUserDefault];
    //    int a  = userDefault.coverVersion;
    
    if(currentInternalVersion == checkCoverInternalVersion){
        return;
    }
    
    
    //
    //    if ([currentVersion isEqualToString:checkCoverVersion]) {
    //        return;
    //    }
    
    //在3.2版本需要做一个事情：把图片的frame全部确定，此处要做Three20的缓存图片删掉
    //所以此处需要判断，升级之前的版本号。
    //3.2版本不清空Three20缓存了，以后需要删除时  下面代码打开。修改版本号
    //    if(checkCoverInternalVersion <  3200){
    //        NSString *three20Document = THREE20_DIRECTORY;
    //        NSArray *three20files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:three20Document error:nil];
    //        for (int i = 0; i < [three20files count]; i++) {
    //            NSString *imagePath = [NSString stringWithFormat:@"%@/%@",three20Document,[three20files objectAtIndex:i]];
    //            [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
    //        }
    //    }
    
    
	
	//删除故事统计上报信息(3.0)
    //3.1版本之前需要删除（包括3.1） 之后版本不需要
    if(checkCoverInternalVersion < 3200){
        NSString *dataPath = [BTUtilityClass fileWithPath:RECORDPLAYCOUNT_PLIST_NAME];
        NSMutableArray *array = [NSMutableArray array];
        [array writeToFile:dataPath atomically:YES];
    }
    
    //删除运营位信息（产品需求，在版本升级的时候删除老版本的运营位）
    //每一个版本都会做这件事情
    NSString *filePathBanner = [BTUtilityClass fileWithPath:BANNER_PLIST_NAME];
    if([[NSFileManager defaultManager] fileExistsAtPath:filePathBanner]){
        NSMutableArray *allBannerInfo = [NSMutableArray arrayWithContentsOfFile:filePathBanner];
        for(NSDictionary *dic in allBannerInfo){
            NSString *bannerURL = [dic objectForKey:POPULARIZ_IMG_URL];
            NSString *tmpPicName = [BTUtilityClass getIdFromURL:bannerURL];
            NSString *picName = [tmpPicName stringByAppendingString:@"_banner"];
            NSString *removeFilePath = [NSString stringWithFormat:@"%@/%@",THREE20_DIRECTORY,picName];
            if([[NSFileManager defaultManager] fileExistsAtPath:removeFilePath]){
                [[NSFileManager defaultManager] removeItemAtPath:removeFilePath error:nil];
            }
        }
        [allBannerInfo removeAllObjects];
        [allBannerInfo writeToFile:filePathBanner atomically:YES];
    }
    
#warning 此处3.X版本需要修改  Neo
    //改成新的版本升级判断模式
    NSString *checkCoverVersion = [BTUserDefaults internalVersionNum];
    float currentVersionFloatValue = [checkCoverVersion floatValue];
    if (currentVersionFloatValue < 3.0 ) {
        //删除原有版本的"downLoadList.plist文件
        NSString *downloadPlistPath = [BTUtilityClass fileWithPath:DOWNLOAD_PLIST_NAME];
        if ([[NSFileManager defaultManager] fileExistsAtPath:downloadPlistPath]) {
            [[NSFileManager defaultManager] removeItemAtPath:downloadPlistPath error:nil];
        }
        
        //删除原有图片
        NSString *babyStoryFolderPath = [BTUtilityClass getBabyStoryFolderPath];
        NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:babyStoryFolderPath error:nil];
        NSArray *imageNames = [files pathsMatchingExtensions:[NSArray arrayWithObject:@"png"]] ;
        for (int i = 0; i < [imageNames count]; i++) {
            NSString *imagePath = [BTUtilityClass fileWithPath:[imageNames objectAtIndex:i]];
            [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
        }
        
        //删除本地的5个自带故事
        NSArray *localStorys = [NSArray arrayWithObjects:@"狼来了.mp3",@"猴子捞月亮.mp3",@"白雪公主.mp3",@"阿文的小毯子.mp3",@"青蛙小弟睡午觉.mp3",nil];
        for (int i = 0; i<[localStorys count]; i++) {
            NSString *filePath = [babyStoryFolderPath stringByAppendingPathComponent:[localStorys objectAtIndex:i]];
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
        
        //创建新的plist
        NSString *localPlistPath = [BTUtilityClass fileWithPath:LOCALSTORY_PLIST_NAME];
        if ([[NSFileManager defaultManager] fileExistsAtPath:localPlistPath]) {
            NSMutableArray *newPlist = [NSMutableArray arrayWithCapacity:5];
            NSMutableArray *plists = [NSMutableArray arrayWithContentsOfFile:localPlistPath];
            for (NSMutableDictionary *dic in plists) {
                NSString *protocal = [dic objectForKey:KEY_PROTOCAL_VERSION];
                if([protocal isEqualToString:@"2.0"]){
                    NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithCapacity:12];
                    [newDic setValue:[dic objectForKey:KEY_LOCAL_STORTID] forKey:KEY_STORY_ID];
                    [newDic setValue:[dic objectForKey:KEY_LOCAL_STORYNAME] forKey:KEY_STORY_NAME];
                    [newDic setValue:[dic objectForKey:KEY_LOCAL_STORYLEN] forKey:KEY_STORY_LENGTH];
                    [newDic setValue:[dic objectForKey:KEY_LOCAL_STORYANC] forKey:KEY_STORY_ANNOUNCER];
                    [newDic setValue:[dic objectForKey:KEY_LOCAL_STORYDES] forKey:KEY_STORY_DESCRIPTION];
                    [newDic setValue:[dic objectForKey:KEY_LOCAL_STORYDOMAIN] forKey:KEY_STORY_DOMAIN];
                    [newDic setValue:[dic objectForKey:KEY_LOCAL_STORYURL] forKey:KEY_STORY_AUDIO_URL_LOW];
                    [newDic setValue:[dic objectForKey:KEY_LOCAL_STORYURL_HIGH] forKey:KEY_STORY_AUDIO_URL_HIGH];
                    [newDic setValue:[dic objectForKey:KEY_LOCAL_STORYPIC_INLOCAL] forKey:KEY_STORY_PIC_SMALL];
                    [newDic setValue:[dic objectForKey:KEY_LOCAL_STORYPIC_INPLAYVIEW] forKey:KEY_STORY_PIC_BIG];
                    [newDic setValue:nil forKey:KEY_STORY_CATEGORY_NAME];
                    [newDic setValue:[BTUtilityClass getBundleVersion] forKey:KEY_PRODUCT_VERSION];
                    [newPlist addObject:newDic];
                }
            }
            
            NSString *localPlistPathNew = [BTUtilityClass fileWithPath:LOCALSTORY_PLIST_NAME_NEW];
            [newPlist writeToFile:localPlistPathNew atomically:YES];
            
            [[NSFileManager defaultManager] removeItemAtPath:localPlistPath error:nil];
        }
    }
    
    //排序字段的初始化
    if(checkCoverInternalVersion < 3400){
        [self setSortFieldValue];
    }
   /**
    *3.5版本之前本地故事的iocn和插图都放到Three20的文件夹下，在清除缓存文件之前，需要把他们复制到document／babyStory文件夹下，
    *从3.5版本开始，本地故事的iocn和插图都会下载到document／babyStory文件夹下，清除缓存时不会受影响。
    */
    if(checkCoverInternalVersion < 3500){
        [self copyLocalStoryImageFromCacheToDocumentFolder];
        
        //3.5版本之前本地故事的命名是以“故事名字.mp3”命名的，由于后台增多，会出现同名的故事，但播音员不同，这会出现同名音频覆盖存储的问题
        [self renameLocalStory];
    }
    
    //每个版本升级都会做这个事情。。。song说的。上面是清除缓存，下面是清空节省的流量数字
    [self versionUpdateRemoveCacheFolder];
    [self updateSaveFlowNum];

    
    
    
    
    //[BTUserDefaults setInteger:currentInternalVersion forKey:USERDAUFLT_COVER_INTERNAL_VERSION_NUMBER];
    //版本1
    [BTUserDefaults setInternalVersion:currentInternalVersion];
    //版本2
    //    BTUserDefaults *defaultUserDef = [BTUserDefaults sharedUserDefault];
    //    defaultUserDef.CoverVersion = currentInternalVersion;
    
    //[BTUserDefaults setValue:currentVersion forKey:USERDAUFLT_COVER_VERSION_NUMBER];
    [BTUserDefaults setInternalVersionNum:currentVersion];
}

- (void)versionUpdateRemoveCacheFolder{
    //缓存故事       清空了cache这个文件夹。有重试3次的操作。Neo
    for (int i = 0 ; i < 3; i++) {
        BOOL flag = [self removeCacheFolder];
        if(flag){
            break;
        }
    }
    //生成缓存文件夹
    NSString *cacheFolder = [BTUtilityClass getStoryCacheFolderPath];
    if(![[NSFileManager defaultManager] fileExistsAtPath:cacheFolder])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:cacheFolder withIntermediateDirectories:YES attributes:nil error:nil];
        [BTUtilityClass addSkipBackupAttributeToItemAtURL:[NSURL URLWithString:cacheFolder]];
    }
}

//清空节省的流量数字
- (void)updateSaveFlowNum{
    [BTUserDefaults removeSaveFlow];
    int yearAndMonth = [BTUtilityClass getCurrentYearAndMonth];
    double saveFlowNum = 0.0f;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:yearAndMonth],KEY_SAVEFLOW_DATE,[NSNumber numberWithDouble:saveFlowNum],KEY_SAVEFLOW_NUM, nil];
    [BTUserDefaults setSaveFlowAndDate:dic];
}

- (BOOL)removeCacheFolder{
     NSString *cacheFolder = [BTUtilityClass getStoryCacheFolderPath];
    BOOL flag = NO;
    if([[NSFileManager defaultManager] fileExistsAtPath:cacheFolder]){//Returns a Boolean value that indicates whether a file or directory exists at a specified path.
        flag = [[NSFileManager defaultManager] removeItemAtPath:cacheFolder error:nil];
    }else{
        flag = YES;
    }
    return flag;
    
}

//将Three20缓存文件夹下本地故事的iocn和插图复制到document／babyStory文件夹下
- (void)copyLocalStoryImageFromCacheToDocumentFolder{
    
    NSArray *picFileNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:THREE20_DIRECTORY error:nil];
    NSMutableArray *localStorys = [NSMutableArray arrayWithContentsOfFile:[BTUtilityClass fileWithPath:LOCALSTORY_PLIST_NAME_NEW]];
    
    for (NSMutableDictionary *dic in localStorys) {
        NSString * sid = [dic objectForKey:KEY_STORY_ID];
        for (NSString * fileName in picFileNames) {
            NSString *iconName = [NSString stringWithFormat:@"%@_storyIcon",sid];
            NSString *playViewName = [NSString stringWithFormat:@"%@_storyPlayView",sid];
            
            if ([fileName isEqualToString:iconName] ||
                [fileName isEqualToString:playViewName]) {
                NSString *filePath = [THREE20_DIRECTORY stringByAppendingPathComponent:fileName];
                if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                    NSString *dstPath = [[BTUtilityClass getBabyStoryFolderPath] stringByAppendingPathComponent:fileName];
                    [[NSFileManager defaultManager] copyItemAtPath:filePath
                                                            toPath:dstPath
                                                             error:nil];
                }
            }
        }
    }
}

//将本地故事从“故事名字.mp3”改为“故事id.mp3”
- (void)renameLocalStory{
    NSMutableArray *localStorys = [NSMutableArray arrayWithContentsOfFile:[BTUtilityClass fileWithPath:LOCALSTORY_PLIST_NAME_NEW]];
    for (NSMutableDictionary *dic in localStorys) {
        NSString *sid = [dic objectForKey:KEY_STORY_ID];
        NSString *sna = [dic objectForKey:KEY_STORY_NAME];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *srcPath = [BTUtilityClass fileWithPath:[NSString stringWithFormat:@"%@.mp3",sna]];
        NSString *dstPath = [BTUtilityClass fileWithPath:[NSString stringWithFormat:@"%@.mp3",sid]];
        if ([fileManager fileExistsAtPath:srcPath]) {
            [fileManager moveItemAtPath:srcPath toPath:dstPath error:nil];
        }
    }
}
//给所有本地故事添加更新字段
-(void)setSortFieldValue{
    NSString *localPlistPath = [BTUtilityClass fileWithPath:LOCALSTORY_PLIST_NAME_NEW];
    NSMutableArray *localStories = [NSMutableArray arrayWithContentsOfFile:localPlistPath];
    int stamp = 0;//[[NSDate date] timeIntervalSince1970];
    for (int i = 0; i < [localStories count]; i ++) {
        NSMutableDictionary *dic = [localStories objectAtIndex:i];
        [dic setValue:[NSNumber numberWithBool:NO] forKey:KEY_STORY_INFO_IS_UPDATED];
        [dic setValue:[NSNumber numberWithInt:stamp + i] forKey:KEY_STORY_DOWNLOAD_STAMP];
    }
    [localStories writeToFile:localPlistPath atomically:YES];
}

//保存活动信息（运营&&砸蛋活动）
- (void)savePopularizesInfoToLocal:(NSArray *)popularizes {
	CDLog(BTDFLAG_BANNER,@"popularizes:%@",popularizes);
	NSMutableArray *allPops = [NSMutableArray array];
	
	NSString *giftPath = [BTUtilityClass fileWithPath:GIFT_EGGS_PLIST_NAME];
	NSMutableDictionary *oldGift = [NSMutableDictionary dictionaryWithContentsOfFile:giftPath];
	NSMutableDictionary *gift = nil;
	
	for (NSDictionary *onePop in popularizes) {
		int type = [[onePop valueForKey:POPULARIZ_TYPE] intValue];
		if (type == 2) {
			[allPops addObject:onePop];
		} else if (type == 3 && !gift) {
			gift = [NSMutableDictionary dictionaryWithDictionary:onePop];
			NSString *identifier = [BTUtilityClass cfUUIDfromKeyChain];
			NSString *appName = APP_NAME;
			
			NSString *runUrl = [gift valueForKey:GIFT_EGGS_RUN_URL];
			NSString *runUrlNew = [NSString stringWithFormat:@"%@?app_name=%@&identifier=%@",runUrl,appName,identifier];
			[gift setValue:runUrlNew forKey:GIFT_EGGS_RUN_URL];
			
			NSString *requestUrl = [gift valueForKey:GIFT_EGGS_REQUEST_OPPORTUNITY_URl];
			NSString *requestUrlNew = [NSString stringWithFormat:@"%@?app_name=%@&identifier=%@",requestUrl,appName,identifier];
			[gift setValue:requestUrlNew forKey:GIFT_EGGS_REQUEST_OPPORTUNITY_URl];
			[allPops addObject:gift];
			
			int oldId = [[oldGift valueForKey:GIFT_EGGS_ID] intValue];
			int newId = [[gift valueForKey:GIFT_EGGS_ID] intValue];
			if (newId != oldId) {
				NSNumber *missionDoneCount = [oldGift valueForKey:GIFT_EGGS_MISSION_DONE];
				[gift setValue:missionDoneCount forKey:GIFT_EGGS_MISSION_DONE];
				NSNumber *playedCount = [oldGift valueForKey:GIFT_EGGS_PLAYED_COUNT];
				[gift setValue:playedCount forKey:GIFT_EGGS_PLAYED_COUNT];
			}
		}
	}
	
	NSString *popPath = [BTUtilityClass fileWithPath:BANNER_PLIST_NAME];
	[allPops writeToFile:popPath atomically:YES];
	
	//DLog(@"gift3 = %@",gift);
    //	NSString *giftPath = [BTUtilityClass fileAbsolutePathWithBabyStory:GIFT_EGGS_PLIST_NAME];
	[gift writeToFile:giftPath atomically:YES];
	
	//告诉BannerView刷新
	NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
	[userInfo setValue:allPops forKey:@"allBanners"];
	[[NSNotificationCenter defaultCenter]
	 postNotificationName:BANNER_REQUEST_FINISH_NOTIFICATION
	 object:self userInfo:userInfo];
}

#pragma mark - Checkin
- (void)onAction:(BTBaseAction *)action withData:(id)data {
	if (action == checkinAction) {
        //更新信息
		int updateType = [BTCheckinManager shareInstance].updateType;
        
		if (updateType != 0) {
			[BTUtilityClass setTabBarBadgeText:@"新版本"];
		}
        //保存活动信息（运营&&砸蛋活动)
        [self savePopularizesInfoToLocal:[BTCheckinManager shareInstance].popularizes];
        
        //闪屏信息
        if (_splashAction != nil) {
            [self cleanSplashAction];
        }
        _splashAction = [[BTSplashAction alloc]init];
        _splashAction.actionDelegate = self;
        [_splashAction downloadSplash];
        
        //微博活动信息
        //3.0版本没有该活动
        
        //父母必备软件html压缩包请求
        int localStamp = [BTUserDefaults necessarySoftUpdateStamp];
        int chechStamp = [[[BTCheckinManager shareInstance].necessarySoftData objectForKey:CHECKIN_RESPONSE_NECESSARY_SOFT_CREATE_TIME] intValue];
        
        if (chechStamp > localStamp) {
            softAction = [[BTNecessarySoftAction alloc] initWithSoftData:[BTCheckinManager shareInstance].necessarySoftData];
            softAction.actionDelegate = self;
            [softAction start];
        }
	}
	
	[self releaseAction:action];
}


- (void)cleanSplashAction {
    if (_splashAction != nil) {
        _splashAction.actionDelegate = nil;
        [_splashAction cancel];
        [_splashAction release];
        _splashAction = nil;
    }
}


- (void) didFinishGetSplashAction:(NSDictionary*)dic;{
    [self cleanSplashAction];
}
- (void) didGetSplashError:(NSDictionary*)dic{
    [self cleanSplashAction];
}

- (void)onAction:(BTBaseAction *)action withError:(NSError *)error {
	[self releaseAction:action];
}

- (void)releaseAction:(BTBaseAction*)action {
	if (action == checkinAction) {
        checkinAction.actionDelegate = nil;
        [checkinAction cancel];
        [checkinAction release];
        checkinAction = nil;
	} else if (action == self.playedCountAction) {
        playedCountAction.actionDelegate = nil;
        [playedCountAction cancel];
        [playedCountAction release];
        playedCountAction = nil;
	} else if (action == self.localCountAction) {
        localCountAction.actionDelegate = nil;
        [localCountAction cancel];
        [localCountAction release];
		localCountAction = nil;
	} else if (action == self.storyDownedAction) {
        storyDownedAction.actionDelegate = nil;
        [storyDownedAction cancel];
        [storyDownedAction release];
		storyDownedAction = nil;
	} else if (action == self.tokenReportAction) {
        tokenReportAction.actionDelegate = nil;
        [tokenReportAction cancel];
        [tokenReportAction release];
		tokenReportAction = nil;
	} else if (action == self.configurationRequestAction) {
        configurationRequestAction.actionDelegate = nil;
        [configurationRequestAction cancel];
        [configurationRequestAction release];
		configurationRequestAction = nil;
	} else if (action == self.bannerReportAction) {
        _bannerReportAction.actionDelegate = nil;
        [_bannerReportAction cancel];
        [_bannerReportAction release];
		_bannerReportAction = nil;
	}
    

}

- (void)cancelAction:(BTBaseAction *)action {
	if (action) {
//		[action cancel];
		[self releaseAction:action];
	}
}

#pragma mark - 统计上报
- (void)startAction:(BTBaseAction *)action {
	[action start];
}

- (void)pushTokenUpload:(NSString *)token {
	
	if (self.tokenReportAction) {
		[self cancelAction:self.tokenReportAction];
	}
	tokenReportAction = [[BTTokenReportAction alloc] initWithToken:token];
	tokenReportAction.actionDelegate = self;
	[self startAction:self.tokenReportAction];
    //	[self performSelector:@selector(startAction:) withObject:self.tokenReportAction afterDelay:0.f];
}

- (void)configurationRequest {
	if (self.configurationRequestAction) {
		[self cancelAction:self.configurationRequestAction];
	}
	configurationRequestAction = [[BTConfigurationRequestAction alloc] init];
	configurationRequestAction.actionDelegate = self;
	[self startAction:self.configurationRequestAction];
    //	[self performSelector:@selector(startAction:) withObject:self.configurationRequestAction afterDelay:0.f];
}

- (void)sendStatisticsReport {
	//banner点击上报
	if (self.bannerReportAction) {
		[self cancelAction:self.bannerReportAction];
	}
	_bannerReportAction = [[BTBannerStatisticsReportAction alloc] init];
	_bannerReportAction.actionDelegate = self;
	[self startAction:self.bannerReportAction];
	
	if (self.playedCountAction) {
		[self cancelAction:self.playedCountAction];
	}
	playedCountAction = [[BTPlayedCountStatisticAction alloc] init];
	playedCountAction.actionDelegate = self;
	[self startAction:self.playedCountAction];
    //	[self performSelector:@selector(startAction:) withObject:self.playedCountAction afterDelay:0.f];
	
	if (self.localCountAction) {
		[self cancelAction:self.localCountAction];
	}
	localCountAction = [[BTLocalStoriesCountAction alloc] init];
	localCountAction.actionDelegate = self;
	[self startAction:self.localCountAction];
    //	[self performSelector:@selector(startAction:) withObject:self.localCountAction afterDelay:0.f];
	
	if (self.storyDownedAction) {
		[self cancelAction:self.storyDownedAction];
	}
	storyDownedAction = [[BTStoryDownloadedCountAction alloc] init];
	storyDownedAction.actionDelegate = self;
	[self startAction:self.storyDownedAction];
    //	[self performSelector:@selector(startAction:) withObject:self.storyDownedAction afterDelay:0.f];
}


//远程操控的截获
#pragma mark remote events
-(void)remoteControlReceivedWithEvent:(UIEvent *)event{
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_REMOTE_CONTROL_CHANGED object:event];
}

#pragma mark - RenrenMobileDelegate
//-----------------------------------------------------------
// dashboard 将呈现在屏幕上
//-----------------------------------------------------------
- (void)dashboardWillAppear{
    //可暂停你的游戏界面
}
- (void)dashboardDidAppear{
    
}
- (void)dashboardWillDisappear{
    //可恢复你的游戏界面
}
- (void)dashboardDidDisappear{
    //可执行你想要的操作
}

- (void)reAuthVerifyUserFailWithError:(RMError *)error{
    if (error) {
        //为了更好的用户体验，当发生此种错误时用户可能无法正常使用人人网的服务，请要求用户重新登录。
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"人人网用户登录已失效"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

#pragma mark 微信&&人人
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
	if ([url.absoluteString hasPrefix:@"rm2080207com.21kunpeng.babylisten201111"]) {//人人
		return [[RMConnectCenter sharedCenter] handleOpenURL:url];
	} else {//其他保持原有
		return [WXApi handleOpenURL:url delegate:self];
	}
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
	//	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"外部调用本程序"
	//														message:[NSString stringWithFormat:@"url.absoluteString = %@, sourceApplication = %@, annotation = %@",url.absoluteString,sourceApplication,annotation]
	//													   delegate:self
	//											  cancelButtonTitle:@"我知道了"
	//											  otherButtonTitles:nil];
	//	[alertView show];
	//	[alertView release];
	//	if ([url.absoluteString hasPrefix:@"wx16b177292454fffc"]) {//微信
	//		return [WXApi handleOpenURL:url delegate:self];
	//	} else
	if ([url.absoluteString hasPrefix:@"rm2080207com.21kunpeng.babylisten201111"]) {//人人
		return [[RMConnectCenter sharedCenter] handleOpenURL:url];
	} else {//其他保持原有
		return [WXApi handleOpenURL:url delegate:self];
	}
}

-(void) onResp:(BaseResp*)resp
{
	//DLog(@"-(void) onResp:(BaseResp*)resp");
	
}

-(void) onReq:(BaseReq*)req
{
	//DLog(@"-(void) onReq:(BaseReq*)req");
}


- (void) sendAppContent:(WXMediaMessage *)message isMulti:(BOOL)isMulti
{
	
    // 发送内容给微信
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = isMulti?WXSceneTimeline:WXSceneSession;
    
    [WXApi sendReq:req];
}

-(void) RespAppContent
{
	
}

#pragma mark - 砸蛋重置
- (void)resetGiftEggsCount {
	[BTGiftEggsAction resetRetryCancelFlag];//重置砸蛋“重试/取消”标识
    
	BOOL bDateChanged = ![BTUtilityClass isNowDateEqualsToDateString:lastDisplaySplashDate];
	if (bDateChanged) {
		NSString *giftPath = [BTUtilityClass fileWithPath:GIFT_EGGS_PLIST_NAME];
		NSMutableDictionary *gift = [NSMutableDictionary dictionaryWithContentsOfFile:giftPath];
		[gift setValue:[NSNumber numberWithInt:0] forKey:GIFT_EGGS_PLAYED_COUNT];
		[gift setValue:[NSNumber numberWithInt:0] forKey:GIFT_EGGS_MISSION_DONE];
		[gift writeToFile:giftPath atomically:YES];
	}
}


#pragma mark - 闪屏显示出来 by Neo
- (void)showSplash{
    BTSplashView *splash = [[BTSplashView alloc] init];
    if(!splash){
        return;
    }
    splash.tag = Splash_Loading_Tag;
    [self.window addSubview:splash];
    
//    2012.11.29 nate Add start 解决内存泄漏
    [splash release];
//    2012.11.29 nate Add end
    
    [self.window bringSubviewToFront:splash];
    _splashAddTime = [[NSDate date] timeIntervalSince1970];
    [UIView animateWithDuration:0.0 animations:^{
        splash.guoduImageView.alpha =1.0f;//过度闪屏出现
    }completion:^(BOOL f){
        //只有默认情况过度闪屏执行淡出；有节日闪屏的时候过度闪屏0.5秒淡出,节日闪屏出现淡出
        if (splash.bIsDefaultSplash) {
            [self startInitDataUnderSplash];
            [self manageSplash];
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
            
        }else{
            splash.imageView.alpha = 1.0;
            [UIView animateWithDuration:0.5 animations:^{
                splash.guoduImageView.alpha = 0.0f;
            }completion:^(BOOL f){
                [self startInitDataUnderSplash];
                [self manageSplash];
                [[UIApplication sharedApplication] setStatusBarHidden:NO];
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
            }];
            
        }
    }];
    
}

//闪屏继续显示，此时数据已经加载完成，需要计算继续显示的时长
//如果加载时间超出预定时间，则移除，否则继续显示到预定时间
- (void)manageSplash{
    double initFinishTime = [[NSDate date] timeIntervalSince1970];
    double intervalTime = initFinishTime - _splashAddTime;
    //产品侧定闪屏默认闪屏是处理数据完成就进入，节日闪屏是3.0s，该变量就是维护这个事情的。
    double totalTime = 0.0f;
    BTSplashView *splash = (BTSplashView *)[self.window viewWithTag:Splash_Loading_Tag];
    if(splash){
        if(splash.bIsDefaultSplash){
            totalTime = splashShowTime;
        }else{
            totalTime = splashHolidayTime;
        }
    }
    double leftTime  =  MAX(totalTime-intervalTime, 0.0);
    [self performSelector:@selector(removeSplash) withObject:nil afterDelay:leftTime];
}

#pragma mark - 移除闪屏重写 by Dora
//移除闪屏
- (void)removeSplash{
    BTSplashView *splash = (BTSplashView *)[self.window viewWithTag:Splash_Loading_Tag];
    if(!splash){
        return;
    }
    float SplashFadeout = (splash.bIsDefaultSplash)?0.3:1.0;
    if (splash.bIsDefaultSplash) {
        [UIView animateWithDuration:SplashFadeout animations:^{
            splash.guoduImageView.alpha= 0.0;
            
        } completion:^(BOOL f){
            [splash removeFromSuperview];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SPLASH_DISPLAY_FINISHED object:nil];
        }];
    }else{
        [UIView animateWithDuration:SplashFadeout animations:^{
            //节日闪屏放大消失
            splash.imageView.alpha= 0.0;
            splash.imageView.frame = CGRectMake(-60, -85, 440, 635);//节日闪屏放大消失
            
        } completion:^(BOOL f){
            [splash removeFromSuperview];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SPLASH_DISPLAY_FINISHED object:nil];
        }];
    }
}

#pragma mark - 闪屏重写 by Zero
- (void)displaySplash {
	BTSplashView *splash = [[BTSplashView alloc] init];
    if (!splash) {
		return;
	}
    splash.tag = Splash_Loading_Tag;
	[_window addSubview:splash];
	[_window bringSubviewToFront:splash];
    float SplashFadeout = (splash.bIsDefaultSplash)?0.3:1.0;
    double totalTime = 0.0f;
    if(splash){
        if(splash.bIsDefaultSplash){
            totalTime = splashShowTime;
        }else{
            totalTime = splashHolidayTime;
        }
    }
	[UIView animateWithDuration:splashFadeIn animations:^{
		//闪屏出现
		splash.imageView.alpha = .99f;
	} completion:^(BOOL f){
        [UIView animateWithDuration:totalTime animations:^{
            splash.imageView.alpha = 1.f;
        }completion:^(BOOL f){
            [UIView animateWithDuration:SplashFadeout animations:^{
                //闪屏消失
                splash.imageView.alpha = 0.f;
                if (!splash.bIsDefaultSplash) {
                    splash.imageView.frame = CGRectMake(-60, -85, 440, 635);//节日闪屏放大消失
                }
            } completion:^(BOOL f){
                [UIView animateWithDuration:splashDisappear animations:^{
                    //黑屏消失
                    splash.alpha = 0.f;
                } completion:^(BOOL f){
                    //销毁闪屏;
                    [splash removeFromSuperview];
					[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SPLASH_DISPLAY_FINISHED object:nil];
                }];
            }];
        }];
	}];
    
}

- (void)jumpToSetUpController{
    // 跳到设置界面
    UIButton *btn = [self.tabCtr.tabBarItems objectAtIndex:3];
    [self.tabCtr tabChanged:btn];
    //创建
    BTCacheCleanController *con = [[BTCacheCleanController alloc] init];
    
    //回到第一级界面
    UINavigationController *nav = (UINavigationController *)self.tabCtr.selectedViewController;
    [nav popToRootViewControllerAnimated:NO];
    
    [nav pushViewController:con animated:YES];
    [con release];
}

#pragma mark - BTFeedbackSingletonActionDelegate
- (void)allRecordsHadBeedSend {
	[BTFeedbackSingletonAction destorySharedInstance];
}
@end
