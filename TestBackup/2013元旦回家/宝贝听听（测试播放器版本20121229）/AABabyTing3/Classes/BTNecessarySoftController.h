//
//  BTNecessarySoftController.h
//  AABabyTing3
//
//  Created by Tiny on 12-9-29.
//
//

#import <UIKit/UIKit.h>
#import "BTListViewController.h"
#import "BTWebView.h"

@interface BTNecessarySoftController : BTListViewController{
    
    BTWebView *_softwareWeb;
}

@property (nonatomic,retain) UIView *softwareWeb;

-(void)openWithHtmlFile:(NSString *)htmlName;

@end
