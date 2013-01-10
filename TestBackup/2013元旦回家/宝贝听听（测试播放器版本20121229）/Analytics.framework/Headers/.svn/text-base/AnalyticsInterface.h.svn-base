//
//  AnalyticsInterface.h
//  Analytics
//
//  Created by test on 11-9-19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnaUploader.h"

/**
 一般用法，完全交由监控sdk自行收集数据并上报
 **/
@interface AnalyticsInterface : NSObject {

}

//注册监控服务，将会向服务器查询策略，并初始化各个模块的默认数据上传器，参数userId为用户qua，参数gateWayIP为当前网络网关IP，不填则默认使用服务器下发的IP
+ (BOOL) enableAnalytics :(NSString *) userId gatewayIP:(NSString *) gatewayIP;

//启用测速功能
+ (BOOL) enableSpeedTrack:(BOOL) enable;

//启用事件上报功能
+ (BOOL) enableEventRecord:(BOOL) enable;

//启用异常上报功能
+ (BOOL) enableCrashReport:(BOOL) enable;
//!!!!!!!IMPORTANT!!!!!!
// 1.you can set to "YES" to enable crash report,
// 2. you need to set one unique build no for you current build 
//   sample code:  
//   #import "CrashReporter.h"
//   str_internal_build_number="2000";
// 3. you also need to set your own callback method to do your own work before crash
//   sample code :
//   static int fooo () {
//     NSLog(@"haha");
//     return 1;
//     }   
//   exp_call_back_func= &fooo;
//!!!!!!!IMPORTANT!!!!!!
// 1. you can set to "NO" and import "CrashReporter.h" to control the crash uplaod manually
// see detail in "CrashReporter.h"

//设置一个GUID的标识,用以通过GUID标识和分类异常用户信息
+ (void) setGUID:(NSString*) guid;

//更换用户时设置userId
+ (void) setUserId:(NSString*) userId;

//用户事件上报通用接口，该接口会保存用户事件到本地，根据上报策略择机上报
//event 事件名称 isSucceed 事件执行是否成功 elapse 事件执行耗时，单位ms size 上报包大小，单位kb params 其他参数，用户自定义
+ (BOOL) onUserAction: (NSString*) eventName isSucceed:(BOOL) isSucceed elapse:(long) elapse size:(long) size params:(NSDictionary *) params;

//实时用户事件上报通用接口，该接口会保存用户事件到本地，并实时上报
//event 事件名称 isSucceed 事件执行是否成功 elapse 事件执行耗时，单位ms size 上报包大小，单位kb params 其他参数，用户自定义
+ (BOOL) onDirectUserAction: (NSString*) eventName isSucceed:(BOOL) isSucceed elapse:(long) elapse size:(long) size params:(NSDictionary *) params;

@end


/**
 能够控制策略的接口
 **/
@interface AnalyticsInterface(StrategyControl)

//该开关为YES的时候会在本地策略生效的时候就开启功能开关（测速／异常），等服务器策略生效后再更新一次
//如果为NO那么会等到服务器策略生效后才开启功能开关
//影响范围：服务器策略生效之前的事件记录和异常处理函数的问题注册
+ (BOOL) enableModuleFunctionBeforeSeverStrategy:(BOOL) enable;

//设置实时事件上报的间隔,默认为1分钟，保护区间>=1分钟
+ (BOOL) setRealTimeEventUploadDuration:(int) minitues;

//设置实时事件上报的最大累计上报条数（满足条数即上报)
//默认分别为10，保护区间<=50
+ (BOOL) setRealTimeEventUploaMaxCount:(int) maxPkgSize;

@end


/**
 主要是QQ提的需求，提供一个回调接口以控制上报的时机，上报时机需要用户确认。
 工作在默认调用模式下，而不是NoAnalyticsNetwork
 **/
@interface AnalyticsInterface (NetworkControll)

//注册一个上传时机的确认器，以便sdk在到达上传时机后询问是否有上传条件，默认时永远返回YES，客户端可以自己注册以便在网络繁忙时禁止上传
//如果禁止上传，sdk将会选择下次时机上传，如果sdk本地存储的数据量达到一定上限后，新的数据将不予存储
+ (BOOL) registAnaUploadConfirmer:(id<AnaUploadConformer>) conformer;

@end


/**
 主要是微薄提的需求，没有上报和查询策略的操作，只提供数据，交由微薄自己调用接口上报
 **/
@interface AnalyticsInterface(NoAnalyticsNetwork)

//注册监控服务，不会向服务器查询策略，需要客户端主动设置，可以调用setStrategyForMaxPkgSize
//需要客户端调用getMixDataUploader等接口自己获取数据，并在上传完成后通知sdk
//客户端可以在任意时刻调用接口获取数据，也可以注册AnaUplaodNotifier协议以便能收到sdk提供的存储数据量达到上限的通知以便能及时上传，因为sdk对存储在本地的数据量时有限制的，超过的将不予存储
+ (BOOL) enableAnalyticsWithoutNetwork :(NSString *) userId gatewayIP:(NSString *) gatewayIP;

//获取各种类型数据的上传者，从上传者那里可以得到上传的数据，
//getMixData
+ (id<AnaUploader>) getMixDataUploader;
//getRealTimeEventData
+ (id<AnaUploader>) getRealTimeEventDataUploader;
//getCrashData
+ (id<AnaUploader>) getCrashDataUploader;

//注册一个混合数据到达上限的监听器，以便能接收信号
+ (BOOL) registMixDataUploadNotifier:(id<AnaUplaodNotifier>) notifier;
//注册一个实时事件到达上限的监听器，以便能接收信号
//+ (BOOL) registRealTimeEventDataUploadNotifier:(id<AnaUplaodNotifier>) notifier;

//设置事件上报的最大累计上报条数（满足条数即上报)，及本地数据库的最大容量（超过限额不予存储）
//默认分别为50 200，保护区间20～100, 100～200
//注意：采用默认调用方式，sdk会在与服务器通讯获取策略后更新本地策略，所以该模式下改API实效
+ (BOOL) setStrategyForMaxPkgSize:(int) maxPkgSize dbMaxSize:(int) dbMaxSize;

@end


/**
 QZone定义的常用事件上报接口
 **/
@interface AnalyticsInterface (QZoneDefinedEvent)

//登录事件
+ (BOOL) onLogin: (BOOL) isSucceed elapse:(long) elapse size:(long) size params:(NSDictionary *) params;
//上传图片事件
+ (BOOL) onUploadPicture: (BOOL) isSucceed elapse:(long) elapse size:(long) size params:(NSDictionary *) params;
//写日志事件
+ (BOOL) onWriteBlog: (BOOL) isSucceed elapse:(long) elapse size:(long) size params:(NSDictionary *) params;

//启动事件
+ (BOOL) onStart: (BOOL) isSucceed elapse:(long) elapse size:(long) size params:(NSDictionary *) params;
//写操作
+ (BOOL) onWrite: (BOOL) isSucceed elapse:(long) elapse size:(long) size params:(NSDictionary *) params;
//刷新操作
+ (BOOL) onRefresh: (BOOL) isSucceed elapse:(long) elapse size:(long) size params:(NSDictionary *) params;
//界面渲染
+ (BOOL) onRender: (BOOL) isSucceed elapse:(long) elapse size:(long) size params:(NSDictionary *) params;

@end
