//
//  BTCategoryAction.m
//  303
//
//  Created by Neo Wang on 12-8-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

// ============================================================
// ** Import **
// ============================================================
#import "BTCategoryAction.h"
#import "BTCategoryData.h"
#import "BTCategoryListService.h"
#import "BTUtilityClass.h"

// ============================================================
// ** BTCategoryAction **
// ============================================================
@implementation BTCategoryAction
/**
 * 发送网络请求
 */


- (id)initWithLastID:(NSInteger)lastID len:(NSInteger)len{
    self= [super init];
    if(self){
        _lastID = lastID;
        _len = len;
    }
    return self;
}
- (void)start{
    BOOL a = [[BTDataManager shareInstance].bigCategoryArrayInfo.result count]>0 && _len ==0;
//    BOOL b = [BTDataManager shareInstance].bigCategoryArrayInfo.countInNet ==_len &&_len!=0;
//    BOOL c = [[BTDataManager shareInstance].bigCategoryArrayInfo.result count] == _len &&_len !=0;
    //BOOL b = [[BTDataManager shareInstance].bigCategoryArrayInfo.result count] == _len && _lastID !=0;
   // BOOL b = [[BTDataManager shareInstance].bigCategoryArrayInfo.result count] == [BTDataManager shareInstance].bigCategoryArrayInfo.countInNet &&_len != 0;
    BOOL b = self.actionType == defaultAction && [[BTDataManager shareInstance].bigCategoryArrayInfo.result count]>0;
    if(a||b){
        if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withData:)]) {
            [_actionDelegate onAction:self withData:[BTDataManager shareInstance].bigCategoryArrayInfo];
        }
    }else {
        //[self performSelectorInBackground:@selector(mayRunInOtherThread:) withObject:nil];
        if([[BTDataManager shareInstance].bigCategoryArrayInfo.result count]==0){
            _lastID = 0 ;
        }
        _service = [[BTCategoryListService alloc] initWithLastID:_lastID];
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
        NSArray *itemList = [response arrayForKey:@"itemlist"];
        NSInteger totalCount = [[response numberForKey:@"total"] integerValue];
        NSMutableArray *categoryResult = [[NSMutableArray alloc] init];
        BTCategoryData *categoryData = nil;
        for(int i = 0 ; i < [itemList count] ; i++){
            NSDictionary *itemInfo = [itemList objectAtIndex:i];
            categoryData = [[BTCategoryData alloc] init];
            categoryData.title = [NSString stringWithFormat:@"%@",[itemInfo stringForKey:@"name"]];
            categoryData.categoryID = [[itemInfo numberForKey:@"id"] integerValue];
            categoryData.iconURL = [itemInfo stringForKey:@"logourl"];
            if([itemInfo stringForKey:@"logourl"]){
                categoryData.iconURL = [BTUtilityClass getUrlWithDomain:domain
                                                    encryptionString:[itemInfo stringForKey:@"logourl"]
                                                    resourceId:[NSString stringWithFormat:@"%d.png", categoryData.categoryID]];
            }
            categoryData.picVersion = [[itemInfo numberForKey:@"picversion"] integerValue  ];
            categoryData.describe = [itemInfo stringForKey:@"desc"];
            categoryData.type = [itemInfo stringForKey:@"type"];
            categoryData.count = [[itemInfo numberForKey:@"scount"] integerValue];
            [categoryResult addObject:categoryData];
            [categoryData release];
        }
        BTListInfo *dataMangerInfo = [BTDataManager shareInstance].bigCategoryArrayInfo;
        [dataMangerInfo.result addObjectsFromArray:categoryResult];
        dataMangerInfo.countInNet = totalCount;
        //[BTDataManager shareInstance].categoryListArray = categoryResult;
        if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withData:)]) {
            [_actionDelegate onAction:self withData:dataMangerInfo];
        }
        [categoryResult release];
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

//Todo delete
//- (void)mayRunInOtherThread:(id)data{
//    DLog(@"%s thread main = %d",__FUNCTION__, [NSThread isMainThread]);
//    [NSThread sleepForTimeInterval:testWaitingTime];
//    
//    [self performSelectorOnMainThread:@selector(didFinishInOtherThread:) withObject:nil waitUntilDone:YES];
//}

//-(void)didFinishInOtherThread:(id)object{
//    int r = abs(rand()) % 2;
//    DLog(@"%s r = %d",__FUNCTION__,r);
//    if(r == 0){
//        
//        NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
//        BTCategoryData *data = nil;
//        for(int i = 0; i< 6 ; i++){
//            data = [[BTCategoryData alloc] init];
//            switch (i) {
//                case 0:
//                    data.title = @"0-3岁故事";
//                    break;
//                case 1:
//                    data.title = @"4-6岁故事";
//                    break;
//                case 2:
//                    data.title = @"7岁以上故事";
//                    break;
//                case 3:
//                    data.title = @"童话语言";
//                    break;
//                case 4:
//                    data.title = @"科普益智";
//                    break;
//                case 5:
//                    data.title = @"国学经典";
//                    break;
//                case 6:
//                    data.title = @"童话儿歌";
//                    break;
//                default:
//                    break;
//            }
//            data.iconURL = @"http://www.apple.com.cn/hotnews/promos/images/promo_mountainlion.jpg";
//            [categoryArray addObject:data];
//            [data release];
//        }
//        
//        [BTDataManager shareInstance].categoryListArray  = categoryArray;
//        if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withData:)]) {
//            [_actionDelegate onAction:self withData:categoryArray];
//        }
//        [categoryArray release];
//    }else {
//        NSError *error = [NSError errorWithDomain:@"radio" code:r userInfo:nil];
//        if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withError:)]) {
//            [_actionDelegate onAction:self withError:error];
//        }
//    }
//}


