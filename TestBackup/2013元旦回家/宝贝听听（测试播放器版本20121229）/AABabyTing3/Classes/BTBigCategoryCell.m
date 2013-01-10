//
//  BTBigCategoryCell.m
//  AABabyTing3
//
//  Created by Neo Wang on 12-8-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTBigCategoryCell.h"
#import "Only320Network.h"

@implementation BTBigCategoryCell
@synthesize categoryTitle = _categoryTitle,backButton = _backButton,categoryImageView = _categoryImageView,data = _data;


- (void)dealloc {
    _categoryImageView.viewController = nil;
    [_countLabel release];
    [_categoryImageView stopLoading];
    [_backButton release];
    [_categoryTitle release];
    [_categoryImageView release];
    [_data release];
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

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = self.frame;
        [self insertSubview:_backButton atIndex:0];
        
    }
    return self;
}

- (void)setImageController:(UIViewController *)viewController{
    _categoryImageView.viewController = viewController;
}

- (void)drawCell:(BTCategoryData *)data{
    //_categoryImageView.frame = CGRectMake(20, 10, 58, 64);
    _categoryImageView.tag = TAG_NetImage;
    _categoryImageView.defaultImage = TTIMAGE(@"bundle://radio_default.png");
    if([data.type isEqualToString:@"age"]){
        //_categoryImageView.type= type_age_category_icon;
        _categoryImageView.suffix = [BTUtilityClass getPicSuffix:type_age_category_icon picVersion:data.picVersion];
    }else if([data.type isEqualToString:@"content"]){
        //_categoryImageView.type= type_content_category_icon;
        _categoryImageView.suffix = [BTUtilityClass getPicSuffix:type_content_category_icon picVersion:data.picVersion];
    }
    _categoryImageView.urlPath = data.iconURL;
    _categoryTitle.text = data.title;
    if(data.count == 0){
        _countLabel.text = @"";
        _categoryTitle.center = CGPointMake(183, 41.5);
    }
    else{
        _countLabel.text = [NSString stringWithFormat:@"共%d个故事",data.count];
    }
    DLog(@"nnd%@",NSStringFromCGPoint(_categoryTitle.center));
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    _backButton.highlighted = highlighted;
    _categoryImageView.highlighted = highlighted;
}
@end
