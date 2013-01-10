//
//  SHKSina.m
//  ShareKit
//
//  Created by K032 on 11-7-7.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SHKSina.h"
#import "ASIFormDataRequest.h"
#import "CJSONDeserializer.h"
@implementation SHKSina

@synthesize xAuth;

- (id)init
{
	if (self = [super init])
	{	
		// OAUTH		
		self.consumerKey = SHKSinaConsumerKey;		
		self.secretKey = SHKSinaSecret;
 		self.authorizeCallbackURL = [NSURL URLWithString:SHKSinaCallbackUrl];// HOW-TO: In your Sina application settings, use the "Callback URL" field.  If you do not have this field in the settings, set your application type to 'Browser'.
		
		// XAUTH
		self.xAuth = SHKSinaUseXAuth?YES:NO;
		
		
		// -- //
		
		
		// You do not need to edit these, they are the same for everyone
//	    self.authorizeURL = [NSURL URLWithString:@"http://api.t.sina.com.cn/oauth/authorize"];
//	    self.requestURL = [NSURL URLWithString:@"http://api.t.sina.com.cn/oauth/request_token"];
//	    self.accessURL = [NSURL URLWithString:@"http://api.t.sina.com.cn/oauth/access_token"]; 
        
        
        self.authorizeURL = [NSURL URLWithString:@"https://api.weibo.com/oauth2/authorize"];
        self.requestURL = nil;
        self.accessURL = nil;
	}	
	return self;
}


#pragma mark -
#pragma mark Configuration : Service Defination

+ (NSString *)sharerTitle
{
	return @"新浪微博";
}

+ (BOOL)canShareURL
{
	return YES;
}

+ (BOOL)canShareText
{
	return YES;
}

// TODO use img.ly to support this
+ (BOOL)canShareImage
{
	return YES;
}


#pragma mark -
#pragma mark Configuration : Dynamic Enable

- (BOOL)shouldAutoShare
{
	return NO;
}


#pragma mark -
#pragma mark Authorization

- (BOOL)isAuthorized
{		
	return [self restoreAccessToken];
}

- (void)promptAuthorization
{		
	if (xAuth)
		[super authorizationFormShow]; // xAuth process
	
	else
		[super promptAuthorization]; // OAuth process		
}


#pragma mark xAuth

+ (NSString *)authorizationFormCaption
{
	return SHKLocalizedString(@"Create a free account at %@", @"t.sina.com");
}

+ (NSArray *)authorizationFormFields
{
	if ([SHKSinaUsername isEqualToString:@""])
		return [super authorizationFormFields];
	
	return [NSArray arrayWithObjects:
			[SHKFormFieldSettings label:SHKLocalizedString(@"Username") key:@"username" type:SHKFormFieldTypeText start:nil],
			[SHKFormFieldSettings label:SHKLocalizedString(@"Password") key:@"password" type:SHKFormFieldTypePassword start:nil],
			[SHKFormFieldSettings label:SHKLocalizedString(@"Follow %@", SHKSinaUsername) key:@"followMe" type:SHKFormFieldTypeSwitch start:SHKFormFieldSwitchOn],			
			nil];
}

- (void)authorizationFormValidate:(SHKFormController *)form
{
	self.pendingForm = form;
	[self tokenAccess];
}

- (void)tokenAccessModifyRequest:(OAMutableURLRequest *)oRequest
{	
	if (xAuth)
	{
		NSDictionary *formValues = [pendingForm formValues];
		
		OARequestParameter *username = [[[OARequestParameter alloc] initWithName:@"x_auth_username"
                                                                           value:[formValues objectForKey:@"username"]] autorelease];
		
		OARequestParameter *password = [[[OARequestParameter alloc] initWithName:@"x_auth_password"
                                                                           value:[formValues objectForKey:@"password"]] autorelease];
		
		OARequestParameter *mode = [[[OARequestParameter alloc] initWithName:@"x_auth_mode"
                                                                       value:@"client_auth"] autorelease];
		
		[oRequest setParameters:[NSArray arrayWithObjects:username, password, mode, nil]];
	}
}

- (void)tokenAccessTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data 
{
	if (xAuth) 
	{
		if (ticket.didSucceed)
		{
			[item setCustomValue:[[pendingForm formValues] objectForKey:@"followMe"] forKey:@"followMe"];
			[pendingForm close];
		}
		
		else
		{
			NSString *response = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
			
			SHKLog(@"tokenAccessTicket Response Body: %@", response);
			
			[self tokenAccessTicket:ticket didFailWithError:[SHK error:response]];
			return;
		}
	}
    
	[super tokenAccessTicket:ticket didFinishWithData:data];		
}


#pragma mark -
#pragma mark UI Implementation

- (void)show
{	
	if (item.shareType == SHKShareTypeImage)
	{
        if (![item URL]) {
            [item setCustomValue:item.title forKey:@"status"];
        }else{
            [item setCustomValue:item.text forKey:@"status"];
        }
		[self showSinaForm];
	}
	
	else if (item.shareType == SHKShareTypeText)
	{
		[item setCustomValue:item.text forKey:@"status"];
		[self showSinaForm];
	}
}

- (void)showSinaForm
{
	SHKSinaForm *rootView = [[SHKSinaForm alloc] initWithNibName:nil bundle:nil];	
	rootView.delegate = self;
	
    if ([item image] != nil) {
        rootView.imageView.image = [item image];
    }
    
	// force view to load so we can set textView text
	[rootView view];
	
	rootView.textView.text = [item customValueForKey:@"status"];
    
	rootView.hasAttachment = item.image != nil;
	
	[self pushViewController:rootView animated:NO];
	
	[[SHK currentHelper] showViewController:self];	
}

- (void)sendForm:(SHKSinaForm *)form
{	
	[item setCustomValue:form.textView.text forKey:@"status"];
	[self tryToSend];
}

#pragma mark -
#pragma mark Share API Methods

- (BOOL)validate
{
	NSString *status = [item customValueForKey:@"status"];
	return status != nil && status.length > 0 && status.length <= 140;
}

- (BOOL)send
{	
	// Check if we should send follow request too
	if (xAuth && [item customBoolForSwitchKey:@"followMe"])
		[self followMe];	
	
	if (![self validate])
		[self show];
	
	else
	{	
		if (item.shareType == SHKShareTypeImage) {
//			[self sendImage];
            [self sendImageOauth2];
		} else {
//			[self sendStatus];
            [self sendTextOauth2];
		}
		
		// Notify delegate
		[self sendDidStart];	
		
		return YES;
	}
	
	return NO;
}

//- (void)sendStatus
//{
//	OAMutableURLRequest *oRequest = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.t.sina.com.cn/statuses/update.json"]
//                                                                    consumer:consumer
//                                                                       token:accessToken
//                                                                       realm:nil
//                                                           signatureProvider:nil];
//	
//	[oRequest setHTTPMethod:@"POST"];
//	
//	OARequestParameter *statusParam = [[OARequestParameter alloc] initWithName:@"status"
//																		 value:[item customValueForKey:@"status"]];
//	NSArray *params = [NSArray arrayWithObjects:statusParam, nil];
//	[oRequest setParameters:params];
//	[statusParam release];
//	
//	OAAsynchronousDataFetcher *fetcher = [OAAsynchronousDataFetcher asynchronousFetcherWithRequest:oRequest
//                                                                                          delegate:self
//                                                                                 didFinishSelector:@selector(sendStatusTicket:didFinishWithData:)
//                                                                                   didFailSelector:@selector(sendStatusTicket:didFailWithError:)];	
//    
//	[fetcher start];
//	[oRequest release];
//}
//
//- (void)sendStatusTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data 
//{	
//	// TODO better error handling here
//    
//	if (ticket.didSucceed) 
//		[self sendDidFinish];
//	
//	else
//	{		
//		if (SHKDebugShowLogs)
//			SHKLog(@"Sina Send Status Error: %@", [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
//		
//		// CREDIT: Oliver Drobnik
//		
//		NSString *string = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];		
//		
//		// in case our makeshift parsing does not yield an error message
//		NSString *errorMessage = @"Unknown Error";		
//		
//		NSScanner *scanner = [NSScanner scannerWithString:string];
//		
//		// skip until error message
//		[scanner scanUpToString:@"\"error\":\"" intoString:nil];
//		
//		
//		if ([scanner scanString:@"\"error\":\"" intoString:nil])
//		{
//			// get the message until the closing double quotes
//			[scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\""] intoString:&errorMessage];
//		}
//		
//		
//		// this is the error message for revoked access
//		if ([errorMessage isEqualToString:@"Invalid / used nonce"])
//		{
//			[self sendDidFailShouldRelogin];
//		}
//		else 
//		{
//			NSError *error = [NSError errorWithDomain:@"Sina" code:2 userInfo:[NSDictionary dictionaryWithObject:errorMessage forKey:NSLocalizedDescriptionKey]];
//			[self sendDidFailWithError:error];
//		}
//	}
//}
//
//- (void)sendStatusTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error
//{
//	[self sendDidFailWithError:error];
//}
//
//- (void)sendImage {
//	NSURL *serviceURL = nil;
//    OAMutableURLRequest *oRequest;
//	if([item image]){
//		serviceURL = [NSURL URLWithString:@"http://api.t.sina.com.cn/statuses/upload.json"];
//        oRequest = [[OAMutableURLRequest alloc] initWithURL:serviceURL
//                                                    consumer:consumer
//                                                       token:accessToken
//                                                       realm:nil
//                                                      status:[item customValueForKey:@"status"]
//                                           signatureProvider:nil];
//                
//        
//	} else {
//		serviceURL = [NSURL URLWithString:@"http://api.t.sina.com.cn/statuses/update.json"];
//        oRequest = [[OAMutableURLRequest alloc] initWithURL:serviceURL
//                                                   consumer:consumer
//                                                      token:accessToken
//                                                      realm:nil
//                                          signatureProvider:nil];
//	}
//	
//
//	
//	[oRequest setHTTPMethod:@"POST"];
//	
//	if([item image]){                
////        NSString *aaa = [NSString stringWithFormat:@"http://api.t.sina.com.cn/statuses/upload.json?source=%@&status=%@",SHKSinaConsumerKey,[[item customValueForKey:@"status"] URLEncodedString]];
////        [oRequest setURL:[NSURL URLWithString:aaa]];
//        
//        UIImage *img = [item image];
//        NSData *fileData = UIImageJPEGRepresentation(img, 0.8);
//        
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
//                             [item customValueForKey:@"status"], @"status",
//                             SHKSinaConsumerKey, @"source",
//                             nil];
//        
//        NSArray* keys = [dic allKeys];
//        NSString* param = [NSString string];
//        int i;
//        for (i = 0; i < [keys count]; i++) {
//            param = [param stringByAppendingString:
//                      [@"--" stringByAppendingString:
//                       [@"0194784892923" stringByAppendingString:
//                        [@"\r\nContent-Disposition: form-data; name=\"" stringByAppendingString:
//                         [[keys objectAtIndex: i] stringByAppendingString:
//                          [@"\"\r\n\r\n" stringByAppendingString:
//                           [[dic valueForKey: [keys objectAtIndex: i]] stringByAppendingString: @"\r\n"]]]]]]];
//        }
//
//        
//        NSString *footer = [NSString stringWithFormat:@"\r\n--%@--\r\n", @"0194784892923"];
//        
//        param = [param stringByAppendingString:[NSString stringWithFormat:@"--%@\r\n", @"0194784892923"]];
//        param = [param stringByAppendingString:@"Content-Disposition: form-data; name=\"pic\";filename=\"image.jpg\"\r\nContent-Type: image/jpeg\r\n\r\n"];
//        
//        NSMutableData *data = [NSMutableData data];
//        [data appendData:[param dataUsingEncoding:NSUTF8StringEncoding]];
//        [data appendData:fileData];
//        [data appendData:[footer dataUsingEncoding:NSUTF8StringEncoding]];
//        
//        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
//        [params setObject:SHKSinaConsumerKey forKey:@"source"];
//        [params setObject:[item customValueForKey:@"status"] forKey:@"status"];        
//        
//        
//        
//        NSString *contentType = @"multipart/form-data; boundary=0194784892923";
//        [oRequest setHTTPShouldHandleCookies:NO];
//        [oRequest setHTTPMethod:@"POST"];
//        [oRequest setValue:contentType forHTTPHeaderField:@"Content-Type"];
//        [oRequest setValue:[NSString stringWithFormat:@"%d", [data length]] forHTTPHeaderField:@"Content-Length"];
//        [oRequest setHTTPBody:data];
//	} else {        
//		OARequestParameter *statusParam = [[OARequestParameter alloc] initWithName:@"status"
//                                                                             value:[item customValueForKey:@"status"]];
//        NSArray *params = [NSArray arrayWithObjects:statusParam, nil];
//        [oRequest setParameters:params];
//        [statusParam release];
//
//	}
//	    
//	// Start the request
//	OAAsynchronousDataFetcher *fetcher = [OAAsynchronousDataFetcher asynchronousFetcherWithRequest:oRequest
//																						  delegate:self
//																				 didFinishSelector:@selector(sendImageTicket:didFinishWithData:)
//																				   didFailSelector:@selector(sendImageTicket:didFailWithError:)];	
//	
//	[fetcher start];
//	
//	
//	[oRequest release];
//}
//
//- (void)sendImageTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
//	// TODO better error handling here
//	// DLog([[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
//	
//	if (ticket.didSucceed) {
//		[self sendDidFinish];
//		// Finished uploading Image, now need to posh the message and url in sina
//		NSString *dataString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
//		NSRange startingRange = [dataString rangeOfString:@"<url>" options:NSCaseInsensitiveSearch];
//		//DLog(@"found start string at %d, len %d",startingRange.location,startingRange.length);
//		NSRange endingRange = [dataString rangeOfString:@"</url>" options:NSCaseInsensitiveSearch];
//		//DLog(@"found end string at %d, len %d",endingRange.location,endingRange.length);
//		
//		if (startingRange.location != NSNotFound && endingRange.location != NSNotFound) {
//			NSString *urlString = [dataString substringWithRange:NSMakeRange(startingRange.location + startingRange.length, endingRange.location - (startingRange.location + startingRange.length))];
//			//DLog(@"extracted string: %@",urlString);
//			[item setCustomValue:[NSString stringWithFormat:@"%@ %@",[item customValueForKey:@"status"],urlString] forKey:@"status"];
//			[self sendStatus];
//		}
//		
//		
//	} else {
//		[self sendDidFailWithError:nil];
//	}
//}
//
//- (void)sendImageTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error {
//	[self sendDidFailWithError:error];
//}
//
//- (void)followMe
//{
//	// remove it so in case of other failures this doesn't get hit again
//	[item setCustomValue:SHKSinaUsername forKey:@"SHKSinaUserName"];
//    [item setCustomValue:SHKSinaUserID forKey:@"SHKSinaUserID"];
//	
//	OAMutableURLRequest *oRequest = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.t.sina.com.cn/friendships/create.json"]]
//																	consumer:consumer
//																	   token:accessToken
//																	   realm:nil
//														   signatureProvider:nil];
//	
//	[oRequest setHTTPMethod:@"POST"];
//    NSString *paramers = [NSString stringWithFormat:@"uid=%@&screen_name=%@",[[item customValueForKey:@"SHKSinaUserID"] URLEncodedString],[[item customValueForKey:@"SHKSinaUserName"] URLEncodedString]];
//    [oRequest setHTTPBody:[paramers dataUsingEncoding:NSUTF8StringEncoding]];
//	
//	OAAsynchronousDataFetcher *fetcher = [OAAsynchronousDataFetcher asynchronousFetcherWithRequest:oRequest
//                                                                                          delegate:nil // Currently not doing any error handling here.  If it fails, it's probably best not to bug the user to follow you again.
//                                                                                 didFinishSelector:nil
//                                                                                   didFailSelector:nil];	
//	
//	[fetcher start];
//	[oRequest release];
//}

//Oauth2.0分享调用的方法
-(void)sendImageOauth2{
    
    if (![item URL]) {
        NSURL *url = [NSURL URLWithString:@"https://api.weibo.com/2/statuses/upload.json"];
        ASIFormDataRequest *req = [[ASIFormDataRequest alloc] initWithURL:url];
        NSString *authToken = [SHK getAuthValueForKey:USER_STORE_ACCESS_TOKEN forSharer:NSStringFromClass([SHKSina class])];
        
        [req setPostValue:authToken    forKey:@"access_token"];
        [req setPostValue:[item customValueForKey:@"status"]         forKey:@"status"];
        DLog(@"item customValueForKey:=%@",[item customValueForKey:@"status"]);
        [req addData:UIImagePNGRepresentation([item image]) forKey:@"pic"];
        req.delegate = self;
        [req startAsynchronous];
        [req release];
        
    }else{
        
        NSURL *url = [NSURL URLWithString:@"https://api.weibo.com/2/statuses/upload_url_text.json"];
        ASIFormDataRequest *req = [[ASIFormDataRequest alloc] initWithURL:url];
        NSString *authToken = [SHK getAuthValueForKey:USER_STORE_ACCESS_TOKEN forSharer:NSStringFromClass([SHKSina class])];
        
        [req setPostValue:authToken    forKey:@"access_token"];
        [req setPostValue:[item customValueForKey:@"status"]         forKey:@"status"];
        CDLog(BTDFLAG_SINA_SHARE_ERROR,@"item customValueForKey:=%@",[item customValueForKey:@"status"]);
        
        //由于新浪微薄没有对带＋号的url进行解码，此处人为手动替换＋号为%2B
//        NSString *imageUrl = [[item URL].absoluteString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        [req setPostValue:[item URL] forKey:@"url"];
        req.delegate = self;
        [req startAsynchronous];
        [req release];
    }
    
    [self sendDidStart];
}

-(void)sendTextOauth2{
    NSURL *url = [NSURL URLWithString:@"https://api.weibo.com/2/statuses/update.json"];
    ASIFormDataRequest *req = [[ASIFormDataRequest alloc] initWithURL:url];
    NSString *authToken = [SHK getAuthValueForKey:USER_STORE_ACCESS_TOKEN forSharer:NSStringFromClass([SHKSina class])];
    
    [req setPostValue:authToken    forKey:@"access_token"];
    [req setPostValue:[item customValueForKey:@"status"]         forKey:@"status"];
    req.delegate = self;
    [req startAsynchronous];
    [req release];
}

-(void)followMeOauth2{
    
    [item setCustomValue:SHKSinaUsername forKey:@"SHKSinaUserName"];
    [item setCustomValue:SHKSinaUserID forKey:@"SHKSinaUserID"];
    
    NSURL *url = [NSURL URLWithString:@"https://api.weibo.com/2/friendships/create.json"];
    ASIFormDataRequest *req = [[ASIFormDataRequest alloc] initWithURL:url];
    NSString *authToken = [SHK getAuthValueForKey:USER_STORE_ACCESS_TOKEN forSharer:NSStringFromClass([SHKSina class])];
    
    [req setPostValue:authToken    forKey:@"access_token"];
    [req setPostValue:[item customValueForKey:@"SHKSinaUserID"] forKey:@"uid"];
    [req setPostValue:[item customValueForKey:@"SHKSinaUserName"] forKey:@"screen_name"];
    req.delegate = self;
    [req startAsynchronous];
    [req release];
    
}

-(void)requestFinished:(ASIFormDataRequest *)req{
    
    CJSONDeserializer *deserializer = [[CJSONDeserializer alloc] init];
    

    //2.0新服务器，不用再转码
    NSData *responseData = [req responseData];
    
    NSDictionary *responseDic = [deserializer deserializeAsDictionary:responseData error:nil];
    [deserializer release];
    NSString *myErr = (NSString *)[responseDic objectForKey:@"error"];
    CDLog(BTDFLAG_SINA_SHARE_ERROR,@"%@",[req responseString]);
    CDLog(BTDFLAG_SINA_SHARE_ERROR,@"%@",myErr);
    if([myErr isEqualToString:@"already followed"]) {
        return;
    }
    if (myErr) {
//        [[[[UIAlertView alloc] initWithTitle:SHKLocalizedString(@"Request Error")
//                                     message:req.error!=nil?[req.error localizedDescription]:SHKLocalizedString(@"There was an error while sharing")
//                                    delegate:nil
//                           cancelButtonTitle:SHKLocalizedString(@"Close")
//                           otherButtonTitles:nil] autorelease] show];
        [[SHKActivityIndicator currentIndicator] displayCompleted:@"发送失败！"];
        return;
    }
    [self sendDidFinish];
    
    
}

-(void)requestFailed:(ASIFormDataRequest *)req{

    [self sendDidFinish];
    [self sendDidFailWithError:req.error];
    
}

@end
