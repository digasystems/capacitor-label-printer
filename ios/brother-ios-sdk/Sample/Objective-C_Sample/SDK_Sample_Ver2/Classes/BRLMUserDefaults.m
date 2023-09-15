//
//  BRLMUserDefaults.m
//  SDK_Sample_Ver2
//
//  Copyright © 2015 Brother Industries, Ltd. All rights reserved.
//

#import "BRLMUserDefaults.h"

static BRLMUserDefaults *sharedBRLMUserDefaults_ = nil;

@implementation BRLMUserDefaults
+ (BRLMUserDefaults *)sharedDefaults {
    @synchronized(self){
        if (!sharedBRLMUserDefaults_) {
            sharedBRLMUserDefaults_ = [BRLMUserDefaults new];
        }
    }
    return sharedBRLMUserDefaults_;
}

- (void)setQlSettings:(BRLMQLPrintSettings *)qlSettings {
    [self saveObject:qlSettings forKey:@"BRLMQLPrintSettings"];
}
- (BRLMQLPrintSettings *)qlSettings {
    return [self loadObject:[BRLMQLPrintSettings class] ForKey:@"BRLMQLPrintSettings"];
}

- (void)setPtSettings:(BRLMPTPrintSettings *)ptSettings {
    [self saveObject:ptSettings forKey:@"BRLMPTPrintSettings"];
}
- (BRLMPTPrintSettings *)ptSettings {
    return [self loadObject:[BRLMPTPrintSettings class] ForKey:@"BRLMPTPrintSettings"];
}

- (void)setPjSettings:(BRLMPJPrintSettings *)pjSettings {
    [self saveObject:pjSettings forKey:@"BRLMPJPrintSettings"];
}
- (BRLMPJPrintSettings *)pjSettings {
    return [self loadObject:[BRLMPJPrintSettings class] ForKey:@"BRLMPJPrintSettings"];
}

- (void)setMwSettings:(BRLMMWPrintSettings *)mwSettings {
    [self saveObject:mwSettings forKey:@"BRLMMWPrintSettings"];
}
- (BRLMMWPrintSettings *)mwSettings {
    return [self loadObject:[BRLMMWPrintSettings class] ForKey:@"BRLMMWPrintSettings"];
}

- (void)setTdSettings:(BRLMTDPrintSettings *)tdSettings {
    [self saveObject:tdSettings forKey:@"BRLMTDPrintSettings"];
}
- (BRLMTDPrintSettings *)tdSettings {
    return [self loadObject:[BRLMTDPrintSettings class] ForKey:@"BRLMTDPrintSettings"];
}

- (void)setRjSettings:(BRLMRJPrintSettings *)rjSettings {
    [self saveObject:rjSettings forKey:@"BRLMRJPrintSettings"];
}
- (BRLMRJPrintSettings *)rjSettings {
    return [self loadObject:[BRLMRJPrintSettings class] ForKey:@"BRLMRJPrintSettings"];
}

- (void)saveObject:(id<NSCoding>)object forKey:(NSString*)key{
    if(object == nil) {
        return;
    }
    NSUserDefaults *userDefaults    = [NSUserDefaults standardUserDefaults];
    NSMutableData* mutabledata = [[NSMutableData alloc] init];
    NSKeyedArchiver* coder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:mutabledata];
    [object encodeWithCoder:coder];
    [userDefaults setObject:coder.encodedData forKey:key];
}

- (id)loadObject:(Class)class ForKey:(NSString*)key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData* settingData = [userDefaults dataForKey:key];
    if(settingData == nil) {
        return nil;
    }
    NSCoder* decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:settingData];
    return [[class alloc] initWithCoder:decoder];
}
@end
