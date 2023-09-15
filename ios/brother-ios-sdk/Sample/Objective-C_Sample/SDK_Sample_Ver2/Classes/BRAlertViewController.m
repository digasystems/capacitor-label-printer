//
//  BRAlertViewController.m
//  BrotherMobile BSH
//
//  Copyright © 2015 Brother Industries, Ltd. All rights reserved.
//
//
#if !__has_feature(objc_arc)
#error This class maid in ARC.
#endif

#import "BRAlertViewController.h"

@interface BRAlertViewController()
@property (nonatomic,strong) UIAlertView* alertView;
@property (nonatomic,copy) void (^cancelButtonAction)(UIAlertView* alertView) ;
@property (nonatomic,copy) void (^otherButtonAction)(UIAlertView* alertView) ;
@end

@implementation BRAlertViewController

- (instancetype)initWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
           cancelButtonAction:(void (^)(UIAlertView* actionSheet))cancelButtonAction
            otherButtonTitles:(NSString *)otherButtonTitle
            otherButtonAction:(void (^)(UIAlertView* actionSheet))otherButtonAction
{
    self = [super init];
    if (self) {
        _alertView = [[UIAlertView alloc] initWithTitle:@"" message:title delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitle, nil];
        _cancelButtonAction = [cancelButtonAction copy];
        _otherButtonAction = [otherButtonAction copy];
        _alertViewCancelBehavior = BRAlertViewControllerAlertViewCancelBehaviorCancelAction;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
            cancelButtonTitle:(NSString *)cancelButtonTitle
           cancelButtonAction:(void (^)(UIAlertView* alertView))cancelButtonAction
            otherButtonTitles:(NSString *)otherButtonTitle
            otherButtonAction:(void (^)(UIAlertView* alertView))otherButtonAction
{
    self = [super init];
    if (self) {
        _alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitle, nil];
        _cancelButtonAction = [cancelButtonAction copy];
        _otherButtonAction = [otherButtonAction copy];
        _alertViewCancelBehavior = BRAlertViewControllerAlertViewCancelBehaviorCancelAction;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                        style:(UIAlertViewStyle)style
            cancelButtonTitle:(NSString *)cancelButtonTitle
           cancelButtonAction:(void (^)(UIAlertView* alertView))cancelButtonAction
            otherButtonTitles:(NSString *)otherButtonTitle
            otherButtonAction:(void (^)(UIAlertView* alertView))otherButtonAction
{
    self = [super init];
    if (self) {
        _alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitle, nil];
        _cancelButtonAction = [cancelButtonAction copy];
        _otherButtonAction = [otherButtonAction copy];
        _alertViewCancelBehavior = BRAlertViewControllerAlertViewCancelBehaviorCancelAction;
        _alertView.alertViewStyle = style;
    }
    return self;
}


- (void) showAlertView
{
    [self.alertView show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex) {
        self.cancelButtonAction(alertView);
    } else {
        self.otherButtonAction(alertView);
    }
}

- (void)alertViewCancel:(UIAlertView *)alertView{
    if (self.alertViewCancelBehavior == BRAlertViewControllerAlertViewCancelBehaviorCancelAction) {
        self.cancelButtonAction(alertView);
    }
    else if (self.alertViewCancelBehavior == BRAlertViewControllerAlertViewCancelBehaviorOtherAction) {
        self.otherButtonAction(alertView);
    }
    else if (self.alertViewCancelBehavior == BRAlertViewControllerAlertViewCancelBehaviorNoOperation) {
        // nop
    }
    else {
        assert(!@"Unsafe Value: self.alertViewCancelBehavior");
    }
}
@end
