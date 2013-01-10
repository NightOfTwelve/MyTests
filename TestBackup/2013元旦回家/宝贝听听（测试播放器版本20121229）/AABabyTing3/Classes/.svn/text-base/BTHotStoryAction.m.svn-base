//
//  BTHotStoryAction.m
//  AABabyTing3
//
//  Created by Neo Wang on 12-8-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTHotStoryAction.h"
#import "BTStory.h"
#import "BTHotStoryService.h"
//#import "BTDataManager.h"


@implementation BTHotStoryAction

- (id)initWithHomeID:(NSInteger)homeID lastID:(NSInteger)lastID rankId:(NSInteger)rankID{
    self = [super init];
    if(self){
		_rankID = rankID;
        _homeID = homeID;
        _lastID = lastID;
    }
    return self;
}

- (void)start{
    NSMutableDictionary *dic = [BTDataManager shareInstance].ranklistsDic;
    NSString *homeIDStr = [NSString stringWithFormat:@"%d",_homeID];
	NSMutableDictionary *lists = [dic valueForKey:homeIDStr];
	if (lists != nil) {
		NSString *rankIdStr = [NSString stringWithFormat:@"%d",_rankID];
		BTListInfo *ranklist = lists[rankIdStr];
		if (ranklist != nil) {//获取到对应ranklist
			NSInteger memoryCount = ranklist.countInDataManager;//本地内存中条目数
			NSInteger netCount = ranklist.countInNet;//服务器总计条目数
			if ((_actionType == defaultAction && memoryCount>0)
				|| (memoryCount >= netCount)) {
				//若：默认请求该页面，但内存中已有数据；
				//或服务器的数据都拉取到本地了
				//则：直接返回内存中数据
				if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withData:)]) {
					[_actionDelegate onAction:self withData:ranklist];
					return;
				}
			}
		} else {
			//断言
			if (_lastID != 0) {
				CELog(BTDFLAG_ALWAYS_PRINT,@"ERROR:_lastID != 0");
				_lastID = 0;
			}
		}
	}
	
	//发请求获取新数据
	_service = [[BTHotStoryService alloc] initWithHomeID:_homeID lastID:_lastID rankID:_rankID];
	_service.serviceDelegate = self;
	[_service sendServiceRequest];
}

- (void)receiveData:(NSDictionary *)data{
    [_service release];
    _service = nil;
    NSError *error = [super onError:data];
    if(error == nil){
        //从Service获得到的数据
        NSDictionary *response = [data dictionaryForKey:@"response"];
		if (response == nil) {
//			NSError *error = [NSError errorWithDomain:@"com.21kunpeng.service" code:9897 userInfo:nil];
//			if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withError:)]) {
//				[_actionDelegate onAction:self withError:error];
//			}
			return;
		}
		
		//获取服务器总数量
        NSInteger totalCount = [[response numberForKey:@"total"] integerValue];
        
        NSMutableArray *result = [super transformToStoryDataWithDic:data];
		
		NSMutableDictionary *dic = [BTDataManager shareInstance].ranklistsDic;
        NSString *key = [NSString stringWithFormat:@"%d",_homeID];
        NSMutableDictionary *lists = [dic valueForKey:key];
        if(!lists){
            lists = [NSMutableDictionary dictionary];
            [[BTDataManager shareInstance].ranklistsDic setValue:lists forKey:key];
        }
        
		
		if (lists != nil) {
			NSString *rankIdStr = [NSString stringWithFormat:@"%d",_rankID];
			BTListInfo *ranklist = lists[rankIdStr];
			if (ranklist != nil) {//获取到对应ranklist
				[ranklist.result addObjectsFromArray:result];
				ranklist.countInNet = totalCount;
			} else {
				CWLog(BTDFLAG_RANKLIST,@"ranklist == nil");
				NSString *rankIdStr = [NSString stringWithFormat:@"%d",_rankID];
				ranklist = [[BTListInfo alloc] init];
				ranklist.result = result;
				ranklist.countInNet = totalCount;
				lists[rankIdStr] = ranklist;
				[ranklist release];
				
				//CDLog(BTDFLAG_RANKLIST,@"ranklists:%@",[BTDataManager shareInstance].ranklists);
			}
			
            BTListInfo  *listinfo = [[[BTDataManager shareInstance].ranklistsDic objectForKey:key] valueForKey:[NSString stringWithFormat:@"%d",_rankID]];
            
			if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withData:)]) {
				[_actionDelegate onAction:self withData:listinfo];
				return;
			}
		} else {
			CELog(BTDFLAG_RANKLIST,@"error:lists[rankId] == nil");
		}
    }
}

@end
