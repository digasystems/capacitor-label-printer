//
//  BRSetStringTableViewController.h
//  SDK_Sample_Ver2
//
//  Copyright © 2017 Brother Industries, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BRSetStringTableViewControllerCompletionHandler)(NSDictionary* result);

@interface BRSetStringTableViewController : UITableViewController

@property (nonatomic, strong) BRSetStringTableViewControllerCompletionHandler completionHandler;
@property (nonatomic, strong) NSArray* require;

@property (nonatomic, strong) NSMutableDictionary* result;
@end
