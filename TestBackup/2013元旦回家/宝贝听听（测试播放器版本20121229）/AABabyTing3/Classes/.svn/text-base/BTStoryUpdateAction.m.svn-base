//
//  BTStoryUpdateAction.m
//  AABabyTing3
//
//  Created by Tiny on 12-11-29.
//
//

#import "BTStoryUpdateAction.h"

@implementation BTStoryUpdateAction
@synthesize requestIds;

-(id)initWithRequestIds:(NSMutableArray *)ids{
    
    self = [super init];
    if (self) {
        self.requestIds = ids;
    }
    return self;
}

-(void)start{
    
    _service = [[BTStoryUpdateService alloc] initWithStoryIds:self.requestIds];
    _service.serviceDelegate = self;
    [_service sendServiceRequest];
}

-(void)receiveData:(NSDictionary *)data{
    [data retain];
    [_service release];
    _service = nil;
    NSError *error = [super onError:data];
    CDLog(BTDFLAG_LOCAL_SORT,@"315response = %@",data);
    if(!error){
        NSMutableArray *foundIds = [super transformToStoryDataWithDic:data];
        NSDictionary *responseDic = [data dictionaryForKey:@"response"];
        NSMutableArray *notFoundIds = [responseDic objectForKey:@"notfound"];
        
        //返回的故事信息
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:foundIds forKey:@"foundIds"];
        [dic setValue:notFoundIds forKey:@"notFoundIds"];
        
        if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withData:)]) {
            [_actionDelegate onAction:self withData:dic];
        }
        
    }
    [data release];
}

-(void)dealloc{
    [requestIds release];
    [super dealloc];
}

@end
