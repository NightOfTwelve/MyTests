//
//  SHKSinaUtils.m
//  ShareKit
//
//  Created by K032 on 11-7-14.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SHKSinaUtils.h"


@implementation SHKSinaUtils

+ (NSString *) getOAuthVerifier: (UIWebView *) webView {
    
    NSString *pin;
	
	NSString			*html = [webView stringByEvaluatingJavaScriptFromString: @"document.body.innerText"];
	DLog(@"html:%@", [webView stringByEvaluatingJavaScriptFromString: @"document.body.innerHTML"]);
	
	if (html.length == 0) return nil;
	
	const char			*rawHTML = (const char *) [html UTF8String];
	int					length = strlen(rawHTML), chunkLength = 0;
	
	for (int i = 0; i < length; i++) {
		if (rawHTML[i] < '0' || rawHTML[i] > '9') {
			if (chunkLength == 6) {
				char				*buffer = (char *) malloc(chunkLength + 1);
				
				memmove(buffer, &rawHTML[i - chunkLength], chunkLength);
				buffer[chunkLength] = 0;
				
				pin = [NSString stringWithUTF8String: buffer];
				free(buffer);
				return pin;
			}
			chunkLength = 0;
		} else
			chunkLength++;
	}
	
	return nil;
}


@end
