//
//  BTBookAction.m
//  cid = 305.故事列表第三个TabView。
//
//  Created by Neo Wang on 12-8-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

// ============================================================
// ** Import **
// ============================================================
#import "BTBookAction.h"
#import "BTStory.h"
#import "BTBook.h"
#import "BTOneBookStoryListService.h"

// ============================================================
// ** BTBookAction **
// ============================================================
@implementation BTBookAction
// ============================================================
// ** 初始化 **
// ============================================================
/**
 * 初始化
 */
- (id)initWithBookID:(NSInteger)bookID LastID:(NSInteger)lastID Len:(NSInteger)len{
    self = [super init];
    if(self){
        _len= len;
        _bookID = bookID;
        _lastID = lastID;
    }
    return self;
}

/**
 * 发送网络请求
 */

//NSString *categoryID = [NSString stringWithFormat:@"%d",_categotyID];
//NSString *key = [categoryID stringByAppendingString:_type];
//NSMutableDictionary *dic = [BTDataManager shareInstance].bookListDic;
//BTListInfo *info = [dic objectForKey:key];
//if([info.result count] >0 && _len== 0){
//    if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withData:)]) {
//        [_actionDelegate onAction:self withData:[dic objectForKey:categoryID]];
//    }
//}



- (void)start{
    NSString *bookID = [NSString stringWithFormat:@"%d",_bookID];
    NSMutableDictionary *dic = [BTDataManager shareInstance].bookStoryDic;
    BTListInfo *info = [dic objectForKey:bookID];
    if ([info.result count]>0 && _len == 0) {
        if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withData:)]) {
            [_actionDelegate onAction:self withData:[dic objectForKey:bookID] ];
        }
    }else {
        _service = [[BTOneBookStoryListService alloc] initWithAlbumidId:[NSString stringWithFormat:@"%d",_bookID]lastID:_lastID];
        _service.serviceDelegate = self;
        [_service sendServiceRequest];
    }
}

/**
 * 获取网络下载数据
 */
- (void)receiveData:(NSDictionary *)data{
    [_service release];
    _service = nil;
    NSError *error = [super onError:data];
    if(!error){
        //从Service获得到的数据
        NSDictionary * responseData = data;
        //DLog(@"%@",responseData);
        NSDictionary *response = [responseData dictionaryForKey:@"response"];
        NSInteger totalCount = [[response numberForKey:@"total"] integerValue];
        //NSMutableArray *bookResult = [[NSMutableArray alloc] initWithCapacity:16];
        NSMutableArray *bookResult = [super transformToStoryDataWithDic:responseData];
        NSString *bookID = [NSString stringWithFormat:@"%d",_bookID];
        BTListInfo *listInfo = [[BTDataManager shareInstance].bookStoryDic objectForKey:bookID];
        if(!listInfo){
            BTListInfo *listInfo = [[BTListInfo alloc] init];
            listInfo.result = bookResult;
            listInfo.countInNet = totalCount;
            [[BTDataManager shareInstance].bookStoryDic setObject:listInfo forKey:bookID];
            [listInfo release];
        }else{
            [listInfo.result addObjectsFromArray:bookResult];
            listInfo.countInNet = totalCount;
            [[BTDataManager shareInstance].bookStoryDic setObject:listInfo forKey:bookID];
        } 
        if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withData:)]) {
            [_actionDelegate onAction:self withData:[[BTDataManager shareInstance].bookStoryDic objectForKey:bookID]];
        }
        //在自己的action处理不同的逻辑（数据存储和返回给上层controller）
    }
    
}

// ============================================================
// ** 析构 **
// ============================================================
/**
 *  析构
 */
-(void)dealloc{
    [super dealloc];
}
@end

//todo delete
//- (void)mayRunInOtherThread:(id)data{
//    [NSThread sleepForTimeInterval:testWaitingTime];
//    
//    [self performSelectorOnMainThread:@selector(didFinishInOtherThread:) withObject:nil waitUntilDone:YES];
//}
//
//- (void)didFinishInOtherThread:(id)data{
//    int r = abs(rand()) % 3;
//    if (r == 0) { //正常
//        NSMutableArray *bookStoryResult = [[NSMutableArray alloc] init];
//        BTStory *story = nil;
//        for (int i = 0; i < 12; i++) {
//            story = [[BTStory alloc] init];
//            story.title = [NSString stringWithFormat:@"第%d个新的故事",i];
//            story.iconURL = nil;
//            story.speakerName = @"王京";
//            story.categoryName = @"《罗飞飞》";
//            story.timeLength = @"03:03";
//            story.picDownLoadURL = @"http://www.apple.com.cn/hotnews/promos/images/promo_mountainlion.jpg";
//            story.bIsInLocal = NO;
//            [bookStoryResult addObject:story];
//            [story release];
//        }
//        [[BTDataManager shareInstance].bookStoryDic setValue:bookStoryResult forKey:[NSString stringWithFormat:@"%d",_bookID]];
//        
//        DLog(@"%@",[[BTDataManager shareInstance].bookStoryDic allKeys]);
//        if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withData:)]) {
//            [_actionDelegate onAction:self withData:bookStoryResult];
//        }
//        [bookStoryResult release];
//    }
//    else { //2,3,4各种错误
//        NSError *error = [NSError errorWithDomain:@"hotStoryAction" code:r userInfo:nil];
//        if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withError:)]) {
//            [_actionDelegate onAction:self withError:error];
//        }
//    }
//}
