//
//  BRUtilityViewController.m
//  SDK_Sample_Ver2
//
//  Copyright © 2016 Brother Industries, Ltd. All rights reserved.
//

#import <BRLMPrinterKit/BRPtouchPrinterKit.h>
#import <BRLMPrinterKit/BRLMPrinterKit.h>
#import "UserDefaults.h"
#import "BRUtilityViewController.h"
#import "BRPrinterSettingItemSelectTableViewController.h"
#import "BRSetStringTableViewController.h"
#import "BRDisplayTextViewController.h"

@interface BRUtilityViewController ()
{
}
@property(nonatomic, weak) IBOutlet UISwitch    *autoConnectBluetoothSwitch;
@property(nonatomic, weak) IBOutlet UILabel     *autoConnectBluetoothStatusLabel;
@property(nonatomic, strong) BRPtouchPrinter    *ptp;
@end

@implementation BRUtilityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.autoConnectBluetoothSwitch.on = NO;
    self.autoConnectBluetoothStatusLabel.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (CONNECTION_TYPE) prepareSelfPtp {
    CONNECTION_TYPE type = CONNECTION_TYPE_ERROR;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *selectedDevice = nil;
    
    if ([userDefaults integerForKey:kIsWiFi] == 0 && [userDefaults integerForKey:kIsBluetooth] == 1 && [userDefaults integerForKey:kIsBLE] == 0){
        type = CONNECTION_TYPE_BLUETOOTH;
        selectedDevice = [NSString stringWithFormat:@"%@",[userDefaults stringForKey:kSelectedDeviceFromBluetooth]];
        
        NSString *serialNumber = [userDefaults stringForKey:kSerialNumber];
        if (serialNumber) {
            self.ptp = [[BRPtouchPrinter alloc] initWithPrinterName:selectedDevice interface:type];
            [self.ptp setupForBluetoothDeviceWithSerialNumber:serialNumber];
        }
    }
    else if ([userDefaults integerForKey:kIsWiFi] == 1 && [userDefaults integerForKey:kIsBluetooth] == 0 && [userDefaults integerForKey:kIsBLE] == 0){
        type = CONNECTION_TYPE_WLAN;
        selectedDevice = [NSString stringWithFormat:@"%@", [userDefaults stringForKey:kSelectedDeviceFromWiFi]];
        
        NSString *ipAddress = [userDefaults stringForKey:kIPAddress];
        if (ipAddress) {
            self.ptp = [[BRPtouchPrinter alloc] initWithPrinterName:selectedDevice interface:type];
            [self.ptp setIPAddress:ipAddress];
        }
    }
    else if ([userDefaults integerForKey:kIsWiFi] == 0 && [userDefaults integerForKey:kIsBluetooth] == 0 && [userDefaults integerForKey:kIsBLE] == 1){
        type = CONNECTION_TYPE_BLE;
        selectedDevice = [NSString stringWithFormat:@"%@", [userDefaults stringForKey:kSelectedDeviceFromBLE]];
        
        NSString *localName = [userDefaults stringForKey:kAdvertiseLocalName];
        if (localName) {
            self.ptp = [[BRPtouchPrinter alloc] initWithPrinterName:selectedDevice interface:type];
            [self.ptp setBLEAdvertiseLocalName:localName];
        }
    }
    else{
        type = CONNECTION_TYPE_ERROR;
    }

    return type;
}

- (BRLMChannel*) prepareSelfPtpV4 {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *selectedDevice = nil;
        
    if ([userDefaults integerForKey:kIsWiFi] == 0 && [userDefaults integerForKey:kIsBluetooth] == 1 && [userDefaults integerForKey:kIsBLE] == 0){
        selectedDevice = [NSString stringWithFormat:@"%@",[userDefaults stringForKey:kSelectedDeviceFromBluetooth]];
        return [[BRLMChannel alloc] initWithBluetoothSerialNumber:[userDefaults objectForKey:kSerialNumber]];
    }
    else if ([userDefaults integerForKey:kIsWiFi] == 1 && [userDefaults integerForKey:kIsBluetooth] == 0 && [userDefaults integerForKey:kIsBLE] == 0){
        selectedDevice = [NSString stringWithFormat:@"%@", [userDefaults stringForKey:kSelectedDeviceFromWiFi]];
        return [[BRLMChannel alloc] initWithWifiIPAddress:[userDefaults objectForKey:kIPAddress]];
    }
    else if ([userDefaults integerForKey:kIsWiFi] == 0 && [userDefaults integerForKey:kIsBluetooth] == 0 && [userDefaults integerForKey:kIsBLE] == 1){
        selectedDevice = [NSString stringWithFormat:@"%@", [userDefaults stringForKey:kSelectedDeviceFromBLE]];
        return [[BRLMChannel alloc] initWithBLELocalName:[userDefaults objectForKey:kAdvertiseLocalName]];
    }
    return nil;
}

- (IBAction) settingForAutoConnectBluetoothButton:(id)sender
{
    [sender setEnabled:NO];
    CONNECTION_TYPE type = [self prepareSelfPtp];
    
    if (type != CONNECTION_TYPE_ERROR) {
        BOOL startCommunicationResult = [self.ptp startCommunication];
        if (startCommunicationResult) {
            BOOL isAutoConnectBluetooth = self.autoConnectBluetoothSwitch.on;
            [self.ptp setAutoConnectBluetooth: isAutoConnectBluetooth];
        }
        [self.ptp endCommunication];
    }
    [sender setEnabled:YES];
}

- (IBAction)getAutoConnectBluetooth:(id)sender
{
    [sender setEnabled:NO];
    CONNECTION_TYPE type = [self prepareSelfPtp];
    
    if (type != CONNECTION_TYPE_ERROR) {
        BOOL startCommunicationResult = [self.ptp startCommunication];
        if (startCommunicationResult) {
            int isAutoConnectBluetooth = [self.ptp isAutoConnectBluetooth];
            self.autoConnectBluetoothStatusLabel.text = [NSString stringWithFormat:@"%d", isAutoConnectBluetooth];
            [self.autoConnectBluetoothStatusLabel reloadInputViews];
        }
        [self.ptp endCommunication];
    }
    [sender setEnabled:YES];
}

- (IBAction)getSystemReport:(id)sender {
    [sender setEnabled:NO];
    CONNECTION_TYPE type = [self prepareSelfPtp];
    
    if (type != CONNECTION_TYPE_ERROR) {
        BOOL startCommunicationResult = [self.ptp startCommunication];
        if (startCommunicationResult) {
            NSString * report;
            int result = [self.ptp getSystemReport:&report];
            [self.ptp endCommunication];

            if (result == ERROR_NONE_) {
                [self showLongText:@"Report" text:report];
            }
            else {
                [self showFailAlert:[@(result) stringValue]];
            }
        }
    }
    [sender setEnabled:YES];

}
- (IBAction)getPrinterSettings:(id)sender {
    [sender setEnabled:NO];
    CONNECTION_TYPE type = [self prepareSelfPtp];
    
    if (type != CONNECTION_TYPE_ERROR) {
        BRPrinterSettingItemSelectTableViewController* nextViewController = [[UIStoryboard storyboardWithName:@"BRUtilityViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"printerSettingItemSelectTableViewController"];
        nextViewController.completionHandler = ^(NSArray *require) {
            BOOL startCommunicationResult = [self.ptp startCommunication];
            if (startCommunicationResult) {
                NSDictionary * report;
                int result = [self.ptp getPrinterSettings:&report require:require];
                [self.ptp endCommunication];
                
                if (result == ERROR_NONE_) {
                    [self showLongText:@"PrinterSettings" text:[report description]];
                }
                else {
                    [self showFailAlert:[@(result) stringValue]];
                }
            }
        };

        [[self navigationController] pushViewController:nextViewController animated:YES];
    }
    [sender setEnabled:YES];
    
}
- (IBAction)setPrinterSettings:(id)sender {
    [sender setEnabled:NO];
    CONNECTION_TYPE type = [self prepareSelfPtp];
    
    if (type != CONNECTION_TYPE_ERROR) {
        BRPrinterSettingItemSelectTableViewController* nextViewController = [[UIStoryboard storyboardWithName:@"BRUtilityViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"printerSettingItemSelectTableViewController"];
        nextViewController.completionHandler = ^(NSArray *require)
        {
            NSMutableArray* require_string = [NSMutableArray array];
            __block NSMutableDictionary* require_string_to_enum = [NSMutableDictionary dictionary];
            for (NSNumber* printerSettingItem in require) {
                NSString* title = [BRPrinterSettingItemSelectTableViewController titleForPrinterSettingItem:[printerSettingItem integerValue]];
                [require_string addObject:title];
                [require_string_to_enum setObject:printerSettingItem forKey:title];
            }
            BRSetStringTableViewController* setStringViewController = [[UIStoryboard storyboardWithName:@"BRUtilityViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"setStringTableViewController"];
            setStringViewController.require = require_string;
            setStringViewController.completionHandler = ^(NSDictionary *result)
            {
                if(!result.count) {
                    return;
                }
                BOOL startCommunicationResult = [self.ptp startCommunication];
                if (startCommunicationResult) {
                    NSMutableDictionary* PrinterSettings = [NSMutableDictionary dictionary];
                    for (NSString* key in result) {
                        NSNumber* item = require_string_to_enum[key];
                        [PrinterSettings setObject:result[key] forKey:item];
                    }
                    int result = [self.ptp setPrinterSettings:PrinterSettings];
                    [self.ptp endCommunication];
                    
                    if (result == ERROR_NONE_) {
                        [self showSuccessAlert:[@(result) stringValue]];
                    }
                    else {
                        [self showFailAlert:[@(result) stringValue]];
                    }
                }
            };
            [[self navigationController] pushViewController:setStringViewController animated:YES];
        };
        
        [[self navigationController] pushViewController:nextViewController animated:YES];
    }
    [sender setEnabled:YES];
}

- (IBAction)getBatteryInfo:(id)sender {
    [sender setEnabled:NO];
    
    int errorStatus = ERROR_COMMUNICATION_ERROR_;
    NSString* resultString = @"";
    CONNECTION_TYPE type = [self prepareSelfPtp];
    if (type != CONNECTION_TYPE_ERROR) {
        BOOL startCommunicationResult = [self.ptp startCommunication];
        if (startCommunicationResult) {
            BRPtouchBatteryInfo *batteryInfo;
            errorStatus = [self.ptp getBatteryInfo:&batteryInfo];
            if (errorStatus != ERROR_NONE_) {
                resultString = [NSString stringWithFormat:@"Faild\nError Code: %d", errorStatus];
            }
            else {
                NSString* healthStatusString;
                switch (batteryInfo.batteryHealthStatus) {
                    case BRPtouchBatteryInfoBatteryHealthStatusExcellent:
                        healthStatusString = @"Excellent";
                        break;
                    case BRPtouchBatteryInfoBatteryHealthStatusGood:
                        healthStatusString = @"Good";
                        break;
                    case BRPtouchBatteryInfoBatteryHealthStatusReplaceSoon:
                        healthStatusString = @"Replace Soon";
                        break;
                    case BRPtouchBatteryInfoBatteryHealthStatusReplaceBattery:
                        healthStatusString = @"Replace Battery";
                        break;
                    case BRPtouchBatteryInfoBatteryHealthStatusNotInstalled:
                        healthStatusString = @"Not Installed";
                        break;
                    default:
                        healthStatusString = @"Unknown";
                        break;
                }
                resultString = [NSString stringWithFormat:@"Charge Level: %d%%\nBattery Health: %d%%(%@)",
                                batteryInfo.batteryChargeLevel,
                                batteryInfo.batteryHealthLevel,
                                healthStatusString];
            }
            [self.ptp endCommunication];
        }
    }
    if (errorStatus == ERROR_NONE_) {
        [self showLongText:@"Battery Health" text:resultString];
    }
    else {
        [self showFailAlert:[@(errorStatus) stringValue]];
    }

    [sender setEnabled:YES];
}


- (IBAction)getFirmVer:(id)sender {
    [sender setEnabled:NO];
    CONNECTION_TYPE type = [self prepareSelfPtp];
    
    if (type != CONNECTION_TYPE_ERROR) {
        BOOL startCommunicationResult = [self.ptp startCommunication];
        if (startCommunicationResult) {
            NSString * firmVer;
            firmVer = [self.ptp getFirmVersion];
            [self.ptp endCommunication];
            
            if ([firmVer length] != 0) {
                [self showLongText:@"Firm Version" text:firmVer];
            }
            else {
                [self showFailAlert:@"fail"];
            }
        }
    }
    [sender setEnabled:YES];
    
}

- (IBAction)getPrinterStatus:(id)sender {
    [sender setEnabled:NO];
    BRLMChannel* ptpChannel = [self prepareSelfPtpV4];
    
    if (ptpChannel) {
        
        BRLMPrinterDriverGenerateResult* generateResult = [BRLMPrinterDriverGenerator openChannel:ptpChannel];
        
        if (generateResult.driver) {
            BRLMGetPrinterStatusResult* result = [generateResult.driver getPrinterStatus];
            if (result.status) {
                NSString* statusString = @"";
                statusString = [statusString stringByAppendingFormat:@"Status Raw: "];
                BRLMPrinterStatusRawDataStructure rawStatus = result.status.rawData;
                for(int i=0; i < sizeof(BRLMPrinterStatusRawDataStructure); i++) {
                    statusString = [statusString stringByAppendingFormat:@"%02x, ", ((Byte*)&rawStatus.byHead)[i]];
                }
                statusString = [statusString stringByAppendingFormat:@"\n"];
                statusString = [statusString stringByAppendingFormat:@"model: %ld\n", result.status.model];
                statusString = [statusString stringByAppendingFormat:@"errorCode: %ld\n", result.status.errorCode];
                
                if (result.status.batteryStatus) {
                    statusString = [statusString stringByAppendingFormat:@"batteryStatus.batteryMounted: %ld\n", result.status.batteryStatus.batteryMounted];
                    statusString = [statusString stringByAppendingFormat:@"batteryStatus.charging: %ld\n", result.status.batteryStatus.charging];
                    statusString = [statusString stringByAppendingFormat:@"batteryStatus.chargeLevel: %d/%d\n", result.status.batteryStatus.chargeLevel.current, result.status.batteryStatus.chargeLevel.max];
                }
                else {
                    statusString = [statusString stringByAppendingFormat:@"batteryStatus: null\n"];
                }
                
                if (result.status.mediaInfo) {
                    statusString = [statusString stringByAppendingFormat:@"mediaInfo.mediaType: %ld\n", result.status.mediaInfo.mediaType];
                    statusString = [statusString stringByAppendingFormat:@"mediaInfo.backgroundColor: %ld\n", result.status.mediaInfo.backgroundColor];
                    statusString = [statusString stringByAppendingFormat:@"mediaInfo.inkColor: %ld\n", result.status.mediaInfo.inkColor];
                    if (result.status.mediaInfo.isHeightInfinite) {
                        statusString = [statusString stringByAppendingFormat:@"mediaInfo.(width, height): (%d, ∞)\n", result.status.mediaInfo.width_mm];
                    }
                    else {
                        statusString = [statusString stringByAppendingFormat:@"mediaInfo.(width, height): (%d, %d)\n", result.status.mediaInfo.width_mm, result.status.mediaInfo.height_mm];
                    }
                    bool succeeded;
                    BRLMPTPrintSettingsLabelSize ptSize = [result.status.mediaInfo getPTLabelSize:&succeeded];
                    if (succeeded) {
                        statusString = [statusString stringByAppendingFormat:@"mediaInfo getPTLabelSize: %ld\n", ptSize];
                    }
                    BRLMQLPrintSettingsLabelSize qlSize = [result.status.mediaInfo getQLLabelSize:&succeeded];
                    if (succeeded) {
                        statusString = [statusString stringByAppendingFormat:@"mediaInfo getQLLabelSize: %ld\n", qlSize];
                    }
                }
                else {
                    statusString = [statusString stringByAppendingFormat:@"mediaInfo: null\n"];
                }
                
                [self showSuccessAlert:statusString];
            }
            else {
                [self showFailAlert:@"Fail to get status."];
            }
        }
        else {
            [self showFailAlert:@"Fail to connect."];
        }
    }
    else {
        [self showFailAlert:@"Printer is not selected."];
    }
    [sender setEnabled:YES];
    
}



#pragma mark - Show Result

- (void)showLongText:(NSString *)title text:(NSString *)text {
    BRDisplayTextViewController *vc = [[BRDisplayTextViewController alloc] initWithText:text];
    vc.title = title;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showSuccessAlert:(NSString *)message {
    [self showAlert:@"Success" message:message];
}

- (void)showFailAlert:(NSString *)message {
    [self showAlert:@"Failed" message:message];
}

- (void)showAlert:(NSString *)title message:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end
