//
//  BTOneRadioAction.m
//  AABabyTing3
//
//  Created by Wang Neo on 12-9-3.
//
//

#import "BTOneRadioAction.h"
#import "BTOneRadioStoryListService.h"

@implementation BTOneRadioAction

- (id)initWithRadioID:(NSInteger)radioID history:(NSArray *)history requestCount:(NSInteger)count{
    self = [super init];
    if(self){
        _radioID = radioID;
        _historyArray = [history retain];
        _requestCount = count;
    }
    return self;
}
- (void)setRadioInfo:(NSInteger)radioID history:(NSArray *)history requestCount:(NSInteger)count {
    _radioID = radioID;
    [_historyArray release];
    _historyArray = [history retain];
    _requestCount = count;
}

- (void)start{
    _service = [[BTOneRadioStoryListService alloc] initWithRadioID:_radioID history:_historyArray requestCount:_requestCount];
    _service.serviceDelegate = self;
    [_service sendServiceRequest];
}

- (void)receiveData:(NSDictionary *)data{
    [_service release];
    _service = nil;
    NSError *error = [super onError:data];
    if(!error){
        NSDictionary * responseData = [NSDictionary dictionaryWithDictionary:data];
        NSArray *arr =  [super transformToStoryDataWithDic:responseData];
        DoLog(@"%d",[arr count]);
        if(_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withData:)]){
            [_actionDelegate onAction:self withData:arr];
        }
    }
}

- (void)dealloc{
    [_historyArray release];
    
    [_service release];
    _service = nil;
    [super dealloc];
}
@end
