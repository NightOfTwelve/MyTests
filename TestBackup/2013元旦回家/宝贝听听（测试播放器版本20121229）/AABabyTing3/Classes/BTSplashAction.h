//
//  BTSplashAction.h
//  闪屏相关文件。
//
//  Created by vicky on 8/31/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
// =========================================
//  ** Import **
// =========================================
#import <Foundation/Foundation.h>
#import "BTBaseAction.h"
#import "BTSplashService.h"

// ==========================================
//  ** Protocol  BTSplashActionnDelegate **
// ==========================================
@protocol BTSplashActionnDelegate <BTBaseActionDelegate>
- (void) didFinishGetSplashAction:(NSDictionary*)dic;               //GetSplash action完成
- (void) didGetSplashError		 :(NSDictionary*)dic;               //GetSplash action容错处理
@end

// =========================================
//  ** Interface  BTSplashAction **
// =========================================
@interface BTSplashAction : BTBaseAction{
// ==================
// ** 属性相关 **
// ==================
    NSInteger           _downloadSplashIndex;                       ///< 闪屏的Index值
    NSArray             *_splashInfos;                              ///< 闪屏信息
    BTSplashService     *_splashService;                            ///< 闪屏Service
    NSArray             *_needDownloadSplashs;                      ///< 筛选后的闪屏信息
}
// =========================================
//  ** BTSplashAction 方法 **
// =========================================
+ (UIImage *)getSplashImage;                                         //从plist里获取图片

- (void)downloadSplash;                                             //调用Service的请求方法
@end
