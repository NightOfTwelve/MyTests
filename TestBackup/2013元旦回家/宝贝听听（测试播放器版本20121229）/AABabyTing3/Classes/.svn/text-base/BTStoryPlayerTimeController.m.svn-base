//
//  BTStoryPlayerTimeController.m
//  定时／定量界面相关。
//
//  Created by Vicky on 8/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BTStoryPlayerTimeController.h"

@implementation BTStoryPlayerTimeController
// =========================================
// ** 初始化 **
// =========================================
/**
 * 初始化
 * 参数：nibNameOrNil、nibBundleOrNil为nil。
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		//m_userSetTime				= 0.0;			//初始化用户设定时间为0
    }
    return self;
}

/**
 * 系统函数，自动检测系统内存不足，回调系统函数处理。
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/**
 * 系统函数，Release any retained subviews of the main view.
 */
- (void)viewDidUnload
{
	[m_backView release];
    [super viewDidUnload];
}
// =========================================
// ** View Class **
// =========================================
#pragma mark - View lifecycle
/**
 * 系统函数，View Load逻辑处理。
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
	CGFloat y_dif = ([UIScreen mainScreen].bounds.size.height - (479+1))/2;
	//CDLog(BTDFLAG_IPHONE5,@"y_dif=%f",y_dif);
	self.view.center = CGPointMake(self.view.center.x, self.view.center.y+y_dif);

	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackView)];
	[m_backView addGestureRecognizer:tap];
	[tap release];
	
    //Observer监听定量界面信息，如果用户在定量界面设定故事数后，Timer作废
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(stopTimerByNumberSet:)
												 name:NOTIFICATION_PAUSE_BEGIN_BY_NUMBER_SET_VIEW
											   object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(startTimer:)
												 name:NOTIFICATION_PAUSE_BEGIN_BY_TIME_SET_VIEW
											   object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(stopTimerByNumberClear:)
												 name:NOTIFICATION_POST_TO_TIMER_SET
											   object:nil];
}

- (void)tapBackView {
	//[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TIMER_MASK object:nil];
	[self.view removeFromSuperview];
}

/**
 * 系统函数：Return YES for supported orientations
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// ================================================================================
//  ** 按钮动作相关处理 **
// ================================================================================
// 各种定时按钮按下后，Timer启动动作（发通知）
-(void)timerStart
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_POST_TO_NUMBER_SET object:nil];
	//Timer设定
    if (!(m_userSetTime > -0.0001 && m_userSetTime < 0.0001)) {	//用户设定时间不为0
		
//		//test by zero
//		m_userSetTime = 0.2;

        NSTimeInterval userSetTimeCount = m_userSetTime * 60;	//换算成秒
        //DLog(@"%f",userSetTimeCount);
        NSString *userInfoString    = [NSString stringWithFormat:@"%f",userSetTimeCount];//换算成秒
        NSDictionary *userInfoDic   = [[NSDictionary alloc]initWithObjectsAndKeys:userInfoString,NSLocalizedDescriptionKey,nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TIME_START_BEGIN
                                                                object:nil
                                                              userInfo:userInfoDic];
        [userInfoDic release];
	}
}

//定时按钮动作
-(IBAction)timeSetPressed:(id)sender
{
    //Todo
}

//定量按钮动作
-(IBAction)numberSetPressed:(id)sender
{
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NUMBER_SET_VIEW_WILL_CHANGE object:nil];
}

//N分钟按钮动作
-(IBAction)timeSetSelectedMinuButton:(UIButton*)sender
{
    //总体变为unselected图片
    [self clearAllSelctedPic];
    //设置被选中的图片状态
	if (([sender.titleLabel.text isEqualToString:@"10分钟"]) && (m_userSetTime != 10.0)) {
		m_userSetTime = 10.0;	//定时
		m_timeSetTenMinuButton.selected = YES;
		[self timerStart];
	}
    else if (([sender.titleLabel.text isEqualToString:@"20分钟"]) && (m_userSetTime != 20.0)) {
		m_userSetTime = 20.0;	//定时
        m_timeSetTwentyMinuButton.selected = YES;
		[self timerStart];
	}
    else if (([sender.titleLabel.text isEqualToString:@"30分钟"]) && (m_userSetTime != 30.0)) {
		m_userSetTime = 30.0;	//定时
        m_timeSetThirtyMinuButton.selected = YES;
		[self timerStart];
	}
    else if (([sender.titleLabel.text isEqualToString:@"40分钟"]) && (m_userSetTime != 40.0)) {
		m_userSetTime = 40.0;	//定时
        m_timeSetFortyMinuButton.selected = YES;
		[self timerStart];
	}
    else if (([sender.titleLabel.text isEqualToString:@"60分钟"]) && (m_userSetTime != 60.0)) {
		m_userSetTime = 60.0;	//定时
        m_timeSetSixtyMinuButton.selected = YES;
		[self timerStart];
	}
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TIME_CANCEL object:nil];
        
        m_userSetTime = 0.0;
        [self clearAllSelctedPic];
		return;
	}
}

/**
 *  重设UI
 */
-(void)clearAllSelctedPic{
    m_timeSetTenMinuButton.selected     = NO;
    m_timeSetTwentyMinuButton.selected  = NO;
    m_timeSetThirtyMinuButton.selected  = NO; 
    m_timeSetFortyMinuButton.selected   = NO;  
    m_timeSetSixtyMinuButton.selected   = NO;
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TIME_CANCEL object:nil];
	//zero有疑问
}

/**
 *  Timer开始计时,post notification to BTStoryPlayerController
 */
-(void)startTimer:(NSNotification*)notification
{
    [self timeSetFinshed];
}

// ================================================================================
// ** Notification事件 **
// ================================================================================
/**
 * 当定量界面设定后，定时界面的Timer作废
 */
-(void)stopTimerByNumberSet:(NSNotification *)notification
{
//	m_userSetTime   = 0.0;    //清零
//	[self clearAllSelctedPic];
}

-(void)stopTimerByNumberClear:(NSNotification *)notification
{
    m_userSetTime   = 0.0;    //清零
    [self clearAllSelctedPic];
}

/**
 * 定时界面的Timer作废后，图片、计数全归零
 */
-(void)timeSetFinshed{
    [self clearAllSelctedPic];
    m_userSetTime = 0.0;
}

// ================================================================================
//  ** 析构 **
// ================================================================================
/**
 * 析构函数
 */
-(void)dealloc
{
	[m_timeSetButton			release];
	[m_timeSetTenMinuButton		release];
	[m_timeSetTwentyMinuButton	release];
	[m_timeSetThirtyMinuButton	release];
	[m_timeSetFortyMinuButton	release];
	[m_timeSetSixtyMinuButton	release];
    [m_maskView                 release];
	[m_numberSetButton			release];
	[m_backView release];
	[super						dealloc];
}

@end
