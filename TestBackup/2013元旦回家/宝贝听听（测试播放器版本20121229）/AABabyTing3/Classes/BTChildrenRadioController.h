//
//  BTChildrenRadioController.h
//  AABabyTing3
//
//  Created by Neo Wang on 12-8-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTListViewController.h"
#import "BTHomeData.h"

@interface BTChildrenRadioController : BTListViewController{
    NSInteger                   _homeID;
}

- (id)initWithHomeData:(NSInteger)dataID;

@end
