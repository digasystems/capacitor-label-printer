//
//  BRSelectWayOfSearchByWiFiTableViewController.m
//  SDK_Sample_Ver2
//
//  Copyright © 2015 Brother Industries, Ltd. All rights reserved.
//

#import "BRSelectWayOfSearchByWiFiTableViewController.h"
#import "BRSearchDeviceByWiFiTableViewController.h"

NSString *kStaticTitle = @"Static IP Address";
NSString *kWiFiSearchTitleIPv4 = @"Search By WiFi(IPv4)";

NSString *segueIdentifierStatic = @"toStaticIPView";
NSString *segueIdentifierWiFi = @"toSearchDeviceByWiFiView";

@interface BRSelectWayOfSearchByWiFiTableViewController () {
    NSArray *searchWays;
}

@end

@implementation BRSelectWayOfSearchByWiFiTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    searchWays = [[NSArray alloc] initWithObjects:kStaticTitle, kWiFiSearchTitleIPv4, nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [searchWays count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *searchWayByWiFiCellIdentifier = @"searchWayByWiFiCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchWayByWiFiCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchWayByWiFiCellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = [searchWays objectAtIndex:indexPath.row];
    
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

#pragma mark - Table view data delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *selectedCellTitle =  [searchWays objectAtIndex:indexPath.row];
    
    if ([selectedCellTitle isEqualToString:kStaticTitle]) {
        [self performSegueWithIdentifier:segueIdentifierStatic sender:self];
    }
    else {
        [self performSegueWithIdentifier:segueIdentifierWiFi sender:self];
    }
}
@end
