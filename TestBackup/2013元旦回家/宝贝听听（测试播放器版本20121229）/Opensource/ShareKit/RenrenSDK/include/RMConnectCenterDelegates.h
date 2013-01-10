//
//  RMConnectCenterDelegates.h
//  RMSDK
//
//  Created by renren-inc on 11-12-27.
//  Copyright (c) 2011年 人人网. All rights reserved.
//
/**
 *zh
 * 连接中心
 *en
 * Connect Center
 */
#import <Foundation/Foundation.h>
#import "RMError.h"

@class RMHeartbeatNewMessage;

@protocol RenrenLoginViewControllerDelegate <NSObject>
/**
 *zh
 * 人人登录界面回调
 * 当登录取消时，关闭登录人人界面，delegate受到此回调
 *
 *en
 * Call-back method for Renren login view controller.
 * Will be called when Renren login view controller be closed while user cancels login. 
 */
- (void)didCloseToLoginCancel;
/**
 *zh
 * 人人登录界面回调
 * 当登录成功时，关闭登录人人界面，delegate受到此回调
 *
 *en
 * Call-back method for Renren login view controller.
 * Will be called when Renren login view controller be closed for the reason of login success. 
 */
- (void)didCloseToLoginSuccess;

@end

@protocol RenrenMobileDelegate <NSObject>
@optional
/**
 *zh
 * 第三方开发者可选实现该方法
 * 通知第三方开发者人人网功能界面将要出现。
 *
 *en
 * optional realization method for third-party developers
 * Notify the third party developers renren function interface will appear.
 */
- (void)dashboardWillAppear;

/**
 *zh
 * 第三方开发者可选实现该方法
 **通知第三方开发者人人网功能界面已经出现
 *
 *en
 * optional realization method for third-party developers
 * Notify the third party developers renren function interface did appear.
 */
- (void)dashboardDidAppear;

/**
 *zh
 * 第三方开发者可选实现该方法
 * 通知第三方开发者人人网功能界面将要消失
 *
 *en
 * optional realization method for third-party developers
 * Notify the third party developers renren function interface will appear.
 */
- (void)dashboardWillDisappear;

/**
 *zh
 * 第三方开发者可选实现该方法
 * 通知第三方开发者人人网功能界面已经消失
 *
 *en
 * optional realization method for third-party developers
 * Notify the third party developers renren function interface did appear.
 */
- (void)dashboardDidDisappear;

/**
 *zh
 * 第三方开发者可选实现该方法
 * 通知第三方开发者用户登录人人网验证状态
 * @param flag:YES登录成功;NO登录失败 
 *
 *en
 * required realization method for third-party developers
 * Notify the third party developers the validation status of user login renren.
 * @param flag: YES login success; NO login failed
 */
//- (void)renrenLoginWithAuthStauts:(BOOL)flag;
#pragma mark Heartbeat

/**
 *zh
 * 第三方开发者可选实现该方法
 * 人人网连接中心轮询消息中心获得到的新消息时,通知第三方开发者。
 * @param message：轮询消息数对象
 *
 *en 
 * optional realization method for third-party developers
 * Notify the third party developers ，RMConnectCenter receives that the message
 * @param message：the object of Class RMHeartbeatNewMessage
 */
- (void)receivedHeartBeatMessage:(RMHeartbeatNewMessage *)message;


@required
/**
 *zh
 * 第三方开发者必须实现该方法
 * RenrenMobile每次启动都会检查当前用户身份是否仍有效，
 * 当验证失败时，RenrenMobile会清除用户登录会话信息，并调用此代理方法通知第三方开发者验证失败。
 * 
 *en
 * required realization method for third-party developers
 * check whether the current user is still valid every time the RenrenMobile start.
 * RenrenMobile clear the user login session information when validation fails and call this proxy method to notify the third-party developers validation fails.
 */
- (void)reAuthVerifyUserFailWithError:(RMError *)error;

@end

