//
//  BRPrinterSettingItemSelectTableViewController.h
//  SDK_Sample_Ver2
//
//  Copyright © 2017 Brother Industries, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BRLMPrinterKit/BRPtouchPrinterKit.h>

typedef void (^BRPrinterSettingItemSelectTableViewControllerCompletionHandler)(NSArray* require);

@interface BRPrinterSettingItemSelectTableViewController : UITableViewController
@property (nonatomic, strong) BRPrinterSettingItemSelectTableViewControllerCompletionHandler completionHandler;

+ (NSString*)titleForPrinterSettingItem:(PrinterSettingItem)printerSettingItem;
@end
