//
//  BTSearchAction.h
//  AABabyTing3
//
//  Created by Tiny on 12-9-20.
//
//

#import "BTBaseAction.h"

@interface BTSearchAction : BTBaseAction{
    NSString *_keyWord;
}

-(id)initWithKeyWord:(NSString *)word;

@end
