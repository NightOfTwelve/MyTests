//
//  SHKRenren.h
//  BabyTing
//
//  Created by Neo Wang on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHKOAuthSharer.h"
#import "SHKRenrenForm.h"

@interface SHKRenren : SHKOAuthSharer {
    BOOL xAuth;		
}

@property BOOL xAuth;

@property (nonatomic, retain) UILabel					*userNickNameLabel;

#pragma mark -
#pragma mark UI Implementation

- (void)showRenrenForm;

#pragma mark -
#pragma mark Share API Methods

- (void)sendForm:(SHKRenrenForm *)form;

- (void)renrenUserNickName:(SHKRenrenForm *)form;
- (void)sendStatus;
- (void)sendStatusTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
- (void)sendStatusTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error;
- (void)sendImage;
- (void)sendImageTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
- (void)sendImageTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error;

@end
