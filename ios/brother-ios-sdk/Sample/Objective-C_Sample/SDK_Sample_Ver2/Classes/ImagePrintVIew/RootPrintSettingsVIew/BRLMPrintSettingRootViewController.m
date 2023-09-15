// ------------------------------------------------------
//  BRLMPrintSettingRootViewController.m
//  SDK_Sample_Ver2
//
//  Copyright (c) 2020 Brother Industries, Ltd. All rights reserved.
// ------------------------------------------------------

#import "BRLMPrintSettingRootViewController.h"
#import <BRLMPrinterKit/BRLMPrinterKit.h>
#import "UserDefaults.h"
#import "BRLMUserDefaults.h"
#import "BRLMPrintSettingTableViewController.h"

@interface BRLMPrintSettingRootViewController ()

@end

@implementation BRLMPrintSettingRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [self selectedModelString];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSString* title;
    switch ((BRLMPrinterClassifierSeries)indexPath.row) {
        case BRLMPrinterClassifierSeriesPJ: title = @"PJ"; break;
        case BRLMPrinterClassifierSeriesRJ: title = @"RJ"; break;
        case BRLMPrinterClassifierSeriesTD: title = @"TD"; break;
        case BRLMPrinterClassifierSeriesPT: title = @"PT"; break;
        case BRLMPrinterClassifierSeriesQL: title = @"QL"; break;
        case BRLMPrinterClassifierSeriesMW: title = @"MW"; break;
        case BRLMPrinterClassifierSeriesUnknown: title = @"Unknown"; break;
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"BRLMPrintSettingRootViewController_textFieldCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BRLMPrintSettingRootViewController_textFieldCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = title;
    
    BRLMPrinterClassifierSeries selectedSeries = [BRLMPrinterClassifier classifyPrinterSerieseFromModel:[self selectedModel]];
    cell.textLabel.enabled = (selectedSeries == (BRLMPrinterClassifierSeries)indexPath.row);
    cell.tag = (BRLMPrinterClassifierSeries)indexPath.row;
    
    return cell;
}


#pragma mark - Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UITableViewCell* cell = sender;
    BRLMPrintSettingTableViewController *viewController = [segue destinationViewController];
    BRLMPrinterModel model = [self selectedModel];
    if (cell.tag != [BRLMPrinterClassifier classifyPrinterSerieseFromModel:[self selectedModel]]) {
        switch ((BRLMPrinterClassifierSeries)cell.tag) {
            case BRLMPrinterClassifierSeriesPJ: model = BRLMPrinterModelPJ_673; break;
            case BRLMPrinterClassifierSeriesRJ: model = BRLMPrinterModelRJ_4230B; break;
            case BRLMPrinterClassifierSeriesTD: model = BRLMPrinterModelTD_2130N; break;
            case BRLMPrinterClassifierSeriesPT: model = BRLMPrinterModelPT_P710BT; break;
            case BRLMPrinterClassifierSeriesQL: model = BRLMPrinterModelQL_820NWB; break;
            case BRLMPrinterClassifierSeriesMW: model = BRLMPrinterModelMW_170; break;
            case BRLMPrinterClassifierSeriesUnknown: model = BRLMPrinterModelUnknown; break;
        }
    }
    if (cell.tag == BRLMPrinterClassifierSeriesQL) {
        viewController.properties = @[@"BRLMQLPrintSettingsLabelSize", @"BRLMPrintSettingsAutoCutForEachPageCount", @"BRLMPrintSettingsAutoCut", @"BRLMPrintSettingsCutAtEnd", @"BRLMPrintSettingsResolution", @"BRLMQLPrintSettingsBiColorRedEnhancement", @"BRLMQLPrintSettingsBiColorGreenEnhancement", @"BRLMQLPrintSettingsBiColorBlueEnhancement", @"BRLMPrintSettingsScaleMode", @"BRLMPrintSettingsScaleValue", @"BRLMPrintSettingsOrientation", @"BRLMPrintSettingsRotation", @"BRLMPrintSettingsHalftone", @"BRLMPrintSettingsHorizontalAlignment", @"BRLMPrintSettingsVerticalAlignment", @"BRLMPrintSettingsCompressMode", @"BRLMPrintSettingsHalftoneThreshold", @"BRLMPrintSettingsNumCopies", @"BRLMPrintSettingsSkipStatusCheck", @"BRLMPrintSettingsPrintQuality", ];
        
        viewController.qlSettings = [BRLMUserDefaults sharedDefaults].qlSettings;
        if(viewController.qlSettings == nil) {
            viewController.qlSettings = [[BRLMQLPrintSettings alloc] initDefaultPrintSettingsWithPrinterModel:model];
        }
        else {
            viewController.qlSettings = [viewController.qlSettings copyWithPrinterModel:model];
        }
    }

    if (cell.tag == BRLMPrinterClassifierSeriesPT) {
        viewController.properties = @[@"BRLMPTPrintSettingsLabelSize", @"BRLMPrintSettingsCutmarkPrint", @"BRLMPTPrintSettingsCutPause", @"BRLMPrintSettingsAutoCut", @"BRLMPrintSettingsHalfCut", @"BRLMPrintSettingsChainPrint", @"BRLMPrintSettingsSpecialTapePrint", @"BRLMPrintSettingsResolution", @"BRLMPrintSettingsAutoCutForEachPageCount", @"BRLMPrintSettingsForceVanishingMargin", @"BRLMPrintSettingsScaleMode", @"BRLMPrintSettingsScaleValue", @"BRLMPrintSettingsOrientation", @"BRLMPrintSettingsRotation", @"BRLMPrintSettingsHalftone", @"BRLMPrintSettingsHorizontalAlignment", @"BRLMPrintSettingsVerticalAlignment", @"BRLMPrintSettingsCompressMode", @"BRLMPrintSettingsHalftoneThreshold", @"BRLMPrintSettingsNumCopies", @"BRLMPrintSettingsSkipStatusCheck", @"BRLMPrintSettingsPrintQuality", ];
        
        viewController.ptSettings = [BRLMUserDefaults sharedDefaults].ptSettings;
        if(viewController.ptSettings == nil) {
            viewController.ptSettings = [[BRLMPTPrintSettings alloc] initDefaultPrintSettingsWithPrinterModel:model];
        }
        else {
            viewController.ptSettings = [viewController.ptSettings copyWithPrinterModel:model];
        }
    }

    if (cell.tag == BRLMPrinterClassifierSeriesPJ) {
        viewController.properties = @[@"BRLMPJPrintSettingsPaperSize", @"BRLMPJPrintSettingsPaperType", @"BRLMPJPrintSettingsPaperInsertionPosition", @"BRLMPJPrintSettingsFeedMode", @"BRLMPJPrintSettingsExtraFeedDots", @"BRLMPJPrintSettingsDensity", @"BRLMPJPrintSettingsRollCase", @"BRLMPJPrintSettingsPrintSpeed", @"BRLMPrintSettingsUsingCarbonCopyPaper", @"BRLMPrintSettingsPrintDashLine", @"BRLMPJPrintSettingsForceStretchPrintableArea", @"BRLMPrintSettingsScaleMode", @"BRLMPrintSettingsScaleValue", @"BRLMPrintSettingsOrientation", @"BRLMPrintSettingsRotation", @"BRLMPrintSettingsHalftone", @"BRLMPrintSettingsHorizontalAlignment", @"BRLMPrintSettingsVerticalAlignment", @"BRLMPrintSettingsCompressMode", @"BRLMPrintSettingsHalftoneThreshold", @"BRLMPrintSettingsNumCopies", @"BRLMPrintSettingsSkipStatusCheck", @"BRLMPrintSettingsPrintQuality", ];
        
        viewController.pjSettings = [BRLMUserDefaults sharedDefaults].pjSettings;
        if(viewController.pjSettings == nil) {
            viewController.pjSettings = [[BRLMPJPrintSettings alloc] initDefaultPrintSettingsWithPrinterModel:model];
        }
        else {
            viewController.pjSettings = [viewController.pjSettings copyWithPrinterModel:model];
        }
    }

    if (cell.tag == BRLMPrinterClassifierSeriesMW) {
        viewController.properties = @[@"BRLMMWPrintSettingsPaperSize", @"BRLMPrintSettingsScaleMode", @"BRLMPrintSettingsScaleValue", @"BRLMPrintSettingsOrientation", @"BRLMPrintSettingsRotation", @"BRLMPrintSettingsHalftone", @"BRLMPrintSettingsHorizontalAlignment", @"BRLMPrintSettingsVerticalAlignment", @"BRLMPrintSettingsCompressMode", @"BRLMPrintSettingsHalftoneThreshold", @"BRLMPrintSettingsNumCopies", @"BRLMPrintSettingsSkipStatusCheck", @"BRLMPrintSettingsPrintQuality", ];
        
        viewController.mwSettings = [BRLMUserDefaults sharedDefaults].mwSettings;
        if(viewController.mwSettings == nil) {
            viewController.mwSettings = [[BRLMMWPrintSettings alloc] initDefaultPrintSettingsWithPrinterModel:model];
        }
        else {
            viewController.mwSettings = [viewController.mwSettings copyWithPrinterModel:model];
        }
    }

    if (cell.tag == BRLMPrinterClassifierSeriesTD) {
        viewController.properties = @[@"BRLMCustomPaperSize", @"BRLMTDPrintSettingsDensity", @"BRLMPrintSettingsPeelLabel", @"BRLMPrintSettingsAutoCut", @"BRLMPrintSettingsCutAtEnd", @"BRLMPrintSettingsAutoCutForEachPageCount", @"BRLMPrintSettingsScaleMode", @"BRLMPrintSettingsScaleValue", @"BRLMPrintSettingsOrientation", @"BRLMPrintSettingsRotation", @"BRLMPrintSettingsHalftone", @"BRLMPrintSettingsHorizontalAlignment", @"BRLMPrintSettingsVerticalAlignment", @"BRLMPrintSettingsCompressMode", @"BRLMPrintSettingsHalftoneThreshold", @"BRLMPrintSettingsNumCopies", @"BRLMPrintSettingsSkipStatusCheck", @"BRLMPrintSettingsPrintQuality", ];
        
        viewController.tdSettings = [BRLMUserDefaults sharedDefaults].tdSettings;
        if(viewController.tdSettings == nil) {
            viewController.tdSettings = [[BRLMTDPrintSettings alloc] initDefaultPrintSettingsWithPrinterModel:model];
        }
        else {
            viewController.tdSettings = [viewController.tdSettings copyWithPrinterModel:model];
        }
    }

    if (cell.tag == BRLMPrinterClassifierSeriesRJ) {
        viewController.properties = @[@"BRLMCustomPaperSize", @"BRLMRJPrintSettingsDensity", @"BRLMPrintSettingsRotate180degrees", @"BRLMPrintSettingsPeelLabel", @"BRLMPrintSettingsScaleMode", @"BRLMPrintSettingsScaleValue", @"BRLMPrintSettingsOrientation", @"BRLMPrintSettingsRotation", @"BRLMPrintSettingsHalftone", @"BRLMPrintSettingsHorizontalAlignment", @"BRLMPrintSettingsVerticalAlignment", @"BRLMPrintSettingsCompressMode", @"BRLMPrintSettingsHalftoneThreshold", @"BRLMPrintSettingsNumCopies", @"BRLMPrintSettingsSkipStatusCheck", @"BRLMPrintSettingsPrintQuality", ];
        
        viewController.rjSettings = [BRLMUserDefaults sharedDefaults].rjSettings;
        if(viewController.rjSettings == nil) {
            viewController.rjSettings = [[BRLMRJPrintSettings alloc] initDefaultPrintSettingsWithPrinterModel:model];
        }
        else {
            viewController.rjSettings = [viewController.rjSettings copyWithPrinterModel:model];
        }
    }

    viewController.navigationItem.title = cell.textLabel.text;
}

- (BRLMPrinterModel)selectedModel {
    return [BRLMPrinterClassifier transferEnumFromString:[self selectedModelString]];
}

- (NSString*)selectedModelString {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *selectedDevice = nil;
    
    if ([userDefaults integerForKey:kIsWiFi] == 0 && [userDefaults integerForKey:kIsBluetooth] == 1 && [userDefaults integerForKey:kIsBLE] == 0){
        selectedDevice = [NSString stringWithFormat:@"%@",[userDefaults stringForKey:kSelectedDeviceFromBluetooth]];    }
    else if ([userDefaults integerForKey:kIsWiFi] == 1 && [userDefaults integerForKey:kIsBluetooth] == 0 && [userDefaults integerForKey:kIsBLE] == 0){
        selectedDevice = [NSString stringWithFormat:@"%@", [userDefaults stringForKey:kSelectedDeviceFromWiFi]];
    }
    else if ([userDefaults integerForKey:kIsWiFi] == 0 && [userDefaults integerForKey:kIsBluetooth] == 0 && [userDefaults integerForKey:kIsBLE] == 1){
        selectedDevice = [NSString stringWithFormat:@"%@", [userDefaults stringForKey:kSelectedDeviceFromBLE]];
    }
    else{
        return @"";
    }
    
    return selectedDevice;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction* deleteButton = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleNormal) title:@"Reset to default" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Reset to default printer setting." message:@"This action cannot be undone." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Reset" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
            UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
            BRLMPrinterModel model = [self selectedModel];
            if (cell.tag != [BRLMPrinterClassifier classifyPrinterSerieseFromModel:[self selectedModel]]) {
                switch ((BRLMPrinterClassifierSeries)cell.tag) {
                    case BRLMPrinterClassifierSeriesPJ: model = BRLMPrinterModelPJ_673; break;
                    case BRLMPrinterClassifierSeriesRJ: model = BRLMPrinterModelRJ_4230B; break;
                    case BRLMPrinterClassifierSeriesTD: model = BRLMPrinterModelTD_2130N; break;
                    case BRLMPrinterClassifierSeriesPT: model = BRLMPrinterModelPT_P710BT; break;
                    case BRLMPrinterClassifierSeriesQL: model = BRLMPrinterModelQL_820NWB; break;
                    case BRLMPrinterClassifierSeriesMW: model = BRLMPrinterModelMW_170; break;
                    case BRLMPrinterClassifierSeriesUnknown: model = BRLMPrinterModelUnknown; break;
                }
            }
            switch ((BRLMPrinterClassifierSeries)cell.tag) {
                case BRLMPrinterClassifierSeriesPJ: [BRLMUserDefaults sharedDefaults].pjSettings = [[BRLMPJPrintSettings alloc] initDefaultPrintSettingsWithPrinterModel:model]; break;
                case BRLMPrinterClassifierSeriesRJ: [BRLMUserDefaults sharedDefaults].rjSettings = [[BRLMRJPrintSettings alloc] initDefaultPrintSettingsWithPrinterModel:model]; break;
                case BRLMPrinterClassifierSeriesTD: [BRLMUserDefaults sharedDefaults].tdSettings = [[BRLMTDPrintSettings alloc] initDefaultPrintSettingsWithPrinterModel:model]; break;
                case BRLMPrinterClassifierSeriesPT: [BRLMUserDefaults sharedDefaults].ptSettings = [[BRLMPTPrintSettings alloc] initDefaultPrintSettingsWithPrinterModel:model]; break;
                case BRLMPrinterClassifierSeriesQL: [BRLMUserDefaults sharedDefaults].qlSettings = [[BRLMQLPrintSettings alloc] initDefaultPrintSettingsWithPrinterModel:model]; break;
                case BRLMPrinterClassifierSeriesMW: [BRLMUserDefaults sharedDefaults].mwSettings = [[BRLMMWPrintSettings alloc] initDefaultPrintSettingsWithPrinterModel:model]; break;
                case BRLMPrinterClassifierSeriesUnknown:  break;
            }
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {}]];
        [self presentViewController:alert animated:YES completion:^{}];
    }];
    deleteButton.backgroundColor = [UIColor systemRedColor];
    
    return @[deleteButton];
}

@end