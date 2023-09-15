//
//  BRSendDataViewController.m
//  SDK_Sample_Ver2
//
//  Copyright © 2015 Brother Industries, Ltd. All rights reserved.
//

#import <BRLMPrinterKit/BRPtouchPrinterKit.h>

#import "UserDefaults.h"
#import "BRSendDataViewController.h"

@interface BRSendDataViewController ()
{
}
@property(nonatomic, weak) IBOutlet UILabel *selectedSendData;
//@property(nonatomic, strong) NSString           *ipAddress;
@property(nonatomic, strong) BRPtouchPrinter    *ptp;
@property(nonatomic) bool semaphore;
@end

@implementation BRSendDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *selectedSendDataName = [userDefaults objectForKey:kSelectedSendDataName];
    self.selectedSendData.text = selectedSendDataName;
    self.semaphore = true;
    [self.view reloadInputViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)didDismiss {
    [self.ptp cancelPrinting];
}

#pragma mark - IBAction

- (IBAction)sendDataSelectButton:(id)sender {
}

- (IBAction)sendDatabaseButton:(id)sender {
    NSLog(@"send database !!\n");
    [self sendDatabaseData:sender];
}

- (IBAction)sendDataButton:(id)sender
{
    [self sendData:sender isFirm:NO];
}

- (IBAction)sendFirmButton:(id)sender
{
    [self sendData:sender isFirm:YES];
}

- (void)sendDatabaseData:(id)sender {
    if(!self.semaphore) {
        return;
    } else {
        self.semaphore = false;
    }
    
    [sender setEnabled:NO];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    CONNECTION_TYPE type = CONNECTION_TYPE_ERROR;
    NSString *selectedDevice = nil;
    int error = ERROR_NONE_;
    
    if ([userDefaults integerForKey:kIsWiFi] == 0 &&
        [userDefaults integerForKey:kIsBluetooth] == 1 &&
        [userDefaults integerForKey:kIsBLE] == 0) {
        type = CONNECTION_TYPE_BLUETOOTH;
        selectedDevice = [NSString stringWithFormat:@"%@",[userDefaults stringForKey:kSelectedDeviceFromBluetooth]];
        NSString *serialNumber = [userDefaults stringForKey:kSerialNumber];
        if (serialNumber) {
            self.ptp = [[BRPtouchPrinter alloc] initWithPrinterName:selectedDevice interface:type];
            [self.ptp setupForBluetoothDeviceWithSerialNumber:serialNumber];
        }
    }
    else if ([userDefaults integerForKey:kIsWiFi] == 1 &&
             [userDefaults integerForKey:kIsBluetooth] == 0 &&
             [userDefaults integerForKey:kIsBLE] == 0) {
        type = CONNECTION_TYPE_WLAN;
        selectedDevice = [NSString stringWithFormat:@"%@", [userDefaults stringForKey:kSelectedDeviceFromWiFi]];
        NSString *ipAddress = [userDefaults stringForKey:kIPAddress];
        if (ipAddress) {
            self.ptp = [[BRPtouchPrinter alloc] initWithPrinterName:selectedDevice interface:type];
            [self.ptp setIPAddress:ipAddress];
        }
    }
    else if ([userDefaults integerForKey:kIsWiFi] == 0 &&
             [userDefaults integerForKey:kIsBluetooth] == 0 &&
             [userDefaults integerForKey:kIsBLE] == 1) {
        type = CONNECTION_TYPE_BLE;
        selectedDevice = [NSString stringWithFormat:@"%@", [userDefaults stringForKey:kSelectedDeviceFromBLE]];
        NSString *localName = [userDefaults stringForKey:kAdvertiseLocalName];
        if (localName) {
            self.ptp = [[BRPtouchPrinter alloc] initWithPrinterName:selectedDevice interface:type];
            [self.ptp setBLEAdvertiseLocalName:localName];
        }
    }
    else {
        type = CONNECTION_TYPE_ERROR;
        selectedDevice = nil;
        error = -1;
        [self showAlertSendDataResult:error];
    }
    
    if ([self.ptp startCommunication]) {
        NSString *selectedSendDataPath = [userDefaults objectForKey:kSelectedSendDataPath];
        
        BOOL isCSVFile = ([[selectedSendDataPath pathExtension] localizedCaseInsensitiveCompare:@"csv"] == NSOrderedSame);
        if (isCSVFile) {
            error = [self.ptp sendDatabase:selectedSendDataPath];
        }
        else {
            error = ERROR_FILE_NOT_SUPPORTED_;
        }
        [self showAlertSendDataResult:error];
        [self.ptp endCommunication];
    }
    else {
        [self showAlertSendDataResult:ERROR_COMMUNICATION_ERROR_];
    }
    
    self.semaphore = true;
    [sender setEnabled:YES];
}


- (void)sendData:(id)sender isFirm:(bool)isFirm
{
    if(!self.semaphore) {
        return;
    }
    else {
        self.semaphore = false;
    }
    [sender setEnabled:NO];
    CONNECTION_TYPE type = CONNECTION_TYPE_ERROR;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *selectedSendDataPath = [userDefaults objectForKey:kSelectedSendDataPath];
    NSString *selectedDevice = nil;
    
    if ([userDefaults integerForKey:kIsWiFi] == 0 && [userDefaults integerForKey:kIsBluetooth] == 1 && [userDefaults integerForKey:kIsBLE] == 0)
    {
        type = CONNECTION_TYPE_BLUETOOTH;
        selectedDevice = [NSString stringWithFormat:@"%@",[userDefaults stringForKey:kSelectedDeviceFromBluetooth]];
        
        NSString *serialNumber = [userDefaults stringForKey:kSerialNumber];
        if (serialNumber) {
            self.ptp = [[BRPtouchPrinter alloc] initWithPrinterName:selectedDevice interface:type];
            [self.ptp setupForBluetoothDeviceWithSerialNumber:serialNumber];
        }
    }
    else if ([userDefaults integerForKey:kIsWiFi] == 1 && [userDefaults integerForKey:kIsBluetooth] == 0 && [userDefaults integerForKey:kIsBLE] == 0)
    {
        type = CONNECTION_TYPE_WLAN;
        selectedDevice = [NSString stringWithFormat:@"%@", [userDefaults stringForKey:kSelectedDeviceFromWiFi]];
        
        NSString *ipAddress = [userDefaults stringForKey:kIPAddress];
        if (ipAddress) {
            self.ptp = [[BRPtouchPrinter alloc] initWithPrinterName:selectedDevice interface:type];
            [self.ptp setIPAddress:ipAddress];
        }
    }
    else if ([userDefaults integerForKey:kIsWiFi] == 0 && [userDefaults integerForKey:kIsBluetooth] == 0 && [userDefaults integerForKey:kIsBLE] == 1)
    {
        type = CONNECTION_TYPE_BLE;
        selectedDevice = [NSString stringWithFormat:@"%@", [userDefaults stringForKey:kSelectedDeviceFromBLE]];
        
        NSString *localName = [userDefaults stringForKey:kAdvertiseLocalName];
        if (localName) {
            self.ptp = [[BRPtouchPrinter alloc] initWithPrinterName:selectedDevice interface:type];
            [self.ptp setBLEAdvertiseLocalName:localName];
        }
    }
    else
    {
        type = CONNECTION_TYPE_ERROR;
    }
    
    int error = -1;
    if (type == CONNECTION_TYPE_ERROR) {
        [self showAlertSendDataResult:error];
    }else{
        BOOL startCommunicationResult = [self.ptp startCommunication];
        if (startCommunicationResult) {
            
            BOOL isPDZFile = false;
            BOOL isBLFFile = false;
            NSString* fileExtension = [selectedSendDataPath pathExtension];
            if (type == CONNECTION_TYPE_BLUETOOTH || type == CONNECTION_TYPE_BLE) {
                isPDZFile = ([fileExtension localizedCaseInsensitiveCompare:@"pd3"] == NSOrderedSame);
            }
            isBLFFile = ([fileExtension localizedCaseInsensitiveCompare:@"blf"] == NSOrderedSame);
            
            if (isPDZFile || isBLFFile) {
                if(isFirm) {
                    error = ![self.ptp sendFirmwareFile:@[selectedSendDataPath]];
                }
                else{
                    error = [self.ptp sendTemplate:selectedSendDataPath connectionType:type];
                }
            }else {
                error = [self.ptp sendFile:selectedSendDataPath];
            }
            [self showAlertSendDataResult:error];
            [self.ptp endCommunication];
        }
        else {
            [self showAlertSendDataResult:ERROR_COMMUNICATION_ERROR_];
        }
    }
    
    self.semaphore = true;
    [sender setEnabled:YES];
}

- (void)showAlertSendDataResult: (int)error
{
    float osVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    NSString *title = @"Send Result";
    NSString *message = @"";
    NSString *battery = @"";
    if (error == 0) {
        message = @"Success";

        BRPtouchPrinterStatus *resultstatus;
        BOOL result = [self.ptp getStatus:&resultstatus];
        if (result) {
            battery = [NSString stringWithFormat:@"\nBattery = %d/%d(AC=%ld,BM=%ld)",
                       resultstatus.batteryResidualQuantityLevel,
                       resultstatus.maxOfBatteryResidualQuantityLevel,
                       (long)resultstatus.isACConnected,
                       (long)resultstatus.isBatteryMounted];
        }
    }else {
        message = @"Failure";
    }

    if(osVersion >= 8.0f) {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title
                                                                                  message:[message stringByAppendingString:battery]
                                                                           preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if (osVersion < 8.0f && osVersion >= 6.0f) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else {
        // Non Support
    }
}

@end
