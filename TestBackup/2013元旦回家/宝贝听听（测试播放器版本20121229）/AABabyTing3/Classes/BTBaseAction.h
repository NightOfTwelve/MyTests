//
//  BTBaseAction.h
//  AABabyTing3
//
//  Created by He baochen on 12-8-14.
//
//

#import <Foundation/Foundation.h>
#import "BTBaseService.h"
#import "BTDataManager.h"
#import "BTStory.h"
#import "BTListInfo.h"
#import "NSDictionary+ActionData.h"
#import "BTBaseActionDelegate.h"

#define testWaitingTime 0.5

@class BTBaseAction;


typedef enum{
    nextPageAction = 90212,//Neo：随便写的，防止重复
    defaultAction,
}actionType;


@interface BTBaseAction : NSObject <BTReceiveDataDelegate>{
  
    id<BTBaseActionDelegate>            _actionDelegate;
    
    BTBaseService                       *_service;
    
    //BTDataManager                       *_dataManager;
    
    
    actionType                          _actionType;
}

@property (nonatomic, assign)	id<BTBaseActionDelegate>	actionDelegate;
@property (nonatomic,assign)actionType   actionType;

- (void) start;
- (void) cancel;
- (NSError *)onError:(NSDictionary *)userInfo ;
- (NSError*) processError:(NSDictionary *)userInfo ;
- (void)dealloc ;

//对故事的结构体进行自己的分析
- (NSMutableArray *)transformToStoryDataWithDic:(NSDictionary *)dic;
@end
