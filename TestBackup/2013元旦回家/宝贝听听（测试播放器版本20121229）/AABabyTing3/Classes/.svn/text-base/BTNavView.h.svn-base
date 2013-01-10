//
//  BTNavView.h
//  AABabyTing3
//
//  Created by Wang Neo on 12-9-11.
//
//

#import <UIKit/UIKit.h>
#import "FXLabel.h"
#import "BTUtilityClass.h"
#import "BTNavButton.h"

@protocol BTNavLabelPress <NSObject>

-(void)labelPress:(id)sender;

@end

@interface BTNavView : UIView <UIGestureRecognizerDelegate>{
    UIImageView *_bgView;
    FXLabel *_titleLabel;
    BTNavButton *_backButton;
    BTNavButton *_playingButton;
    BTNavButton *_editButton;
    BTNavButton *_playListButton;
    id<BTNavLabelPress>   _delegate;

}
@property (assign)id<BTNavLabelPress> delegate;
@property (nonatomic,retain)UIImageView *bgView;
@property (nonatomic,retain)FXLabel *titleLabel;
@property (nonatomic,retain)BTNavButton *backButton;
@property (nonatomic,retain)BTNavButton *playingButton;
@property (nonatomic,retain)BTNavButton *editButton;
@property (nonatomic,retain)BTNavButton *playListButton;


@end
