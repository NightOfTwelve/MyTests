//
//  BTDownLoadAlertView.m
//  全局提示View。单例使用。
//
//  Created by Vicky on 12-8-23.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

// =======================================================
// ** Import **
// =======================================================
#import "BTDownLoadAlertView.h"

// =======================================================
// ** define **
// =======================================================
#define downLoadAlertView_tag   100
#define alertContentTag         200
#define iphoneWindowWidth       320
#define alertHeight             20

// =======================================================
// ** Class **
// =======================================================
static BTDownLoadAlertView *sSharedAlertView = nil;
@implementation BTDownLoadAlertView
@synthesize tipShow;
// =======================================================
// ** 初始化相关 **
// =======================================================
/**
 *  重写初始化方法
 *  iphoneWindowWidth   :[in]竖版iphone的宽度。
 *  alertHeight         :[in]alert的高度。
 *  return              :[sSharedAlertView] BTDownLoadAlertView实例化View。
 */
+(id)sharedAlertView{
	@synchronized (self) {
		if (sSharedAlertView == nil) {
			sSharedAlertView = [[BTDownLoadAlertView alloc] initWithFrame:CGRectMake(0, 0, iphoneWindowWidth, alertHeight)];
		}
	}
	return sSharedAlertView;
}

/**
 *  初始化Frame
 */
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		tipShow = NO;
    }
    return self;
}

// =======================================================
// ** View显示相关 **
// =======================================================
/**
 * 显示内容函数
 * showString :[NSString *]将要显示的文字。
 */
-(void)showDownLoadCompleteAlertWithString:(NSString *)showString{
    NSString *showText = showString;
    
    if (tipShow==YES) { //当显示文字有变更时的操作
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(disappearAlert) object:nil];
        [self modifyModeName:showText];
        [self performSelector:@selector(disappearAlert) withObject:nil afterDelay:3.0];
        return;
    }
    
    //下载完成提示框
    UIView *downLoadAlert = [[UIView alloc] initWithFrame:CGRectMake(0, 0, iphoneWindowWidth, alertHeight)];
    downLoadAlert.backgroundColor = [UIColor blackColor];
    downLoadAlert.tag = downLoadAlertView_tag;
    downLoadAlert.alpha = 0.5;
    UILabel *alertContent = [[UILabel alloc] initWithFrame:CGRectMake(0,0,iphoneWindowWidth,alertHeight)];
    alertContent.text = showText;
    alertContent.backgroundColor = [UIColor clearColor];
    alertContent.font = [UIFont systemFontOfSize:13];
    alertContent.textColor = [UIColor whiteColor];
    alertContent.tag=alertContentTag;
    
    alertContent.textAlignment = UITextAlignmentCenter;
    [downLoadAlert addSubview:alertContent];    

//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, iphoneWindowWidth, alertHeight) ];
//    [button addTarget:self action:@selector(enterToLocalView) forControlEvents:UIControlEventTouchUpInside];
//    button.backgroundColor = [UIColor clearColor];
//    [downLoadAlert addSubview:button];
//    [button release];
    
    //将显示的文字加在View上
    [self addSubview:downLoadAlert];
    
    //动画实现
    [UIView beginAnimations:@"downLoadCompleteAppear" context:nil];
    [UIView setAnimationDuration:0.5];
    [downLoadAlert setCenter:CGPointMake(downLoadAlert.center.x,downLoadAlert.center.y + downLoadAlert.frame.size.height)];
    [UIView setAnimationDelegate:self];
    
    [UIView setAnimationDidStopSelector:@selector(displayAlert)];
    [UIView commitAnimations];
    
    //内存释放
    [downLoadAlert release];
    [alertContent release];
    
    tipShow = YES;
}

/**
 * 把显示内容加到app上，防止被navigationController遮挡
 */
+(void)showAlert {
    BTAppDelegate *delegate = (BTAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:sSharedAlertView];
}

/**
 * 变更显示字符函数
 * name :[NSString *]将要变更的文字。
 */
-(void)modifyModeName:(NSString *)name{
    UIView *downLoadAlert=[self viewWithTag:downLoadAlertView_tag];
    UILabel *alertContent=(UILabel *)[downLoadAlert viewWithTag:alertContentTag];
    alertContent.text=name;
}

/**
 * Alert消失动作
 */
-(void)displayAlert{
    [self performSelector:@selector(disappearAlert) withObject:nil afterDelay:3.0];
}

/**
 * Alert消失动作
 */
-(void)disappearAlert{
    UIView *alert = [self viewWithTag:downLoadAlertView_tag];
    [UIView beginAnimations:@"downLoadCompleteAppear" context:nil];
    [UIView setAnimationDuration:0.5];
    [alert setCenter:CGPointMake(alert.center.x,alert.center.y - alert.frame.size.height)];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeAlertView)];
    [UIView commitAnimations];
}

/**
 * View移除
 */
-(void)removeAlertView{
    UIView *alert = [self viewWithTag:downLoadAlertView_tag];
    [alert removeFromSuperview];
    tipShow = NO;
}
// =======================================================
// ** 析构 **
// =======================================================
/**
 * 析构函数
 */
- (void)dealloc {
    [super dealloc];
}
@end
