//
//  BTNewStoryInfoCell.m
//  AABabyTing3
//
//  Created by Neo Wang on 12-8-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTNewStoryInfoView.h"
#import "Only320Network.h"

@implementation BTNewStoryInfoView

@synthesize lastestStoryInfo = _lastestStoryInfo,allDownloadDelegate = _allDownloadDelegate;


- (void)dealloc{
    _iconView.viewController = nil;
    [_lastestStoryInfo release];
    [_iconView stopLoading];
    [_iconView release];
    [_titleLabel release];
    [_descLabel release];
    [_downloadBtn release];
    [_onlineDate release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)drawView{
//    _iconView.tag = TAG_NetImage;
    _iconView.tag = TAG_HeaderNetImage;
    _iconView.defaultImage = TTIMAGE(@"bundle://categoryDefault.png");
    _iconView.suffix  = [BTUtilityClass getPicSuffix:type_newStory_Intro_icon picVersion:_lastestStoryInfo.picVersion];
    //_iconView.type = type_newStory_Intro_icon;
    
    _iconView.urlPath = _lastestStoryInfo.collectionIconURL ;
//    DLog(@"%@",_iconView.urlPath);
    _descLabel.text = _lastestStoryInfo.collectionDes;
    //[_downloadBtn setTitle:@"下载" forState:UIControlStateNormal];
    _onlineDate.text =_lastestStoryInfo.onlineDate;
    _titleLabel.text = _lastestStoryInfo.collectionTitle;
}

- (IBAction)allStorydownLoad:(id)sender{
    [_allDownloadDelegate newStoryAllDownload:_downloadBtn];
}

- (void)setImageViewController:(UIViewController *)viewcontroller{
    _iconView.viewController = viewcontroller;
}

@end
