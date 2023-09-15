//
//  BRFileManager.h
//  SDK_Sample_Ver2
//
//  Copyright © 2017 Brother Industries, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface BRFileManager : NSObject

+ (BRFileManager *)sharedManager;

- (NSString *)generateTemporaryPath:(NSString *)ext;

// save as png
- (BOOL)saveImage:(UIImage *)image path:(NSString *)path;
- (BOOL)removeFile:(NSString *)path;

@end
