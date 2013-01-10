//
//  BTBaseAction.m
//  AABabyTing3
//
//  Created by He baochen on 12-8-14.
//
//

#import "BTBaseAction.h"
#import "NSDictionary+ActionData.h"
#import "BTUtilityClass.h"
@implementation BTBaseAction
@synthesize actionDelegate = _actionDelegate,actionType = _actionType;
//@synthesize lastId, listId, percount;

-(id)init{
    
    self = [super init];
    if (self) {
    }
    return self;
}

- (void) start {

    [_service sendServiceRequest];
}

- (void) cancel {
    //_actionDelegate = nil;
    [_service cancel];
}

- (NSError *)onError:(NSDictionary *)userInfo {
    NSError *error = [userInfo objectForKey:NOTIFICATION_ERROR];
    if(error){
		//在这里主要给error添加userInfo这个字典，参考.h文件的注释
		if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withError:)] ) {
			[_actionDelegate onAction:self withError:error];
		}
        return error;
    }
    return nil;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (NSMutableArray *)transformToStoryDataWithDic:(NSDictionary *)dic{
    NSDictionary * responseData = dic;
//    CDLog(BTDFLAG_LOCAL_SORT,@"responseData = %@",responseData);
    NSString *domain = [responseData stringForKey:@"domain"];
    NSDictionary *response = [responseData dictionaryForKey:@"response"];
    NSArray *itemList = [response arrayForKey:@"itemlist"];
    NSMutableArray *result = [NSMutableArray array];
    if(![itemList isKindOfClass:[NSArray class]]){
        return result;
    }
    
    for(int i = 0 ; i < [itemList count] ; i++){
        NSDictionary *itemInfo = [itemList objectAtIndex:i];
        BTStory *story = [[BTStory alloc] init];
        story.storyId = [NSString stringWithFormat:@"%d",[[itemInfo numberForKey:KEY_STORY_ID] integerValue]];
        story.title = [itemInfo stringForKey:KEY_STORY_NAME];
        story.domain = domain;
        story.timeLength =[NSString stringWithFormat:@"%@",[itemInfo numberForKey:KEY_STORY_LENGTH]];
        story.speakerName = [itemInfo stringForKey:KEY_STORY_ANNOUNCER];
        story.pressTime = [[itemInfo numberForKey:KEY_STORY_HITCOUNT] intValue];
        story.stamp = [[itemInfo numberForKey:KEY_STORY_UPDATE_TIME] intValue];
        story.categoryName = [itemInfo stringForKey:KEY_STORY_CATEGORY_NAME];
        story.spic = [itemInfo stringForKey:KEY_STORY_PIC_SMALL];
        story.orderby = [[itemInfo numberForKey:KEY_STORY_ORDERBY] integerValue];
        story.picversion = [[itemInfo numberForKey:KEY_STORY_PICVERSION] integerValue];
        story.albumid = [[itemInfo numberForKey:KEY_STORY_ALBUMID] integerValue];
        story.isNew = [BTUtilityClass isNewStory:story.storyId stamp:story.stamp];
        //story.rankNum = i + 1;
        if ([[itemInfo arrayForKey:KEY_STORY_PIC_BIG] isKindOfClass:[NSArray class]]) {
            if ([[itemInfo arrayForKey:KEY_STORY_PIC_BIG] count] > 0) {
                story.bpic = [NSMutableArray arrayWithArray:[itemInfo arrayForKey:KEY_STORY_PIC_BIG]];
            }
        }else{
            story.bpic = nil;
        }
        story.lstory = [itemInfo stringForKey:KEY_STORY_AUDIO_URL_LOW];
        
        story.hstory = [itemInfo stringForKey:KEY_STORY_AUDIO_URL_HIGH];
        
        
        story.encryType = [[itemInfo numberForKey:@"encrypt"] integerValue];
        [result addObject:story];
        [story release];
        
    }
    return result;
}

@end
