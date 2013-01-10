//
//  ParabolaView.m
//  AABabyTing3
//
//  Created by bird bird on 12-9-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ParabolaView.h"

@implementation ParabolaView


-(id)initWithImg:(UIImage *)img size:(CGSize)size start:(CGPoint)start {
    self = [super initWithFrame:CGRectMake(0, 0, 320, WINDOW_HEIGHT)];
    if (self) {
        currentClipTime = 0;
        startPoint = start;
        topPoint = CGPointMake(160, startPoint.y / 2);
        bottomPoint = CGPointMake(220, 450);
        _mc = [[UIImageView alloc] init];
        _mc.frame = CGRectMake(0, 0, size.width, size.height); 
        _mc.image = img;
        [self addSubview:_mc];
        [_mc release];
        _mc.center = startPoint;
    }
    return self;
}

-(void)startRuning {

    _ParabolaTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateParabola:) userInfo:nil repeats:YES];
}

-(void)updateParabola:(NSTimeInterval) delta{
    

    
    currentClipTime = currentClipTime + 3 - 2 * (totalClipTime - currentClipTime)/totalClipTime;
    
    
    float t = currentClipTime / totalClipTime;
    if (t >= 1) {
        t = 1;
    }
    float ax,bx,ay,by,tSquared;
    bx = 2 * (topPoint.x - startPoint.x);
    ax = bottomPoint.x + startPoint.x - 2 * topPoint.x;
    by = 2 * (topPoint.y - startPoint.y);
    ay = bottomPoint.y + startPoint.y - 2 * topPoint.y;
    tSquared = t * t;
    
    _mc.transform = CGAffineTransformMakeScale(1 - 0.5 * t, 1 - 0.5 * t);
    float resultX = ax * tSquared + bx * t + startPoint.x;   
    float resultY = ay * tSquared + by * t + startPoint.y;
    _mc.center = CGPointMake(resultX, resultY);
    if (currentClipTime >= totalClipTime) {
        if (_ParabolaTimer) {
            if ([_ParabolaTimer isValid]) {
                [_ParabolaTimer invalidate];
            }
            _ParabolaTimer=nil;
        }
        [self removeFromSuperview];
    }
    
}

- (void)dealloc {
    [super dealloc];
}
@end
