//
//  BTWebView.m
//  AABabyTing3
//
//  Created by Tiny on 12-10-15.
//
//

#import "BTWebView.h"

@implementation BTWebView
@synthesize webView = _webView;
@synthesize waiting = _waiting;
@synthesize bIsNeedToShowWaiting = _bIsNeedToShowWaiting;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {        
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _webView.scalesPageToFit = YES;
        _webView.delegate = self;
        [self addSubview:_webView];
        
        //添加进入应用失去焦点时的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive:) name:@"UIApplicationWillResignActiveNotification" object:nil];
        _bIsNeedToShowWaiting = YES;
    }
    return self;
}
//加载web页Url
-(void)loadWebRequest:(NSURL *)url{
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
}
//显示等待
-(void)showWaiting{
    if (!_waiting) {
        self.waiting = [MBProgressHUD showHUDAddedTo:self animated:YES];
    }
}
//隐藏等待
-(void)hideWaiting{
    if (_waiting) {
        [_waiting removeFromSuperview];
        _waiting = nil;
    }
}
//失去焦点时的处理
-(void)willResignActive:(id)sender{
    if (!_webView.isLoading ) {
        [self hideWaiting];
    }
}

#pragma mark -
#pragma UIWebView delegate

- (void)webViewDidStartLoad:(UIWebView *)webView{
    if (_bIsNeedToShowWaiting) {
        [self showWaiting];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self hideWaiting];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    [self hideWaiting];
    NSString *errorString = nil;
    switch (error.code) {
        case 101://超时
            errorString = @"打不开该网页,因为它无法连接到服务器。";
            break;
        case -1009://没有网络
        case -1004:
            errorString = @"打不开该网页,因为它尚未接入互联网。";
            break;
        default:
            break;
    }
    
    if(errorString && !bIsShowingAlert){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法打开网页"
                                                        message:errorString
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        bIsShowingAlert = YES;
    }

}
//避免多次弹出提示框
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    bIsShowingAlert = NO;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_webView release];
    [_waiting release];
    [super dealloc];
}

@end
