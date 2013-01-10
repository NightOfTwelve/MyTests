//
//  BTSearchView.h
//  AABabyTing3
//
//  Created by Tiny on 12-9-24.
//
//

#import <UIKit/UIKit.h>
#import "BTTextField.h"

#define Tag_UItextfield 800
#define Tag_Clear_Button 801
#define Tag_Cancel_Button 802
#define Tag_Search_Bar_Bg 803

@protocol searchDelegate <NSObject>
-(void)searchViewAppear;
-(void)searchViewDisappear:(NSString *)keyWord;
@end

@interface BTSearchView : UIView<UITextFieldDelegate,UIGestureRecognizerDelegate>{
    
    UIImageView *barBgView;
    BTTextField *inputField;
    UIButton *clearButton;
    UIButton *cancelButton;
    UIView *maskView;
    id<searchDelegate> _delegate;
}


@property (nonatomic,assign) id<searchDelegate> delegate;



- (void)setSearchState:(NSString *)str;
- (NSString *)textFieldContent;
-(void)cancelButtonPressed:(id)sender;
- (void)endSearchAnimation;
- (void)beginSearchAnimation:(UITextField *)textField;
@end
