//
//  BTTabBarController.h
//  BabyTingIntense
//
//  Created by  on 12-8-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTTabBarItem.h"

@interface BTTabBarController : UITabBarController{
    
	UIImageView					*selectionView;
    NSMutableArray              *m_tabImageViews;
}

- (void)resetAllTabs;
- (void)unHighlightTabAtIndex:(NSInteger)index;
- (void)highlightTabAtIndex:(NSInteger)index;

@end
