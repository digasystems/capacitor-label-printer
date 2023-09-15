//
//  BRLMInputCustomPaperSizeViewController.h
//  SDK_Sample_Ver2
//
//  Copyright © 2015 Brother Industries, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BRLMPrinterKit/BRLMPrinterKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BRLMInputCustomPaperSizeViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) BRLMCustomPaperSize* defaultSize;
@property (nonatomic) void (^decisionHandler)(BRLMCustomPaperSize* customPaperSize);
@end

NS_ASSUME_NONNULL_END
