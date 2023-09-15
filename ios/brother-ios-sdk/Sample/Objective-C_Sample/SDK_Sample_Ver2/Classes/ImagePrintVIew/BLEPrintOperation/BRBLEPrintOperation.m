//
//  BRBLEPrintOperation.m
//  SDK_Sample_Ver2
//
//  Copyright (c) 2018 Brother Industries, Ltd. All rights reserved.
//

#import "UserDefaults.h"
#import "BRBLEPrintOperation.h"

@interface BRBLEPrintOperation ()
{
}
@property(nonatomic, assign) BOOL isExecutingForBLE;
@property(nonatomic, assign) BOOL isFinishedForBLE;

// override properties in NSOperation
@property(nonatomic, assign) BOOL isExecuting;
@property(nonatomic, assign) BOOL isFinished;

@property(nonatomic, strong) BRLMChannel* channel;
@property(nonatomic, strong) BRLMPrinterDriver* ptp;
@property(nonatomic, strong) id<BRLMPrintSettingsProtocol> printInfo;
@property(nonatomic, strong) NSArray* imagePathArray;
@property(nonatomic, strong) NSString* localName;
@property(nonatomic, strong) NSString* customPaperFilePath;
@end

@implementation BRBLEPrintOperation

- (id)initWithOperation:(BRLMChannel*)targetPtp
              printInfo:(id<BRLMPrintSettingsProtocol>)targetPrintInfo
                 images:(NSArray*)targetImgPathArray
     advertiseLocalName:(NSString*)targetLocalName
{
    self = [super init];
    if (self) {
        self.channel            = targetPtp;
        self.printInfo      = targetPrintInfo;
        self.imagePathArray = targetImgPathArray;
        self.localName      = targetLocalName;
    }
    
    return self;
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString*)key
{
    if ([key isEqualToString:@"communicationResultForBLE"] ||
        [key isEqualToString:@"isExecutingForBLE"]         ||
        [key isEqualToString:@"isFinishedForBLE"]) {
        return YES;
    }
    return [super automaticallyNotifiesObserversForKey:key];
}

- (void)start
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.isExecutingForBLE = YES;
    
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
        [userDefaults setObject:[NSString stringWithFormat:@"%@", printResult] forKey:kPrintResultForBLE];
    }
    else {
        [userDefaults setObject:[NSString stringWithFormat:@"BRLMOpenChannelErrorCode = %ld", (long)result.error.code] forKey:kPrintResultForBLE];
    }
    if ([self.delegate respondsToSelector:@selector(showPrintResultForBLE)]) {
        [self.delegate showPrintResultForBLE];
    }
    [self.ptp closeChannel];

    self.isExecutingForBLE = NO;
    self.isFinishedForBLE = YES;
}

- (void)cancelPrinting {
    [self.ptp cancelPrinting];
}

- (void)setIsExecutingForBLE:(BOOL)isExecutingForBLE
{
    if (_isExecutingForBLE != isExecutingForBLE) {
        _isExecutingForBLE = isExecutingForBLE;
        self.isExecuting = isExecutingForBLE;
    }
}

- (void)setIsFinishedForBLE:(BOOL)isFinishedForBLE
{
    if (_isFinishedForBLE != isFinishedForBLE) {
        _isFinishedForBLE = isFinishedForBLE;
        self.isFinished = isFinishedForBLE;
    }
}

@end
