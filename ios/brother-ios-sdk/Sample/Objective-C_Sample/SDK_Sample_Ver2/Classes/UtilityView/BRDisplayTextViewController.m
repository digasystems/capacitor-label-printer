//
//  BRDisplayTextViewController.m
//  SDK_Sample_Ver2
//
//  Copyright © 2017 Brother Industries, Ltd. All rights reserved.
//

#import "BRDisplayTextViewController.h"
#import "UIColor+CompatiColor.h"

@interface BRDisplayTextViewController ()
@property (nonatomic) NSString *text;
@end

@implementation BRDisplayTextViewController

- (instancetype)initWithText:(NSString *)text {
    self = [super init];
    if (self) {
        self.text = text;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.systemBackgroundColorCompati;
    
    UITextView *textView = [UITextView new];
    textView.translatesAutoresizingMaskIntoConstraints = NO;
    textView.scrollEnabled = YES;
    textView.editable = NO;
    [self.view addSubview:textView];
    
    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(textView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[textView]|" options:0 metrics:nil views:viewsDict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[textView]|" options:0 metrics:nil views:viewsDict]];
    
    textView.text = self.text;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
