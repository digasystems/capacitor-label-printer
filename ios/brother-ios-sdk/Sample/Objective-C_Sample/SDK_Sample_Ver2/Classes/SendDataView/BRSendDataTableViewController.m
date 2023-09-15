//
//  BRSendDataTableViewController.m
//  SDK_Sample_Ver2
//
//  Copyright © 2015 Brother Industries, Ltd. All rights reserved.
//

#import "UserDefaults.h"
#import "BRSendDataTableViewController.h"

@interface BRSendDataTableViewController ()
{
}
@property(nonatomic, strong) NSArray *dataArray;
@end

@implementation BRSendDataTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *documentDirectries = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectries lastObject];
    
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    self.dataArray = [fileManager contentsOfDirectoryAtPath:documentDirectory error:&error];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sendDataCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sendDataCell"];
    }
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *documentDirectries = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectries lastObject];
    NSString *dataName = [self.dataArray objectAtIndex:indexPath.row];
    if (documentDirectory && dataName) {
        NSString *sendDataPath = [NSString stringWithFormat:@"%@/%@",documentDirectory, dataName];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:sendDataPath    forKey:kSelectedSendDataPath];
        [userDefaults setObject:dataName        forKey:kSelectedSendDataName];
    }
}

@end
