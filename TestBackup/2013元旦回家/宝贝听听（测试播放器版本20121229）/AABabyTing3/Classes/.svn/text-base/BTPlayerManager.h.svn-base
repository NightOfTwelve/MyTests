//
//  BTLayerManager.h
//  BabyTing
//
//  Created by Neo on 11-12-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTConstant.h"

@class BTStoryPlayerController;
@class BTRadioPlayerController;
typedef enum{
    PLAY_MODEL_NONE = 0,          //暂停状态
    PLAY_MODEL_STORY,           //播放状态
    PLAY_MODEL_RADIO,         //loading状态
}CONTROLLER_PLAY_MODEL;

@interface BTPlayerManager : NSObject {
	BTStoryPlayerController			*storyPlayer;
    BTRadioPlayerController         *radioPlayer;
    NSMutableArray          *playList;              //故事列表
    NSString                *listName;              //列表标题
    int                     playingStoryIndex;      //当前播放故事索引 
    StoryType               storyType;
    CONTROLLER_PLAY_MODEL   controler_play_mode;
    NSString                *playingStoryId;
}
+(BTPlayerManager *)sharedInstance;

@property (nonatomic ,retain)BTStoryPlayerController *storyPlayer;
@property (nonatomic ,retain)BTRadioPlayerController *radioPlayer;
@property (nonatomic ,retain)NSMutableArray         *playList;
@property (nonatomic ,assign)int                    playingStoryIndex;
@property (nonatomic ,assign)CONTROLLER_PLAY_MODEL  controler_play_mode;
@property (nonatomic ,retain)NSString               *listName;
@property (nonatomic ,retain)NSString               *playingStoryId;
@property (nonatomic)StoryType                      storyType;
@end
