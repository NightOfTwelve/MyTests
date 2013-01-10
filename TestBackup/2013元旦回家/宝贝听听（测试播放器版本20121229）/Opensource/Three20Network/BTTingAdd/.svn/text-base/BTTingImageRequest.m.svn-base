//
//  BTTingImageRequest.m
//  AABabyTing3
//
//  Created by Wang Neo on 12-8-27.
//
//

#import "BTTingImageRequest.h"

@implementation BTTingImageRequest
@synthesize suffix = _suffix;
@synthesize picVersion  =   _picVersion;


- (NSString*)generateCacheKey {

    NSString *str = [BTThree20Constant stringByURL:self.urlPath suffix:self.suffix];
    if(str == nil){
        return [self.urlPath md5Hash];
    }else{
        return str;
    }

}
@end
