//
//  SHKSina.m
//  ShareKit
//
//  Created by K032 on 11-7-7.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SHKRenren.h"
#import "ASIFormDataRequest.h"
#import "CJSONDeserializer.h"
#import "ROUtility.h"

@interface SHKRenren(Private)


-(void)sendImageOauth2;
-(NSString *)signatureByDic:(NSDictionary *)dic;
@end    
@implementation SHKRenren


@synthesize xAuth;

- (id)init
{
	if (self = [super init])
	{	
		// OAUTH		
		self.consumerKey = SHKRenrenConsumerKey;		
		self.secretKey = SHKRenrenSecret;
 		self.authorizeCallbackURL = [NSURL URLWithString:SHKRenrenCallbackUrl];
		// XAUTH
		self.xAuth = SHKRenrenUseXAuth?YES:NO;
		
		
		// -- //
		
		
		// You do not need to edit these, they are the same for everyone
        //	    self.authorizeURL = [NSURL URLWithString:@"http://api.t.sina.com.cn/oauth/authorize"];
        //	    self.requestURL = [NSURL URLWithString:@"http://api.t.sina.com.cn/oauth/request_token"];
        //	    self.accessURL = [NSURL URLWithString:@"http://api.t.sina.com.cn/oauth/access_token"]; 
        
        
        self.authorizeURL = [NSURL URLWithString:@"https://graph.renren.com/oauth/authorize"];
        self.requestURL = nil;
        self.accessURL = nil;
	}	
	return self;
}


#pragma mark -
#pragma mark Configuration : Service Defination

+ (NSString *)sharerTitle
{
	return @"人人网";
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
//			[SHKFormFieldSettings label:SHKLocalizedString(@"Follow %@", SHKRenrenUsername) key:@"followMe" type:SHKFormFieldTypeSwitch start:SHKFormFieldSwitchOn],			
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
		[self showRenrenForm];
	}
	
	else if (item.shareType == SHKShareTypeText)
	{
		[item setCustomValue:item.text forKey:@"status"];
		[self showRenrenForm];
	}
}

- (void)showRenrenForm
{
	SHKRenrenForm *rootView = [[SHKRenrenForm alloc] initWithNibName:nil bundle:nil];	
	rootView.delegate = self;
	
//    if ([item image] != nil) {
//        rootView.imageView.image = [item image];
//    }
    
	// force view to load so we can set textView text
	[rootView view];
	
	rootView.textView.text = [item customValueForKey:@"status"];
    
	rootView.hasAttachment = item.image != nil;
	
	[self pushViewController:rootView animated:NO];
	
	[[SHK currentHelper] showViewController:self];	
}

- (void)sendForm:(SHKRenrenForm *)form
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
//	if (xAuth && [item customBoolForSwitchKey:@"followMe"])
//		[self followMe];	
	
	if (![self validate])
		[self show];
	
	else
	{	
		if (item.shareType == SHKShareTypeImage) {
            //			[self sendImage];
            [self sendImageOauth2];
		} else {
            //			[self sendStatus];
            [self sendImageOauth2];
		}
		
		// Notify delegate
		[self sendDidStart];	
		
		return YES;
	}
	
	return NO;
}

//得到签名
-(NSString *)signatureByDic:(NSDictionary *)dic{
    DLog(@"reqdasdfasfsdfsafsa %@",dic);

//    for(NSString *parameterName in [[extraOAuthParameters allKeys] sortedArrayUsingSelector:@selector(compare:)]) {
//		[parameterPairs addObject:[[OARequestParameter requestParameterWithName:[parameterName URLEncodedString] value: [[extraOAuthParameters objectForKey:parameterName] URLEncodedString]] URLEncodedNameValuePair]];
//	}
    NSMutableString *returnStr = [NSMutableString string];
    for(NSString *str in [[dic allKeys] sortedArrayUsingSelector:@selector(compare:)]){
        [returnStr appendString:[NSString stringWithFormat:@"%@=%@",str,[dic objectForKey:str]]];
    }
    [returnStr appendString:SHKRenrenSecret];
    DLog(@"returnStr = %@",returnStr);
    return returnStr;
}

//得到用户名
-(void)renrenUserNickName:(SHKRenrenForm *)form {
    DLog(@"userNickNameLabel: %@",form.userNickNameLabel.text);
//	self.userNickNameLabel = [form.userNickNameLabel retain];
	self.userNickNameLabel = form.userNickNameLabel;
	NSURL *url = [NSURL URLWithString:SHKRenrenRequestBaseUrl];
    ASIFormDataRequest *req = [[ASIFormDataRequest alloc] initWithURL:url];
    NSString *authToken = [SHK getAuthValueForKey:USER_STORE_ACCESS_TOKEN forSharer:NSStringFromClass([SHKRenren class])];
    NSMutableDictionary *dic  = [[NSMutableDictionary alloc] init];
    [dic setObject:authToken forKey:@"access_token"];
    [dic setObject:@"users.getInfo" forKey:@"method"];
//    [dic setObject:[item customValueForKey:@"status"]         forKey:@"caption"];
    [dic setObject:@"JSON"         forKey:@"format"];
    [dic setObject:@"1.0"         forKey:@"v"];
	[dic setObject:@"name" forKey:@"fields"];
    //[dic setObject:@"image/png"         forKey:@"upload"];
    [req setPostValue:authToken    forKey:@"access_token"];
    [req setPostValue:@"users.getInfo" forKey:@"method"];
//    [req setPostValue:[item customValueForKey:@"status"]         forKey:@"caption"];
    [req setPostValue:@"JSON"         forKey:@"format"];
    [req setPostValue:@"1.0"         forKey:@"v"];
	[req setPostValue:@"name" forKey:@"fields"];
    
    //[req addData:UIImagePNGRepresentation([item image]) forKey:@"upload"];
//    [req addData:UIImagePNGRepresentation([item image]) withFileName:@"aaa.png" andContentType:@"image/png" forKey:@"upload"];
    //[self signatureByAsi:dic];
	//    NSString * sigBaseString=[NSString stringWithFormat:@"access_token=%@method=%@format=JSONstatus=%@v=1.0%@"
	//                              ,authToken,@"photos.upload",nil,SHKRenrenConsumerKey];
    [req setPostValue:[ROUtility md5HexDigest:[self signatureByDic:dic]] forKey:@"sig"];
	[dic release];
    req.delegate = self;
	
	[req setDidFinishSelector:@selector(sendRequestUserNickNameFinished:)];
	[req setDidFailSelector:@selector(sendRequestUserNickNameFailed:)];
	
    [req startAsynchronous];
    [req release];
}
-(void)sendRequestUserNickNameFinished:(ASIFormDataRequest *)req{
	DLog(@"%@",NSStringFromSelector(_cmd));
    
    CJSONDeserializer *deserializer = [[CJSONDeserializer alloc] init];
    
    
    //2.0新服务器，不用再转码
    NSData *responseData = [req responseData];
    
//    NSDictionary *responseDic = [deserializer deserializeAsDictionary:responseData error:nil];
	NSArray *responseArray = [deserializer deserializeAsArray:responseData error:nil];
	DLog(@"user nick name = %@",responseArray);
	[deserializer release];
	//TODO:RENREN_USER_STORE_NICK_NAME
	NSString *nickName = [[responseArray objectAtIndex:0] valueForKey:@"name"];
	[[NSUserDefaults standardUserDefaults] setValue:nickName forKey:RENREN_USER_STORE_NICK_NAME];
	DLog(@"self.userNickNameLabel = %@",self.userNickNameLabel);
    UILabel *label = [[UILabel alloc] init];
    [label setText:nickName];
	//[self.userNickNameLabel setText:nickName];
    self.userNickNameLabel = label;
    [label release];
	//[self.userNickNameLabel release];
	
//    NSString *tmp = [responseDic objectForKey:@"error_msg"];
//    if(tmp!=nil){
//        //错误代码在api查找
//        DLog(@"发送失败");
//        NSString *string = [NSString stringWithUTF8String:[tmp UTF8String]];
//        DLog(@"error des = %@",string);
//    }else{
//        DLog(@"发送成功");
////		[NSUserDefaults standardUserDefaults] setValue: forKey:nil
//    }
//    DLog(@"req%@",[req description]);
    
}
-(void)sendRequestUserNickNameFailed:(ASIFormDataRequest *)req{
	DLog(@"%@",NSStringFromSelector(_cmd));
}
//Oauth2.0分享调用的方法
-(void)sendImageOauth2{
    NSURL *url = [NSURL URLWithString:SHKRenrenRequestBaseUrl];
    ASIFormDataRequest *req = [[ASIFormDataRequest alloc] initWithURL:url];
    NSString *authToken = [SHK getAuthValueForKey:USER_STORE_ACCESS_TOKEN forSharer:NSStringFromClass([SHKRenren class])];
    NSMutableDictionary *dic  = [[NSMutableDictionary alloc] init];
    [dic setObject:authToken forKey:@"access_token"];
    [dic setObject:@"photos.upload" forKey:@"method"];
    [dic setObject:[item customValueForKey:@"status"]         forKey:@"caption"];
    [dic setObject:@"JSON"         forKey:@"format"];
    [dic setObject:@"1.0"         forKey:@"v"];
    //[dic setObject:@"image/png"         forKey:@"upload"];
    [req setPostValue:authToken    forKey:@"access_token"];
    [req setPostValue:@"photos.upload" forKey:@"method"];
    [req setPostValue:[item customValueForKey:@"status"]         forKey:@"caption"];
    [req setPostValue:@"JSON"         forKey:@"format"];
    [req setPostValue:@"1.0"         forKey:@"v"];
    
    //[req addData:UIImagePNGRepresentation([item image]) forKey:@"upload"];
    [req addData:UIImagePNGRepresentation([item image]) withFileName:@"aaa.png" andContentType:@"image/png" forKey:@"upload"];
    //[self signatureByAsi:dic];
//    NSString * sigBaseString=[NSString stringWithFormat:@"access_token=%@method=%@format=JSONstatus=%@v=1.0%@"
//                              ,authToken,@"photos.upload",nil,SHKRenrenConsumerKey];
    [req setPostValue:[ROUtility md5HexDigest:[self signatureByDic:dic]] forKey:@"sig"];
    
    //2012.11.29 nate Add start 解决内存泄漏
    [dic release];
    //2012.11.29 nate Add end

    req.delegate = self;
	
	[req setDidFinishSelector:@selector(sendRequestFinished:)];
	[req setDidFailSelector:@selector(sendRequestFailed:)];
	
    [req startAsynchronous];
    [req release];

    
    [self sendDidStart];
}
//2012.11.29 nate add 次函数已经废弃，不使用，工具检测出内存泄漏无需关注
-(void)sendRequestFinished:(ASIFormDataRequest *)req{
	DLog(@"%@",NSStringFromSelector(_cmd));
    
    CJSONDeserializer *deserializer = [[CJSONDeserializer alloc] init];
    
    
    //2.0新服务器，不用再转码
    NSData *responseData = [req responseData];
    
    NSDictionary *responseDic = [deserializer deserializeAsDictionary:responseData error:nil];
    //2012.11.29 nate Add start 解决内存泄漏
    [deserializer release];
    //2012.11.29 nate Add end
    NSString *tmp = [responseDic objectForKey:@"error_msg"];
    if(tmp!=nil){
        //错误代码在api查找
        DLog(@"发送失败");
        NSString *string = [[NSString alloc] initWithUTF8String:[tmp UTF8String]];
        //[NSString stringWithUTF8String:[tmp UTF8String]];
        DLog(@"error des = %@",string);
        [string release];
        
		[self sendDidFailWithError:nil];
    }else{
        DLog(@"发送成功");
		[self sendDidFinish];
    }
    DLog(@"req%@",[req description]);
    
}

-(void)sendRequestFailed:(ASIFormDataRequest *)req{
	DLog(@"%@",NSStringFromSelector(_cmd));
	
    [self sendDidFinish];
    [self sendDidFailWithError:req.error];
}

@end
