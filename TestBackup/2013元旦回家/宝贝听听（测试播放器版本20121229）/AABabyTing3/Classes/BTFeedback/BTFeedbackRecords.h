//
//  BTFeedbackRecords.h
//  Test_Feedback
//
//  Created by Zero on 11/23/12.
//  Copyright (c) 2012 songzhipeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTFeedbackRecord.h"
@interface BTFeedbackRecords : NSObject
<NSCoding>

//获取单例
+ (BTFeedbackRecords *)sharedInstance;

//销毁单例
+ (void)destorySharedInstance;

//获取一条记录
//当没有可用记录时，返回nil
- (BTFeedbackRecord *)getOneRecord;

//添加一条记录
- (void)addRecord:(BTFeedbackRecord *)record;

//删除一条记录
- (BOOL)deleteRecord;

//当本条发送失败，需要发送下一条时，调用
- (BTFeedbackRecord *)getNextRecord;
@end
