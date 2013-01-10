//
//  BTBookListAction.m
//  cid = 304.故事列表第二个TabView相关。
//
//  Created by Neo Wang on 12-8-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

// ============================================================
// ** Import **
// ============================================================
#import "BTBookListAction.h"
#import "BTBook.h"
#import "BTConstant.h"
// ============================================================
// ** BTBookListAction **
// ============================================================

@implementation BTBookListAction
// ============================================================
// ** 初始化 **
// ============================================================
/**
 * 初始化
 */
- (id)initWithCategoryID:(NSInteger)categoryID type:(NSString *)type len:(NSInteger)len lastId:(NSInteger       )lastID{
    self = [super init];
    if(self){
        _categotyID = categoryID;
        _type = [type retain];
        _len = len;
        _lastID = lastID;
    }
    return self;
}

- (void)dealloc{
    [_type release];
    [super dealloc];
}

/**
 * 发送网络请求
 */
- (void)start{
    NSString *categoryID = [NSString stringWithFormat:@"%d",_categotyID];
    NSString *key = [categoryID stringByAppendingString:_type];
    NSMutableDictionary *dic = [BTDataManager shareInstance].bookListDic;
    BTListInfo *info = [dic objectForKey:key];
    if([info.result count] >0 && _len== 0){
        if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withData:)]) {
            [_actionDelegate onAction:self withData:[dic objectForKey:key]];
        }
    }else {
       // [self performSelectorInBackground:@selector(mayRunInOtherThread:) withObject:nil];
        _service = [[BTBookListService alloc] initWithCategoryId:[NSString stringWithFormat:@"%d",_categotyID] type:_type lastID:_lastID];
        _service.serviceDelegate = self;
        [_service sendServiceRequest];
    }
}

/**
 *  获得网络请求数据
 */
- (void)receiveData:(NSDictionary *)data{
    [_service release];
    _service = nil;
    NSError *error = [super onError:data];
    if(!error){
        //从Service获得到的数据
        NSDictionary * responseData = data;
        //DLog(@"%@",responseData);
        NSString *domain = [responseData stringForKey:@"domain"];
        NSDictionary *response = [responseData dictionaryForKey:@"response"];
        NSInteger totalCount = [[response numberForKey:@"total"] integerValue];
        NSArray *itemList = [response arrayForKey:@"itemlist"];
        NSMutableArray *bookResult = [[NSMutableArray alloc] init];
        BTBook *bookData = nil;
        NSMutableDictionary *localDic = [[NSMutableDictionary alloc]initWithContentsOfFile:[BTUtilityClass fileWithPath:BOOK_FILE_NAME]];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        int createTime = 0;
        id check = [ud objectForKey:CREATESTAMP];
        if (check) {
            createTime = [[ud objectForKey:CREATESTAMP] intValue];
        }
        for(int i = 0 ; i < [itemList count] ; i++){
            NSDictionary *itemInfo = [itemList objectAtIndex:i];
            bookData = [[BTBook alloc] init];
            bookData.title = [NSString stringWithFormat:@"%@",[itemInfo stringForKey:@"name"]];
            bookData.desc =  [NSString stringWithFormat:@"%@",[itemInfo stringForKey:@"desc"]];
            //bookData.onlineDate = [NSString stringWithFormat:@"%@",[itemInfo objectForKey:@"onlineday"]];
            bookData.bookID = [NSString stringWithFormat:@"%@",[itemInfo numberForKey:@"id"]];
            bookData.storyCount = [[NSString stringWithFormat:@"%@",[itemInfo numberForKey:@"size"]]intValue];
            //[keyArr insertObject:bookData.bookID atIndex:i];
            if([[itemInfo stringForKey:@"logourl"] length]>0){
                bookData.iconURL = [BTUtilityClass getUrlWithDomain:domain encryptionString:[itemInfo stringForKey:@"logourl"] resourceId:[NSString stringWithFormat:@"%@.png",bookData.bookID]];
                //bookData.iconURL = nil;
            }
            
            bookData.picVersion = [[itemInfo numberForKey:@"picversion"] integerValue];

            NSString *upTimeFromNet = [NSString stringWithFormat:@"%@",[itemInfo numberForKey:@"uptime"]];
            NSString *upTimeFromLocal = [[localDic objectForKey:bookData.bookID] objectForKey:KEY_BOOK_UPDATETIME];
            BOOL flag = [[[localDic objectForKey:bookData.bookID] objectForKey:KEY_BOOK_SHOWNEWFLAG] boolValue];
//            upTimeFromNet = [NSString stringWithFormat:@"%d",1500000000+arc4random()%5];          //测试代码
            if(![upTimeFromNet isEqualToString:upTimeFromLocal] && upTimeFromNet != nil)
            {
                NSMutableDictionary *redic = [NSMutableDictionary dictionary];
                [redic setValue:upTimeFromNet forKey:KEY_BOOK_UPDATETIME];
                int upTimeValue = [[itemInfo numberForKey:@"uptime"] intValue];
//                int upTimeValue = [upTimeFromNet intValue];                                       //测试代码
                if (upTimeValue > createTime) {
                    [redic setValue:[NSNumber numberWithBool:YES] forKey:KEY_BOOK_SHOWNEWFLAG];
                    bookData.isNew = YES;
                } else {
                    [redic setValue:[NSNumber numberWithBool:NO] forKey:KEY_BOOK_SHOWNEWFLAG];
                    bookData.isNew = NO;
                }
                [localDic setValue:redic forKey:bookData.bookID];
            } else if(flag) {
                bookData.isNew = YES;
            }
            
            
            [bookResult addObject:bookData];
            [bookData release];
        }
        [localDic writeToFile:[BTUtilityClass fileWithPath:BOOK_FILE_NAME] atomically:YES];
        [localDic release];
        
        
        
        NSString *categoryID = [NSString stringWithFormat:@"%d",_categotyID];
        NSString *key = [categoryID stringByAppendingString:_type];
        BTListInfo *listInfo = [[BTDataManager shareInstance].bookListDic objectForKey:key];
        if(!listInfo){
            BTListInfo *listInfo = [[BTListInfo alloc] init];
            listInfo.result = bookResult;
            listInfo.countInNet = totalCount;
            [[BTDataManager shareInstance].bookListDic setObject:listInfo forKey:key];
            [listInfo release];
        }else{
            [listInfo.result addObjectsFromArray:bookResult];
            listInfo.countInNet = totalCount;
            [[BTDataManager shareInstance].bookListDic setObject:listInfo forKey:key];
        }


        

        //转给controller处理
        if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withData:)]) {
            [_actionDelegate onAction:self withData:[[BTDataManager shareInstance].bookListDic objectForKey:key]];
        }
        [bookResult release];
        
        
        
    }
}

@end
//Todo delete
//- (void)mayRunInOtherThread:(id)data{
//    DLog(@"%s thread main = %d",__FUNCTION__, [NSThread isMainThread]);
//    [NSThread sleepForTimeInterval:testWaitingTime];
//    
//    [self performSelectorOnMainThread:@selector(didFinishInOtherThread:) withObject:nil waitUntilDone:YES];
//}
//
//- (void)didFinishInOtherThread:(id)data{
//    int r = abs(rand()) % 2;
//    DLog(@"%s r = %d",__FUNCTION__,r);
//    if(r == 0){
//        NSMutableArray *bookListResult = [[NSMutableArray alloc] init];
//        BTBook *book = nil;
//        for (int i = 0; i < 10; i++) {
//            book = [[BTBook alloc] init];
//            book.iconURL = nil;
//            book.title = @"床边故事";
//            book.storyCount = i;
//            book.desc = [NSString stringWithFormat:@"第%d个精选故事合集的对应描述",i];
//            book.onlineDate = @"2012-7-15";
//            book.bookID = i;
//            [bookListResult addObject:book];
//            [book release];
//        }
//        [[BTDataManager shareInstance].bookListDic setValue:bookListResult forKey:[NSString stringWithFormat:@"%d",_categotyID]];
//        if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withData:)]) {
//            [_actionDelegate onAction:self withData:bookListResult];
//        }
//        [bookListResult release];
//    }
//
//    else {
//        NSError *error = [NSError errorWithDomain:@"chosenStoryAction" code:r userInfo:nil];
//        if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withError:)]) {
//            [_actionDelegate onAction:self withError:error];
//        }
//    }
//}
