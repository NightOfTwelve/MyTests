//
//  BTCategoryData.h
//  cid = 303.故事列表界面第一个TabView数据相关。
//
//  Created by Neo Wang on 12-8-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTCategoryData : NSObject{
}

@property (nonatomic,copy)NSString       *title;
@property (assign)NSInteger              categoryID;
@property (nonatomic,copy)NSString       *iconURL;
@property (nonatomic,copy)NSString       *describe;
@property (nonatomic,copy)NSString       *type;
@property (assign)NSInteger              count;
@property (assign)NSInteger              picVersion;
@end
