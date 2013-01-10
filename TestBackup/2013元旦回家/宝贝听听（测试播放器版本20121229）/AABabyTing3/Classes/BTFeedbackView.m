//
//  BTFeedbackView.m
//  AABabyTing3
//
//  Created by Zero on 9/11/12.
//
//

#import "BTFeedbackView.h"
#import "BTFeedbackAction.h"
#import "BTTextField.h"
#import "BTFeedbackSingletonAction.h"
#import "BTFeedbackRecords.h"

typedef enum _FocusText {
	FocusTextDefault = 0,
	FocusTextView = 1,
	FocusTextField = 2,
	FocusTextNone = 9
}FocusText;

const NSInteger				kTagSubmitButton = 7778;

@interface BTFeedbackView ()
<UITextFieldDelegate, UITextViewDelegate, UIGestureRecognizerDelegate>

@property (retain, nonatomic)	UITextView				*textView;
@property (retain, nonatomic)	BTTextField				*textField;
@property (retain, nonatomic)	UIButton				*submitButton;
@property (retain, nonatomic)	UITapGestureRecognizer	*tapGesture;
@property (retain, nonatomic)	NSMutableDictionary		*feedbackInfo;
@property (nonatomic)			FocusText				focus;

- (void)submitBtnClicked:(id)sender;

@end

@implementation BTFeedbackView
@synthesize textView, textField, submitButton, feedbackInfo, focus;

#pragma mark - Getter && Setter
- (void)setFocus:(FocusText)aFocus {	
	focus = aFocus;
	[self startViewAnimation];
}

#pragma mark - Button Event
- (void)submitBtnClicked:(id)sender {
	//显示发送成功
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发送成功"
													message:@"感谢您的反馈，我们会认真考虑您的意见。"
												   delegate:self
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
	
	NSString *content = [BTUtilityClass removeWhiteSpaceInString:self.textView.text];
	NSString *contract = [BTUtilityClass removeWhiteSpaceInString:self.textField.text];

	BTFeedbackRecord *record = [BTFeedbackRecord record];
	record.text = content;
	record.email = contract;
	CDLog(BTDFLAG_NEW_FEEDBACK,@"意见反馈：点击发送键");
	BTFeedbackSingletonAction *action = [BTFeedbackSingletonAction sharedInstance];
	[action addOneRecord:record];
	[action reportAllRecords];
	
	self.textView.text = @"";
	self.textField.text = @"";
	self.submitButton.enabled = NO;
}

#pragma mark - TapGestureEventHandler
- (void)tapTheView:(UITapGestureRecognizer *)tapGes {
//	if (self.focus == FocusTextField || self.focus == FocusTextView) {
//	DLog(@"tapGes = %@",tapGes);
//	UIView *view = [tapGes.view viewWithTag:kTagSubmitButton];
//	if (tapGes.view.tag == kTagSubmitButton) {
//		DLog(@"submit");
//		[self submitBtnClicked:nil];
//	}
	self.focus = FocusTextNone;
}

#pragma mark - Init UI
- (void)initUI {
	//设置背景
	NSString *path = [NSString stringWithFormat:@"%@/%@",[NSBundle mainBundle].resourcePath, @"feedback_bg.png"];
	UIImage *image = [UIImage imageWithContentsOfFile:path];
	[self setImage:image];
	
	//创建内容输入框
	textView = [[UITextView alloc] initWithFrame:CGRectMake(28, 134-41, 266, 84)];
	textView.delegate = self;
	textView.font = [UIFont systemFontOfSize:17];
	textView.returnKeyType = UIReturnKeyNext;
	textView.backgroundColor = [UIColor clearColor];
	[self addSubview:textView];
	
	//创建联系方式输入框
	textField = [[BTTextField alloc] initWithFrame:CGRectMake(28, 272-37, 266, 30)];
    textField.type = FeedBackTpe;
	textField.delegate = self;
	textField.font = [UIFont systemFontOfSize:17];
	textField.returnKeyType = UIReturnKeyDone;
	textField.backgroundColor = [UIColor clearColor];
    textField.placeholder = @"QQ/邮箱/电话等";
	[self addSubview:textField];
	
	//创建提交按钮
	self.submitButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	submitButton.tag = kTagSubmitButton;
	submitButton.frame = CGRectMake(223, 313-41, 80, 40);
	[submitButton addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
	submitButton.enabled = NO;
	NSString *btnPath = [NSString stringWithFormat:@"%@/%@",[NSBundle mainBundle].resourcePath, @"feedback_submit.png"];
	UIImage *btnImage = [UIImage imageWithContentsOfFile:btnPath];
	[submitButton setImage:btnImage forState:UIControlStateNormal];
	[self addSubview:submitButton];
	
	//添加点击手势
	self.tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTheView:)] autorelease];
	_tapGesture.numberOfTapsRequired = 1;
	_tapGesture.numberOfTouchesRequired = 1;
	_tapGesture.cancelsTouchesInView = NO;
	_tapGesture.delegate = self;
	[self addGestureRecognizer:_tapGesture];
}

#pragma mark - View Lifecycle

- (id)init {
	if (self = [super init]) {
		self.frame = CGRectMake(0, 20, 320, 328);
		self.backgroundColor = [UIColor clearColor];
		
		[self initUI];
		
		self.userInteractionEnabled = YES;
	}
	
	return (self);
}

- (void)dealloc {
	if (self.tapGesture != nil) {
		[self removeGestureRecognizer:self.tapGesture];
		self.tapGesture = nil;
	}
	[feedbackInfo release];
	[textView release];
	[textField release];
	[submitButton release];
	[super dealloc];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
	self.focus = FocusTextView;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
//	self.focus = FocusTextNone;
}

- (void)textViewDidChange:(UITextView *)textView {
	NSString *str = [BTUtilityClass removeWhiteSpaceInString:self.textView.text];
	self.submitButton.enabled = (str.length > 0);
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
	return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
	NSInteger number = [self.textView.text length];
    if (number > 200) {
        self.textView.text = [self.textView.text substringToIndex:200];
    }
    
    NSString *returnChar = [[NSString alloc]initWithFormat:@"%c",0x000A];
    if ([text isEqualToString:returnChar]) {
		[self.textView resignFirstResponder];
		[self.textField becomeFirstResponder];
    }
	[returnChar release];
    return YES;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
	self.focus = FocusTextField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
//	self.focus = FocusTextNone;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	NSInteger number = [self.textField.text length];
	if (number > 50 ){
        self.textField.text = [self.textField.text substringToIndex:50];
    }
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField {
//	[textField resignFirstResponder];
	self.focus = FocusTextNone;
	return YES;
}

#pragma mark - UIView动画
- (void)startViewAnimation {
	if (focus == FocusTextNone) {
		[textView resignFirstResponder];
		[textField resignFirstResponder];
	}
//	DLog(@"animation!!");
//	DLog(@"before:self.center=%@",NSStringFromCGPoint(self.center));
	[UIView animateWithDuration:.4f animations:^{
		CGFloat targetPos = 328.f/2 + 20.f;
		if (focus == FocusTextNone) {
			targetPos = 328.f/2 + 20.f;
		} else if (focus == FocusTextField) {
			targetPos = 328.f/2 - 80.f;
		} else if (focus == FocusTextView) {
			targetPos = 328.f/2;
		}
		self.center = CGPointMake(self.center.x, targetPos);
	} completion:^(BOOL f){
//		DLog(@"after:self.center=%@",NSStringFromCGPoint(self.center));
//		DLog(@"===============");		
	}];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
	// 过滤掉UIButton
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
}

@end
