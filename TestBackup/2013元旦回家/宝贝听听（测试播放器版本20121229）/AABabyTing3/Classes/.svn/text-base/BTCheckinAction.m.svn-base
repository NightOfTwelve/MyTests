//
//  BTCheckinAction.m
//  BabyTingiPad
//
//  Created by  on 12-8-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTCheckinAction.h"
#import "JSONKit.h" 
#import "BTCheckinManager.h"
#import "BTConstant.h"

@implementation BTCheckinAction

- (id)init {
    if ((self = [super init])) {
        _service = [[BTCheckinService alloc] init];
        _service.serviceDelegate = self;
    }
    return self;
}

- (void)start{
    [_service sendServiceRequest];
}

//存储checkin的返回信息
-(void)saveCheckinResponseDataToManager:(NSDictionary *)dic{
    
    NSDictionary *responseInfo = [dic dictionaryForKey:CHECKIN_RESPONSE_INFO];
    NSArray *popularizes = [responseInfo arrayForKey:CHECKIN_RESPONSE_POPULARIZE];
    NSArray *recommends = [responseInfo arrayForKey:CHECKIN_RESPONSE_RECOMMEND];
    NSArray *splashs = [responseInfo arrayForKey:CHECKIN_RESPONSE_SPLASH];
    int updateType = [[responseInfo numberForKey:CHECKIN_RESPONSE_UPDATE_TYPE] intValue];
    NSString *updateUrl = [responseInfo stringForKey:CHECKIN_RESPONSE_UPDATE_URL];
    NSDictionary *softData = [responseInfo dictionaryForKey:CHECKIN_RESPONSE_NECESSARY_SOFT];
    
    BTCheckinManager *manager = [BTCheckinManager shareInstance];
    manager.popularizes = popularizes;
    manager.recommends = recommends;
    manager.splashs = splashs;
    manager.updateType = updateType;
    manager.necessarySoftData = softData;
    if (updateUrl) {
        manager.updateUrl = updateUrl;
    }
    //[self savePopularizesInfoToLocal:popularizes];
	
	//版本更新通知
//	[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATE_SOFTWARE_WHEN_CHECKIN_FINISH
//														object:nil
//													  userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:updateType]
//																						   forKey:UPDATE_SOFTWARE_UPDATE_TYPE]];
}

- (void)receiveData:(NSDictionary *)data{

    NSError *error = [super onError:data];
    if(!error){
        //从Service获得到的数据
        NSDictionary * responseData = data;
		
//		CVLog(BTDFLAG_CHECKIN,@"checkin response ====%@",responseData);
        //在自己的action处理不同的逻辑（数据存储和返回给上层controller）
        [self saveCheckinResponseDataToManager:responseData];
        
        if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withData:)]) {
            [_actionDelegate onAction:self withData:nil];
        }
    }
}

-(void)dealloc{
    [_service cancel];
    [_service release];
    _service = nil;
    [super dealloc];
}

@end
