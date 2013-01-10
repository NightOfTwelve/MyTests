//
//  BTCustomTabBarController.m
//  AABabyTing3
//
//  Created by  on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTCustomTabBarController.h"
#import "BTBadgeView.h"
#import "BTConstant.h"
#import "BTUtilityClass.h"
#import "BTBadgeImageView.h"



@implementation BTCustomTabBarController

@synthesize customTabBarView = _customTabBarView;
@synthesize tabBarItems = _tabBarItems;


-(id)init{
    
    self = [super init];
    if(self){
        
        [[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(setBadge:)
													 name: NOTIFICATION_ADD_BADGE_TO_TABBAR
												   object: nil];
        [self hideRealTabBar];
        [self customTabBar];
        
    }
    
    return self;
}

- (void)hideRealTabBar{
	for(UIView *view in self.view.subviews){
		if([view isKindOfClass:[UITabBar class]]){
			view.hidden = YES;
			break;
		}
	}
}

- (void)setBadge:(NSNotification *)_notification{
	NSDictionary *dic = [_notification userInfo];
	int index = [[dic valueForKey:@"index"] intValue];
	UIButton *btn = [self.tabBarItems objectAtIndex:index];
	NSString *text = [_notification object];
    UIFont *font = [UIFont boldSystemFontOfSize: 12];
    NSUInteger tag = TAG_BADGE_ORIGIN + index;
    
    if ([btn viewWithTag:tag]) {
        [[btn viewWithTag:tag] removeFromSuperview];
    }
    
    if (index == 2) {//本地TabBar上的数字
        BTBadgeImageView *badgeImageView = [[BTBadgeImageView alloc] initWithText:text font:font];
        CGRect badgeFrame = badgeImageView.frame;
        badgeFrame.origin.x = btn.bounds.size.width/2+8;
        badgeFrame.origin.y = -6;
        badgeImageView.frame = badgeFrame;
        badgeImageView.tag = tag;
        [btn addSubview:badgeImageView];
        [badgeImageView release];
    } else if (index == 3) {//更多TabBar上的“新版本”
        CGRect frame = CGRectMake(btn.bounds.size.width/2-12, -6, 49, 23);
        BTBadgeImageView *badgeImageView = [[BTBadgeImageView alloc] initWithText:nil font:nil];
        badgeImageView.image = [UIImage imageNamed:@"moreTabbar_new_version.png"];
        badgeImageView.frame = frame;
        badgeImageView.tag = tag;
        [btn addSubview:badgeImageView];
        [badgeImageView release];
    }
}

-(void)customTabBar{
    
    self.tabBarItems = [NSMutableArray array];
    
    CGRect tabBarFrame = self.tabBar.frame;
    
    self.customTabBarView = [[[UIView alloc] initWithFrame:tabBarFrame] autorelease];
    _customTabBarView.backgroundColor = [UIColor blackColor];
    _customTabBarView.tag = TAG_TABBAR;
    [self.view addSubview:_customTabBarView];
    
    UIImageView *bottom = [[UIImageView alloc] initWithFrame:CGRectMake(0, -12, 320, 66)];
    bottom.image = [UIImage imageNamed:@"player_green.png"];
    [_customTabBarView addSubview:bottom];
    
    float originX = 0;
    UIImage *image = nil;
    for (int i = 0; i < 4; i++) {
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *pic = [NSString stringWithFormat:@"tabBarItem_%d.png",i+1];
        image = [UIImage imageNamed:pic];
        bt.frame = CGRectMake(originX,0,image.size.width/2*2,image.size.height/2*2);
        [bt setImage:image forState:UIControlStateNormal];
        
        pic = [NSString stringWithFormat:@"tabBarItem_selected_%d.png",i+1];
        image = [UIImage imageNamed:pic];
        [bt setImage:image forState:UIControlStateSelected];
        bt.tag = TAG_BUTTON_ORIGIN + i;
        [bt addTarget:self action:@selector(tabChanged:) forControlEvents:UIControlEventTouchUpInside];
        [bt setExclusiveTouch:YES];
        [_tabBarItems addObject:bt];
        
        if (i == 0) 
            bt.selected = YES;
        [_customTabBarView addSubview:bt];
        originX += image.size.width/2*2;
        
        //调整位置
        switch (i) {
            case 0:
                [bt setImageEdgeInsets:UIEdgeInsetsMake(-13, 0, 0, 0)];
                break;
            case 1:
                [bt setImageEdgeInsets:UIEdgeInsetsMake(-5, 0, 0, 0)];
                break;
            case 2:
                [bt setImageEdgeInsets:UIEdgeInsetsMake(-5, 0, 0, 0)];
                break;          
            case 3:
                [bt setImageEdgeInsets:UIEdgeInsetsMake(-8.5, 0, 0, 0)];
                break;
            default:
                break;
        }
        
    }
    
}

-(void)tabChanged:(UIButton *)bt{
    
    UIView *tabBarView = [self.view viewWithTag:TAG_TABBAR];
    for (UIView *view in tabBarView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            
            UIButton *bt = (UIButton *)view;
            bt.selected = NO;
        }
    }
    bt.selected = YES;
    
    int currentIndex = bt.tag - TAG_BUTTON_ORIGIN;
    
	//RQD上报，点击TabBarItem
	switch (currentIndex) {
		case 0://首页
			[BTRQDReport reportUserAction:EventHomeTabClicked];
			break;
		case 1://故事分类
			[BTRQDReport reportUserAction:EventCategoryTabClicked];
			break;
		case 2://我的故事
			[BTRQDReport reportUserAction:EventMyStoriesTabClicked];
			break;
		case 3://更多
			[BTRQDReport reportUserAction:EventMoreTabClicked];
			break;
		default:
			break;
	}
	
    if (self.selectedIndex != currentIndex) {
        self.selectedIndex = bt.tag - TAG_BUTTON_ORIGIN;
    }else{
        UINavigationController *navTabCtr = [self.viewControllers objectAtIndex:currentIndex];
        [navTabCtr popToRootViewControllerAnimated:YES];
    }
    
    if (currentIndex == 2) {
        [BTUserDefaults setInteger:0 forKey:TABBAR_BADGE_VALUE];
        BTBadgeImageView *view = (BTBadgeImageView *)[bt viewWithTag:TAG_BADGE_ORIGIN + 2];
        [view removeFromSuperview];
    }
}

-(void)dealloc{
    [_tabBarItems release];
    [_customTabBarView release];
    [super dealloc];
}

@end
