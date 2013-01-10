//
//  SHKOAuthSharer.m
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

#import "SHKOAuthSharer.h"
#import "SHKOAuthView.h"
#import "OAuthConsumer.h"


@implementation SHKOAuthSharer

@synthesize consumerKey, secretKey, authorizeCallbackURL;
@synthesize authorizeURL, requestURL, accessURL;
@synthesize consumer, requestToken, accessToken;
@synthesize signatureProvider;
@synthesize authorizeResponseQueryVars;


- (void)dealloc
{
	[consumerKey release];
	[secretKey release];
	[authorizeCallbackURL release];
	[authorizeURL release];
	[requestURL release];
	[accessURL release];
	[consumer release];
	[requestToken release];
	[accessToken release];
	[signatureProvider release];
	[authorizeResponseQueryVars release];
	
	[super dealloc];
}


- (BOOL)isNeedToRefreshTheToken
{
    NSString *shareID = [self sharerId];
    //2012.11.29 add nate 变量初始化
    NSString *DicKey = nil;
    if([shareID isEqualToString:@"SHKRenren"]){
        DicKey = RENREN_USER_STORE_EXPIRATION_DAT;
    }else if([shareID isEqualToString:@"SHKSina"]){
        DicKey = SINA_USER_STORE_EXPIRATION_DATE;
    }
    
    NSDate *expirationDate = [[NSUserDefaults standardUserDefaults]objectForKey:DicKey];
    if (expirationDate == nil)  return YES;
    
    BOOL boolValue = !(NSOrderedDescending == [expirationDate compare:[NSDate date]]);
    
    if (boolValue) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:DicKey];
        [SHK removeAuthValueForKey:USER_STORE_ACCESS_TOKEN forSharer:[self sharerId]];
    }
	
    return boolValue;
}

#pragma mark -
#pragma mark Authorization

- (BOOL)isAuthorized
{
	return [self restoreAccessToken];
}

- (void)promptAuthorization
{
    if (requestURL) {
        [self tokenRequest];
    }else{
        [self getOAuthAccessToken];
    }
}
#pragma mark -

- (NSURL*)generateURL:(NSString*)baseURL params:(NSDictionary*)params {
	if (params) {
		NSMutableArray* pairs = [NSMutableArray array];
		for (NSString* key in params.keyEnumerator) {
			NSString* value = [params objectForKey:key];
			NSString* escaped_value = (NSString *)CFURLCreateStringByAddingPercentEscapes(
																						  NULL, /* allocator */
																						  (CFStringRef)value,
																						  NULL, /* charactersToLeaveUnescaped */
																						  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
																						  kCFStringEncodingUTF8);
            
            [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
			[escaped_value release];
		}
		
		NSString* query = [pairs componentsJoinedByString:@"&"];
		NSString* url = [NSString stringWithFormat:@"%@?%@", baseURL, query];
		return [NSURL URLWithString:url];
	} else {
		return [NSURL URLWithString:baseURL];
	}
}

-(NSURL*)getOauthCodeUrl
{
    //https://api.weibo.com/oauth2/authorize
    DLog(@"!!!%@,",[self sharerId]);
    NSMutableDictionary* params;
    NSString *shareID = [self sharerId];
    if([shareID isEqualToString:@"SHKSina"]){ //新浪的认证的URL的后面参数
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
				  SHKSinaConsumerKey,              @"client_id",       //申请的appkey
				  @"token",                        @"response_type",   //access_token
				  SHKSinaOauthCallBackUrl,         @"redirect_uri",    //申请时的重定向地址
				  @"mobile",                       @"display",         //web页面的显示方式
				  nil];
    }else if([shareID isEqualToString:@"SHKRenren"]){//人人网的认证URL后面参数
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
				  SHKRenrenConsumerKey,                 @"client_id",       //申请的appkey
				  SHKRenrenOauthCallBackUrl,           @"redirect_uri",
				  @"token",                        @"response_type",
				  @"photo_upload",                        @"scope",
				  nil];
		//        url = [NSURL URLWithString:@"https://graph.renren.com/oauth/authorize?client_id=3111b4745daf43cf994cd0761090f54d&redirect_uri=http://graph.renren.com/oauth/login_success.html&response_type=token&scope=status_update"];
    }
    
    NSURL *url = [self generateURL:authorizeURL.absoluteString params:params];
	
	DLog(@"url= %@",url);
    return url;
}
//oauth2.0认证获取token
-(void)getOAuthAccessToken{
    
    NSURL *url = [self getOauthCodeUrl];
	
	SHKOAuthView *auth = [[SHKOAuthView alloc] initWithURL:url delegate:self];
	[[SHK currentHelper] showViewController:auth];
	[auth release];
    
}
#pragma mark -

#pragma mark Request

- (void)tokenRequest
{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
//    NSString *currentLanguage = [languages objectAtIndex:0];
//    if ([currentLanguage isEqualToString:@"zh-Hans"]) {
//        [[SHKActivityIndicator currentIndicator] displayActivity:SHKLocalizedString(@"连接中...")];
//    }else {
//        [[SHKActivityIndicator currentIndicator] displayActivity:SHKLocalizedString(@"Connecting...")];
//    }
	
    OAMutableURLRequest *oRequest = [[OAMutableURLRequest alloc] initWithURL:requestURL
																	consumer:consumer
																	   token:nil   // we don't have a Token yet
																	   realm:nil   // our service provider doesn't specify a realm
														   signatureProvider:signatureProvider];
	
    
	if ([requestURL.host isEqualToString:@"open.t.qq.com"]) {
        [oRequest setHTTPMethod:@"GET"];
        
        [oRequest prepare];
        
        NSString *urlParmas = [oRequest getURLParmas];
        
        NSString *newRequestURL = [NSString stringWithFormat:@"%@?%@",[requestURL URLStringWithoutQuery],urlParmas];
        
        [oRequest setURL:[NSURL URLWithString:newRequestURL]];
    }else {
        [oRequest setHTTPMethod:@"POST"];
	}
	[self tokenRequestModifyRequest:oRequest];
	
    OAAsynchronousDataFetcher *fetcher = [OAAsynchronousDataFetcher asynchronousFetcherWithRequest:oRequest
																						  delegate:self
																				 didFinishSelector:@selector(tokenRequestTicket:didFinishWithData:)
																				   didFailSelector:@selector(tokenRequestTicket:didFailWithError:)];
	[fetcher start];
	[oRequest release];
}

- (void)tokenRequestModifyRequest:(OAMutableURLRequest *)oRequest
{
	// Subclass to add custom paramaters and headers
}

- (void)tokenRequestTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	if (SHKDebugShowLogs) // check so we don't have to alloc the string with the data if we aren't logging
		SHKLog(@"tokenRequestTicket Response Body: %@", [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
	
	[[SHKActivityIndicator currentIndicator] hide];
	
	if (ticket.didSucceed)
	{
		NSString *responseBody = [[NSString alloc] initWithData:data
													   encoding:NSUTF8StringEncoding];
        //2012.11.29 nate add 内存泄漏
        OAToken *newToken  = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
		self.requestToken = newToken;
        [newToken release];
        //2012.11.29 nate end
		[responseBody release];
        
		[self tokenAuthorize];
	}
	
	else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
        NSString *currentLanguage = [languages objectAtIndex:0];
        if ([currentLanguage isEqualToString:@"zh-Hans"]) {
            [self tokenRequestTicket:ticket didFailWithError:[SHK error:SHKLocalizedString(@"从%@请求授权时遇到一个错误.", [self sharerTitle])]];
        }else {
            // TODO - better error handling here
            [self tokenRequestTicket:ticket didFailWithError:[SHK error:SHKLocalizedString(@"There was a problem requesting authorization from %@", [self sharerTitle])]];
        }
    }
}

- (void)tokenRequestTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error
{
	[[SHKActivityIndicator currentIndicator] hide];
	
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLanguage = [languages objectAtIndex:0];
    if ([currentLanguage isEqualToString:@"zh-Hans"]) {
        [[[[UIAlertView alloc] initWithTitle:@"请求错误"
                                     message:error!=nil?[error localizedDescription]:@"分享时出现一个错误."
                                    delegate:nil
                           cancelButtonTitle:@"关闭"
                           otherButtonTitles:nil] autorelease] show];
		
    }else {
        [[[[UIAlertView alloc] initWithTitle:SHKLocalizedString(@"Request Error")
                                     message:error!=nil?[error localizedDescription]:SHKLocalizedString(@"There was an error while sharing")
                                    delegate:nil
                           cancelButtonTitle:SHKLocalizedString(@"Close")
                           otherButtonTitles:nil] autorelease] show];
		
    }
}


#pragma mark Authorize

- (void)tokenAuthorize
{
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?oauth_token=%@", authorizeURL.absoluteString, requestToken.key]];
	
	SHKOAuthView *auth = [[SHKOAuthView alloc] initWithURL:url delegate:self];
	[[SHK currentHelper] showViewController:auth];
	[auth release];
}

- (void)tokenAuthorizeView:(SHKOAuthView *)authView didFinishWithSuccess:(BOOL)success queryParams:(NSMutableDictionary *)queryParams error:(NSError *)error
{
	[[SHK currentHelper] hideCurrentViewControllerAnimated:YES];
	
	if (!success)
	{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
        NSString *currentLanguage = [languages objectAtIndex:0];
        if ([currentLanguage isEqualToString:@"zh-Hans"]) {
            [[[[UIAlertView alloc] initWithTitle:@"授权错误"
                                         message:error!=nil?[error localizedDescription]:@"授权时出现了一个错误."
                                        delegate:nil
                               cancelButtonTitle:@"关闭"
                               otherButtonTitles:nil] autorelease] show];
        }else {
            [[[[UIAlertView alloc] initWithTitle:SHKLocalizedString(@"Authorize Error")
                                         message:error!=nil?[error localizedDescription]:SHKLocalizedString(@"There was an error while authorizing")
                                        delegate:nil
                               cancelButtonTitle:SHKLocalizedString(@"Close")
                               otherButtonTitles:nil] autorelease] show];
        }
	}
	
	else
	{
		self.authorizeResponseQueryVars = queryParams;
        
        if ([requestURL.host isEqualToString:@"api.t.sina.com.cn"]) {
            self.requestToken.pin = [NSString stringWithFormat:@"%@",[authorizeResponseQueryVars objectForKey:@"oauth_verifier"]]; //Add By DuJin,7.14,for Sina API.
        }else if ([requestURL.host isEqualToString:@"open.t.qq.com"]) {
            self.requestToken.pin = [NSString stringWithFormat:@"%@",[authorizeResponseQueryVars objectForKey:@"oauth_verifier"]]; //Add By DuJin,7.20,for Tencent API.
        }
        
        [self tokenAccess];
	}
}

- (void)tokenAuthorizeCancelledView:(SHKOAuthView *)authView
{
	[[SHK currentHelper] hideCurrentViewControllerAnimated:YES];
}


#pragma mark Access

- (void)tokenAccess
{
	[self tokenAccess:NO];
}

- (void)tokenAccess:(BOOL)refresh
{
	if (!refresh){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
        NSString *currentLanguage = [languages objectAtIndex:0];
        if ([currentLanguage isEqualToString:@"zh-Hans"]) {
            [[SHKActivityIndicator currentIndicator] displayActivity:SHKLocalizedString(@"授权中...")];
        }else {
            [[SHKActivityIndicator currentIndicator] displayActivity:SHKLocalizedString(@"Authenticating...")];
        }
    }
	
    OAMutableURLRequest *oRequest = [[OAMutableURLRequest alloc] initWithURL:accessURL
																	consumer:consumer
																	   token:(refresh ? accessToken : requestToken)
																	   realm:nil   // our service provider doesn't specify a realm
														   signatureProvider:signatureProvider]; // use the default method, HMAC-SHA1
    
    if ([accessURL.host isEqualToString:@"open.t.qq.com"]) {
        [oRequest setHTTPMethod:@"GET"];
        
        [oRequest prepare];
        
        NSString *urlParmas = [oRequest getURLParmas];
        
        NSString *newRequestURL = [NSString stringWithFormat:@"%@?%@",[accessURL URLStringWithoutQuery],urlParmas];
        
        [oRequest setURL:[NSURL URLWithString:newRequestURL]];
    }else {
        [oRequest setHTTPMethod:@"POST"];
	}
	
	[self tokenAccessModifyRequest:oRequest];
	
    OAAsynchronousDataFetcher *fetcher = [OAAsynchronousDataFetcher asynchronousFetcherWithRequest:oRequest
																						  delegate:self
																				 didFinishSelector:@selector(tokenAccessTicket:didFinishWithData:)
																				   didFailSelector:@selector(tokenAccessTicket:didFailWithError:)];
	[fetcher start];
	[oRequest release];
}

- (void)tokenAccessModifyRequest:(OAMutableURLRequest *)oRequest
{
	// Subclass to add custom paramaters or headers
}

- (void)tokenAccessTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	if (SHKDebugShowLogs) // check so we don't have to alloc the string with the data if we aren't logging
		SHKLog(@"tokenAccessTicket Response Body: %@", [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
	
	[[SHKActivityIndicator currentIndicator] hide];
	
	if (ticket.didSucceed)
	{
		NSString *responseBody = [[NSString alloc] initWithData:data
													   encoding:NSUTF8StringEncoding];
        //2012.11.29 nate add 内存泄漏
        OAToken *newToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
		self.accessToken = newToken;
        [newToken release];
		[responseBody release];
        //2012.11.29 nate end
		
        if ([accessURL.host isEqualToString:@"api.t.sina.com.cn"]) {
            self.accessToken.pin = [NSString stringWithFormat:@"%@",[authorizeResponseQueryVars objectForKey:@"oauth_verifier"]];  //Add by DuJin,7.14,for Sina API
        }if ([accessURL.host isEqualToString:@"open.t.qq.com"]) {
            self.accessToken.pin = [NSString stringWithFormat:@"%@",[authorizeResponseQueryVars objectForKey:@"oauth_verifier"]];  //Add by DuJin,7.20,for Tencent API
        }
        
		[self storeAccessToken];
		
		[self tryPendingAction];
	}
	
	
	else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
        NSString *currentLanguage = [languages objectAtIndex:0];
        if ([currentLanguage isEqualToString:@"zh-Hans"]) {
            // TODO - better error handling here
            [self tokenAccessTicket:ticket didFailWithError:[SHK error:SHKLocalizedString(@"从%@请求授权时出现了一个错误", [self sharerTitle])]];
        }else {
            // TODO - better error handling here
            [self tokenAccessTicket:ticket didFailWithError:[SHK error:SHKLocalizedString(@"There was a problem requesting access from %@", [self sharerTitle])]];
        }
    }
}

- (void)tokenAccessTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error
{
    DLog(@"error = %@",[error description]);
	[[SHKActivityIndicator currentIndicator] hide];
	
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLanguage = [languages objectAtIndex:0];
    if ([currentLanguage isEqualToString:@"zh-Hans"]) {
        [[[[UIAlertView alloc] initWithTitle:@"访问错误"
                                     message:error!=nil?[error localizedDescription]:@"分享时出现了一个错误."
                                    delegate:nil
                           cancelButtonTitle:@"关闭"
                           otherButtonTitles:nil] autorelease] show];
    }else {
        [[[[UIAlertView alloc] initWithTitle:SHKLocalizedString(@"Access Error")
                                     message:error!=nil?[error localizedDescription]:SHKLocalizedString(@"There was an error while sharing")
                                    delegate:nil
                           cancelButtonTitle:SHKLocalizedString(@"Close")
                           otherButtonTitles:nil] autorelease] show];
    }
}

- (void)storeAccessToken
{
	[SHK setAuthValue:accessToken.key
			   forKey:@"accessKey"
			forSharer:[self sharerId]];
	
	[SHK setAuthValue:accessToken.secret
			   forKey:@"accessSecret"
			forSharer:[self sharerId]];
	
	[SHK setAuthValue:accessToken.sessionHandle
			   forKey:@"sessionHandle"
			forSharer:[self sharerId]];
    
    [SHK setAuthValue:accessToken.pin
			   forKey:@"accessPin"
			forSharer:[self sharerId]];  //Add By DuJin,7.14,for Sina API, store the 'pin' value.
}

+ (void)deleteStoredAccessToken
{
	NSString *sharerId = [self sharerId];
	
	[SHK removeAuthValueForKey:@"accessKey" forSharer:sharerId];
	[SHK removeAuthValueForKey:@"accessSecret" forSharer:sharerId];
	[SHK removeAuthValueForKey:@"sessionHandle" forSharer:sharerId];
    [SHK removeAuthValueForKey:USER_STORE_ACCESS_TOKEN forSharer:sharerId];
}

+ (void)logout
{
	[self deleteStoredAccessToken];
	
	// Clear cookies (for OAuth, doesn't affect XAuth)
	// TODO - move the authorizeURL out of the init call (into a define) so we don't have to create an object just to get it
	SHKOAuthSharer *sharer = [[self alloc] init];
	if (sharer.authorizeURL)
	{
		NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
		NSArray *cookies = [storage cookiesForURL:sharer.authorizeURL];
		for (NSHTTPCookie *each in cookies)
		{
			[storage deleteCookie:each];
		}
	}
	[sharer release];
}

- (BOOL)restoreAccessToken
{
	self.consumer = [[[OAConsumer alloc] initWithKey:consumerKey secret:secretKey] autorelease];
	
	if (accessToken != nil)
		return YES;
	
    //oauth2.0的accessToken
    if ([SHK getAuthValueForKey:USER_STORE_ACCESS_TOKEN forSharer:[self sharerId]] && ![self isNeedToRefreshTheToken]) {
        return YES;
    }
	
	NSString *key = [SHK getAuthValueForKey:@"accessKey"
								  forSharer:[self sharerId]];
	
	NSString *secret = [SHK getAuthValueForKey:@"accessSecret"
									 forSharer:[self sharerId]];
	
	NSString *sessionHandle = [SHK getAuthValueForKey:@"sessionHandle"
											forSharer:[self sharerId]];
	
    NSString *pin = [SHK getAuthValueForKey:@"accessPin"
								  forSharer:[self sharerId]];  //Add by DuJin,7.14, for Sina API get the value of 'pin'
    
	if (key != nil && secret != nil)
	{
		self.accessToken = [[[OAToken alloc] initWithKey:key secret:secret] autorelease];
		
		if (sessionHandle != nil)
			accessToken.sessionHandle = sessionHandle;
		if (pin != nil) {
            accessToken.pin = pin; //Add by DuJin,7.14, for Sina API set the value of 'accessToken.pin'
        }
		return accessToken != nil;
	}
	
	return NO;
}


#pragma mark Expired

- (void)refreshToken
{
	self.pendingAction = SHKPendingRefreshToken;
	[self tokenAccess:YES];
}

#pragma mark -
#pragma mark Pending Actions
#pragma mark -
#pragma mark Pending Actions

- (void)tryPendingAction
{
	switch (pendingAction)
	{
		case SHKPendingRefreshToken:
			[self tryToSend]; // try to resend
			break;
			
		default:
			[super tryPendingAction];
	}
}


@end
