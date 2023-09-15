//
//  BRBLEPrintOperation.h
//  SDK_Sample_Ver2
//
//  Copyright (c) 2018 Brother Industries, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BRLMPrinterKit/BRLMPrinterKit.h>

@protocol BRBLEPrintOperationDelegate <NSObject>
- (void) showPrintResultForBLE;
@end

@interface BRBLEPrintOperation : NSOperation

@property (nonatomic, weak)id<BRBLEPrintOperationDelegate> delegate;
@property(nonatomic, assign) BOOL communicationResultForBLE;

- (id)initWithOperation:(BRLMChannel *)targetPtp
              printInfo:(id<BRLMPrintSettingsProtocol>)targetPrintInfo
                 images:(NSArray *)targetImgPathArray
              advertiseLocalName:(NSString *)localName;

- (void)cancelPrinting;

@end

