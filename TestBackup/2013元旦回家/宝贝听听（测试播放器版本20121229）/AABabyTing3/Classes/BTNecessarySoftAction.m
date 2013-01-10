//
//  BTNecessarySoftAction.m
//  AABabyTing3
//
//  Created by Tiny on 12-9-29.
//
//

#import "BTNecessarySoftAction.h"
#import "BTNecessarySoftwareService.h"

@implementation BTNecessarySoftAction

-(id)initWithSoftData:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        softData = dic;
    }
    return self;
}

-(void)start{
    _service = [[BTNecessarySoftwareService alloc] initWithData:softData];
    _service.serviceDelegate = self;
    [_service sendServiceRequest];
}

@end
