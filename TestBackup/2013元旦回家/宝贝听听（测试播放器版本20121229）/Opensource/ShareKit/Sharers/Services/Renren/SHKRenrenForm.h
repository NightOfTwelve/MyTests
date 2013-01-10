//
//  SHKRenrenForm.h
//  BabyTing
//
//  Created by Neo Wang on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHKRenrenForm : UIViewController <UITextViewDelegate>{
    id delegate;
	UITextView *textView;
	UILabel *counter;
//    UIImageView *imageView;
	BOOL hasAttachment;
	UILabel *_userNickNameLabel;
}

@property (nonatomic, retain) UILabel *userNickNameLabel;
@property (nonatomic, retain) id delegate;
@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) UILabel *counter;
//@property (nonatomic, retain) UIImageView *imageView;
@property BOOL hasAttachment;
- (void)layoutCounter;

@end
