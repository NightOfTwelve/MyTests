//
//  BTWebView.h
//  AABabyTing3
//
//  Created by Tiny on 12-10-15.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface BTWebView : UIView<UIWebViewDelegate>{
    UIWebView *_webView;
    BOOL bIsShowingAlert;
    MBProgressHUD *_waiting;
    BOOL _bIsNeedToShowWaiting;
}

@property (nonatomic,retain) UIWebView *webView;
@property (nonatomic,retain) MBProgressHUD *waiting;
@property (nonatomic,assign) BOOL bIsNeedToShowWaiting;

-(void)loadWebRequest:(NSURL *)url;
-(void)showWaiting;
-(void)hideWaiting;

@end
