//
//  BTTabBarController.m
//  BabyTingIntense
//
//  Created by  on 12-8-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTTabBarController.h"
#import <QuartzCore/QuartzCore.h>

#define TAG_TAB_IMAGEVIEW_BEGIN                 10
#define kTabSelectionAnimationDuration          0.3


@interface UITabBar (Custom)


@end

@implementation UITabBar (Custom)

-(void)drawRect:(CGRect)rect
{
	self.frame = CGRectMake(0,WINDOW_HEIGHT - 45,320, 45);
	UIView * superView = [self superview];
	for (UIView * v in superView.subviews) {
		//MLOG(@"%@",v);
		if ([[v description] hasPrefix:@"<UITransitionView"]) {
			CGRect f = v.frame ;
			f.size.height = self.frame.origin.y;
			v.frame = f;
		}
	}
}

@end

@implementation BTTabBarController

-(id)init
{
	if(self = [super init])
	{
		self.tabBar.backgroundColor =[UIColor grayColor];
        
        m_tabImageViews = [[NSMutableArray alloc] initWithCapacity:0];
		selectionView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.tabBar.frame.size.height - 14, 0, 9)];
		selectionView.image  = nil;
	}
	return self;
}

- (void)dealloc {
    
    [m_tabImageViews release];
    [super dealloc];
}

-(void)setViewControllers:(NSArray*)viewControllers animated:(BOOL)animated
{
	[super setViewControllers:viewControllers animated:animated];
	UIImage* _image = [UIImage imageNamed:@"tabBar_bg"];
    
    UIImageView *tabBarBg = [[UIImageView alloc]initWithImage:_image];
    tabBarBg.frame = CGRectMake(0, -17, 320, 66);
    [self.tabBar addSubview:tabBarBg];
	self.tabBar.clipsToBounds = NO;
    
    [tabBarBg release];
	self.tabBar.backgroundColor = [UIColor redColor];
	
    for (UIView *view in m_tabImageViews) {
        [view removeFromSuperview];
    }
    [m_tabImageViews removeAllObjects];
    
    if ([viewControllers count] <= 0) {
        return;
    }
    
	
    CGFloat width = self.tabBar.frame.size.width/[viewControllers count];
    CGRect rc = CGRectMake(0, 0, width, 45);
    for (int i=0; i<[viewControllers count]; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:rc];
        imageView.tag = TAG_TAB_IMAGEVIEW_BEGIN + i;
        imageView.contentMode = UIViewContentModeCenter;
        [self.tabBar addSubview:imageView];
		self.tabBar.backgroundColor  = [UIColor clearColor];
        [m_tabImageViews addObject:imageView];
        [imageView release];
        rc.origin.x += width;
    }
	self.selectedIndex = 0;
	CGRect f = selectionView.frame;
	f.size.width = width;
	f.origin.x = self.selectedIndex * width;
	selectionView.frame = f;
	//DLog(@"selectionView frame: %@ ",NSStringFromCGRect(f));
	[self.tabBar insertSubview:selectionView aboveSubview:tabBarBg];
}


- (void)resetAllTabs {
    
    for (int index=0; index<[m_tabImageViews count]; index++) {
        UIImageView *imageView = [m_tabImageViews objectAtIndex:index];
        
        if (index < [self.viewControllers count]) {
            UIViewController *controller = [self.viewControllers objectAtIndex:index];
            BTTabBarItem *item = (id)controller.tabBarItem;
            imageView.image = item.normalImage;
        }
    }
}

- (void)animateSelectionToItemAtIndex:(NSUInteger)itemIndex;
{
	CGRect f = selectionView.frame;
	
	f.origin.x = self.selectedIndex * f.size.width;
	
	
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:(CGRectIsEmpty(selectionView.frame) ? 0. : kTabSelectionAnimationDuration)];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    selectionView.frame = f;
    [UIView commitAnimations];
}

- (void)unHighlightTabAtIndex:(NSInteger)index {
    
    if (index < [m_tabImageViews count]) {
        UIImageView *imageView = [m_tabImageViews objectAtIndex:index];
        
        if (index < [self.viewControllers count]) {
            UIViewController *controller = [self.viewControllers objectAtIndex:index];
            BTTabBarItem *item = (id)controller.tabBarItem;
            imageView.image = item.normalImage;
        }
    }
}


- (void)highlightTabAtIndex:(NSInteger)index {
    
    if (index < [m_tabImageViews count]) {
        UIImageView *imageView = [m_tabImageViews objectAtIndex:index];
        
        if (index < [self.viewControllers count]) {
            UIViewController *controller = [self.viewControllers objectAtIndex:index];
            BTTabBarItem *item = (id)controller.tabBarItem;
            imageView.image = item.customHighlightedImage;
			[self animateSelectionToItemAtIndex:index];
        }
    }
}

@end
