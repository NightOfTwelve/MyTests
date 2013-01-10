//
//  BTAboutViewController.h
//  AABabyTing3
//
//  Created by Zero on 8/29/12.
//
//

#import <UIKit/UIKit.h>
#import "BTTableViewController.h"

@interface BTAboutViewController : BTTableViewController {
    UILabel *versionLabel;
}
- (IBAction)mailClicked:(id)sender;
- (IBAction)websiteClicked:(id)sender;
- (IBAction)tencentWeiboClicked:(id)sender;
- (IBAction)sinaWeiboClicked:(id)sender;
@property (retain, nonatomic) IBOutlet UIView *theView;

@end
