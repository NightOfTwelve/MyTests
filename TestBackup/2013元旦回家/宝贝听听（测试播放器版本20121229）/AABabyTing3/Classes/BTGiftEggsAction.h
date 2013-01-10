//
//  BTGiftEggsAction.h
//  AABabyTing3
//
//  Created by Zero on 9/2/12.
//
//  砸蛋Action

#import <Foundation/Foundation.h>
#import "BTBaseAction.h"
#import "BTGiftEggsBaseService.h"

@interface BTGiftEggsAction : BTBaseAction

@property (nonatomic, copy)	NSString		*requestUrlStr;

- (void)oneStoryHasPlayed;

//重置“重试/取消”标识
+ (void)resetRetryCancelFlag;

//获取“重试/取消”标识
//若联网失败时，此标识为YES，不提示“重试/取消”；反之，则提示。
+ (BOOL)getRetryCancelFlag;

//设置“重试/取消”标识
+ (void)setRetryCancelFlag;
@end
