//
//  BTSearchView.m
//  AABabyTing3
//
//  Created by Tiny on 12-9-24.
//
//

#import "BTSearchView.h"



@implementation BTSearchView
@synthesize delegate = _delegate;

-(void)dealloc{
    [barBgView release];
    [inputField release];
    [clearButton release];
    [cancelButton release];
    [maskView release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, WINDOW_HEIGHT)];
        maskView.backgroundColor = [UIColor blackColor];
        maskView.alpha = 0.5;
        [self addSubview:maskView];
        maskView.hidden = YES;

        
        UIImageView *cellBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_cell_bg.png"]];
        cellBgView.frame = CGRectMake(0, 61,320,57);
        [self addSubview:cellBgView];
        [cellBgView release];
        
        //替换掉UIImage拉伸的5.0的api
//        barBgView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"search_bar_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 40, 1, 20)]];
        UIImage *image = [[UIImage imageNamed:@"search_bar_bg.png"] stretchableImageWithLeftCapWidth:40 topCapHeight:1];
        barBgView = [[UIImageView alloc] initWithImage:image];
        barBgView.frame = CGRectMake(20, 61+10, 280, 36);
        barBgView.tag = Tag_Search_Bar_Bg;
        [self addSubview:barBgView];
        
        inputField = [[BTTextField alloc] initWithFrame:CGRectMake(50, 61+16, 230, 30)];
        inputField.type = SearchType;
        inputField.placeholder = @"输入想听的故事吧";
        inputField.delegate = self;
        inputField.font = [UIFont boldSystemFontOfSize:20];
        inputField.textColor = [UIColor colorWithRed:210.0/255.0 green:163.0/255.0 blue:40.0/255.0 alpha:1.0f];
        inputField.returnKeyType = UIReturnKeySearch;
        inputField.tag = Tag_UItextfield;
        [self addSubview:inputField];
        
        clearButton = [[UIButton alloc] init];
        [clearButton setFrame:CGRectMake(202, 61+7, 44, 44)];
        [clearButton setImage:[UIImage imageNamed:@"search_bar_clear_btn.png"] forState:UIControlStateNormal];
        [clearButton addTarget:self action:@selector(clearButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        clearButton.tag = Tag_Clear_Button;
        [self addSubview:clearButton];
        clearButton.hidden = YES;
        
        cancelButton = [[UIButton alloc] init];
        [cancelButton setFrame:CGRectMake(240, 61 +7, 77, 44)];
        [cancelButton setImage:[UIImage imageNamed:@"search_bar_cancel_btn.png"] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        cancelButton.tag = Tag_Cancel_Button;
        [self addSubview:cancelButton];
        cancelButton.hidden = YES;
        
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFileTextDidChange) name:UITextFieldTextDidChangeNotification object:nil];
    }
    return self;
}

-(void)textFileTextDidChange{
    
//    NSString *searchKey = [inputField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([inputField.text length] > 50) {
        inputField.text = [inputField.text substringToIndex:50];
    }
    
    if ([inputField.text length] > 0) {
        clearButton.hidden = NO;
    }else{
        clearButton.hidden = YES;
    }
}

-(void)clearButtonPressed:(id)sender{
    
    if (inputField.text) {
        inputField.text = @"";
        clearButton.hidden = YES;
    }
}

-(void)cancelButtonPressed:(id)sender{
    
    if (_delegate && [_delegate respondsToSelector:@selector(searchViewDisappear:)]) {
        [_delegate searchViewDisappear:nil];
    }
      inputField.text = @"";

    [inputField resignFirstResponder];
    [self endSearchAnimation];

}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (_delegate && [_delegate respondsToSelector:@selector(searchViewAppear)]) {
        [_delegate searchViewAppear];
    }

    [self beginSearchAnimation:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[BTRQDReport reportUserAction:EventCategoryLayerSearchButtonClicked];
    if (_delegate && [_delegate respondsToSelector:@selector(searchViewDisappear:)]) {
        [_delegate searchViewDisappear:inputField.text];
    }
    [textField resignFirstResponder];
    [self endSearchAnimation];

 
    return YES;
}

- (void)setSearchState:(NSString *)str{
    inputField.text = str;
    barBgView.frame = CGRectMake(20, 61+10, 280, 36);
    [inputField setFrame:CGRectMake(50, 61+16, 215, 30)];
    cancelButton.hidden = YES;
    clearButton.frame =CGRectMake(200+58, 61+7, 44, 44);
    clearButton.hidden = NO;
}

- (NSString *)textFieldContent{
    return inputField.text;
}

- (void)endSearchAnimation{
    cancelButton.hidden = YES;
    clearButton.hidden = YES;
    maskView.hidden = YES;
    [UIView animateWithDuration:0.3
                     animations:^{barBgView.frame = CGRectMake(20, 61+10, 280, 36);}
                     completion:^(BOOL finished){
                         cancelButton.hidden = YES;
                     }];
    [inputField setFrame:CGRectMake(50, 61+16, 215, 30)];
    
    
}
- (void)beginSearchAnimation:(UITextField *)textField{
    clearButton.hidden = YES;
    clearButton.frame =CGRectMake(205, 61+7, 44, 44);
    maskView.hidden = NO;
    [UIView animateWithDuration:0.3
                     animations:^{barBgView.frame = CGRectMake(20, 61+10, 225, 36);}
                     completion:^(BOOL finished){
                         cancelButton.hidden = NO;
                         if(textField.text.length>0){
                             clearButton.hidden = NO;
                         }
                     }];
    [inputField setFrame:CGRectMake(50, 61+16, 165, 30)];

}
@end
