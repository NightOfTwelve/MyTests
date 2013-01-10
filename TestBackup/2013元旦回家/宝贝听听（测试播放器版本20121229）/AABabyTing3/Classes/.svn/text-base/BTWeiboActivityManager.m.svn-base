//
//  BTWeiboActivityManager.m
//  BabyTing
//
//  Created by Neo Wang on 12-7-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTWeiboActivityManager.h"
#import "BTUtilityClass.h"

@implementation BTWeiboActivityManager
- (NSDictionary *)weiboActivityInfoWithWeiboType:(NSString *)weiboName{
    NSDate *date = [[NSDate alloc] init];
    long nowDate = [date timeIntervalSince1970];
    [date release];
    NSMutableDictionary *resultDic = [[[NSMutableDictionary alloc] init] autorelease];
    int weiBoType = -1;
    if([weiboName isEqualToString:@"新浪微博"]){
        weiBoType = 22;
    }else if([weiboName isEqualToString:@"腾讯微博"]){
        weiBoType = 21;
    }
    NSString *weiboPlist = [BTUtilityClass fileWithPath:@"weiboInfo.plist"];
    NSArray *localWeiboInfo = [NSArray arrayWithContentsOfFile:weiboPlist];
    for(NSDictionary *dic in localWeiboInfo){
        if ([resultDic count]==0) {
            NSNumber *typeNum = [dic objectForKey:@"type"];
            if(typeNum.intValue == weiBoType){
                NSNumber *startTimeNum = [dic objectForKey:@"start_time"];
                NSNumber *endTimeNum = [dic objectForKey:@"end_time"];
                long startTime = startTimeNum.longValue;
                long endTime = endTimeNum.longValue;
                if(nowDate > startTime && nowDate < endTime){
                    [resultDic setValue:[dic objectForKey:@"describe_msg"] forKey:@"message"];
                    [resultDic setValue:[dic objectForKey:@"download_url"] forKey:@"download_url"];
                }
            }
        }
    }

    return resultDic;
}
@end
