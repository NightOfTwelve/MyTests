//
//  ViewController.h
//  TestLock
//
//  Created by Zero on 1/11/13.
//  Copyright (c) 2013 21kunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIButton *buttonA;
@property (retain, nonatomic) IBOutlet UIButton *buttonB;
- (IBAction)onClickedButton:(UIButton *)sender;

@end
