//
//  BRLMPaperSizePJTableViewController.h
//  SDK_Sample_Ver2
//
//  Copyright © 2015 Brother Industries, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BRLMPrinterKit/BRLMPrinterKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BRLMPaperSizePJTableViewController : UITableViewController
@property (nonatomic) BRLMPJPrintSettingsPaperSize* defaultPaperSizePJ;
@property (nonatomic) void (^decisionHandler)(BRLMPJPrintSettingsPaperSize* paperSizePJ);
@end

NS_ASSUME_NONNULL_END
