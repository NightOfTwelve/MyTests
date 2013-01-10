//
//  BTPopoverContentViewController.h
//  testPopoverController
//
//  Created by Zero on 11/6/12.
//  Copyright (c) 2012 songzhipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXLabel.h"

#pragma mark - 用于请求的rankid常量定义
#define Request_Rank_ID_Week	(1)
#define Request_Rank_ID_Today	(2)
#define Request_Rank_ID_Month	(3)
#define Request_Rank_ID_Total	(4)


#pragma mark - 点击某个排行榜的委托协议
@class BTRankCategory;
@protocol BTPopoverContentViewControllerDelegate <NSObject>
- (void)didSelectedAtIndex:(NSInteger)selectedIndex;
@end

#pragma mark - 排行榜类别(BTRankCategory)
//排行榜类别
@interface BTRankCategory : NSObject
@property (nonatomic,assign) NSInteger lastId;
@property (nonatomic,assign,readonly) NSInteger requestId;
@property (nonatomic,copy) NSString *name;
- (id)initWithRequestId:(NSInteger)theRequestId andName:(NSString *)theName;
+ (id)rankCategoryWithRequestId:(NSInteger)theRequestId andName:(NSString *)theName;
@end




#pragma mark - BTPopoverContentViewController
@interface BTPopoverContentViewController : UIViewController
@property (nonatomic,assign) id<BTPopoverContentViewControllerDelegate> delegate;
@property (nonatomic,assign) NSInteger selectedIndex;
- (id)initWithRankCategories:(NSMutableArray *)rankCategories;
@end
