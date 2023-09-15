//
//  BRLMPrintSettingsValidateViewController.m
//  SDK_Sample_Ver2
//
//  Created by Yu Matsuo on 27/2/20.
//

#import "BRLMPrintSettingsValidateViewController.h"

@interface BRLMPrintSettingsValidateViewController ()

@end

@implementation BRLMPrintSettingsValidateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.text = self.report.description;
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
