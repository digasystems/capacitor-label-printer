//
//  NSDate+Formatter.m
//  SDK_Sample_Ver2
//
//  Copyright (c) 2018 Brother Industries, Ltd. All rights reserved.
//

#import "NSDate+Formatter.h"

@implementation NSDate (Formatter)

- (NSString *)dateStringWithFormat:(NSString *)formatString {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = formatString;

    return [dateFormatter stringFromDate:self];
}

@end
