//
//  BTBigCategoryCell.h
//  AABabyTing3
//
//  Created by Neo Wang on 12-8-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTNetImageView.h"
#import "BTCategoryData.h"
#import "BTBaseCell.h"
@interface BTBigCategoryCell : BTBaseCell{
    IBOutlet    UILabel                 *_categoryTitle;
    UIButton                            *_backButton;
    IBOutlet    BTNetImageView                      *_categoryImageView;
    BTCategoryData                      *_data;
    IBOutlet    UILabel                 *_countLabel;
}



@property (nonatomic,retain)BTCategoryData          *data;
@property (nonatomic,retain)UILabel                 *categoryTitle;
@property (nonatomic,retain)UIButton                *backButton;
@property (nonatomic,retain)BTNetImageView             *categoryImageView;


- (void)drawCell:(BTCategoryData *)data;
- (void)setImageController:(UIViewController *)viewController;
@end
