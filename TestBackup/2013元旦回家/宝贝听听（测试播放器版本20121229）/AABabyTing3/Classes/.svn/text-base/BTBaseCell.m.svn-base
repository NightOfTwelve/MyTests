//
//  BTBaseCell.m
//  AABabyTing3
//
//  Created by Dora on 12-12-14.
//
//

#import "BTBaseCell.h"
#import "BTImportConstant.h"
@implementation BTBaseCell
@synthesize baseNetImageView = _baseNetImageView;

- (void)dealloc{
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

- (BTNetImageView *)baseNetImageView{
    _baseNetImageView = (BTNetImageView  *)[self viewWithTag:TAG_NetImage];
    return _baseNetImageView;
}

@end
