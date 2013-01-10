//
//  BTCustomTabBarController.h
//  AABabyTing3
//
//  Created by  on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#define TAG_TABBAR         1101
#define TAG_BUTTON_ORIGIN  1102
#define TAG_BADGE_ORIGIN   1103
@class BTBadgeView;

@interface BTCustomTabBarController : UITabBarController{
    
    NSMutableArray *_tabBarItems;
    UIView *_customTabBarView;
}
@property (nonatomic, retain)	NSMutableArray		*tabBarItems;
@property (nonatomic, retain)	UIView				*customTabBarView;


-(void)hideRealTabBar;
-(void)customTabBar;
-(void)tabChanged:(UIButton *)bt;

@end
