//
//  BTStoryPlayerNumberController.m
//  定量界面相关文件。定量界面加载在定时界面上。
//
//  Created by Vicky on 8/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

// ============================================================
// ** Import **
// ============================================================
#import "BTStoryPlayerNumberController.h"

@implementation BTStoryPlayerNumberController
// ============================================================
// ** 初始化 **
// ============================================================
/**
 *	初始化函数
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //m_numberUserSetCount = 0;	//初始化用户设定故事数为0
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
	
//	m_backViewForNumberSet.view.backgroundColor = [UIColor clearColor];
    //Observer监听定时界面信息，如果用户在定时界面设定故事数后，通知StoryPlayer以前设置的故事数为0
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(stopNumberSetByTimer:)
												 name:NOTIFICATION_PAUSE_BEGIN_BY_TIME_SET_VIEW
											   object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(stopNumberSetByTimer:)
												 name:NOTIFICATION_POST_TO_NUMBER_SET
											   object:nil];
}

- (void)tapBackView {
   if (m_numberUserSetCount == 0) {
     [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NUMBER_MASK object:nil userInfo:nil];
    }
	[self.view removeFromSuperview];
}

/**
 * 系统函数：Return YES for supported orientations
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/**
 * 系统函数，Release any retained subviews of the main view.
 */
- (void)viewDidUnload
{
	[m_backView release];
	m_backView = nil;
    [super viewDidUnload];
	self.view.backgroundColor = [UIColor clearColor];
}

// ================================================================================
//  ** 按钮动作相关处理 **
// ================================================================================
/**定时按钮动作
 * Superview：[BTStoryPlayerTimeView]定时界面
 */
-(IBAction)timeSetButtonPressed:(id)sender
{
    NSString *usrInfoString    = @"numberView";
    NSDictionary *usrInfoDic   = [[NSDictionary alloc]initWithObjectsAndKeys:usrInfoString,NSLocalizedDescriptionKey,nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NUMBER_SET_VIEW_WILL_CHANGE object:nil userInfo:usrInfoDic];
     [usrInfoDic release];
//
//    NSString *userInfoString    = [NSString stringWithFormat:@"%d",m_numberUserSetCount];
//    NSDictionary *userInfoDic   = [[NSDictionary alloc]initWithObjectsAndKeys:userInfoString,NSLocalizedDescriptionKey,nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PAUSE_BEGIN_BY_NUMBER_SET_VIEW
//                                                        object:nil
//                                                      userInfo:userInfoDic];
//    [userInfoDic release];
}

/**
 * 定量按钮动作
 */
-(IBAction)numberSetButtonPressed:(id)sender
{
}

/**
 * N个故事按钮动作
 */
-(IBAction)numberSetSelectedButton:(UIButton*)sender
{
    //总体变为unselected图片
    [self clearAllSelctedPic];
    
    //设置被选中的图片状态
	if (([sender.titleLabel.text isEqualToString:@"2个故事"]) && (m_numberUserSetCount != 2)) {
		m_numberUserSetCount = 2;
		m_numberSetTwoButton.selected = YES;
		[self numberSetStart];
	}
    else if (([sender.titleLabel.text isEqualToString:@"3个故事"]) && (m_numberUserSetCount != 3)){
		m_numberUserSetCount = 3;
        m_numberSetThreeButton.selected = YES;
		[self numberSetStart];
	}
    else if (([sender.titleLabel.text isEqualToString:@"4个故事"]) && (m_numberUserSetCount != 4)) {
		m_numberUserSetCount = 4;
        m_numberSetFourButton.selected = YES;
		[self numberSetStart];
	}
    else if (([sender.titleLabel.text isEqualToString:@"5个故事"]) && (m_numberUserSetCount != 5)) {
		m_numberUserSetCount = 5;
        m_numberSetFiveButton.selected = YES;
		[self numberSetStart];
	}
    else if (([sender.titleLabel.text isEqualToString:@"6个故事"]) && (m_numberUserSetCount != 6)) {
		m_numberUserSetCount = 6;
        m_numberSetSixButton.selected = YES;
		[self numberSetStart];
	}
    else {
        [self clearAllSelctedPic];
        m_numberUserSetCount = 0;
		
		NSString *userInfoString    = [NSString stringWithFormat:@"%d",m_numberUserSetCount];
		NSDictionary *userInfoDic   = [[NSDictionary alloc]initWithObjectsAndKeys:userInfoString,NSLocalizedDescriptionKey,nil];
		[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PAUSE_BEGIN_BY_NUMBER_SET_VIEW 
															object:nil
														  userInfo:userInfoDic];
		[userInfoDic release];
		return;
	}
}

/**
 *  重设UI
 */
-(void)clearAllSelctedPic{
    m_numberSetTwoButton.selected   = NO;
    m_numberSetThreeButton.selected = NO;
    m_numberSetFourButton.selected  = NO;
    m_numberSetFiveButton.selected  = NO;
    m_numberSetSixButton.selected   = NO;
}
//
// ================================================================================
// ** View Touch事件 **
// ================================================================================
/**
 * 点击遮罩背景响应函数
 */
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
//{
//	UITouch *touch =  [touches anyObject];
//    if([touch view] == m_backViewForNumberSet.view)
//	{
//	}
//    
//	else if([touch view] == m_maskViewForNumberSet.view)
//	{
//        if (m_numberUserSetCount == 0) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NUMBER_MASK object:nil userInfo:nil];
//        }
//		[self.view removeFromSuperview];
//	}
//}

/**
 * 定量action开始响应事件
 */
-(void)numberSetStart
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_POST_TO_TIMER_SET object:nil];
    NSString *userInfoString = [NSString stringWithFormat:@"%d",m_numberUserSetCount];
    NSDictionary *userInfoDic = [[NSDictionary alloc]initWithObjectsAndKeys:userInfoString,NSLocalizedDescriptionKey,nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PAUSE_BEGIN_BY_NUMBER_SET_VIEW 
                                                        object:nil
                                                      userInfo:userInfoDic];
	[userInfoDic release];
}

/**
 * 定量界面的定量功能作废后，图片、计数全归零
 */
-(void)numberSetFinished{
    [self clearAllSelctedPic];
    m_numberUserSetCount = 0;
}
// ================================================================================
// ** Notification事件 **
// ================================================================================
/**
 * 当用户设置定时时，定量功能取消
 */
-(void)stopNumberSetByTimer:(NSNotification *)notificaion
{
    m_numberUserSetCount    = 0;    //清零
    
    NSString *userInfoString    = [NSString stringWithFormat:@"%d",m_numberUserSetCount];
    NSDictionary *userInfoDic   = [[NSDictionary alloc]initWithObjectsAndKeys:userInfoString,NSLocalizedDescriptionKey,nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PAUSE_BEGIN_BY_NUMBER_SET_VIEW 
                                                        object:nil
                                                      userInfo:userInfoDic];
	[userInfoDic release];
    [self clearAllSelctedPic];
}

// ================================================================================
//  ** 析构 **
// ================================================================================
/**
 * 析构函数
 */
-(void)dealloc
{
	[m_numberSetButton				release];
	[m_timeSetButton				release];
	[m_numberSetTwoButton			release];
	[m_numberSetThreeButton			release];
	[m_numberSetFourButton			release];
	[m_numberSetFiveButton			release];
	[m_numberSetSixButton			release];
	[m_maskViewForNumberSet			release];
	[m_backView release];
	[super							dealloc];
}

@end
