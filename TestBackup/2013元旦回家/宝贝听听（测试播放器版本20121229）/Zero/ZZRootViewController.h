//
//  ZZRootViewController.h
//  AABabyTing3
//
//  Created by Song Zhipeng on 12/30/12.
//
//

#import <UIKit/UIKit.h>
#import "AudioModel.h"

@interface ZZRootViewController : UIViewController
{
	AudioModel *_player;
}

@property (retain, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (retain, nonatomic) IBOutlet UILabel *currentTimeLabel;
- (IBAction)onClickedPauseButton:(UIButton *)sender;
- (IBAction)onClickedStopButton:(UIButton *)sender;
- (IBAction)onClickedPlayButton:(UIButton *)sender;
@end
