//
//  BRBluetoothPrintOperation.h
//  SDK_Sample_Ver2
//
//  Copyright © 2015 Brother Industries, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BRLMPrinterKit/BRLMPrinterKit.h>

@protocol BRBluetoothPrintOperationDelegate <NSObject>
- (void) showPrintResultForBluetooth;
@end

@interface BRBluetoothPrintOperation : NSOperation
{
}
@property (nonatomic, weak)id<BRBluetoothPrintOperationDelegate> delegate;
@property(nonatomic, assign) BOOL communicationResultForBT;

- (id)initWithOperation:(BRLMChannel *)targetPtp
              printInfo:(id<BRLMPrintSettingsProtocol>)targetPrintInfo
                 images:(NSArray *)targetImgPathArray
           serialNumber:(NSString *)targetSerialNumber;

- (void)cancelPrinting;

@end
