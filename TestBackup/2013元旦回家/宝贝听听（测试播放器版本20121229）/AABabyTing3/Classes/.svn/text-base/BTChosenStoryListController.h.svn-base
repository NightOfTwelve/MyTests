//
//  BTChosenStoryListController.h
//  AABabyTing3
//
//  Created by Neo Wang on 12-8-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTListViewController.h"
#import "BTStoryCell.h"
#import "BTBook.h"
#import "BTOneChosenCategoryInfoView.h"
#import "BTOneChosenHeaderAction.h"
#import "BTOneChosenListAction.h"
#import "BTOneChosenHeaderData.h"

@interface BTChosenStoryListController : BTListViewController<BTStoryCellDownLoadPressDelegate,BTOneChosenDownloadPress>{
    //BTBook                   *_bookInfo;
    BTOneChosenHeaderAction  *_headerAction;
    BTOneChosenListAction    *_listAction;
    BTOneChosenHeaderData    *_headerData;
    doubleActionState         _doubleActionState;
    NSInteger                 _chosenID;
    BOOL                      bIsAllStoriesDownload;
    UIView                   *_headerView;
}
@property (nonatomic,retain)BTOneChosenHeaderAction*     headerAction;
@property (nonatomic,retain)BTOneChosenListAction*      listAction;
@property (nonatomic,retain)BTOneChosenHeaderData*      headerData;

- (id)initWithChosenID:(NSInteger)chosenID;
@end
