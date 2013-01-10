//
//  BTTextField.h
//  AABabyTing3
//
//  Created by Wang Neo on 12-9-25.
//
//

#import <UIKit/UIKit.h>

typedef enum{SearchType = 0,FeedBackTpe}PlaceHolerColorType;

@interface BTTextField : UITextField{
    PlaceHolerColorType type;
}
@property (nonatomic) PlaceHolerColorType type;
- (void) drawPlaceholderInRect:(CGRect)rect;
@end
