//
//  BTDataManager.h
//  AABabyTing3
//
//  Created by Neo Wang on 12-8-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTNewStoryInfo.h"
#import "BTListInfo.h"
//#import "BTRanklistConstants.h"
@interface BTDataManager : NSObject{
}
//2个主界面的数据
@property (nonatomic, retain)   BTListInfo              *homeArrayInfo;
//@property (nonatomic, retain)	NSArray					*homeArray;                     //主界面的数据
@property (nonatomic, retain)   BTListInfo              *bigCategoryArrayInfo;
//@property (nonatomic, retain)	NSArray					*categoryListArray;             //故事分类列表
//主界面的分类
//@property (nonatomic, retain)	NSArray					*radioArray;                    //电台列表
//@property (nonatomic, retain)   BTListInfo              *radioArrayInfo;
@property (nonatomic,retain)  NSMutableDictionary       *radioDicInfo;                  //电台列表，homeID作为Key
@property (nonatomic, retain)	NSArray					*sotfWareArray;                 //家长必备软件列表
//@property (nonatomic, retain)   BTListInfo              *lastestArrayInfo;
//@property (nonatomic, retain)	NSArray			*lastestStoryArray;        //新故事列表
@property (nonatomic,retain)    NSMutableDictionary         *lastestDicInfo;
//@property (nonatomic, retain)   BTNewStoryInfo          *lastestStoryInfo;
@property (nonatomic,retain)    NSMutableDictionary     *lastestStoryHeaderInfo;        //新故事首发上面的Header
@property (nonatomic, retain)	NSMutableDictionary		*ranklistsDic;
//@property (nonatomic, retain)   BTListInfo              *hotArrayInfo;
//@property (nonatomic, retain)	NSArray					*hotStoryArray;                 //排行榜列表
//@property (nonatomic, retain)	NSArray					*chosenListArray;               //精选合集列表
//@property (nonatomic,retain)    BTListInfo              *chosenArrayInfo;
@property (nonatomic,retain)  NSMutableDictionary       *chosenDicInfo ;                //精选合集列表
//故事分类的列表
@property (nonatomic, retain)	NSMutableDictionary     *bookStoryDic;					//一本书里面的故事列表
@property (nonatomic, retain)	NSMutableDictionary     *bookListDic;					//一个分类书的列表
@property (nonatomic, retain)	NSMutableDictionary     *oneBookHeaderDic;				//一个分类书的列表Header


@property (nonatomic, retain)   NSMutableDictionary     *oneChoosenHeaderDic;            //合集的header字典

//合集里面的东东
@property (nonatomic, retain)	NSMutableDictionary     *oneChosenListDic;
//一个合集的故事列表,其中key是合集的ID。每一个value里面都是一个数组。存放该ID合集的数据。


@property (nonatomic, retain)   NSMutableArray           *radioHistoryArray;              //故事电台在播放界面维护的list    Neo  此处应该存储故事的ID 是NSNumber类型的对象，否则服务器返回数据报错。

+ (BTDataManager *)shareInstance;
+ (void)destroyInstance;
@end
