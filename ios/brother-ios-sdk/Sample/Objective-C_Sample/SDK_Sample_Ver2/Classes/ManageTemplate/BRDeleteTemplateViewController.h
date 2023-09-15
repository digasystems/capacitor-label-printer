//
//  BRDeleteTemplateViewController.h
//  SDK_Sample_Ver2
//
//  Copyright (c) 2018 Brother Industries, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BRDeleteTemplateViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

+ (instancetype)makeInstance;

@end
