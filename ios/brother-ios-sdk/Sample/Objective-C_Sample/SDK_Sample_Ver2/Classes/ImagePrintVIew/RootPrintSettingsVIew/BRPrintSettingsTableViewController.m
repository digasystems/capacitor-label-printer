//
//  RootPrintSettingsTableViewController.m
//  SDK_Sample_Ver2
//
//  Copyright © 2015 Brother Industries, Ltd. All rights reserved.
//

#import "UserDefaults.h"
#import "BRPrintSettingsTableViewController.h"
#import "BRPrintSettingDetailTableVIewController.h"

@interface BRPrintSettingsTableViewController ()<UITextFieldDelegate>
{
}
@property (nonatomic, strong) NSMutableArray *printSettingTableViewArray;
@end

@implementation BRPrintSettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.printSettingTableViewArray = [[NSMutableArray alloc] init];
    
    NSString *pathInPrintSettings   = [[NSBundle mainBundle] pathForResource:@"PrintSettings" ofType:@"plist"];
    self.printSettingTableViewArray = [NSMutableArray arrayWithContentsOfFile:pathInPrintSettings];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.printSettingTableViewArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    NSUserDefaults *userDefaults    = [NSUserDefaults standardUserDefaults];
    NSString *objectKey             = [[self.printSettingTableViewArray objectAtIndex:indexPath.row] objectForKey:@"Key"];
    
    if ([[self.printSettingTableViewArray objectAtIndex:indexPath.row] objectForKey:@"isTextFieldCell"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"textFieldCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"textFieldCell"];
        }
        
        if ([[cell.contentView viewWithTag:9] isKindOfClass:[UILabel class]]){
            UILabel *textLabel = (UILabel *)[cell.contentView viewWithTag:9];
            [textLabel setText:[[self.printSettingTableViewArray objectAtIndex:indexPath.row] objectForKey:@"Title"]];
        }
        if ([[cell.contentView viewWithTag:10] isKindOfClass:[UITextField class]]){
            UITextField *textField = (UITextField *)[cell.contentView viewWithTag:10];
            [textField setText:[userDefaults stringForKey: objectKey]];
            textField.delegate = self;
            textField.tag = indexPath.row;
        }
    }
    else if ([[self.printSettingTableViewArray objectAtIndex:indexPath.row] objectForKey:@"isCustomPaperInfoParameters"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"customPaperInfoParametersCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"customPaperInfoParametersCell"];
        }
        cell.textLabel.text = [[self.printSettingTableViewArray objectAtIndex:indexPath.row] objectForKey:@"Title"];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"printSettingsCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"printSettingsCell"];
        }
        
        cell.textLabel.text = [[self.printSettingTableViewArray objectAtIndex:indexPath.row] objectForKey:@"Title"];
        NSString *cellText = [self resolveUserDefaultValueByNumber:[userDefaults integerForKey:objectKey]
                                            printSettingTargetItem:[self.printSettingTableViewArray objectAtIndex:indexPath.row]];
        cell.detailTextLabel.text = cellText;
    }
    
    return cell;
}

- (NSString *) resolveUserDefaultValueByNumber:(NSInteger)userDefaultNumber printSettingTargetItem:(NSDictionary *)printSettingTargetItem
{
    NSString *target = nil;
    
    NSString *key = [printSettingTargetItem objectForKey:@"Key"];
    if ([key isEqualToString:kPrintPaperSizeKey] ||
        [key isEqualToString:kPrintCustomPaperKey]) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        target = [userDefaults stringForKey:key];
    }
    else{
        NSArray *itemNumberArray = [printSettingTargetItem objectForKey:@"ItemNumber"];
        NSInteger targetItemNumberCount = 0;
        int i = 0;
        for(NSNumber *num in itemNumberArray){
            if (userDefaultNumber == [num integerValue]) {
                targetItemNumberCount = i;
                break;
            }
            i++;
        }
        NSArray *itemsArray = [printSettingTargetItem objectForKey:@"Items"];
        target = [itemsArray objectAtIndex:targetItemNumberCount];
    }
    
    return target;
}

#pragma mark - UItextField Delegate Method

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    NSInteger index = textField.tag;
    if (index < self.printSettingTableViewArray.count) {
        NSDictionary *dict = [self.printSettingTableViewArray objectAtIndex:index];
        NSString *key = [dict objectForKey:@"Key"];
        [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:key];
    }
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [[segue identifier] isEqualToString:@"printDetailSettingsSegue"] ) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        BRPrintSettingDetailTableVIewController *printSettingDetailTableVIewController = [segue destinationViewController];
        printSettingDetailTableVIewController.selectedRowKey = [[self.printSettingTableViewArray objectAtIndex:indexPath.row] objectForKey:@"Key"];
    }
    else if ([[segue identifier] isEqualToString:@"customPaperInfoParametersSegue"]){
    }
}

@end
