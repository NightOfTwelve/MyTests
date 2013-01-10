//
//  BTMoreCell.h
//  AABabyTing3
//
//  Created by Zero on 8/25/12.
//
//

#import <UIKit/UIKit.h>
#import "BTBaseCell.h"
@class FXLabel;
@interface BTMoreCell : BTBaseCell{
    UIButton            *_backButton;
}

@property (nonatomic,retain)	UIButton    *backButton;
@property (nonatomic,retain)	FXLabel		*myTextLabel;
@property (nonatomic,assign)    NSInteger   cellTag;

@end
