//
//  BRImagePrintViewItemCreator.h
//  SDK_Sample_Ver2
//
//  Copyright © 2015 Brother Industries, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRImagePrintTablesViewItem.h"

typedef enum {
    searchDeviceForWiFi = 1,
    searchDeviceForMFi,
    searchDeviceForBLE,
    rootPrintSetting
} BRImagePrintTablesViewItemEnum;

@interface BRImagePrintTablesViewItemCreator : NSObject
{
}

- (BRImagePrintTablesViewItem *)selectedImagePrintTablesViewItem:(NSInteger)tag tableSection:(NSInteger)section;
- (NSMutableArray *)createImagePrintTablesViewItems;
@end
