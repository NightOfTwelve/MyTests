//
//  BTBannerView.h
//
//	运营栏
//
//  Created by Zero on 8/20/12.
//  Copyright (c) 2012 21kunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTBannerAction.h"
#import "BTOpenURLDelegate.h"
#import "BTBannerClickedStatisticsAction.h"

@class BTDataManager;

@interface BTBannerView : UIView
<UIScrollViewDelegate, BTBaseActionDelegate, BTBannerClickedDelegate>
- (id)initWithDelegate:(id<BTOpenURLDelegate>)delegate;
- (void)resetUI;
@end
