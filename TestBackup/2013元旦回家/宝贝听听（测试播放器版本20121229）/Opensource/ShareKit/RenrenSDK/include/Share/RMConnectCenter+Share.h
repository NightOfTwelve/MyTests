//
//  RMConnectCenter+Share.h
//  RMShareComponent
//
//  Created by 王 永胜 on 12-6-7.
//  Copyright (c) 2012年 人人网. All rights reserved.
//

#import "RMConnectCenter.h"

@protocol RMShareComponentDelegate <NSObject>

/**
 *zh
 * 人人分享界面回调
 * 当分享取消时，关闭分享界面，delegate受到此回调
 *
 *en
 * Call-back method for Renren share view controller.
 * Will be called when Renren share view controller be closed while user cancels share.
 */

- (void)didCloseToShareCancel;
/**
 *zh
 * 人人分享界面回调
 * 当分享成功时，关闭分享界面，delegate受到此回调
 *
 *en
 * Call-back method for Renren share view controller.
 * Will be called when Renren share view controller be closed for the reason of share success.
 */
- (void)didCloseToShareSuccess;


@end



@interface RMConnectCenter (Share)


/**
 *zh
 * 启动功能界面，让用户分享链接到人人网
 *@param url         分享链接的url地址
 *@param title       分享链接的标题
 *@param comment     分享链接的评论
 *@param imageUrl    分享链接的缩略图url地址
 *@param description 分享链接的描述 
 *@param delegate    分享组件的代理
 *en
 * start function interface that lets users share links to renren
 *@param url         links to share the url
 *@param title       share the title of the link
 *@param comment     share links comments
 *@param imageUrl    share links thumbnail url address
 *@param description share links description
 *@param delegate    share component delegate
 */

- (void)launchDashboardShareLinkRequiredUrl:(NSString *)url 
                                      title:(NSString *)title 
                            optionalComment:(NSString *)comment
                                 thumbImage:(NSString *)imageUrl 
                                description:(NSString *)description
                                andDelegate:(id<RMShareComponentDelegate> )delegate;





/**
 *zh
 * 启动功能界面，让用户发布照片到人人网
 *@param image     要上传的图片，仅支持人人网可以上传的图片类型及格式
 *@param caption   图片描述，不得超过240字，可填写一些默认描述，没有可设为nil
 *@param placeData 图片的地址信息，没有可设为nil
 *@param delegate  分享组件的代理
 *
 *en
 *start the function interface to allow users to publish their photos on renren
 *@param image      store the picture going to be uploaded, only support the image type and format which can be uploaded by renren.
 *@param caption    description of the picture which can't be more than 240 words, you can fill in some words as default description or
 *                  just set it to nil.
 *@param placeData  the address information of the picture, set it nil if there aren't any.
 *@param delegate    share component delegate
 */
- (void)launchDashboardSharePhotoRequiredImage:(UIImage *)image 
                               optionalCaption:(NSString *)caption 
                                     placeData:(NSString *)placeData
                                   andDelegate:(id<RMShareComponentDelegate> )delegate;
@end
