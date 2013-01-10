//
//  RMConnectCenter.h
//  RMSDK
//
//  Created by Renren-inc on 11-9-28.
//  Copyright 2011年 Renren Inc. All rights reserved.
//  - Powered by Team Pegasus. -
//
/**
 *zh
 * 连接中心
 *en
 * Connect Center
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RMConnectCenterDelegates.h"
#import "RMRequestContextDelegate.h"

//读取用户的资源
NSString *const kScopeType_ReadReasource;
//操作用户的资源
NSString *const kScopeType_WrireReasource;
//上传用户的游戏分数
NSString *const kScopeType_ShareGameScore;
//操作用户的位置信息
NSString *const kScopeType_ReadLBS;
//管理用户的公共主页
NSString *const kScopeType_MainPage;
//读取用户的消息
NSString *const kScopeType_ReadMessage;
//操作用户的消息
NSString *const kScopeType_WriteMessage;
//访问用户的所有人人网信息
NSString *const kScopeType_All;


@protocol RMRequestContextDelegate;
@class RMUser;

@interface RMConnectCenter : NSObject <RMRequestContextDelegate,UIAlertViewDelegate> {
    id<RenrenMobileDelegate> _connectCenterDelegate;
}
/// 确认并实现了@protocol RenrenMobileDelegate的任意对象。  confirm and realize any objects of @protocol RenrenMobileDelegate.
@property(nonatomic ,assign)id<RenrenMobileDelegate> connectCenterDelegate;

/**
 *zh
 * 此方法是人人连接中心的初始化方法，请先调用此方法并保证传入正确参数。
 *@param apiKey    分配给应用的apiKey
 *@param secretKey 分配给应用的secretKey
 *@param appId     分配给应用的appId
 *@param delegate  确认并实现RenrenMobileDelegate的delegate
 *
 *en
 * this method is the initialize method of RMConnectCenter, please make sure you call this method first and pass the correct parameter
 *@param apiKey    api assigned to the application
 *@param secretKey secretKey assigned to the application
 *@param appId     appId assigned to the application
 *@param delegate  confirm and realize the delegate of RenrenMobileDelegate
 */
+ (void)initializeConnectWithAPIKey:(NSString *)apiKey 
                          secretKey:(NSString *)secretKey
                              appId:(NSString *)appId
                     mobileDelegate:(id<RenrenMobileDelegate>)delegate;
/**
 *zh
 * 销毁人人网所生成的全部实例，调用此方法后其他任何接口皆无法使用，要重新启用必须再调用人人连接中心的初始化方法
 * initializeConnectWithAPIKey: secretKey: appId:mobileDelegate:
 *
 *en
 * destroy all the instances created by renren, all the other interfaces would be invalid after this method is called, they would won't be valid unless you call the nitialize method of RMConnectCenter.
 */
+ (void)disconnectRenrenMobile;

/**
 *zh
 * 获取RMConnectCenter的实例。
 *
 *en
 * get the instance of RMConnectCenter
 */                               
+ (RMConnectCenter *)sharedCenter;

/**
 *zh
 * 判断当前是否有用户登录人人网。
 * @return YES，已有用户登录人人网；NO，没用用户登录人人网
 *
 *en
 * Verify if there are any users login renren.
 * @return YES, user has login renren; NO, nobody login renren.
 */ 
+ (BOOL)isCurrentUserLogined;

/**
 *zh
 * 返回当前登录人人网用户的 access token，若当前无用户登录返回nil
 *
 *en
 * Return the access token for current renren‘s user  , if the current user unlogin returns nil.
 */ 
+ (NSString *)currertUserAccessToken;

/**
 *zh
 * 从人人网登出当前用户。
 *
 *en
 * logout the current user from renren.
 */ 
+ (void)logoutCurrentUser;

/**
 *zh
 * 获取当前登录用户的实例，可查看用户的基本信息。
 * 使用RMUserGetInfoContext，传入的UserId为当前用户时，RMConnectCenter会自动补全当前用户信息。
 *
 *en
 * get the instance of current user and you can view the user's basic information.
 * When the incoming UserId is current user, the RMConnectCenter will automatically complete the current user's information if you use RMUserGetInfoContext
 */ 
+ (RMUser*)currentUser;

/**
 *zh
 * 完成社交组件与主客户端SSO登录的主要方法，第三方开发者必须在UIApplicationDelegate中调用此方法：
 *
 *en
 * to complete the RMTinyClient and the main client SSO login method, the third-party developers must call this method in the UIApplicationDelegate:
 * - (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
 *   return [[RMConnectCenter sharedCenter] handleOpenURL:url];
 * }
 *
 * - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
 *   return [[RMConnectCenter sharedCenter] handleOpenURL:url];
 * }
 */ 
- (BOOL)handleOpenURL:(NSURL *)url;


/**
 *zh
 * 启动人人网的授权功能
 * 使用此接口时，SDK将自动选择授权方式——SSO授权和页面授权
 * @param scope    权限列表，多个权限请使用“,”间隔
 * @param delegate 处理授权结果的代理
 *en
 * Start the Authorized function of renren
 * when using this interface, the SDK will automatically choose the authorized way -- SSO authorized and Page authorized  
 * @param scope    authority list.  Multiple authority, Please using "," to separate it.
 * @param delegate The delegate deal with the result of Authorized.
 */
- (void)launchDashboardLoginWithScope:(NSString *)scope andDelegate:(id<RenrenLoginViewControllerDelegate>)delegate;

/**
 *zh
 * 启动人人网的授权功能
 * 使用此接口时，SDK将依据参数isManual选择授权方式
 * 如果isManual为YES，SDK将提示AlertView让用户选择是通过SSO授权，还是通过页面授权。
 * 如果isManual为NO，SDK将自动选择授权方式——SSO授权和页面授权
 * 当无法进行SSO授权时，则不会提示AlertView自动选择页面授权。
 * @param scope     权限列表，多个权限请使用“,”间隔
 * @param delegate  处理授权结果的代理
 * @param isManual 用来标识是SDK自动选择授权方式，还是用户手动选择授权方式
 *en
 * Start the Authorized function of renren
 * when using this interface, the SDK will automatically choose the authorized way Based on the param of isManual.
 * if the Value of isManual is YES, the SDK will remind the user to choose the authorized way -- SSO authorized or Page authorized
 * if the Value of isManual is NO, the SDK will automatically choose the authorized way -- SSO authorized and Page authorized
 * when it's unable to use SSO authorized, it will automatically choose Page authorized without any AlertView to remind the user.
 * @param scope     authority list.  Multiple authority, Please using "," to separate it.
 * @param delegate  The delegate deal with the result of Authorized.
 * @param isManual the flag of authorized way -- SDK Automatic selection or Users choose by themselves 
 */
- (void)launchDashboardLoginWithScope:(NSString *)scope delegate:(id<RenrenLoginViewControllerDelegate>)delegate andManualSwitch:(BOOL)isManual;

/**
 *zh
 * 启动人人网的注册界面
 *
 *en
 * Start the Registered interface of renren
 */ 
- (void)launchDashboardRegister;


@end





