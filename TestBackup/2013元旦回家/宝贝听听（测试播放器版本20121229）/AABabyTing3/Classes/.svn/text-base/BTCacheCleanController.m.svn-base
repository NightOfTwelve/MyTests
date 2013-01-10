//
//  BTCacheCleanController.m
//  AABabyTing3
//
//  Created by Wang Neo on 12-11-27.
//
//

#import "BTCacheCleanController.h"

@interface BTCacheCleanController ()

@end

@implementation BTCacheCleanController

#define Tag_Alert_ComfirmClean 315
#define TAG_ActiveView 316

#define deepColor     [UIColor colorWithRed:6/255.0 green:59/255.0 blue:104/255.0 alpha:1.0]

#define lowColor      [UIColor colorWithRed:44/255.0 green:116/255.0 blue:177/255.0 alpha:1.0]

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc{
    [cacheTotal release];
    [picCacheNum release];
    [storyCacheNum release];
    [saveFlow release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"本地缓存信息";
    self.viewTitle.text = @"本地缓存信息";
    CGRect rect = [UIScreen mainScreen].bounds;
    rect.origin.y -= 25;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:rect];
    scrollView.userInteractionEnabled = YES;
    scrollView.alwaysBounceVertical = YES;
    scrollView.scrollEnabled = YES;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    [scrollView release];
    
    
    UIView *backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 320, 328)];
    backGroundView.backgroundColor = [UIColor clearColor];
    
    //底图
    UIImageView  *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 318)];
    imageView.userInteractionEnabled = YES;
    imageView.image = [UIImage imageNamed:@"cacheBackGround.png"];
    [backGroundView addSubview:imageView];
    [imageView release];
    
    [self.view insertSubview:_ropeView aboveSubview:self.view];
    
    //苗苗说话的底图
    
    UIImageView *speakerBackGround = [[UIImageView alloc] initWithFrame:CGRectMake(30, 85, 237, 53)];
    speakerBackGround.image = [UIImage imageNamed:@"cacheTotalBackGround.png"];
    [backGroundView addSubview:speakerBackGround];
    speakerBackGround.backgroundColor = [UIColor clearColor];
    [speakerBackGround release];
    

    //节省流量的文字
    saveFlow = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, 237, 18)];
    saveFlow.backgroundColor = [UIColor clearColor];
    saveFlow.textColor = deepColor;
    saveFlow.textAlignment = NSTextAlignmentCenter;
    saveFlow.font = [UIFont boldSystemFontOfSize:15];
    [speakerBackGround addSubview:saveFlow];
    
    
    //总共占的缓存
    cacheTotal = [[UILabel alloc] initWithFrame:CGRectMake(60, 200 , 200, 33)];
    cacheTotal.backgroundColor = [UIColor clearColor];
    cacheTotal.textAlignment = NSTextAlignmentCenter;
    cacheTotal.textColor = deepColor;
    cacheTotal.font = [UIFont boldSystemFontOfSize:16];
    [imageView addSubview:cacheTotal];
    
    
    
    //故事
    storyCacheNum = [[UILabel alloc] initWithFrame:CGRectMake(60, 225, 95, 33)];
    storyCacheNum.backgroundColor = [UIColor clearColor];
    storyCacheNum.textAlignment = NSTextAlignmentRight;
    storyCacheNum.textColor = lowColor;
    storyCacheNum.font = [UIFont boldSystemFontOfSize:16];
    [imageView addSubview:storyCacheNum];
    
    
    //图片
    picCacheNum = [[UILabel alloc] initWithFrame:CGRectMake(165, 225, 95, 33)];
    picCacheNum.backgroundColor = [UIColor clearColor];
    picCacheNum.textAlignment = NSTextAlignmentLeft;
    picCacheNum.textColor = lowColor;
    picCacheNum.font = [UIFont boldSystemFontOfSize:16];
    [imageView addSubview:picCacheNum];
    
    

    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(cleanBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:@"cleanCacheButton.png"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(43, 260, 235,30);
    [imageView addSubview:btn];

    [scrollView addSubview:backGroundView];
    [backGroundView release];
    
    
    //cacheTotal = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, 200, 50)];
    
    
    //storyCacheNum = [[UILabel alloc] initWithFrame:CGRectMake(50, 170, 200, 50)];
    //storyCacheNum.text = [NSString stringWithFormat:@"故事数量:%d",[self getCacheStoryNum]];
    
    //picCacheNum = [[UILabel alloc] initWithFrame:CGRectMake(50, 240, 200, 50)];
    //picCacheNum.text = [NSString stringWithFormat:@"图片数量:%d",[self getCachepicNum]];
    
    
    //saveFlow.text = [NSString stringWithFormat:@"节省的流量:%.1fM",[self getSaveFlow]/1024.0f/1024.0f];
    
    
//
    //[self.view addSubview:cacheTotal];
    //[self.view addSubview:saveFlow];
    //[self.view addSubview:picCacheNum];
    //[self.view addSubview:storyCacheNum];
    
//    [cacheTotal release];
//    [picCacheNum  release];
//    [saveFlow release];
//    [storyCacheNum release];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    actionState = ACTION_NOTNEED;
    [super viewWillAppear:animated];
    [self updateLabelContent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//缓存故事数量
- (int)getCacheStoryNum{
    NSString *filePath = [BTUtilityClass fileWithCacheFolderPath:STORYCACHE_PLIST_NAME];
    NSArray *arr = [NSArray arrayWithContentsOfFile:filePath];
    return [arr count];
}
//缓存的插图的数量
- (int)getCachepicNum{
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:THREE20_DIRECTORY error:nil];
    int total = 0;

    for (NSString *str in files) {
        BOOL isDic = NO;
        NSString *fullPath = [THREE20_DIRECTORY stringByAppendingPathComponent:str];
        [[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDic];
        if(!isDic&&![str hasSuffix:@"_banner"]){
            total++;
        }
    }
    return total;
}


- (double)getCacheTotalCapacity{
    return [BTUtilityClass getCacheTotalCapacity];
}


- (double)getSaveFlow{
    
    NSDictionary *flowDateAndNum = [BTUserDefaults saveFlowAndDate];
    int nowYearAndMonth = [BTUtilityClass getCurrentYearAndMonth];
    int plistRecordDate = [[flowDateAndNum valueForKey:KEY_SAVEFLOW_DATE] intValue];
    double plistRecordNum = [[flowDateAndNum valueForKey:KEY_SAVEFLOW_NUM] doubleValue];
    if(nowYearAndMonth != plistRecordDate){
        plistRecordNum = 0.0f;
    }
    
    return plistRecordNum;
}

- (void)cleanBtnPress:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定要清除缓存吗？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = Tag_Alert_ComfirmClean;
    [alert show];
    [alert release];
}

- (void)cleanCache{
    CDLog(Neoadd,@"kaishi");
    unsigned long long cleanDataMount = 0;
    //缓存故事
    NSArray *storiesArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[BTUtilityClass getStoryCacheFolderPath] error:nil];
    NSMutableArray *tmpArray = [NSMutableArray arrayWithContentsOfFile:[BTUtilityClass fileWithCacheFolderPath:STORYCACHE_PLIST_NAME]];
    for(NSString *str in storiesArray){
        NSString *fullPath = [BTUtilityClass fileWithCacheFolderPath:str] ;
        if([fullPath hasSuffix:@".mp3"]){
            NSDictionary *attribute = [[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:nil];
            unsigned long long size = attribute.fileSize;
            BOOL flag = [[NSFileManager defaultManager] removeItemAtPath:fullPath error:nil];
            NSArray * components = [str componentsSeparatedByString:@"_"];
            NSString *typeString = [components objectAtIndex:2];
            typeString = [typeString stringByReplacingOccurrencesOfString:@".mp3" withString:@""];
            if(flag){
                [tmpArray removeObject:typeString];
                cleanDataMount += size;
            }
        }
    }
    [tmpArray writeToFile:[BTUtilityClass fileWithCacheFolderPath:STORYCACHE_PLIST_NAME] atomically:YES];
    
    
    //320的图片
    NSArray *picsArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:THREE20_DIRECTORY error:nil];
    for(NSString *str in picsArray){
        BOOL isDic = NO;
        NSString *fullPath = [THREE20_DIRECTORY stringByAppendingPathComponent:str];
        [[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDic];
        if(!isDic&&![fullPath hasSuffix:@"_banner"]){
            NSDictionary *attribute = [[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:nil];
        unsigned long long size = attribute.fileSize;
           BOOL flag  =   [[NSFileManager defaultManager] removeItemAtPath:fullPath error:nil];
            if(flag){
                cleanDataMount += size;
            }
        }
    }
    NSNumber *num = [NSNumber numberWithLongLong:cleanDataMount];
    
    //[NSThread sleepForTimeInterval:10.f];
    [self performSelectorOnMainThread:@selector(cleanCacheOver:) withObject:num waitUntilDone:YES];
}


- (void)cleanCacheOver:(NSNumber *)num{
    [self removeWaitingView:num];
    [self updateLabelContent];
    
}

- (void)updateLabelContent{
    
    //UILabel *cacheTotal = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, 200, 50)];
    cacheTotal.text = [NSString stringWithFormat:@"本地缓存数据：%@",[BTUtilityClass changToDiskCapacity:[self getCacheTotalCapacity]/1024.0f/1024.0f]];
    //cacheTotal.text = @"本地缓存数据：1000GB";
    
    //UILabel *storyCacheNum = [[UILabel alloc] initWithFrame:CGRectMake(50, 170, 200, 50)];
    storyCacheNum.text = [NSString stringWithFormat:@"故事：%d个",[self getCacheStoryNum]];
    //storyCacheNum.text = @"故事：99个";
    //UILabel *picCacheNum = [[UILabel alloc] initWithFrame:CGRectMake(50, 240, 200, 50)];
    picCacheNum.text = [NSString stringWithFormat:@"图片：%d个",[self getCachepicNum]];
    
    //picCacheNum.text = @"图片：999个";
    //UILabel *saveFlow = [[UILabel alloc] initWithFrame:CGRectMake(50, 310, 200, 50)];
    saveFlow.text = [NSString stringWithFormat:@"本月为您节省流量：%@",[BTUtilityClass changToDiskCapacity:[self getSaveFlow]]];
    //saveFlow.text = @"已经为您节省流量：1000GB";
}

- (void)showWaitingView{
    waitingAlert = [[UIAlertView alloc]initWithTitle:@"删除中"
                                                  message:nil
                                                 delegate:nil
                                        cancelButtonTitle:nil
                                        otherButtonTitles:nil];
    
    UIActivityIndicatorView *activeView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activeView.center = CGPointMake(140, 70);
    [activeView startAnimating];
    activeView.tag = TAG_ActiveView;
    [waitingAlert addSubview:activeView];
    [waitingAlert show];

    [activeView release];
    [waitingAlert release];
}

- (void)removeWaitingView:(NSNumber *)num{
    [waitingAlert dismissWithClickedButtonIndex:0 animated:NO];
    
    [self addSuccessAlert:num];
}

- (void)addSuccessAlert:(NSNumber *)num{
    
    double size = [num longLongValue]/1024.0f/1024.0f;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"清理完毕" message:[NSString stringWithFormat:@"已为您清理出%@的空间!",[BTUtilityClass changToDiskCapacity:size]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag = Tag_Alert_ComfirmClean){
        if(buttonIndex == 1){
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
            [self showWaitingView];
            [self performSelectorInBackground:@selector(cleanCache) withObject:nil];
        }
    }
}



@end
