//
//  BTImageView.m
//  AABabyTing3
//
//  Created by Wang Neo on 12-9-18.
//
//

#import "BTImageView.h"

@implementation BTImageView


- (void)dealloc{
    [_normalImage release];
    [super dealloc];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self= [super initWithCoder:aDecoder];
    if(self){
        b_isHighlight = NO;
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        b_isHighlight = NO;
    }
    return self;
}



- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    if(highlighted){
        b_isHighlight = YES;
        if(_normalImage){
            [_normalImage release];
        }
        _normalImage = [self.image retain];
        self.image = [self imageWithMask];       
    }
    else{
        b_isHighlight = NO;
        if(_normalImage&&_normalImage!=nil){
            self.image = _normalImage;
        }
    }
}

- (void)setImage:(UIImage *)image{
    [super setImage:image];
    if(!b_isHighlight&&_normalImage){
        [_normalImage release];
        _normalImage = nil;
    }
    
}

- (UIImage *)imageWithColor{
    UIImage *img = nil;
    CGRect rect = CGRectMake(0, 0,self.frame.size.width, self.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context,1.0,1.0,1.0,0.5);
    CGContextFillRect(context, rect);
    img = UIGraphicsGetImageFromCurrentImageContext();
    //2012.12.03 nate del 这里无需在retain 一次img，会造成内存泄漏
    //[img retain];
    UIGraphicsEndImageContext();
    return img;
}

- (UIImage *)imageWithMask{
    UIImage *maskImage = [self imageWithColor];
    CGImageRef imgRef = [self.image CGImage];
    CGImageRef maskRef = [maskImage CGImage];
    CGImageRef actualMask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                              CGImageGetHeight(maskRef),
                                              CGImageGetBitsPerComponent(maskRef),
                                              CGImageGetBitsPerPixel(maskRef),
                                              CGImageGetBytesPerRow(maskRef),
                                              CGImageGetDataProvider(maskRef), NULL, false);
    CGImageRef masked = CGImageCreateWithMask(imgRef, actualMask);
    CGImageRelease(actualMask);
    UIImage *resultImage = [UIImage imageWithCGImage:masked];
	CGImageRelease(masked);
    return resultImage;
}


@end
