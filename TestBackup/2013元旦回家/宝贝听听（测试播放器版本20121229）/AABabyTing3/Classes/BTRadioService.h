//
//  BTRadioService.h
//  AABabyTing3
//
//  Created by Wang Neo on 12-8-31.
//
//

#import <Foundation/Foundation.h>
#import "BTBaseService.h"

@interface BTRadioService : BTBaseService{
    NSInteger                   _homeID;
    NSInteger                   _lastID;
}


- (id)initWithHomeID:(NSInteger)homeID lastID:(NSInteger)lastID;

@end
