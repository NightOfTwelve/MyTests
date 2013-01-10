//
//  BTChildrenRadioController.m
//  AABabyTing3
//
//  Created by Neo Wang on 12-8-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTChildrenRadioController.h"
#import "BTRadioAction.h"
#import "BTRadioCell.h"
#import "BTRadioData.h"
#import "BTStoryPlayerController.h"
#import "BTRadioPlayerController.h"
@interface BTChildrenRadioController ()

@end

@implementation BTChildrenRadioController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithHomeData:(NSInteger )dataID{
    self = [super init];
    if(self){
        //DLog(@"%@",homeData.homeID);
        _homeID = dataID;
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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85.0f;
}

// 重写父类的方法（点击）
- (void)didSelectedAtObject:(id)object {
    BTRadioData *radio = (BTRadioData *)object;
    BTRadioPlayerController *radioCtr = [BTPlayerManager sharedInstance].radioPlayer;
    BOOL bIsExist = [[self.navigationController viewControllers] containsObject:radioCtr];
    if (bIsExist) {
        CDLog(BTDFLAG_PRESS_PLAYING_CRASH,@"防止重复push");
        return;
    }
    
    radioCtr.bIsBackToCurrentPlayingLayer = NO;
    radioCtr.storyType = StoryType_Radio;
    radioCtr.radio = radio;
    
    //-------------tiny modify begin------------
    
//    NSString* audioID = [NSString stringWithFormat:@"%@%@",radio.radioID,@"_radio"];
//    NSString *newFlagForAudio = [NSString stringWithFormat:@"%@%@",audioID,@"new"];
//    NSString* newSelectedForAudio = [NSString stringWithFormat:@"%@%@",audioID,@"_selected"];
//    [[NSUserDefaults standardUserDefaults]setValue:@"old" forKey:newFlagForAudio];
//    [[NSUserDefaults standardUserDefaults]synchronize];
//    [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:newSelectedForAudio];
//    [[NSUserDefaults standardUserDefaults]synchronize];

    NSString *key = [NSString stringWithFormat:@"%@_radio", radio.radioID];
    [BTUtilityClass setBookIsOld:key];
    radio.isNew = NO;
    
    //-------------tiny modify end------------
    
    [self.navigationController pushViewController:radioCtr animated:YES];
    [radioCtr startRequestRadio];
}

// 重写父类的方法（更新cell）
- (void)updateTableViewCell:(UITableViewCell *)cell withObject:(id)object {
    BTRadioCell *radioCell = (BTRadioCell *)cell;
    BTRadioData *radioData = (BTRadioData *)object;
    radioCell.radioTitle.text = radioData.radioTitle;
    
    //-------------tiny modify begin------------
    
//    //是否显示new标签
//    NSString* radiodataID = [NSString stringWithFormat:@"%@%@",radioData.radioID,@"_radio"];
//    NSString* newFlagForAudio = [NSString stringWithFormat:@"%@%@",radiodataID,@"_new"];
//    NSString* newSelectedForAudio = [NSString stringWithFormat:@"%@%@",radioData.radioID,@"_selected"];
//    NSString* judgeNew = [[NSUserDefaults standardUserDefaults]objectForKey:newFlagForAudio];
//    NSString* selectedNew = [[NSUserDefaults standardUserDefaults]objectForKey:newSelectedForAudio];
//    if ([judgeNew isEqualToString:@"old"]) {
//        radioCell.theNewFlagPic.hidden = YES;
//    }else{
//        if([selectedNew isEqualToString:@"YES"]){
//            radioCell.theNewFlagPic.hidden = YES;
//        }else{
//            radioCell.theNewFlagPic.hidden = NO;
//        }
//    }
    
    //-------------tiny modify end------------
    
    //radioCell.iconView.frame = CGRectMake(18, 10, 64, 63);
    radioCell.iconView.viewController=self;
    radioCell.iconView.tag = TAG_NetImage;
    radioCell.iconView.defaultImage = TTIMAGE(@"bundle://radio_default.png");
    //radioCell.iconView.type =  type_radio_icon;
    radioCell.iconView.suffix = [BTUtilityClass getPicSuffix:type_radio_icon picVersion:radioData.picVersion];
    radioCell.iconView.urlPath = radioData.radioIconURL;
    
    [radioCell drawCell:radioData];
    
    if(cell.tag == TAG_Last_Cell){
        [radioCell.backButton setImage:[UIImage imageNamed:@"lastBigCategoryCell.png"] forState:UIControlStateNormal];
    }else {
        [radioCell.backButton setImage:[UIImage imageNamed:@"bigCategoryCell.png"] forState:UIControlStateNormal];
    }
}


//如果有自定义的Cell，子类需要重写这个方法
- (UITableViewCell*) tableViewCellForRowAtIndexPath:(NSIndexPath *)indexPath cellIdentifier:(NSString*)identifier {
    UITableViewCell *cell = nil;
    if (cell == nil) {
        NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"BTRadioCell" owner:nil options:nil];
        cell = [objs lastObject];
    }
    return cell;
}

- (BTBaseAction*)action {
    if (_baseAction == nil) {
        NSInteger lastID = 0;
        if([self.itemArray count]>0){
            BTRadioData *data = [self.itemArray lastObject];
            lastID = [data.radioID integerValue];
        }
        _baseAction = [[BTRadioAction alloc] initWithHomeID:_homeID visibleLen:[self.itemArray count] lastID:lastID];
        _baseAction.actionDelegate = self;
    }
    return _baseAction;
}

@end
