//
//  BTMoreController.h
//  BabyTingUpgraded
//
//  Created by  on 12-8-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTListViewController.h"
#import "BTMoreData.h"
#import "BTCacheCleanController.h"
@interface BTMoreController : BTListViewController{

    BTMoreData          *_moreData;
    NSMutableArray      *_moreItemArray;
    NSString            *_updateUrl;

}

@end
