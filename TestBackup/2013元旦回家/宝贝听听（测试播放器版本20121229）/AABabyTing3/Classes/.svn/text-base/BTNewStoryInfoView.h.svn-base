//
//  BTNewStoryInfoCell.h
//  AABabyTing3
//
//  Created by Neo Wang on 12-8-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTNetImageView.h"
#import "BTNewStoryInfo.h"

@protocol BTNewStoryAllDownloadDelegate <NSObject>

- (void)newStoryAllDownload:(id)data;

@end

@interface BTNewStoryInfoView : UIView{
    id<BTNewStoryAllDownloadDelegate>   _allDownloadDelegate;
    IBOutlet   BTNetImageView          *_iconView;
    IBOutlet   UILabel                 *_titleLabel;
    IBOutlet   UILabel                 *_descLabel;
    IBOutlet   UIButton                *_downloadBtn;
    IBOutlet   UILabel                 *_onlineDate;
    BTNewStoryInfo                     *_lastestStoryInfo;
}

@property(nonatomic,retain)BTNewStoryInfo    *lastestStoryInfo;
@property(assign)id<BTNewStoryAllDownloadDelegate>   allDownloadDelegate;
- (void)drawView;
- (void)setImageViewController:(UIViewController *)viewcontroller;

@end
