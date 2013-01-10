//
//  BTWellChosenListController.h
//  AABabyTing3
//
//  Created by Neo Wang on 12-8-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTListViewController.h"
#import "BTHomeData.h"

@interface BTWellChosenListController : BTListViewController{
    NSInteger                   _homeId;
}


- (id)initWithHomeData:(NSInteger)DataID;
@end
