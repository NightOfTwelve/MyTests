//
//  BTThree20Constant.h
//  AABabyTing3
//
//  Created by Wang Neo on 12-8-25.
//
//

#import <Foundation/Foundation.h>
#import "BTConstant.h"


//typedef enum{
//    type_default = 0,
//    type_home_icon,                       //主界面的icon
//    type_newStory_Intro_icon,             //新故事首发上面的header的图片icon
//    type_newStory_icon,                   //暂时没有使用，新故事首发的前面图片和故事的图片是一个。
//    type_collection_icon,                 //合集的默认插图
//    type_age_category_icon,                   //大分类 大专辑的插图  年龄
//    type_content_category_icon,                     // 内容分类
//    type_book_icon,                       //专辑下的故事书的插图
//    type_story_icon,                      //每一个故事前面的icon
//    type_story_playView,                  //每一个故事在播放界面的插图
//    type_Chosen_intro_icon,               //合集上面的图片
//	type_banner_cell_view,
//    type_radio_icon,                       //故事电台的前面的小icon
//    type_category_intro_icon               //专辑上面的图片
//}ImageType;

@interface BTThree20Constant : NSObject


+ (NSString *)stringByURL:(NSString *)urlPath suffix:(NSString *)aSuffix;

+ (NSString *)getIdFromURL:(NSString *)urlPath;
@end
