//
//  SearchDeviceByMFiTableViewController.m
//  SDK_Sample_Ver2
//
//  Copyright © 2015 Brother Industries, Ltd. All rights reserved.
//

#import "UserDefaults.h"
#import "BRSearchDeviceByMFiTableViewController.h"
#ifndef WLAN_ONLY
#import <BRLMPrinterKit/BRPtouchBluetoothManager.h>
#import <BRLMPrinterKit/BRPtouchDeviceInfo.h>
#import <BRLMPrinterKit/BRLMPrinterKit.h>
#import <BRLMPrinterKit/BRLMPrinterSearcher.h>

#endif

@interface BRSearchDeviceByMFiTableViewController ()
@property (nonatomic) NSMutableArray<BRLMChannel*> *channels;
@end

@implementation BRSearchDeviceByMFiTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getChannels];
    UIBarButtonItem *pairingButton = [[UIBarButtonItem alloc] initWithTitle:@"Pairing" style:UIBarButtonItemStylePlain target:self action:@selector(pairing)];
    [self.navigationItem setRightBarButtonItem:pairingButton];
}

- (void)getChannels {
    BRLMPrinterSearchResult *result = [BRLMPrinterSearcher startBluetoothSearch];
    if(result.error.code == BRLMPrinterSearchErrorNoError) {
        self.channels = [result.channels mutableCopy];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pairing {
    [BRLMPrinterSearcher startBluetoothAccessorySearch:^(BRLMPrinterSearchResult *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Result" message:[NSString stringWithFormat:@"BRLMPrinterSearchErrorCode = %ld", (long)result.error.code] preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                [self getChannels];
                [self.tableView reloadData];
            }]];
            [self presentViewController:alert animated:YES completion:^{}];
        });
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.channels.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSLog(@"cellForRowAtIndexPath");
	static NSString *eaAccessoryCellIdentifier = @"brotherDeviceCellIdentifier";
	NSUInteger row = [indexPath row];
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:eaAccessoryCellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:eaAccessoryCellIdentifier];
	}
    
    NSString *modelName_ = [[self.channels objectAtIndex:row].extraInfo objectForKey:BRLMChannelExtraInfoKeyModelName] ;
    NSString *serialNumber = [self.channels objectAtIndex:row].channelInfo;

    if([modelName_ length] == 0) {
        modelName_ = @"unknown";
    }

    if([serialNumber length] == 0) {
        serialNumber = @"unknown";
    }

	
	[[cell textLabel] setText:modelName_];
	[[cell detailTextLabel] setText:serialNumber];
	
    return cell;
}

#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BRLMChannel *channel = [self.channels objectAtIndex:[indexPath row]];
    NSString *modelName_ = [channel.extraInfo objectForKey:BRLMChannelExtraInfoKeyModelName] ;
    if([modelName_ length] == 0) {
        modelName_ = @"unknown";
    }

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:modelName_ forKey:kSelectedDevice];
    [userDefaults setObject:channel.channelInfo forKey:kSerialNumber];
    [userDefaults setObject:@"" forKey:kIPAddress];
    [userDefaults setObject:@"" forKey:kAdvertiseLocalName];

    [userDefaults setObject:@"0" forKey:kIsWiFi];
    [userDefaults setObject:@"1" forKey:kIsBluetooth];
    [userDefaults setObject:@"0" forKey:kIsBLE];
    [userDefaults setObject:@"Search device from Wi-Fi" forKey:kSelectedDeviceFromWiFi];
    [userDefaults setObject:modelName_ forKey:kSelectedDeviceFromBluetooth];
    [userDefaults setObject:@"Search device from BLE" forKey:kSelectedDeviceFromBLE];
    [userDefaults synchronize];
    
	
	[[self tableView] deselectRowAtIndexPath:indexPath animated:YES];
	[self.navigationController popToRootViewControllerAnimated:YES];
}

@end
