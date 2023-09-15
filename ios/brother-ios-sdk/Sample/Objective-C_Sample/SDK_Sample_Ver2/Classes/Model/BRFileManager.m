//
//  BRFileManager.m
//  SDK_Sample_Ver2
//
//  Copyright © 2017 Brother Industries, Ltd. All rights reserved.
//

#import "BRFileManager.h"

static BRFileManager *sharedInstance;

@implementation BRFileManager

+ (BRFileManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BRFileManager alloc] init];
    });
    return sharedInstance;
}

- (NSString *)generateTemporaryPath:(NSString *)ext {
    NSUUID *uuid = [NSUUID new];
    NSString *name = [uuid.UUIDString stringByAppendingPathExtension:ext];
    return [NSTemporaryDirectory() stringByAppendingPathComponent:name];
}

- (BOOL)saveImage:(UIImage *)image path:(NSString *)path {
    NSData *data = UIImagePNGRepresentation(image);
    return [data writeToFile:path atomically:YES];
}

- (BOOL)removeFile:(NSString *)path {
    return [NSFileManager.defaultManager removeItemAtPath:path error:nil];
}

@end
