//
//  BTCategoryAction.h
//  303
//
//  Created by Neo Wang on 12-8-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

// ============================================================
// ** Import **
// ============================================================
#import "BTBaseAction.h"

// ============================================================
// ** BTCategoryAction **
// ============================================================
@interface BTCategoryAction : BTBaseAction{
    NSInteger                   _lastID;
    NSInteger                   _len;
}


- (id)initWithLastID:(NSInteger)lastID len:(NSInteger)len;
@end