//
//  BRPrintResultViewController.m
//  SDK_Sample_Ver2
//
//  Copyright © 2015 Brother Industries, Ltd. All rights reserved.
//

#import <BRLMPrinterKit/BRLMPrinterKit.h>
#import <BRLMPrinterKit/BRPtouchPrinter.h>

#ifndef WLAN_ONLY
#import <BRLMPrinterKit/BRPtouchBluetoothManager.h>
#endif

#import "UserDefaults.h"
#import "BRLMUserDefaults.h"
#import "BRPrintResultViewController.h"
#import "BRWLANPrintOperation.h"
#import "BRBluetoothPrintOperation.h"
#import "BRBLEPrintOperation.h"

@interface BRPrintResultViewController ()
{
    BRLMChannel	*_ptp;
}
@property(nonatomic, weak) IBOutlet UILabel *communicationResultLabel;
@property(nonatomic, weak) IBOutlet UILabel *sendDataLabel;
@property(nonatomic, weak) IBOutlet UILabel *printResultLabel;
@property(nonatomic, weak) IBOutlet UILabel *batteryPowerLabel;

@property(nonatomic, strong) NSOperationQueue           *queueForWLAN;
@property(nonatomic, strong) BRWLANPrintOperation       *operationForWLAN;
@property(nonatomic, strong) NSOperationQueue           *queueForBT;
@property(nonatomic, strong) BRBluetoothPrintOperation  *operationForBT;
@property(nonatomic, strong) NSOperationQueue           *queueForBLE;
@property(nonatomic, strong) BRBLEPrintOperation        *operationForBLE;

@property(nonatomic, strong) NSString *bytesWrittenMessage;
@property(nonatomic, strong) NSNumber *bytesWritten;
@property(nonatomic, strong) NSNumber *bytesToWrite;

@property(nonatomic, assign) BRLMChannelType type;
@end

@implementation BRPrintResultViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem.enabled = NO;
    
    self.communicationResultLabel.text = @"Communication Result : ";
    self.bytesWritten = [NSNumber numberWithInt:0];
    self.bytesToWrite = [NSNumber numberWithInt:0];
    self.sendDataLabel.text = [NSString stringWithFormat:@"Send Data : %@/%@",self.bytesWritten, self.bytesToWrite];
    self.printResultLabel.text = @"Print Result : ";
    self.batteryPowerLabel.text = @"Battery Power : ";
    self.type = BRLMChannelTypeWiFi;

    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *selectedDevice = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directory = [paths lastObject];
    
    NSString *ipAddress     = [userDefaults stringForKey:kIPAddress];
    NSString *serialNumber  = [userDefaults stringForKey:kSerialNumber];
    NSString *advertiseLocalName  = [userDefaults stringForKey:kAdvertiseLocalName];
    
    if ([userDefaults integerForKey:kIsWiFi] == 0 && [userDefaults integerForKey:kIsBluetooth] == 1 && [userDefaults integerForKey:kIsBLE] == 0){
        self.type = BRLMChannelTypeBluetoothMFi;
        selectedDevice = [NSString stringWithFormat:@"%@",[userDefaults stringForKey:kSelectedDeviceFromBluetooth]];
        _ptp = [[BRLMChannel alloc] initWithBluetoothSerialNumber:serialNumber];
    }
    else if ([userDefaults integerForKey:kIsWiFi] == 1 && [userDefaults integerForKey:kIsBluetooth] == 0 && [userDefaults integerForKey:kIsBLE] == 0){
        self.type = BRLMChannelTypeWiFi;
        selectedDevice = [NSString stringWithFormat:@"%@", [userDefaults stringForKey:kSelectedDeviceFromWiFi]];
        _ptp = [[BRLMChannel alloc] initWithWifiIPAddress:ipAddress];
    }
    else if ([userDefaults integerForKey:kIsWiFi] == 0 && [userDefaults integerForKey:kIsBluetooth] == 0 && [userDefaults integerForKey:kIsBLE] == 1){
        self.type = BRLMChannelTypeBluetoothLowEnergy;
        selectedDevice = [NSString stringWithFormat:@"%@", [userDefaults stringForKey:kSelectedDeviceFromBLE]];
        _ptp = [[BRLMChannel alloc] initWithBLELocalName:advertiseLocalName];
    }
    else{
        NSAssert(false, @"BRLMChannelType error");
    }


    // PrintInfo
    id<BRLMPrintSettingsProtocol> setting = [self getPrintInfoWithDeviceName:selectedDevice];
    [self initWithNotificationObserver];
    
    switch (self.type)
    {
        case BRLMChannelTypeWiFi:
        {
            self.queueForWLAN = [[NSOperationQueue alloc] init];
            self.operationForWLAN = [[BRWLANPrintOperation alloc] initWithOperation:_ptp
                                                                          printInfo:setting
                                                                             images:self.imagePathArray
                                                                          ipAddress:ipAddress];
            [self.operationForWLAN addObserver:self
                                    forKeyPath:@"isFinishedForWLAN"
                                       options:NSKeyValueObservingOptionNew
                                       context:nil];
            
            [self.operationForWLAN addObserver:self
                                    forKeyPath:@"communicationResultForWLAN"
                                       options:NSKeyValueObservingOptionNew
                                       context:nil];
            
            self.operationForWLAN.delegate = self;
            
            [self.queueForWLAN addOperation:self.operationForWLAN];
        }
            break;
            
        case BRLMChannelTypeBluetoothMFi:
#ifndef WLAN_ONLY
        {
            NSArray *pairedDevices = [NSArray arrayWithArray:[[BRPtouchBluetoothManager sharedManager] pairedDevices]];
            if (pairedDevices == nil) {
                NSLog(@"No Bluetooth Device Connected !!");
            }
            else {
                self.queueForBT = [[NSOperationQueue alloc] init];
                self.operationForBT = [[BRBluetoothPrintOperation alloc] initWithOperation:_ptp
                                                                                 printInfo:setting
                                                                                    images:self.imagePathArray
                                                                              serialNumber:serialNumber];

                [self.operationForBT addObserver:self
                                      forKeyPath:@"isFinishedForBT"
                                         options:NSKeyValueObservingOptionNew
                                         context:nil];
                
                [self.operationForBT addObserver:self
                                      forKeyPath:@"communicationResultForBT"
                                         options:NSKeyValueObservingOptionNew
                                         context:nil];
                
                self.operationForBT.delegate = self;
                
                [self.queueForBT addOperation:self.operationForBT];
            }
        }
#endif
            break;
            
        case BRLMChannelTypeBluetoothLowEnergy:
        {
            self.queueForBLE = [[NSOperationQueue alloc] init];
            self.operationForBLE = [[BRBLEPrintOperation alloc] initWithOperation:_ptp
                                                                        printInfo:setting
                                                                           images:self.imagePathArray
                                                               advertiseLocalName:advertiseLocalName];
            [self.operationForBLE addObserver:self
                                    forKeyPath:@"isFinishedForBLE"
                                       options:NSKeyValueObservingOptionNew
                                       context:nil];
            
            [self.operationForBLE addObserver:self
                                    forKeyPath:@"communicationResultForBLE"
                                       options:NSKeyValueObservingOptionNew
                                       context:nil];
            
            self.operationForBLE.delegate = self;
            
            [self.queueForBLE addOperation:self.operationForBLE];
        }
            break;
            
        default:
            break;
    }

}

- (id<BRLMPrintSettingsProtocol>)getPrintInfoWithDeviceName:(NSString*)selectedDevice {
    BRLMPrinterModel model = [BRLMPrinterClassifier transferEnumFromString:selectedDevice];
    BRLMPrinterClassifierSeries series = [BRLMPrinterClassifier classifyPrinterSerieseFromModel:model];
    id<BRLMPrintSettingsProtocol> setting;
    switch (series) {
        case BRLMPrinterClassifierSeriesMW:
            setting = [[BRLMUserDefaults sharedDefaults].mwSettings copyWithPrinterModel:model];
            if (setting == nil) {
                setting = [[BRLMMWPrintSettings alloc] initDefaultPrintSettingsWithPrinterModel:model];
            }
            break;
        case BRLMPrinterClassifierSeriesPJ:
            setting = [[BRLMUserDefaults sharedDefaults].pjSettings copyWithPrinterModel:model];
            if (setting == nil) {
                setting = [[BRLMPJPrintSettings alloc] initDefaultPrintSettingsWithPrinterModel:model];
            }
            break;
        case BRLMPrinterClassifierSeriesRJ:
            setting = [[BRLMUserDefaults sharedDefaults].rjSettings copyWithPrinterModel:model];
            if (setting == nil) {
                setting = [[BRLMRJPrintSettings alloc] initDefaultPrintSettingsWithPrinterModel:model];
            }
            break;
        case BRLMPrinterClassifierSeriesTD:
            setting = [[BRLMUserDefaults sharedDefaults].tdSettings copyWithPrinterModel:model];
            if (setting == nil) {
                setting = [[BRLMTDPrintSettings alloc] initDefaultPrintSettingsWithPrinterModel:model];
            }
            break;
        case BRLMPrinterClassifierSeriesPT:
            setting = [[BRLMUserDefaults sharedDefaults].ptSettings copyWithPrinterModel:model];
            if (setting == nil) {
                setting = [[BRLMPTPrintSettings alloc] initDefaultPrintSettingsWithPrinterModel:model];
            }
            break;
        case BRLMPrinterClassifierSeriesQL:
            setting = [[BRLMUserDefaults sharedDefaults].qlSettings copyWithPrinterModel:model];
            if (setting == nil) {
                setting = [[BRLMQLPrintSettings alloc] initDefaultPrintSettingsWithPrinterModel:model];
            }
            break;
        case BRLMPrinterClassifierSeriesUnknown:
            NSAssert(false, @"BRLMPrinterClassifierSeriesUnknown");
            break;
    }

    return setting;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self removeNotificationObserver];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)cancelPrinting {
    switch (self.type) {
        case BRLMChannelTypeBluetoothMFi:
            [self.operationForBT cancelPrinting];
            break;
        case BRLMChannelTypeWiFi:
            [self.operationForWLAN cancelPrinting];
            break;
        case BRLMChannelTypeBluetoothLowEnergy:
            [self.operationForBLE cancelPrinting];
            break;
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"isFinishedForWLAN"])
    {
        [self.operationForWLAN removeObserver:self forKeyPath:@"isFinishedForWLAN"];
        [self.operationForWLAN removeObserver:self forKeyPath:@"communicationResultForWLAN"];

        self.operationForWLAN = nil;
        self.queueForWLAN = nil;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.leftBarButtonItem.enabled = YES;
            [self.view reloadInputViews];
        });
    }
    else if ([keyPath isEqualToString:@"isFinishedForBT"])
    {
        [self.operationForBT removeObserver:self forKeyPath:@"isFinishedForBT"];
        [self.operationForBT removeObserver:self forKeyPath:@"communicationResultForBT"];

        self.operationForBT = nil;
        self.queueForBT = nil;

        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.leftBarButtonItem.enabled = YES;
            [self.view reloadInputViews];
        });
    }
    else if ([keyPath isEqualToString:@"isFinishedForBLE"])
    {
        [self.operationForBLE removeObserver:self forKeyPath:@"isFinishedForBLE"];
        [self.operationForBLE removeObserver:self forKeyPath:@"communicationResultForBLE"];

        self.operationForBLE = nil;
        self.queueForBLE = nil;

        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.leftBarButtonItem.enabled = YES;
            [self.view reloadInputViews];
        });
    }
    else if ([keyPath isEqualToString:@"communicationResultForWLAN"])
    {
        BOOL result = _operationForWLAN.communicationResultForWLAN;
        if (!result) {
            self.queueForWLAN = nil;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.communicationResultLabel.text = [NSString stringWithFormat:@"Communication Result : %d",result];
            [self.view reloadInputViews];
        });
    }
    else if ([keyPath isEqualToString:@"communicationResultForBT"])
    {
        BOOL result = _operationForBT.communicationResultForBT;
        if (!result) {
            self.queueForBT = nil;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.communicationResultLabel.text = [NSString stringWithFormat:@"Communication Result : %d",result];
            [self.view reloadInputViews];
        });
    }
    else if ([keyPath isEqualToString:@"communicationResultForBLE"])
    {
        BOOL result = _operationForBLE.communicationResultForBLE;
        if (!result) {
            self.queueForBLE = nil;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.communicationResultLabel.text = [NSString stringWithFormat:@"Communication Result : %d",result];
            [self.view reloadInputViews];
        });
    }
}

#pragma mark - Notification (for Progress)

- (void) initWithNotificationObserver
{
    self.bytesWrittenMessage = nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(bytesWrittenNotification:)
                                                 name:BRWLanConnectBytesWrittenNotification
                                               object:nil];
    
#ifndef WLAN_ONLY
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(bytesWrittenNotification:)
                                                 name:BRBluetoothSessionBytesWrittenNotification
                                               object:nil];
#endif
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(bytesWrittenNotification:)
                                                 name:BRBLEBytesWrittenNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(bytesWrittenNotification:)
                                                 name:BRPtouchPrinterKitMessageNotification
                                               object:nil];
}

- (void) removeNotificationObserver
{
    self.bytesWrittenMessage = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:BRWLanConnectBytesWrittenNotification
                                                  object:nil];
    
#ifndef WLAN_ONLY
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:BRBluetoothSessionBytesWrittenNotification
                                                  object:nil];
#endif
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:BRBLEBytesWrittenNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:BRPtouchPrinterKitMessageNotification
                                                  object:nil];
}

- (void) bytesWrittenNotification: (NSNotification *)notification
{
    NSString *msgStr = [notification.userInfo objectForKey:@"message"];
    if (msgStr){
        self.bytesWrittenMessage = msgStr;
        NSLog(@"*** message = %@", self.bytesWrittenMessage);
    }
    
    if ([self.bytesWrittenMessage isEqualToString:@"MESSAGE_START_SEND_DATA"])
    {
        self.bytesWritten = [notification.userInfo objectForKey:@"bytesWritten"];
        self.bytesToWrite = [notification.userInfo objectForKey:@"bytesToWrite"];
        NSLog(@"Send Data: %d/%d(byte)", [self.bytesWritten intValue], [self.bytesToWrite intValue]);

        dispatch_async(dispatch_get_main_queue(), ^{
            self.sendDataLabel.text = [NSString stringWithFormat:@"Send Data : %d/%d", [self.bytesWritten intValue], [self.bytesToWrite intValue]];
            [self.view reloadInputViews];
        });
    }
    else if ([self.bytesWrittenMessage isEqualToString:@"MESSAGE_END_SEND_DATA"])
    {
            self.bytesWritten = 0;
            self.bytesToWrite = 0;
    }
    else if ([self.bytesWrittenMessage isEqualToString:@"MESSAGE_END_READ_PRINTER_STATUS"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController reloadInputViews];
        });
    }
    else if ([self.bytesWrittenMessage isEqualToString:@"MESSAGE_PRINT_ERROR"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.leftBarButtonItem.enabled = YES;
            [self.navigationController reloadInputViews];
        });
    }
}

- (void) showPrintResultForWLAN
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSUserDefaults *userDefaults    = [NSUserDefaults standardUserDefaults];
        if (self.type == BRLMChannelTypeWiFi) {
            self.printResultLabel.text  = [NSString stringWithFormat:@"Print Result  : %@", [userDefaults stringForKey:kPrintResultForWLAN]];
            self.batteryPowerLabel.text = [NSString stringWithFormat:@"Battery Power : %@", [userDefaults stringForKey:kPrintStatusBatteryPowerForWLAN]];
            [self.printResultLabel reloadInputViews];
        }
    });
}

- (void) showPrintResultForBluetooth
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSUserDefaults *userDefaults    = [NSUserDefaults standardUserDefaults];
        if  (self.type == BRLMChannelTypeBluetoothMFi) {
            self.printResultLabel.text  = [NSString stringWithFormat:@"Print Result  : %@", [userDefaults stringForKey:kPrintResultForBT]];
            self.batteryPowerLabel.text = [NSString stringWithFormat:@"Battery Power : %@", [userDefaults stringForKey:kPrintStatusBatteryPowerForBT]];
        }
    });
}

- (void) showPrintResultForBLE
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSUserDefaults *userDefaults    = [NSUserDefaults standardUserDefaults];
        if (self.type == BRLMChannelTypeBluetoothLowEnergy) {
            self.printResultLabel.text  = [NSString stringWithFormat:@"Print Result  : %@", [userDefaults stringForKey:kPrintResultForBLE]];
            self.batteryPowerLabel.text = [NSString stringWithFormat:@"Battery Power : %@", [userDefaults stringForKey:kPrintStatusBatteryPowerForBLE]];
        }
    });
}

- (IBAction)showAllLogs:(id)sender {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"All Logs" message:self.printResultLabel.text preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {}]];
    [self presentViewController:alert animated:YES completion:^{}];
}


@end
