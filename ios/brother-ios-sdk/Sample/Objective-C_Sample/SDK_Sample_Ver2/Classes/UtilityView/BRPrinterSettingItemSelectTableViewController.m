//
//  BRPrinterSettingItemSelectTableViewController.m
//  SDK_Sample_Ver2
//
//  Copyright © 2017 Brother Industries, Ltd. All rights reserved.
//

#import "BRPrinterSettingItemSelectTableViewController.h"
#import <BRLMPrinterKit/BRPtouchPrinterKit.h>

@interface BRPrinterSettingItemSelectTableViewController ()

@end

@implementation BRPrinterSettingItemSelectTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = NO;
    
    self.tableView.allowsMultipleSelection = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pushDone)];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
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
    return [self printerSettingIndexArray].count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
}

- (void)pushDone {
    NSMutableArray* PrinterSettingItems = [NSMutableArray array];
    NSArray* selectedIndexPathArray = [self.tableView indexPathsForSelectedRows];
    for (NSIndexPath* indexPath in selectedIndexPathArray) {
        PrinterSettingItem item = [self printerSettingItemForRowIndex: indexPath.row];
        [PrinterSettingItems addObject:@(item)];
    }
    self.completionHandler(PrinterSettingItems);
}

- (void)cellInitWithCell:(UITableViewCell *)cell title:(NSString*)title tag:(NSInteger)tag {
    cell.textLabel.text = title;
    cell.tag = tag;
}

- (NSArray*)printerSettingIndexArray {
    static NSArray* indexArray;
    if(indexArray == nil) {
        indexArray = @[@(PSI_NET_BOOTMODE),
                            @(PSI_NET_INTERFACE),
                            @(PSI_NET_USED_IPV6),
                            @(PSI_NET_PRIORITY_IPV6),
                            @(PSI_NET_IPV4_BOOTMETHOD),
                            @(PSI_NET_STATIC_IPV4ADDRESS),
                            @(PSI_NET_SUBNETMASK),
                            @(PSI_NET_GATEWAY),
                            @(PSI_NET_DNS_IPV4_BOOTMETHOD),
                            @(PSI_NET_PRIMARY_DNS_IPV4ADDRESS),
                            @(PSI_NET_SECOND_DNS_IPV4ADDRESS),
                            @(PSI_NET_IPV6_BOOTMETHOD),
                            @(PSI_NET_STATIC_IPV6ADDRESS),
                            @(PSI_NET_PRIMARY_DNS_IPV6ADDRESS),
                            @(PSI_NET_SECOND_DNS_IPV6ADDRESS),
                            @(PSI_NET_IPV6ADDRESS_LIST),
                            @(PSI_NET_COMMUNICATION_MODE),
                            @(PSI_NET_SSID),
                            @(PSI_NET_CHANNEL),
                            @(PSI_NET_AUTHENTICATION_METHOD),
                            @(PSI_NET_ENCRYPTIONMODE),
                            @(PSI_NET_WEPKEY),
                            @(PSI_NET_PASSPHRASE),
                            @(PSI_NET_USER_ID),
                            @(PSI_NET_PASSWORD),
                            @(PSI_NET_NODENAME),
                            @(PSI_WIRELESSDIRECT_KEY_CREATE_MODE),
                            @(PSI_WIRELESSDIRECT_SSID),
                            @(PSI_WIRELESSDIRECT_NETWORK_KEY),
                            @(PSI_BT_ISDISCOVERABLE),
                            @(PSI_BT_DEVICENAME),
                            @(PSI_BT_BOOTMODE),
                            @(PSI_PRINTER_POWEROFFTIME),
                            @(PSI_PRINTER_POWEROFFTIME_BATTERY),
                            @(PSI_PRINT_JPEG_HALFTONE),
                            @(PSI_PRINT_JPEG_SCALE),
                            @(PSI_PRINT_DENSITY),
                            @(PSI_PRINT_SPEED),
                            @(PSI_BT_POWERSAVEMODE),
                            @(PSI_BT_SSP),
                            @(PSI_BT_AUTHMODE),
                            @(PSI_BT_AUTO_CONNECTION),
                            ];
    }
    return indexArray;
}

- (PrinterSettingItem)printerSettingItemForRowIndex:(NSInteger)rowIndex {
    NSArray* indexArray = [self printerSettingIndexArray];
    if (rowIndex < 0 || rowIndex >= indexArray.count) {
        return PSI_NET_BOOTMODE;
    }
    return (PrinterSettingItem)[indexArray[rowIndex] integerValue];
}

+ (NSString*)titleForPrinterSettingItem:(PrinterSettingItem)printerSettingItem {
    switch (printerSettingItem) {
        case PSI_NET_BOOTMODE: return @"PSI_NET_BOOTMODE";
        case PSI_NET_INTERFACE: return @"PSI_NET_INTERFACE";
        case PSI_NET_USED_IPV6: return @"PSI_NET_USED_IPV6";
        case PSI_NET_PRIORITY_IPV6: return @"PSI_NET_PRIORITY_IPV6";
        case PSI_NET_IPV4_BOOTMETHOD: return @"PSI_NET_IPV4_BOOTMETHOD";
        case PSI_NET_STATIC_IPV4ADDRESS: return @"PSI_NET_STATIC_IPV4ADDRESS";
        case PSI_NET_SUBNETMASK: return @"PSI_NET_SUBNETMASK";
        case PSI_NET_GATEWAY: return @"PSI_NET_GATEWAY";
        case PSI_NET_DNS_IPV4_BOOTMETHOD: return @"PSI_NET_DNS_IPV4_BOOTMETHOD";
        case PSI_NET_PRIMARY_DNS_IPV4ADDRESS: return @"PSI_NET_PRIMARY_DNS_IPV4ADDRESS";
        case PSI_NET_SECOND_DNS_IPV4ADDRESS: return @"PSI_NET_SECOND_DNS_IPV4ADDRESS";
        case PSI_NET_IPV6_BOOTMETHOD: return @"PSI_NET_IPV6_BOOTMETHOD";
        case PSI_NET_STATIC_IPV6ADDRESS: return @"PSI_NET_STATIC_IPV6ADDRESS";
        case PSI_NET_PRIMARY_DNS_IPV6ADDRESS: return @"PSI_NET_PRIMARY_DNS_IPV6ADDRESS";
        case PSI_NET_SECOND_DNS_IPV6ADDRESS: return @"PSI_NET_SECOND_DNS_IPV6ADDRESS";
        case PSI_NET_IPV6ADDRESS_LIST: return @"PSI_NET_IPV6ADDRESS_LIST";
        case PSI_NET_COMMUNICATION_MODE: return @"PSI_NET_COMMUNICATION_MODE";
        case PSI_NET_SSID: return @"PSI_NET_SSID";
        case PSI_NET_CHANNEL: return @"PSI_NET_CHANNEL";
        case PSI_NET_AUTHENTICATION_METHOD: return @"PSI_NET_AUTHENTICATION_METHOD";
        case PSI_NET_ENCRYPTIONMODE: return @"PSI_NET_ENCRYPTIONMODE";
        case PSI_NET_WEPKEY: return @"PSI_NET_WEPKEY";
        case PSI_NET_PASSPHRASE: return @"PSI_NET_PASSPHRASE";
        case PSI_NET_USER_ID: return @"PSI_NET_USER_ID";
        case PSI_NET_PASSWORD: return @"PSI_NET_PASSWORD";
        case PSI_NET_NODENAME: return @"PSI_NET_NODENAME";
        case PSI_WIRELESSDIRECT_KEY_CREATE_MODE: return @"PSI_WIRELESSDIRECT_KEY_CREATE_MODE";
        case PSI_WIRELESSDIRECT_SSID: return @"PSI_WIRELESSDIRECT_SSID";
        case PSI_WIRELESSDIRECT_NETWORK_KEY: return @"PSI_WIRELESSDIRECT_NETWORK_KEY";
        case PSI_BT_ISDISCOVERABLE: return @"PSI_BT_ISDISCOVERABLE";
        case PSI_BT_DEVICENAME: return @"PSI_BT_DEVICENAME";
        case PSI_BT_BOOTMODE: return @"PSI_BT_BOOTMODE";
        case PSI_PRINTER_POWEROFFTIME: return @"PSI_PRINTER_POWEROFFTIME";
        case PSI_PRINTER_POWEROFFTIME_BATTERY: return @"PSI_PRINTER_POWEROFFTIME_BATTERY";
        case PSI_PRINT_JPEG_HALFTONE: return @"PSI_PRINT_JPEG_HALFTONE";
        case PSI_PRINT_JPEG_SCALE: return @"PSI_PRINT_JPEG_SCALE";
        case PSI_PRINT_DENSITY: return @"PSI_PRINT_DENSITY";
        case PSI_PRINT_SPEED: return @"PSI_PRINT_SPEED";
        case PSI_BT_POWERSAVEMODE: return @"PSI_BT_POWERSAVEMODE";
        case PSI_BT_SSP: return @"PSI_BT_SSP";
        case PSI_BT_AUTHMODE: return @"PSI_BT_AUTHMODE";
        case PSI_BT_AUTO_CONNECTION: return @"PSI_BT_AUTO_CONNECTION";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    PrinterSettingItem item = [self printerSettingItemForRowIndex:indexPath.row];
    [self cellInitWithCell:cell title:[[self class] titleForPrinterSettingItem:item] tag:item];
    
    if(cell.selected) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
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
