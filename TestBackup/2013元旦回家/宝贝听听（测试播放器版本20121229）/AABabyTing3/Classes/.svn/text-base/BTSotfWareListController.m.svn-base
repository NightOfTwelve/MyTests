//
//  BTSotfWareListController.m
//  AABabyTing3
//
//  Created by Neo Wang on 12-8-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTSotfWareListController.h"
#import "BTSoftWareData.h"
#import "BTParentSoftWareCell.h"

@interface BTSotfWareListController ()

@end

@implementation BTSotfWareListController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    actionState = ACTION_NOTNEED;
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view insertSubview:_ropeView belowSubview:self.tableView];
    BTSoftWareData *babyGrow = [[BTSoftWareData alloc] init];
    babyGrow.downloadURL= @"http://itunes.apple.com/cn/app/bao-bei-cheng-zhang-lu/id520023935?mt=8";
    babyGrow.sotfID = @"1";
    BTSoftWareData *babyDraw = [[BTSoftWareData alloc] init];
    babyDraw.downloadURL= @"http://itunes.apple.com/cn/app/bao-bei-hua-hua-kan/id444706489?mt=8";
    babyDraw.sotfID = @"2";
    BTSoftWareData *babyPaiPai = [[BTSoftWareData alloc] init];
    babyPaiPai.downloadURL= @"http://itunes.apple.com/cn/app/bao-bei-pai-pai-gu+/id480128866?mt=8";
    babyPaiPai.sotfID = @"3";
    BTSoftWareData *babyTuTu = [[BTSoftWareData alloc] init];
    babyTuTu.downloadURL= @"http://itunes.apple.com/cn/app/bao-bei-tu-tu-kan-for-iphone/id457826851?mt=8";
    babyTuTu.sotfID = @"4";
    BTSoftWareData *babyPinPin = [[BTSoftWareData alloc] init];
    babyPinPin.downloadURL= @"http://itunes.apple.com/cn/app/bao-bei-pin-pin-kan/id429868822?mt=8";
    babyPinPin.sotfID = @"5";
    self.itemArray = [NSMutableArray arrayWithObjects:babyGrow,babyDraw,babyTuTu,babyPinPin,nil];//去掉拍拍鼓了byDora
	
	[babyGrow release];
	[babyDraw release];
	[babyPaiPai release];
	[babyPinPin release];
	[babyTuTu release];
	
    [self.tableView reloadData];
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
        NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"BTParentSoftWareCell" owner:nil options:nil];
        cell = [objs lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}


//父母必备软件下载
- (void)downLoadSoftWare:(id)data{
    //下载逻辑
    BTSoftWareData *soft = (BTSoftWareData *)data;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:soft.downloadURL]];
}

// 重写父类的方法（更新cell）
- (void)updateTableViewCell:(UITableViewCell *)cell withObject:(id)object {
    BTParentSoftWareCell *softwareCell = (BTParentSoftWareCell *)cell; 
    BTSoftWareData *softwareInfo = (BTSoftWareData *)object;
    softwareCell.softData = softwareInfo;
    softwareCell.softwareDelegate = self;
    [softwareCell drawCell];
    if(cell.tag == TAG_Last_Cell){
        UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"softCell_last.png"]];
        softwareCell.backgroundView = view;
        [view release];
    }else {
        UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"softCell.png"]];
        softwareCell.backgroundView = view;
        [view release];
    }
}

@end
