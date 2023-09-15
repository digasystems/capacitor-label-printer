//
//  BRCustomPaperInfoParametersTableViewController.m
//  SDK_Sample_Ver2
//

#import "UserDefaults.h"
#import "BRCustomPaperInfoParametersTableViewController.h"

@interface BRCustomPaperInfoParametersTableViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *customPaperInfoParametersArr;
@property(nonatomic, weak) IBOutlet UISwitch *usingCustomPaperInfoSwitch;
@end

@implementation BRCustomPaperInfoParametersTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    bool isSwitch = [[userDefaults stringForKey: kUsingCustomPaperInfo] boolValue];
    if (isSwitch) {
        self.usingCustomPaperInfoSwitch.on = YES;
    }
    else {
        self.usingCustomPaperInfoSwitch.on = NO;
    }
    
    if (self.usingCustomPaperInfoSwitch.on == NO){
        // parameters clear
        NSEnumerator *enumrator = [self.customPaperInfoParametersArr objectEnumerator];
        NSArray *arr;
        while (arr = [enumrator nextObject]) {
            NSString *key = arr[1];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:key];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.customPaperInfoParametersArr = [@[@[@"Roll:1 DieCut:2 Mark:3", kPaperKind],
                                           @[@"Inch:1 Mm:2",            kUnitOfLength],
                                           @[@"Tape Width",             kTapeWidth],
                                           @[@"Tape Length",            kTapeLength],
                                           @[@"Right Margin",           kRightMargin],
                                           @[@"Left Margin",            kLeftMagin],
                                           @[@"Top Margin",             kTopMargin],
                                           @[@"Bottom Margin",          kBottomMargin],
                                           @[@"Label Pitch",            kLabelPitch],
                                           @[@"Mark Position",          kMarkPosition],
                                           @[@"Mark Height",            kMarkHeight],
                                           @[@"Display Name",           kDisplayName],
                                           ] mutableCopy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.customPaperInfoParametersArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    UITableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"parameterNameAndTextFieldCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"parameterNameAndTextFieldCell"];
    }
    
    NSArray *arr = [self.customPaperInfoParametersArr objectAtIndex:indexPath.row];
    NSString *label = arr[0];
    NSString *value = [userDefaults stringForKey: arr[1]];
    
    if ([[cell.contentView viewWithTag:1] isKindOfClass:[UILabel class]]){
        UILabel *textLabel = (UILabel *)[cell.contentView viewWithTag:1];
        [textLabel setText:label];
    }
    if ([[cell.contentView viewWithTag:2] isKindOfClass:[UITextField class]]){
        UITextField *textField = (UITextField *)[cell.contentView viewWithTag:2];
        if ([value isEqualToString:@""] || value == nil){
            if([label isEqualToString:@"Display Name"]) {
                value = @"";
            }
            else {
                value = @"0";
            }
        }
        [textField setText:value];
        textField.delegate = self;
        textField.tag = indexPath.row;
    }

    return cell;
}

#pragma mark - UItextField Delegate Method

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    NSInteger index = textField.tag;
    if (index < self.customPaperInfoParametersArr.count) {
        NSArray *arr = [self.customPaperInfoParametersArr objectAtIndex:index];
        NSString *key = arr[1];
        [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:key];
    }
    [textField resignFirstResponder];
    
    return YES;
}

-(IBAction)switchChanged:(id)sender{
    if(self.usingCustomPaperInfoSwitch.on){
        NSLog(@"Switch ON");
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:kUsingCustomPaperInfo];
    }
    else{
        NSLog(@"Switch OFF");
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:kUsingCustomPaperInfo];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
