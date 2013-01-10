//
//  SHKTencentForm.m
//  ShareKit
//
//  Created by K032 on 11-7-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SHKTencentForm.h"
#import "SHK.h"
#import "SHKTencent.h"

@implementation SHKTencentForm

@synthesize delegate;
@synthesize textView;
@synthesize counter;
@synthesize imageView;
@synthesize hasAttachment;

- (void)dealloc 
{
	[delegate release];
	[textView release];
    [imageView release];
	[counter release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
	{
        //2012.11.29 nate add 内存泄漏
        UIImageView *newImageView = [[UIImageView alloc] init];
        self.imageView = newImageView;
        [newImageView release];
        //2012.11.29 nate end
        ifFollowUs = YES;
    }
    return self;
}

- (void)segmentChanged:(id)sender {
    if ([sender selectedSegmentIndex] == 0) {
        [[SHK currentHelper] hideCurrentViewControllerAnimated:YES];
    }else if ([sender selectedSegmentIndex] == 1) {
        [[[[UIAlertView alloc] initWithTitle:@"解除绑定"
                                     message:@"你确定要解除绑定吗?"
                                    delegate:self
                           cancelButtonTitle:@"取消"
                           otherButtonTitles:@"解除绑定",nil] autorelease] show];
    }else if ([sender selectedSegmentIndex] == 2) {
        if (textView.text.length > (hasAttachment?115:140))
        {
            [[[[UIAlertView alloc] initWithTitle:@"信息过长."
                                         message:@"腾讯微博最多只能输入140个字."
                                        delegate:nil
                               cancelButtonTitle:@"关闭"
                               otherButtonTitles:nil] autorelease] show];
            return;
        }else if (textView.text.length == 0)
        {
            [[[[UIAlertView alloc] initWithTitle:@"信息为空."
                                         message:@"信息不能为空."
                                        delegate:nil
                               cancelButtonTitle:@"关闭"
                               otherButtonTitles:nil] autorelease] show];
            return;
        }else {
            [[SHK currentHelper] hideCurrentViewControllerAnimated:YES];
            [(SHKTencent *)delegate sendForm:self];
            if (ifFollowUs) {
                [(SHKTencent *)delegate followMe];   //一键关注
            }
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 1) {
        [[SHK currentHelper] hideCurrentViewControllerAnimated:YES];
		[SHK logoutOfAll];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(keyboardWillShow:) name: UIKeyboardWillShowNotification object:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
	//2012.11.29 nate add 内存泄漏
    UITextView *newTextView = [[UITextView alloc] initWithFrame:self.view.bounds];
    self.textView = newTextView;
    [newTextView release];
    //2012.11.29 nate end
    
	textView.delegate = self;
	textView.font = [UIFont systemFontOfSize:15];
	//textView.contentInset = UIEdgeInsetsMake(5,5,0,0);
	textView.backgroundColor = [UIColor whiteColor];	
	textView.autoresizesSubviews = YES;
	textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [textView becomeFirstResponder];
	
	[self.view addSubview:textView];
    [textView release];
    
    if (self.imageView.image != nil) {
        [self.view addSubview:imageView];
        [imageView release];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];	
	
	//[self.textView becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];	
	
	// Remove observers
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self name: UIKeyboardWillShowNotification object:nil];
	
	// Remove the SHK view wrapper from the window
	[[SHK currentHelper] viewWasDismissed];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    //return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)keyboardWillShow:(NSNotification *)notification
{	
	CGRect keyboardFrame;
	CGFloat keyboardHeight;
	
	// 3.2 and above
	/*if (UIKeyboardFrameEndUserInfoKey)
	 {		
	 [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];		
	 if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown) 
	 keyboardHeight = keyboardFrame.size.height;
	 else
	 keyboardHeight = keyboardFrame.size.width;
	 }
	 
	 // < 3.2
	 else 
	 {*/
	[[notification.userInfo valueForKey:UIKeyboardBoundsUserInfoKey] getValue:&keyboardFrame];
	keyboardHeight = keyboardFrame.size.height;
	//}
	
	// Find the bottom of the screen (accounting for keyboard overlay)
	// This is pretty much only for pagesheet's on the iPad
	UIInterfaceOrientation orient = [[UIApplication sharedApplication] statusBarOrientation];
	BOOL inLandscape = orient == UIInterfaceOrientationLandscapeLeft || orient == UIInterfaceOrientationLandscapeRight;
	BOOL upsideDown = orient == UIInterfaceOrientationPortraitUpsideDown || orient == UIInterfaceOrientationLandscapeRight;
	
	CGPoint topOfViewPoint = [self.view convertPoint:CGPointZero toView:nil];
	CGFloat topOfView = inLandscape ? topOfViewPoint.x : topOfViewPoint.y;
	
	CGFloat screenHeight = inLandscape ? [[UIScreen mainScreen] applicationFrame].size.width : [[UIScreen mainScreen] applicationFrame].size.height;
	
	CGFloat distFromBottom = screenHeight - ((upsideDown ? screenHeight - topOfView : topOfView ) + self.view.bounds.size.height) + ([UIApplication sharedApplication].statusBarHidden || upsideDown ? 0 : 20);							
	CGFloat maxViewHeight = self.view.bounds.size.height - keyboardHeight + distFromBottom;
    
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2, 30)];        
    [segmentControl insertSegmentWithTitle:@"取消" atIndex:0 animated:YES];
    [segmentControl insertSegmentWithTitle:@"解除绑定" atIndex:1 animated:YES];
    [segmentControl insertSegmentWithTitle:@"发送" atIndex:2 animated:YES];
    [segmentControl setMomentary:YES];
    [segmentControl setMultipleTouchEnabled:YES];
    [segmentControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    [segmentControl setSegmentedControlStyle:UISegmentedControlStyleBar];
    
    UIBarButtonItem *itemL = [[UIBarButtonItem alloc] initWithCustomView:segmentControl];
    [segmentControl release];
    
    self.navigationItem.leftBarButtonItem = itemL;
    [itemL release];
    
    UIButton *followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [followBtn setFrame:CGRectMake(0, 0, self.view.frame.size.width/2, 30)];
    [followBtn setFrame:CGRectMake(0, 0, 74, 30)];
    //[followBtn setTitle:@"FollowMe(1)" forState:UIControlStateNormal];
    [followBtn setImage:[UIImage imageNamed:@"CheckboxDone.png"] forState:UIControlStateNormal];
    [followBtn addTarget:self action:@selector(clickFollowBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *itemR = [[UIBarButtonItem alloc] initWithCustomView:followBtn];
    
    self.navigationItem.rightBarButtonItem = itemR;
    [itemR release];
	
	textView.frame = CGRectMake(0,0,self.view.bounds.size.width ,maxViewHeight - 25);
    
    if (self.imageView.image != nil) {
        imageView.frame = CGRectMake(5, maxViewHeight - 40, 38 * (imageView.image.size.width > imageView.image.size.height ? imageView.image.size.width/imageView.image.size.height:imageView.image.size.height/imageView.image.size.width), 38);
    }
    
    [self layoutCounter];
}

- (void)clickFollowBtn:(id)sender {
    UIButton *button = (UIButton*)sender;
    if (ifFollowUs) {
        ifFollowUs = NO;
        //[button setTitle:@"FollowMe(0)" forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"CheckboxNone.png"] forState:UIControlStateNormal];
    }else {
        ifFollowUs = YES;
        //[button setTitle:@"FollowMe(1)" forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"CheckboxDone.png"] forState:UIControlStateNormal];
    }
}

#pragma mark -

- (void)updateCounter
{
	if (counter == nil)
	{
        //2012.11.29 nate add 内存泄漏
        UILabel *newLabel =[[UILabel alloc] initWithFrame:CGRectZero];
		self.counter = newLabel;
        [newLabel release];
        //2012.11.29 nate end
        
		counter.backgroundColor = [UIColor clearColor];
		counter.opaque = NO;
		counter.font = [UIFont boldSystemFontOfSize:18];
		counter.textAlignment = UITextAlignmentRight;
		
		counter.autoresizesSubviews = YES;
		counter.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
		
		[self.view addSubview:counter];
		[self layoutCounter];
		
		[counter release];
	}
	
	int count = (hasAttachment?115:140) - textView.text.length;
	counter.text = [NSString stringWithFormat:@"还能输入%@%i 字", hasAttachment ? @"":@"" , count];
	counter.textColor = count >= 0 ? [UIColor blackColor] : [UIColor redColor];
}

- (void)layoutCounter
{
	counter.frame = CGRectMake(textView.bounds.size.width-150-15,
							   textView.bounds.size.height-15,
							   150,
							   40);
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
	[self updateCounter];
}

- (void)textViewDidChange:(UITextView *)textView
{
	[self updateCounter];	
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
	[self updateCounter];
}

@end
