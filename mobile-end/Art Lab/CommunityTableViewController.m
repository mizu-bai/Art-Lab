//
//  CommunityTableViewController.m
//  Art Lab
//
//  Created by 李俊宏 on 2021/6/18.
//

#import "CommunityTableViewController.h"
#import "Post.h"
#import "PostCell.h"
#import "PostFrame.h"
#import "NewPostViewController.h"
#import "UIColor+Hex.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface CommunityTableViewController ()

@property(nonatomic, strong) NSArray *postFrames;

@end

@implementation CommunityTableViewController

#pragma mark - Lazy Load

- (NSArray *)postFrames {
    if (_postFrames == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"statuses" ofType:@"plist"];
        NSArray *arrayDict = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *arrayModels = [NSMutableArray array];
        for (NSDictionary *dict in arrayDict) {
            Post *model = [Post postWithDict:dict];
            PostFrame *modelFrame = [[PostFrame alloc] init];
            modelFrame.post = model;
            [arrayModels addObject:modelFrame];
        }
        _postFrames = [arrayModels copy];
    }
    return _postFrames;
}

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"head_background"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#F6F9FF" alpha:1.0];
}



#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.postFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // get data
    PostFrame *model = self.postFrames[(NSUInteger) indexPath.row];
    // create cell
    PostCell *cell = [PostCell postCellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // set data
    cell.postFrame = model;
    // return cell
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostFrame *postFrame = self.postFrames[(NSUInteger) indexPath.row];
    return postFrame.rowHeight;
}

#pragma mark - Table View Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.tableView endEditing:YES];
}



#pragma mark - Send New Post

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NewPostViewController *newPostViewController = segue.destinationViewController;
    newPostViewController.sendPostBlock = ^(PostFrame *postFrame) {
        self.postFrames = [@[postFrame] arrayByAddingObjectsFromArray:self.postFrames];
        [self.tableView reloadData];
    };
}

@end
