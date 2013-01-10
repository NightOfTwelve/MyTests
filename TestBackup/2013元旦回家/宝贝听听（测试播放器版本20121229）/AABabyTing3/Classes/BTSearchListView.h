//
//  BTSearchListView.h
//  AABabyTing3
//
//  Created by Wang Neo on 12-9-25.
//
//

#import "BTListViewController.h"
#import "BTStoryCell.h"

@interface BTSearchListView : BTListViewController<BTStoryCellDownLoadPressDelegate>{
    NSString                    *_keyWord;
}
@property(nonatomic,copy) NSString  *keyWord;
- (id)initWithKeyWord:(NSString *)keyWord;

@end
