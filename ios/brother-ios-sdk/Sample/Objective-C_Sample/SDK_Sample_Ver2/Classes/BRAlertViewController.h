//
//  BRAlertViewController.h
//  BrotherMobile BSH
//
//  Copyright © 2015 Brother Industries, Ltd. All rights reserved.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BRAlertViewControllerAlertViewCancelBehavior) {
    BRAlertViewControllerAlertViewCancelBehaviorCancelAction,
    BRAlertViewControllerAlertViewCancelBehaviorOtherAction,
    BRAlertViewControllerAlertViewCancelBehaviorNoOperation,
};

@interface BRAlertViewController : NSObject<UIAlertViewDelegate>

- (instancetype)initWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
           cancelButtonAction:(void (^)(UIAlertView* alertView))cancelButtonAction
            otherButtonTitles:(NSString *)otherButtonTitle
            otherButtonAction:(void (^)(UIAlertView* alertView))otherButtonAction;

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
            cancelButtonTitle:(NSString *)cancelButtonTitle
           cancelButtonAction:(void (^)(UIAlertView* alertView))cancelButtonAction
            otherButtonTitles:(NSString *)otherButtonTitle
            otherButtonAction:(void (^)(UIAlertView* alertView))otherButtonAction;

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                        style:(UIAlertViewStyle)style
            cancelButtonTitle:(NSString *)cancelButtonTitle
           cancelButtonAction:(void (^)(UIAlertView* alertView))cancelButtonAction
            otherButtonTitles:(NSString *)otherButtonTitle
            otherButtonAction:(void (^)(UIAlertView* alertView))otherButtonAction;

- (void) showAlertView;

@property (nonatomic) BRAlertViewControllerAlertViewCancelBehavior alertViewCancelBehavior;

- (instancetype)init __attribute__((unavailable("init is not available")));
@end
