//
//  BTSearchAction.m
//  AABabyTing3
//
//  Created by Tiny on 12-9-20.
//
//

#import "BTSearchAction.h"
#import "BTSearchService.h"
#import "BTDebug.h"

@implementation BTSearchAction

-(id)initWithKeyWord:(NSString *)word{
    self = [super init];
    if (self) {
        _keyWord = word;
    }
    return self;
}

-(void)start{
    _service = [[BTSearchService alloc] initWith:_keyWord];
    _service.serviceDelegate = self;
    [_service sendServiceRequest];
}

-(void)receiveData:(NSDictionary *)data{
    [_service release];
    _service = nil;
    NSError *error = [super onError:data];
    if(!error){
        NSInteger totalCount = [[data numberForKey:@"total"] integerValue];
        NSMutableArray *result = [super transformToStoryDataWithDic:data];
        BTListInfo *passInfo = [[BTListInfo alloc] init];
        [passInfo.result addObjectsFromArray:result];
        passInfo.countInNet = totalCount;
        if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withData:)]) {
            [_actionDelegate onAction:self withData:passInfo];
        }
        [passInfo release];
    }
    
}


@end
