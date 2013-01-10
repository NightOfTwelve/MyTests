//
//  BTStoryPlayerNumberController.h
//  定量界面相关文件。
//
//  Created by Vicky on 8/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

// ============================================================
// ** Import **
// ============================================================
#import <UIKit/UIKit.h>
#import "BTStoryPlayerTimeController.h"

// ============================================================
// ** Define **
// ============================================================
#define NOTIFICATION_PAUSE_BEGIN_BY_NUMBER_SET_VIEW @"numberSetView_pause_notification"
#define NOTIFICATION_POST_TO_TIMER_SET              @"post_to_timer_clear"
#define NOTIFICATION_NUMBER_MASK                    @"number_mask_view"
// ============================================================
// ** Interface **
// ============================================================
@interface BTStoryPlayerNumberController : UIViewController{
	// ===================================================
    // ** Outlet 属性**
    // ===================================================
	/**
	 Button
	 */
	IBOutlet	UIButton	*m_numberSetTwoButton;              ///< 2个故事按钮
	IBOutlet	UIButton	*m_numberSetThreeButton;            ///< 3个故事按钮
	IBOutlet	UIButton	*m_numberSetFourButton;             ///< 4个故事按钮
	IBOutlet	UIButton	*m_numberSetFiveButton;             ///< 5个故事按钮
	IBOutlet	UIButton	*m_numberSetSixButton;              ///< 6个故事按钮
	
	/**
	 全局button
	 */
	IBOutlet	UIButton	*m_timeSetButton;					///< 定时按钮
	IBOutlet	UIButton	*m_numberSetButton;					///< 定量按钮
	// ===================================================
    // ** Others 属性**
    // ===================================================
	int								m_numberUserSetCount;		///< 用户设定的故事数
	/**
	 Mask View
	 */
	IBOutlet   UIViewController		*m_maskViewForNumberSet;	///< 遮罩View
	IBOutlet UIView *m_backView;
}

// ================================================================================
//  ** 按钮动作相关处理 **
// ================================================================================

-(IBAction)timeSetButtonPressed:(id)sender;						//定时按钮动作
-(IBAction)numberSetButtonPressed:(id)sender;					//定量按钮动作

-(IBAction)numberSetSelectedButton:(UIButton*)sender;           //N个故事按钮动作
// ================================================================================
//  ** Others动作相关处理 **
// ================================================================================
-(void)numberSetStart;                                          //定量开始
-(void)stopNumberSetByTimer:(NSNotification *)notificaion;      //定时界面为主时动作
-(void)clearAllSelctedPic;                                      //重设UI
-(void)numberSetFinished;										//定量界面的定量功能作废后，图片、计数全归零
@end
