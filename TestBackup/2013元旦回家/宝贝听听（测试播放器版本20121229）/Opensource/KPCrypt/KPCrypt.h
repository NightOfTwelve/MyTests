//
//  KPCrypt.h
//  testEncrypt
//
//  Created by Zero on 11/3/12.
//  Copyright (c) 2012 songzhipeng. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface KPCrypt : NSObject
+ (NSMutableData *)encrypt:(NSData *)data withKey:(NSString *)theKey;
+ (NSMutableData *)decrypt:(NSData *)data withKey:(NSString *)theKey;
@end
