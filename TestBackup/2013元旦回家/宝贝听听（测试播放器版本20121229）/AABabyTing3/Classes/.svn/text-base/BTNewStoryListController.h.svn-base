//
//  BTNewStoryListController.h
//  AABabyTing3
//
//  Created by Neo Wang on 12-8-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTListViewController.h"
#import "BTStoryCell.h"
#import "BTNewStoryInfo.h"
#import "BTNewStoryInfoView.h"
#import "BTNewStoryAction.h"
#import "BTNewStoryHeaderAction.h"
#import "BTHomeData.h"


@interface BTNewStoryListController : BTListViewController<BTStoryCellDownLoadPressDelegate,BTNewStoryAllDownloadDelegate>{
    BTNewStoryInfo            *_listInfo;
    BTNewStoryHeaderAction    *_headerAction;
    BTNewStoryAction          *_lastestStoryAction;
    doubleActionState         _doubleActionState;
    NSInteger                 _homeID;
    BOOL                      bIsAllStoriesDownload;
    UIView                    *_headerView;
}

@property (nonatomic,retain)BTNewStoryInfo            *listInfo;
@property (nonatomic,retain)BTNewStoryAction          *lastestStoryAction;
@property (nonatomic,retain)BTNewStoryHeaderAction    *headerAction;


- (id)initWithHomeData:(NSInteger)dataID;
@end
