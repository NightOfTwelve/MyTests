//
//  BTHotStoryListController.h
//  AABabyTing3
//
//  Created by Neo Wang on 12-8-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTListViewController.h"
#import "BTHotStoryCell.h"
#import "BTHomeData.h"
#import "BTPopoverContentViewController.h"
#import "WEPopoverController.h"

@interface BTHotStoryListController : BTListViewController<BTHotCellDownloadPressDelegate,BTPopoverContentViewControllerDelegate,WEPopoverControllerDelegate>
{
    NSInteger                       _homeID;
}

@property (nonatomic, assign) BOOL arrowDirectionUp;//三角箭头是否向上
- (id)initWithHomeData:(NSInteger)dataID;
@end
