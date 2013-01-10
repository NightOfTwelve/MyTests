//
//  BTOneChosenCategoryInfo.m
//  AABabyTing3
//
//  Created by Neo Wang on 12-8-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTOneChosenCategoryInfoView.h"
#import "Only320Network.h"

@implementation BTOneChosenCategoryInfoView

@synthesize bookInfo = _bookInfo,downloadDelegate = _oneChosenDownloadDelegate,bookInformation = _bookInfomation,iconView = _iconView;

- (void)dealloc{
    _iconView.viewController= nil;
    [_descLabel release];
    [_downloadBtn release];
    [_onlineDate release];
    [_titleLabel release];
    [_iconView stopLoading];
    [_iconView release];
    [_bookInfomation release];
    [_bookInfo release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (IBAction)btnPress:(id)sender{
    [_oneChosenDownloadDelegate downloadOneChosen:sender];
}

- (void)drawView{
//    _iconView.tag = TAG_NetImage;
    _iconView.tag = TAG_HeaderNetImage;
    _iconView.defaultImage = TTIMAGE(@"bundle://categoryDefault.png");
    //_iconView.type = type_category_intro_icon;
    _iconView.suffix = [BTUtilityClass getPicSuffix:type_category_intro_icon picVersion:_bookInfo.picVersion];
    if(_bookInfo.logourl == nil ||[_bookInfo.logourl length]==0){
        _iconView.urlPath = @"bundle://categoryDefaultIcon.png";
    }else{
        _iconView.urlPath = _bookInfo.logourl;
    }
    _descLabel.text = _bookInfo.descb;
    //[_downloadBtn setTitle:@"下载" forState:UIControlStateNormal];
    _onlineDate.text =_bookInfo.onLineDay; 
    _titleLabel.text = _bookInfo.desch;
}

- (void)drawChosenView{
    _iconView.tag = TAG_HeaderNetImage;
    _iconView.defaultImage = TTIMAGE(@"bundle://categoryDefault.png");
    _iconView.suffix = [BTUtilityClass getPicSuffix:type_Chosen_intro_icon picVersion:_bookInfomation.picVersion];
    //_iconView.type = type_Chosen_intro_icon;
    _iconView.urlPath = _bookInfomation.picurl ;
    _descLabel.text = _bookInfomation.descb;
    //[_downloadBtn setTitle:@"下载" forState:UIControlStateNormal];
    _onlineDate.text =_bookInfomation.onlineday;
    _titleLabel.text = _bookInfomation.desch;
}
- (void)setImageViewController:(UIViewController *)viewcontroller{
    _iconView.viewController = viewcontroller;
}
@end
