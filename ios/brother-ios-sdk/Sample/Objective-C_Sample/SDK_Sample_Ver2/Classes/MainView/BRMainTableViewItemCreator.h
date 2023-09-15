//
//  BRMainTableViewItemCreator.h
//  SDK_Sample_Ver2
//
//  Copyright © 2015 Brother Industries, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ImagePrint = 1,
    SendData,
    TemplatePrint,
    ManageTemplate,
    Utility,
    Info
} BRMainTableViewItemEnum;

@interface BRMainTableViewItemCreator : NSObject
{
}

- (NSMutableArray *)createMainTableViewItems;

@end
