//
//  BTSearchService.h
//  AABabyTing3
//
//  Created by Tiny on 12-9-20.
//
//

#import <Foundation/Foundation.h>
#import "BTBaseService.h"

@interface BTSearchService : BTBaseService{
    
    NSString *_searchContent;
}

-(id)initWith:(NSString *)content;

@end
