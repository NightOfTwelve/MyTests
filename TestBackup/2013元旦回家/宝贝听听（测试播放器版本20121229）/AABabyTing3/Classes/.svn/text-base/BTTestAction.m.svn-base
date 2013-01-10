//
//  BTTestAction.m
//  AABabyTing3
//
//  Created by He baochen on 12-8-14.
//
//

#import "BTTestAction.h"
#import "BTStory.h"
@implementation BTTestAction


//for test
- (void) start {
  
  [self performSelectorInBackground:@selector(mayRunInOtherThread:) withObject:nil];
  
}

- (void) mayRunInOtherThread:(id)data{
//  DLog(@"%s thread main = %d",__FUNCTION__, [NSThread isMainThread]);
  [NSThread sleepForTimeInterval:2];
  
  [self performSelectorOnMainThread:@selector(didFinishInOtherThread:) withObject:nil waitUntilDone:YES];
  //[self didFinishInOtherThread:nil];
}

- (void)didFinishInOtherThread:(id)data {
//  NSDictionary *userInfo = notification.userInfo;
//  NSError *error = [userInfo objectForKey:@"kError"];
  
  int r = abs(rand()) % 4;
//  DLog(@"%s r = %d",__FUNCTION__,r);
//  r = 0;
  if (r == 0) { //正常
    NSMutableArray *testResult = [[NSMutableArray alloc] initWithCapacity:16];
    BTStory *story = nil;
    for (int i = 0; i < 16; i++) {
      story = [[BTStory alloc] init];
      story.title = [NSString stringWithFormat:@"Title %d",i];
      //story.desc = [NSString stringWithFormat:@"Desc %d",i];
//      story.iconURL = nil;
      [testResult addObject:story];
      [story release];
    }
    if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withData:)]) {
      [_actionDelegate onAction:self withData:testResult];
    }
  [testResult release];
  } else { //2,3,4各种错误
    [self onError:nil];
  }
}

@end
