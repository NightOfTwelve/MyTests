//
//  BTCategoryListController.h
//  AABabyTing3
//
//  Created by Neo Wang on 12-8-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTListViewController.h"
#import "LoadMoreTableFooterView.h"
#import "BTSearchView.h"

@interface BTCategoryListController : BTListViewController<LoadMoreTableFooterDelegate,searchDelegate,UIGestureRecognizerDelegate>{
    NSString  *_historyRecord;
    UIView    *_maskView;
}

@end
