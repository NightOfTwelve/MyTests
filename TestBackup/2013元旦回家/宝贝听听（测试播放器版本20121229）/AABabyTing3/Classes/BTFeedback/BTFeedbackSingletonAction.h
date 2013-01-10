//
//  BTFeedbackSingletonAction.h
//  AABabyTing3
//
//  Created by Zero on 11/23/12.
//
//

#import <Foundation/Foundation.h>
#import "BTFeedbackSingletonService.h"

@protocol BTFeedbackSingletonActionDelegate <NSObject>
@optional
//所有的意见反馈记录都已发送完毕
//（不管成功还是失败，应该销毁单例action了）
- (void)allRecordsHadBeedSend;
@end

@class BTFeedbackRecord;
@interface BTFeedbackSingletonAction : NSObject
<BTFeedbackSingletonServiceDelegate>

//添加一条反馈记录
- (void)addOneRecord:(BTFeedbackRecord *)record;

//发送所有反馈记录
- (void)reportAllRecords;

//创建单例
+ (BTFeedbackSingletonAction *)sharedInstance;

//销毁单例
+ (void)destorySharedInstance;

//最多失败次数
@property(nonatomic,assign) int maxRetryCount;

@property(nonatomic,assign) id<BTFeedbackSingletonActionDelegate> delegate;
@end


