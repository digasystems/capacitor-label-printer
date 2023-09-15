//
//  BRMainTableViewItem.h
//  SDK_Sample_Ver2
//
//  Copyright © 2015 Brother Industries, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BRMainTableViewItem : NSObject
{
}

@property(nonatomic, strong) NSNumber *itemID;
@property(nonatomic, strong) UIImage  *image;
@property(nonatomic, strong) UIImage  *highlightedImage;
@property(nonatomic, strong) NSString *labelName;

@end
