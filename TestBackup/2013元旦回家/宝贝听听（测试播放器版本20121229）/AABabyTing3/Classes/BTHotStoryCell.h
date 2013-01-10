//
//  BTHotStoryCell.h
//  AABabyTing3
//
//  Created by Neo Wang on 12-8-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTNetImageView.h"
#import "BTStory.h"
#import "BTImageView.h"
#import "BTBaseCell.h"

@protocol BTHotCellDownloadPressDelegate <NSObject>

- (void)storyDownload:(BTStory *)storyData;

@end

@interface BTHotStoryCell : BTBaseCell{
    IBOutlet    UILabel                 *_title;
    IBOutlet    UILabel                 *_downloadTimes;
    IBOutlet    UILabel                 *_rankNum;
    IBOutlet    UIButton                *_downloadBtn;
    IBOutlet    BTNetImageView          *_storyImg;
    id<BTHotCellDownloadPressDelegate>  _hotDownloadDelegate;
    BTStory                             *_storyData;
    UIButton                            *_backButton;
    IBOutlet   BTImageView              *_rankBackView;
    BTImageView     *newFlagPic;
    BTImageView     *playingFlagPic;
    BOOL            isNew;
}

//@property(nonatomic,retain)UILabel                 *title;
//@property(nonatomic,retain)UILabel                 *downloadTim;
//@property(nonatomic,retain)UILabel                 *categoryTit;
//@property(nonatomic,retain)UILabel                 *speakerName;
//@property(nonatomic,retain)UILabel                 *timeLenth;
//@property(nonatomic,retain)UILabel                 *rankNum;
//@property(nonatomic,retain)TTNetImageView          *storyImg;

@property(assign)id<BTHotCellDownloadPressDelegate>  hotDownloadDelegate;
@property(nonatomic,retain)BTStory                             *storyData;
@property(nonatomic,retain)UIButton                            *backButton;
@property(nonatomic,retain)BTImageView                          *rankBackView;


- (void)drawCell;
- (void)setImageController:(UIViewController *)viewController;

@end
