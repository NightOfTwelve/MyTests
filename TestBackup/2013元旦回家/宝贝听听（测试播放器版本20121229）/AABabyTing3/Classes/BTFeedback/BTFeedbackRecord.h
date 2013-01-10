//
//  BTFeedbackRecord.h
//  Test_Feedback
//
//  Created by Zero on 11/23/12.
//  Copyright (c) 2012 songzhipeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTFeedbackRecord : NSObject
<NSCoding>
@property(nonatomic,copy) NSString *appName;
@property(nonatomic,copy) NSString *appVersion;
@property(nonatomic,copy) NSString *apiVersion;
@property(nonatomic,copy) NSString *uuid;
@property(nonatomic,copy) NSString *text;
@property(nonatomic,copy) NSString *qq;
@property(nonatomic,copy) NSString *email;
@property(nonatomic,copy) NSString *tel;
@property(nonatomic,copy) NSDate *date;
+ (BTFeedbackRecord *)record;
@end
