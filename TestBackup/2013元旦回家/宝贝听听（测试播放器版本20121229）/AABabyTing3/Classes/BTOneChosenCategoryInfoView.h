//
//  BTOneChosenCategoryInfo.h
//  AABabyTing3
//
//  Created by Neo Wang on 12-8-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTBook.h"
#import "BTNetImageView.h"
#import "BTOneBookStoryListHeaderData.h"
#import "BTOneChosenHeaderData.h"

@protocol BTOneChosenDownloadPress <NSObject>

-(void)downloadOneChosen:(id)data;

@end

@interface BTOneChosenCategoryInfoView : UIView{
    id<BTOneChosenDownloadPress>        _oneChosenDownloadDelegate;
    IBOutlet   BTNetImageView          *_iconView;
    IBOutlet   UILabel                 *_descLabel;
    IBOutlet   UIButton                *_downloadBtn;
    IBOutlet   UILabel                 *_onlineDate;
    IBOutlet   UILabel                 *_titleLabel;
    BTOneBookStoryListHeaderData       *_bookInfo;
    BTOneChosenHeaderData                             *_bookInfomation;
}

@property (assign)id<BTOneChosenDownloadPress>       downloadDelegate;
@property (nonatomic,retain) BTOneBookStoryListHeaderData      *bookInfo;
@property (nonatomic,retain) BTOneChosenHeaderData                             *bookInformation;
@property (nonatomic,retain) BTNetImageView          *iconView;

- (void)drawView;
- (void)drawChosenView;
- (void)setImageViewController:(UIViewController *)viewcontroller;
@end
