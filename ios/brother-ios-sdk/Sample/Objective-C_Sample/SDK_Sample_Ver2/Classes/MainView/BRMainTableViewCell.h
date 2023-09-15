//
//  BRMainViewCellTableViewCell.h
//  SDK_Sample_Ver2
//
//  Copyright © 2015 Brother Industries, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BRMainTableViewCell : UITableViewCell
{
}

@property (nonatomic, weak) IBOutlet UIImageView *image;
@property (nonatomic, weak) IBOutlet UILabel *label;
@property (nonatomic, weak) IBOutlet UIImageView *backgroundImage;

@property (nonatomic, strong) NSNumber *cellID;
@end
