//
//  BRDeleteTemplateViewController.m
//  SDK_Sample_Ver2
//
//  Copyright (c) 2018 Brother Industries, Ltd. All rights reserved.
//

#import <BRLMPrinterKit/BRPtouchPrinterKit.h>

#import "BRDeleteTemplateViewController.h"
#import "UserDefaults.h"
#import "NSDate+Formatter.h"

@interface BRDeleteTemplateViewController ()
@property (nonatomic) BRPtouchPrinter *ptp;
@property (nonatomic) NSArray<BRPtouchTemplateInfo*> *templateList;
@property (nonatomic) BOOL isCommunicating;
@property (nonatomic) UIAlertController *alertController;
@end

@implementation BRDeleteTemplateViewController

+ (instancetype)makeInstance {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BRDeleteTemplateViewController" bundle:nil];
    BRDeleteTemplateViewController *viewController = storyboard.instantiateInitialViewController;

    return viewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isCommunicating = NO;
    self.tableView.allowsMultipleSelection = YES;
    [self setupToolbar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

- (void)setupToolbar {
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithTitle:@"delete" style:UIBarButtonItemStylePlain target:self action:@selector(deleteButtonPushed:)];
    UIBarButtonItem *getButton = [[UIBarButtonItem alloc] initWithTitle:@"get" style:UIBarButtonItemStylePlain target:self action:@selector(getButtonPushed:)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [self.toolbar setItems:@[space, deleteButton, space, getButton, space]];
}

- (void)showCancelControllerWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel"
                                                           style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             [self cancelPrinterCommunication];
                                                         }];
    
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showMessageControllerWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"close"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             // do nothing
                                                         }];
    
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)dismissAlertController {
    [self dismissAlertControllerWithCompletion:nil];
}

- (void)dismissAlertControllerAndShowAlertController:(NSString *)title message:(NSString *)message {
    __weak BRDeleteTemplateViewController *weakSelf = self;
    [self dismissAlertControllerWithCompletion:^{
        [weakSelf showMessageControllerWithTitle:title message:message];
    }];
}

- (void)dismissAlertControllerWithCompletion:(void (^)(void))completion {
    if ([self.presentedViewController isKindOfClass:[UIAlertController class]]) {
        [self.presentedViewController dismissViewControllerAnimated:YES completion:completion];
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

- (NSArray<NSNumber *>*)selectedTemplateKeys {
    __block NSMutableArray<NSNumber *> *deleteTemplateKeys = [NSMutableArray new];
    [self.tableView.indexPathsForSelectedRows enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.section == 0) {
            NSNumber *selectedKey = [NSNumber numberWithInteger:self.templateList[obj.row].key];
            [deleteTemplateKeys addObject:selectedKey];
        }
    }];
    return [deleteTemplateKeys copy];
}

- (void)deleteButtonPushed:(UIBarButtonItem *)sender {
    NSArray<NSNumber *> *deleteTemplateKeys = [self selectedTemplateKeys];
    if (deleteTemplateKeys.count == 0) {
        [self showMessageControllerWithTitle:@"Delete Templates" message:@"Failed - select templates"];
        return;
    }
    
    [self showCancelControllerWithTitle:@"Delete Templates" message:@"sending..."];

    __weak BRDeleteTemplateViewController *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        int result = RET_FALSE;
        if ([weakSelf startPrinterCommunication]) {
            result = [weakSelf.ptp removeTemplate:deleteTemplateKeys];
            if (result == RET_TRUE) {
                [weakSelf reloadTemplateList];
            }
            [weakSelf stopPrinterCommunication];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
            NSString *message = (result == RET_TRUE) ? @"Succeeded" : @"Failed";
            [weakSelf dismissAlertControllerAndShowAlertController:@"Delete Templates" message:message];
        });
    });
}

- (void)getButtonPushed:(UIBarButtonItem *)sender {
    [self setupPTPrinter];
    [self showCancelControllerWithTitle:@"Sync Templates" message:@"receiving..."];
    
    __weak BRDeleteTemplateViewController *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL result = false;
        if ([weakSelf startPrinterCommunication]) {
            result = [weakSelf reloadTemplateList];
            [weakSelf stopPrinterCommunication];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
            NSString *message = (result) ? @"Succeeded" : @"Failed";
            [weakSelf dismissAlertControllerAndShowAlertController:@"Sync Templates" message:message];
        });
    });
}

- (BOOL)reloadTemplateList {
    int result = RET_FALSE;
    if (self.isCommunicating) {
        self.templateList = nil;
        NSArray<BRPtouchTemplateInfo *> *templateInfo;
        result = [self.ptp getTemplateList:&templateInfo];

        if (result == RET_TRUE) {
            self.templateList = templateInfo;
        }
    }
    
    return (result == RET_TRUE) ? YES : NO;
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
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.templateList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DeleteTemplateCell"];
    
    BRPtouchTemplateInfo *templateInfo = self.templateList[indexPath.row];
    NSUInteger key  = templateInfo.key;
    NSUInteger size = templateInfo.fileSize;
    NSString *title = templateInfo.fileName;
    NSString *modifiedDate = [templateInfo.modifiedDate dateStringWithFormat:@"yyyy/MM/dd HH:mm:ss"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%3lu - %@", (unsigned long)key, title];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"      %@ - %lu byte", modifiedDate, (unsigned long)size];
    
    return cell;
}


#pragma mark - UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
@end
