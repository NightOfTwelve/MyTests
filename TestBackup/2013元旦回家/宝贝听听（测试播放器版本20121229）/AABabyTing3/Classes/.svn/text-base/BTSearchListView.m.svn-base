//
//  BTSearchListView.m
//  AABabyTing3
//
//  Created by Wang Neo on 12-9-25.
//
//

#import "BTSearchListView.h"
#import "BTSearchAction.h"
#import "BTStory.h"
#import "BTStoryCell.h"
#import "ParabolaView.h"
#import "BTStoryPlayerController.h"
#import "BTDownLoadManager.h"
@interface BTSearchListView ()

@end



@implementation BTSearchListView


@synthesize keyWord = _keyWord;

- (void)dealloc{
    [_keyWord release];
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

- (id)initWithKeyWord:(NSString *)keyWord{
    self = [super init];
    if(self){
        _keyWord = [keyWord retain];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modifyPlayStoryPlayingStatus:) name:NOTIFICATION_PLAY_STORY object:nil];
    
}
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)modifyPlayStoryPlayingStatus:(NSNotification *)sender {
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestNullData{
    [super requestNullData];
    //处理。。。。
    UIImageView *noResult = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 320, 370)];
    noResult.image = [UIImage imageNamed:@"searchNoResult.png"];
    [self.view addSubview:noResult];
	[noResult release];
}

- (BTBaseAction *)action{
    if (_baseAction == nil) {
        _baseAction = [[BTSearchAction alloc] initWithKeyWord:_keyWord];
        _baseAction.actionDelegate = self;
    }
    return _baseAction;
}
//单个故事下载动画
-(void)stroyDownloadAnimation:(BTStory *)storyData{
    int index = [self.itemArray indexOfObject:storyData];
    CGPoint point = [_tableView contentOffset];
    CGPoint startPoint = CGPointMake(52, index * 57 - point.y + 85);
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@_storyIcon",THREE20_DIRECTORY,storyData.storyId];
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    if (!image) {
        
        NSString *path = [NSString stringWithFormat:@"bundle://story_cell_default.png"];
        image = TTIMAGE(path);
    }
    if (image) {
        ParabolaView *parabola = [[ParabolaView alloc]initWithImg:image size:CGSizeMake(41, 41) start:startPoint];
        [self.view addSubview:parabola];
        [parabola release];
        [parabola startRuning];
    }
}

//点击故事下载
- (void)storyDownLoad:(BTStory *)storyData{
    //    DLog(@"热门故事下载%@",storyData.title);
    
    if ([BTUtilityClass isNetWorkNotAvailable]) {
        [[BTDownLoadManager sharedInstance] showNoNetWorkAlert];
        return;
    }
    
    if ([[BTDownLoadManager sharedInstance] showDownloadAlert]) {
        return;
    }
    
    storyData.bIsInLocal = YES;
    [self.tableView reloadData];
    
    if (![[BTDownLoadManager sharedInstance] isInMyStoryList:storyData]) {
        [[BTDownLoadManager sharedInstance] addNewDownLoadTask:storyData];
        [BTUtilityClass setTabBarBadgeNumber:1];
        [self stroyDownloadAnimation:storyData];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 57.0f;
}

// 重写父类的方法（点击）
- (void)didSelectedAtObject:(id)object {
    //    DLog(@"进入到播放界面333");
    BTStoryPlayerController *playerCtr = [BTPlayerManager sharedInstance].storyPlayer;
    BOOL bIsExist = [[self.navigationController viewControllers] containsObject:playerCtr];
    if (bIsExist) {
        CDLog(BTDFLAG_PRESS_PLAYING_CRASH,@"防止重复push");
        return;
    }
    
    NSMutableArray *playListArray = [[NSMutableArray alloc] init];
    [playListArray addObject:object];

    playerCtr.bIsBackToCurrentPlayingLayer = NO;
    playerCtr.playList = playListArray;
    playerCtr.playingStoryIndex = 0;
    playerCtr.storyType = StoryType_Net;
    [self.navigationController pushViewController:playerCtr animated:YES];
    [playerCtr playStory];
    [playListArray release];
    BTStory *story = (BTStory *)object;
    story.isNew = NO;
}
- (void)doCell:(UITableViewCell *)cell {
    UIView *view = [cell viewWithTag:TAG_NEW_FLAG];
    if (view) {
        view.hidden = YES;
    }
}
// 重写父类的方法（更新cell）
- (void)updateTableViewCell:(UITableViewCell *)cell withObject:(id)object {
    BTStoryCell *storyCell = (BTStoryCell *)cell;
    BTStory *storyData = (BTStory *)object;
    NSInteger index = [self.itemArray indexOfObject:storyData];
    storyData.rankNum = index + 1;
    storyCell.storyDelegate= self;
    storyCell.storyData = storyData;
	storyCell.keyword = _keyWord;
    [storyCell setCellData];
    [storyCell setImageController:self];
    
    if(storyCell.tag == TAG_Last_Cell){
        [storyCell.backButton setImage:[UIImage imageNamed:@"myStory_cell_last_bg.png"] forState:UIControlStateNormal];
    }else {
        [storyCell.backButton setImage:[UIImage imageNamed:@"myStory_cell_bg.png"] forState:UIControlStateNormal];
    }
}
//如果有自定义的Cell，子类需要重写这个方法
- (UITableViewCell*) tableViewCellForRowAtIndexPath:(NSIndexPath *)indexPath cellIdentifier:(NSString*)identifier {
    UITableViewCell *cell = nil;
    if (cell == nil) {
        NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"BTStoryCell" owner:nil options:nil];
        cell = [objs lastObject];
    }
    return cell;
}

@end
