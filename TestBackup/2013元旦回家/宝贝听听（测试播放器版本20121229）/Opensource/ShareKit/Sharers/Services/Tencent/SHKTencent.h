//
//  SHKTencent.h
//  ShareKit
//
//  Created by K032 on 11-7-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHKOAuthSharer.h"
#import "SHKTencentForm.h"

@interface SHKTencent : SHKOAuthSharer 
{	
	BOOL xAuth;		
}

@property BOOL xAuth;


#pragma mark -
#pragma mark UI Implementation

- (void)showTencentForm;

#pragma mark -
#pragma mark Share API Methods

- (void)sendForm:(SHKTencentForm *)form;

- (void)sendStatus;
- (void)sendStatusTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
- (void)sendStatusTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error;
- (void)sendImage;
- (void)sendImageTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
- (void)sendImageTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error;

- (void)followMe;
- (void)sendImageWithUrl;

@end
