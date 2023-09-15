//
//  BRLMPrintSettingsValidateViewController.h
//  SDK_Sample_Ver2
//
//  Created by Yu Matsuo on 27/2/20.
//

#import <UIKit/UIKit.h>
#import <BRLMPrinterKit/BRLMPrinterKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BRLMPrintSettingsValidateViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) BRLMValidatePrintSettingsReport* report;
@end

NS_ASSUME_NONNULL_END
