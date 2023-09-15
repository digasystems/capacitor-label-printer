//
//  BRTemplatePrintProcessItem.h
//  SDK_Sample_Ver2
//
//  Copyright (c) 2018 Brother Industries, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

// This order depends on storyboard.
typedef NS_ENUM(NSUInteger, TemplateObjectReplacementMode) {
    TemplateObjectReplacementModeText = 0,
    TemplateObjectReplacementModeIndex,
    TemplateObjectReplacementModeObjectName
};

@interface BRTemplatePrintProcessItem : NSObject
@property (nonatomic) int key;
@property (nonatomic) TemplateObjectReplacementMode mode;
@property (nonatomic) int objectIndex;
@property (nonatomic) NSString *objectName;
@property (nonatomic) NSString *replacementText;
@end
