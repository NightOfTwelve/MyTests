//
//  TTNetImageView.m
//  320NetworkDemo
//
//  Created by he baochen on 12-3-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTNetImageView.h"
#import "BTNetImageViewDelegate.h"

// Network
#import "TTURLCache.h"
#import "BTURLImageResponse.h"
#import "BTTingImageRequest.h"

#import "NSStringAdditions.h"

#import <QuartzCore/QuartzCore.h>


//controller (早晚得删除，别说我)
#import "BTHomeListViewController.h"
#import "BTChildrenRadioController.h"
#import "BTCategoryListController.h"

//Path
#import "TTGlobalCorePaths.h"

@interface BTNetImageView (Private)

- (BOOL) sendRequest;

@end

@implementation BTNetImageView

@synthesize urlPath             = _urlPath;
@synthesize defaultImage        = _defaultImage;
@synthesize request				= _request;
@synthesize activityIndicatorView = _activityIndicatorView;
@synthesize autoDisplayActivityIndicator = _autoDisplayActivityIndicator;
@synthesize sendRequestOnClick = _sendRequestOnClick;
@synthesize viewController = _viewController;

@synthesize delegate = _delegate;

@synthesize suffix = _suffix;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _autoDisplayActivityIndicator = NO;
        _sendRequestOnClick = NO;
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewDisappear:) name:viewWillDisAppearNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewAppear:) name:viewWillAppearNotification object:nil];
        _defaultFrame = frame;
    }
    return self;
}

- (void)viewAppear:(id)sender{
    NSDictionary *userInfo = [sender userInfo];
    //自己遍历出来
    //UIViewController *controller1 = [self viewController];
    UIViewController *controller2 = [userInfo objectForKey:@"controller"];
    if(_viewController == controller2){
        [self reload];
    }
}

- (void)viewDisappear:(id)sender{
    NSDictionary *userInfo = [sender userInfo];
    //UIViewController *controller1 = [self viewController];
    UIViewController *controller2 = [userInfo objectForKey:@"controller"];
    if(_viewController == controller2){
        [self stopLoading];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        _autoDisplayActivityIndicator = NO;
        _sendRequestOnClick = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewDisappear:) name:viewWillDisAppearNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewAppear:) name:viewWillAppearNotification object:nil];
        _defaultFrame = self.frame;
    }
    return self;
}

- (UIViewController*)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview)
    {
        UIResponder* nextResponder = [next nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController*)nextResponder;
        }
    }
    
    return nil;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _delegate = nil;
    [_request cancel];
    _viewController = nil;
    TT_RELEASE_SAFELY(_suffix);
    TT_RELEASE_SAFELY(_request);
    TT_RELEASE_SAFELY(_urlPath);
    TT_RELEASE_SAFELY(_defaultImage);
    TT_RELEASE_SAFELY(_activityIndicatorView);
    [super dealloc];
}

- (void)setHighlighted:(BOOL)highlighted{
    BOOL lastHighlight = super.highlighted;
    if(highlighted == YES && self.image == _defaultImage){
        _needReloadForHighlight = YES;
    }
    [super setHighlighted:highlighted];
    if(lastHighlight&&!highlighted){
        //todo-list
        if(_needReloadForHighlight){
            _needReloadForHighlight = NO;
            [self reload];
            
        }
    }
}

#pragma mark -
#pragma mark BTURLRequestDelegate


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidStartLoad:(BTTingImageRequest*)request {
    [_request release];
    _request = [request retain];
    
    [self imageViewDidStartLoad];
    if ([_delegate respondsToSelector:@selector(netImageViewDidStartLoad:)]) {
        [_delegate netImageViewDidStartLoad:self];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidFinishLoad:(BTTingImageRequest*)request {
    //DLog(@"finish");
    BTURLImageResponse* response = request.response;
    UIView *view = self.superview;
    if(!view||request.respondedFromCache){  //如果当前的view没有在界面显示，或者image不是从服务器拉取的，不做任何动画。
        
        [self setImage:response.image];
        
        
        [self imageViewDidLoadImage:response.image];
        if ([_delegate respondsToSelector:@selector(netImageView:didLoadImage:)]) {
            [_delegate netImageView:self didLoadImage:response.image];
        }
        TT_RELEASE_SAFELY(_request);
        return;
    }
    ImageType type = [BTUtilityClass getTypeFromSuffix:self.suffix];
    if(type == type_newStory_Intro_icon ||type == type_story_playView ||type ==type_Chosen_intro_icon || type == type_category_intro_icon || type == type_banner_cell_view){
        BTURLImageResponse* response = request.response;
        UIImageView *before = [[UIImageView alloc] initWithFrame:self.frame];
        before.image = self.image;
        //[view addSubview:before];
        [view insertSubview:before aboveSubview:self];
        [before release];
        self.alpha = 0.0f;
        [self setImage:response.image];
        
        
        [UIView animateWithDuration:.5f animations:^{
            self.alpha = 1.0f;
            before.alpha = 0.0f;
        } completion:^(BOOL finished){
            //[after removeFromSuperview];
            [before removeFromSuperview];
            [self imageViewDidLoadImage:response.image];
            if ([_delegate respondsToSelector:@selector(netImageView:didLoadImage:)]) {
                [_delegate netImageView:self didLoadImage:response.image];
            }
            TT_RELEASE_SAFELY(_request);
        }];
        
    }
    else{
        BTURLImageResponse* response = request.response;
        
        
        
        UIViewAnimationOptions options = UIViewAnimationOptionAllowUserInteraction |UIViewAnimationOptionTransitionFlipFromRight;
        
        
        [UIView transitionWithView:self duration:0.5f options:options animations:^{
            self.image = response.image;
        } completion:^(BOOL finished){
            self.image = response.image;
            [self imageViewDidLoadImage:response.image];
            if ([_delegate respondsToSelector:@selector(netImageView:didLoadImage:)]) {
                [_delegate netImageView:self didLoadImage:response.image];
            }
            TT_RELEASE_SAFELY(_request);
        }];
        
//        [UIView animateWithDuration:5.f animations:^{
//            [UIView setAnimationTransition:options forView:self cache:YES];
//            self.image = response.image;
//        } completion:^(BOOL finished){
//            self.image = response.image;
//            [self imageViewDidLoadImage:response.image];
//            if ([_delegate respondsToSelector:@selector(netImageView:didLoadImage:)]) {
//                [_delegate netImageView:self didLoadImage:response.image];
//            }
//            TT_RELEASE_SAFELY(_request);
//        }];
        
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)request:(BTTingImageRequest*)request didFailLoadWithError:(NSError*)error {
    TT_RELEASE_SAFELY(_request);
    
    [self imageViewDidFailLoadWithError:error];
    if ([_delegate respondsToSelector:@selector(netImageView:didFailLoadWithError:)]) {
        [_delegate netImageView:self didFailLoadWithError:error];
    }
}
//

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidCancelLoad:(BTTingImageRequest*)request {
    TT_RELEASE_SAFELY(_request);
    
    [self imageViewDidFailLoadWithError:nil];
    if ([_delegate respondsToSelector:@selector(netImageView:didFailLoadWithError:)]) {
        [_delegate netImageView:self didFailLoadWithError:nil];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isLoading {
    return !!_request;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isLoaded {
    return nil != self.image && self.image != _defaultImage;
}

- (void) setSendRequestOnClick:(BOOL)isLoadOnClick {
    if (_sendRequestOnClick != isLoadOnClick) {
        _sendRequestOnClick = isLoadOnClick;
        self.userInteractionEnabled = _sendRequestOnClick;
    }
}

- (void)setAutoDisplayActivityIndicator:(BOOL) isAutoDisplay {
    if (_autoDisplayActivityIndicator!=isAutoDisplay) {
        _autoDisplayActivityIndicator = isAutoDisplay;
        if (_autoDisplayActivityIndicator) {
            [self addSubview:self.activityIndicatorView];
        } else {
            if (_activityIndicatorView) {
                [_activityIndicatorView removeFromSuperview];
                TT_RELEASE_SAFELY(_activityIndicatorView);
            }
        }
    }
}

- (UIActivityIndicatorView*) activityIndicatorView {
    if (_activityIndicatorView == nil) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityIndicatorView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    }
    return _activityIndicatorView;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)reload {
    if (nil == _request && nil != _urlPath) {
        UIImage* image = [[TTURLCache sharedCache] imageForURL:[BTThree20Constant stringByURL:_urlPath suffix:_suffix]];
        if (nil != image) {
            self.backgroundColor = [UIColor clearColor];
            self.image = image;
        } else {
            if(TTIsBundleURL(_urlPath)){//处理bundle下的图片的处理
                if([[TTURLCache sharedCache] hasImageForURL:_urlPath fromDisk:YES  ]){
                    self.image = [[TTURLCache sharedCache]imageForURL:_urlPath];
                }
            }else if(TTIsDocumentsURL(_urlPath)){//处理docmuments下的图片处理
                //现在还没有doc的图片
                if([[TTURLCache sharedCache] hasImageForURL:_urlPath fromDisk:YES  ]){
                    self.image = [[TTURLCache sharedCache]imageForURL:_urlPath];
                }
            }else{
                BOOL send = NO;
                if (!_sendRequestOnClick) {
                    send = [self sendRequest];
                }
                if (!send) {
                    // Put the default image in place while waiting for the request to load
                    if (_defaultImage && nil == self.image) {
                        self.image = _defaultImage;
                    }
                }
            }
        }
    }
}

- (BOOL) sendRequest {
    BTTingImageRequest* request = (BTTingImageRequest *)[BTTingImageRequest requestWithURL:_urlPath delegate:self];
    request.cachePolicy = TTURLRequestCachePolicyLocal;
    request.response = [[[BTURLImageResponse alloc] init] autorelease];
    request.suffix = _suffix;
    
    // Give the delegate one chance to configure the requester.
    if ([_delegate respondsToSelector:@selector(netImageView:willSendARequest:)]) {
        [_delegate netImageView:self willSendARequest:request];
    }
    return [request send];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)stopLoading {
    [_request cancel];
}



///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)imageViewDidStartLoad {
    if (_autoDisplayActivityIndicator) {
        [_activityIndicatorView startAnimating];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)imageViewDidLoadImage:(UIImage*)image {
    self.layer.borderWidth = -1;
    self.layer.borderColor = [[UIColor clearColor] CGColor];
    self.backgroundColor = [UIColor clearColor];
    if (_autoDisplayActivityIndicator) {
        [_activityIndicatorView stopAnimating];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)imageViewDidFailLoadWithError:(NSError*)error {
    if (_autoDisplayActivityIndicator) {
        [_activityIndicatorView stopAnimating];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark public


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)unsetImage {
    [_activityIndicatorView stopAnimating];
    [self stopLoading];
    self.image = nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setDefaultImage:(UIImage*)theDefaultImage {
    if (_defaultImage != theDefaultImage) {
        [_defaultImage release];
        _defaultImage = [theDefaultImage retain];
    }
    if (nil == _urlPath || 0 == _urlPath.length) {
        //no url path set yet, so use it as the current image
        self.image = _defaultImage;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setUrlPath:(NSString*)urlPath {
    // Check for no changes.
    //当改变不同的urlPath的时候，应该把之前在队列中的request cancel掉（正在发的就不必了）
//    //发现在UITabView的cell重用时发现
//    if(_request&&!_request.isLoading){
//        [_request cancel];
//        TT_RELEASE_SAFELY(_request);
//    }
    if (nil != self.image && nil != _urlPath &&( [urlPath isEqualToString:_urlPath])) {
        return;
    }
    //[self stopLoading];
    [self unsetImage];
    {
        NSString* urlPathCopy = [urlPath copy];
        [_urlPath release];
        _urlPath = urlPathCopy;
    }
    
    if (nil == _urlPath || 0 == _urlPath.length) {
        // Setting the url path to an empty/nil path, so let's restore the default image.
        self.image = _defaultImage;
        
    } else {
        [self reload];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.isLoading && !self.isLoaded) {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        if (CGRectContainsPoint(self.bounds,point)) {
            //DLog(@"%s",__FUNCTION__);
            [self sendRequest];
        }
    }
}



- (void)setImage:(UIImage *)image{
    self.frame = _defaultFrame;
    [super setImage:image];
    int sizeWidth = (int)(image.size.width+0.5);
    int sizeHeight = (int)(image.size.height+0.5);
    //此处不得已而为之，因为这次要换小音符和首页面的图片的frame，只能对这个图片做特殊处理了，
    BOOL isRadioOrCategoryList = ([_viewController isKindOfClass:[BTChildrenRadioController class]]||[_viewController isKindOfClass:[BTCategoryListController class]]);
    //小音符
    if(isRadioOrCategoryList&&((sizeHeight == 45&&sizeWidth ==57)||(sizeHeight == 23&&sizeWidth == 29))){
        self.frame  =  CGRectMake(28, 29, 29, 23);
    }
    //首页
    BOOL isHomePage = [_viewController isKindOfClass:[BTHomeListViewController class]];
    
    
    BOOL newStory =(sizeHeight == 23&&sizeWidth ==29)||(sizeHeight == 46&&sizeWidth == 58);
    BOOL parent = (sizeHeight == 27&&sizeWidth ==26)||(sizeHeight == 53&&sizeWidth == 52);
    BOOL radio = (sizeHeight == 25&&sizeWidth ==29)||(sizeHeight == 50&&sizeWidth == 58);
    BOOL hot = (sizeHeight == 24&&sizeWidth ==31)||(sizeHeight == 48&&sizeWidth == 61);
    BOOL chosen = (sizeHeight == 27&&sizeWidth ==29)||(sizeHeight == 53&&sizeWidth == 58);
    
    if( isHomePage&&(newStory||parent||radio||hot||chosen)){
        self.frame = CGRectMake(21, 19, 29, 25);
    }
}


- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
}

@end
