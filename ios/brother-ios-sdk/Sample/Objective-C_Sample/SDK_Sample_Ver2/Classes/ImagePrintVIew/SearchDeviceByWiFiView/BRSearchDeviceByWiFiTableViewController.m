//
//  BRSearchDeviceByWiFiViewControllerTableViewController.m
//  SDK_Sample_Ver2
//
//  Copyright © 2015 Brother Industries, Ltd. All rights reserved.
//

#import "UserDefaults.h"
#import "BRSearchDeviceByWiFiTableViewController.h"
#import <BRLMPrinterKit/BRLMPrinterKit.h>

@interface BRSearchDeviceByWiFiTableViewController ()
@property (nonatomic) NSMutableArray<BRLMChannel*> *channels;
@property (nonatomic) UIView *loadingView;
@property (nonatomic) UIActivityIndicatorView *indicator;

@end

@implementation BRSearchDeviceByWiFiTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.channels = [NSMutableArray array];
    [self showIndicator];
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        BRLMNetworkSearchOption *option = [self createOption];
        BRLMPrinterSearchResult * result = [BRLMPrinterSearcher startNetworkSearch:option callback:^(BRLMChannel *channel){
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

- (BRLMNetworkSearchOption *)createOption
{
    const int searchTimeSec = 15;
    BRLMNetworkSearchOption *option = [[BRLMNetworkSearchOption alloc] init];
    option.searchDuration = searchTimeSec;
    NSArray *printerList = nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PrinterList" ofType:@"plist"];
    if(path)
    {
        NSDictionary *printerDict = [NSDictionary dictionaryWithContentsOfFile:path];
        printerList = [[NSArray alloc] initWithArray:printerDict.allKeys];
    }
    option.printerList = printerList;
    return option;
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

- (void)cancelSearch:(UIButton*)button{
    [BRLMPrinterSearcher cancelNetworkSearch];
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
    NSString *ipaddress = [self.channels objectAtIndex:row].channelInfo;

    if([modelName_ length] == 0) {
        modelName_ = @"unknown";
    }

    if([ipaddress length] == 0) {
        ipaddress = @"unknown";
    }

    
    [[cell textLabel] setText:modelName_];
    [[cell detailTextLabel] setText:ipaddress];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BRLMChannel *channel = [self.channels objectAtIndex:[indexPath row]];
    NSString *modelName_ = [channel.extraInfo objectForKey:BRLMChannelExtraInfoKeyModelName] ;
    if([modelName_ length] == 0) {
        modelName_ = @"unknown";
    }

    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:modelName_ forKey:kSelectedDevice];
    [userDefaults setObject:channel.channelInfo forKey:kIPAddress];
    [userDefaults setObject:@"0"                            forKey:kSerialNumber];
    [userDefaults setObject:@""                            forKey:kAdvertiseLocalName];

    [userDefaults setObject:@"1" forKey:kIsWiFi];
    [userDefaults setObject:@"0" forKey:kIsBluetooth];
    [userDefaults setObject:@"0" forKey:kIsBLE];
    [userDefaults setObject:modelName_ forKey:kSelectedDeviceFromWiFi];
    [userDefaults setObject:@"Search device from Bluetooth" forKey:kSelectedDeviceFromBluetooth];
    [userDefaults setObject:@"Search device from BLE" forKey:kSelectedDeviceFromBLE];

    [userDefaults synchronize];
    
	[[self tableView] deselectRowAtIndexPath:indexPath animated:YES];
	[self.navigationController popToRootViewControllerAnimated:YES];
}

@end
