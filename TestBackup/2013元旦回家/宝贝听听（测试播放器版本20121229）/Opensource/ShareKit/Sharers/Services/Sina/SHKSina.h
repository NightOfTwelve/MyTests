//
//  SHKSina.h
//  ShareKit
//
//  Created by K032 on 11-7-7.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHKOAuthSharer.h"
#import "SHKSinaForm.h"


@interface SHKSina : SHKOAuthSharer {
    BOOL xAuth;		
}

@property BOOL xAuth;


#pragma mark -
#pragma mark UI Implementation

- (void)showSinaForm;

#pragma mark -
#pragma mark Share API Methods

- (void)sendForm:(SHKSinaForm *)form;

- (void)sendStatus;
- (void)sendStatusTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
- (void)sendStatusTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error;
- (void)sendImage;
- (void)sendImageTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
- (void)sendImageTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error;
- (void)followMe;

- (void)sendImageOauth2;
- (void)sendTextOauth2;
-(void)followMeOauth2;

@end
