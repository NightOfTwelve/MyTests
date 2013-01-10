//
//  BTRadioAction.m
//  AABabyTing3
//
//  Created by Neo Wang on 12-8-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTRadioAction.h"
#import "BTRadioData.h"
#import "BTRadioService.h"

@implementation BTRadioAction


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
    NSMutableDictionary *radioDicInfo = [BTDataManager shareInstance].radioDicInfo;
    NSString *homeIDStr = [NSString stringWithFormat:@"%d",_homeID];
    BTListInfo *oneRadioList = [radioDicInfo valueForKey:homeIDStr];
    
    if([oneRadioList.result count]>0&&_len==0){    //判断条件待确定。。
        if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withData:)]) {
            [_actionDelegate onAction:self withData:oneRadioList];
        }
    }else {
        _service = [[BTRadioService alloc] initWithHomeID:_homeID lastID:_latID];
        _service.serviceDelegate = self;
        [_service sendServiceRequest];

    }
}

- (void)receiveData:(NSDictionary *)data{
    [_service release];
    _service = nil;
    NSError *error = [super onError:data];
    if(!error){
        NSDictionary * responseData = data;
        NSString *domain = [responseData stringForKey:@"domain"];
        NSDictionary *response = [responseData dictionaryForKey:@"response"];
        NSInteger totalCount = [[response numberForKey:@"total"] integerValue];
        NSArray *itemList = [response arrayForKey:@"itemlist"];
        NSMutableArray *radioResult = [[NSMutableArray alloc] initWithCapacity:16];
        BTRadioData *radioData = nil;
        
        //------tiny add begin-----
        NSMutableDictionary *localDic = [[NSMutableDictionary alloc]initWithContentsOfFile:[BTUtilityClass fileWithPath:BOOK_FILE_NAME]];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        int createTime = 0;
        id check = [ud objectForKey:CREATESTAMP];
        if (check) {
            createTime = [[ud objectForKey:CREATESTAMP] intValue];
        }
        //------tiny add end---------
        
        for (int i = 0; i<[itemList count]; i++) {
            radioData = [[BTRadioData alloc] init];
            NSDictionary *itemInfo = [itemList objectAtIndex:i];
            radioData.radioTitle = [itemInfo stringForKey:@"name"];
            radioData.radioDes = [itemInfo stringForKey:@"desc"];
            radioData.radioID = [[itemInfo numberForKey:@"id"] stringValue];
            radioData.radioIconURL = [BTUtilityClass getUrlWithDomain:domain encryptionString:[itemInfo stringForKey:@"logourl"] resourceId:[NSString stringWithFormat:@"%@.png",radioData.radioID]];
            radioData.picVersion = [[itemInfo numberForKey:@"picversion"] integerValue];
        //------tiny modify begin---------
//            //判断刷新时间是否替换
//            NSString* radiodataID = [NSString stringWithFormat:@"%@%@",radioData.radioID,@"_radio"];
//            NSString* oldTime = [[NSUserDefaults standardUserDefaults]objectForKey:radiodataID];
//            if (oldTime == nil) {
//                NSString *uptime = [[itemInfo numberForKey:@"uptime"]stringValue];
//                [[NSUserDefaults standardUserDefaults]setValue:uptime forKey:radiodataID];
//                [[NSUserDefaults standardUserDefaults]synchronize];
//                oldTime = [[NSUserDefaults standardUserDefaults]objectForKey:radiodataID];
//            }
//            NSString* newTime = [[itemInfo numberForKey:@"uptime"] stringValue];
//            int oldTime_int = [oldTime intValue];
//            int newTime_int = [newTime intValue];
//            //写回本次刷新时间
//            radioData.uptime = [[itemInfo numberForKey:@"uptime"]stringValue];
//            [[NSUserDefaults standardUserDefaults]setValue:radioData.uptime forKey:radiodataID];
//            [[NSUserDefaults standardUserDefaults]synchronize];
//            if (oldTime_int == newTime_int) {
//                NSString* newFlagForAudio = [NSString stringWithFormat:@"%@%@",radiodataID,@"_new"];
//                [[NSUserDefaults standardUserDefaults]setValue:@"old" forKey:newFlagForAudio];
//                [[NSUserDefaults standardUserDefaults]synchronize];
//            }
//            else{
//                NSString* newFlagForAudio = [NSString stringWithFormat:@"%@%@",radiodataID,@"_new"];
//                [[NSUserDefaults standardUserDefaults]setValue:@"new" forKey:newFlagForAudio];
//                [[NSUserDefaults standardUserDefaults]synchronize];
//            }
//
            
            NSString *radioId = [NSString stringWithFormat:@"%@_radio",[itemInfo numberForKey:@"id"]];
            NSString *upTimeFromNet = [NSString stringWithFormat:@"%@",[itemInfo numberForKey:@"uptime"]];
            NSString *upTimeFromLocal = [[localDic objectForKey:radioId] objectForKey:KEY_BOOK_UPDATETIME];
            BOOL flag = [[[localDic objectForKey:radioId] objectForKey:KEY_BOOK_SHOWNEWFLAG] boolValue];
//            upTimeFromNet = [NSString stringWithFormat:@"%d",1500000000+arc4random()%5];          //测试代码
            if(![upTimeFromNet isEqualToString:upTimeFromLocal] && upTimeFromNet != nil)
            {
                NSMutableDictionary *redic = [NSMutableDictionary dictionary];
                [redic setValue:upTimeFromNet forKey:KEY_BOOK_UPDATETIME];
                int upTimeValue = [[itemInfo numberForKey:@"uptime"] intValue];
//                int upTimeValue = [upTimeFromNet intValue];                                       //测试代码
                if (upTimeValue > createTime) {
                    [redic setValue:[NSNumber numberWithBool:YES] forKey:KEY_BOOK_SHOWNEWFLAG];
                    radioData.isNew = YES;
                } else {
                    [redic setValue:[NSNumber numberWithBool:NO] forKey:KEY_BOOK_SHOWNEWFLAG];
                    radioData.isNew = NO;
                }
                [localDic setValue:redic forKey:radioId];
            }else if (flag){
                radioData.isNew = YES;
            }
            //------tiny modify end---------
            
            [radioResult addObject:radioData];
            [radioData release];
        }
        
        [localDic writeToFile:[BTUtilityClass fileWithPath:BOOK_FILE_NAME] atomically:YES];
        [localDic release];
        
        NSMutableDictionary *radioDicInfo = [BTDataManager shareInstance].radioDicInfo;
        NSString *key = [NSString stringWithFormat:@"%d",_homeID];
        BTListInfo *radioInfo = [radioDicInfo valueForKey:key];
        
        if(!radioInfo){
            BTListInfo *listInfo = [[BTListInfo alloc] init];
            listInfo.result = radioResult;
            listInfo.countInNet = totalCount;
            [[BTDataManager shareInstance].radioDicInfo setValue:listInfo forKey:key];
            [listInfo release];
        }else{
            [radioInfo.result addObjectsFromArray:radioResult];
            radioInfo.countInNet = totalCount;
            [[BTDataManager shareInstance].radioDicInfo setValue:radioInfo forKey:key];
        }
        
        
//        BTListInfo *dataMangerInfo = [BTDataManager shareInstance].radioArrayInfo;
//        [dataMangerInfo.result addObjectsFromArray:radioResult];
//        dataMangerInfo.countInNet = totalCount;
        
        //[BTDataManager shareInstance].radioArrayInfo = dataMangerInfo;
        //DLog(@"%d",[dataMangerInfo.result count]);
        if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withData:)]) {
            [_actionDelegate onAction:self withData:[[BTDataManager shareInstance].radioDicInfo valueForKey:key]];
        }
        [radioResult release];
        //[dataMangerInfo release];
    }
    
}
@end
