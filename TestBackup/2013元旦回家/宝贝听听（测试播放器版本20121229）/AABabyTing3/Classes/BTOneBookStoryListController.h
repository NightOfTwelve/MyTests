//
//  BTOneBookStoryListController.h
//  AABabyTing3
//
//  Created by Neo Wang on 12-8-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTListViewController.h"
#import "BTStoryCell.h"
#import "BTBook.h"
#import "BTCategoryCell.h"
#import "BTOneChosenCategoryInfoView.h"
#import "BTOneBookStoryListHeaderAction.h"
#import "BTBookAction.h"
#import "BTOneBookStoryListHeaderData.h"

@interface BTOneBookStoryListController : BTListViewController<BTStoryCellDownLoadPressDelegate,BTOneChosenDownloadPress>{
    BTOneBookStoryListHeaderData        *_dataInfo;
    BTOneBookStoryListHeaderAction      *_headerAction;
    BTBookAction                        *_bookAction;
    doubleActionState                   _doubleActionState;
    NSString                            *_albumid;
    BOOL                                bIsAllStoriesDownload;
    UIView                              *_headerView;
}
@property (nonatomic,retain)BTOneBookStoryListHeaderData           *dataInfo;
@property (nonatomic,retain)BTOneBookStoryListHeaderAction         *headerAction;
@property (nonatomic,retain)BTBookAction    *bookAction;
-(id)initWithAlbumidID:(NSString*)albumid;
@end
