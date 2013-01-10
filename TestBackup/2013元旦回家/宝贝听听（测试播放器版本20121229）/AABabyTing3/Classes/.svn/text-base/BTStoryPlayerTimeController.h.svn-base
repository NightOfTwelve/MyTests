//
//  BTStoryPlayerTimeController.h
//  定时／定量界面相关。
//
//  Created by Vicky on 8/21/12.
//  Copyright (c) 2012 __Tencent_DL__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTStoryPlayerNumberController.h"

#define NOTIFICATION_PAUSE_BEGIN_BY_TIME_SET_VIEW		@"timer_start_to_pause"
#define NOTIFICATION_NUMBER_SET_VIEW_WILL_CHANGE		@"number_set_view_will_show"
#define NOTIFICATION_TIME_CANCEL                        @"time_cancel"

#define NOTIFICATION_TIME_START                         @"timer_start"
#define NOTIFICATION_TIME_START_BEGIN                   @"timer_start_begin"
#define NOTIFICATION_POST_TO_NUMBER_SET                 @"number_set_clear"
#define NOTIFICATION_TIMER_MASK                         @"timer_mask_view"

@interface BTStoryPlayerTimeController : UIViewController{
    // ===================================================
    // ** Outlet **
    // ===================================================
	/**
	 Button
	 */
	IBOutlet	UIButton				*m_timeSetTenMinuButton;		///< 10分钟
	IBOutlet	UIButton				*m_timeSetTwentyMinuButton;		///< 20分钟
	IBOutlet	UIButton				*m_timeSetThirtyMinuButton;		///< 30分钟
	IBOutlet	UIButton				*m_timeSetFortyMinuButton;		///< 40分钟
	IBOutlet	UIButton				*m_timeSetSixtyMinuButton;		///< 60分钟
	
	/**
	 全局button
	 */
	IBOutlet	UIButton				*m_timeSetButton;				///< 定时按钮
	IBOutlet	UIButton				*m_numberSetButton;				///< 定量按钮
    
    // ===================================================
    // ** Others **
    // ===================================================
	/**
	 Mask View
	 */
	IBOutlet   UIViewController         *m_maskView;                     ///< 遮罩View
	IBOutlet   UIView					*m_backView;                     ///< button背景View
    
	
    /**
	 Timer相关
	 */
	double								m_userSetTime;					///< 记录用户设定的时间
}

// ================================================================================
//  ** 按钮动作相关处理 **
// ================================================================================
-(IBAction)timeSetPressed:(id)sender;									//定时按钮动作
-(IBAction)numberSetPressed:(id)sender;									//定量按钮动作

-(IBAction)timeSetSelectedMinuButton:(UIButton*)sender;					//N分钟按钮动作
// ================================================================================
//  ** 其他动作相关处理 **
// ================================================================================
-(void)startTimer:(NSNotification*)notification;						//Timer开始计时
-(void)stopTimerByNumberClear:(NSNotification *)notification;
-(void)timerStart;														//Timer启动动作（发通知）
-(void)clearAllSelctedPic;                                              //重设UI
-(void)timeSetFinshed;													//Timer作废后，图片、计数全归零
@end
