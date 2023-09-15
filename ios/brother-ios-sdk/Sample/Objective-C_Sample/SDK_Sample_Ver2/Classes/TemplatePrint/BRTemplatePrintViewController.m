//
//  BRTemplatePrintViewController.m
//  SDK_Sample_Ver2
//
//  Copyright (c) 2018 Brother Industries, Ltd. All rights reserved.
//

#import <BRLMPrinterKit/BRPtouchPrinterKit.h>

#import "BRTemplatePrintViewController.h"
#import "BRTemplatePrintProcessItem.h"
#import "UserDefaults.h"
#import "UIColor+CompatiColor.h"

@interface BRTemplatePrintViewController ()
@property (weak, nonatomic) IBOutlet UITextField *templateKeyTextField;
@property (weak, nonatomic) IBOutlet UILabel *selectedEncodingLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *replaceModeSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *templateObjectIndexLabel;
@property (weak, nonatomic) IBOutlet UITextField *templateObjectIndexTextField;
@property (weak, nonatomic) IBOutlet UITextField *templateNumCopiesTextField;
@property (weak, nonatomic) IBOutlet UILabel *templateObjectNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *templateObjectNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *templateObjectReplacementLabel;
@property (weak, nonatomic) IBOutlet UITextField *templateObjectReplacementTextField;
@property (weak, nonatomic) IBOutlet UITextView *replacementListTextView;
@property (nonatomic) TemplateEncoding selectedEncoding;
@property (nonatomic) NSMutableArray<BRTemplatePrintProcessItem *> *printProcess;
@property (nonatomic) BRPtouchPrinter *ptp;
@property (nonatomic) BOOL isCommunicating;
@property (nonatomic) UIAlertController *alertController;
@end

@implementation BRTemplatePrintViewController

+ (instancetype)makeInstance {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BRTemplatePrintViewController" bundle:nil];
    BRTemplatePrintViewController *viewController = storyboard.instantiateInitialViewController;

    return viewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.replaceModeSegmentedControl.selectedSegmentIndex = TemplateObjectReplacementModeText;
    [self replaceModeDidChangeValue:self.replaceModeSegmentedControl];
    
    self.templateKeyTextField.delegate = self;
    self.templateObjectIndexTextField.delegate = self;
    self.templateObjectNameTextField.delegate = self;
    self.templateObjectReplacementTextField.delegate = self;
    self.templateNumCopiesTextField.delegate = self;
    
    self.replacementListTextView.text = @"";
    
    self.printProcess = [NSMutableArray new];
    self.isCommunicating = NO;
    [self setupAlertController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupAlertController {
    self.alertController = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel"
                                                           style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             [self cancelPrinterCommunication];
                                                         }];
    [self.alertController addAction:cancelAction];
}

- (void)changeSelectedEncoding:(TemplateEncoding)encoding {
    self.selectedEncoding = encoding;
    self.selectedEncodingLabel.text = [BRTemplateEncodingUtil stringFromTemplateEncoding:encoding];
}

- (void)setTemplateObjectIndexEnabled:(BOOL)enabled {
    self.templateObjectIndexLabel.enabled = enabled;
    self.templateObjectIndexTextField.enabled = enabled;
    self.templateObjectIndexTextField.textColor = (enabled) ? UIColor.labelColorCompati : UIColor.systemGrayColor;
}

- (void)setTemplateObjectNameEnabled:(BOOL)enabled {
    self.templateObjectNameLabel.enabled = enabled;
    self.templateObjectNameTextField.enabled = enabled;
    self.templateObjectNameTextField.textColor = (enabled) ? UIColor.labelColorCompati : UIColor.systemGrayColor;
}

// FIXME: 共通化
// PrintResultViewController からコピーしてきた
- (BRPtouchPrintInfo *)getPrintInfo {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *selectedDevice = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directory = [paths lastObject];

    // PrintInfo
    BRPtouchPrintInfo *printInfo = [[BRPtouchPrintInfo alloc] init];
    
    if ([[userDefaults stringForKey:kExportPrintFileNameKey] isEqualToString:@""]) {
        printInfo.strSaveFilePath    = @"";
    }
    else {
        NSString *fileName = [[userDefaults stringForKey:kExportPrintFileNameKey] stringByAppendingPathExtension:@"prn"];
        NSString *filePath = [directory stringByAppendingPathComponent:fileName];
        printInfo.strSaveFilePath = filePath; // Item 0
    }

    printInfo.strPaperName        = [userDefaults stringForKey:kPrintPaperSizeKey];
    printInfo.nOrientation        = (int)[userDefaults integerForKey:kPrintOrientationKey];
    printInfo.nPrintMode        = (int)[userDefaults integerForKey:kScalingModeKey];
    printInfo.scaleValue        = [userDefaults doubleForKey:kScalingFactorKey];
    
    printInfo.nHalftone            = (int)[userDefaults integerForKey:kPrintHalftoneKey];
    printInfo.nHalftoneBinaryThreshold = (int)[userDefaults integerForKey:kPrintBinaryThresholdKey];
    printInfo.nHorizontalAlign    = (int)[userDefaults integerForKey:kPrintHorizintalAlignKey];
    printInfo.nVerticalAlign    = (int)[userDefaults integerForKey:kPrintVerticalAlignKey];
    printInfo.nPaperAlign        = (int)[userDefaults integerForKey:kPrintPaperAlignKey];
    
    printInfo.nExtFlag |= (int)[userDefaults integerForKey:kPrintCodeKey];
    printInfo.nExtFlag |= (int)[userDefaults integerForKey:kPrintCarbonKey];
    printInfo.nExtFlag |= (int)[userDefaults integerForKey:kPrintDashKey];
    printInfo.nExtFlag |= (int)[userDefaults integerForKey:kPrintFeedModeKey];
    
    printInfo.nRollPrinterCase    = (int)[userDefaults integerForKey:kPrintCurlModeKey];
    printInfo.nSpeed            = (int)[userDefaults integerForKey:kPrintSpeedKey];
    printInfo.bBidirection      = (int)[userDefaults integerForKey:kPrintBidirectionKey];
    
    printInfo.nCustomFeed   = (int)[userDefaults integerForKey:kPrintFeedMarginKey];
    printInfo.nCustomLength = (int)[userDefaults integerForKey:kPrintCustomLengthKey];
    printInfo.nCustomWidth  = (int)[userDefaults integerForKey:kPrintCustomWidthKey];
    
    printInfo.nAutoCutFlag  |= (int)[userDefaults integerForKey:kPrintAutoCutKey];
    printInfo.bEndcut = (int)[userDefaults integerForKey:kPrintCutAtEndKey];
    printInfo.bHalfCut       = (int)[userDefaults integerForKey:kPrintHalfCutKey];
    printInfo.bSpecialTape      = (int)[userDefaults integerForKey:kPrintSpecialTapeKey];
    printInfo.bRotate180     = (int)[userDefaults integerForKey:kRotateKey];
    printInfo.bPeel          = (int)[userDefaults integerForKey:kPeelKey];
    
    NSString *customPaper = [userDefaults stringForKey:kPrintCustomPaperKey];
    NSString *customPaperFilePath = nil;
    if(![customPaper isEqualToString:@"NoCustomPaper"]) {
        customPaperFilePath = [NSString stringWithFormat:@"%@/%@",directory, [userDefaults stringForKey:kPrintCustomPaperKey]];
    }
    
    printInfo.bCutMark      = (int)[userDefaults integerForKey:kPrintCutMarkKey];
    printInfo.nLabelMargine = (int)[userDefaults integerForKey:kPrintLabelMargineKey];
    
    if ([selectedDevice rangeOfString:@"RJ-"].location != NSNotFound ||
        [selectedDevice rangeOfString:@"TD-"].location != NSNotFound) {
        printInfo.nDensity = (int)[userDefaults integerForKey:kPrintDensityMax5Key];
    }
    else if([selectedDevice rangeOfString:@"PJ-"].location != NSNotFound){
        printInfo.nDensity = (int)[userDefaults integerForKey:kPrintDensityMax10Key];
    }
    else {
        // Error
    }
    
    printInfo.nTopMargin   = (int)[userDefaults integerForKey:kPrintTopMarginKey];
    printInfo.nLeftMargin   = (int)[userDefaults integerForKey:kPrintLeftMarginKey];
    
    printInfo.nPJPaperKind = (int)[userDefaults integerForKey:kPJPaperKindKey];
    
    printInfo.nPrintQuality = (int)[userDefaults integerForKey:kPirintQuality];
    
    printInfo.bMode9 = (int)[userDefaults integerForKey:kPrintMode9];
    printInfo.bRawMode = (int)[userDefaults integerForKey:kPrintRawMode];
    
    return printInfo;
}

- (void)updateReplacementList {
    NSMutableString *printProcessText = [NSMutableString new];

    for (BRTemplatePrintProcessItem *item in self.printProcess) {
        switch (item.mode) {
            case TemplateObjectReplacementModeText:
                [printProcessText appendFormat:@"key: %d, replace with: %@\n", item.key, item.replacementText];
                break;
            case TemplateObjectReplacementModeIndex:
                [printProcessText appendFormat:@"key: %d, index: %d replace with: %@\n", item.key, item.objectIndex, item.replacementText];
                break;
            case TemplateObjectReplacementModeObjectName:
                [printProcessText appendFormat:@"key: %d, name: %@ replace with: %@\n", item.key, item.objectName, item.replacementText];
                break;
            default:
                break;
        }
    }
    
    self.replacementListTextView.text = printProcessText;
}

- (NSStringEncoding)stringEncoding {
    switch (self.selectedEncoding) {
        case JapaneseEncoding:
            return NSShiftJISStringEncoding;
            break;
        case EnglishEncoding:
            return NSUTF8StringEncoding;
            break;
        case ChineseEncoding:
            return CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            break;
        default:
            return NSUTF8StringEncoding;
            break;
    }
}

- (void)showCancelControllerWithTitle:(NSString *)title message:(NSString *)message {
    self.alertController.title = title;
    self.alertController.message = message;
    [self presentViewController:self.alertController animated:YES completion:nil];
}

- (void)changeCancelControllerMessage:(NSString *)message {
    self.alertController.message = message;
}

- (void)dismissAlertController {
    if ([self.presentedViewController isKindOfClass:[self.alertController class]]) {
        [self.alertController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (BOOL)startPrinterCommunication {
    if (self.isCommunicating) { return NO; }
    self.isCommunicating = [self.ptp startCommunication];
    
    return self.isCommunicating;
}

- (void)cancelPrinterCommunication {
    if (self.isCommunicating) {
        [self.ptp cancelPrinting];
        [self.ptp endCommunication];
        self.isCommunicating = NO;
    }
}

- (void)stopPrinterCommunication {
    if (self.isCommunicating) {
        [self.ptp endCommunication];
        self.isCommunicating = NO;
    }
}

- (void)setupPTPrinter {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    CONNECTION_TYPE type = CONNECTION_TYPE_ERROR;
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
    else {
        self.ptp = nil;
    }
    
    [self.ptp setPrintInfo:[self getPrintInfo]];
}

- (void)startPrintWithTemplateKey:(int)key encoding:(NSStringEncoding)encoding {
    [self setupPTPrinter];

    __weak BRTemplatePrintViewController *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        BOOL result = false;
        if ([weakSelf startPrinterCommunication]) {
            [weakSelf.ptp startPTTPrint:key encoding:encoding];
            
            for (BRTemplatePrintProcessItem *item in weakSelf.printProcess) {
                switch (item.mode) {
                    case TemplateObjectReplacementModeText:
                        [weakSelf.ptp replaceText:item.replacementText];
                        break;
                    case TemplateObjectReplacementModeIndex:
                        [weakSelf.ptp replaceTextIndex:item.replacementText objectIndex:item.objectIndex];
                        break;
                    case TemplateObjectReplacementModeObjectName:
                        [weakSelf.ptp replaceTextName:item.replacementText objectName:item.objectName];
                    default:
                        break;
                }
            }
            
            int copies = self.templateNumCopiesTextField.text.intValue;
            result = [weakSelf.ptp flushPTTPrintWithCopies:copies];
            [weakSelf stopPrinterCommunication];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            if (result) {
                [weakSelf dismissAlertController];
            }
            else {
                [weakSelf changeCancelControllerMessage:@"failed"];
            }
        });
    });
}

#pragma mark - IBAction

- (IBAction)replaceModeDidChangeValue:(id)sender {
    TemplateObjectReplacementMode mode = [(UISegmentedControl *)sender selectedSegmentIndex];
    switch (mode) {
        case TemplateObjectReplacementModeText:
            [self setTemplateObjectIndexEnabled:NO];
            [self setTemplateObjectNameEnabled:NO];
            break;
        case TemplateObjectReplacementModeIndex:
            [self setTemplateObjectIndexEnabled:YES];
            [self setTemplateObjectNameEnabled:NO];
            break;
        case TemplateObjectReplacementModeObjectName:
            [self setTemplateObjectIndexEnabled:NO];
            [self setTemplateObjectNameEnabled:YES];
            break;
        default:
            break;
    }
}

- (IBAction)replacementAddButtonDidTapped:(id)sender {
    TemplateObjectReplacementMode currentMode = self.replaceModeSegmentedControl.selectedSegmentIndex;
    
    BRTemplatePrintProcessItem *item = [BRTemplatePrintProcessItem new];
    item.key = self.templateKeyTextField.text.intValue;
    item.mode = currentMode;
    item.objectIndex = self.templateObjectIndexTextField.text.intValue;
    item.objectName = self.templateObjectNameTextField.text;
    item.replacementText = self.templateObjectReplacementTextField.text;

    [self.printProcess addObject:item];
    [self updateReplacementList];
}
- (IBAction)deleteButtonTapped:(id)sender {
    [self.printProcess removeLastObject];
    [self updateReplacementList];
}

- (IBAction)cancelButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)printButtonTapped:(id)sender {
    int printTemplateKey = 0;
    if (self.printProcess.firstObject) {
        printTemplateKey = self.printProcess.firstObject.key;
    }
    else {
        printTemplateKey = self.templateKeyTextField.text.intValue;
    }

    [self showCancelControllerWithTitle:@"Template Print" message:@"sending..."];
    
    NSStringEncoding encoding = [self stringEncoding];
    [self startPrintWithTemplateKey:printTemplateKey encoding:encoding];
}

#pragma mark - UITextFieldDelegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITableViewDelegates

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // エンコードのみ選択可能にする
    if (indexPath.section == 0 && indexPath.row == 1) {
        return indexPath;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BRTemplateEncodingTableViewController *viewController = [BRTemplateEncodingTableViewController makeInstance];
    viewController.delegate = self;
    
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - BRTemplateEncodingTableViewControllerDelegate

- (void)templateEncodingTableView:(UITableViewController *)tableView didSelectTemplateEncoding:(TemplateEncoding)encoding {
    [self changeSelectedEncoding:encoding];
}

@end
