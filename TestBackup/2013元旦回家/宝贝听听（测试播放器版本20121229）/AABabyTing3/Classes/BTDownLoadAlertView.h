//
//  BTDownLoadAlertView.h
//  全局提示View。单例使用。
//  调用方法：
//  [[BTDownLoadAlertView sharedAlertView] showDownLoadCompleteAlertWithString:@"XXX"];
//  [BTDownLoadAlertView showAlert];
//
//  Created by Vicky on 12-8-23.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

// =======================================================
// ** Import **
// =======================================================
#import <UIKit/UIKit.h>
#import "BTAppDelegate.h"
// =======================================================
// ** Class声明 **
// =======================================================
@interface BTDownLoadAlertView : UIView {
    BOOL                    m_tipShow;                                  ///< 防止重复加载
}

// =======================================================
// ** 属性 **
// =======================================================
@property (nonatomic)BOOL tipShow;                                      ///< 防止重复加载

// =======================================================
// ** 方法 **
// =======================================================
+(id)sharedAlertView;                                                   //初始化
+(void)showAlert;                                                       //加载View到App上

-(void)showDownLoadCompleteAlertWithString:(NSString *)showString;      //显示内容
-(void)modifyModeName:(NSString *)name;                                 //改变显示内容
@end
