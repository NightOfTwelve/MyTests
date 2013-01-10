//
//  BTHomeCell.h
//  AABabyTing3
//
//  Created by Neo Wang on 12-8-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTNetImageView.h"
#import "BTHomeData.h"
#import "BTBaseCell.h"
@interface BTHomeCell : BTBaseCell{
    IBOutlet BTNetImageView *_netImageView;
    IBOutlet UILabel *_titleLabel;
    IBOutlet UILabel *_descLabel;
    UIButton *_backButton;
    BTImageView *_theNewFlagPic;
}

@property(nonatomic, retain) BTNetImageView *netImageView;
@property(nonatomic, retain) BTImageView *theNewFlagPic;
@property(nonatomic, retain) UILabel *titleLabel;
@property(nonatomic, retain) UILabel *descLabel;
@property(nonatomic, retain) UIButton *backButton;

-(void)drawCell:(BTHomeData *)data;

@end
