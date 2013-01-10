//
//  BTStory.m
//  AABabyTing3
//
//  Created by He baochen on 12-8-14.
//
//

#import "BTStory.h"
#import "BTConstant.h"
#import "BTUtilityClass.h"
@implementation BTStory

@synthesize title,speakerName,categoryName,timeLength,pressTime,rankNum,bIsInLocal,storyId,stamp,domain,prodcutVersion,lstory,hstory,state,spic,bpic,isNew,encryType,orderby,picversion,albumid,downloadStamp,playCounts,isUpdated,iconHasExisted,playViewImageHasExisted;
@synthesize tempProgress;
@synthesize lowAudioDownLoadUrl = _lowAudioDownLoadUrl;
@synthesize highAudioDownLoadUrl = _highAudioDownLoadUrl;
@synthesize iconURL = _iconURL;
@synthesize picDownLoadURLs = _picDownLoadURLs;
- (id) initWithDictionary:(NSDictionary*)dict{
    self = [super init];
    if (self) {
        
        self.storyId = [dict objectForKey:KEY_STORY_ID];
        self.title = [dict objectForKey:KEY_STORY_NAME];
        self.spic = [dict objectForKey:KEY_STORY_PIC_SMALL];
        self.speakerName = [dict objectForKey:KEY_STORY_ANNOUNCER];
        self.categoryName = [dict objectForKey:KEY_STORY_CATEGORY_NAME];
        self.bpic = [dict objectForKey:KEY_STORY_PIC_BIG];
        self.domain = [dict objectForKey:KEY_STORY_DOMAIN];
        self.lstory = [dict objectForKey:KEY_STORY_AUDIO_URL_LOW];
        self.hstory = [dict objectForKey:KEY_STORY_AUDIO_URL_HIGH];
        self.timeLength = [dict objectForKey:KEY_STORY_LENGTH];
        self.prodcutVersion = [dict objectForKey:KEY_PRODUCT_VERSION];
        self.orderby = [[dict objectForKey:KEY_STORY_ORDERBY] integerValue];
        self.picversion = [[dict objectForKey:KEY_STORY_PICVERSION] integerValue];
        self.albumid = [[dict objectForKey:KEY_STORY_ALBUMID] integerValue];
        self.downloadStamp = [[dict objectForKey:KEY_STORY_DOWNLOAD_STAMP] integerValue];
        self.playCounts = [[dict objectForKey:KEY_STORY_PLAYCOUNTS] integerValue];
        self.isUpdated = [[dict objectForKey:KEY_STORY_INFO_IS_UPDATED] boolValue];
        self.iconHasExisted = [[dict objectForKey:KEY_STORY_ICON_HAS_EXISTED] boolValue];
        self.playViewImageHasExisted = [[dict objectForKey:KEY_STORY_PLAYVIEW_IMAGE_HAS_EXISTED] boolValue];
        if([dict objectForKey:KEY_STORY_ENCRY_TYPE]){
            self.encryType = [[dict objectForKey:KEY_STORY_ENCRY_TYPE] intValue];
        }else{
            self.encryType = 1;
        }
        
    }
    return self;
}


- (void)dealloc {
    [storyId release];
    [domain release];
    [title release];
    [speakerName release];
    [categoryName release];
    [timeLength release];
    [_picDownLoadURLs release];
    [_lowAudioDownLoadUrl release];
    [_highAudioDownLoadUrl release];
    [_iconURL release];
    [prodcutVersion release];
    [lstory release];
    [hstory release];
    [spic release];
    [bpic release];
    [super dealloc];
}

- (BOOL)isEqual:(id)object {
    if (object != nil) {
        BTStory* another = (BTStory*)object;
        if ([another.storyId isEqualToString:storyId]) {
            return YES;
        }
    }
    return NO;
}

- (NSUInteger)hash {
    return [storyId hash];
}

- (NSString*)lowAudioDownLoadUrl {
    if (_lowAudioDownLoadUrl == nil) {
        if([BTUtilityClass isNetUrl:self.lstory]){
            _lowAudioDownLoadUrl = [self.lstory copy];
        }else{
        _lowAudioDownLoadUrl = [[BTUtilityClass getUrlWithDomain:self.domain
                                               encryptionString:self.lstory
                                                     resourceId:[NSString stringWithFormat:@"%@.mp3",self.storyId]] copy ];
        }
    }
    return _lowAudioDownLoadUrl;
    
    
}

- (NSString*)highAudioDownLoadUrl {
    if (_highAudioDownLoadUrl == nil) {
        if([BTUtilityClass isNetUrl:self.hstory]){
            _highAudioDownLoadUrl = [self.hstory copy];
        }else{
            _highAudioDownLoadUrl = [[BTUtilityClass getUrlWithDomain:self.domain
                                                     encryptionString:self.hstory
                                                           resourceId:[NSString stringWithFormat:@"%@.mp3",self.storyId]] copy];
        }
    }
    return _highAudioDownLoadUrl;
}

-(NSString *)iconURL{
    if(spic == nil||[self.spic length] ==0){
        return nil;
    }
    if (_iconURL == nil) {
        _iconURL = [[BTUtilityClass getUrlWithDomain:self.domain
                                    encryptionString:self.spic
                                       resourceId:[NSString stringWithFormat:@"%@.png",self.storyId]] copy];
    }
    return _iconURL;
}
  
-(NSMutableArray *)picDownLoadURLs{

    if (self.bpic == nil ||[self.bpic count] == 0) {
        return nil;
    }else {
        id url = [self.bpic objectAtIndex:0];
        if(url){
            if([url isKindOfClass:[NSString class]]){
                NSString *str = (NSString *)url;
                if([str length] == 0){
                    return nil;
                }
            }else{
                return nil;
            }
        }else{
            return nil;
        }
    }
    
    if (_picDownLoadURLs == nil) {
        
        _picDownLoadURLs = [[NSMutableArray arrayWithCapacity:1] retain];
        
        for (int i = 0; i < [self.bpic count]; i++) {
            NSString *bigUrl = [BTUtilityClass getUrlWithDomain:self.domain
                                               encryptionString:[self.bpic objectAtIndex:i]
                                                     resourceId:[NSString stringWithFormat:@"%@.png",self.storyId]];
            [_picDownLoadURLs addObject:bigUrl];
        }
    }

    return _picDownLoadURLs;
}


- (NSMutableDictionary*)toDictionary {

    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] initWithCapacity:11] autorelease];
    [dict setValue:self.storyId forKey:KEY_STORY_ID];
    [dict setValue:self.title forKey:KEY_STORY_NAME];
    [dict setValue:self.spic forKey:KEY_STORY_PIC_SMALL];
    [dict setValue:self.speakerName forKey:KEY_STORY_ANNOUNCER];
    [dict setValue:self.categoryName forKey:KEY_STORY_CATEGORY_NAME];
    [dict setValue:self.bpic forKey:KEY_STORY_PIC_BIG];
    [dict setValue:self.domain forKey:KEY_STORY_DOMAIN];
    [dict setValue:self.lstory forKey:KEY_STORY_AUDIO_URL_LOW];
    [dict setValue:self.hstory forKey:KEY_STORY_AUDIO_URL_HIGH];
    [dict setValue:self.timeLength forKey:KEY_STORY_LENGTH];
    [dict setValue:[BTUtilityClass getBundleVersion] forKey:KEY_PRODUCT_VERSION];
    [dict setValue:[NSNumber numberWithInt:self.encryType] forKey:KEY_STORY_ENCRY_TYPE];
    [dict setValue:[NSNumber numberWithInteger:self.orderby] forKey:KEY_STORY_ORDERBY];
    [dict setValue:[NSNumber numberWithInteger:self.picversion] forKey:KEY_STORY_PICVERSION];
    [dict setValue:[NSNumber numberWithInteger:self.albumid] forKey:KEY_STORY_ALBUMID];
    [dict setValue:[NSNumber numberWithInteger:self.downloadStamp] forKey:KEY_STORY_DOWNLOAD_STAMP];
    [dict setValue:[NSNumber numberWithInteger:self.playCounts] forKey:KEY_STORY_PLAYCOUNTS];
    [dict setValue:[NSNumber numberWithBool:self.isUpdated] forKey:KEY_STORY_INFO_IS_UPDATED];
    [dict setValue:[NSNumber numberWithBool:self.iconHasExisted] forKey:KEY_STORY_ICON_HAS_EXISTED];
    [dict setValue:[NSNumber numberWithBool:self.playViewImageHasExisted] forKey:KEY_STORY_PLAYVIEW_IMAGE_HAS_EXISTED];
    
    return dict;
}



@end
