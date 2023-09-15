//
//  BRLMSelectNumberViewController.m
//  SDK_Sample_Ver2
//
//  Copyright © 2015 Brother Industries, Ltd. All rights reserved.
//

#import "BRLMSelectNumberViewController.h"

@interface BRLMSelectNumberViewController ()
@end

@implementation BRLMSelectNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.labels.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"BRLMSelectNumberViewController_textFieldCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BRLMSelectNumberViewController_textFieldCell"];
    }
    cell.textLabel.text = self.labels[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.decisionHandler(self.labels[tableView.indexPathForSelectedRow.row], self.values[tableView.indexPathForSelectedRow.row]);
}

@end
