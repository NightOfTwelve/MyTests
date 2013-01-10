//
//  SHKTwitterAuthView.m
//  ShareKit
//
//  Created by Nathan Weiner on 6/21/10.

//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//

#import "SHKOAuthView.h"
#import "SHK.h"
#import "SHKOAuthSharer.h"
#import "SHKSinaUtils.h"
#import "SHKSina.h"
#import "SHKRenren.h"

@implementation SHKOAuthView

@synthesize webView, delegate, spinner;

- (void)dealloc
{
	[webView release];
	[delegate release];
	[spinner release];
	[super dealloc];
}

- (id)initWithURL:(NSURL *)authorizeURL delegate:(id)d
{
    if ((self = [super initWithNibName:nil bundle:nil]))
	{
        DLog(@"webView init");
		[self.navigationItem setLeftBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																								 target:self
																								 action:@selector(cancel)] autorelease] animated:NO];
		
		self.delegate = d;
        //2012.11.29 nate add 内存泄漏
        UIWebView *newWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
		self.webView = newWebView;
        [newWebView release];
        //2012.11.29 nate end
		webView.delegate = self;
		webView.scalesPageToFit = YES;
		webView.dataDetectorTypes = UIDataDetectorTypeNone;
        //2012.12.03 nate del 对象提前释放错误
		//[webView release];
		webView .tag = 111;
		[webView loadRequest:[NSURLRequest requestWithURL:authorizeURL]];
		
    }
    return self;
}

- (void)loadView
{
	self.view = webView;
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	
	// Remove the SHK view wrapper from the window
	[[SHK currentHelper] viewWasDismissed];
}

- (NSString *) getStringFromUrl: (NSString*) url needle:(NSString *) needle {
	NSString * str = nil;
	NSRange start = [url rangeOfString:needle];
	if (start.location != NSNotFound) {
		NSRange end = [[url substringFromIndex:start.location+start.length] rangeOfString:@"&"];
		NSUInteger offset = start.location+start.length;
		str = end.location == NSNotFound
		? [url substringFromIndex:offset]
		: [url substringWithRange:NSMakeRange(offset, end.location)];
		str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	}
	return str;
}

//剥离出url中的access_token的值
- (void) dialogDidSucceed:(NSURL*)url {
    NSString *q = [url absoluteString];
    NSString *sharedId = [delegate sharerId];
    NSString *token = [self getStringFromUrl:q needle:@"access_token="];
    
    //用户点取消 error_code=21330
    NSString *errorCode = [self getStringFromUrl:q needle:@"error_code="];
    if (errorCode != nil && [errorCode isEqualToString: @"21330"]) {
        DLog(@"Oauth canceled");
    }
    
	//    NSString *refreshToken  = [self getStringFromUrl:q needle:@"refresh_token="];
    NSString *expTime       = [self getStringFromUrl:q needle:@"expires_in="];
	//    NSString *uid           = [self getStringFromUrl:q needle:@"uid="];
	//    NSString *remindIn      = [self getStringFromUrl:q needle:@"remind_in="];
    
	//    [[NSUserDefaults standardUserDefaults] setObject:token forKey:USER_STORE_ACCESS_TOKEN];
    if([sharedId isEqualToString:@"SHKSina"]){
        [SHK setAuthValue:token forKey:USER_STORE_ACCESS_TOKEN forSharer:NSStringFromClass([SHKSina class])];
    }else if([sharedId isEqualToString:@"SHKRenren"]){
        [SHK setAuthValue:token forKey:USER_STORE_ACCESS_TOKEN forSharer:NSStringFromClass([SHKRenren class])];
    }
    
    
    NSDate *expirationDate =nil;
    //DLog(@"jtone \n\ntoken=%@\nrefreshToken=%@\nexpTime=%@\nuid=%@\nremindIn=%@\n\n",token,refreshToken,expTime,uid,remindIn);
    if (expTime != nil) {
        int expVal = [expTime intValue]-3600;
        if (expVal == 0)
        {
            
        } else {
            expirationDate = [NSDate dateWithTimeIntervalSinceNow:expVal];
            if([sharedId isEqualToString:@"SHKSina"]){
                [[NSUserDefaults standardUserDefaults]setObject:expirationDate forKey:SINA_USER_STORE_EXPIRATION_DATE];
            }else if([sharedId isEqualToString:@"SHKRenren"]){
                [[NSUserDefaults standardUserDefaults]setObject:expirationDate forKey:RENREN_USER_STORE_EXPIRATION_DAT];
            }
            [[NSUserDefaults standardUserDefaults] synchronize];
			//DLog(@"jtone time = %@",expirationDate);
        }
    }
    if (token) {
        [[SHK currentHelper] hideCurrentViewControllerAnimated:YES];
        [delegate tryPendingAction];
    }
}

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
	//    DLog(@"tag = %d",aWebView.tag);
	//    DLog(@"startLoadWithRequest!!!");
	//    if(!a){
	//        a = YES;
	//    }else {
	//        return YES;
	//    }
	//    DLog(@"request.URL.absoluteString = %@",request.URL.absoluteString);
	//    DLog(@"delegate authorizeCallbackURL = %@",[delegate authorizeCallbackURL]);
    
    NSURL *url = [request URL];
    DLog(@"webview's url = %@",url);
	NSArray *array = [[url absoluteString] componentsSeparatedByString:@"#"];
	if ([array count]>1) {
		[self dialogDidSucceed:url];
		return NO;
	}
	if ([request.URL.absoluteString rangeOfString:[delegate authorizeCallbackURL].absoluteString].location != NSNotFound) {
      	// Get query
		NSMutableDictionary *queryParams = nil;
		if (request.URL.query != nil)
		{
			queryParams = [NSMutableDictionary dictionaryWithCapacity:0];
			NSArray *vars = [request.URL.query componentsSeparatedByString:@"&"];
			NSArray *parts;
			for(NSString *var in vars)
			{
				parts = [var componentsSeparatedByString:@"="];
				if (parts.count == 2)
					[queryParams setObject:[parts objectAtIndex:1] forKey:[parts objectAtIndex:0]];
			}
		}
		
		[delegate tokenAuthorizeView:self didFinishWithSuccess:YES queryParams:queryParams error:nil];
		self.delegate = nil;
		
		return NO;
	}
	
	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    DLog(@"webViewDidStartLoad");
	[self startSpinner];
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
    DLog(@"webViewDidFinishLoad");
	[self stopSpinner];
	
	// Extra sanity check for Twitter OAuth users to make sure they are using BROWSER with a callback instead of pin based auth
	if ([webView.request.URL.host isEqualToString:@"twitter.com"] && [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('oauth_pin').innerHTML"].length) {
		[delegate tokenAuthorizeView:self didFinishWithSuccess:NO queryParams:nil error:[SHK error:@"Your SHKTwitter config is incorrect.  You must set your application type to Browser and define a callback url.  See SHKConfig.h for more details"]];
        //DLog(@" webViewDidFinishLoad error");
    }
	//    else if ([webView.request.URL.host isEqualToString:@"api.weibo.com"]) {
	//        NSMutableDictionary *queryParams = nil;
	//        queryParams = [NSMutableDictionary dictionaryWithCapacity:0];
	//
	//        NSString *oauth_verifier = [SHKSinaUtils getOAuthVerifier:webView];
	//
	//        if (oauth_verifier) {
	//            [queryParams setObject:oauth_verifier forKey:@"oauth_verifier"];
	//
	//            [delegate tokenAuthorizeView:self didFinishWithSuccess:YES queryParams:queryParams error:nil];
	//            self.delegate = nil;
	//        }
	//
	//    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    DLog(@"didFailLoadWithError");
	if ([error code] != NSURLErrorCancelled && [error code] != 102 && [error code] != NSURLErrorFileDoesNotExist)
	{
		[self stopSpinner];
		[delegate tokenAuthorizeView:self didFinishWithSuccess:NO queryParams:nil error:error];
	}
}

- (void)startSpinner
{
	if (spinner == nil)
	{
		self.spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
		UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:spinner];
		[self.navigationItem setRightBarButtonItem:right animated:NO];
		[right release];
		spinner.hidesWhenStopped = YES;
		[spinner release];
	}
	
	[spinner startAnimating];
}

- (void)stopSpinner
{
	[spinner stopAnimating];
}


#pragma mark -

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	    return [self.parentViewController.parentViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
    //return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)cancel
{
	[delegate tokenAuthorizeCancelledView:self];
	[[SHK currentHelper] hideCurrentViewControllerAnimated:YES];
}

@end
