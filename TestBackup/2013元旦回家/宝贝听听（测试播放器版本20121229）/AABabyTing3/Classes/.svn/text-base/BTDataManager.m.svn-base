//
//  BTDataManager.m
//  AABabyTing3
//
//  Created by Neo Wang on 12-8-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTDataManager.h"

static BTDataManager *instance = nil;

@implementation BTDataManager



@synthesize bookStoryDic,bookListDic ,oneChosenListDic,oneBookHeaderDic,homeArrayInfo,radioDicInfo,sotfWareArray,chosenDicInfo,bigCategoryArrayInfo,lastestDicInfo,lastestStoryHeaderInfo,radioHistoryArray,oneChoosenHeaderDic,ranklistsDic;


- (void)dealloc{
    [chosenDicInfo release];
    [radioHistoryArray release];
    [lastestStoryHeaderInfo release];
    [homeArrayInfo release];
    [radioDicInfo release];
    //[radioArrayInfo release];
    [bookListDic release];
    [ranklistsDic release];
    [lastestDicInfo release];
    [sotfWareArray release];
    [bookStoryDic release];
    [oneChoosenHeaderDic release];
    [bigCategoryArrayInfo release];
    [oneChosenListDic release];
	[oneBookHeaderDic release];
    [super dealloc];
}

+ (BTDataManager*)shareInstance {
    if (instance == nil) {
        instance = [[BTDataManager alloc] init];
    }
    return instance;
}

- (id)init{
    if((self = [super init])){
        bookListDic = [[NSMutableDictionary alloc] init];
        bookStoryDic = [[NSMutableDictionary alloc] init];
        oneChosenListDic = [[NSMutableDictionary alloc] init];
		oneBookHeaderDic = [[NSMutableDictionary alloc] init];
        radioHistoryArray = [[NSMutableArray alloc] init];
        radioDicInfo = [[NSMutableDictionary alloc] init];
        lastestDicInfo = [[NSMutableDictionary alloc] init];
        homeArrayInfo = [[BTListInfo alloc]init];
        chosenDicInfo = [[NSMutableDictionary alloc] init];
        bigCategoryArrayInfo = [[BTListInfo alloc] init];
        lastestStoryHeaderInfo = [[NSMutableDictionary alloc] init];
        oneChoosenHeaderDic = [[NSMutableDictionary alloc] init];
		
		self.ranklistsDic = [NSMutableDictionary dictionary];
    }
    return self;
}

+ (void)destroyInstance {
    [instance release];
    instance = nil;
}
@end
