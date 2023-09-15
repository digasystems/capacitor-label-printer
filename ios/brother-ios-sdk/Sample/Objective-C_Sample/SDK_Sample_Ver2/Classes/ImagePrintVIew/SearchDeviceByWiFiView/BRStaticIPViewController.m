//
//  BRStaticIPViewController.m
//  SDK_Sample_Ver2
//
//  Copyright © 2015 Brother Industries, Ltd. All rights reserved.
//

#import "BRStaticIPViewController.h"
#import "UserDefaults.h"
#import "PingOperation.h"

@interface BRStaticIPViewController () <UITextFieldDelegate, PingLogDelegate, UIPickerViewDelegate, UIPickerViewDataSource>{
    IBOutlet UITextField *ipAddressTextField;
    IBOutlet UITextView *pingLogTextView;
    IBOutlet UITextField *printerNameTextField;
    
    NSArray *_pritnerList;
    
    PingOperation   *_pingOperation;
    NSMutableString *_pingLog;
}
@property (nonatomic, strong)dispatch_queue_t pingQueue;

@end

@implementation BRStaticIPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    ipAddressTextField.text = [[NSUserDefaults standardUserDefaults] stringForKey:kIPAddress];
    ipAddressTextField.delegate = self;
    _pingOperation = [[PingOperation alloc] init];
    _pingOperation.shouldStop = YES;
    [_pingOperation setDelegate:self];
    _pingLog = [[NSMutableString alloc] init];
    
    NSString *	path = [[NSBundle mainBundle] pathForResource:@"PrinterList" ofType:@"plist"];
    if( path )
    {
        NSDictionary *printerDict = [NSDictionary dictionaryWithContentsOfFile:path];
        _pritnerList = [[NSArray alloc] initWithArray:printerDict.allKeys];
    }
    
    [self initPicker];
}

- (void) initPicker
{
    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.delegate = self;
    picker.dataSource = self;
    picker.showsSelectionIndicator = YES;
    
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 38.0f)];
    pickerToolbar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:nil
                                                                                  action:nil];
    UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(resignKeyboard:)];
    [pickerToolbar setItems:@[spaceBarItem, doneBarItem]];
    
    printerNameTextField.inputAccessoryView = pickerToolbar;
    printerNameTextField.inputView = picker;
    printerNameTextField.text = [[NSUserDefaults standardUserDefaults] stringForKey:kSelectedDeviceFromWiFi];
}

- (void)resignKeyboard:(id)sender{
    [printerNameTextField resignFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    _pingOperation.shouldStop = YES;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - IBAction

- (IBAction)pushedIPAddressAndPrinterNameSettingButton:(id)sender {
    NSString *ipAddress = [ipAddressTextField.text copy];
    NSString *printerName = [printerNameTextField.text copy];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:ipAddress forKey:kIPAddress];
    [userDefaults setObject:printerName forKey:kSelectedDeviceFromWiFi];
    [userDefaults setObject:@"1" forKey:kIsWiFi];
    [userDefaults setObject:@"0" forKey:kIsBluetooth];
    [userDefaults setObject:@"0" forKey:kIsBLE];
    [userDefaults setObject:@"Search device from Bluetooth" forKey:kSelectedDeviceFromBluetooth];
    [userDefaults setObject:@"Search device from BLE" forKey:kSelectedDeviceFromBLE];

    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)pushedPingStartButton:(id)sender{
    if (_pingOperation.shouldStop == YES) {
        if (_pingQueue == nil) {
            _pingQueue = dispatch_queue_create("pingOperationQueue", DISPATCH_QUEUE_SERIAL);
        }
        
        dispatch_async(_pingQueue, ^{
            [_pingOperation runWithHostName:ipAddressTextField.text];
        });

    }
}

- (IBAction)pushedPingStopButton:(id)sender{
    _pingOperation.shouldStop = YES;
}

#pragma mark -
#pragma mark UIPickerView DataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [_pritnerList count];
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [_pritnerList objectAtIndex:row];
}


#pragma mark -
#pragma mark UIPickerView Delegate Method

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    printerNameTextField.text = [_pritnerList objectAtIndex:row];
}


#pragma mark PingLog Delegate Method

- (void)outputToScreenWithLog:(NSString *)log
{
    if (log) {
        [_pingLog appendString:log];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [pingLogTextView setText:_pingLog];
        [self scrollTextViewToBottom:pingLogTextView];
    });
}

- (void)scrollTextViewToBottom:(UITextView *)textView {
    
    [UIView setAnimationsEnabled:NO];
    [textView scrollRangeToVisible:NSMakeRange([textView.text length], 0)];
    [UIView setAnimationsEnabled:YES];
    
}


#pragma mark UItextField Delegate Method
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
