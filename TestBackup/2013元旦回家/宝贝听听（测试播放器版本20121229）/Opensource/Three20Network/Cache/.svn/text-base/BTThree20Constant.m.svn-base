//
//  BTThree20Constant.m
//  AABabyTing3
//
//  Created by Wang Neo on 12-8-25.
//
//

#import "BTThree20Constant.h"

@implementation BTThree20Constant


+ (NSString *)stringByURL:(NSString *)urlPath suffix:(NSString *)aSuffix{
    NSString *returnStr = nil;
    NSString *resourceID = [BTThree20Constant getIdFromURL:urlPath];
    if(resourceID == nil){
        resourceID = @"";
    }
    returnStr = [NSString stringWithFormat:@"%@%@",resourceID,aSuffix];
    return returnStr;
}

//////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString *)getIdFromURL:(NSString *)urlPath{
    NSArray* childStrArr= [urlPath componentsSeparatedByString:@"/"];
    NSString *IDString = [childStrArr lastObject];
    NSRange ra = [IDString rangeOfString:@"."];
    if (ra.length == 0) {
        return nil;
    }
    NSRange ra2 = NSMakeRange(0, ra.location);
    NSString *ID = [IDString substringWithRange:ra2];
    return ID;
}
@end
