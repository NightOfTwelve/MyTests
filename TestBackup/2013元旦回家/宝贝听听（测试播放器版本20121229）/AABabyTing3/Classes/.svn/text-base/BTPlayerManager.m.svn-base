

#import "BTPlayerManager.h"
#import "BTStoryPlayerController.h"
#import "BTRadioPlayerController.h"
#import "BTPlayerAction.h"
#import "AudioModel.h"
@implementation BTPlayerManager
@synthesize storyPlayer;
@synthesize radioPlayer;
@synthesize playList;
@synthesize playingStoryIndex;
@synthesize listName;
@synthesize storyType;
@synthesize controler_play_mode;
@synthesize playingStoryId;
static BTPlayerManager* sharedLayerManager = nil;

+(BTPlayerManager*)sharedInstance
{
	if (sharedLayerManager == nil)
    {
        sharedLayerManager = [[self alloc]init];
		sharedLayerManager.controler_play_mode = PLAY_MODEL_NONE;
    }
    
    return sharedLayerManager;
}

-(BTStoryPlayerController *)storyPlayer {
    if (!storyPlayer) {
        BTStoryPlayerController *playerCtr=[[BTStoryPlayerController alloc] init];
        self.storyPlayer = playerCtr;
        [playerCtr release];
    }
    if (radioPlayer != nil) {
        [radioPlayer.radioAction cancel];
        if (radioPlayer.playerAction.player != nil) {
            [radioPlayer.playerAction.player stop];
        }
        //[radioPlayer release];
        
    }


    


    self.controler_play_mode = PLAY_MODEL_STORY;
    return storyPlayer;
}
-(BTRadioPlayerController *)radioPlayer {
    if (!radioPlayer) {
        BTRadioPlayerController *radioCtr = [[BTRadioPlayerController alloc] init];
        self.radioPlayer = radioCtr;
        [radioCtr release];
    }
    if (storyPlayer) {
        if (storyPlayer.playerAction.player) {
            [storyPlayer.playerAction.player stop];
        }
        //[storyPlayer release];
    }

    self.controler_play_mode = PLAY_MODEL_RADIO;
    return radioPlayer;
}
-(void)dealloc
{
    [playingStoryId release];
    [radioPlayer release];
    [storyPlayer release];
    [playList release];
    [listName release];
	[super dealloc];
}

@end
