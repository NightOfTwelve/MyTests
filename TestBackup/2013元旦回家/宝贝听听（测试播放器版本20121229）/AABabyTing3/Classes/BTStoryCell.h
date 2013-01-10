//
//  BTStoryCell.h
//  AABabyTing3
//
//  Created by Neo Wang on 12-8-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTNetImageView.h"
#import "BTStory.h"
#import "TTTAttributedLabel.h"
#import "KPLabel.h"
#import "BTBaseCell.h"
@protocol BTStoryCellDownLoadPressDelegate <NSObject>

- (void)storyDownLoad:(BTStory *)storyData;

@end

@interface BTStoryCell : BTBaseCell{
    id<BTStoryCellDownLoadPressDelegate>      _storyDelegate;
    IBOutlet        UILabel                 *_timeLabel;
    IBOutlet        BTNetImageView          *_storyImg;
    IBOutlet        UIButton                *_downloadBtn;
    BTStory         *_storyData;
    BTImageView     *newFlagPic;
    BTImageView     *playingFlagPic;
    UIButton        *_backButton;
    BOOL            _isShowCategory;
    //BOOL            isNew;
}
@property(nonatomic,retain)		TTTAttributedLabel *categoryLabel;
@property(nonatomic,copy)		NSString *keyword;
@property(nonatomic,retain)    TTTAttributedLabel	*titleLabel;
@property(assign)id<BTStoryCellDownLoadPressDelegate> storyDelegate; 
//@property(nonatomic,retain)UILabel                 *titleLabel;
//@property(nonatomic,retain)UILabel                 *speakerLabel;
//@property(nonatomic,retain)UILabel                 *timeLabel;
//@property(nonatomic,retain)TTNetImageView          *storyImg;
@property(nonatomic,retain)UIButton                *downloadBtn;
//@property(nonatomic,retain)UILabel                 *categoryLabel;
@property(nonatomic,retain)BTStory                 *storyData;
@property(nonatomic, retain) UIButton *backButton;
@property(assign)BOOL isShowCategory;

- (IBAction)downloadPress:(id)sender;
- (void)setPlayListCellData;
- (void)setCellData;
- (void)setImageController:(UIViewController *)viewController;
@end
