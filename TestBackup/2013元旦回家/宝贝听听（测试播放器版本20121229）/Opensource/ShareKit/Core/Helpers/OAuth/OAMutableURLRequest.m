//
// OAMutableURLRequest.m
// OAuthConsumer
//
// Created by Jon Crosby on 10/19/07.
// Copyright 2007 Kaboomerang LLC. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import "OAMutableURLRequest.h"
#import "SHKConfig.h"
#import <CommonCrypto/CommonHMAC.h>


@interface OAMutableURLRequest (Private)
- (void)_generateTimestamp;
- (void)_generateNonce;
- (NSString *)_signatureBaseString;
@end

@implementation OAMutableURLRequest
@synthesize signature, nonce;

#pragma mark init

- (id)initWithURL:(NSURL *)aUrl
		 consumer:(OAConsumer *)aConsumer
			token:(OAToken *)aToken
            realm:(NSString *)aRealm
signatureProvider:(id<OASignatureProviding, NSObject>)aProvider
{
    if (self = [super initWithURL:aUrl
					  cachePolicy:NSURLRequestReloadIgnoringCacheData
				  timeoutInterval:10.0])
	{
		consumer = [aConsumer retain];
		
		// empty token for Unauthorized Request Token transaction
		if (aToken == nil)
			token = [[OAToken alloc] init];
		else
			token = [aToken retain];
		
		if (aRealm == nil)
			realm = [[NSString alloc] initWithString:@""];
		else
			realm = [aRealm retain];
		
		// default to HMAC-SHA1
		if (aProvider == nil)
			signatureProvider = [[OAHMAC_SHA1SignatureProvider alloc] init];
		else
			signatureProvider = [aProvider retain];
		
		[self _generateTimestamp];
		[self _generateNonce];
		
		didPrepare = NO;
	}
    return self;
}


- (id)initWithURL:(NSURL *)aUrl
		 consumer:(OAConsumer *)aConsumer
			token:(OAToken *)aToken
            realm:(NSString *)aRealm
          content:(NSString *)aContent
signatureProvider:(id<OASignatureProviding, NSObject>)aProvider{ //Add by DuJIn,7.21 for TencentRequest to be init.
    if (self = [super initWithURL:aUrl
					  cachePolicy:NSURLRequestReloadIgnoringCacheData
				  timeoutInterval:10.0])
	{
		consumer = [aConsumer retain];
		
		// empty token for Unauthorized Request Token transaction
		if (aToken == nil)
			token = [[OAToken alloc] init];
		else
			token = [aToken retain];
		
		if (aRealm == nil)
			realm = [[NSString alloc] initWithString:@""];
		else
			realm = [aRealm retain];
		
        if (aContent == nil) {
            content = [[NSString alloc] initWithString:@""];
        }else
            content = [aContent retain];
            
		// default to HMAC-SHA1
		if (aProvider == nil)
			signatureProvider = [[OAHMAC_SHA1SignatureProvider alloc] init];
		else
			signatureProvider = [aProvider retain];
		
		[self _generateTimestamp];
		[self _generateNonce];
		
		didPrepare = NO;
	}
    return self;

}

- (id)initWithURL:(NSURL *)aUrl
		 consumer:(OAConsumer *)aConsumer
			token:(OAToken *)aToken
            realm:(NSString *)aRealm
       friendName:(NSString *)aName
signatureProvider:(id<OASignatureProviding, NSObject>)aProvider{ //Add by DuJIn,7.21 for TencentRequest to be init.
    if (self = [super initWithURL:aUrl
					  cachePolicy:NSURLRequestReloadIgnoringCacheData
				  timeoutInterval:10.0])
	{
		consumer = [aConsumer retain];
		
		// empty token for Unauthorized Request Token transaction
		if (aToken == nil)
			token = [[OAToken alloc] init];
		else
			token = [aToken retain];
		
		if (aRealm == nil)
			realm = [[NSString alloc] initWithString:@""];
		else
			realm = [aRealm retain];
		
        if (aName == nil) {
            friendName = [[NSString alloc] initWithString:@""];
        }else
            friendName = [aName retain];
        
		// default to HMAC-SHA1
		if (aProvider == nil)
			signatureProvider = [[OAHMAC_SHA1SignatureProvider alloc] init];
		else
			signatureProvider = [aProvider retain];
		
		[self _generateTimestamp];
		[self _generateNonce];
		
		didPrepare = NO;
	}
    return self;
    
}

- (id)initWithURL:(NSURL *)aUrl
		 consumer:(OAConsumer *)aConsumer
			token:(OAToken *)aToken
            realm:(NSString *)aRealm
          content:(NSString *)aContent
         imageUrl:(NSString *)url
signatureProvider:(id<OASignatureProviding, NSObject>)aProvider{ //添加分享图片url的请求
    if (self = [super initWithURL:aUrl
					  cachePolicy:NSURLRequestReloadIgnoringCacheData
				  timeoutInterval:10.0])
	{
		consumer = [aConsumer retain];
		
		// empty token for Unauthorized Request Token transaction
		if (aToken == nil)
			token = [[OAToken alloc] init];
		else
			token = [aToken retain];
		
		if (aRealm == nil)
			realm = [[NSString alloc] initWithString:@""];
		else
			realm = [aRealm retain];
        
        if (aContent == nil) {
            content = [[NSString alloc] initWithString:@""];
        }else
            content = [aContent retain];
		
        if (url == nil) {
            imageUrl = [[NSString alloc] initWithString:@""];
        }else
            imageUrl = [url retain];
        
		// default to HMAC-SHA1
		if (aProvider == nil)
			signatureProvider = [[OAHMAC_SHA1SignatureProvider alloc] init];
		else
			signatureProvider = [aProvider retain];
		
		[self _generateTimestamp];
		[self _generateNonce];
		
		didPrepare = NO;
	}
    return self;
    
}

- (id)initWithURL:(NSURL *)aUrl
		 consumer:(OAConsumer *)aConsumer
			token:(OAToken *)aToken
            realm:(NSString *)aRealm
           status:(NSString *)aStatus
signatureProvider:(id<OASignatureProviding, NSObject>)aProvider {  //Add by DuJIn,7.22 for Sina to be init.
    if (self = [super initWithURL:aUrl
					  cachePolicy:NSURLRequestReloadIgnoringCacheData
				  timeoutInterval:10.0])
	{
		consumer = [aConsumer retain];
		
		// empty token for Unauthorized Request Token transaction
		if (aToken == nil)
			token = [[OAToken alloc] init];
		else
			token = [aToken retain];
		
		if (aRealm == nil)
			realm = [[NSString alloc] initWithString:@""];
		else
			realm = [aRealm retain];
		
        if (aStatus == nil) {
            status = [[NSString alloc] initWithString:@""];
        }else
            status = [aStatus retain];
        
		// default to HMAC-SHA1
		if (aProvider == nil)
			signatureProvider = [[OAHMAC_SHA1SignatureProvider alloc] init];
		else
			signatureProvider = [aProvider retain];
		
		[self _generateTimestamp];
		[self _generateNonce];
		
		didPrepare = NO;
	}
    return self;
}

// Setting a timestamp and nonce to known
// values can be helpful for testing
- (id)initWithURL:(NSURL *)aUrl
		 consumer:(OAConsumer *)aConsumer
			token:(OAToken *)aToken
            realm:(NSString *)aRealm
signatureProvider:(id<OASignatureProviding, NSObject>)aProvider
            nonce:(NSString *)aNonce
        timestamp:(NSString *)aTimestamp
{
	if (self = [super initWithURL:aUrl
					  cachePolicy:NSURLRequestReloadIgnoringCacheData
				  timeoutInterval:10.0])
	{
		consumer = [aConsumer retain];
		
		// empty token for Unauthorized Request Token transaction
		if (aToken == nil)
			token = [[OAToken alloc] init];
		else
			token = [aToken retain];
		
		if (aRealm == nil)
			realm = [[NSString alloc] initWithString:@""];
		else
			realm = [aRealm retain];
		
		// default to HMAC-SHA1
		if (aProvider == nil)
			signatureProvider = [[OAHMAC_SHA1SignatureProvider alloc] init];
		else
			signatureProvider = [aProvider retain];
		
		timestamp = [aTimestamp retain];
		nonce = [aNonce retain];
		
		didPrepare = NO;
	}
    return self;
}

- (void)dealloc
{
	[consumer release];
	[token release];
	[realm release];
	[signatureProvider release];
	[timestamp release];
	[nonce release];
	[extraOAuthParameters release];
	[super dealloc];
}

#pragma mark -
#pragma mark Public

- (void)setOAuthParameterName:(NSString*)parameterName withValue:(NSString*)parameterValue
{
	assert(parameterName && parameterValue);
	
	if (extraOAuthParameters == nil) {
		extraOAuthParameters = [NSMutableDictionary new];
	}
	
	[extraOAuthParameters setObject:parameterValue forKey:parameterName];
}

- (void)prepare
{
	if (didPrepare) {
		return;
	}
	didPrepare = YES;
    // sign
	// Secrets must be urlencoded before concatenated with '&'
	// TODO: if later RSA-SHA1 support is added then a little code redesign is needed
    
    NSString *oauthHeader = [self getOauthHeader];
    if (![self.URL.host isEqualToString:@"open.t.qq.com"]) {
        [self setValue:oauthHeader forHTTPHeaderField:@"Authorization"];
    }
}

- (NSString *)getOauthHeader {
    signature = [signatureProvider signClearText:[self _signatureBaseString]
                                      withSecret:[NSString stringWithFormat:@"%@&%@",
												  [consumer.secret URLEncodedString],
                                                  [token.secret URLEncodedString]]];
    
    // set OAuth headers
    NSString *oauthToken;
    if ([token.key isEqualToString:@""])
        oauthToken = @""; // not used on Request Token transactions
    else
        oauthToken = [NSString stringWithFormat:@"oauth_token=\"%@\", ", [token.key URLEncodedString]];
	
	NSMutableString *extraParameters = [NSMutableString string];
	
	// Adding the optional parameters in sorted order isn't required by the OAuth spec, but it makes it possible to hard-code expected values in the unit tests.
	for(NSString *parameterName in [[extraOAuthParameters allKeys] sortedArrayUsingSelector:@selector(compare:)])
	{
		[extraParameters appendFormat:@", %@=\"%@\"",
		 [parameterName URLEncodedString],
		 [[extraOAuthParameters objectForKey:parameterName] URLEncodedString]];
	}
    
    NSString *oauthHeader = [NSString stringWithFormat:@"OAuth realm=\"%@\", oauth_consumer_key=\"%@\", %@oauth_signature_method=\"%@\", oauth_signature=\"%@\", oauth_timestamp=\"%@\", oauth_nonce=\"%@\", oauth_version=\"1.0\"%@",
                       [realm URLEncodedString],
                       [consumer.key URLEncodedString],
                       oauthToken,
                       [[signatureProvider name] URLEncodedString],
                       [signature URLEncodedString],
                       timestamp,
                       nonce,
                       extraParameters];
    
    if ([self.URL.host isEqualToString:@"api.t.sina.com.cn"] && token.pin.length) {
        oauthHeader = [oauthHeader stringByAppendingFormat: @", oauth_verifier=\"%@\"", token.pin]; // Add by DuJin,7.14, for component the http header.
    }
    return oauthHeader;
}

- (NSString *)getURLParmas {  //Add by DuJin, for Tencent API Only.    
    signature = [signatureProvider signClearText:[self _signatureBaseString]
                                      withSecret:[NSString stringWithFormat:@"%@&%@",
												  [consumer.secret URLEncodedString],
                                                  token.secret?[token.secret URLEncodedString]:@""]];
    
    NSString *urlParams;
    
    if (token.pin.length) {
        if (content && imageUrl == nil) {
                urlParams = [NSString stringWithFormat:@"oauth_consumer_key=%@&oauth_nonce=%@&oauth_signature_method=%@&oauth_timestamp=%@&oauth_token=%@&oauth_version=1.0&oauth_signature=%@",
                             [consumer.key URLEncodedString],
                             nonce,
                             [[signatureProvider name] URLEncodedString],
                             timestamp,
                             token.key,
                             [signature URLEncodedString]];
        }else if(imageUrl && content){
            urlParams = [NSString stringWithFormat:@"oauth_consumer_key=%@&oauth_nonce=%@&oauth_signature_method=%@&oauth_timestamp=%@&oauth_token=%@&oauth_version=1.0&oauth_signature=%@",
                         [consumer.key URLEncodedString],
                         nonce,
                         [[signatureProvider name] URLEncodedString],
                         timestamp,
                         token.key,
                         [signature URLEncodedString]];
            
        }else if (friendName) {
            urlParams = [NSString stringWithFormat:@"format=json&name=%@&oauth_consumer_key=%@&oauth_nonce=%@&oauth_signature_method=%@&oauth_timestamp=%@&oauth_token=%@&oauth_version=1.0&oauth_signature=%@",
                         friendName,
                         [consumer.key URLEncodedString],
                         nonce,
                         [[signatureProvider name] URLEncodedString],
                         timestamp,
                         token.key,
                         [signature URLEncodedString]];
        }else {
            urlParams = [NSString stringWithFormat:@"oauth_consumer_key=%@&oauth_nonce=%@&oauth_signature_method=%@&oauth_timestamp=%@&oauth_token=%@&oauth_version=1.0&oauth_signature=%@&oauth_verifier=%@",
                                   [consumer.key URLEncodedString],
                                   nonce,
                                   [[signatureProvider name] URLEncodedString],
                                   timestamp,
                                   token.key,
                                   [signature URLEncodedString],
                                   token.pin];
        }
    }else {
        urlParams = [NSString stringWithFormat:@"oauth_callback=%@&oauth_consumer_key=%@&oauth_nonce=%@&oauth_signature_method=%@&oauth_timestamp=%@&oauth_version=1.0&oauth_signature=%@",
                               [SHKTencentCallbackUrl URLEncodedString],
                               [consumer.key URLEncodedString],
                               nonce,
                               [[signatureProvider name] URLEncodedString],
                               timestamp,
                               [signature URLEncodedString]];
    }
    
    return urlParams;
}

#pragma mark -
#pragma mark Private

- (void)_generateTimestamp
{
    timestamp = [[NSString stringWithFormat:@"%d", time(NULL)] retain];
    //timestamp = [NSString stringWithFormat:@"%d", (int)[[NSDate date] timeIntervalSince1970]];
    //timestamp = [NSString stringWithString:@"1311139254"];
}

- (void)_generateNonce
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    NSMakeCollectable(theUUID);
    //2012.11.29 nate Add start 解决内存泄漏
    CFRelease(theUUID);
    //2012.11.29 nate Add end   
    nonce = (NSString *)string;
    
    if ([self.URL.host isEqualToString:@"open.t.qq.com"]) {
        if (nonce) {
            [nonce release];
        }
        nonce = [[NSString alloc] initWithFormat:@"%u", arc4random() % (9999999 - 123400) + 123400];/////////
    }
}

- (NSString *)_signatureBaseString
{
    // OAuth Spec, Section 9.1.1 "Normalize Request Parameters"
    // build a sorted array of both request parameters and OAuth header parameters
    NSMutableArray *parameterPairs;
    
    
    if ([self.URL.host isEqualToString:@"open.t.qq.com"] && !token.pin.length) {
        parameterPairs = [NSMutableArray arrayWithCapacity:(7)]; // 6 being the number of OAuth params in the Signature Base String
        [parameterPairs addObject:[[OARequestParameter requestParameterWithName:@"oauth_callback" value:SHKTencentCallbackUrl] URLEncodedNameValuePair]];
        [parameterPairs addObject:[[OARequestParameter requestParameterWithName:@"oauth_consumer_key" value:consumer.key] URLEncodedNameValuePair]];
         [parameterPairs addObject:[[OARequestParameter requestParameterWithName:@"oauth_nonce" value:nonce] URLEncodedNameValuePair]];
        [parameterPairs addObject:[[OARequestParameter requestParameterWithName:@"oauth_signature_method" value:[signatureProvider name]] URLEncodedNameValuePair]];
        [parameterPairs addObject:[[OARequestParameter requestParameterWithName:@"oauth_timestamp" value:timestamp] URLEncodedNameValuePair]];
        [parameterPairs addObject:[[OARequestParameter requestParameterWithName:@"oauth_version" value:@"1.0"] URLEncodedNameValuePair]];
    }else if ([self.URL.host isEqualToString:@"open.t.qq.com"] && token.pin.length && content&&imageUrl==nil) {
        parameterPairs = [NSMutableArray arrayWithCapacity:(9)]; // 9 being the number of OAuth params in the Signature Base String
        [parameterPairs addObject:[[OARequestParameter requestParameterWithName:@"clientip" value:@"127.0.0.1"] URLEncodedNameValuePair]];
        [parameterPairs addObject:[[OARequestParameter requestParameterWithName:@"content" value:content] URLEncodedNameValuePair]];
        
        [parameterPairs addObject:[[OARequestParameter requestParameterWithName:@"oauth_consumer_key" value:consumer.key] URLEncodedNameValuePair]];
        [parameterPairs addObject:[[OARequestParameter requestParameterWithName:@"oauth_nonce" value:nonce] URLEncodedNameValuePair]];
        [parameterPairs addObject:[[OARequestParameter requestParameterWithName:@"oauth_signature_method" value:[signatureProvider name]] URLEncodedNameValuePair]];
        [parameterPairs addObject:[[OARequestParameter requestParameterWithName:@"oauth_timestamp" value:timestamp] URLEncodedNameValuePair]];
        [parameterPairs addObject:[[OARequestParameter requestParameterWithName:@"oauth_token" value:token.key] URLEncodedNameValuePair]];
        [parameterPairs addObject:[[OARequestParameter requestParameterWithName:@"oauth_version" value:@"1.0"] URLEncodedNameValuePair]];
    }else if ([self.URL.host isEqualToString:@"open.t.qq.com"] && token.pin.length && content && imageUrl) {
        parameterPairs = [NSMutableArray arrayWithCapacity:(9)]; // 8 being the number of OAuth params in the Signature Base String
        [parameterPairs addObject:[[OARequestParameter requestParameterWithName:@"clientip" value:@"127.0.0.1"] URLEncodedNameValuePair]];
        [parameterPairs addObject:[[OARequestParameter requestParameterWithName:@"content" value:content] URLEncodedNameValuePair]];
        [parameterPairs addObject:[[OARequestParameter requestParameterWithName:@"pic_url" value:imageUrl] URLEncodedNameValuePair]];
        
        [parameterPairs addObject:[[OARequestParameter requestParameterWithName:@"oauth_consumer_key" value:consumer.key] URLEncodedNameValuePair]];
        [parameterPairs addObject:[[OARequestParameter requestParameterWithName:@"oauth_nonce" value:nonce] URLEncodedNameValuePair]];
        [parameterPairs addObject:[[OARequestParameter requestParameterWithName:@"oauth_signature_method" value:[signatureProvider name]] URLEncodedNameValuePair]];
        [parameterPairs addObject:[[OARequestParameter requestParameterWithName:@"oauth_timestamp" value:timestamp] URLEncodedNameValuePair]];
        [parameterPairs addObject:[[OARequestParameter requestParameterWithName:@"oauth_token" value:token.key] URLEncodedNameValuePair]];
        [parameterPairs addObject:[[OARequestParameter requestParameterWithName:@"oauth_version" value:@"1.0"] URLEncodedNameValuePair]];
    }else if ([self.URL.host isEqualToString:@"open.t.qq.com"] && token.pin.length && friendName) {
        parameterPairs = [NSMutableArray arrayWithCapacity:(9)]; // 8 being the number of OAuth params in the Signature Base String
        [parameterPairs addObject:[[OARequestParameter requestParameterWithName:@"format" value:@"json"] URLEncodedNameValuePair]];
        [parameterPairs addObject:[[OARequestParameter requestParameterWithName:@"name" value:friendName] URLEncodedNameValuePair]];        
        [parameterPairs addObject:[[OARequestParameter requestParameterWithName:@"oauth_consumer_key" value:consumer.key] URLEncodedNameValuePair]];
        [parameterPairs addObject:[[OARequestParameter requestParameterWithName:@"oauth_nonce" value:nonce] URLEncodedNameValuePair]];
        [parameterPairs addObject:[[OARequestParameter requestParameterWithName:@"oauth_signature_method" value:[signatureProvider name]] URLEncodedNameValuePair]];
        [parameterPairs addObject:[[OARequestParameter requestParameterWithName:@"oauth_timestamp" value:timestamp] URLEncodedNameValuePair]];
        [parameterPairs addObject:[[OARequestParameter requestParameterWithName:@"oauth_token" value:token.key] URLEncodedNameValuePair]];
        [parameterPairs addObject:[[OARequestParameter requestParameterWithName:@"oauth_version" value:@"1.0"] URLEncodedNameValuePair]];
    }else {
        parameterPairs = [NSMutableArray arrayWithCapacity:(8)]; // 8 being the number of OAuth params in the Signature Base String
        //[parameterPairs addObject:[[OARequestParameter requestParameterWithName:@"oauth_callback" value:SHKTencentCallbackUrl] URLEncodedNameValuePair]];
        [parameterPairs addObject:[[OARequestParameter requestParameterWithName:@"oauth_consumer_key" value:consumer.key] URLEncodedNameValuePair]];
        [parameterPairs addObject:[[OARequestParameter requestParameterWithName:@"oauth_signature_method" value:[signatureProvider name]] URLEncodedNameValuePair]];
        [parameterPairs addObject:[[OARequestParameter requestParameterWithName:@"oauth_timestamp" value:timestamp] URLEncodedNameValuePair]];
        [parameterPairs addObject:[[OARequestParameter requestParameterWithName:@"oauth_nonce" value:nonce] URLEncodedNameValuePair]];
        [parameterPairs addObject:[[OARequestParameter requestParameterWithName:@"oauth_version" value:@"1.0"] URLEncodedNameValuePair]];
        
        if (![token.key isEqualToString:@""]) {
            [parameterPairs addObject:[[OARequestParameter requestParameterWithName:@"oauth_token" value:token.key] URLEncodedNameValuePair]];
        }
        
        if (token.pin.length > 0) 
            [parameterPairs addObject:[[OARequestParameter requestParameterWithName:@"oauth_verifier" value:token.pin] URLEncodedNameValuePair]];		//Add by DuJin,7.14 for the Sina OAuth implementation
        if (status) {
            [parameterPairs addObject:[[OARequestParameter requestParameterWithName:@"source" value:SHKSinaConsumerKey] URLEncodedNameValuePair]];    //Add by DuJin.
            [parameterPairs addObject:[[OARequestParameter requestParameterWithName:@"status" value:status] URLEncodedNameValuePair]];
        }
    }
    
	
	for(NSString *parameterName in [[extraOAuthParameters allKeys] sortedArrayUsingSelector:@selector(compare:)]) {
		[parameterPairs addObject:[[OARequestParameter requestParameterWithName:[parameterName URLEncodedString] value: [[extraOAuthParameters objectForKey:parameterName] URLEncodedString]] URLEncodedNameValuePair]];
	}
	
	if (![[self valueForHTTPHeaderField:@"Content-Type"] hasPrefix:@"multipart/form-data"]) {
		for (OARequestParameter *param in [self parameters]) {
			[parameterPairs addObject:[param URLEncodedNameValuePair]];
		}
	}
    
    NSArray *sortedPairs = [parameterPairs sortedArrayUsingSelector:@selector(compare:)];
    NSString *normalizedRequestParameters = [sortedPairs componentsJoinedByString:@"&"];
    
    // OAuth Spec, Section 9.1.2 "Concatenate Request Elements"
    NSString *ret = [NSString stringWithFormat:@"%@&%@&%@",
					 [self HTTPMethod],
					 [[[self URL] URLStringWithoutQuery] URLEncodedString],
					 [normalizedRequestParameters URLEncodedString]];
	
	SHKLog(@"OAMutableURLRequest parameters %@", normalizedRequestParameters);
	
	return ret;
}

@end
