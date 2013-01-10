//
//  BTHomeAction.m
//  AABabyTing3
//
//  Created by Neo Wang on 12-8-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTHomeAction.h"
#import "BTHomeData.h"

@implementation BTHomeAction

-(id)init{
    
    self = [super init];
    if (self) {
    }
    return self;
}


- (void)dealloc{
    [_service release];
    [super dealloc];
}

- (void)start{
    if([[BTDataManager shareInstance].homeArrayInfo.result count]>0){
        if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withData:)]) {
            [_actionDelegate onAction:self withData:[BTDataManager shareInstance].homeArrayInfo];
        }
    }else {
        _service = [[BTHomeService alloc] init];
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
//        DLog(@"%@",responseData);
        NSDictionary *response = [responseData dictionaryForKey:@"response"];
        NSString *domain = [responseData stringForKey:@"domain"];
        NSInteger allCount = [[response numberForKey:@"count"] integerValue];
        NSArray *itemList = [response arrayForKey:@"itemlist"];
        NSMutableArray *homeResult = [[NSMutableArray alloc] initWithCapacity:16];
        BTHomeData *homedata = nil;
        
        //------tiny add begin-----
        NSMutableDictionary *localDic = [[NSMutableDictionary alloc]initWithContentsOfFile:[BTUtilityClass fileWithPath:BOOK_FILE_NAME]];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        int createTime = 0;
        id check = [ud objectForKey:CREATESTAMP];
        if (check) {
            createTime = [[ud objectForKey:CREATESTAMP] intValue];
        }
        //------tiny add end---------
        
        for(int i = 0 ; i < [itemList count] ; i++){
            NSDictionary *itemInfo = [itemList objectAtIndex:i];
            homedata = [[BTHomeData alloc] init];
            homedata.homeID = [NSString stringWithFormat:@"%@",[[itemInfo numberForKey:@"id"] stringValue]];
            homedata.type = [itemInfo stringForKey:@"type"];
            homedata.category = [itemInfo stringForKey:@"name"];
            if([itemInfo stringForKey:@"logourl"]){
                homedata.iconURL = [BTUtilityClass getUrlWithDomain:domain encryptionString:[itemInfo stringForKey:@"logourl"] resourceId:[NSString stringWithFormat:@"%@.png",homedata.homeID]];
            }
            homedata.describe = [itemInfo stringForKey:@"desc"];
            homedata.picVersion = [[itemInfo numberForKey:@"picversion"] integerValue];
            //---------tiny modify begin----------
//            
//            //判断刷新时间是否替换
//            NSString *oldTime = [[NSUserDefaults standardUserDefaults] objectForKey:homedata.homeID];
//            if (oldTime == nil) {
//                NSString *uptime  = [[itemInfo numberForKey:@"uptime"] stringValue];
//                [[NSUserDefaults standardUserDefaults] setValue:uptime forKey:homedata.homeID];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//                oldTime = [[NSUserDefaults standardUserDefaults] objectForKey:homedata.homeID];
//            }
//            NSString *newTime = [[itemInfo numberForKey:@"uptime"] stringValue];
//            int oldTime_int = [oldTime intValue];
//            int newTime_int = [newTime intValue];
//            //写回本次刷新时间
//            homedata.updateDate = [[itemInfo numberForKey:@"uptime"] stringValue];
//            [[NSUserDefaults standardUserDefaults] setValue:homedata.updateDate forKey:homedata.homeID];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            
//            if (oldTime_int == newTime_int) {
//                NSString *newFlagForHome = [NSString stringWithFormat:@"%@%@",homedata.homeID,@"_new"];
//                [[NSUserDefaults standardUserDefaults] setValue:@"old" forKey:newFlagForHome];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//            }
//            else{
//                NSString *newFlagForHome = [NSString stringWithFormat:@"%@%@",homedata.homeID,@"_new"];
//                [[NSUserDefaults standardUserDefaults] setValue:@"new" forKey:newFlagForHome];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//            }
 
            NSString *homeId = [NSString stringWithFormat:@"%@_home",[itemInfo numberForKey:@"id"]];
            NSString *upTimeFromNet = [NSString stringWithFormat:@"%@",[itemInfo numberForKey:@"uptime"]];
            NSString *upTimeFromLocal = [[localDic objectForKey:homeId] objectForKey:KEY_BOOK_UPDATETIME];
            BOOL flag = [[[localDic objectForKey:homeId] objectForKey:KEY_BOOK_SHOWNEWFLAG] boolValue];
//            upTimeFromNet = [NSString stringWithFormat:@"%d",1500000000+arc4random()%5];          //测试代码

            if(![upTimeFromNet isEqualToString:upTimeFromLocal] && upTimeFromNet != nil)
            {
                NSMutableDictionary *redic = [NSMutableDictionary dictionary];
                [redic setValue:upTimeFromNet forKey:KEY_BOOK_UPDATETIME];
                int upTimeValue = [[itemInfo numberForKey:@"uptime"] intValue];
//                int upTimeValue = [upTimeFromNet intValue];                                       //测试代码
                if (upTimeValue > createTime) {
                    [redic setValue:[NSNumber numberWithBool:YES] forKey:KEY_BOOK_SHOWNEWFLAG];
                    homedata.isNew = YES;
                } else {
                    [redic setValue:[NSNumber numberWithBool:NO] forKey:KEY_BOOK_SHOWNEWFLAG];
                    homedata.isNew = NO;
                }
                [localDic setValue:redic forKey:homeId];
            }else if (flag){
                homedata.isNew = YES;
            }
            
            [homeResult addObject:homedata];
            [homedata release];
        }
        
        [localDic writeToFile:[BTUtilityClass fileWithPath:BOOK_FILE_NAME] atomically:YES];
        [localDic release];
        
        //---------tiny modify end----------
        
//        DLog(@"bbbbb");
        BTListInfo *info = [BTDataManager shareInstance].homeArrayInfo;
        [info.result addObjectsFromArray:homeResult];
        info.countInNet =allCount;
        if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withData:)]) {
            [_actionDelegate onAction:self withData:[BTDataManager shareInstance].homeArrayInfo];
        }
        [homeResult release];
        //在自己的action处理不同的逻辑（数据存储和返回给上层controller）
    }
}

@end
