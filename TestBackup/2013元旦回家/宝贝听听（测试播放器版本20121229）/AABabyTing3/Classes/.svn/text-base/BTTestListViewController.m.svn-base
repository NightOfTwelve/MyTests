//
//  BTTestListViewController.m
//  AABabyTing3
//
//  Created by He baochen on 12-8-14.
//
//

#import "BTTestListViewController.h"
#import "BTStory.h"
#import "BTTestCell.h"

@interface BTTestListViewController ()

@end

@implementation BTTestListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

//如果有自定义的Cell，子类需要重写这个方法
- (UITableViewCell*) tableViewCellForRowAtIndexPath:(NSIndexPath *)indexPath cellIdentifier:(NSString*)identifier {
  UITableViewCell *cell =[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
  if (cell == nil) {
    //NSArray *objs = [[[NSBundle mainBundle] loadNibNamed:@"TestCell" owner:nil options:nil] autorelease];
    //cell = [objs lastObject];
    
  }
  return cell;
}
   
// 子类重写这个方法实现点击Row
- (void)didSelectedAtObject:(id)object {
#warning
}

// 子类重写这个方法实现更新Cell
- (void)updateTableViewCell:(UITableViewCell *)cell withObject:(id)object {
#warning
  BTStory *story = (BTStory*)object;
  BTTestCell *testCell = (BTTestCell*)cell;
  testCell.netImageView.urlPath = story.iconURL;
  testCell.titleLabel.text = story.title;
  //testCell.descLabel.text = story.desc;
}


//TODO: 这部分的设计需要重新考虑一下
- (BTBaseAction*)action {
#warning
  if (_baseAction == nil) {
	  _baseAction = [[BTBaseAction alloc] init];
//    _baseAction = [[BTTestAction alloc] init];
//    _baseAction.actionDelegate = self;
  }
  return _baseAction;
}


@end
