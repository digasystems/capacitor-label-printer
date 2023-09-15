//
//  BRSetStringTableViewController.m
//  SDK_Sample_Ver2
//
//  Copyright © 2017 Brother Industries, Ltd. All rights reserved.
//

#import "BRSetStringTableViewController.h"
#import "BRAlertViewController.h"
#import "UIColor+CompatiColor.h"

@interface BRSetStringTableViewController ()
@property (strong) BRAlertViewController *brAlertViewController;
@end

@implementation BRSetStringTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.result = [NSMutableDictionary dictionary];

    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pushDone)];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"setstring"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _require.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    float osVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(osVersion >= 8.0f) {
        UIAlertController * alertController =
        [UIAlertController alertControllerWithTitle:cell.textLabel.text
                                            message:nil
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action)
                                    {
                                        UITextField* textField = alertController.textFields.firstObject;
                                        if(textField.text) {
                                            [self.result setObject:textField.text forKey:self.require[indexPath.row]];
                                        }
                                        [tableView deselectRowAtIndexPath:indexPath animated:NO];
                                        [tableView reloadData];
                                    }]];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"set data";
        }];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if (osVersion < 8.0f && osVersion >= 6.0f) {
        self.brAlertViewController = [[BRAlertViewController alloc] initWithTitle:cell.textLabel.text
                                                                                message:@""
                                                                                  style:UIAlertViewStylePlainTextInput
                                                                      cancelButtonTitle:nil
                                                                     cancelButtonAction:nil
                                                                      otherButtonTitles:@"OK"
                                                                      otherButtonAction:^(UIAlertView* alertView)
                                            {
                                                UITextField* textField = [alertView textFieldAtIndex:0];
                                                if(textField.text) {
                                                    [self.result setObject:textField.text forKey:self.require[indexPath.row]];
                                                }
                                                [tableView deselectRowAtIndexPath:indexPath animated:NO];
                                                [tableView reloadData];
                                            }];
        [self.brAlertViewController showAlertView];
    }
}

- (void)pushDone {
    self.completionHandler(self.result);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"setstring"];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSString* title = self.require[indexPath.row];
    cell.textLabel.text = title;
    if(self.result[title]) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"\"%@\"",self.result[title]];
        cell.detailTextLabel.textColor = [UIColor systemGrayColor];
    }
    else {
        cell.detailTextLabel.text = @"tap to input";
        cell.detailTextLabel.textColor = [UIColor systemGray2ColorCompati];
    }

    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
