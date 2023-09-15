//
//  BRLMSelectNumberViewController.h
//  SDK_Sample_Ver2
//
//  Copyright © 2015 Brother Industries, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BRLMSelectNumberViewController : UITableViewController
@property (nonatomic) NSArray<NSString*>* labels;
@property (nonatomic) NSArray<NSNumber*>* values;
@property (nonatomic) void (^decisionHandler)(NSString* label, NSNumber* value);
@end

NS_ASSUME_NONNULL_END
