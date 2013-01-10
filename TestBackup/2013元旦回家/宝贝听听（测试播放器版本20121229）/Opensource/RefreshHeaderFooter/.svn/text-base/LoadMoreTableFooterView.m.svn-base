

#import "LoadMoreTableFooterView.h"


#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f
#define FOOTER_HEIGHT 60.0f

@interface LoadMoreTableFooterView (Private)
- (void)setState:(LoadMoreState)aState;
@end

@implementation LoadMoreTableFooterView

@synthesize delegate=_delegate,visible = _visible;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 2.0f, self.frame.size.width, 20.0f)];
        label.backgroundColor = [UIColor clearColor];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:18.0f];
		label.textColor = TEXT_COLOR;
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		[label release];

        
        CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake(45,-2 ,13, 32);
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:@"pullArrow.png"].CGImage;
		
		[[self layer] addSublayer:layer];
		_statusLayer=layer;
        
				
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(150.0f, 20.0f, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
		[view release];
		self.hidden = YES;
		
		[self setState:LoadMoreNormal];
    }
	
    return self;	
}


#pragma mark -
#pragma mark Setters

- (void)setState:(LoadMoreState)aState{	
	switch (aState) {
		case LoadMorePulling:
			_statusLabel.text = NSLocalizedString(@"释放立即显示...",nil);
            [UIView animateWithDuration:0.18 animations:^{_statusLayer.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);} completion:^(BOOL finished){}];
			break;
		case LoadMoreNormal:
			_statusLabel.text = NSLocalizedString(@"上拉显示更多...",nil);
			_statusLabel.hidden = NO;
            _statusImageView.hidden = NO;
            _statusLayer.hidden = NO;
            [UIView animateWithDuration:0.18 animations:^{_statusLayer.transform = CATransform3DIdentity;} completion:^(BOOL finished){}];
			[_activityView stopAnimating];
			break;
		case LoadMoreLoading:
			_statusLabel.hidden = YES;
            _statusImageView.hidden = YES;
            _statusLayer.hidden = YES;
			[_activityView startAnimating];
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)loadMoreScrollViewDidScroll:(UIScrollView *)scrollView {
	CDLog(BTDFLAG_RANKLIST_BUG,@"执行DidScroll方法");
	CDLog(BTDFLAG_RANKLIST_BUG,@"footer此时不可见");
	if (!self.visible) {
		return;
	}
	CDLog(BTDFLAG_RANKLIST_BUG,@"footer此时可见");
	if (_state == LoadMoreLoading) {
		scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, FOOTER_HEIGHT, 0.0f);
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(loadMoreTableFooterDataSourceIsLoading:)]) {
			_loading = [_delegate loadMoreTableFooterDataSourceIsLoading:self];
		}
    CGFloat curLoadMoreDeltaY = scrollView.contentOffset.y;
    if (scrollView.bounds.size.height < scrollView.contentSize.height) {
      curLoadMoreDeltaY += scrollView.bounds.size.height - scrollView.contentSize.height;
    }
		if (_state == LoadMoreNormal && curLoadMoreDeltaY > 0 && curLoadMoreDeltaY < FOOTER_HEIGHT && !_loading) {
			self.frame = CGRectMake(0, scrollView.contentSize.height, self.frame.size.width, self.frame.size.height);
			self.hidden = NO;
		} else if (_state == LoadMoreNormal && curLoadMoreDeltaY > FOOTER_HEIGHT && !_loading) {
			[self setState:LoadMorePulling];
		}
		else if (_state == LoadMorePulling && curLoadMoreDeltaY > 0 && curLoadMoreDeltaY < FOOTER_HEIGHT && !_loading) {
			[self setState:LoadMoreNormal];
		}
		
		if (scrollView.contentInset.bottom != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
	}
}

- (void)loadMoreScrollViewDidEndDragging:(UIScrollView *)scrollView {
	if (!self.visible) {
		return;
	}
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(loadMoreTableFooterDataSourceIsLoading:)]) {
		_loading = [_delegate loadMoreTableFooterDataSourceIsLoading:self];
	}
  
  CGFloat curLoadMoreDeltaY = scrollView.contentOffset.y;
  if (scrollView.bounds.size.height < scrollView.contentSize.height) {
    curLoadMoreDeltaY += scrollView.bounds.size.height - scrollView.contentSize.height;
  }
  //DLog(@"curLoadMoreDeltaY = %f _state = %d",curLoadMoreDeltaY, _state);
	if (curLoadMoreDeltaY > FOOTER_HEIGHT && !_loading) {
		if ([_delegate respondsToSelector:@selector(loadMoreTableFooterDidTriggerRefresh:)]) {
			[_delegate loadMoreTableFooterDidTriggerRefresh:self];
		}
		
		[self setState:LoadMoreLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, FOOTER_HEIGHT, 0.0f);
		[UIView commitAnimations];
	}
  
  else if (curLoadMoreDeltaY > 0 && curLoadMoreDeltaY < FOOTER_HEIGHT && !_loading) {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    [UIView commitAnimations];
    [self setState:LoadMoreNormal];
    self.hidden = YES;
  }
}

- (void)loadMoreScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
	if (!self.visible) {
		return;
	}
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[self setState:LoadMoreNormal];
	self.hidden = YES;
}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	_delegate=nil;
	_activityView = nil;
	_statusLabel = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark visible
- (BOOL)visible {
	return _visible;
}
- (void)setVisible:(BOOL)visible {
	CDLog(BTDFLAG_RANKLIST,@"footter.visible=%@",visible?@"YES":@"NO");
	_visible= visible;
	self.hidden = !visible;
}

@end