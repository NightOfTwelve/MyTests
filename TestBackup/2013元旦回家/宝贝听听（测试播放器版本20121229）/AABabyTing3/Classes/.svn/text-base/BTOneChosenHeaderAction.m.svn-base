//
//  BTOneChosenHeaderAction.m
//  AABabyTing3
//
//  Created by Wang Neo on 12-9-6.
//
//

#import "BTOneChosenHeaderAction.h"

@implementation BTOneChosenHeaderAction

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
    NSString *oneBookID = [NSString stringWithFormat:@"%d",_listID];
    NSMutableDictionary *dic = [BTDataManager shareInstance].oneChoosenHeaderDic;
    if([dic objectForKey:oneBookID]){
        if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withData:)]) {
            [_actionDelegate onAction:self withData:[dic objectForKey:oneBookID]];
        }
    }else{
        _service = [[BTOneChosenHeaderService alloc] initWithID:_listID];
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
        NSString *domain = [responseData stringForKey:@"domain"];
        NSDictionary *response = [responseData dictionaryForKey:@"response"];
        BTOneChosenHeaderData *data = [[BTOneChosenHeaderData alloc] init];
        data.headerID = [[response numberForKey:@"id"] integerValue];
        data.name = [response stringForKey:@"name"];
        data.desc = [response stringForKey:@"desc"];
        data.descb = [response stringForKey:@"descb"];
        data.desch = [response stringForKey:@"desch"];
        data.size = [[response numberForKey:@"size"] integerValue];
        data.onlineday = [response stringForKey:@"onlineday"];
        data.picVersion = [[response numberForKey:@"picversion"] integerValue];
        data.picurl = [BTUtilityClass getUrlWithDomain:domain encryptionString:[response stringForKey:@"picurl"] resourceId:[NSString stringWithFormat:@"%d.png",data.headerID]];
//        DLog(@"%@",data.picurl);
        [[BTDataManager shareInstance].oneChoosenHeaderDic setObject:data forKey:[NSString stringWithFormat:@"%d",_listID]];
        
//        DLog(@"%@",[BTDataManager shareInstance].oneChoosenHeaderDic);
        if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withData:)]) {
            [_actionDelegate onAction:self withData:data];
        }
        [data release];
    }
}
@end
