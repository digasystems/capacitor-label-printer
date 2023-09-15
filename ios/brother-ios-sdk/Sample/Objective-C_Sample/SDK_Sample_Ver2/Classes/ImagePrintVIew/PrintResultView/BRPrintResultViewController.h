//
//  BRPrintResultViewController.h
//  SDK_Sample_Ver2
//
//  Copyright © 2015 Brother Industries, Ltd. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BRWLANPrintOperation.h"
#import "BRBluetoothPrintOperation.h"
#import "BRBLEPrintOperation.h"

@protocol BRPrintResultViewControllerDelegate <NSObject>
- (void) showPrintResultForWLAN;
- (void) showPrintResultForBluetooth;
@end

@interface BRPrintResultViewController : UIViewController<BRWLANPrintOperationDelegate, BRBluetoothPrintOperationDelegate, BRBLEPrintOperationDelegate>
{
}
@property (nonatomic, weak)id<BRPrintResultViewControllerDelegate> delegate;
@property (nonatomic, strong)NSArray *imagePathArray;

- (void)cancelPrinting;

@end
