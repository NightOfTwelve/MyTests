//
//  BTListViewController.h
//  AABabyTing3
//
//  Created by He baochen on 12-8-14.
//
//

#import "BTTableViewController.h"
#import "BTBaseAction.h"
#import "Only320Network.h"
#import "MBProgressHUD.h"
#import "BTRopeView.h"
#import "BTAppDelegate.h"
#import "BTListInfo.h"

//@class BTHomePageController;
//@class BTMystoriesController;
//@class BTCategoriesController;

typedef enum  {
    ACTION_NOT_BEGIN = 0,
    ACTION_SENDING,
    ACTION_REQUESTFINISH,
    ACTION_REQUESTERROR,
    ACTION_NOTNEED,
} ActionState;

typedef enum  {
    noRequest = 999,
    oneRequest,
    twoRequest,
} doubleActionState;


@interface BTListViewController : BTTableViewController<BTBaseActionDelegate,MBProgressHUDDelegate,UIAlertViewDelegate,UIScrollViewDelegate,allDownloadDelegate> {
    NSMutableArray      * _itemArray;
    NSMutableDictionary * _itemDictionary;
    BTBaseAction        * _baseAction;
    //BOOL                _bIsActionComplete;      //用来判断当前controller是push出现的还是pop出现的
    ActionState          actionState;
    MBProgressHUD       *_waitingHUB;
    BTRopeView          *_ropeView;
    //CGFloat               _scrollDistance;
    CGFloat               _lastScrollOffsetY;
    CGFloat               _ropeViewHeight;
    NSInteger             _countInNet;
   
}

@property(nonatomic,retain)NSMutableArray* itemArray;
@property(nonatomic,retain)NSMutableDictionary* itemDictionary;
@property(nonatomic,retain)BTBaseAction * action;
@property(nonatomic,retain)MBProgressHUD * waitingHUB;
@property(assign)NSInteger countInNet;


- (void) releaseAction;
- (void) initChildUI;
- (void)doneLoadingTableViewData;
- (void)reloadTableViewDataSource;
- (void)doCell:(UITableViewCell *)cell;
- (void)checkAllDownLoadButtonEnable;
- (void)showDownloadProgressAlert;
- (void)requestNullData;
@end
