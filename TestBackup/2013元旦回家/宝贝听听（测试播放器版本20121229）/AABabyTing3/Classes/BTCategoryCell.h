//
//  BTCategoryCell.h
//  AABabyTing3
//
//  Created by Neo Wang on 12-8-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTNetImageView.h"
#import "BTBook.h"
#import "BTBaseCell.h"
@interface BTCategoryCell : BTBaseCell{
    IBOutlet        UILabel                 *_titleLabel;
    IBOutlet        UILabel                 *_descLabel;
    IBOutlet        BTNetImageView          *_categoryImg;
    BTBook                                  *_bookData;
    UIButton *_backButton;
    BTImageView     *newFlagPic;
    //BOOL            isNew;
}

//@property(nonatomic ,retain)UILabel                 *titleLabel;
//@property(nonatomic ,retain)UILabel                 *descLabel;
//@property(nonatomic ,retain)TTNetImageView          *categoryImg;
@property(nonatomic,retain)BTBook                   *bookData;
@property(nonatomic, retain) UIButton *backButton;

- (void)setImageViewController:(UIViewController *)viewController;
- (void)drawCategoryCell;

- (void)drawChooseCell;
@end
