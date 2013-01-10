//
//  BTStoryUpdateAction.h
//  AABabyTing3
//
//  Created by Tiny on 12-11-29.
//
//

#import <Foundation/Foundation.h>
#import "BTStoryUpdateService.h"
#import "BTBaseAction.h"

@interface BTStoryUpdateAction : BTBaseAction

@property (nonatomic ,retain) NSMutableArray *requestIds;
-(id)initWithRequestIds:(NSMutableArray *)ids;


@end
