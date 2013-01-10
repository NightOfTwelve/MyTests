//
//  BTBannerView.m
//
//  Created by Zero on 8/20/12.
//  Copyright (c) 2012 21kunpeng. All rights reserved.
//

#import "BTBannerView.h"
#import "BTDataManager.h"
#import "BTNetImageView.h"
#import "BTBannerClickedStatisticsAction.h"
#import "BTBannerRefresher.h"

static NSInteger	kTagCoverImageView = 7701;
static NSInteger	kTagButtonBegin = 7800;

static CGFloat kCoverViewWidth = 320.0f;
static CGFloat kCoverViewHeight = 118.0f;

static CGFloat kScrollViewHeight = 109.0f;
static CGFloat kScrollViewWidth = 309;

static CGFloat kPageControlHeight = 18.0f;

static CGFloat kPageTotalHeight = 118.0f + 61.0f;
static CGFloat kPageTotalWidth = 320.0f;

static CGFloat kSpaceHeight = 61.0f;

static CGFloat kScrollViewLeftWidth = (320.0f - 309.0f)/2;

static CGFloat kAutoChangePicTimeInterval = 5.0f;	//自动切换间隔

static NSInteger kMaxTimesOfExeStartTimer = 20;		//最多阻止启动刷新器次数

@interface BTBannerView ()
@property (nonatomic, assign)	id<BTOpenURLDelegate>		homeDelegate;			//首页ViewController的Delegate
@property (nonatomic)			BOOL						bPageControlUsed;
@property (nonatomic, retain)	UIPageControl				*pageControl;			//页面控制器
@property (nonatomic, retain)	UIScrollView				*scrollView;
@property (nonatomic, retain)	NSTimer						*timer;					//定时器
@property (nonatomic)			CGSize						winSize;				//mainScreen.bounds.size
@property (nonatomic)			NSUInteger					imageCount;				//图片数量
@property (nonatomic, retain)	NSMutableArray				*allBanners;			//运营栏信息
@property (nonatomic, retain)	BTBaseAction				*action;				//action
@property (nonatomic, assign)	BOOL						bSplashHasFinished;		//闪屏结束标识位
@property (nonatomic, assign)	BOOL						bStartTimerHasExe;		//已经启动了刷新器
@end

@implementation BTBannerView

@synthesize bPageControlUsed;
@synthesize timer;
@synthesize pageControl;
@synthesize scrollView;
@synthesize winSize;
@synthesize imageCount;
@synthesize homeDelegate;
@synthesize allBanners;
@synthesize action;

- (BTBannerRefresher *)refresher {
	return [BTBannerRefresher sharedInstance];
}

//当本地拉取回来时是否可以刷新
- (BOOL)canRefreshOnLocalFinished {
	return [[self refresher] canRefreshOfLocol];
}

//当checkin拉取回来时是否可以刷新
- (BOOL)canRefreshOnCheckinFinished {
	return [[self refresher] canRefreshOfCheckinFinished];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[pageControl release];
	[scrollView release];
	[scrollView release];
	[timer release];
	[allBanners release];
	[action release];
	
	[super dealloc];
}

- (id)initWithDelegate:(id<BTOpenURLDelegate>)delegate {
	if (self = [super init]) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkinFinish:) name:BANNER_REQUEST_FINISH_NOTIFICATION object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(splashHasFinished) name:NOTIFICATION_SPLASH_DISPLAY_FINISHED object:nil];
		self.homeDelegate = delegate;
		self.backgroundColor = [UIColor clearColor];
		self.frame = CGRectMake(0, 0, kPageTotalWidth, kPageTotalHeight);
		//创建底板
		UIImage *boardImage = [UIImage imageNamed:@"banner_board.png"];
		UIImageView *boardImageView = [[UIImageView alloc] initWithImage:boardImage];
		boardImageView.layer.cornerRadius = 6;
		CGFloat y = kSpaceHeight + (kPageTotalHeight-kSpaceHeight-kScrollViewHeight)/2;
		boardImageView.frame = CGRectMake(kScrollViewLeftWidth, y, kScrollViewWidth, kScrollViewHeight);
		
		//创建上面镂空遮罩
		UIImage *coverImage = [UIImage imageNamed:@"banner_cover.png"];
		UIImageView *coverImageView = [[UIImageView alloc] initWithImage:coverImage];
		coverImageView.tag = kTagCoverImageView;
		coverImageView.frame = CGRectMake(0, kSpaceHeight, kCoverViewWidth, kCoverViewHeight);
		
		[self addSubview:boardImageView];
		[boardImageView release];
		[self addSubview:coverImageView];
		[coverImageView release];
		[self.action start];
	}
	return self;
}

- (BTBaseAction *)action {
	if (action == nil) {
        action = [[BTBannerAction alloc] init];
        action.actionDelegate = self;
    }
    return action;
}
		 
#pragma mark - 闪屏显示结束通知
- (void)splashHasFinished {
	CDLog(BTDFLAG_Splash_And_Banner, @"111");
	_bSplashHasFinished = YES;
}

#pragma mark - 某条BannerView的点击事件
-(void)bunnerPressed:(id)sender{
    [self removeFromSuperview];
}

#pragma mark - delegate
// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.bPageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.bPageControlUsed = NO;
}

#pragma mark - 定时器调用函数
- (void)scheduledFunction {
	if (nil == self.pageControl) {
		return;
	}
	int page = (self.pageControl.currentPage+1)%self.pageControl.numberOfPages;
	[self gotoPage:page animated:YES];
}

- (void)startTimer {
	static NSInteger times = 0;
	CDLog(BTDFLAG_Splash_And_Banner,@"222");
	if (_bSplashHasFinished || times++ >= kMaxTimesOfExeStartTimer) {
		CDLog(BTDFLAG_Splash_And_Banner,@"333");
		[self resetTimer];
	} else {
		CDLog(BTDFLAG_Splash_And_Banner,@"444");
		[self performSelector:@selector(startTimer) withObject:nil afterDelay:.5f];
	}
}

- (void)resetTimer {
	if (self.timer) {
		[self.timer invalidate];
	}
	self.timer = [NSTimer scheduledTimerWithTimeInterval:kAutoChangePicTimeInterval target:self selector:@selector(scheduledFunction) userInfo:nil repeats:NO];
}

#pragma mark -
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (self.bPageControlUsed)
    {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = (int)(floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)%(self.pageControl.numberOfPages?self.pageControl.numberOfPages:1);
    self.pageControl.currentPage = page;
    [self resetTimer];
    
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

- (void)gotoPage:(int)page animated:(BOOL)bAnimated{
	// update the scroll view to the appropriate page
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:bAnimated];
	[self resetTimer];
}

- (void)pageControlValueChanged:(id)sender {
	
	int page = self.pageControl.currentPage;
	
	[self gotoPage:page animated:YES];
	
	self.bPageControlUsed = YES;
}

- (void)resetUI {
	@synchronized(self) {
		if (allBanners.count <= 0) {
			return;
		}
		self.winSize = [UIScreen mainScreen].bounds.size;
		self.imageCount = allBanners.count;
		
		//创建PageControl
		CGRect pageControlFrame = CGRectMake(0, kPageTotalHeight-kPageControlHeight, kPageTotalWidth, kPageControlHeight);
		if (self.pageControl) {
			[self.pageControl removeFromSuperview];
			self.pageControl = nil;
		}
		pageControl = [[UIPageControl alloc] initWithFrame:pageControlFrame];
		self.pageControl.numberOfPages = self.imageCount;
		self.pageControl.currentPage = 0;
		self.pageControl.backgroundColor = [UIColor clearColor];
		self.pageControl.userInteractionEnabled = NO;
		[self.pageControl addTarget:self action:@selector(pageControlValueChanged:) forControlEvents:UIControlEventValueChanged];
		self.bPageControlUsed = NO;
		
		
		//创建ScrollView
		CGFloat y = kSpaceHeight + (kPageTotalHeight-kSpaceHeight-kScrollViewHeight)/2;
		CGRect scrollViewFrame = CGRectMake(kScrollViewLeftWidth, y, kScrollViewWidth, kScrollViewHeight);
		CGSize contentSize = CGSizeMake(kScrollViewWidth * self.pageControl.numberOfPages, kScrollViewHeight);
		if (self.scrollView) {
			[self.scrollView removeFromSuperview];
			self.scrollView = nil;
		}
		scrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
		self.scrollView.layer.cornerRadius = 6;
		self.scrollView.userInteractionEnabled = YES;
		self.scrollView.pagingEnabled = YES;
		self.scrollView.contentSize = contentSize;
		self.scrollView.showsHorizontalScrollIndicator = NO;
		self.scrollView.showsVerticalScrollIndicator = NO;
		self.scrollView.scrollEnabled = YES;
		self.scrollView.scrollsToTop = NO;
		self.scrollView.delegate = self;
		self.scrollView.backgroundColor = [UIColor clearColor];
		
		//创建具体页面
		for (int i = 0; i < self.imageCount; i ++) {
			CGRect cellFrame = CGRectMake(kScrollViewWidth * i, 0, kScrollViewWidth, kScrollViewHeight);
			BTNetImageView *cellView = [[BTNetImageView alloc] initWithFrame:cellFrame];
			cellView.defaultImage = nil;
			cellView.suffix = [BTUtilityClass getPicSuffix:type_banner_cell_view picVersion:10];
			
			//上面有保证self.imageCount==allBanners.count，此处应该不会越界，因此无需判断
			NSDictionary *oneBannerInfo = [allBanners objectAtIndex:i];
			
			cellView.urlPath = [oneBannerInfo valueForKey:POPULARIZ_IMG_URL];
			cellView.autoDisplayActivityIndicator = YES;
			cellView.layer.cornerRadius = 6;
			cellView.userInteractionEnabled = YES;
			{
				CGRect btnFrame = cellFrame;
				btnFrame.origin.x = 0;
				UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
				btn.frame = btnFrame;
				btn.backgroundColor = [UIColor clearColor];
				btn.tag = kTagButtonBegin + i;
				[btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
				[cellView addSubview:btn];
			}
			[self.scrollView addSubview:cellView];
			[cellView release];
		}
		
		[self addSubview:self.scrollView];
		[self addSubview:self.pageControl];

		//创建上面镂空遮罩
		UIImage *coverImage = [UIImage imageNamed:@"banner_cover.png"];
		UIImageView *coverImageView = [[UIImageView alloc] initWithImage:coverImage];
		coverImageView.tag = kTagCoverImageView;
		coverImageView.frame = CGRectMake(0, kSpaceHeight, kCoverViewWidth, kCoverViewHeight);

		//删除原来的镂空遮罩并重新添加
		UIView *oldCoverImageView = [self viewWithTag:kTagCoverImageView];
		[oldCoverImageView removeFromSuperview];
		[self addSubview:coverImageView];
		[coverImageView release];
		
		//创建定时器
		if (!_bStartTimerHasExe) {//保证只创建一次
			_bStartTimerHasExe = YES;
			[self startTimer];
		}
	}
}

- (void)buttonClicked:(UIButton *)btn {

	int selectedBannerId = btn.tag - kTagButtonBegin;
//	NSString *key = [NSString stringWithFormat:@"%d",selectedBannerId];
	if (allBanners.count < selectedBannerId) {
		return;
	}
	NSDictionary *oneBannerInfo = [allBanners objectAtIndex:selectedBannerId];
	if (!oneBannerInfo) {
		return;
	}
	
	NSUInteger bannerIdInt = [[oneBannerInfo valueForKey:POPULARIZ_ID] unsignedIntegerValue];
	NSString *bannerId = [NSString stringWithFormat:@"%u",bannerIdInt];
	CDLog(BTDFLAG_BANNER,@"bannerId:%@",bannerId);
	BTBannerClickedStatisticsAction *bannerAction = [[BTBannerClickedStatisticsAction alloc] init];
	bannerAction.delegate = self;
	[bannerAction clickedBannerAtId:bannerId];
	
	[homeDelegate bannerOpenURL:oneBannerInfo];
}

- (void)saveBannerStatisticsSucceed:(BTBannerClickedStatisticsAction *)action1 {
	CDLog(BTDFLAG_BANNER,@"banner save suc");
	[action1 release];
}

- (void)saveBannerStatisticsFailed:(BTBannerClickedStatisticsAction *)action1 {
	CDLog(BTDFLAG_BANNER,@"banner save failed");
	[action1 release];
}

#pragma mark - BTBaseActionDelegate
- (void)onAction:(BTBaseAction *)action1 withData:(id)data {
	CILog(BTDFLAG_NEW_BANNER,@"local reset");
	self.allBanners = data;
	
	if ([self canRefreshOnLocalFinished]) {
		[self resetUI];
	}
}

- (void)onAction:(BTBaseAction *)action1 withError:(NSError *)error {
	
	self.action = nil;
	[self.action start];
}

#pragma mark - Notification
- (void)checkinFinish:(NSNotification *)notification {
	
	NSDictionary *userInfo = notification.userInfo;
	NSArray *banners = [userInfo arrayForKey:@"allBanners"];
	
	//筛选
	NSTimeInterval nowTime = [BTUtilityClass nowTimeDouble];
	self.allBanners = [NSMutableArray array];
	for (NSDictionary *oneBannerInfo in banners) {
		NSTimeInterval startTime = [[oneBannerInfo numberForKey:POPULARIZ_START_TIME] doubleValue];
		NSTimeInterval endTime = [[oneBannerInfo numberForKey:POPULARIZ_END_TIME] doubleValue];
		if (nowTime >= startTime && nowTime <= endTime) {
			[self.allBanners addObject:oneBannerInfo];
		}
	}

	//刷新
	CILog(BTDFLAG_NEW_BANNER,@"checkin reset");
	if ([self canRefreshOnCheckinFinished]) {
		[self resetUI];
	}
}

@end
