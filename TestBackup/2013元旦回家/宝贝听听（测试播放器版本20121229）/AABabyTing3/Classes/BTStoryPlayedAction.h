//
//  BTStoryPlayedAction.h
//  AABabyTing3
//
//  Created by Zero on 8/31/12.
//
//	某个故事播放50%之后进行的处理类

#import "BTBaseAction.h"

@interface BTStoryPlayedAction : NSObject
<BTBaseActionDelegate, UIAlertViewDelegate>

- (void)start:(NSString *)storyId;

@end
