//
//  BTMystoriesController.h
//  BabyTingUpgraded
//
//  Created by  on 12-8-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTListViewController.h"
#import "WEPopoverController.h"
#import "BTLocalSortViewController.h"
#import "BTStoryUpdateAction.h"

@interface BTMystoriesController : BTListViewController<BTStroyProgressDelegate,WEPopoverControllerDelegate,BTLocalSortViewControllerDelegate,BTBaseActionDelegate> {
    NSMutableArray *_downloadList;
    NSMutableArray *_localList;
    int  localStoryCount;
    BTNavButton *_editButton;
    BOOL bIsEditing;
    UIButton *_sortButton;
    WEPopoverController *_popc;
    int _selectedSortIndex;
    BOOL _arrowDirectionUp;
    UIImageView *_arrowImageView;
    BTStoryUpdateAction *_storyUpdateAction;
    NSMutableArray *_sortRequestIds;                                //版本覆盖时，需要请求排序字段的故事id数组
}

@property (nonatomic,retain)BTNavButton *editButton;
@property (nonatomic,retain)UIButton *sortButton;
@property (nonatomic,retain)WEPopoverController *popc;
@property (nonatomic,assign)int selectedSortIndex;
@property (nonatomic,assign) BOOL arrowDirectionUp;
@property (nonatomic,retain) UIImageView *arrowImageView;
@property (nonatomic,retain) BTStoryUpdateAction *storyUpdateAction;
@property (nonatomic,retain) NSMutableArray *sortRequestIds;
@end
