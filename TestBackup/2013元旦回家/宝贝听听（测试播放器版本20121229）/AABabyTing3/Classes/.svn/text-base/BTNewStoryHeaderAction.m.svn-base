//
//  BTNewStoryHeaderAction.m
//  AABabyTing3
//
//  Created by Wang Neo on 12-9-3.
//
//

#import "BTNewStoryHeaderAction.h"
#import "BTNewStoryInfo.h"

@implementation BTNewStoryHeaderAction

-(id)initWithListId:(NSInteger )listID{
    
    self = [super init];
    if (self) {
        _listID = listID;
    }
    return self;
}


- (void)dealloc{
    [_service release];
    [super dealloc];
}

- (void)start{
    NSString *homeIDStr = [NSString stringWithFormat:@"%d",_listID];
    NSMutableDictionary *lastestStoryHeaderInfoDic = [BTDataManager shareInstance].lastestStoryHeaderInfo;
    BTNewStoryInfo *info = [lastestStoryHeaderInfoDic valueForKey:homeIDStr];
    if(info&&info!=nil){
        if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withData:)]) {
            [_actionDelegate onAction:self withData:info];
        }
    }else{
        _service = [[BTNewStoryHeaderService alloc] initWithID:_listID];
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
//        DLog(@"%@",responseData);
        NSString *domain = [responseData stringForKey:@"domain"];
        NSDictionary *response = [responseData dictionaryForKey:@"response"];
        BTNewStoryInfo *info = [[BTNewStoryInfo alloc] init];
        info.infoID = [[response numberForKey:@"id"] integerValue];
        info.onlineDate = [response stringForKey:@"onlineday"];
        info.collectionIconURL = [BTUtilityClass getUrlWithDomain:domain encryptionString:[response stringForKey:@"picurl"] resourceId:[NSString stringWithFormat:@"%d.png",info.infoID]];
        info.collectionDes = [response stringForKey:@"descb"];
        info.collectionTitle = [response stringForKey:@"desch"];
        info.picVersion = [[response numberForKey:@"picversion"] integerValue];
        NSMutableDictionary *dic = [BTDataManager shareInstance].lastestStoryHeaderInfo;
        NSString *key = [NSString stringWithFormat:@"%d",_listID];
        [dic setValue:info forKey:key];
//        
//        
//        [BTDataManager shareInstance].lastestStoryInfo = info;
        if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withData:)]) {
            [_actionDelegate onAction:self withData:[dic valueForKey:key]];
        }
        [info release];
    }
}

@end
