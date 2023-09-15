//
//  BRSearchDeviceByWiFiViewControllerTableViewController.m
//  SDK_Sample_Ver2
//
//  Copyright (c) 2018 Brother Industries, Ltd. All rights reserved.
//

#import "UserDefaults.h"
#import "BRSearchDeviceByBLETableViewController.h"
#import <BRLMPrinterKit/BRPtouchBLEManager.h>
#import <BRLMPrinterKit/BRLMPrinterKit.h>
#import <BRLMPrinterKit/BRLMPrinterSearcher.h>

@interface BRSearchDeviceByBLETableViewController ()
@property (nonatomic) NSMutableArray<BRLMChannel*> *channels;
@property (nonatomic) UIView *loadingView;
@property (nonatomic) UIActivityIndicatorView *indicator;


@end

@implementation BRSearchDeviceByBLETableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.channels = [[NSMutableArray alloc] initWithCapacity:0];
    [self showIndicator];

    // Start printer search(Sub thread)
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        BRLMBLESearchOption *option = [self createOption];
        BRLMPrinterSearchResult * result = [BRLMPrinterSearcher startBLESearch:option callback:^(BRLMChannel *channel){
            [self.channels addObject:channel];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self stopIndicator];
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Result" message:[NSString stringWithFormat:@"BRLMPrinterSearchErrorCode = %ld", (long)result.error.code] preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {}]];
            [self presentViewController:alert animated:YES completion:^{}];
        });
    }];
}

- (BRLMBLESearchOption *)createOption
{
    const int searchTimeSec = 15;
    BRLMBLESearchOption *option = [[BRLMBLESearchOption alloc] init];
    option.searchDuration = searchTimeSec;
    return option;
}

- (void)cancelSearch:(UIButton*)button{
    [BRLMPrinterSearcher cancelBLESearch];
}


- (void)showIndicator
{
    self.loadingView = [[UIView alloc] initWithFrame:[self.parentViewController.view bounds]];
    [self.loadingView setBackgroundColor:[UIColor blackColor]];
    [self.loadingView setAlpha:self.view.alpha / 2];
    [self.parentViewController.view addSubview:self.loadingView];
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    CGFloat indicatorSize = 40.0;
    CGFloat btnSize = 60;
    CGFloat margin = 40;
    self.indicator.frame = CGRectMake(0, 0, indicatorSize, indicatorSize);
    self.indicator.center = CGPointMake(self.loadingView.center.x, self.loadingView.center.y - margin / 2);
    [self.loadingView addSubview:self.indicator];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(0, 0, btnSize, btnSize / 2);
    btn.center = CGPointMake(self.loadingView.center.x, self.loadingView.center.y + margin / 2);
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [btn setTitle:@"Cancel" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(cancelSearch:) forControlEvents:UIControlEventTouchDown];
    [self.loadingView addSubview:btn];
    [self.indicator startAnimating];
}

- (void)stopIndicator
{
    [self.indicator stopAnimating];
    [self.indicator removeFromSuperview];
    [self.loadingView removeFromSuperview];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    NSString *advertiseLocalName = [self.channels objectAtIndex:row].channelInfo;

    if([modelName_ length] == 0) {
        modelName_ = @"unknown";
    }

    if([advertiseLocalName length] == 0) {
        advertiseLocalName = @"unknown";
    }

    
    [[cell textLabel] setText:modelName_];
    [[cell detailTextLabel] setText:advertiseLocalName];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BRLMChannel *channel = [self.channels objectAtIndex:[indexPath row]];
    NSString *modelName_ = [channel.extraInfo objectForKey:BRLMChannelExtraInfoKeyModelName] ;
    if([modelName_ length] == 0) {
        modelName_ = @"unknown";
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"" forKey:kIPAddress];
    [userDefaults setObject:@"" forKey:kSerialNumber];
    [userDefaults setObject:channel.channelInfo forKey:kAdvertiseLocalName];
    [userDefaults setObject:@"0" forKey:kIsWiFi];
    [userDefaults setObject:@"0" forKey:kIsBluetooth];
    [userDefaults setObject:@"1" forKey:kIsBLE];
    [userDefaults setObject:@"Search device from Wi-Fi" forKey:kSelectedDeviceFromWiFi];
    [userDefaults setObject:@"Search device from Bluetooth" forKey:kSelectedDeviceFromBluetooth];
    [userDefaults setObject:modelName_ forKey:kSelectedDeviceFromBLE];
    [userDefaults synchronize];

    [[self tableView] deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
