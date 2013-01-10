//
//  CrashReporter.h
//  Analytics
//
//  Created by dong kerry on 11-11-17.
//  Copyright (c) 2011年 tencent.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnaUploader.h"

@protocol CrashUploadResultDelegete <NSObject>

- (void) onUploadCrashSuccess;
- (void) onUploadCrashFail:(NSString*) errorMsg;

@end

typedef int (*exp_callback) ();

extern exp_callback exp_call_back_func;
extern const char * str_internal_build_number;

//!!!!!!!IMPORTANT!!!!!!
//1. you can catch and uplaod crash atomatically, call install method and set upoadAtomaic to "YES"
//   or you can do the upload by yourself ,set uploadAtomatic to "NO"
//   and then implement protocol CrashUploadResultDelegete
//   you can use the method "checkCrash" "uploadCrashes" "cleanCrashRecord"

//2. use this to specify your build, we will use your bundle id,bundler version and this str_internal_build_number to find the mapping file
//   if your project has configured in RDM CI, you don't need to set this 
//   if you set this, you also need to uplaod your mapping file to RDM with  your bundle id,bundle version and str_internal_build_number
//   sample code:  
//   str_internal_build_number="2000";

//3. define you own call back method to do something you want to do, point func to your func address
//   warning: avoid do some hard work
//   sample code :
//   static int fooo () {
//     NSLog(@"haha");
//     return 1;
//     }   
//   exp_call_back_func= &fooo;
@interface CrashReporter : NSObject<AnaUploader> {
    id<CrashUploadResultDelegete> delegate;
}

@property (nonatomic,retain) id<CrashUploadResultDelegete> delegate;

+ (CrashReporter*) sharedInstance;

//register crash handler, and check whether hace crash record for upload,atfer upload will clean the uploaded records
//uin normally is a qq 
- (void) install:(NSString *)uin uploadAtomatic:(BOOL) flag;

//设置一个GUID的标识
- (void) setGUID:(NSString*) guid;

//设置附加的log信息，客户端可以在exp_call_back_func函数中获取自己需要记录的信息并调用改函数保存
-(void) setAttachLog:(NSString*) attLog;

//for user manual check if crash exist
- (BOOL) checkCrash;
//for user manual uplaod all crash info, set CrashUploadResultDelegete to get the upload result
- (BOOL) uploadCrashes:(id)delegate;
//for user manual clean all crash records
- (BOOL) cleanCrashRecord;


@end
