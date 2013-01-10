//
//  BTSourceUpdateAction.m
//  BabyTingiPad
//
//  Created by DL on 12-8-10.
//
//
#import "BTConstant.h"
#import "BTSourceUpdateAction.h"
#import "TTURLCache.h"


@implementation BTSourceUpdateAction

-(id) init {
    if ((self = [super init])) {
    }
    return self;
}
- (void)start{
    BOOL ask = NO;
	id lastDate = [BTUserDefaults valueForKey:UPDATE_STAMP];
    if (lastDate == nil) {
        
        ask = YES;
    } else {
        id interVal = [BTUserDefaults valueForKey:CONFIGURATION_RESOURCE_UPDATE];
        if (interVal == nil) {

            ask = YES;
        }else {
            NSDate *date = [NSDate date];
            double time = [date timeIntervalSince1970];
            int value = (int)time;
            int lastValue = [lastDate intValue];
            int interValue = [interVal intValue];
            if (value > lastValue + interValue) {
                ask = YES;
            }
        }
    }
    if(ask) {
		_service = [[BTSourceUpdateService alloc] init];
		_service.serviceDelegate = self;
        [_service sendServiceRequest];
    }
}
- (void)receiveData:(NSDictionary *)data {
    [_service release];
    _service = nil;
    NSError *error = [super onError:data];
    if(!error){
        //从Service获得到的数据
        NSDictionary * responseData = data;
        CDLog(BTDFLAG_316_PROTOCAL,@"responseData = %@",responseData);
        NSNumber *stamp = [responseData numberForKey:@"stamp"];
        if (stamp != nil) {
            [BTUserDefaults setValue:stamp forKey:SOURCE_UPDATE_TIME];
        }
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//        DLog(@"收到316数据");
        NSDate *date = [NSDate date];
        double time = [date timeIntervalSince1970];
        int value = (int)time;
        [ud setValue:[NSNumber numberWithInt:value] forKey:UPDATE_STAMP];
        
        //2012.11.29 nate edit 无用的变量声明
        //NSFileManager *fileManager = [[[NSFileManager alloc] init] autorelease];
        NSDictionary *response = [responseData dictionaryForKey:@"response"];
        //主界面资源
        NSDictionary *mainDic = [response dictionaryForKey:@"main"];
        NSArray      *mainArray = [mainDic arrayForKey:@"itemlist"];

        for (int i = 0; i < [mainArray count]; i++) {
            int idValue = [[[mainArray objectAtIndex:i] numberForKey:@"id"] intValue];
            
            NSString *homeKey = [NSString stringWithFormat:@"%d_home",idValue];
            [[TTURLCache sharedCache] removeURL:homeKey fromDisk:YES];
            
        }
        
        //最新故事资源
        NSDictionary *newDic = [response dictionaryForKey:@"new"];
        NSArray      *newArray = [newDic arrayForKey:@"itemlist"];

        for (int i = 0; i < [newArray count]; i++) {
            int idValue = [[[newArray objectAtIndex:i] numberForKey:@"id"] intValue];
            
            NSString *iconKey = [NSString stringWithFormat:@"%d_newStoryIcon",idValue];
            [[TTURLCache sharedCache] removeURL:iconKey fromDisk:YES];
            
            NSString *introIonKey = [NSString stringWithFormat:@"%d_newStoryIntroIcon",idValue];
            [[TTURLCache sharedCache] removeURL:introIonKey fromDisk:YES];
        }
        
        //大分类里的故事书
        NSDictionary *albumDic = [response dictionaryForKey:@"album"];
        NSArray      *albumArray = [albumDic arrayForKey:@"itemlist"];
        for (int i = 0; i < [albumArray count]; i++) {
            int idValue = [[[albumArray objectAtIndex:i] numberForKey:@"id"] intValue];///
    
            NSString *bookIconKey = [NSString stringWithFormat:@"%d_bookIcon",idValue];
            [[TTURLCache sharedCache] removeURL:bookIconKey fromDisk:YES];
            
            NSString *categoryIconKey = [NSString stringWithFormat:@"%d_categotyIcon",idValue];
            [[TTURLCache sharedCache] removeURL:categoryIconKey fromDisk:YES];
            
        }
        
        //年龄分类
        NSDictionary *ageDic = [response dictionaryForKey:@"age"];
        NSArray      *ageArray = [ageDic arrayForKey:@"itemlist"];
        for (int i = 0; i < [ageArray count]; i++) {
            int idValue = [[[ageArray objectAtIndex:i] numberForKey:@"id"] intValue];
            
            NSString *ageKey = [NSString stringWithFormat:@"%d_age_categoryIcon",idValue];
            [[TTURLCache sharedCache] removeURL:ageKey fromDisk:YES];

        }
        
        //八大分类
        NSDictionary *contentDic = [response dictionaryForKey:@"content"];
        NSArray      *contentArray = [contentDic arrayForKey:@"itemlist"];
        for (int i = 0; i < [contentArray count]; i++) {
            int idValue = [[[contentArray objectAtIndex:i] numberForKey:@"id"] intValue];
            
            NSString *contentKey = [NSString stringWithFormat:@"%d_content_categoryIcon",idValue];
            [[TTURLCache sharedCache] removeURL:contentKey fromDisk:YES];

        }
        
        //电台资源
        NSDictionary *radioDic = [response dictionaryForKey:@"radio"];
        NSArray      *radioArray = [radioDic arrayForKey:@"itemlist"];

        for (int i = 0; i < [radioArray count]; i++) {
            int idValue = [[[radioArray objectAtIndex:i] numberForKey:@"id"] intValue];
            
            NSString *radioKey = [NSString stringWithFormat:@"%d_radioIcon",idValue];
            [[TTURLCache sharedCache] removeURL:radioKey fromDisk:YES];
        }
        
        //精选合集界面资源
        NSDictionary *collectionDic = [response dictionaryForKey:@"collection"];
        NSArray      *collectionArray = [collectionDic arrayForKey:@"itemlist"];

        for (int i = 0; i < [collectionArray count]; i++) {
            int idValue = [[[collectionArray objectAtIndex:i] numberForKey:@"id"] intValue];
            
            NSString *iconKey = [NSString stringWithFormat:@"%d_collectionIcon",idValue];
            [[TTURLCache sharedCache] removeURL:iconKey fromDisk:YES];
            
            NSString *introIconKey = [NSString stringWithFormat:@"%d_chosenIntroIcon",idValue];
            [[TTURLCache sharedCache] removeURL:introIconKey fromDisk:YES];
        }
        
        
        
        
        //故事资源
        NSDictionary *storyDic = [response dictionaryForKey:@"story"];
        NSArray      *storyArray = [storyDic arrayForKey:@"itemlist"];

        NSString *localfilePath = [BTUtilityClass fileWithPath:LOCALSTORY_PLIST_NAME_NEW];
        NSMutableArray *localArray = [NSMutableArray arrayWithContentsOfFile:localfilePath];
        for (int i = 0; i < [storyArray count]; i++) {
            int idValue = [[[storyArray objectAtIndex:i] numberForKey:@"id"] intValue];
        
            NSString *iconKey = [NSString stringWithFormat:@"%d_storyIcon",idValue];
            [[TTURLCache sharedCache] removeURL:iconKey fromDisk:YES];
            
            NSString *playViewKey = [NSString stringWithFormat:@"%d_storyPlayView",idValue];
            [[TTURLCache sharedCache] removeURL:playViewKey fromDisk:YES];
            
            NSString *storyId = [NSString stringWithFormat:@"%d",idValue];
            NSArray *itemsArray = [[storyArray objectAtIndex:i] arrayForKey:@"bpic"];
            NSString *spic = [[storyArray objectAtIndex:i] stringForKey:@"spic"];
            for(int j = 0;j<[localArray count];j++){
                NSMutableDictionary *localDic = [localArray objectAtIndex:j];
                NSString *localId = [localDic objectForKey:KEY_STORY_ID];
                if ([localId isEqualToString:storyId]) {

                    if (itemsArray) {
                        [localDic setObject:itemsArray forKey:KEY_STORY_PIC_BIG];
                    }
                    if (spic) {
                        [localDic setObject:spic forKey:KEY_STORY_PIC_SMALL];
                    }
                    break;
                }
            }
        }     
        [BTUtilityClass writeToFile:localfilePath withObject:localArray];

    }
}

- (void)dealloc {
    [_service cancel];
    [_service release];
    [super dealloc];
}

@end
