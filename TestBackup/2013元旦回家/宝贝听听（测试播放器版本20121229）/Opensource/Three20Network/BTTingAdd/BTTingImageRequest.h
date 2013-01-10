//
//  BTTingImageRequest.h
//  AABabyTing3
//
//  Created by Wang Neo on 12-8-27.
//
//

#import <Foundation/Foundation.h>
#import "TTURLRequest.h"
#import "BTThree20Constant.h"
#import "NSStringAdditions.h"
@interface BTTingImageRequest : TTURLRequest{
    NSString                *_suffix;
    int                     _picVersion;
}


@property(nonatomic,copy)NSString                *suffix;
@property(assign)int         picVersion;

@end
