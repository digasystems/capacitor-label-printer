//
//  BRTemplatePrintViewController.h
//  SDK_Sample_Ver2
//
//  Copyright (c) 2018 Brother Industries, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRTemplateEncodingTableViewController.h"

@interface BRTemplatePrintViewController : UITableViewController <BRTemplateEncodingTableViewControllerDelegate, UITextFieldDelegate>

+ (instancetype)makeInstance;

@end
