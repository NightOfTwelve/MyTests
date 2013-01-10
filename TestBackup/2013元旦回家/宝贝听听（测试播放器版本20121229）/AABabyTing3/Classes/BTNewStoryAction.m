//
//  BTNewStoryAction.m
//  AABabyTing3
//
//  Created by Neo Wang on 12-8-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTNewStoryAction.h"
#import "BTStory.h"
#import "BTNewStoryInfo.h"
#import "BTNewStoryService.h"

@implementation BTNewStoryAction

- (id)initWithListId:(NSInteger)listID visibleLen:(NSInteger)len lastID:(NSInteger)lastID{
    self= [super init];
    if(self){
        _lastID = lastID;
        _listID = listID;
        _len = len;
    }
    return self;
}

- (void)start{
    NSMutableDictionary *lastestDicInfo = [BTDataManager shareInstance].lastestDicInfo;
    NSString *homeIDStr = [NSString stringWithFormat:@"%d",_listID];
    BTListInfo *lastestInfo = [lastestDicInfo valueForKey:homeIDStr];
    if([lastestInfo.result count]>0&&_len ==0){
        if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withData:)]) {
            [_actionDelegate onAction:self withData:lastestInfo];
        }
    }else {
        _service = [[BTNewStoryService alloc] initWithListID:_listID lastID:_lastID];
        _service.serviceDelegate = self;
        [_service sendServiceRequest];
    }
}


- (void)receiveData:(NSDictionary *)data{
    [_service release];
    _service = nil;
    NSError *error = [super onError:data];
    if(!error){
        //从Service获得到的数据
        
        NSDictionary *response = [data dictionaryForKey:@"response"];
        NSInteger totalCount = [[response numberForKey:@"total"] integerValue];
        NSMutableArray *result = [super transformToStoryDataWithDic:data];
        //[BTDataManager shareInstance].lastestStoryArray = result;
        
        NSMutableDictionary *lastestDicInfo = [BTDataManager shareInstance].lastestDicInfo;
        NSString *key = [NSString stringWithFormat:@"%d",_listID];
        BTListInfo *lastestInfo = [lastestDicInfo valueForKey:key];
        
        if(!lastestInfo){
            BTListInfo *listInfo = [[BTListInfo alloc] init];
            listInfo.result = result;
            listInfo.countInNet = totalCount;
            [[BTDataManager shareInstance].lastestDicInfo setValue:listInfo forKey:key];
            [listInfo release];
        }else{
            [lastestInfo.result addObjectsFromArray:result];
            lastestInfo.countInNet = totalCount;
            [[BTDataManager shareInstance].lastestDicInfo setValue:lastestInfo forKey:key];
        }
        
        
        
        
        
        
//        BTListInfo *dataMangerInfo = [BTDataManager shareInstance].lastestArrayInfo;
//        [dataMangerInfo.result addObjectsFromArray:result];
//        dataMangerInfo.countInNet = totalCount;
        //[BTDataManager shareInstance].radioArrayInfo = dataMangerInfo;
        
        if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withData:)]) {
            [_actionDelegate onAction:self withData:[[BTDataManager shareInstance].lastestDicInfo valueForKey:key]];
        }
        //在自己的action处理不同的逻辑（数据存储和返回给上层controller）
    }

}

- (void)mayRunInOtherThread:(id)data{
//    DLog(@"%s thread main = %d",__FUNCTION__, [NSThread isMainThread]);
    [NSThread sleepForTimeInterval:testWaitingTime];
    
    [self performSelectorOnMainThread:@selector(didFinishInOtherThread:) withObject:nil waitUntilDone:YES];
}

- (void)didFinishInOtherThread:(id)data{
    int r = abs(rand()) % 2;
//    DLog(@"%s r = %d",__FUNCTION__,r);
    if (r == 0) { //正常
        NSMutableDictionary *newStoryResult = [[NSMutableDictionary alloc] init];
        BTNewStoryInfo *newstoryInfo = [[BTNewStoryInfo alloc] init];
        newstoryInfo.collectionTitle = @"宝贝听听";
        newstoryInfo.collectionIconURL = @"http://www.apple.com.cn/hotnews/promos/images/promo_mountainlion.jpg";
        newstoryInfo.collectionDes =@"《青蛙罗飞飞》同步首发，培养孩子养成好的习惯培养孩子养成好的习惯培养孩子养成好的习惯培养孩子养成好的习惯培养孩子养成好的习惯    ";
        newstoryInfo.onlineDate = @"2012-7-20";
        [newStoryResult setObject:newstoryInfo forKey:@"info"];
        [newstoryInfo release];
        NSMutableArray *newStoryList = [[NSMutableArray alloc] init];
        BTStory *story = nil;
        for (int i = 0; i < 12; i++) {
            story = [[BTStory alloc] init];
            story.title = [NSString stringWithFormat:@"第%d个新的故事",i];
//            story.iconURL = nil;
            story.speakerName = @"王京";
            story.categoryName = @"《罗飞飞》";
            story.timeLength = @"03:03";
//            story.picDownLoadURLs = @"http://www.apple.com.cn/hotnews/promos/images/promo_mountainlion.jpg";
            story.bIsInLocal = NO;
            [newStoryList addObject:story];
            [story release];
        }
        [newStoryResult setObject:newStoryList forKey:@"ArrayList"];
        
       // [BTDataManager shareInstance].lastestStoryArray = newStoryList;
        if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withData:)]) {
            [_actionDelegate onAction:self withData:newStoryResult];
        }
        [newStoryResult release];
    }
    else { //2,3,4各种错误
        NSError *error = [NSError errorWithDomain:@"newStoryAction" code:r userInfo:nil];
        if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withError:)]) {
            [_actionDelegate onAction:self withError:error];
        }
    }
}

@end
