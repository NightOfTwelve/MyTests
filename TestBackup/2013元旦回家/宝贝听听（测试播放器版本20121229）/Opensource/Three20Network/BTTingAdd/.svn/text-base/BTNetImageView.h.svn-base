//
//  TTNetImageView.h
//  320NetworkDemo
//
//  Created by he baochen on 12-3-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTURLRequestDelegate.h"
#import "BTThree20Constant.h"
#import "BTImageView.h"
#import "BTConstant.h"


@class BTTingImageRequest;
@protocol BTNetImageViewDelegate;
//@class BTImageView;

/**
 * A view that asynchronously loads an image and subsequently displays it.
 */
@interface BTNetImageView : BTImageView<TTURLRequestDelegate> {
    BTTingImageRequest*     _request;
    NSString*               _urlPath;
    UIImage*                _defaultImage;
    
    id<BTNetImageViewDelegate> _delegate;
    
    UIActivityIndicatorView *_activityIndicatorView;
    BOOL _autoDisplayActivityIndicator;
    BOOL _sendRequestOnClick;
    BOOL _needReloadForHighlight;
    
    
    UIViewController        *_viewController;
    CGRect               _defaultFrame;
    
    NSString                *_suffix;
    
}


@property (nonatomic,copy)NSString  *suffix;

//从controller中传入当前的imageView的所属的viewController
@property(nonatomic,assign) UIViewController    *viewController;

//
/**
 * The path of the image. This may be a web path (http://path/to/image.gif) or a local bundle
 * path (bundle://path/to/image.png).
 */
@property (nonatomic, copy) NSString* urlPath;


/**
 * The default image that is displayed until the image has been downloaded. If no urlPath is
 * specified, this image will be displayed indefinitely.
 */
@property (nonatomic, retain) UIImage* defaultImage;

/**
 * Is an asynchronous request currently active?
 */
@property (nonatomic, readonly) BOOL isLoading;

/**
 * Has the image been successfully loaded?
 */
@property (nonatomic, readonly) BOOL isLoaded;

/**
 If YES, load the image when user click on the view
 Default value is NO, auto send http request to get the image
 */
@property (nonatomic) BOOL sendRequestOnClick;

/**
 Display an activityIndicatorView when requesting an image
 Default value is NO
 */
@property (nonatomic) BOOL autoDisplayActivityIndicator;

/**
 The default style is white
 */
@property (nonatomic, readonly) UIActivityIndicatorView *activityIndicatorView;
/**
 * A delegate that notifies you when the image has started and finished loading.
 */
@property (nonatomic, assign) id<BTNetImageViewDelegate> delegate;

/**
 * The TTURLRequest requester used to load this image.
 */
@property (nonatomic, readonly) BTTingImageRequest* request;


/**
 * Cancel any pending request, remove the image, and redraw the view.
 */
- (void)unsetImage;

/**
 * Force the image to be reloaded. If the image is not in the cache, an asynchronous request is
 * sent off to fetch the image.
 */
- (void)reload;

/**
 * Cancel this image views' active asynchronous requests.
 */
- (void)stopLoading;

/**
 * Called when the image begins loading asynchronously.
 * Overridable method.
 *
 * @protected
 */
- (void)imageViewDidStartLoad;

/**
 * Called when the image finishes loading asynchronously.
 * Overridable method.
 *
 * @protected
 */
- (void)imageViewDidLoadImage:(UIImage*)image;

/**
 * Called when the image failed to load asynchronously.
 * Overridable method.
 *
 * @protected
 */
- (void)imageViewDidFailLoadWithError:(NSError*)error;

- (UIViewController*)viewController;

@end
