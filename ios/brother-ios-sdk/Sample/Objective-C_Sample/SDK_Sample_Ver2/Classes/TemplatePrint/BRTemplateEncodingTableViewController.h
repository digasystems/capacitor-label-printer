//
//  BRTemplateEncodingTableViewController.h
//  SDK_Sample_Ver2
//
//  Copyright (c) 2018 Brother Industries, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TemplateEncoding) {
    EnglishEncoding = 0,
    JapaneseEncoding,
    ChineseEncoding,
};

@protocol BRTemplateEncodingTableViewControllerDelegate <NSObject>
@optional
- (void)templateEncodingTableView:(UITableViewController *)tableView didSelectTemplateEncoding:(TemplateEncoding)encoding;
@end

@interface BRTemplateEncodingTableViewController : UITableViewController
@property (weak, nonatomic) id <BRTemplateEncodingTableViewControllerDelegate> delegate;
+ (instancetype)makeInstance;
@end

@interface BRTemplateEncodingUtil : NSObject
+ (NSString *)stringFromTemplateEncoding:(TemplateEncoding)encoding;
@end
