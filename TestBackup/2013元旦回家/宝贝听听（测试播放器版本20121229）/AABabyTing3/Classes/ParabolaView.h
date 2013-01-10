//
//  ParabolaView.h
//  AABabyTing3
//
//  Created by bird bird on 12-9-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTNetImageView.h"
#define totalClipTime 80
@interface ParabolaView : UIView{
    
    UIImageView *_mc;
    NSTimer     *_ParabolaTimer;
    float       currentClipTime;
    CGPoint     startPoint;
    CGPoint     topPoint;
    CGPoint     bottomPoint;
}
-(id)initWithImg:(UIImage *)img size:(CGSize)size start:(CGPoint)start;
-(void)startRuning;

@end
