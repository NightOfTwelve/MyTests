


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
	LoadMorePulling = 0,
	LoadMoreNormal,
	LoadMoreLoading,	
} LoadMoreState;

@protocol LoadMoreTableFooterDelegate;
@interface LoadMoreTableFooterView : UIView {
	id _delegate;
	LoadMoreState _state;
	BOOL                                _visible;
	UILabel *_statusLabel;
    UIImageView                 *_statusImageView;
    CALayer                     *_statusLayer;
	UIActivityIndicatorView *_activityView;
}

//visible: (add by zero) 由外部决定上提刷新功能是否可用
@property(nonatomic)		BOOL								visible;		//加载更多页面是否显示（同时是否禁用）
@property(nonatomic,assign) id <LoadMoreTableFooterDelegate>	delegate;

- (void)loadMoreScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)loadMoreScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)loadMoreScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end

@protocol LoadMoreTableFooterDelegate
- (void)loadMoreTableFooterDidTriggerRefresh:(LoadMoreTableFooterView *)view;
- (BOOL)loadMoreTableFooterDataSourceIsLoading:(LoadMoreTableFooterView *)view;
@end
