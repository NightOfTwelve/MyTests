//
//  BTLocalSortViewController.h
//  AABabyTing3
//
//  Created by Tiny on 12-11-27.
//
//

#import <UIKit/UIKit.h>
#import "BTFxLabelInPopoverView.h"

@protocol BTLocalSortViewControllerDelegate <NSObject>
- (void)didSelectedAtIndex:(NSInteger)selectedIndex;
@end

@interface BTLocalSortViewController : UIViewController{
    
    NSMutableArray *_labels;
    NSMutableArray *_sortTitles;
    id <BTLocalSortViewControllerDelegate> _delegate;
}
@property (nonatomic,assign) id<BTLocalSortViewControllerDelegate> delegate;
@property (nonatomic,assign) NSInteger selectedIndex;
@property (nonatomic, retain) NSMutableArray *labels;
@property (nonatomic, retain) NSMutableArray *sortTitles;
-(id)initWithSortTitles:(NSMutableArray *)titles;

@end
