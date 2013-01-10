//
//  BTChosenAction.m
//  AABabyTing3
//
//  Created by Neo Wang on 12-8-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTChosenAction.h"
#import "BTBook.h"
#import "BTChosenService.h"

@implementation BTChosenAction

- (id)initWithHomeID:(NSInteger)homeID visibleLen:(NSInteger)len lastID:(NSInteger)lastID{
    self = [super init];
    if(self){
        _homeID = homeID;
        _len = len;
        _latID = lastID;
    }
    return self;
}

- (void)start{
    NSString *homeIDStr = [NSString stringWithFormat:@"%d",_homeID];
    NSMutableDictionary *chosenDicInfo = [BTDataManager shareInstance].chosenDicInfo;
    BTListInfo *chosenInfo = [chosenDicInfo valueForKey:homeIDStr];
    if([chosenInfo.result count]>0&&_len ==0){
        if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withData:)]) {
            [_actionDelegate onAction:self withData:chosenInfo];
        }
    }else {
//        [self performSelectorInBackground:@selector(mayRunInOtherThread:) withObject:nil];
        _service = [[BTChosenService alloc] initWithHomeID:_homeID lastID:_latID];
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
        NSDictionary * responseData = data;
//        DLog(@"BTChosenAction response =====%@",responseData);
        NSString *domain = [responseData stringForKey:@"domain"];
        NSDictionary *response = [responseData dictionaryForKey:@"response"];
        NSInteger totalCount = [[response numberForKey:@"total"] integerValue];
        NSArray *itemList = [response arrayForKey:@"itemlist"];
        NSMutableArray *result = [NSMutableArray array];
        
        NSMutableDictionary *localDic = [[NSMutableDictionary alloc]initWithContentsOfFile:[BTUtilityClass fileWithPath:BOOK_FILE_NAME]];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        int createTime = 0;
        id check = [ud objectForKey:CREATESTAMP];
        if (check) {
            createTime = [[ud objectForKey:CREATESTAMP] intValue];
        }
        
        for(int i = 0 ; i < [itemList count] ; i++){
            NSDictionary *itemInfo = [itemList objectAtIndex:i];
            BTBook *book = [[BTBook alloc] init];
            book.title = [itemInfo stringForKey:@"name"];
            book.bookID = [NSString stringWithFormat:@"%d",[[itemInfo numberForKey:@"id"] integerValue]];
            book.desc = [itemInfo stringForKey:@"desc"];
            book.descBody = [itemInfo stringForKey:@"descb"];
            book.descHead = [itemInfo stringForKey:@"desch"];
            //book.onlineDate = [itemInfo objectForKey:@"onlineday"];
            book.storyCount = [[itemInfo numberForKey:@"size"] intValue];
            book.iconURL = [BTUtilityClass getUrlWithDomain:domain
                                           encryptionString:[itemInfo stringForKey:@"logourl"] 
                                                 resourceId:[NSString stringWithFormat:@"%@.png",book.bookID]];
            book.picVersion = [[itemInfo numberForKey:@"picversion"] integerValue];
            //精选合辑new标记
            NSString *bookId = [NSString stringWithFormat:@"%@_chosen",[itemInfo numberForKey:@"id"]];
            NSString *upTimeFromNet = [NSString stringWithFormat:@"%@",[itemInfo numberForKey:@"uptime"]];
            NSString *upTimeFromLocal = [[localDic objectForKey:bookId] objectForKey:KEY_BOOK_UPDATETIME];
            BOOL flag = [[[localDic objectForKey:bookId] objectForKey:KEY_BOOK_SHOWNEWFLAG] boolValue];
//            upTimeFromNet = [NSString stringWithFormat:@"%d",1500000000+arc4random()%5];          //测试代码

            if(![upTimeFromNet isEqualToString:upTimeFromLocal] && upTimeFromNet != nil)
            {
                NSMutableDictionary *redic = [NSMutableDictionary dictionary];
                [redic setValue:upTimeFromNet forKey:KEY_BOOK_UPDATETIME];
                int upTimeValue = [[itemInfo numberForKey:@"uptime"] intValue];
//                int upTimeValue = [upTimeFromNet intValue];                                       //测试代码
                if (upTimeValue > createTime) {
                    [redic setValue:[NSNumber numberWithBool:YES] forKey:KEY_BOOK_SHOWNEWFLAG];
                    book.isNew = YES;
                } else {
                    [redic setValue:[NSNumber numberWithBool:NO] forKey:KEY_BOOK_SHOWNEWFLAG];
                    book.isNew = NO;
                }
                [localDic setValue:redic forKey:bookId];
            } else if (flag) {
                book.isNew = YES;
            }
        
            [result addObject:book];
            [book release];
            
        }
        
        [localDic writeToFile:[BTUtilityClass fileWithPath:BOOK_FILE_NAME] atomically:YES];
        [localDic release];
        
        
 

        NSMutableDictionary *chosenDicInfo = [BTDataManager shareInstance].chosenDicInfo;
        NSString *key = [NSString stringWithFormat:@"%d",_homeID];
        BTListInfo *chosenInfo = [chosenDicInfo valueForKey:key];
        
        if(!chosenInfo){
            BTListInfo *listInfo = [[BTListInfo alloc] init];
            listInfo.result = result;
            listInfo.countInNet = totalCount;
            [[BTDataManager shareInstance].chosenDicInfo setValue:listInfo forKey:key];
            [listInfo release];
        }else{
            [chosenInfo.result addObjectsFromArray:result];
            chosenInfo.countInNet = totalCount;
            [[BTDataManager shareInstance].chosenDicInfo setValue:chosenInfo forKey:key];
        }
        
        //[BTDataManager shareInstance].chosenListArray = result;
//        BTListInfo *dataMangerInfo = [BTDataManager shareInstance].chosenArrayInfo;
//        [dataMangerInfo.result addObjectsFromArray:result];
//        dataMangerInfo.countInNet = totalCount;
        if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withData:)]) {
            [_actionDelegate onAction:self withData:[[BTDataManager shareInstance].chosenDicInfo valueForKey:key]];
        }
    }
}


- (void)mayRunInOtherThread:(id)data{
//    DLog(@"%s thread main = %d",__FUNCTION__, [NSThread isMainThread]);
    [NSThread sleepForTimeInterval:testWaitingTime];
    
    [self performSelectorOnMainThread:@selector(didFinishInOtherThread:) withObject:nil waitUntilDone:YES];
}

- (void)didFinishInOtherThread:(id)data{
    int r = abs(rand()) % 2;
    //DLog(@"%s r = %d",__FUNCTION__,r);
    if(r == 0){
        NSMutableArray *chosenResult = [[NSMutableArray alloc] init];
        BTBook *book = nil;
        for (int i = 0; i < 10; i++) {
            book = [[BTBook alloc] init];
            book.iconURL = @"http://www.apple.com.cn/hotnews/promos/images/promo_mountainlion.jpg";
            book.title = [NSString stringWithFormat:@"第%d个精选故事合集",i];
            book.storyCount = i;
            book.desc = [NSString stringWithFormat:@"第%d个精选故事合集的对应描述",i];
            book.onlineDate = @"2012-7-15";
            //book.bookID = i;
            [chosenResult addObject:book];
            [book release];
        }
        //[BTDataManager shareInstance].chosenListArray = chosenResult;
        if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withData:)]) {
            [_actionDelegate onAction:self withData:chosenResult];
        }
        [chosenResult release];
    }
    else {
        NSError *error = [NSError errorWithDomain:@"chosenStoryAction" code:r userInfo:nil];
        if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withError:)]) {
            [_actionDelegate onAction:self withError:error];
        }
    }
}
@end
