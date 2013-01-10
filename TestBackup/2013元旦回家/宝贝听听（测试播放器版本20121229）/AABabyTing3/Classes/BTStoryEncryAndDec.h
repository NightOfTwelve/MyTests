//
//  BTSotryEncryAndDec.h
//  BabyTing
//
//  Created by Neo on 11-12-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BTStoryEncryAndDec : NSObject {

}

+(void)encryptionWithSourcePath:(NSString *)SourcePath targetPath:(NSString *)targetPath;
+(void)decryptWithSourcePath:(NSString *)SourcePath targetPath:(NSString *)targetPath;
+(NSData *)decryptData:(NSData *)encryptedData type:(NSDictionary *)algorithmFac;
@end
