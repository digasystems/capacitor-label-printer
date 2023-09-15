//
//  BRLMInputNumbersViewController.m
//  SDK_Sample_Ver2
//
//  Copyright © 2015 Brother Industries, Ltd. All rights reserved.
//

#import "BRLMInputNumbersViewController.h"

@interface BRLMInputNumbersViewController ()
@end

@implementation BRLMInputNumbersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.decisionHandler(self);
    [super viewWillDisappear:animated];
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
    cell = [tableView dequeueReusableCellWithIdentifier:@"BRLMInputNumbersViewController_textFieldCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BRLMInputNumbersViewController_textFieldCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = self.labels[indexPath.row];
    cell.detailTextLabel.text = self.values[indexPath.row].stringValue;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

- (void)showInputStringViewWithTitle:(NSString*)title message:(NSString *)message placeHolder:(NSString *)placeHolder decisionHandler:(void(^)(NSString*)) handler {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = placeHolder;
        textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        handler(alert.textFields.firstObject.text);
        [self.tableView reloadData];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {}]];
    [self presentViewController:alert animated:YES completion:^{}];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak BRLMInputNumbersViewController* wself = self;
    [self showInputStringViewWithTitle:self.labels[indexPath.row] message:self.values[indexPath.row].stringValue placeHolder:@"" decisionHandler:^(NSString * input) {
        wself.values[indexPath.row] = @([input floatValue]);
    }];
}

@end
