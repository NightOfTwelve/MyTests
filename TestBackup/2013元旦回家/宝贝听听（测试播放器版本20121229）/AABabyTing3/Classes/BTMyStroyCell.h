//
//  BTMyStroyCell.h
//  AABabyTing3
//
//  Created by  on 12-8-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTProgressIndicator.h"
#import "BTDownLoadManager.h"
#import "BTNetImageView.h"
#import "BTBaseCell.h"

@interface BTMyStroyCell : BTBaseCell{
    UILabel *_storyName;
    UILabel *_storyAlbumName;
    UILabel *_storyLength;
    BTNetImageView *_storyImage;
    UIImageView *_cellBg;
    BTStory *_story;
    BTImageView     *playingFlagPic;
    UIButton *_bgButton;
}

@property (nonatomic,retain) UILabel *storyName;
@property (nonatomic,retain) UILabel *storyAlbumName;
@property (nonatomic,retain) UILabel *storyLength;
@property (nonatomic,retain) BTNetImageView *storyImage;
@property (nonatomic,retain) UIImageView *cellBg;
@property (nonatomic,retain) BTStory *story;
@property (nonatomic,retain) UIButton *bgButton;
 
-(void)update;
-(void)setimageViewController:(UIViewController *)viewController;

@end
