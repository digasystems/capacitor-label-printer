//
//  BRBluetoothPrintOperation.m
//  SDK_Sample_Ver2
//
//  Copyright © 2015 Brother Industries, Ltd. All rights reserved.
//

#import "UserDefaults.h"
#import "BRBluetoothPrintOperation.h"

@interface BRBluetoothPrintOperation ()
{
}
@property(nonatomic, assign) BOOL isExecutingForBT;
@property(nonatomic, assign) BOOL isFinishedForBT;
// override properties in NSOperation
@property(nonatomic, assign) BOOL isExecuting;
@property(nonatomic, assign) BOOL isFinished;

@property(nonatomic, strong) BRLMChannel    *channel;
@property(nonatomic, strong) BRLMPrinterDriver    *ptp;
@property(nonatomic, strong) id<BRLMPrintSettingsProtocol> printInfo;
@property(nonatomic, strong) NSArray *imagePathArray;
@property(nonatomic, strong) NSString           *serialNumber;
@property(nonatomic, strong) NSString           *customPaperFilePath;

@end


@implementation BRBluetoothPrintOperation

- (id)initWithOperation:(BRLMChannel *)targetPtp
              printInfo:(id<BRLMPrintSettingsProtocol>)targetPrintInfo
                 images:(NSArray *)targetImgPathArray
           serialNumber:(NSString *)targetSerialNumber
{
    self = [super init];
    if (self) {
        self.channel            = targetPtp;
        self.printInfo      = targetPrintInfo;
        self.imagePathArray = targetImgPathArray;
        self.serialNumber   = targetSerialNumber;
    }
    
    return self;
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString*)key
{
    if (
        [key isEqualToString:@"communicationResultForBT"]   ||
        [key isEqualToString:@"isExecutingForBT"]           ||
        [key isEqualToString:@"isFinishedForBT"])
    {
        return YES;
    }
    return [super automaticallyNotifiesObserversForKey:key];
}

- (void)start
{
     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.isExecutingForBT = YES;
    
    BRLMPrinterDriverGenerateResult* result = [BRLMPrinterDriverGenerator openChannel:self.channel];
    
    if (result.error.code == BRLMOpenChannelErrorCodeNoError) {
        self.ptp = result.driver;
        
        NSString *selectedPDFFilePath = [userDefaults objectForKey:kSelectedPDFFilePath];
        BRLMPrintError* error;
        if (![selectedPDFFilePath isEqualToString:@"0"]) {
            error = [self.ptp printPDFWithURL:[NSURL fileURLWithPath:selectedPDFFilePath] settings:self.printInfo];
        }
        else if (self.imagePathArray) {
            if (self.imagePathArray.count == 1) {
                NSString *path = [self.imagePathArray objectAtIndex:0];
                UIImage *image = [UIImage imageWithContentsOfFile:path];
                error = [self.ptp printImageWithImage:image.CGImage settings:self.printInfo];
            } else if (self.imagePathArray.count > 1) {
                NSMutableArray* urlArray = [NSMutableArray array];
                for (NSString* path in self.imagePathArray) {
                    [urlArray addObject:[NSURL fileURLWithPath:path]];
                }
                error = [self.ptp printImageWithURLs:urlArray settings:self.printInfo];
            }
        }
        NSString* printResult = error.description;
        [userDefaults setObject:[NSString stringWithFormat:@"%@", printResult] forKey:kPrintResultForBT];
    } else {
        [userDefaults setObject:[NSString stringWithFormat:@"BRLMOpenChannelErrorCode = %ld", (long)result.error.code] forKey:kPrintResultForBT];
        
    }
    if ([self.delegate respondsToSelector:@selector(showPrintResultForBluetooth)]) {
        [self.delegate showPrintResultForBluetooth];
    }
   [self.ptp closeChannel];


    self.isExecutingForBT = NO;
    self.isFinishedForBT = YES;
}

- (void)cancelPrinting {
    [self.ptp cancelPrinting];
}

- (void)setIsExecutingForBT:(BOOL)isExecutingForBT
{
    if (_isExecutingForBT != isExecutingForBT) {
        _isExecutingForBT = isExecutingForBT;
        self.isExecuting = isExecutingForBT;
    }
}

- (void)setIsFinishedForBT:(BOOL)isFinishedForBT
{
    if (_isFinishedForBT != isFinishedForBT) {
        _isFinishedForBT = isFinishedForBT;
        self.isFinished = isFinishedForBT;
    }
}

@end
