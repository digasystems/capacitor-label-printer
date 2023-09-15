//
//  BRPrintSettingDetailTableVIewController.m
//  SDK_Sample_Ver2
//
//  Copyright © 2015 Brother Industries, Ltd. All rights reserved.
//

#import "UserDefaults.h"
#import "BRPrintSettingDetailTableVIewController.h"

@interface BRPrintSettingDetailTableVIewController ()
{
}
@property (nonatomic, strong) NSMutableArray *printSettingItemsArray;
@property (nonatomic, strong) NSMutableArray *printSettingItemNumberArray;
@end

@implementation BRPrintSettingDetailTableVIewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.printSettingItemsArray = nil;
    self.printSettingItemNumberArray = nil;
    
    if ([self.selectedRowKey isEqualToString:kPrintPaperSizeKey]){
        NSString *pathInPrintSettings   = [[NSBundle mainBundle] pathForResource:@"PrinterList" ofType:@"plist"];
        if (pathInPrintSettings) {
            NSString *selectedDevice = [self selectedDeviceInPrinterList];
            if (selectedDevice) {
                NSDictionary *priterListRootDictionary = [NSDictionary dictionaryWithContentsOfFile:pathInPrintSettings];
                if (priterListRootDictionary) {
                    self.printSettingItemsArray         = [[priterListRootDictionary objectForKey:selectedDevice] objectForKey:@"PaperSize"];
                    self.printSettingItemNumberArray    = [[priterListRootDictionary objectForKey:selectedDevice] objectForKey:@"PaperSize"];
                }
            }
        }
    }
    else if ([self.selectedRowKey isEqualToString:kPrintCustomPaperKey]){
        NSMutableArray *itemsArray      = [[NSMutableArray alloc] init];
        NSMutableArray *itemNumberArray = [[NSMutableArray alloc] init];
        [itemsArray         addObject:@"No Custom Page"];
        [itemNumberArray    addObject:@""];
        
        NSArray *documentDirectries = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [documentDirectries lastObject];
        NSError *error = nil;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSMutableArray *dataArray = [[fileManager contentsOfDirectoryAtPath:documentDirectory error:&error] mutableCopy];
        if (dataArray) {
            for (NSString *dataStr in dataArray) {
                BOOL isBinFile =[dataStr hasSuffix:@".bin"];
                if (isBinFile) {
                    [itemsArray         addObject:dataStr];
                    [itemNumberArray    addObject:dataStr];
                }
            }
        }
        self.printSettingItemsArray         = itemsArray;
        self.printSettingItemNumberArray    = itemNumberArray;
    }
    else{
        NSString *pathInPrintSettings = [[NSBundle mainBundle] pathForResource:@"PrintSettings" ofType:@"plist"];
        if (pathInPrintSettings) {
            NSMutableArray *rootArray = [NSMutableArray arrayWithContentsOfFile:pathInPrintSettings];
            if (rootArray) {
                for (NSDictionary *dict in rootArray) {
                    if ([[dict objectForKey:@"Key"] isEqualToString:self.selectedRowKey]) {
                        self.printSettingItemsArray         = [dict objectForKey:@"Items"];
                        self.printSettingItemNumberArray    = [dict objectForKey:@"ItemNumber"];
                        break;
                    }
                }
            }
        }
    }
}

- (NSString *)selectedDeviceInPrinterList {
    NSString *device = nil;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([userDefaults integerForKey:kIsWiFi] == 0 && [userDefaults integerForKey:kIsBluetooth] == 1 && [userDefaults integerForKey:kIsBLE] == 0){
        device = [NSString stringWithFormat:@"Brother %@",[userDefaults stringForKey:kSelectedDeviceFromBluetooth]];
    }
    else if ([userDefaults integerForKey:kIsWiFi] == 1 && [userDefaults integerForKey:kIsBluetooth] == 0 && [userDefaults integerForKey:kIsBLE] == 0){
        device = [NSString stringWithFormat:@"%@", [userDefaults stringForKey:kSelectedDeviceFromWiFi]];
    }
    else if ([userDefaults integerForKey:kIsWiFi] == 0 && [userDefaults integerForKey:kIsBluetooth] == 0 && [userDefaults integerForKey:kIsBLE] == 1){
        device = [NSString stringWithFormat:@"%@", [userDefaults stringForKey:kSelectedDeviceFromBLE]];
    }
    else{
        device = nil;
    }
    
    return device;
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
    return self.printSettingItemsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"printSettingDetailCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"printSettingDetailCell"];
    }
    
    cell.textLabel.text = [self.printSettingItemsArray objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[self.printSettingItemNumberArray objectAtIndex:indexPath.row] forKey:self.selectedRowKey];
    [userDefaults synchronize];
}

@end
