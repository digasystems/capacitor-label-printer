//
//  UIColor+CompatiColor.m
//  SDK_Sample_Ver2
//
//  Created by Yu Matsuo on 18/11/20.
//

#import "UIColor+CompatiColor.h"

@implementation UIColor (CompatiColor)

+ (UIColor *)systemBackgroundColorCompati {
    if(@available(iOS 13.0, *)) {
        return UIColor.systemBackgroundColor;
    }
    return UIColor.whiteColor;
}

+ (UIColor *)systemGray2ColorCompati {
    if(@available(iOS 13.0, *)) {
        return UIColor.systemGray2Color;
    }
    return [[UIColor alloc] initWithRed:174.0/255.0 green:174.0/255.0 blue:178.0/255.0 alpha:1.0];
}
+ (UIColor *)labelColorCompati {
    if(@available(iOS 13.0, *)) {
        return UIColor.labelColor;
    }
    return UIColor.blackColor;
}
@end
