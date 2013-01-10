//
//  SHKTencent.m
//  ShareKit
//
//  Created by K032 on 11-7-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SHKTencent.h"


@implementation SHKTencent

@synthesize xAuth;

- (id)init
{
	if (self = [super init])
	{	
		// OAUTH		
		self.consumerKey = SHKTencentConsumerKey;		
		self.secretKey = SHKTencentSecret;
 		self.authorizeCallbackURL = [NSURL URLWithString:SHKTencentCallbackUrl];// HOW-TO: In your Tencent application settings, use the "Callback URL" field.  If you do not have this field in the settings, set your application type to 'Browser'.
		
		// XAUTH
		self.xAuth = SHKTencentUseXAuth?YES:NO;
		
		
		// -- //
		
		
		// You do not need to edit these, they are the same for everyone
	    self.authorizeURL = [NSURL URLWithString:@"https://open.t.qq.com/cgi-bin/authorize"];
	    self.requestURL = [NSURL URLWithString:@"https://open.t.qq.com/cgi-bin/request_token"];
	    self.accessURL = [NSURL URLWithString:@"https://open.t.qq.com/cgi-bin/access_token"]; 
	}	
	return self;
}


#pragma mark -
#pragma mark Configuration : Service Defination

+ (NSString *)sharerTitle
{
	return @"腾讯微博";
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
	return SHKLocalizedString(@"Create a free account at %@", @"t.qq.com");
}

+ (NSArray *)authorizationFormFields
{
	if ([SHKTencentUsername isEqualToString:@""])
		return [super authorizationFormFields];
	
	return [NSArray arrayWithObjects:
			[SHKFormFieldSettings label:SHKLocalizedString(@"Username") key:@"username" type:SHKFormFieldTypeText start:nil],
			[SHKFormFieldSettings label:SHKLocalizedString(@"Password") key:@"password" type:SHKFormFieldTypePassword start:nil],
			[SHKFormFieldSettings label:SHKLocalizedString(@"Follow %@", SHKTencentUsername) key:@"followMe" type:SHKFormFieldTypeSwitch start:SHKFormFieldSwitchOn],			
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
		[item setCustomValue:item.title forKey:@"status"];
		[self showTencentForm];
	}
    else if(item.shareType == SHKShareTypeURL)
    {
     	[item setCustomValue:item.text forKey:@"status"];
		[self showTencentForm];
    }
    else if (item.shareType == SHKShareTypeText)
	{
		[item setCustomValue:item.text forKey:@"status"];
		[self showTencentForm];
	}
}

- (void)showTencentForm
{
	SHKTencentForm *rootView = [[SHKTencentForm alloc] initWithNibName:nil bundle:nil];	
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

- (void)sendForm:(SHKTencentForm *)form
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
			[self sendImage];
		}if (item.shareType == SHKShareTypeURL) {
            [self sendImageWithUrl];
        }else {
			[self sendStatus];
		}
		
		// Notify delegate
		[self sendDidStart];	
		
		return YES;
	}
	
	return NO;
}

- (void)sendStatus
{
  	OAMutableURLRequest *oRequest = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://open.t.qq.com/api/t/add"]
                                                                    consumer:consumer
                                                                       token:accessToken
                                                                       realm:nil
                                                                     content:[item customValueForKey:@"status"]
                                                           signatureProvider:nil];
    
	[oRequest setHTTPMethod:@"POST"];
    
    [oRequest prepare];
    
	[oRequest setTimeoutInterval:20.0f];
	[oRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSString *paramers = [NSString stringWithFormat:@"clientip=127.0.0.1&content=%@&%@",[[item customValueForKey:@"status"] URLEncodedString],[oRequest getURLParmas]];
    
    [oRequest setHTTPBody:[paramers dataUsingEncoding:NSUTF8StringEncoding]];

	OAAsynchronousDataFetcher *fetcher = [OAAsynchronousDataFetcher asynchronousFetcherWithRequest:oRequest
                                                                                          delegate:self
                                                                                 didFinishSelector:@selector(sendStatusTicket:didFinishWithData:)
                                                                                   didFailSelector:@selector(sendStatusTicket:didFailWithError:)];	
    
	[fetcher start];
	[oRequest release];
}

- (void)sendImageWithUrl
{
    [item setCustomValue:[item URL].absoluteString forKey:@"pic_url"];

    OAMutableURLRequest *oRequest = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://open.t.qq.com/api/t/add_pic_url"]
                                                                    consumer:consumer
                                                                       token:accessToken
                                                                       realm:nil
                                                                     content:[item customValueForKey:@"status"]
                                                                    imageUrl:[item customValueForKey:@"pic_url"]
                                                           signatureProvider:nil];

    
    
	[oRequest setHTTPMethod:@"POST"];
    
    [oRequest prepare];
    [oRequest setTimeoutInterval:20.0f];
    
    NSString *paramers = [NSString stringWithFormat:@"clientip=127.0.0.1&content=%@&pic_url=%@&%@",[[item customValueForKey:@"status"] URLEncodedString],[[item URL].absoluteString URLEncodedString],[oRequest getURLParmas]];
    
	[oRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [oRequest setHTTPBody:[paramers dataUsingEncoding:NSUTF8StringEncoding]];
    
	OAAsynchronousDataFetcher *fetcher = [OAAsynchronousDataFetcher asynchronousFetcherWithRequest:oRequest
                                                                                          delegate:self
                                                                                 didFinishSelector:@selector(sendImageUrlTicket:didFinishWithData:)
                                                                                   didFailSelector:@selector(sendImageUrlTicket:didFailWithError:)];	
    
	[fetcher start];
	[oRequest release];
}

- (void)sendImageUrlTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data{
    
    if (ticket.didSucceed){

		[self sendDidFinish];
        //2012.11.29 nate edit 无用的变量，引起分析错误
        //NSString *dataString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    }
	else{

        [self sendDidFailWithError:nil];
    }
}

- (void)sendImageUrlTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error {
    [self sendDidFailWithError:error];
}

- (void)sendStatusTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data 
{	
	// TODO better error handling here
    
	if (ticket.didSucceed){
		//[self sendDidFinish];
    }
	else
	{		
		if (SHKDebugShowLogs)
			SHKLog(@"Tencent Send Status Error: %@", [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
		
		// CREDIT: Oliver Drobnik
		
		NSString *string = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];		
		
		// in case our makeshift parsing does not yield an error message
		NSString *errorMessage = @"Unknown Error";		
		
		NSScanner *scanner = [NSScanner scannerWithString:string];
		
		// skip until error message
		[scanner scanUpToString:@"\"error\":\"" intoString:nil];
		
		
		if ([scanner scanString:@"\"error\":\"" intoString:nil])
		{
			// get the message until the closing double quotes
			[scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\""] intoString:&errorMessage];
		}
		
		
		// this is the error message for revoked access
		if ([errorMessage isEqualToString:@"Invalid / used nonce"])
		{
			[self sendDidFailShouldRelogin];
		}
		else 
		{
			NSError *error = [NSError errorWithDomain:@"Tencent" code:2 userInfo:[NSDictionary dictionaryWithObject:errorMessage forKey:NSLocalizedDescriptionKey]];
			[self sendDidFailWithError:error];
		}
	}
}

- (void)sendStatusTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error
{
	[self sendDidFailWithError:error];
}

- (void)sendImage {
	
	NSURL *serviceURL = nil;
	if([item image]){
		serviceURL = [NSURL URLWithString:@"http://open.t.qq.com/api/t/add_pic"];
	} else {
		serviceURL = [NSURL URLWithString:@"http://open.t.qq.com/api/t/add"];
	}
	OAMutableURLRequest *oRequest = [[OAMutableURLRequest alloc] initWithURL:serviceURL
                                                                    consumer:consumer
                                                                       token:accessToken
                                                                       realm:nil
                                                                     content:[item customValueForKey:@"status"]
                                                           signatureProvider:nil];
    
	[oRequest setHTTPMethod:@"POST"];
	[oRequest setTimeoutInterval:20.0f];
    
	if([item image]){
		[oRequest prepare];
        
        NSString *paramers = [NSString stringWithFormat:@"clientip=127.0.0.1&content=%@&%@",[[item customValueForKey:@"status"] URLEncodedString],[oRequest getURLParmas]];
        
       	CFUUIDRef       uuid;
        CFStringRef     uuidStr;
        uuid = CFUUIDCreate(NULL);
        assert(uuid != NULL);
        uuidStr = CFUUIDCreateString(NULL, uuid);
        assert(uuidStr != NULL);
        NSString *boundary = [NSString stringWithFormat:@"Boundary-%@", uuidStr];
        CFRelease(uuidStr);
        CFRelease(uuid);
        
        NSData *boundaryBytes = [[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding];
        [oRequest setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
        
        NSMutableData *bodyData = [NSMutableData data];
        NSString *formDataTemplate = @"\r\n--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@";
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        NSArray *pairs = [paramers componentsSeparatedByString:@"&"];
        for(NSString *pair in pairs) {
            NSArray *keyValue = [pair componentsSeparatedByString:@"="];
            if([keyValue count] == 2) {
                NSString *key = [keyValue objectAtIndex:0];
                NSString *value = [keyValue objectAtIndex:1];
                value = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                if(key && value)
                    [dict setObject:value forKey:key];
            }
        }
        NSDictionary *listParams = dict;
        
        for (NSString *key in listParams) {
            
            NSString *value = [listParams valueForKey:key];
            NSString *formItem = [NSString stringWithFormat:formDataTemplate, boundary, key, value];
            [bodyData appendData:[formItem dataUsingEncoding:NSUTF8StringEncoding]];
        }
        [bodyData appendData:boundaryBytes];
        
        NSString *headerTemplate = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"pic\"; filename=\"%@\"\r\nContent-Type: \"application/octet-stream\"\r\n\r\n",@"image.png"];
        UIImage *img = [item image];
        NSData *fileData = UIImageJPEGRepresentation(img, 1.0);
        
        [bodyData appendData:[headerTemplate dataUsingEncoding:NSUTF8StringEncoding]];
        [bodyData appendData:fileData];
        [bodyData appendData:boundaryBytes];

        [oRequest setValue:[NSString stringWithFormat:@"%d", [bodyData length]] forHTTPHeaderField:@"Content-Length"];
        [oRequest setHTTPBody:bodyData];
	}
    
//    DLog(@"oRequest = %@",[oRequest description]);
	// Start the request
	OAAsynchronousDataFetcher *fetcher = [OAAsynchronousDataFetcher asynchronousFetcherWithRequest:oRequest
																						  delegate:self
																				 didFinishSelector:@selector(sendImageTicket:didFinishWithData:)
																				   didFailSelector:@selector(sendImageTicket:didFailWithError:)];	
	
	[fetcher start];
	
	[oRequest release];
}

- (void)sendImageTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
	// TODO better error handling here
	
	if (ticket.didSucceed) {
		[self sendDidFinish];
		// Finished uploading Image, now need to posh the message and url in Tencent
		NSString *dataString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
		NSRange startingRange = [dataString rangeOfString:@"<url>" options:NSCaseInsensitiveSearch];
		NSRange endingRange = [dataString rangeOfString:@"</url>" options:NSCaseInsensitiveSearch];

		
		if (startingRange.location != NSNotFound && endingRange.location != NSNotFound) {
			NSString *urlString = [dataString substringWithRange:NSMakeRange(startingRange.location + startingRange.length, endingRange.location - (startingRange.location + startingRange.length))];
			[item setCustomValue:[NSString stringWithFormat:@"%@ %@",[item customValueForKey:@"status"],urlString] forKey:@"status"];
			[self sendStatus];
		}
		
		
	} else {
		[self sendDidFailWithError:nil];
	}
}

- (void)sendImageTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error {
	[self sendDidFailWithError:error];
}


- (void)followMe
{
	// remove it so in case of other failures this doesn't get hit again
	[item setCustomValue:SHKTencentUsername forKey:@"followMe"];
	
	OAMutableURLRequest *oRequest = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://open.t.qq.com/api/friends/add"]
                                                                    consumer:consumer
                                                                       token:accessToken
                                                                       realm:nil
                                                                  friendName:[item customValueForKey:@"followMe"]
                                                           signatureProvider:nil];
    
	[oRequest setHTTPMethod:@"POST"];
    
    [oRequest prepare];
        
    NSString *paramers = [NSString stringWithFormat:@"%@",[oRequest getURLParmas]];
    [oRequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://open.t.qq.com/api/friends/add?%@",paramers]]];
    
    [oRequest setHTTPBody:[paramers dataUsingEncoding:NSUTF8StringEncoding]];
    
	OAAsynchronousDataFetcher *fetcher = [OAAsynchronousDataFetcher asynchronousFetcherWithRequest:oRequest
                                                                                          delegate:self
                                                                                 didFinishSelector:@selector(sendStatusTicket:didFinishWithData:)
                                                                                   didFailSelector:@selector(sendStatusTicket:didFailWithError:)];	
    
	[fetcher start];
	[oRequest release];
}

@end
