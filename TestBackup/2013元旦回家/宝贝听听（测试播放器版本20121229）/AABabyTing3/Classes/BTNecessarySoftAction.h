//
//  BTNecessarySoftAction.h
//  AABabyTing3
//
//  Created by Tiny on 12-9-29.
//
//

#import "BTBaseAction.h"

@interface BTNecessarySoftAction : BTBaseAction{
    
    NSDictionary *softData;
}

-(id)initWithSoftData:(NSDictionary *)dic;

@end
