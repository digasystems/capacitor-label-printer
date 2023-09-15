//
//  BRManageTemplateViewController.m
//  SDK_Sample_Ver2
//
//  Copyright (c) 2018 Brother Industries, Ltd. All rights reserved.
//

#import "BRManageTemplateViewController.h"
#import "BRDeleteTemplateViewController.h"

@interface BRManageTemplateViewController ()
@property (nonatomic) UITableView *tableView;
@end

@implementation BRManageTemplateViewController

+ (instancetype)makeInstance {
    BRManageTemplateViewController *viewController = [BRManageTemplateViewController new];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:viewController.view.frame];
    tableView.dataSource = viewController;
    tableView.delegate = viewController;
    viewController.tableView = tableView;
    [viewController.view addSubview:tableView];

    return viewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ManageTemplateCell"];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = NSLocalizedString(@"Get/Delete Templates", nil);
    }
    
    return cell;
}


#pragma mark - UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        // テンプレート削除
        BRDeleteTemplateViewController *viewController = [BRDeleteTemplateViewController makeInstance];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end
