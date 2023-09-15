//
//  BRWLANPrintOperation.m
//  SDK_Sample_Ver2
//
//  Copyright © 2015 Brother Industries, Ltd. All rights reserved.
//

#import "UserDefaults.h"
#import "BRWLANPrintOperation.h"
#import <BRLMPrinterKit/BRLMPrinterKit.h>

@interface BRWLANPrintOperation ()
{
}
@property(nonatomic, assign) BOOL isExecutingForWLAN;
@property(nonatomic, assign) BOOL isFinishedForWLAN;

// override properties in NSOperation
@property(nonatomic, assign) BOOL isExecuting;
@property(nonatomic, assign) BOOL isFinished;

@property(nonatomic, strong) BRLMChannel    *channel;
@property(nonatomic, strong) BRLMPrinterDriver    *ptp;
@property(nonatomic, strong) id<BRLMPrintSettingsProtocol> printInfo;
@property(nonatomic, strong) NSArray *imagePathArray;
@property(nonatomic, strong) NSString           *ipAddress;
@property(nonatomic, strong) NSString           *customPaperFilePath;
@end

@implementation BRWLANPrintOperation

- (id)initWithOperation:(BRLMChannel *)targetPtp
              printInfo:(id<BRLMPrintSettingsProtocol>)targetPrintInfo
                 images:(NSArray *)targetImgPathArray
              ipAddress:(NSString *)targetIPAddress
{
    self = [super init];
    if (self) {
        self.channel        = targetPtp;
        self.printInfo      = targetPrintInfo;
        self.imagePathArray = targetImgPathArray;
        self.ipAddress      = targetIPAddress;
    }
    self.isExecutingForWLAN = NO;
    self.isFinishedForWLAN = NO;

    
    return self;
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString*)key
{
    if ([key isEqualToString:@"communicationResultForWLAN"] ||
        [key isEqualToString:@"isExecutingForWLAN"]         ||
        [key isEqualToString:@"isFinishedForWLAN"]) {
        return YES;
    }
    return [super automaticallyNotifiesObserversForKey:key];
}

- (void)setIsExecutingForWLAN:(BOOL)isExecutingForWLAN
{
    if (_isExecutingForWLAN != isExecutingForWLAN) {
        _isExecutingForWLAN = isExecutingForWLAN;
        self.isExecuting = isExecutingForWLAN;
    }
}

- (void)setIsFinishedForWLAN:(BOOL)isFinishedForWLAN
{
    if (_isFinishedForWLAN != isFinishedForWLAN) {
        _isFinishedForWLAN = isFinishedForWLAN;
        self.isFinished = isFinishedForWLAN;
    }
}


- (void)start
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.isExecutingForWLAN = YES;
    
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
        [userDefaults setObject:[NSString stringWithFormat:@"%@", printResult] forKey:kPrintResultForWLAN];
    }
    else {
        [userDefaults setObject:[NSString stringWithFormat:@"BRLMOpenChannelErrorCode = %ld", (long)result.error.code] forKey:kPrintResultForWLAN];
    }
    if ([self.delegate respondsToSelector:@selector(showPrintResultForWLAN)]) {
        [self.delegate showPrintResultForWLAN];
    }
    [self.ptp closeChannel];

    self.isExecutingForWLAN = NO;
    self.isFinishedForWLAN = YES;
}


- (void)cancelPrinting {
    [self.ptp cancelPrinting];
}

- (void)dealloc
{
    NSLog(@"BRWLANPrintOperarion dealloc");
}

@end
