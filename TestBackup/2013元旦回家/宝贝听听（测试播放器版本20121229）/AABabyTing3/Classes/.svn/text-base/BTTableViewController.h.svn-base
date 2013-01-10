//
//  BTTableViewController.h
//  AABabyTing3
//
//  Created by He baochen on 12-8-14.
//
//

#import <UIKit/UIKit.h>
#import "FXLabel.h"
#import "BTPlayerManager.h"
#import "BTAlertView.h"
#import "LoadMoreTableFooterView.h"
#import "BTNavButton.h"
#import "BTNavView.h"

#define TAG_Retry_Button  101
#define TAG_NONetWork_Button 102

#define TAG_Last_Cell     500
#define TAG_TitleView     600


#define TAG_First_Cell     100
#define TAG_Second_Cell    200
#define TAG_Third_Cell     300
#define TAG_Default_Cell   400

#define NOTIFICATION_EGG_VIEW_WILL_APPEAR @"notification_eggView"

@interface BTTableViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate,LoadMoreTableFooterDelegate,BTNavLabelPress>
{
	UITableView *_tableView;
	BOOL _clearsSelectionOnViewWillAppear;
	BOOL _reloading;
	LoadMoreTableFooterView *_loadMoreFooterView;
	FXLabel             *_viewTitle;
    BTNavButton            *_backButton;
    BTNavButton            *_playingButton;
     BOOL                  cellSelected;
}

@property(nonatomic,copy)		NSString		*titleStr;
@property(nonatomic, retain)	UITableView*	tableView;
@property(nonatomic)			BOOL			clearsSelectionOnViewWillAppear;
@property(nonatomic,assign)		FXLabel			*viewTitle;
@property(nonatomic,assign)		BTNavButton		*backButton;
@property(nonatomic,assign)		BTNavButton		*playingButton;

- (void)willAppearDid;
@end
