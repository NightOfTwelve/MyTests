//
//  BTImageView.h
//  AABabyTing3
//
//  Created by Wang Neo on 12-9-18.
//
//

#import <UIKit/UIKit.h>

@interface BTImageView : UIImageView{
    BOOL                  b_isHighlight;
    UIImage               *_normalImage;
}



- (UIImage *)imageWithColor;

- (UIImage *)imageWithMask;

@end
