//
//  BRLMPrinterSpecViewController.m
//  SDK_Sample_Ver2
//
//  Created by Shintaro on 2023/01/12.
//

#import "BRLMPrinterSpecViewController.h"
#import <BRLMPrinterKit/BRLMPrinterKit.h>

@interface BRLMPrinterSpecViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic)  NSDictionary *dict;

@end

@implementation BRLMPrinterSpecViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithInt:BRLMPrinterModelPJ_773], @"Brother PJ-773",
                          [NSNumber numberWithInt:BRLMPrinterModelMW_260MFi], @"Brother MW-260MFi",
                          [NSNumber numberWithInt:BRLMPrinterModelRJ_3150Ai], @"Brother RJ-3150Ai",
                          [NSNumber numberWithInt:BRLMPrinterModelRJ_2150], @"Brother RJ-2150",
                          [NSNumber numberWithInt:BRLMPrinterModelRJ_4250WB], @"Brother RJ-4250WB",
                          [NSNumber numberWithInt:BRLMPrinterModelTD_2130N], @"Brother TD-2130N",
                          [NSNumber numberWithInt:BRLMPrinterModelTD_4550DNWB], @"Brother TD-4550DNWB",
                          [NSNumber numberWithInt:BRLMPrinterModelQL_720NW], @"Brother QL-720W",
                          [NSNumber numberWithInt:BRLMPrinterModelQL_820NWB], @"Brother QL-820W",
                          [NSNumber numberWithInt:BRLMPrinterModelQL_1115NWB], @"Brother QL-1115NWB",
                          [NSNumber numberWithInt:BRLMPrinterModelPT_E550W], @"Brother PT-E550W",
                          [NSNumber numberWithInt:BRLMPrinterModelPT_P750W], @"Brother PT-P750W",
                          [NSNumber numberWithInt:BRLMPrinterModelPT_D800W], @"Brother PT-D800W",
                          [NSNumber numberWithInt:BRLMPrinterModelPT_E850TKW], @"Brother PT-E850TKW",
                          [NSNumber numberWithInt:BRLMPrinterModelPT_P950NW], @"Brother PT-P950NW",
                          [NSNumber numberWithInt:BRLMPrinterModelPT_P910BT], @"Brother P-P910BT",
                          [NSNumber numberWithInt:BRLMPrinterModelRJ_3250WB], @"Brother RJ-3250WB",
                          [NSNumber numberWithInt:BRLMPrinterModelPJ_883], @"Brother PJ-883",
                          [NSNumber numberWithInt:BRLMPrinterModelTD_2135NWB], @"Brother TD-2135NWB",nil];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dict allKeys].count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = [[self.dict allKeys] objectAtIndex:indexPath.row];
    BRLMPrinterModel model = [[self.dict objectForKey:key] integerValue];
    BRLMPrinterModelSpec *spec = [[BRLMPrinterModelSpec alloc] initWithPrinterModel:model];
    NSString *specStr = [NSString stringWithFormat:@"Xdpi : %f, Ydpi : %f", spec.Xdpi, spec.Ydpi];
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:key message:specStr preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {}]];
    [self presentViewController:alert animated:YES completion:^{}];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"setstring"];
    cell.textLabel.text = [[self.dict allKeys] objectAtIndex:indexPath.row];
    return cell;
}


@end
