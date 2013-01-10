//
//  BTBookListController.m
//  AABabyTing3
//
//  Created by Neo Wang on 12-8-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTBookListController.h"
#import "BTBook.h"
#import "BTCategoryCell.h"
#import "BTCategoryData.h"
#import "BTBookListAction.h"
#import "BTOneBookStoryListController.h"
@interface BTBookListController ()

@end

@implementation BTBookListController

- (void)dealloc{
    [_type release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCategoryID:(NSInteger)categoryID type:(NSString *)type{
    self = [super init];
    if(self){
        _categoryID =categoryID;
        _type = [type retain];
    }
    return self;
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

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
    BTOneBookStoryListController *oneChosenController = [[BTOneBookStoryListController alloc] initWithAlbumidID:bookInfo.bookID];
//    BTListViewController *controller = (BTListViewController *)self.navigationController.topViewController;
    self.viewTitle.text = bookInfo.title;
    oneChosenController.title = bookInfo.title;
    //oneChosenController.viewTitle.text = bookInfo.title;
    [self.navigationController pushViewController:oneChosenController animated:YES];
    
    [oneChosenController release];
    
    [BTUtilityClass setBookIsOld:bookInfo.bookID];
    bookInfo.isNew = NO;
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
    [categoryCell drawCategoryCell];
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
        _baseAction = [[BTBookListAction alloc] initWithCategoryID:_categoryID type:_type len:[self.itemArray count] lastId:lastID];
        _baseAction.actionDelegate = self;
    }
    return _baseAction;
}

@end
