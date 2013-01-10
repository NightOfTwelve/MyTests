//
//  BTHomeData.h
//  AABabyTing3
//
//  Created by Neo Wang on 12-8-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTHomeData : NSObject
@property (nonatomic,copy)NSString *homeID;
@property (nonatomic,copy)NSString *category;
@property (nonatomic,copy)NSString *describe;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *iconURL;
@property (nonatomic,copy)NSString *updateDate;
@property (nonatomic,assign)BOOL isNew;
@property (assign)NSInteger picVersion;
@end
