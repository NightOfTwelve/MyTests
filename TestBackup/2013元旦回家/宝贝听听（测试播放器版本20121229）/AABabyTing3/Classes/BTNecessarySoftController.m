//
//  BTNecessarySoftController.m
//  AABabyTing3
//
//  Created by Tiny on 12-9-29.
//
//

#import "BTNecessarySoftController.h"

@implementation BTNecessarySoftController
@synthesize softwareWeb = _softwareWeb;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.viewTitle.text = @"父母必备软件";
    self.title = @"父母必备软件";
    actionState = ACTION_NOTNEED;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)openWithHtmlFile:(NSString *)htmlName{

    _softwareWeb = [[BTWebView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-88)];
    [self.view addSubview:_softwareWeb];
    NSString *unZipFolder = [BTUtilityClass fileWithPath:@"parent"];
    NSString *path = [[NSBundle bundleWithPath:unZipFolder] pathForResource:htmlName ofType:@"html"];
    if (path) {
        [_softwareWeb loadWebRequest:[NSURL fileURLWithPath:path]];
    }
}

-(void)dealloc{
    [_softwareWeb release];
    [super dealloc];
}


@end
