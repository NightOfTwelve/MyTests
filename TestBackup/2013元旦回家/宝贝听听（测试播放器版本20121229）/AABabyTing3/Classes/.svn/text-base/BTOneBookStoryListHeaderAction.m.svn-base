//
//  BTOneBookStoryListHeaderAction.m
//  cid = 317.故事列表第三个TabView。
//
//  Created by Vicky on 9/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

// ============================================================
// ** Import **
// ============================================================
#import "BTOneBookStoryListHeaderAction.h"
#import "BTBook.h"
#import "BTOneBookStoryListHeaderService.h"
#import "BTOneBookStoryListHeaderData.h"

// ============================================================
// ** BTOneBookStoryListHeaderAction **
// ============================================================

@implementation BTOneBookStoryListHeaderAction
// ============================================================
// ** 初始化 **
// ============================================================
/**
 *  初始化函数
 */
- (id)initWithOneBookHeaderID:(NSInteger)oneBookHeaderID{
    self = [super init];
    if(self){
        _OneBookHeaderID = oneBookHeaderID;
    }
    return self;
}

/**
 *  请求发送
 */
- (void)start{
    NSString *oneBookID = [NSString stringWithFormat:@"%d",_OneBookHeaderID];
    NSMutableDictionary *dic = [BTDataManager shareInstance].oneBookHeaderDic;
    if([dic objectForKey:oneBookID]){
        if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withData:)]) {
            [_actionDelegate onAction:self withData:[dic objectForKey:oneBookID]];
        }
    }else {
       // [self performSelectorInBackground:@selector(mayRunInOtherThread:) withObject:nil];
        _service = [[BTOneBookStoryListHeaderService alloc] initWithAlbumID:_OneBookHeaderID];
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
//        DLog(@"%@",responseData);
        NSString *domain = [responseData stringForKey:@"domain"];
        NSDictionary *response = [responseData dictionaryForKey:@"response"];
        BTOneBookStoryListHeaderData *bookData = nil;
        bookData = [[BTOneBookStoryListHeaderData alloc] init];
        bookData.name = [NSString stringWithFormat:@"%@",[response stringForKey:@"name"]];
        bookData.desch = [NSString stringWithFormat:@"%@",[response stringForKey:@"desch"]];
        bookData.descb = [NSString stringWithFormat:@"%@",[response stringForKey:@"descb"]];
        bookData.headerid =  [[NSString stringWithFormat:@"%@",[response numberForKey:@"id"]]intValue];
        bookData.onLineDay = [NSString stringWithFormat:@"%@",[response stringForKey:@"onlineday"]];
        bookData.picVersion = [[response numberForKey:@"picversion"] integerValue];
        if([[response stringForKey:@"picurl"] length]>0){
            bookData.logourl = [BTUtilityClass getUrlWithDomain:domain encryptionString:[response stringForKey:@"picurl"] resourceId:[NSString stringWithFormat:@"%d.png",bookData.headerid]];
        }
        [[BTDataManager shareInstance].oneBookHeaderDic setValue:bookData forKey:[NSString stringWithFormat:@"%d",_OneBookHeaderID]];
        DLog(@"%@",[BTDataManager shareInstance].oneBookHeaderDic);
        if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withData:)]) {
            [_actionDelegate onAction:self withData:bookData];
        }
        [bookData release];
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
