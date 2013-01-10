//
//  BTCategoryCell.m
//  AABabyTing3
//
//  Created by Neo Wang on 12-8-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTCategoryCell.h"
#import "Only320Network.h"
#import "BTUtilityClass.h"
#import "BTConstant.h"
@implementation BTCategoryCell
//@synthesize descLabel=_descLabel,titleLabel = _titleLabel,categoryImg=_categoryImg;
@synthesize bookData = _bookData,backButton = _backButton;
- (void)dealloc{
    _categoryImg.viewController = nil;
    [_categoryImg stopLoading];
    [newFlagPic release];
    [_descLabel release];
    [_titleLabel release];
    [_categoryImg release];
    [_backButton release];
    [_bookData release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setImageViewController:(UIViewController *)viewController{
    _categoryImg.viewController = viewController;
}


- (void)drawCategoryCell{
    _descLabel.text = [NSString stringWithFormat:@"共%d个故事",_bookData.storyCount];
    _titleLabel.text = _bookData.title;
    _categoryImg.tag = TAG_NetImage;
    _categoryImg.defaultImage= TTIMAGE(@"bundle://categoryDefault.png");
    //_categoryImg.type = type_book_icon;
    _categoryImg.suffix = [BTUtilityClass getPicSuffix:type_book_icon picVersion:_bookData.picVersion];
    if(_bookData.iconURL == nil || [_bookData.iconURL length]==0){
        _categoryImg.urlPath = @"bundle://categoryDefaultIcon.png";
    }else{
        _categoryImg.urlPath = _bookData.iconURL;
    }

    //NSString *bookId = [NSString stringWithFormat:@"%@", _bookData.bookID];
    //isNew = [BTUtilityClass isNewBook:bookId];
    if (newFlagPic == nil) {
        newFlagPic = [[BTImageView alloc] initWithFrame:CGRectMake(30, 2, 22, 21)];
        UIImage *bottomImage = [UIImage imageNamed:@"newFlag.png"];
        newFlagPic.image = bottomImage;
        newFlagPic.tag = TAG_NEW_FLAG;
        [_categoryImg addSubview:newFlagPic];
    }

    if (!_bookData.isNew) {
        newFlagPic.hidden = YES;
    } else {
        newFlagPic.hidden = NO;
    }
}

- (void)drawChooseCell{
    _descLabel.text = [NSString stringWithFormat:@"共%d个故事",_bookData.storyCount];
    _titleLabel.text = _bookData.title;
    _categoryImg.tag = TAG_NetImage;
    _categoryImg.defaultImage= TTIMAGE(@"bundle://categoryDefault.png");
    //_categoryImg.type = type_collection_icon;
    _categoryImg.suffix = [BTUtilityClass getPicSuffix:type_collection_icon picVersion:_bookData.picVersion];
    _categoryImg.urlPath = _bookData.iconURL;
    
    //NSString *bookId = [NSString stringWithFormat:@"%@_chosen", _bookData.bookID];
    //isNew = [BTUtilityClass isNewBook:bookId];
    if (newFlagPic == nil) {
        newFlagPic = [[BTImageView alloc] initWithFrame:CGRectMake(30, 2, 22, 21)];
        UIImage *bottomImage = [UIImage imageNamed:@"newFlag.png"];
        newFlagPic.image = bottomImage;
        newFlagPic.tag = TAG_NEW_FLAG;
        [_categoryImg addSubview:newFlagPic];
    }
    
    if (!_bookData.isNew) {
        newFlagPic.hidden = YES;
    } else {
        newFlagPic.hidden = NO;
    }
}



- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = self.frame;
        [self insertSubview:_backButton atIndex:0];
        
    }
    return self;
}



- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    _backButton.highlighted = highlighted;
    _categoryImg.highlighted = highlighted;
    newFlagPic.highlighted = highlighted;
}

@end
