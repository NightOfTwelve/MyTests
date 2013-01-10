//
//  BTWellChosenListController.m
//  AABabyTing3
//
//  Created by Neo Wang on 12-8-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTWellChosenListController.h"
#import "BTChosenAction.h"
#import "BTCategoryCell.h"
#import "BTBook.h"
#import "BTChosenStoryListController.h"

@interface BTWellChosenListController ()

@end

@implementation BTWellChosenListController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithHomeData:(NSInteger)DataID{
    self = [super init];
    if(self){
        //DLog(@"%@",homeData.homeID);
        _homeId = DataID;
    }
    return  self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _loadMoreFooterView.visible = YES;
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85.0f;
}

- (UITableViewCell*) tableViewCellForRowAtIndexPath:(NSIndexPath *)indexPath cellIdentifier:(NSString*)identifier {
    UITableViewCell *cell = nil;
    if (cell == nil) {
        NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"BTCategoryCell" owner:nil options:nil];
        cell = [objs lastObject];
    }
    return cell;
}
// 重写父类的方法（点击）
- (void)didSelectedAtObject:(id)object {
    BTBook *bookInfo = (BTBook *)object;
    BTChosenStoryListController *oneChosenController = [[BTChosenStoryListController alloc] initWithChosenID:[bookInfo.bookID integerValue]];
    oneChosenController.title = bookInfo.title;
    self.viewTitle.text = bookInfo.title;
    [self.navigationController pushViewController:oneChosenController animated:YES];
    NSString *key = [NSString stringWithFormat:@"%@_chosen", bookInfo.bookID];
    [BTUtilityClass setBookIsOld:key];
    bookInfo.isNew = NO;
    [oneChosenController release];
    
}
- (void)doCell:(UITableViewCell *)cell {
    UIView *view = [cell viewWithTag:TAG_NEW_FLAG];
    if (view) {
        view.hidden = YES;
    }
}
// 重写父类的方法（更新cell）
- (void)updateTableViewCell:(UITableViewCell *)cell withObject:(id)object {
    BTCategoryCell *categoryCell = (BTCategoryCell *)cell; 
    BTBook *category = (BTBook *)object;
    categoryCell.bookData = category;
    [categoryCell drawChooseCell];
    [categoryCell setImageViewController:self];
    if(categoryCell.tag == TAG_Last_Cell){
        [categoryCell.backButton setImage:[UIImage imageNamed:@"categoryCell_last.png"] forState:UIControlStateNormal];
    }else {
        [categoryCell.backButton setImage:[UIImage imageNamed:@"categoryCell.png"] forState:UIControlStateNormal];
    }
}

-(BTBaseAction *)action{
    if (_baseAction == nil) {
        NSInteger lastID = 0;
        if([self.itemArray count]>0){
            BTBook *data = [self.itemArray lastObject];
            lastID = [data.bookID integerValue];
        }
        _baseAction = [[BTChosenAction alloc] initWithHomeID:_homeId visibleLen:[self.itemArray count] lastID:lastID];
        _baseAction.actionDelegate = self;
    }
    return _baseAction;
}

@end
