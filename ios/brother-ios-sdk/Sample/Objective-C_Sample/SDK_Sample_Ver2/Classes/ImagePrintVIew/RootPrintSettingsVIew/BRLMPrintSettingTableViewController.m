// ------------------------------------------------------
//  BRLMPrintSettingTableViewController.m
//  SDK_Sample_Ver2
//
//  Copyright (c) 2020 Brother Industries, Ltd. All rights reserved.
// ------------------------------------------------------

#import "BRLMPrintSettingTableViewController.h"
#import "BRLMSelectNumberViewController.h"
#import "BRLMInputNumbersViewController.h"
#import "BRLMInputCustomPaperSizeViewController.h"
#import "BRLMPaperSizePJTableViewController.h"
#import "BRLMPrintSettingsValidateViewController.h"
#import "BRLMUserDefaults.h"

@class BRLMSwitchEventHandler;

@interface BRLMPrintSettingTableViewController ()
@property (nonatomic) void(^segueAction)(UIStoryboardSegue* segue);
@property (nonatomic) NSMutableDictionary<NSString*, BRLMSwitchEventHandler*>* switchEventHandlers;
@end

typedef void (^BRLMSwitchEventHandlerValueChanged)(BOOL value);
@interface BRLMSwitchEventHandler : NSObject
- (instancetype) initWithHandler:(BRLMSwitchEventHandlerValueChanged)handler;
- (void)perform:(id)sender;
@property (nonatomic) BRLMSwitchEventHandlerValueChanged handler;
@end

@implementation BRLMPrintSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.switchEventHandlers = [[NSMutableDictionary alloc] init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem.title = @"Validate";
}

- (void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [BRLMUserDefaults sharedDefaults].qlSettings = self.qlSettings;
    [BRLMUserDefaults sharedDefaults].ptSettings = self.ptSettings;
    [BRLMUserDefaults sharedDefaults].pjSettings = self.pjSettings;
    [BRLMUserDefaults sharedDefaults].mwSettings = self.mwSettings;
    [BRLMUserDefaults sharedDefaults].tdSettings = self.tdSettings;
    [BRLMUserDefaults sharedDefaults].rjSettings = self.rjSettings;
    
    [super viewWillDisappear:animated];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.properties.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    typedef UITableViewCell * (^MakeCellFunction)();
    
    MakeCellFunction textFieldCell = ^{
        NSString* title = self.properties[indexPath.row];
        NSString* cellIdentifier = @"BRLMPrintSettingRootViewController_textFieldCell";
        if ([title isEqualToString:@"BRLMCustomPaperSize"]) {
            cellIdentifier = @"BRLMPrintSettingRootViewController_customPaperCell";
        }
        if ([title isEqualToString:@"BRLMPJPrintSettingsPaperSize"]) {
            cellIdentifier = @"BRLMPrintSettingRootViewController_paperSizePJCell";
        }
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = [self shortenTitle:title];
        if (self.qlSettings) {
            if ([title isEqualToString:@"BRLMPrintSettingsScaleMode"]) {
                if (self.qlSettings.scaleMode == BRLMPrintSettingsScaleModeActualSize) {
                    cell.detailTextLabel.text = @"ActualSize";
                }
                if (self.qlSettings.scaleMode == BRLMPrintSettingsScaleModeFitPageAspect) {
                    cell.detailTextLabel.text = @"FitPageAspect";
                }
                if (self.qlSettings.scaleMode == BRLMPrintSettingsScaleModeFitPaperAspect) {
                    cell.detailTextLabel.text = @"FitPaperAspect";
                }
                if (self.qlSettings.scaleMode == BRLMPrintSettingsScaleModeScaleValue) {
                    cell.detailTextLabel.text = @"ScaleValue";
                }
            }
            if ([title isEqualToString:@"BRLMPrintSettingsScaleValue"]) {
                cell.detailTextLabel.text = [@(self.qlSettings.scaleValue) stringValue];
            }
            if ([title isEqualToString:@"BRLMPrintSettingsOrientation"]) {
                if (self.qlSettings.printOrientation == BRLMPrintSettingsOrientationPortrait) {
                    cell.detailTextLabel.text = @"Portrait";
                }
                if (self.qlSettings.printOrientation == BRLMPrintSettingsOrientationLandscape) {
                    cell.detailTextLabel.text = @"Landscape";
                }
            }
            if ([title isEqualToString:@"BRLMPrintSettingsRotation"]) {
                if (self.qlSettings.imageRotation == BRLMPrintSettingsRotationRotate0) {
                    cell.detailTextLabel.text = @"Rotate0";
                }
                if (self.qlSettings.imageRotation == BRLMPrintSettingsRotationRotate90) {
                    cell.detailTextLabel.text = @"Rotate90";
                }
                if (self.qlSettings.imageRotation == BRLMPrintSettingsRotationRotate180) {
                    cell.detailTextLabel.text = @"Rotate180";
                }
                if (self.qlSettings.imageRotation == BRLMPrintSettingsRotationRotate270) {
                    cell.detailTextLabel.text = @"Rotate270";
                }
            }
            if ([title isEqualToString:@"BRLMPrintSettingsHalftone"]) {
                if (self.qlSettings.halftone == BRLMPrintSettingsHalftoneThreshold) {
                    cell.detailTextLabel.text = @"Threshold";
                }
                if (self.qlSettings.halftone == BRLMPrintSettingsHalftoneErrorDiffusion) {
                    cell.detailTextLabel.text = @"ErrorDiffusion";
                }
                if (self.qlSettings.halftone == BRLMPrintSettingsHalftonePatternDither) {
                    cell.detailTextLabel.text = @"PatternDither";
                }
            }
            if ([title isEqualToString:@"BRLMPrintSettingsHorizontalAlignment"]) {
                if (self.qlSettings.hAlignment == BRLMPrintSettingsHorizontalAlignmentLeft) {
                    cell.detailTextLabel.text = @"Left";
                }
                if (self.qlSettings.hAlignment == BRLMPrintSettingsHorizontalAlignmentCenter) {
                    cell.detailTextLabel.text = @"Center";
                }
                if (self.qlSettings.hAlignment == BRLMPrintSettingsHorizontalAlignmentRight) {
                    cell.detailTextLabel.text = @"Right";
                }
            }
            if ([title isEqualToString:@"BRLMPrintSettingsVerticalAlignment"]) {
                if (self.qlSettings.vAlignment == BRLMPrintSettingsVerticalAlignmentTop) {
                    cell.detailTextLabel.text = @"Top";
                }
                if (self.qlSettings.vAlignment == BRLMPrintSettingsVerticalAlignmentCenter) {
                    cell.detailTextLabel.text = @"Center";
                }
                if (self.qlSettings.vAlignment == BRLMPrintSettingsVerticalAlignmentBottom) {
                    cell.detailTextLabel.text = @"Bottom";
                }
            }
            if ([title isEqualToString:@"BRLMPrintSettingsCompressMode"]) {
                if (self.qlSettings.compress == BRLMPrintSettingsCompressModeNone) {
                    cell.detailTextLabel.text = @"None";
                }
                if (self.qlSettings.compress == BRLMPrintSettingsCompressModeTiff) {
                    cell.detailTextLabel.text = @"Tiff";
                }
                if (self.qlSettings.compress == BRLMPrintSettingsCompressModeMode9) {
                    cell.detailTextLabel.text = @"Mode9";
                }
            }
            if ([title isEqualToString:@"BRLMPrintSettingsHalftoneThreshold"]) {
                cell.detailTextLabel.text = [@(self.qlSettings.halftoneThreshold) stringValue];
            }
            if ([title isEqualToString:@"BRLMPrintSettingsNumCopies"]) {
                cell.detailTextLabel.text = [@(self.qlSettings.numCopies) stringValue];
            }
            if ([title isEqualToString:@"BRLMPrintSettingsPrintQuality"]) {
                if (self.qlSettings.printQuality == BRLMPrintSettingsPrintQualityBest) {
                    cell.detailTextLabel.text = @"Best";
                }
                if (self.qlSettings.printQuality == BRLMPrintSettingsPrintQualityFast) {
                    cell.detailTextLabel.text = @"Fast";
                }
            }
            if ([title isEqualToString:@"BRLMQLPrintSettingsLabelSize"]) {
                if (self.qlSettings.labelSize == BRLMQLPrintSettingsLabelSizeDieCutW17H54) {
                    cell.detailTextLabel.text = @"DieCutW17H54";
                }
                if (self.qlSettings.labelSize == BRLMQLPrintSettingsLabelSizeDieCutW17H87) {
                    cell.detailTextLabel.text = @"DieCutW17H87";
                }
                if (self.qlSettings.labelSize == BRLMQLPrintSettingsLabelSizeDieCutW23H23) {
                    cell.detailTextLabel.text = @"DieCutW23H23";
                }
                if (self.qlSettings.labelSize == BRLMQLPrintSettingsLabelSizeDieCutW29H42) {
                    cell.detailTextLabel.text = @"DieCutW29H42";
                }
                if (self.qlSettings.labelSize == BRLMQLPrintSettingsLabelSizeDieCutW29H90) {
                    cell.detailTextLabel.text = @"DieCutW29H90";
                }
                if (self.qlSettings.labelSize == BRLMQLPrintSettingsLabelSizeDieCutW38H90) {
                    cell.detailTextLabel.text = @"DieCutW38H90";
                }
                if (self.qlSettings.labelSize == BRLMQLPrintSettingsLabelSizeDieCutW39H48) {
                    cell.detailTextLabel.text = @"DieCutW39H48";
                }
                if (self.qlSettings.labelSize == BRLMQLPrintSettingsLabelSizeDieCutW52H29) {
                    cell.detailTextLabel.text = @"DieCutW52H29";
                }
                if (self.qlSettings.labelSize == BRLMQLPrintSettingsLabelSizeDieCutW62H29) {
                    cell.detailTextLabel.text = @"DieCutW62H29";
                }
                if (self.qlSettings.labelSize == BRLMQLPrintSettingsLabelSizeDieCutW62H60) {
                    cell.detailTextLabel.text = @"DieCutW62H60";
                }
                if (self.qlSettings.labelSize == BRLMQLPrintSettingsLabelSizeDieCutW62H75) {
                    cell.detailTextLabel.text = @"DieCutW62H75";
                }
                if (self.qlSettings.labelSize == BRLMQLPrintSettingsLabelSizeDieCutW62H100) {
                    cell.detailTextLabel.text = @"DieCutW62H100";
                }
                if (self.qlSettings.labelSize == BRLMQLPrintSettingsLabelSizeDieCutW60H86) {
                    cell.detailTextLabel.text = @"DieCutW60H86";
                }
                if (self.qlSettings.labelSize == BRLMQLPrintSettingsLabelSizeDieCutW54H29) {
                    cell.detailTextLabel.text = @"DieCutW54H29";
                }
                if (self.qlSettings.labelSize == BRLMQLPrintSettingsLabelSizeDieCutW102H51) {
                    cell.detailTextLabel.text = @"DieCutW102H51";
                }
                if (self.qlSettings.labelSize == BRLMQLPrintSettingsLabelSizeDieCutW102H152) {
                    cell.detailTextLabel.text = @"DieCutW102H152";
                }
                if (self.qlSettings.labelSize == BRLMQLPrintSettingsLabelSizeDieCutW103H164) {
                    cell.detailTextLabel.text = @"DieCutW103H164";
                }
                if (self.qlSettings.labelSize == BRLMQLPrintSettingsLabelSizeRollW12) {
                    cell.detailTextLabel.text = @"RollW12";
                }
                if (self.qlSettings.labelSize == BRLMQLPrintSettingsLabelSizeRollW29) {
                    cell.detailTextLabel.text = @"RollW29";
                }
                if (self.qlSettings.labelSize == BRLMQLPrintSettingsLabelSizeRollW38) {
                    cell.detailTextLabel.text = @"RollW38";
                }
                if (self.qlSettings.labelSize == BRLMQLPrintSettingsLabelSizeRollW50) {
                    cell.detailTextLabel.text = @"RollW50";
                }
                if (self.qlSettings.labelSize == BRLMQLPrintSettingsLabelSizeRollW54) {
                    cell.detailTextLabel.text = @"RollW54";
                }
                if (self.qlSettings.labelSize == BRLMQLPrintSettingsLabelSizeRollW62) {
                    cell.detailTextLabel.text = @"RollW62";
                }
                if (self.qlSettings.labelSize == BRLMQLPrintSettingsLabelSizeRollW62RB) {
                    cell.detailTextLabel.text = @"RollW62RB";
                }
                if (self.qlSettings.labelSize == BRLMQLPrintSettingsLabelSizeRollW102) {
                    cell.detailTextLabel.text = @"RollW102";
                }
                if (self.qlSettings.labelSize == BRLMQLPrintSettingsLabelSizeRollW103) {
                    cell.detailTextLabel.text = @"RollW103";
                }
                if (self.qlSettings.labelSize == BRLMQLPrintSettingsLabelSizeDTRollW90) {
                    cell.detailTextLabel.text = @"DTRollW90";
                }
                if (self.qlSettings.labelSize == BRLMQLPrintSettingsLabelSizeDTRollW102) {
                    cell.detailTextLabel.text = @"DTRollW102";
                }
                if (self.qlSettings.labelSize == BRLMQLPrintSettingsLabelSizeDTRollW102H51) {
                    cell.detailTextLabel.text = @"DTRollW102H51";
                }
                if (self.qlSettings.labelSize == BRLMQLPrintSettingsLabelSizeDTRollW102H152) {
                    cell.detailTextLabel.text = @"DTRollW102H152";
                }
                if (self.qlSettings.labelSize == BRLMQLPrintSettingsLabelSizeRoundW12DIA) {
                    cell.detailTextLabel.text = @"RoundW12DIA";
                }
                if (self.qlSettings.labelSize == BRLMQLPrintSettingsLabelSizeRoundW24DIA) {
                    cell.detailTextLabel.text = @"RoundW24DIA";
                }
                if (self.qlSettings.labelSize == BRLMQLPrintSettingsLabelSizeRoundW58DIA) {
                    cell.detailTextLabel.text = @"RoundW58DIA";
                }
            }
            if ([title isEqualToString:@"BRLMPrintSettingsAutoCutForEachPageCount"]) {
                cell.detailTextLabel.text = [@(self.qlSettings.autoCutForEachPageCount) stringValue];
            }
            if ([title isEqualToString:@"BRLMPrintSettingsResolution"]) {
                if (self.qlSettings.resolution == BRLMPrintSettingsResolutionLow) {
                    cell.detailTextLabel.text = @"Low";
                }
                if (self.qlSettings.resolution == BRLMPrintSettingsResolutionNormal) {
                    cell.detailTextLabel.text = @"Normal";
                }
                if (self.qlSettings.resolution == BRLMPrintSettingsResolutionHigh) {
                    cell.detailTextLabel.text = @"High";
                }
            }
            if ([title isEqualToString:@"BRLMQLPrintSettingsBiColorRedEnhancement"]) {
                cell.detailTextLabel.text = [@(self.qlSettings.biColorRedEnhancement) stringValue];
            }
            if ([title isEqualToString:@"BRLMQLPrintSettingsBiColorGreenEnhancement"]) {
                cell.detailTextLabel.text = [@(self.qlSettings.biColorGreenEnhancement) stringValue];
            }
            if ([title isEqualToString:@"BRLMQLPrintSettingsBiColorBlueEnhancement"]) {
                cell.detailTextLabel.text = [@(self.qlSettings.biColorBlueEnhancement) stringValue];
            }
        }

        if (self.ptSettings) {
            if ([title isEqualToString:@"BRLMPrintSettingsScaleMode"]) {
                if (self.ptSettings.scaleMode == BRLMPrintSettingsScaleModeActualSize) {
                    cell.detailTextLabel.text = @"ActualSize";
                }
                if (self.ptSettings.scaleMode == BRLMPrintSettingsScaleModeFitPageAspect) {
                    cell.detailTextLabel.text = @"FitPageAspect";
                }
                if (self.ptSettings.scaleMode == BRLMPrintSettingsScaleModeFitPaperAspect) {
                    cell.detailTextLabel.text = @"FitPaperAspect";
                }
                if (self.ptSettings.scaleMode == BRLMPrintSettingsScaleModeScaleValue) {
                    cell.detailTextLabel.text = @"ScaleValue";
                }
            }
            if ([title isEqualToString:@"BRLMPrintSettingsScaleValue"]) {
                cell.detailTextLabel.text = [@(self.ptSettings.scaleValue) stringValue];
            }
            if ([title isEqualToString:@"BRLMPrintSettingsOrientation"]) {
                if (self.ptSettings.printOrientation == BRLMPrintSettingsOrientationPortrait) {
                    cell.detailTextLabel.text = @"Portrait";
                }
                if (self.ptSettings.printOrientation == BRLMPrintSettingsOrientationLandscape) {
                    cell.detailTextLabel.text = @"Landscape";
                }
            }
            if ([title isEqualToString:@"BRLMPrintSettingsRotation"]) {
                if (self.ptSettings.imageRotation == BRLMPrintSettingsRotationRotate0) {
                    cell.detailTextLabel.text = @"Rotate0";
                }
                if (self.ptSettings.imageRotation == BRLMPrintSettingsRotationRotate90) {
                    cell.detailTextLabel.text = @"Rotate90";
                }
                if (self.ptSettings.imageRotation == BRLMPrintSettingsRotationRotate180) {
                    cell.detailTextLabel.text = @"Rotate180";
                }
                if (self.ptSettings.imageRotation == BRLMPrintSettingsRotationRotate270) {
                    cell.detailTextLabel.text = @"Rotate270";
                }
            }
            if ([title isEqualToString:@"BRLMPrintSettingsHalftone"]) {
                if (self.ptSettings.halftone == BRLMPrintSettingsHalftoneThreshold) {
                    cell.detailTextLabel.text = @"Threshold";
                }
                if (self.ptSettings.halftone == BRLMPrintSettingsHalftoneErrorDiffusion) {
                    cell.detailTextLabel.text = @"ErrorDiffusion";
                }
                if (self.ptSettings.halftone == BRLMPrintSettingsHalftonePatternDither) {
                    cell.detailTextLabel.text = @"PatternDither";
                }
            }
            if ([title isEqualToString:@"BRLMPrintSettingsHorizontalAlignment"]) {
                if (self.ptSettings.hAlignment == BRLMPrintSettingsHorizontalAlignmentLeft) {
                    cell.detailTextLabel.text = @"Left";
                }
                if (self.ptSettings.hAlignment == BRLMPrintSettingsHorizontalAlignmentCenter) {
                    cell.detailTextLabel.text = @"Center";
                }
                if (self.ptSettings.hAlignment == BRLMPrintSettingsHorizontalAlignmentRight) {
                    cell.detailTextLabel.text = @"Right";
                }
            }
            if ([title isEqualToString:@"BRLMPrintSettingsVerticalAlignment"]) {
                if (self.ptSettings.vAlignment == BRLMPrintSettingsVerticalAlignmentTop) {
                    cell.detailTextLabel.text = @"Top";
                }
                if (self.ptSettings.vAlignment == BRLMPrintSettingsVerticalAlignmentCenter) {
                    cell.detailTextLabel.text = @"Center";
                }
                if (self.ptSettings.vAlignment == BRLMPrintSettingsVerticalAlignmentBottom) {
                    cell.detailTextLabel.text = @"Bottom";
                }
            }
            if ([title isEqualToString:@"BRLMPrintSettingsCompressMode"]) {
                if (self.ptSettings.compress == BRLMPrintSettingsCompressModeNone) {
                    cell.detailTextLabel.text = @"None";
                }
                if (self.ptSettings.compress == BRLMPrintSettingsCompressModeTiff) {
                    cell.detailTextLabel.text = @"Tiff";
                }
                if (self.ptSettings.compress == BRLMPrintSettingsCompressModeMode9) {
                    cell.detailTextLabel.text = @"Mode9";
                }
            }
            if ([title isEqualToString:@"BRLMPrintSettingsHalftoneThreshold"]) {
                cell.detailTextLabel.text = [@(self.ptSettings.halftoneThreshold) stringValue];
            }
            if ([title isEqualToString:@"BRLMPrintSettingsNumCopies"]) {
                cell.detailTextLabel.text = [@(self.ptSettings.numCopies) stringValue];
            }
            if ([title isEqualToString:@"BRLMPrintSettingsPrintQuality"]) {
                if (self.ptSettings.printQuality == BRLMPrintSettingsPrintQualityBest) {
                    cell.detailTextLabel.text = @"Best";
                }
                if (self.ptSettings.printQuality == BRLMPrintSettingsPrintQualityFast) {
                    cell.detailTextLabel.text = @"Fast";
                }
            }
            if ([title isEqualToString:@"BRLMPTPrintSettingsLabelSize"]) {
                if (self.ptSettings.labelSize == BRLMPTPrintSettingsLabelSizeWidth3_5mm) {
                    cell.detailTextLabel.text = @"Width3_5mm";
                }
                if (self.ptSettings.labelSize == BRLMPTPrintSettingsLabelSizeWidth6mm) {
                    cell.detailTextLabel.text = @"Width6mm";
                }
                if (self.ptSettings.labelSize == BRLMPTPrintSettingsLabelSizeWidth9mm) {
                    cell.detailTextLabel.text = @"Width9mm";
                }
                if (self.ptSettings.labelSize == BRLMPTPrintSettingsLabelSizeWidth12mm) {
                    cell.detailTextLabel.text = @"Width12mm";
                }
                if (self.ptSettings.labelSize == BRLMPTPrintSettingsLabelSizeWidth18mm) {
                    cell.detailTextLabel.text = @"Width18mm";
                }
                if (self.ptSettings.labelSize == BRLMPTPrintSettingsLabelSizeWidth24mm) {
                    cell.detailTextLabel.text = @"Width24mm";
                }
                if (self.ptSettings.labelSize == BRLMPTPrintSettingsLabelSizeWidth36mm) {
                    cell.detailTextLabel.text = @"Width36mm";
                }
                if (self.ptSettings.labelSize == BRLMPTPrintSettingsLabelSizeWidthHS_5_8mm) {
                    cell.detailTextLabel.text = @"WidthHS_5_8mm";
                }
                if (self.ptSettings.labelSize == BRLMPTPrintSettingsLabelSizeWidthHS_8_8mm) {
                    cell.detailTextLabel.text = @"WidthHS_8_8mm";
                }
                if (self.ptSettings.labelSize == BRLMPTPrintSettingsLabelSizeWidthHS_11_7mm) {
                    cell.detailTextLabel.text = @"WidthHS_11_7mm";
                }
                if (self.ptSettings.labelSize == BRLMPTPrintSettingsLabelSizeWidthHS_17_7mm) {
                    cell.detailTextLabel.text = @"WidthHS_17_7mm";
                }
                if (self.ptSettings.labelSize == BRLMPTPrintSettingsLabelSizeWidthHS_23_6mm) {
                    cell.detailTextLabel.text = @"WidthHS_23_6mm";
                }
                if (self.ptSettings.labelSize == BRLMPTPrintSettingsLabelSizeWidthFL_21x45mm) {
                    cell.detailTextLabel.text = @"WidthFL_21x45mm";
                }
                if (self.ptSettings.labelSize == BRLMPTPrintSettingsLabelSizeWidthHS_5_2mm) {
                    cell.detailTextLabel.text = @"WidthHS_5_2mm";
                }
                if (self.ptSettings.labelSize == BRLMPTPrintSettingsLabelSizeWidthHS_9_0mm) {
                    cell.detailTextLabel.text = @"WidthHS_9_0mm";
                }
                if (self.ptSettings.labelSize == BRLMPTPrintSettingsLabelSizeWidthHS_11_2mm) {
                    cell.detailTextLabel.text = @"WidthHS_11_2mm";
                }
                if (self.ptSettings.labelSize == BRLMPTPrintSettingsLabelSizeWidthHS_21_0mm) {
                    cell.detailTextLabel.text = @"WidthHS_21_0mm";
                }
                if (self.ptSettings.labelSize == BRLMPTPrintSettingsLabelSizeWidthHS_31_0mm) {
                    cell.detailTextLabel.text = @"WidthHS_31_0mm";
                }
            }
            if ([title isEqualToString:@"BRLMPrintSettingsResolution"]) {
                if (self.ptSettings.resolution == BRLMPrintSettingsResolutionLow) {
                    cell.detailTextLabel.text = @"Low";
                }
                if (self.ptSettings.resolution == BRLMPrintSettingsResolutionNormal) {
                    cell.detailTextLabel.text = @"Normal";
                }
                if (self.ptSettings.resolution == BRLMPrintSettingsResolutionHigh) {
                    cell.detailTextLabel.text = @"High";
                }
            }
            if ([title isEqualToString:@"BRLMPrintSettingsAutoCutForEachPageCount"]) {
                cell.detailTextLabel.text = [@(self.ptSettings.autoCutForEachPageCount) stringValue];
            }
        }

        if (self.pjSettings) {
            if ([title isEqualToString:@"BRLMPrintSettingsScaleMode"]) {
                if (self.pjSettings.scaleMode == BRLMPrintSettingsScaleModeActualSize) {
                    cell.detailTextLabel.text = @"ActualSize";
                }
                if (self.pjSettings.scaleMode == BRLMPrintSettingsScaleModeFitPageAspect) {
                    cell.detailTextLabel.text = @"FitPageAspect";
                }
                if (self.pjSettings.scaleMode == BRLMPrintSettingsScaleModeFitPaperAspect) {
                    cell.detailTextLabel.text = @"FitPaperAspect";
                }
                if (self.pjSettings.scaleMode == BRLMPrintSettingsScaleModeScaleValue) {
                    cell.detailTextLabel.text = @"ScaleValue";
                }
            }
            if ([title isEqualToString:@"BRLMPrintSettingsScaleValue"]) {
                cell.detailTextLabel.text = [@(self.pjSettings.scaleValue) stringValue];
            }
            if ([title isEqualToString:@"BRLMPrintSettingsOrientation"]) {
                if (self.pjSettings.printOrientation == BRLMPrintSettingsOrientationPortrait) {
                    cell.detailTextLabel.text = @"Portrait";
                }
                if (self.pjSettings.printOrientation == BRLMPrintSettingsOrientationLandscape) {
                    cell.detailTextLabel.text = @"Landscape";
                }
            }
            if ([title isEqualToString:@"BRLMPrintSettingsRotation"]) {
                if (self.pjSettings.imageRotation == BRLMPrintSettingsRotationRotate0) {
                    cell.detailTextLabel.text = @"Rotate0";
                }
                if (self.pjSettings.imageRotation == BRLMPrintSettingsRotationRotate90) {
                    cell.detailTextLabel.text = @"Rotate90";
                }
                if (self.pjSettings.imageRotation == BRLMPrintSettingsRotationRotate180) {
                    cell.detailTextLabel.text = @"Rotate180";
                }
                if (self.pjSettings.imageRotation == BRLMPrintSettingsRotationRotate270) {
                    cell.detailTextLabel.text = @"Rotate270";
                }
            }
            if ([title isEqualToString:@"BRLMPrintSettingsHalftone"]) {
                if (self.pjSettings.halftone == BRLMPrintSettingsHalftoneThreshold) {
                    cell.detailTextLabel.text = @"Threshold";
                }
                if (self.pjSettings.halftone == BRLMPrintSettingsHalftoneErrorDiffusion) {
                    cell.detailTextLabel.text = @"ErrorDiffusion";
                }
                if (self.pjSettings.halftone == BRLMPrintSettingsHalftonePatternDither) {
                    cell.detailTextLabel.text = @"PatternDither";
                }
            }
            if ([title isEqualToString:@"BRLMPrintSettingsHorizontalAlignment"]) {
                if (self.pjSettings.hAlignment == BRLMPrintSettingsHorizontalAlignmentLeft) {
                    cell.detailTextLabel.text = @"Left";
                }
                if (self.pjSettings.hAlignment == BRLMPrintSettingsHorizontalAlignmentCenter) {
                    cell.detailTextLabel.text = @"Center";
                }
                if (self.pjSettings.hAlignment == BRLMPrintSettingsHorizontalAlignmentRight) {
                    cell.detailTextLabel.text = @"Right";
                }
            }
            if ([title isEqualToString:@"BRLMPrintSettingsVerticalAlignment"]) {
                if (self.pjSettings.vAlignment == BRLMPrintSettingsVerticalAlignmentTop) {
                    cell.detailTextLabel.text = @"Top";
                }
                if (self.pjSettings.vAlignment == BRLMPrintSettingsVerticalAlignmentCenter) {
                    cell.detailTextLabel.text = @"Center";
                }
                if (self.pjSettings.vAlignment == BRLMPrintSettingsVerticalAlignmentBottom) {
                    cell.detailTextLabel.text = @"Bottom";
                }
            }
            if ([title isEqualToString:@"BRLMPrintSettingsCompressMode"]) {
                if (self.pjSettings.compress == BRLMPrintSettingsCompressModeNone) {
                    cell.detailTextLabel.text = @"None";
                }
                if (self.pjSettings.compress == BRLMPrintSettingsCompressModeTiff) {
                    cell.detailTextLabel.text = @"Tiff";
                }
                if (self.pjSettings.compress == BRLMPrintSettingsCompressModeMode9) {
                    cell.detailTextLabel.text = @"Mode9";
                }
            }
            if ([title isEqualToString:@"BRLMPrintSettingsHalftoneThreshold"]) {
                cell.detailTextLabel.text = [@(self.pjSettings.halftoneThreshold) stringValue];
            }
            if ([title isEqualToString:@"BRLMPrintSettingsNumCopies"]) {
                cell.detailTextLabel.text = [@(self.pjSettings.numCopies) stringValue];
            }
            if ([title isEqualToString:@"BRLMPrintSettingsPrintQuality"]) {
                if (self.pjSettings.printQuality == BRLMPrintSettingsPrintQualityBest) {
                    cell.detailTextLabel.text = @"Best";
                }
                if (self.pjSettings.printQuality == BRLMPrintSettingsPrintQualityFast) {
                    cell.detailTextLabel.text = @"Fast";
                }
            }
            if ([title isEqualToString:@"BRLMPJPrintSettingsPaperSize"]) {
                cell.detailTextLabel.text = @"";
            }
            if ([title isEqualToString:@"BRLMPJPrintSettingsPaperType"]) {
                if (self.pjSettings.paperType == BRLMPJPrintSettingsPaperTypeRoll) {
                    cell.detailTextLabel.text = @"Roll";
                }
                if (self.pjSettings.paperType == BRLMPJPrintSettingsPaperTypeCutSheet) {
                    cell.detailTextLabel.text = @"CutSheet";
                }
                if (self.pjSettings.paperType == BRLMPJPrintSettingsPaperTypePerforatedRoll) {
                    cell.detailTextLabel.text = @"PerforatedRoll";
                }
            }
            if ([title isEqualToString:@"BRLMPJPrintSettingsPaperInsertionPosition"]) {
                if (self.pjSettings.paperInsertionPosition == BRLMPJPrintSettingsPaperInsertionPositionLeft) {
                    cell.detailTextLabel.text = @"Left";
                }
                if (self.pjSettings.paperInsertionPosition == BRLMPJPrintSettingsPaperInsertionPositionCenter) {
                    cell.detailTextLabel.text = @"Center";
                }
                if (self.pjSettings.paperInsertionPosition == BRLMPJPrintSettingsPaperInsertionPositionRight) {
                    cell.detailTextLabel.text = @"Right";
                }
            }
            if ([title isEqualToString:@"BRLMPJPrintSettingsFeedMode"]) {
                if (self.pjSettings.feedMode == BRLMPJPrintSettingsFeedModeNoFeed) {
                    cell.detailTextLabel.text = @"NoFeed";
                }
                if (self.pjSettings.feedMode == BRLMPJPrintSettingsFeedModeFixedPage) {
                    cell.detailTextLabel.text = @"FixedPage";
                }
                if (self.pjSettings.feedMode == BRLMPJPrintSettingsFeedModeEndOfPage) {
                    cell.detailTextLabel.text = @"EndOfPage";
                }
                if (self.pjSettings.feedMode == BRLMPJPrintSettingsFeedModeEndOfPageRetract) {
                    cell.detailTextLabel.text = @"EndOfPageRetract";
                }
            }
            if ([title isEqualToString:@"BRLMPJPrintSettingsExtraFeedDots"]) {
                cell.detailTextLabel.text = [@(self.pjSettings.extraFeedDots) stringValue];
            }
            if ([title isEqualToString:@"BRLMPJPrintSettingsDensity"]) {
                if (self.pjSettings.density == BRLMPJPrintSettingsDensityWeakLevel5) {
                    cell.detailTextLabel.text = @"WeakLevel5";
                }
                if (self.pjSettings.density == BRLMPJPrintSettingsDensityWeakLevel4) {
                    cell.detailTextLabel.text = @"WeakLevel4";
                }
                if (self.pjSettings.density == BRLMPJPrintSettingsDensityWeakLevel3) {
                    cell.detailTextLabel.text = @"WeakLevel3";
                }
                if (self.pjSettings.density == BRLMPJPrintSettingsDensityWeakLevel2) {
                    cell.detailTextLabel.text = @"WeakLevel2";
                }
                if (self.pjSettings.density == BRLMPJPrintSettingsDensityWeakLevel1) {
                    cell.detailTextLabel.text = @"WeakLevel1";
                }
                if (self.pjSettings.density == BRLMPJPrintSettingsDensityNeutral) {
                    cell.detailTextLabel.text = @"Neutral";
                }
                if (self.pjSettings.density == BRLMPJPrintSettingsDensityStrongLevel1) {
                    cell.detailTextLabel.text = @"StrongLevel1";
                }
                if (self.pjSettings.density == BRLMPJPrintSettingsDensityStrongLevel2) {
                    cell.detailTextLabel.text = @"StrongLevel2";
                }
                if (self.pjSettings.density == BRLMPJPrintSettingsDensityStrongLevel3) {
                    cell.detailTextLabel.text = @"StrongLevel3";
                }
                if (self.pjSettings.density == BRLMPJPrintSettingsDensityStrongLevel4) {
                    cell.detailTextLabel.text = @"StrongLevel4";
                }
                if (self.pjSettings.density == BRLMPJPrintSettingsDensityStrongLevel5) {
                    cell.detailTextLabel.text = @"StrongLevel5";
                }
                if (self.pjSettings.density == BRLMPJPrintSettingsDensityUsePrinterSetting) {
                    cell.detailTextLabel.text = @"UsePrinterSetting";
                }
            }
            if ([title isEqualToString:@"BRLMPJPrintSettingsRollCase"]) {
                if (self.pjSettings.rollCase == BRLMPJPrintSettingsRollCaseNone) {
                    cell.detailTextLabel.text = @"None";
                }
                if (self.pjSettings.rollCase == BRLMPJPrintSettingsRollCasePARC001_NoAntiCurl) {
                    cell.detailTextLabel.text = @"PARC001_NoAntiCurl";
                }
                if (self.pjSettings.rollCase == BRLMPJPrintSettingsRollCasePARC001) {
                    cell.detailTextLabel.text = @"PARC001";
                }
                if (self.pjSettings.rollCase == BRLMPJPrintSettingsRollCasePARC001_ShortFeed) {
                    cell.detailTextLabel.text = @"PARC001_ShortFeed";
                }
                if (self.pjSettings.rollCase == BRLMPJPrintSettingsRollCaseKeepPrinterSetting) {
                    cell.detailTextLabel.text = @"KeepPrinterSetting";
                }
            }
            if ([title isEqualToString:@"BRLMPJPrintSettingsPrintSpeed"]) {
                if (self.pjSettings.printSpeed == BRLMPJPrintSettingsPrintSpeedHighSpeed) {
                    cell.detailTextLabel.text = @"HighSpeed";
                }
                if (self.pjSettings.printSpeed == BRLMPJPrintSettingsPrintSpeedMediumHighSpeed) {
                    cell.detailTextLabel.text = @"MediumHighSpeed";
                }
                if (self.pjSettings.printSpeed == BRLMPJPrintSettingsPrintSpeedMediumLowSpeed) {
                    cell.detailTextLabel.text = @"MediumLowSpeed";
                }
                if (self.pjSettings.printSpeed == BRLMPJPrintSettingsPrintSpeedLowSpeed) {
                    cell.detailTextLabel.text = @"LowSpeed";
                }
                if (self.pjSettings.printSpeed == BRLMPJPrintSettingsPrintSpeedFast_DraftQuality) {
                    cell.detailTextLabel.text = @"Fast_DraftQuality";
                }
                if (self.pjSettings.printSpeed == BRLMPJPrintSettingsPrintSpeedFast_LineConversion) {
                    cell.detailTextLabel.text = @"Fast_LineConversion";
                }
                if (self.pjSettings.printSpeed == BRLMPJPrintSettingsPrintSpeedUsePrinterSetting) {
                    cell.detailTextLabel.text = @"UsePrinterSetting";
                }
                if (self.pjSettings.printSpeed == BRLMPJPrintSettingsPrintSpeed2_5inchPerSec) {
                    cell.detailTextLabel.text = @"2_5inchPerSec";
                }
                if (self.pjSettings.printSpeed == BRLMPJPrintSettingsPrintSpeed1_9inchPerSec) {
                    cell.detailTextLabel.text = @"1_9inchPerSec";
                }
                if (self.pjSettings.printSpeed == BRLMPJPrintSettingsPrintSpeed1_6inchPerSec) {
                    cell.detailTextLabel.text = @"1_6inchPerSec";
                }
                if (self.pjSettings.printSpeed == BRLMPJPrintSettingsPrintSpeed1_1inchPerSec) {
                    cell.detailTextLabel.text = @"1_1inchPerSec";
                }
            }
            if ([title isEqualToString:@"BRLMPJPrintSettingsForceStretchPrintableArea"]) {
                cell.detailTextLabel.text = [@(self.pjSettings.forceStretchPrintableArea) stringValue];
            }
        }

        if (self.mwSettings) {
            if ([title isEqualToString:@"BRLMPrintSettingsScaleMode"]) {
                if (self.mwSettings.scaleMode == BRLMPrintSettingsScaleModeActualSize) {
                    cell.detailTextLabel.text = @"ActualSize";
                }
                if (self.mwSettings.scaleMode == BRLMPrintSettingsScaleModeFitPageAspect) {
                    cell.detailTextLabel.text = @"FitPageAspect";
                }
                if (self.mwSettings.scaleMode == BRLMPrintSettingsScaleModeFitPaperAspect) {
                    cell.detailTextLabel.text = @"FitPaperAspect";
                }
                if (self.mwSettings.scaleMode == BRLMPrintSettingsScaleModeScaleValue) {
                    cell.detailTextLabel.text = @"ScaleValue";
                }
            }
            if ([title isEqualToString:@"BRLMPrintSettingsScaleValue"]) {
                cell.detailTextLabel.text = [@(self.mwSettings.scaleValue) stringValue];
            }
            if ([title isEqualToString:@"BRLMPrintSettingsOrientation"]) {
                if (self.mwSettings.printOrientation == BRLMPrintSettingsOrientationPortrait) {
                    cell.detailTextLabel.text = @"Portrait";
                }
                if (self.mwSettings.printOrientation == BRLMPrintSettingsOrientationLandscape) {
                    cell.detailTextLabel.text = @"Landscape";
                }
            }
            if ([title isEqualToString:@"BRLMPrintSettingsRotation"]) {
                if (self.mwSettings.imageRotation == BRLMPrintSettingsRotationRotate0) {
                    cell.detailTextLabel.text = @"Rotate0";
                }
                if (self.mwSettings.imageRotation == BRLMPrintSettingsRotationRotate90) {
                    cell.detailTextLabel.text = @"Rotate90";
                }
                if (self.mwSettings.imageRotation == BRLMPrintSettingsRotationRotate180) {
                    cell.detailTextLabel.text = @"Rotate180";
                }
                if (self.mwSettings.imageRotation == BRLMPrintSettingsRotationRotate270) {
                    cell.detailTextLabel.text = @"Rotate270";
                }
            }
            if ([title isEqualToString:@"BRLMPrintSettingsHalftone"]) {
                if (self.mwSettings.halftone == BRLMPrintSettingsHalftoneThreshold) {
                    cell.detailTextLabel.text = @"Threshold";
                }
                if (self.mwSettings.halftone == BRLMPrintSettingsHalftoneErrorDiffusion) {
                    cell.detailTextLabel.text = @"ErrorDiffusion";
                }
                if (self.mwSettings.halftone == BRLMPrintSettingsHalftonePatternDither) {
                    cell.detailTextLabel.text = @"PatternDither";
                }
            }
            if ([title isEqualToString:@"BRLMPrintSettingsHorizontalAlignment"]) {
                if (self.mwSettings.hAlignment == BRLMPrintSettingsHorizontalAlignmentLeft) {
                    cell.detailTextLabel.text = @"Left";
                }
                if (self.mwSettings.hAlignment == BRLMPrintSettingsHorizontalAlignmentCenter) {
                    cell.detailTextLabel.text = @"Center";
                }
                if (self.mwSettings.hAlignment == BRLMPrintSettingsHorizontalAlignmentRight) {
                    cell.detailTextLabel.text = @"Right";
                }
            }
            if ([title isEqualToString:@"BRLMPrintSettingsVerticalAlignment"]) {
                if (self.mwSettings.vAlignment == BRLMPrintSettingsVerticalAlignmentTop) {
                    cell.detailTextLabel.text = @"Top";
                }
                if (self.mwSettings.vAlignment == BRLMPrintSettingsVerticalAlignmentCenter) {
                    cell.detailTextLabel.text = @"Center";
                }
                if (self.mwSettings.vAlignment == BRLMPrintSettingsVerticalAlignmentBottom) {
                    cell.detailTextLabel.text = @"Bottom";
                }
            }
            if ([title isEqualToString:@"BRLMPrintSettingsCompressMode"]) {
                if (self.mwSettings.compress == BRLMPrintSettingsCompressModeNone) {
                    cell.detailTextLabel.text = @"None";
                }
                if (self.mwSettings.compress == BRLMPrintSettingsCompressModeTiff) {
                    cell.detailTextLabel.text = @"Tiff";
                }
                if (self.mwSettings.compress == BRLMPrintSettingsCompressModeMode9) {
                    cell.detailTextLabel.text = @"Mode9";
                }
            }
            if ([title isEqualToString:@"BRLMPrintSettingsHalftoneThreshold"]) {
                cell.detailTextLabel.text = [@(self.mwSettings.halftoneThreshold) stringValue];
            }
            if ([title isEqualToString:@"BRLMPrintSettingsNumCopies"]) {
                cell.detailTextLabel.text = [@(self.mwSettings.numCopies) stringValue];
            }
            if ([title isEqualToString:@"BRLMPrintSettingsPrintQuality"]) {
                if (self.mwSettings.printQuality == BRLMPrintSettingsPrintQualityBest) {
                    cell.detailTextLabel.text = @"Best";
                }
                if (self.mwSettings.printQuality == BRLMPrintSettingsPrintQualityFast) {
                    cell.detailTextLabel.text = @"Fast";
                }
            }
            if ([title isEqualToString:@"BRLMMWPrintSettingsPaperSize"]) {
                if (self.mwSettings.paperSize == BRLMMWPrintSettingsPaperSizeA6) {
                    cell.detailTextLabel.text = @"A6";
                }
                if (self.mwSettings.paperSize == BRLMMWPrintSettingsPaperSizeA7) {
                    cell.detailTextLabel.text = @"A7";
                }
            }
        }

        if (self.tdSettings) {
            if ([title isEqualToString:@"BRLMPrintSettingsScaleMode"]) {
                if (self.tdSettings.scaleMode == BRLMPrintSettingsScaleModeActualSize) {
                    cell.detailTextLabel.text = @"ActualSize";
                }
                if (self.tdSettings.scaleMode == BRLMPrintSettingsScaleModeFitPageAspect) {
                    cell.detailTextLabel.text = @"FitPageAspect";
                }
                if (self.tdSettings.scaleMode == BRLMPrintSettingsScaleModeFitPaperAspect) {
                    cell.detailTextLabel.text = @"FitPaperAspect";
                }
                if (self.tdSettings.scaleMode == BRLMPrintSettingsScaleModeScaleValue) {
                    cell.detailTextLabel.text = @"ScaleValue";
                }
            }
            if ([title isEqualToString:@"BRLMPrintSettingsScaleValue"]) {
                cell.detailTextLabel.text = [@(self.tdSettings.scaleValue) stringValue];
            }
            if ([title isEqualToString:@"BRLMPrintSettingsOrientation"]) {
                if (self.tdSettings.printOrientation == BRLMPrintSettingsOrientationPortrait) {
                    cell.detailTextLabel.text = @"Portrait";
                }
                if (self.tdSettings.printOrientation == BRLMPrintSettingsOrientationLandscape) {
                    cell.detailTextLabel.text = @"Landscape";
                }
            }
            if ([title isEqualToString:@"BRLMPrintSettingsRotation"]) {
                if (self.tdSettings.imageRotation == BRLMPrintSettingsRotationRotate0) {
                    cell.detailTextLabel.text = @"Rotate0";
                }
                if (self.tdSettings.imageRotation == BRLMPrintSettingsRotationRotate90) {
                    cell.detailTextLabel.text = @"Rotate90";
                }
                if (self.tdSettings.imageRotation == BRLMPrintSettingsRotationRotate180) {
                    cell.detailTextLabel.text = @"Rotate180";
                }
                if (self.tdSettings.imageRotation == BRLMPrintSettingsRotationRotate270) {
                    cell.detailTextLabel.text = @"Rotate270";
                }
            }
            if ([title isEqualToString:@"BRLMPrintSettingsHalftone"]) {
                if (self.tdSettings.halftone == BRLMPrintSettingsHalftoneThreshold) {
                    cell.detailTextLabel.text = @"Threshold";
                }
                if (self.tdSettings.halftone == BRLMPrintSettingsHalftoneErrorDiffusion) {
                    cell.detailTextLabel.text = @"ErrorDiffusion";
                }
                if (self.tdSettings.halftone == BRLMPrintSettingsHalftonePatternDither) {
                    cell.detailTextLabel.text = @"PatternDither";
                }
            }
            if ([title isEqualToString:@"BRLMPrintSettingsHorizontalAlignment"]) {
                if (self.tdSettings.hAlignment == BRLMPrintSettingsHorizontalAlignmentLeft) {
                    cell.detailTextLabel.text = @"Left";
                }
                if (self.tdSettings.hAlignment == BRLMPrintSettingsHorizontalAlignmentCenter) {
                    cell.detailTextLabel.text = @"Center";
                }
                if (self.tdSettings.hAlignment == BRLMPrintSettingsHorizontalAlignmentRight) {
                    cell.detailTextLabel.text = @"Right";
                }
            }
            if ([title isEqualToString:@"BRLMPrintSettingsVerticalAlignment"]) {
                if (self.tdSettings.vAlignment == BRLMPrintSettingsVerticalAlignmentTop) {
                    cell.detailTextLabel.text = @"Top";
                }
                if (self.tdSettings.vAlignment == BRLMPrintSettingsVerticalAlignmentCenter) {
                    cell.detailTextLabel.text = @"Center";
                }
                if (self.tdSettings.vAlignment == BRLMPrintSettingsVerticalAlignmentBottom) {
                    cell.detailTextLabel.text = @"Bottom";
                }
            }
            if ([title isEqualToString:@"BRLMPrintSettingsCompressMode"]) {
                if (self.tdSettings.compress == BRLMPrintSettingsCompressModeNone) {
                    cell.detailTextLabel.text = @"None";
                }
                if (self.tdSettings.compress == BRLMPrintSettingsCompressModeTiff) {
                    cell.detailTextLabel.text = @"Tiff";
                }
                if (self.tdSettings.compress == BRLMPrintSettingsCompressModeMode9) {
                    cell.detailTextLabel.text = @"Mode9";
                }
            }
            if ([title isEqualToString:@"BRLMPrintSettingsHalftoneThreshold"]) {
                cell.detailTextLabel.text = [@(self.tdSettings.halftoneThreshold) stringValue];
            }
            if ([title isEqualToString:@"BRLMPrintSettingsNumCopies"]) {
                cell.detailTextLabel.text = [@(self.tdSettings.numCopies) stringValue];
            }
            if ([title isEqualToString:@"BRLMPrintSettingsPrintQuality"]) {
                if (self.tdSettings.printQuality == BRLMPrintSettingsPrintQualityBest) {
                    cell.detailTextLabel.text = @"Best";
                }
                if (self.tdSettings.printQuality == BRLMPrintSettingsPrintQualityFast) {
                    cell.detailTextLabel.text = @"Fast";
                }
            }
            if ([title isEqualToString:@"BRLMCustomPaperSize"]) {
                cell.detailTextLabel.text = @"";
            }
            if ([title isEqualToString:@"BRLMTDPrintSettingsDensity"]) {
                if (self.tdSettings.density == BRLMTDPrintSettingsDensityWeakLevel5) {
                    cell.detailTextLabel.text = @"WeakLevel5";
                }
                if (self.tdSettings.density == BRLMTDPrintSettingsDensityWeakLevel4) {
                    cell.detailTextLabel.text = @"WeakLevel4";
                }
                if (self.tdSettings.density == BRLMTDPrintSettingsDensityWeakLevel3) {
                    cell.detailTextLabel.text = @"WeakLevel3";
                }
                if (self.tdSettings.density == BRLMTDPrintSettingsDensityWeakLevel2) {
                    cell.detailTextLabel.text = @"WeakLevel2";
                }
                if (self.tdSettings.density == BRLMTDPrintSettingsDensityWeakLevel1) {
                    cell.detailTextLabel.text = @"WeakLevel1";
                }
                if (self.tdSettings.density == BRLMTDPrintSettingsDensityNeutral) {
                    cell.detailTextLabel.text = @"Neutral";
                }
                if (self.tdSettings.density == BRLMTDPrintSettingsDensityStrongLevel1) {
                    cell.detailTextLabel.text = @"StrongLevel1";
                }
                if (self.tdSettings.density == BRLMTDPrintSettingsDensityStrongLevel2) {
                    cell.detailTextLabel.text = @"StrongLevel2";
                }
                if (self.tdSettings.density == BRLMTDPrintSettingsDensityStrongLevel3) {
                    cell.detailTextLabel.text = @"StrongLevel3";
                }
                if (self.tdSettings.density == BRLMTDPrintSettingsDensityStrongLevel4) {
                    cell.detailTextLabel.text = @"StrongLevel4";
                }
                if (self.tdSettings.density == BRLMTDPrintSettingsDensityStrongLevel5) {
                    cell.detailTextLabel.text = @"StrongLevel5";
                }
                if (self.tdSettings.density == BRLMTDPrintSettingsDensityUsePrinterSetting) {
                    cell.detailTextLabel.text = @"UsePrinterSetting";
                }
            }
            if ([title isEqualToString:@"BRLMPrintSettingsAutoCutForEachPageCount"]) {
                cell.detailTextLabel.text = [@(self.tdSettings.autoCutForEachPageCount) stringValue];
            }
        }

        if (self.rjSettings) {
            if ([title isEqualToString:@"BRLMPrintSettingsScaleMode"]) {
                if (self.rjSettings.scaleMode == BRLMPrintSettingsScaleModeActualSize) {
                    cell.detailTextLabel.text = @"ActualSize";
                }
                if (self.rjSettings.scaleMode == BRLMPrintSettingsScaleModeFitPageAspect) {
                    cell.detailTextLabel.text = @"FitPageAspect";
                }
                if (self.rjSettings.scaleMode == BRLMPrintSettingsScaleModeFitPaperAspect) {
                    cell.detailTextLabel.text = @"FitPaperAspect";
                }
                if (self.rjSettings.scaleMode == BRLMPrintSettingsScaleModeScaleValue) {
                    cell.detailTextLabel.text = @"ScaleValue";
                }
            }
            if ([title isEqualToString:@"BRLMPrintSettingsScaleValue"]) {
                cell.detailTextLabel.text = [@(self.rjSettings.scaleValue) stringValue];
            }
            if ([title isEqualToString:@"BRLMPrintSettingsOrientation"]) {
                if (self.rjSettings.printOrientation == BRLMPrintSettingsOrientationPortrait) {
                    cell.detailTextLabel.text = @"Portrait";
                }
                if (self.rjSettings.printOrientation == BRLMPrintSettingsOrientationLandscape) {
                    cell.detailTextLabel.text = @"Landscape";
                }
            }
            if ([title isEqualToString:@"BRLMPrintSettingsRotation"]) {
                if (self.rjSettings.imageRotation == BRLMPrintSettingsRotationRotate0) {
                    cell.detailTextLabel.text = @"Rotate0";
                }
                if (self.rjSettings.imageRotation == BRLMPrintSettingsRotationRotate90) {
                    cell.detailTextLabel.text = @"Rotate90";
                }
                if (self.rjSettings.imageRotation == BRLMPrintSettingsRotationRotate180) {
                    cell.detailTextLabel.text = @"Rotate180";
                }
                if (self.rjSettings.imageRotation == BRLMPrintSettingsRotationRotate270) {
                    cell.detailTextLabel.text = @"Rotate270";
                }
            }
            if ([title isEqualToString:@"BRLMPrintSettingsHalftone"]) {
                if (self.rjSettings.halftone == BRLMPrintSettingsHalftoneThreshold) {
                    cell.detailTextLabel.text = @"Threshold";
                }
                if (self.rjSettings.halftone == BRLMPrintSettingsHalftoneErrorDiffusion) {
                    cell.detailTextLabel.text = @"ErrorDiffusion";
                }
                if (self.rjSettings.halftone == BRLMPrintSettingsHalftonePatternDither) {
                    cell.detailTextLabel.text = @"PatternDither";
                }
            }
            if ([title isEqualToString:@"BRLMPrintSettingsHorizontalAlignment"]) {
                if (self.rjSettings.hAlignment == BRLMPrintSettingsHorizontalAlignmentLeft) {
                    cell.detailTextLabel.text = @"Left";
                }
                if (self.rjSettings.hAlignment == BRLMPrintSettingsHorizontalAlignmentCenter) {
                    cell.detailTextLabel.text = @"Center";
                }
                if (self.rjSettings.hAlignment == BRLMPrintSettingsHorizontalAlignmentRight) {
                    cell.detailTextLabel.text = @"Right";
                }
            }
            if ([title isEqualToString:@"BRLMPrintSettingsVerticalAlignment"]) {
                if (self.rjSettings.vAlignment == BRLMPrintSettingsVerticalAlignmentTop) {
                    cell.detailTextLabel.text = @"Top";
                }
                if (self.rjSettings.vAlignment == BRLMPrintSettingsVerticalAlignmentCenter) {
                    cell.detailTextLabel.text = @"Center";
                }
                if (self.rjSettings.vAlignment == BRLMPrintSettingsVerticalAlignmentBottom) {
                    cell.detailTextLabel.text = @"Bottom";
                }
            }
            if ([title isEqualToString:@"BRLMPrintSettingsCompressMode"]) {
                if (self.rjSettings.compress == BRLMPrintSettingsCompressModeNone) {
                    cell.detailTextLabel.text = @"None";
                }
                if (self.rjSettings.compress == BRLMPrintSettingsCompressModeTiff) {
                    cell.detailTextLabel.text = @"Tiff";
                }
                if (self.rjSettings.compress == BRLMPrintSettingsCompressModeMode9) {
                    cell.detailTextLabel.text = @"Mode9";
                }
            }
            if ([title isEqualToString:@"BRLMPrintSettingsHalftoneThreshold"]) {
                cell.detailTextLabel.text = [@(self.rjSettings.halftoneThreshold) stringValue];
            }
            if ([title isEqualToString:@"BRLMPrintSettingsNumCopies"]) {
                cell.detailTextLabel.text = [@(self.rjSettings.numCopies) stringValue];
            }
            if ([title isEqualToString:@"BRLMPrintSettingsPrintQuality"]) {
                if (self.rjSettings.printQuality == BRLMPrintSettingsPrintQualityBest) {
                    cell.detailTextLabel.text = @"Best";
                }
                if (self.rjSettings.printQuality == BRLMPrintSettingsPrintQualityFast) {
                    cell.detailTextLabel.text = @"Fast";
                }
            }
            if ([title isEqualToString:@"BRLMCustomPaperSize"]) {
                cell.detailTextLabel.text = @"";
            }
            if ([title isEqualToString:@"BRLMRJPrintSettingsDensity"]) {
                if (self.rjSettings.density == BRLMRJPrintSettingsDensityWeakLevel5) {
                    cell.detailTextLabel.text = @"WeakLevel5";
                }
                if (self.rjSettings.density == BRLMRJPrintSettingsDensityWeakLevel4) {
                    cell.detailTextLabel.text = @"WeakLevel4";
                }
                if (self.rjSettings.density == BRLMRJPrintSettingsDensityWeakLevel3) {
                    cell.detailTextLabel.text = @"WeakLevel3";
                }
                if (self.rjSettings.density == BRLMRJPrintSettingsDensityWeakLevel2) {
                    cell.detailTextLabel.text = @"WeakLevel2";
                }
                if (self.rjSettings.density == BRLMRJPrintSettingsDensityWeakLevel1) {
                    cell.detailTextLabel.text = @"WeakLevel1";
                }
                if (self.rjSettings.density == BRLMRJPrintSettingsDensityNeutral) {
                    cell.detailTextLabel.text = @"Neutral";
                }
                if (self.rjSettings.density == BRLMRJPrintSettingsDensityStrongLevel1) {
                    cell.detailTextLabel.text = @"StrongLevel1";
                }
                if (self.rjSettings.density == BRLMRJPrintSettingsDensityStrongLevel2) {
                    cell.detailTextLabel.text = @"StrongLevel2";
                }
                if (self.rjSettings.density == BRLMRJPrintSettingsDensityStrongLevel3) {
                    cell.detailTextLabel.text = @"StrongLevel3";
                }
                if (self.rjSettings.density == BRLMRJPrintSettingsDensityStrongLevel4) {
                    cell.detailTextLabel.text = @"StrongLevel4";
                }
                if (self.rjSettings.density == BRLMRJPrintSettingsDensityStrongLevel5) {
                    cell.detailTextLabel.text = @"StrongLevel5";
                }
                if (self.rjSettings.density == BRLMRJPrintSettingsDensityUsePrinterSetting) {
                    cell.detailTextLabel.text = @"UsePrinterSetting";
                }
            }
        }

        return cell;
    };
    
    MakeCellFunction switchCell = ^{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BRLMPrintSettingRootViewController_switchCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BRLMPrintSettingRootViewController_switchCell"];

        }
        
        cell.accessoryView = [[UISwitch alloc] init];

        NSString* title = self.properties[indexPath.row];
        cell.textLabel.text = [self shortenTitle:title];
        UISwitch* switchView = (UISwitch*)cell.accessoryView;
        __weak BRLMPrintSettingTableViewController* wself = self;
        if (self.qlSettings) {
            if ([title isEqualToString:@"BRLMPrintSettingsSkipStatusCheck"]) {
                switchView.on = self.qlSettings.skipStatusCheck;
                [self setInputBoolViewWithTitle:title switchView:switchView changeHandler:^(BOOL value) {
                    wself.qlSettings.skipStatusCheck = value;
                }];
            }
            if ([title isEqualToString:@"BRLMPrintSettingsAutoCut"]) {
                switchView.on = self.qlSettings.autoCut;
                [self setInputBoolViewWithTitle:title switchView:switchView changeHandler:^(BOOL value) {
                    wself.qlSettings.autoCut = value;
                }];
            }
            if ([title isEqualToString:@"BRLMPrintSettingsCutAtEnd"]) {
                switchView.on = self.qlSettings.cutAtEnd;
                [self setInputBoolViewWithTitle:title switchView:switchView changeHandler:^(BOOL value) {
                    wself.qlSettings.cutAtEnd = value;
                }];
            }

        }
        else if (self.ptSettings) {
            if ([title isEqualToString:@"BRLMPrintSettingsSkipStatusCheck"]) {
                switchView.on = self.ptSettings.skipStatusCheck;
                [self setInputBoolViewWithTitle:title switchView:switchView changeHandler:^(BOOL value) {
                    wself.ptSettings.skipStatusCheck = value;
                }];
            }
            if ([title isEqualToString:@"BRLMPrintSettingsCutmarkPrint"]) {
                switchView.on = self.ptSettings.cutmarkPrint;
                [self setInputBoolViewWithTitle:title switchView:switchView changeHandler:^(BOOL value) {
                    wself.ptSettings.cutmarkPrint = value;
                }];
            }
            if ([title isEqualToString:@"BRLMPTPrintSettingsCutPause"]) {
                switchView.on = self.ptSettings.cutPause;
                [self setInputBoolViewWithTitle:title switchView:switchView changeHandler:^(BOOL value) {
                    wself.ptSettings.cutPause = value;
                }];
            }
            if ([title isEqualToString:@"BRLMPrintSettingsAutoCut"]) {
                switchView.on = self.ptSettings.autoCut;
                [self setInputBoolViewWithTitle:title switchView:switchView changeHandler:^(BOOL value) {
                    wself.ptSettings.autoCut = value;
                }];
            }
            if ([title isEqualToString:@"BRLMPrintSettingsHalfCut"]) {
                switchView.on = self.ptSettings.halfCut;
                [self setInputBoolViewWithTitle:title switchView:switchView changeHandler:^(BOOL value) {
                    wself.ptSettings.halfCut = value;
                }];
            }
            if ([title isEqualToString:@"BRLMPrintSettingsChainPrint"]) {
                switchView.on = self.ptSettings.chainPrint;
                [self setInputBoolViewWithTitle:title switchView:switchView changeHandler:^(BOOL value) {
                    wself.ptSettings.chainPrint = value;
                }];
            }
            if ([title isEqualToString:@"BRLMPrintSettingsSpecialTapePrint"]) {
                switchView.on = self.ptSettings.specialTapePrint;
                [self setInputBoolViewWithTitle:title switchView:switchView changeHandler:^(BOOL value) {
                    wself.ptSettings.specialTapePrint = value;
                }];
            }
            if ([title isEqualToString:@"BRLMPrintSettingsForceVanishingMargin"]) {
                switchView.on = self.ptSettings.forceVanishingMargin;
                [self setInputBoolViewWithTitle:title switchView:switchView changeHandler:^(BOOL value) {
                    wself.ptSettings.forceVanishingMargin = value;
                }];
            }

        }
        else if (self.pjSettings) {
            if ([title isEqualToString:@"BRLMPrintSettingsSkipStatusCheck"]) {
                switchView.on = self.pjSettings.skipStatusCheck;
                [self setInputBoolViewWithTitle:title switchView:switchView changeHandler:^(BOOL value) {
                    wself.pjSettings.skipStatusCheck = value;
                }];
            }
            if ([title isEqualToString:@"BRLMPrintSettingsUsingCarbonCopyPaper"]) {
                switchView.on = self.pjSettings.usingCarbonCopyPaper;
                [self setInputBoolViewWithTitle:title switchView:switchView changeHandler:^(BOOL value) {
                    wself.pjSettings.usingCarbonCopyPaper = value;
                }];
            }
            if ([title isEqualToString:@"BRLMPrintSettingsPrintDashLine"]) {
                switchView.on = self.pjSettings.printDashLine;
                [self setInputBoolViewWithTitle:title switchView:switchView changeHandler:^(BOOL value) {
                    wself.pjSettings.printDashLine = value;
                }];
            }

        }
        else if (self.mwSettings) {
            if ([title isEqualToString:@"BRLMPrintSettingsSkipStatusCheck"]) {
                switchView.on = self.mwSettings.skipStatusCheck;
                [self setInputBoolViewWithTitle:title switchView:switchView changeHandler:^(BOOL value) {
                    wself.mwSettings.skipStatusCheck = value;
                }];
            }

        }
        else if (self.tdSettings) {
            if ([title isEqualToString:@"BRLMPrintSettingsSkipStatusCheck"]) {
                switchView.on = self.tdSettings.skipStatusCheck;
                [self setInputBoolViewWithTitle:title switchView:switchView changeHandler:^(BOOL value) {
                    wself.tdSettings.skipStatusCheck = value;
                }];
            }
            if ([title isEqualToString:@"BRLMPrintSettingsPeelLabel"]) {
                switchView.on = self.tdSettings.peelLabel;
                [self setInputBoolViewWithTitle:title switchView:switchView changeHandler:^(BOOL value) {
                    wself.tdSettings.peelLabel = value;
                }];
            }
            if ([title isEqualToString:@"BRLMPrintSettingsAutoCut"]) {
                switchView.on = self.tdSettings.autoCut;
                [self setInputBoolViewWithTitle:title switchView:switchView changeHandler:^(BOOL value) {
                    wself.tdSettings.autoCut = value;
                }];
            }
            if ([title isEqualToString:@"BRLMPrintSettingsCutAtEnd"]) {
                switchView.on = self.tdSettings.cutAtEnd;
                [self setInputBoolViewWithTitle:title switchView:switchView changeHandler:^(BOOL value) {
                    wself.tdSettings.cutAtEnd = value;
                }];
            }

        }
        else if (self.rjSettings) {
            if ([title isEqualToString:@"BRLMPrintSettingsSkipStatusCheck"]) {
                switchView.on = self.rjSettings.skipStatusCheck;
                [self setInputBoolViewWithTitle:title switchView:switchView changeHandler:^(BOOL value) {
                    wself.rjSettings.skipStatusCheck = value;
                }];
            }
            if ([title isEqualToString:@"BRLMPrintSettingsRotate180degrees"]) {
                switchView.on = self.rjSettings.rotate180degrees;
                [self setInputBoolViewWithTitle:title switchView:switchView changeHandler:^(BOOL value) {
                    wself.rjSettings.rotate180degrees = value;
                }];
            }
            if ([title isEqualToString:@"BRLMPrintSettingsPeelLabel"]) {
                switchView.on = self.rjSettings.peelLabel;
                [self setInputBoolViewWithTitle:title switchView:switchView changeHandler:^(BOOL value) {
                    wself.rjSettings.peelLabel = value;
                }];
            }

        }
        return cell;
    };
    BOOL isSwitchCell = NO;
    NSString* title = self.properties[indexPath.row];
    if (self.qlSettings) {
        if ([title isEqualToString:@"BRLMPrintSettingsSkipStatusCheck"]) {
            isSwitchCell = YES;
        }
        if ([title isEqualToString:@"BRLMPrintSettingsAutoCut"]) {
            isSwitchCell = YES;
        }
        if ([title isEqualToString:@"BRLMPrintSettingsCutAtEnd"]) {
            isSwitchCell = YES;
        }

    }
    else if (self.ptSettings) {
        if ([title isEqualToString:@"BRLMPrintSettingsSkipStatusCheck"]) {
            isSwitchCell = YES;
        }
        if ([title isEqualToString:@"BRLMPrintSettingsCutmarkPrint"]) {
            isSwitchCell = YES;
        }
        if ([title isEqualToString:@"BRLMPTPrintSettingsCutPause"]) {
            isSwitchCell = YES;
        }
        if ([title isEqualToString:@"BRLMPrintSettingsAutoCut"]) {
            isSwitchCell = YES;
        }
        if ([title isEqualToString:@"BRLMPrintSettingsHalfCut"]) {
            isSwitchCell = YES;
        }
        if ([title isEqualToString:@"BRLMPrintSettingsChainPrint"]) {
            isSwitchCell = YES;
        }
        if ([title isEqualToString:@"BRLMPrintSettingsSpecialTapePrint"]) {
            isSwitchCell = YES;
        }
        if ([title isEqualToString:@"BRLMPrintSettingsForceVanishingMargin"]) {
            isSwitchCell = YES;
        }

    }
    else if (self.pjSettings) {
        if ([title isEqualToString:@"BRLMPrintSettingsSkipStatusCheck"]) {
            isSwitchCell = YES;
        }
        if ([title isEqualToString:@"BRLMPrintSettingsUsingCarbonCopyPaper"]) {
            isSwitchCell = YES;
        }
        if ([title isEqualToString:@"BRLMPrintSettingsPrintDashLine"]) {
            isSwitchCell = YES;
        }

    }
    else if (self.mwSettings) {
        if ([title isEqualToString:@"BRLMPrintSettingsSkipStatusCheck"]) {
            isSwitchCell = YES;
        }

    }
    else if (self.tdSettings) {
        if ([title isEqualToString:@"BRLMPrintSettingsSkipStatusCheck"]) {
            isSwitchCell = YES;
        }
        if ([title isEqualToString:@"BRLMPrintSettingsPeelLabel"]) {
            isSwitchCell = YES;
        }
        if ([title isEqualToString:@"BRLMPrintSettingsAutoCut"]) {
            isSwitchCell = YES;
        }
        if ([title isEqualToString:@"BRLMPrintSettingsCutAtEnd"]) {
            isSwitchCell = YES;
        }

    }
    else if (self.rjSettings) {
        if ([title isEqualToString:@"BRLMPrintSettingsSkipStatusCheck"]) {
            isSwitchCell = YES;
        }
        if ([title isEqualToString:@"BRLMPrintSettingsRotate180degrees"]) {
            isSwitchCell = YES;
        }
        if ([title isEqualToString:@"BRLMPrintSettingsPeelLabel"]) {
            isSwitchCell = YES;
        }

    }
    UITableViewCell *cell;
    if(isSwitchCell) {
        cell = switchCell();
    }
    else {
        cell = textFieldCell();
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* title = self.properties[indexPath.row];
    __weak BRLMPrintSettingTableViewController* wself = self;
    if (self.qlSettings) {
                if ([title isEqualToString:@"BRLMPrintSettingsScaleMode"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"ActualSize", @"FitPageAspect", @"FitPaperAspect", @"ScaleValue", ]
                                      values:@[@(BRLMPrintSettingsScaleModeActualSize), @(BRLMPrintSettingsScaleModeFitPageAspect), @(BRLMPrintSettingsScaleModeFitPaperAspect), @(BRLMPrintSettingsScaleModeScaleValue), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.qlSettings.scaleMode = (BRLMPrintSettingsScaleMode)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsScaleValue"]) {
            [self showInputStringViewWithTitle:@"BRLMPrintSettingsScaleValue" message:[NSString stringWithFormat:@"%f",self.qlSettings.scaleValue] placeHolder:@"" decisionHandler:^(NSString * input) {
                wself.qlSettings.scaleValue = [input floatValue];
            }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsOrientation"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"Portrait", @"Landscape", ]
                                      values:@[@(BRLMPrintSettingsOrientationPortrait), @(BRLMPrintSettingsOrientationLandscape), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.qlSettings.printOrientation = (BRLMPrintSettingsOrientation)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsRotation"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"Rotate0", @"Rotate90", @"Rotate180", @"Rotate270", ]
                                      values:@[@(BRLMPrintSettingsRotationRotate0), @(BRLMPrintSettingsRotationRotate90), @(BRLMPrintSettingsRotationRotate180), @(BRLMPrintSettingsRotationRotate270), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.qlSettings.imageRotation = (BRLMPrintSettingsRotation)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsHalftone"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"Threshold", @"ErrorDiffusion", @"PatternDither", ]
                                      values:@[@(BRLMPrintSettingsHalftoneThreshold), @(BRLMPrintSettingsHalftoneErrorDiffusion), @(BRLMPrintSettingsHalftonePatternDither), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.qlSettings.halftone = (BRLMPrintSettingsHalftone)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsHorizontalAlignment"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"Left", @"Center", @"Right", ]
                                      values:@[@(BRLMPrintSettingsHorizontalAlignmentLeft), @(BRLMPrintSettingsHorizontalAlignmentCenter), @(BRLMPrintSettingsHorizontalAlignmentRight), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.qlSettings.hAlignment = (BRLMPrintSettingsHorizontalAlignment)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsVerticalAlignment"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"Top", @"Center", @"Bottom", ]
                                      values:@[@(BRLMPrintSettingsVerticalAlignmentTop), @(BRLMPrintSettingsVerticalAlignmentCenter), @(BRLMPrintSettingsVerticalAlignmentBottom), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.qlSettings.vAlignment = (BRLMPrintSettingsVerticalAlignment)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsCompressMode"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"None", @"Tiff", @"Mode9", ]
                                      values:@[@(BRLMPrintSettingsCompressModeNone), @(BRLMPrintSettingsCompressModeTiff), @(BRLMPrintSettingsCompressModeMode9), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.qlSettings.compress = (BRLMPrintSettingsCompressMode)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsHalftoneThreshold"]) {
            [self showInputStringViewWithTitle:@"BRLMPrintSettingsHalftoneThreshold" message:[NSString stringWithFormat:@"%lu",(unsigned long)self.qlSettings.halftoneThreshold] placeHolder:@"" decisionHandler:^(NSString * input) {
                wself.qlSettings.halftoneThreshold = (uint8_t)[input integerValue];
            }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsNumCopies"]) {
            [self showInputStringViewWithTitle:@"BRLMPrintSettingsNumCopies" message:[NSString stringWithFormat:@"%ld",(unsigned long)self.qlSettings.numCopies] placeHolder:@"" decisionHandler:^(NSString * input) {
                wself.qlSettings.numCopies = [input integerValue];
            }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsPrintQuality"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"Best", @"Fast", ]
                                      values:@[@(BRLMPrintSettingsPrintQualityBest), @(BRLMPrintSettingsPrintQualityFast), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.qlSettings.printQuality = (BRLMPrintSettingsPrintQuality)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMQLPrintSettingsLabelSize"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"DieCutW17H54", @"DieCutW17H87", @"DieCutW23H23", @"DieCutW29H42", @"DieCutW29H90", @"DieCutW38H90", @"DieCutW39H48", @"DieCutW52H29", @"DieCutW62H29", @"DieCutW62H60", @"DieCutW62H75", @"DieCutW62H100", @"DieCutW60H86", @"DieCutW54H29", @"DieCutW102H51", @"DieCutW102H152", @"DieCutW103H164", @"RollW12", @"RollW29", @"RollW38", @"RollW50", @"RollW54", @"RollW62", @"RollW62RB", @"RollW102", @"RollW103", @"DTRollW90", @"DTRollW102", @"DTRollW102H51", @"DTRollW102H152", @"RoundW12DIA", @"RoundW24DIA", @"RoundW58DIA", ]
                                      values:@[@(BRLMQLPrintSettingsLabelSizeDieCutW17H54), @(BRLMQLPrintSettingsLabelSizeDieCutW17H87), @(BRLMQLPrintSettingsLabelSizeDieCutW23H23), @(BRLMQLPrintSettingsLabelSizeDieCutW29H42), @(BRLMQLPrintSettingsLabelSizeDieCutW29H90), @(BRLMQLPrintSettingsLabelSizeDieCutW38H90), @(BRLMQLPrintSettingsLabelSizeDieCutW39H48), @(BRLMQLPrintSettingsLabelSizeDieCutW52H29), @(BRLMQLPrintSettingsLabelSizeDieCutW62H29), @(BRLMQLPrintSettingsLabelSizeDieCutW62H60), @(BRLMQLPrintSettingsLabelSizeDieCutW62H75), @(BRLMQLPrintSettingsLabelSizeDieCutW62H100), @(BRLMQLPrintSettingsLabelSizeDieCutW60H86), @(BRLMQLPrintSettingsLabelSizeDieCutW54H29), @(BRLMQLPrintSettingsLabelSizeDieCutW102H51), @(BRLMQLPrintSettingsLabelSizeDieCutW102H152), @(BRLMQLPrintSettingsLabelSizeDieCutW103H164), @(BRLMQLPrintSettingsLabelSizeRollW12), @(BRLMQLPrintSettingsLabelSizeRollW29), @(BRLMQLPrintSettingsLabelSizeRollW38), @(BRLMQLPrintSettingsLabelSizeRollW50), @(BRLMQLPrintSettingsLabelSizeRollW54), @(BRLMQLPrintSettingsLabelSizeRollW62), @(BRLMQLPrintSettingsLabelSizeRollW62RB), @(BRLMQLPrintSettingsLabelSizeRollW102), @(BRLMQLPrintSettingsLabelSizeRollW103), @(BRLMQLPrintSettingsLabelSizeDTRollW90), @(BRLMQLPrintSettingsLabelSizeDTRollW102), @(BRLMQLPrintSettingsLabelSizeDTRollW102H51), @(BRLMQLPrintSettingsLabelSizeDTRollW102H152), @(BRLMQLPrintSettingsLabelSizeRoundW12DIA), @(BRLMQLPrintSettingsLabelSizeRoundW24DIA), @(BRLMQLPrintSettingsLabelSizeRoundW58DIA), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.qlSettings.labelSize = (BRLMQLPrintSettingsLabelSize)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsAutoCutForEachPageCount"]) {
            [self showInputStringViewWithTitle:@"BRLMPrintSettingsAutoCutForEachPageCount" message:[NSString stringWithFormat:@"%lu",(unsigned long)self.qlSettings.autoCutForEachPageCount] placeHolder:@"" decisionHandler:^(NSString * input) {
                wself.qlSettings.autoCutForEachPageCount = (uint8_t)[input integerValue];
            }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsResolution"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"Low", @"Normal", @"High", ]
                                      values:@[@(BRLMPrintSettingsResolutionLow), @(BRLMPrintSettingsResolutionNormal), @(BRLMPrintSettingsResolutionHigh), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.qlSettings.resolution = (BRLMPrintSettingsResolution)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMQLPrintSettingsBiColorRedEnhancement"]) {
            [self showInputStringViewWithTitle:@"BRLMQLPrintSettingsBiColorRedEnhancement" message:[NSString stringWithFormat:@"%ld",(unsigned long)self.qlSettings.biColorRedEnhancement] placeHolder:@"" decisionHandler:^(NSString * input) {
                wself.qlSettings.biColorRedEnhancement = [input integerValue];
            }];
        }
        if ([title isEqualToString:@"BRLMQLPrintSettingsBiColorGreenEnhancement"]) {
            [self showInputStringViewWithTitle:@"BRLMQLPrintSettingsBiColorGreenEnhancement" message:[NSString stringWithFormat:@"%ld",(unsigned long)self.qlSettings.biColorGreenEnhancement] placeHolder:@"" decisionHandler:^(NSString * input) {
                wself.qlSettings.biColorGreenEnhancement = [input integerValue];
            }];
        }
        if ([title isEqualToString:@"BRLMQLPrintSettingsBiColorBlueEnhancement"]) {
            [self showInputStringViewWithTitle:@"BRLMQLPrintSettingsBiColorBlueEnhancement" message:[NSString stringWithFormat:@"%ld",(unsigned long)self.qlSettings.biColorBlueEnhancement] placeHolder:@"" decisionHandler:^(NSString * input) {
                wself.qlSettings.biColorBlueEnhancement = [input integerValue];
            }];
        }

    }
    else if (self.ptSettings) {
                if ([title isEqualToString:@"BRLMPrintSettingsScaleMode"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"ActualSize", @"FitPageAspect", @"FitPaperAspect", @"ScaleValue", ]
                                      values:@[@(BRLMPrintSettingsScaleModeActualSize), @(BRLMPrintSettingsScaleModeFitPageAspect), @(BRLMPrintSettingsScaleModeFitPaperAspect), @(BRLMPrintSettingsScaleModeScaleValue), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.ptSettings.scaleMode = (BRLMPrintSettingsScaleMode)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsScaleValue"]) {
            [self showInputStringViewWithTitle:@"BRLMPrintSettingsScaleValue" message:[NSString stringWithFormat:@"%f",self.ptSettings.scaleValue] placeHolder:@"" decisionHandler:^(NSString * input) {
                wself.ptSettings.scaleValue = [input floatValue];
            }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsOrientation"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"Portrait", @"Landscape", ]
                                      values:@[@(BRLMPrintSettingsOrientationPortrait), @(BRLMPrintSettingsOrientationLandscape), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.ptSettings.printOrientation = (BRLMPrintSettingsOrientation)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsRotation"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"Rotate0", @"Rotate90", @"Rotate180", @"Rotate270", ]
                                      values:@[@(BRLMPrintSettingsRotationRotate0), @(BRLMPrintSettingsRotationRotate90), @(BRLMPrintSettingsRotationRotate180), @(BRLMPrintSettingsRotationRotate270), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.ptSettings.imageRotation = (BRLMPrintSettingsRotation)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsHalftone"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"Threshold", @"ErrorDiffusion", @"PatternDither", ]
                                      values:@[@(BRLMPrintSettingsHalftoneThreshold), @(BRLMPrintSettingsHalftoneErrorDiffusion), @(BRLMPrintSettingsHalftonePatternDither), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.ptSettings.halftone = (BRLMPrintSettingsHalftone)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsHorizontalAlignment"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"Left", @"Center", @"Right", ]
                                      values:@[@(BRLMPrintSettingsHorizontalAlignmentLeft), @(BRLMPrintSettingsHorizontalAlignmentCenter), @(BRLMPrintSettingsHorizontalAlignmentRight), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.ptSettings.hAlignment = (BRLMPrintSettingsHorizontalAlignment)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsVerticalAlignment"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"Top", @"Center", @"Bottom", ]
                                      values:@[@(BRLMPrintSettingsVerticalAlignmentTop), @(BRLMPrintSettingsVerticalAlignmentCenter), @(BRLMPrintSettingsVerticalAlignmentBottom), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.ptSettings.vAlignment = (BRLMPrintSettingsVerticalAlignment)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsCompressMode"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"None", @"Tiff", @"Mode9", ]
                                      values:@[@(BRLMPrintSettingsCompressModeNone), @(BRLMPrintSettingsCompressModeTiff), @(BRLMPrintSettingsCompressModeMode9), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.ptSettings.compress = (BRLMPrintSettingsCompressMode)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsHalftoneThreshold"]) {
            [self showInputStringViewWithTitle:@"BRLMPrintSettingsHalftoneThreshold" message:[NSString stringWithFormat:@"%lu",(unsigned long)self.ptSettings.halftoneThreshold] placeHolder:@"" decisionHandler:^(NSString * input) {
                wself.ptSettings.halftoneThreshold = (uint8_t)[input integerValue];
            }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsNumCopies"]) {
            [self showInputStringViewWithTitle:@"BRLMPrintSettingsNumCopies" message:[NSString stringWithFormat:@"%ld",(unsigned long)self.ptSettings.numCopies] placeHolder:@"" decisionHandler:^(NSString * input) {
                wself.ptSettings.numCopies = [input integerValue];
            }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsPrintQuality"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"Best", @"Fast", ]
                                      values:@[@(BRLMPrintSettingsPrintQualityBest), @(BRLMPrintSettingsPrintQualityFast), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.ptSettings.printQuality = (BRLMPrintSettingsPrintQuality)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPTPrintSettingsLabelSize"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"Width3_5mm", @"Width6mm", @"Width9mm", @"Width12mm", @"Width18mm", @"Width24mm", @"Width36mm", @"WidthHS_5_8mm", @"WidthHS_8_8mm", @"WidthHS_11_7mm", @"WidthHS_17_7mm", @"WidthHS_23_6mm", @"WidthFL_21x45mm", @"WidthHS_5_2mm", @"WidthHS_9_0mm", @"WidthHS_11_2mm", @"WidthHS_21_0mm", @"WidthHS_31_0mm", ]
                                      values:@[@(BRLMPTPrintSettingsLabelSizeWidth3_5mm), @(BRLMPTPrintSettingsLabelSizeWidth6mm), @(BRLMPTPrintSettingsLabelSizeWidth9mm), @(BRLMPTPrintSettingsLabelSizeWidth12mm), @(BRLMPTPrintSettingsLabelSizeWidth18mm), @(BRLMPTPrintSettingsLabelSizeWidth24mm), @(BRLMPTPrintSettingsLabelSizeWidth36mm), @(BRLMPTPrintSettingsLabelSizeWidthHS_5_8mm), @(BRLMPTPrintSettingsLabelSizeWidthHS_8_8mm), @(BRLMPTPrintSettingsLabelSizeWidthHS_11_7mm), @(BRLMPTPrintSettingsLabelSizeWidthHS_17_7mm), @(BRLMPTPrintSettingsLabelSizeWidthHS_23_6mm), @(BRLMPTPrintSettingsLabelSizeWidthFL_21x45mm), @(BRLMPTPrintSettingsLabelSizeWidthHS_5_2mm), @(BRLMPTPrintSettingsLabelSizeWidthHS_9_0mm), @(BRLMPTPrintSettingsLabelSizeWidthHS_11_2mm), @(BRLMPTPrintSettingsLabelSizeWidthHS_21_0mm), @(BRLMPTPrintSettingsLabelSizeWidthHS_31_0mm), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.ptSettings.labelSize = (BRLMPTPrintSettingsLabelSize)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsResolution"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"Low", @"Normal", @"High", ]
                                      values:@[@(BRLMPrintSettingsResolutionLow), @(BRLMPrintSettingsResolutionNormal), @(BRLMPrintSettingsResolutionHigh), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.ptSettings.resolution = (BRLMPrintSettingsResolution)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsAutoCutForEachPageCount"]) {
            [self showInputStringViewWithTitle:@"BRLMPrintSettingsAutoCutForEachPageCount" message:[NSString stringWithFormat:@"%lu",(unsigned long)self.ptSettings.autoCutForEachPageCount] placeHolder:@"" decisionHandler:^(NSString * input) {
                wself.ptSettings.autoCutForEachPageCount = (uint8_t)[input integerValue];
            }];
        }

    }
    else if (self.pjSettings) {
                if ([title isEqualToString:@"BRLMPrintSettingsScaleMode"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"ActualSize", @"FitPageAspect", @"FitPaperAspect", @"ScaleValue", ]
                                      values:@[@(BRLMPrintSettingsScaleModeActualSize), @(BRLMPrintSettingsScaleModeFitPageAspect), @(BRLMPrintSettingsScaleModeFitPaperAspect), @(BRLMPrintSettingsScaleModeScaleValue), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.pjSettings.scaleMode = (BRLMPrintSettingsScaleMode)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsScaleValue"]) {
            [self showInputStringViewWithTitle:@"BRLMPrintSettingsScaleValue" message:[NSString stringWithFormat:@"%f",self.pjSettings.scaleValue] placeHolder:@"" decisionHandler:^(NSString * input) {
                wself.pjSettings.scaleValue = [input floatValue];
            }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsOrientation"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"Portrait", @"Landscape", ]
                                      values:@[@(BRLMPrintSettingsOrientationPortrait), @(BRLMPrintSettingsOrientationLandscape), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.pjSettings.printOrientation = (BRLMPrintSettingsOrientation)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsRotation"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"Rotate0", @"Rotate90", @"Rotate180", @"Rotate270", ]
                                      values:@[@(BRLMPrintSettingsRotationRotate0), @(BRLMPrintSettingsRotationRotate90), @(BRLMPrintSettingsRotationRotate180), @(BRLMPrintSettingsRotationRotate270), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.pjSettings.imageRotation = (BRLMPrintSettingsRotation)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsHalftone"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"Threshold", @"ErrorDiffusion", @"PatternDither", ]
                                      values:@[@(BRLMPrintSettingsHalftoneThreshold), @(BRLMPrintSettingsHalftoneErrorDiffusion), @(BRLMPrintSettingsHalftonePatternDither), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.pjSettings.halftone = (BRLMPrintSettingsHalftone)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsHorizontalAlignment"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"Left", @"Center", @"Right", ]
                                      values:@[@(BRLMPrintSettingsHorizontalAlignmentLeft), @(BRLMPrintSettingsHorizontalAlignmentCenter), @(BRLMPrintSettingsHorizontalAlignmentRight), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.pjSettings.hAlignment = (BRLMPrintSettingsHorizontalAlignment)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsVerticalAlignment"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"Top", @"Center", @"Bottom", ]
                                      values:@[@(BRLMPrintSettingsVerticalAlignmentTop), @(BRLMPrintSettingsVerticalAlignmentCenter), @(BRLMPrintSettingsVerticalAlignmentBottom), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.pjSettings.vAlignment = (BRLMPrintSettingsVerticalAlignment)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsCompressMode"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"None", @"Tiff", @"Mode9", ]
                                      values:@[@(BRLMPrintSettingsCompressModeNone), @(BRLMPrintSettingsCompressModeTiff), @(BRLMPrintSettingsCompressModeMode9), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.pjSettings.compress = (BRLMPrintSettingsCompressMode)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsHalftoneThreshold"]) {
            [self showInputStringViewWithTitle:@"BRLMPrintSettingsHalftoneThreshold" message:[NSString stringWithFormat:@"%lu",(unsigned long)self.pjSettings.halftoneThreshold] placeHolder:@"" decisionHandler:^(NSString * input) {
                wself.pjSettings.halftoneThreshold = (uint8_t)[input integerValue];
            }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsNumCopies"]) {
            [self showInputStringViewWithTitle:@"BRLMPrintSettingsNumCopies" message:[NSString stringWithFormat:@"%ld",(unsigned long)self.pjSettings.numCopies] placeHolder:@"" decisionHandler:^(NSString * input) {
                wself.pjSettings.numCopies = [input integerValue];
            }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsPrintQuality"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"Best", @"Fast", ]
                                      values:@[@(BRLMPrintSettingsPrintQualityBest), @(BRLMPrintSettingsPrintQualityFast), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.pjSettings.printQuality = (BRLMPrintSettingsPrintQuality)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPJPrintSettingsPaperSize"]) {
            self.segueAction = ^(UIStoryboardSegue* segue) {
                BRLMPaperSizePJTableViewController *viewController = [segue destinationViewController];
                viewController.defaultPaperSizePJ = wself.pjSettings.paperSize;
                viewController.decisionHandler = ^(BRLMPJPrintSettingsPaperSize* paperSizePJ) {
                    wself.pjSettings.paperSize = paperSizePJ;
                };
            };
            [self performSegueWithIdentifier:@"BRLMPaperSizePJTableViewController" sender:self];
        }
        if ([title isEqualToString:@"BRLMPJPrintSettingsPaperType"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"Roll", @"CutSheet", @"PerforatedRoll", ]
                                      values:@[@(BRLMPJPrintSettingsPaperTypeRoll), @(BRLMPJPrintSettingsPaperTypeCutSheet), @(BRLMPJPrintSettingsPaperTypePerforatedRoll), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.pjSettings.paperType = (BRLMPJPrintSettingsPaperType)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPJPrintSettingsPaperInsertionPosition"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"Left", @"Center", @"Right", ]
                                      values:@[@(BRLMPJPrintSettingsPaperInsertionPositionLeft), @(BRLMPJPrintSettingsPaperInsertionPositionCenter), @(BRLMPJPrintSettingsPaperInsertionPositionRight), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.pjSettings.paperInsertionPosition = (BRLMPJPrintSettingsPaperInsertionPosition)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPJPrintSettingsFeedMode"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"NoFeed", @"FixedPage", @"EndOfPage", @"EndOfPageRetract", ]
                                      values:@[@(BRLMPJPrintSettingsFeedModeNoFeed), @(BRLMPJPrintSettingsFeedModeFixedPage), @(BRLMPJPrintSettingsFeedModeEndOfPage), @(BRLMPJPrintSettingsFeedModeEndOfPageRetract), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.pjSettings.feedMode = (BRLMPJPrintSettingsFeedMode)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPJPrintSettingsExtraFeedDots"]) {
            [self showInputStringViewWithTitle:@"BRLMPJPrintSettingsExtraFeedDots" message:[NSString stringWithFormat:@"%ld",(unsigned long)self.pjSettings.extraFeedDots] placeHolder:@"" decisionHandler:^(NSString * input) {
                wself.pjSettings.extraFeedDots = [input integerValue];
            }];
        }
        if ([title isEqualToString:@"BRLMPJPrintSettingsDensity"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"WeakLevel5", @"WeakLevel4", @"WeakLevel3", @"WeakLevel2", @"WeakLevel1", @"Neutral", @"StrongLevel1", @"StrongLevel2", @"StrongLevel3", @"StrongLevel4", @"StrongLevel5", @"UsePrinterSetting", ]
                                      values:@[@(BRLMPJPrintSettingsDensityWeakLevel5), @(BRLMPJPrintSettingsDensityWeakLevel4), @(BRLMPJPrintSettingsDensityWeakLevel3), @(BRLMPJPrintSettingsDensityWeakLevel2), @(BRLMPJPrintSettingsDensityWeakLevel1), @(BRLMPJPrintSettingsDensityNeutral), @(BRLMPJPrintSettingsDensityStrongLevel1), @(BRLMPJPrintSettingsDensityStrongLevel2), @(BRLMPJPrintSettingsDensityStrongLevel3), @(BRLMPJPrintSettingsDensityStrongLevel4), @(BRLMPJPrintSettingsDensityStrongLevel5), @(BRLMPJPrintSettingsDensityUsePrinterSetting), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.pjSettings.density = (BRLMPJPrintSettingsDensity)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPJPrintSettingsRollCase"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"None", @"PARC001_NoAntiCurl", @"PARC001", @"PARC001_ShortFeed", @"KeepPrinterSetting", ]
                                      values:@[@(BRLMPJPrintSettingsRollCaseNone), @(BRLMPJPrintSettingsRollCasePARC001_NoAntiCurl), @(BRLMPJPrintSettingsRollCasePARC001), @(BRLMPJPrintSettingsRollCasePARC001_ShortFeed), @(BRLMPJPrintSettingsRollCaseKeepPrinterSetting), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.pjSettings.rollCase = (BRLMPJPrintSettingsRollCase)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPJPrintSettingsPrintSpeed"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"HighSpeed", @"MediumHighSpeed", @"MediumLowSpeed", @"LowSpeed", @"Fast_DraftQuality", @"Fast_LineConversion", @"UsePrinterSetting", @"2_5inchPerSec", @"1_9inchPerSec", @"1_6inchPerSec", @"1_1inchPerSec", ]
                                      values:@[@(BRLMPJPrintSettingsPrintSpeedHighSpeed), @(BRLMPJPrintSettingsPrintSpeedMediumHighSpeed), @(BRLMPJPrintSettingsPrintSpeedMediumLowSpeed), @(BRLMPJPrintSettingsPrintSpeedLowSpeed), @(BRLMPJPrintSettingsPrintSpeedFast_DraftQuality), @(BRLMPJPrintSettingsPrintSpeedFast_LineConversion), @(BRLMPJPrintSettingsPrintSpeedUsePrinterSetting), @(BRLMPJPrintSettingsPrintSpeed2_5inchPerSec), @(BRLMPJPrintSettingsPrintSpeed1_9inchPerSec), @(BRLMPJPrintSettingsPrintSpeed1_6inchPerSec), @(BRLMPJPrintSettingsPrintSpeed1_1inchPerSec), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.pjSettings.printSpeed = (BRLMPJPrintSettingsPrintSpeed)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPJPrintSettingsForceStretchPrintableArea"]) {
            [self showInputStringViewWithTitle:@"BRLMPJPrintSettingsForceStretchPrintableArea" message:[NSString stringWithFormat:@"%ld",(unsigned long)self.pjSettings.forceStretchPrintableArea] placeHolder:@"" decisionHandler:^(NSString * input) {
                wself.pjSettings.forceStretchPrintableArea = [input integerValue];
            }];
        }

    }
    else if (self.mwSettings) {
                if ([title isEqualToString:@"BRLMPrintSettingsScaleMode"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"ActualSize", @"FitPageAspect", @"FitPaperAspect", @"ScaleValue", ]
                                      values:@[@(BRLMPrintSettingsScaleModeActualSize), @(BRLMPrintSettingsScaleModeFitPageAspect), @(BRLMPrintSettingsScaleModeFitPaperAspect), @(BRLMPrintSettingsScaleModeScaleValue), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.mwSettings.scaleMode = (BRLMPrintSettingsScaleMode)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsScaleValue"]) {
            [self showInputStringViewWithTitle:@"BRLMPrintSettingsScaleValue" message:[NSString stringWithFormat:@"%f",self.mwSettings.scaleValue] placeHolder:@"" decisionHandler:^(NSString * input) {
                wself.mwSettings.scaleValue = [input floatValue];
            }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsOrientation"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"Portrait", @"Landscape", ]
                                      values:@[@(BRLMPrintSettingsOrientationPortrait), @(BRLMPrintSettingsOrientationLandscape), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.mwSettings.printOrientation = (BRLMPrintSettingsOrientation)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsRotation"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"Rotate0", @"Rotate90", @"Rotate180", @"Rotate270", ]
                                      values:@[@(BRLMPrintSettingsRotationRotate0), @(BRLMPrintSettingsRotationRotate90), @(BRLMPrintSettingsRotationRotate180), @(BRLMPrintSettingsRotationRotate270), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.mwSettings.imageRotation = (BRLMPrintSettingsRotation)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsHalftone"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"Threshold", @"ErrorDiffusion", @"PatternDither", ]
                                      values:@[@(BRLMPrintSettingsHalftoneThreshold), @(BRLMPrintSettingsHalftoneErrorDiffusion), @(BRLMPrintSettingsHalftonePatternDither), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.mwSettings.halftone = (BRLMPrintSettingsHalftone)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsHorizontalAlignment"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"Left", @"Center", @"Right", ]
                                      values:@[@(BRLMPrintSettingsHorizontalAlignmentLeft), @(BRLMPrintSettingsHorizontalAlignmentCenter), @(BRLMPrintSettingsHorizontalAlignmentRight), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.mwSettings.hAlignment = (BRLMPrintSettingsHorizontalAlignment)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsVerticalAlignment"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"Top", @"Center", @"Bottom", ]
                                      values:@[@(BRLMPrintSettingsVerticalAlignmentTop), @(BRLMPrintSettingsVerticalAlignmentCenter), @(BRLMPrintSettingsVerticalAlignmentBottom), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.mwSettings.vAlignment = (BRLMPrintSettingsVerticalAlignment)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsCompressMode"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"None", @"Tiff", @"Mode9", ]
                                      values:@[@(BRLMPrintSettingsCompressModeNone), @(BRLMPrintSettingsCompressModeTiff), @(BRLMPrintSettingsCompressModeMode9), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.mwSettings.compress = (BRLMPrintSettingsCompressMode)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsHalftoneThreshold"]) {
            [self showInputStringViewWithTitle:@"BRLMPrintSettingsHalftoneThreshold" message:[NSString stringWithFormat:@"%lu",(unsigned long)self.mwSettings.halftoneThreshold] placeHolder:@"" decisionHandler:^(NSString * input) {
                wself.mwSettings.halftoneThreshold = (uint8_t)[input integerValue];
            }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsNumCopies"]) {
            [self showInputStringViewWithTitle:@"BRLMPrintSettingsNumCopies" message:[NSString stringWithFormat:@"%ld",(unsigned long)self.mwSettings.numCopies] placeHolder:@"" decisionHandler:^(NSString * input) {
                wself.mwSettings.numCopies = [input integerValue];
            }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsPrintQuality"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"Best", @"Fast", ]
                                      values:@[@(BRLMPrintSettingsPrintQualityBest), @(BRLMPrintSettingsPrintQualityFast), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.mwSettings.printQuality = (BRLMPrintSettingsPrintQuality)[value integerValue];
                                      }];
        }

    }
    else if (self.tdSettings) {
                if ([title isEqualToString:@"BRLMPrintSettingsScaleMode"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"ActualSize", @"FitPageAspect", @"FitPaperAspect", @"ScaleValue", ]
                                      values:@[@(BRLMPrintSettingsScaleModeActualSize), @(BRLMPrintSettingsScaleModeFitPageAspect), @(BRLMPrintSettingsScaleModeFitPaperAspect), @(BRLMPrintSettingsScaleModeScaleValue), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.tdSettings.scaleMode = (BRLMPrintSettingsScaleMode)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsScaleValue"]) {
            [self showInputStringViewWithTitle:@"BRLMPrintSettingsScaleValue" message:[NSString stringWithFormat:@"%f",self.tdSettings.scaleValue] placeHolder:@"" decisionHandler:^(NSString * input) {
                wself.tdSettings.scaleValue = [input floatValue];
            }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsOrientation"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"Portrait", @"Landscape", ]
                                      values:@[@(BRLMPrintSettingsOrientationPortrait), @(BRLMPrintSettingsOrientationLandscape), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.tdSettings.printOrientation = (BRLMPrintSettingsOrientation)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsRotation"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"Rotate0", @"Rotate90", @"Rotate180", @"Rotate270", ]
                                      values:@[@(BRLMPrintSettingsRotationRotate0), @(BRLMPrintSettingsRotationRotate90), @(BRLMPrintSettingsRotationRotate180), @(BRLMPrintSettingsRotationRotate270), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.tdSettings.imageRotation = (BRLMPrintSettingsRotation)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsHalftone"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"Threshold", @"ErrorDiffusion", @"PatternDither", ]
                                      values:@[@(BRLMPrintSettingsHalftoneThreshold), @(BRLMPrintSettingsHalftoneErrorDiffusion), @(BRLMPrintSettingsHalftonePatternDither), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.tdSettings.halftone = (BRLMPrintSettingsHalftone)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsHorizontalAlignment"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"Left", @"Center", @"Right", ]
                                      values:@[@(BRLMPrintSettingsHorizontalAlignmentLeft), @(BRLMPrintSettingsHorizontalAlignmentCenter), @(BRLMPrintSettingsHorizontalAlignmentRight), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.tdSettings.hAlignment = (BRLMPrintSettingsHorizontalAlignment)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsVerticalAlignment"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"Top", @"Center", @"Bottom", ]
                                      values:@[@(BRLMPrintSettingsVerticalAlignmentTop), @(BRLMPrintSettingsVerticalAlignmentCenter), @(BRLMPrintSettingsVerticalAlignmentBottom), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.tdSettings.vAlignment = (BRLMPrintSettingsVerticalAlignment)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsCompressMode"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"None", @"Tiff", @"Mode9", ]
                                      values:@[@(BRLMPrintSettingsCompressModeNone), @(BRLMPrintSettingsCompressModeTiff), @(BRLMPrintSettingsCompressModeMode9), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.tdSettings.compress = (BRLMPrintSettingsCompressMode)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsHalftoneThreshold"]) {
            [self showInputStringViewWithTitle:@"BRLMPrintSettingsHalftoneThreshold" message:[NSString stringWithFormat:@"%lu",(unsigned long)self.tdSettings.halftoneThreshold] placeHolder:@"" decisionHandler:^(NSString * input) {
                wself.tdSettings.halftoneThreshold = (uint8_t)[input integerValue];
            }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsNumCopies"]) {
            [self showInputStringViewWithTitle:@"BRLMPrintSettingsNumCopies" message:[NSString stringWithFormat:@"%ld",(unsigned long)self.tdSettings.numCopies] placeHolder:@"" decisionHandler:^(NSString * input) {
                wself.tdSettings.numCopies = [input integerValue];
            }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsPrintQuality"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"Best", @"Fast", ]
                                      values:@[@(BRLMPrintSettingsPrintQualityBest), @(BRLMPrintSettingsPrintQualityFast), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.tdSettings.printQuality = (BRLMPrintSettingsPrintQuality)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMCustomPaperSize"]) {
            self.segueAction = ^(UIStoryboardSegue* segue) {
                BRLMInputCustomPaperSizeViewController *viewController = [segue destinationViewController];
                viewController.defaultSize = wself.tdSettings.customPaperSize;
                viewController.decisionHandler = ^(BRLMCustomPaperSize* customPaperSize) {
                    wself.tdSettings.customPaperSize = customPaperSize;
                };
            };
            [self performSegueWithIdentifier:@"BRLMInputCustomPaperSizeViewController" sender:self];
        }
        if ([title isEqualToString:@"BRLMTDPrintSettingsDensity"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"WeakLevel5", @"WeakLevel4", @"WeakLevel3", @"WeakLevel2", @"WeakLevel1", @"Neutral", @"StrongLevel1", @"StrongLevel2", @"StrongLevel3", @"StrongLevel4", @"StrongLevel5", @"UsePrinterSetting", ]
                                      values:@[@(BRLMTDPrintSettingsDensityWeakLevel5), @(BRLMTDPrintSettingsDensityWeakLevel4), @(BRLMTDPrintSettingsDensityWeakLevel3), @(BRLMTDPrintSettingsDensityWeakLevel2), @(BRLMTDPrintSettingsDensityWeakLevel1), @(BRLMTDPrintSettingsDensityNeutral), @(BRLMTDPrintSettingsDensityStrongLevel1), @(BRLMTDPrintSettingsDensityStrongLevel2), @(BRLMTDPrintSettingsDensityStrongLevel3), @(BRLMTDPrintSettingsDensityStrongLevel4), @(BRLMTDPrintSettingsDensityStrongLevel5), @(BRLMTDPrintSettingsDensityUsePrinterSetting), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.tdSettings.density = (BRLMTDPrintSettingsDensity)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsAutoCutForEachPageCount"]) {
            [self showInputStringViewWithTitle:@"BRLMPrintSettingsAutoCutForEachPageCount" message:[NSString stringWithFormat:@"%lu",(unsigned long)self.tdSettings.autoCutForEachPageCount] placeHolder:@"" decisionHandler:^(NSString * input) {
                wself.tdSettings.autoCutForEachPageCount = (uint8_t)[input integerValue];
            }];
        }

    }
    else if (self.rjSettings) {
                if ([title isEqualToString:@"BRLMPrintSettingsScaleMode"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"ActualSize", @"FitPageAspect", @"FitPaperAspect", @"ScaleValue", ]
                                      values:@[@(BRLMPrintSettingsScaleModeActualSize), @(BRLMPrintSettingsScaleModeFitPageAspect), @(BRLMPrintSettingsScaleModeFitPaperAspect), @(BRLMPrintSettingsScaleModeScaleValue), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.rjSettings.scaleMode = (BRLMPrintSettingsScaleMode)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsScaleValue"]) {
            [self showInputStringViewWithTitle:@"BRLMPrintSettingsScaleValue" message:[NSString stringWithFormat:@"%f",self.rjSettings.scaleValue] placeHolder:@"" decisionHandler:^(NSString * input) {
                wself.rjSettings.scaleValue = [input floatValue];
            }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsOrientation"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"Portrait", @"Landscape", ]
                                      values:@[@(BRLMPrintSettingsOrientationPortrait), @(BRLMPrintSettingsOrientationLandscape), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.rjSettings.printOrientation = (BRLMPrintSettingsOrientation)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsRotation"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"Rotate0", @"Rotate90", @"Rotate180", @"Rotate270", ]
                                      values:@[@(BRLMPrintSettingsRotationRotate0), @(BRLMPrintSettingsRotationRotate90), @(BRLMPrintSettingsRotationRotate180), @(BRLMPrintSettingsRotationRotate270), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.rjSettings.imageRotation = (BRLMPrintSettingsRotation)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsHalftone"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"Threshold", @"ErrorDiffusion", @"PatternDither", ]
                                      values:@[@(BRLMPrintSettingsHalftoneThreshold), @(BRLMPrintSettingsHalftoneErrorDiffusion), @(BRLMPrintSettingsHalftonePatternDither), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.rjSettings.halftone = (BRLMPrintSettingsHalftone)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsHorizontalAlignment"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"Left", @"Center", @"Right", ]
                                      values:@[@(BRLMPrintSettingsHorizontalAlignmentLeft), @(BRLMPrintSettingsHorizontalAlignmentCenter), @(BRLMPrintSettingsHorizontalAlignmentRight), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.rjSettings.hAlignment = (BRLMPrintSettingsHorizontalAlignment)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsVerticalAlignment"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"Top", @"Center", @"Bottom", ]
                                      values:@[@(BRLMPrintSettingsVerticalAlignmentTop), @(BRLMPrintSettingsVerticalAlignmentCenter), @(BRLMPrintSettingsVerticalAlignmentBottom), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.rjSettings.vAlignment = (BRLMPrintSettingsVerticalAlignment)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsCompressMode"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"None", @"Tiff", @"Mode9", ]
                                      values:@[@(BRLMPrintSettingsCompressModeNone), @(BRLMPrintSettingsCompressModeTiff), @(BRLMPrintSettingsCompressModeMode9), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.rjSettings.compress = (BRLMPrintSettingsCompressMode)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsHalftoneThreshold"]) {
            [self showInputStringViewWithTitle:@"BRLMPrintSettingsHalftoneThreshold" message:[NSString stringWithFormat:@"%lu",(unsigned long)self.rjSettings.halftoneThreshold] placeHolder:@"" decisionHandler:^(NSString * input) {
                wself.rjSettings.halftoneThreshold = (uint8_t)[input integerValue];
            }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsNumCopies"]) {
            [self showInputStringViewWithTitle:@"BRLMPrintSettingsNumCopies" message:[NSString stringWithFormat:@"%ld",(unsigned long)self.rjSettings.numCopies] placeHolder:@"" decisionHandler:^(NSString * input) {
                wself.rjSettings.numCopies = [input integerValue];
            }];
        }
        if ([title isEqualToString:@"BRLMPrintSettingsPrintQuality"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"Best", @"Fast", ]
                                      values:@[@(BRLMPrintSettingsPrintQualityBest), @(BRLMPrintSettingsPrintQualityFast), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.rjSettings.printQuality = (BRLMPrintSettingsPrintQuality)[value integerValue];
                                      }];
        }
        if ([title isEqualToString:@"BRLMCustomPaperSize"]) {
            self.segueAction = ^(UIStoryboardSegue* segue) {
                BRLMInputCustomPaperSizeViewController *viewController = [segue destinationViewController];
                viewController.defaultSize = wself.rjSettings.customPaperSize;
                viewController.decisionHandler = ^(BRLMCustomPaperSize* customPaperSize) {
                    wself.rjSettings.customPaperSize = customPaperSize;
                };
            };
            [self performSegueWithIdentifier:@"BRLMInputCustomPaperSizeViewController" sender:self];
        }
        if ([title isEqualToString:@"BRLMRJPrintSettingsDensity"]) {
            [self showInputEnumViewWithTitle:title
                                      labels:@[@"WeakLevel5", @"WeakLevel4", @"WeakLevel3", @"WeakLevel2", @"WeakLevel1", @"Neutral", @"StrongLevel1", @"StrongLevel2", @"StrongLevel3", @"StrongLevel4", @"StrongLevel5", @"UsePrinterSetting", ]
                                      values:@[@(BRLMRJPrintSettingsDensityWeakLevel5), @(BRLMRJPrintSettingsDensityWeakLevel4), @(BRLMRJPrintSettingsDensityWeakLevel3), @(BRLMRJPrintSettingsDensityWeakLevel2), @(BRLMRJPrintSettingsDensityWeakLevel1), @(BRLMRJPrintSettingsDensityNeutral), @(BRLMRJPrintSettingsDensityStrongLevel1), @(BRLMRJPrintSettingsDensityStrongLevel2), @(BRLMRJPrintSettingsDensityStrongLevel3), @(BRLMRJPrintSettingsDensityStrongLevel4), @(BRLMRJPrintSettingsDensityStrongLevel5), @(BRLMRJPrintSettingsDensityUsePrinterSetting), ]
                             decisionHandler:^(NSString* label, NSNumber* value) {
                wself.rjSettings.density = (BRLMRJPrintSettingsDensity)[value integerValue];
                                      }];
        }

    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    __weak BRLMPrintSettingTableViewController* wself = self;
    self.segueAction = ^(UIStoryboardSegue* segue) {
        BRLMPrintSettingsValidateViewController *viewController = [segue destinationViewController];
        id setting = nil;
        if(wself.qlSettings) {setting = wself.qlSettings;}
        if(wself.ptSettings) {setting = wself.ptSettings;}
        if(wself.pjSettings) {setting = wself.pjSettings;}
        if(wself.mwSettings) {setting = wself.mwSettings;}
        if(wself.tdSettings) {setting = wself.tdSettings;}
        if(wself.rjSettings) {setting = wself.rjSettings;}
        viewController.report = [BRLMValidatePrintSettings validate:setting];
    };
    [self performSegueWithIdentifier:@"BRLMPrintSettingsValidateViewController" sender:self];
}

#pragma mark - Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.segueAction(segue);
}

- (void)showInputStringViewWithTitle:(NSString*)title message:(NSString *)message placeHolder:(NSString *)placeHolder decisionHandler:(void(^)(NSString*)) handler {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = placeHolder;
        textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        handler(alert.textFields.firstObject.text);
        [self.tableView reloadData];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {}]];
    [self presentViewController:alert animated:YES completion:^{}];
}

- (void)showInputEnumViewWithTitle:(NSString*)title labels:(NSArray<NSString*>*)labels values:(NSArray<NSNumber*>*)values decisionHandler:(void(^)(NSString* label, NSNumber* value)) handler {
    __weak BRLMPrintSettingTableViewController* wself = self;
    self.segueAction = ^(UIStoryboardSegue* segue) {
        BRLMSelectNumberViewController *viewController = [segue destinationViewController];
        viewController.labels = labels;
        viewController.values = values;
        viewController.title = title;
        viewController.decisionHandler = ^(NSString* label, NSNumber* value) {
            handler(label, value);
            [wself.navigationController popViewControllerAnimated:YES];
        };
    };
    [self performSegueWithIdentifier:@"BRLMSelectNumberViewController" sender:self];
}

- (void)setInputBoolViewWithTitle:(NSString*)title switchView:(UISwitch*)switchView changeHandler:(void(^)(BOOL value)) handler {
    BRLMSwitchEventHandler* eventHandler = [[BRLMSwitchEventHandler alloc] initWithHandler:^(BOOL value) {
        handler(value);
    }];
    self.switchEventHandlers[title] = eventHandler;
    [switchView addTarget:eventHandler action:@selector(perform:) forControlEvents:UIControlEventValueChanged];
}
    
- (NSString*)shortenTitle:(NSString*)title {
    title = [title stringByReplacingOccurrencesOfString:@"PrintSettings" withString:@""];
    title = [title stringByReplacingOccurrencesOfString:@"BRLM" withString:@""];
    return title;
}
@end


@implementation BRLMSwitchEventHandler
-(instancetype)initWithHandler:(BRLMSwitchEventHandlerValueChanged)handler
{
    self = [super init];
    if (self) {
        self.handler = handler;
    }
    return self;
}
- (void)perform:(id)sender {
    if (![sender isKindOfClass:[UISwitch class]]) {
        NSAssert(false, @"BRLMSwitchEventHandler sender is not kind of class UISwitch.");
        return;
    }
    
    UISwitch* switchui = sender;
    
    self.handler(switchui.on);
}
@end