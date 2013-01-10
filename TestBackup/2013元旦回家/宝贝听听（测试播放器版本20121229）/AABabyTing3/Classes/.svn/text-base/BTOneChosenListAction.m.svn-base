//
//  BTOneChosenList.m
//  AABabyTing3
//
//  Created by Neo Wang on 12-8-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTOneChosenListAction.h"
#import "BTStory.h"
#import "BTOneChosenListService.h"
@implementation BTOneChosenListAction




- (id)initWithChosenID:(NSInteger)chosenID lastId:(NSInteger)lastID len:(NSInteger)len  {
    self = [super init];
    if(self){
        _chosenID = chosenID;
        _lastID = lastID;
        _len = len;
    }
    return self;
}
- (void)start{
    NSString *chosenID = [NSString stringWithFormat:@"%d",_chosenID];
    NSMutableDictionary *dic = [BTDataManager shareInstance].oneChosenListDic;
    if([dic objectForKey:chosenID]&& _len == 0){
        if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withData:)]) {
            [_actionDelegate onAction:self withData:[dic objectForKey:chosenID]];
        }
    }else { 
        _service = [[BTOneChosenListService alloc] initWithBookId:_chosenID lastID:_lastID];
        _service.serviceDelegate = self;
        [_service sendServiceRequest];
    }
}

-(void)receiveData:(NSDictionary *)data{
    
    [_service release];
    _service = nil;
    NSError *error = [super onError:data];
//    DLog(@"data = %@",data);
    if(!error){
        NSDictionary *response = [data dictionaryForKey:@"response"];
        NSInteger totalCount = [[response numberForKey:@"total"] integerValue];
        //从Service获得到的数据
        NSMutableArray *result = [super transformToStoryDataWithDic:data];
        
        NSString * chosenKey= [NSString stringWithFormat:@"%d",_chosenID];
//        DLog(@"%@",[BTDataManager shareInstance].oneChosenListDic);
        
        BTListInfo *listInfo = [[BTDataManager shareInstance].oneChosenListDic objectForKey:chosenKey];
        if(!listInfo){
            BTListInfo *listInfo = [[BTListInfo alloc] init];
            listInfo.result = result;
            listInfo.countInNet = totalCount;
            [[BTDataManager shareInstance].oneChosenListDic setObject:listInfo forKey:chosenKey];
            [listInfo release];
        }else{
            [listInfo.result addObjectsFromArray:result];
            listInfo.countInNet = totalCount;
            [[BTDataManager shareInstance].oneChosenListDic setObject:listInfo forKey:chosenKey];
        }
        
        
        
        if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withData:)]) {
            [_actionDelegate onAction:self withData:[[BTDataManager shareInstance].oneChosenListDic objectForKey:chosenKey]];
        }
        //在自己的action处理不同的逻辑（数据存储和返回给上层controller）
    }
}
@end
