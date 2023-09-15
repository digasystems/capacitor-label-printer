//
//  BRLMPaperSizePJTableViewController.m
//  SDK_Sample_Ver2
//
//  Copyright © 2015 Brother Industries, Ltd. All rights reserved.
//

#import "BRLMPaperSizePJTableViewController.h"
#import "BRLMSelectNumberViewController.h"
#import "BRLMInputNumbersViewController.h"

@interface BRLMPaperSizePJTableViewController ()
@property (nonatomic) void(^segueAction)(UIStoryboardSegue* segue);

@property (nonatomic) BRLMPJPrintSettingsPaperSizeStandard paperSizeStandard;
@property (nonatomic, nullable) BRLMPJPrintSettingsCustomPaperSize *customPaper;
@end

@implementation BRLMPaperSizePJTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.paperSizeStandard = self.defaultPaperSizePJ.paperSizeStandard;
    self.customPaper = self.defaultPaperSizePJ.customPaper;
    //self.customPaper = self.defaultPaperSizePJ.customPaper;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.decisionHandler(self.defaultPaperSizePJ);
    [super viewWillDisappear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

static NSString* _Nonnull BRLMPaperSizePJTableViewController_PaperSize = @"PaperSize";
static NSString* _Nonnull BRLMPaperSizePJTableViewController_CustomPaperSize = @"CustomPaperSize";

- (NSDictionary*)defaultPaperSizePJKeyMap {
    return @{@(BRLMPJPrintSettingsPaperSizeStandardA4): @"A4",
             @(BRLMPJPrintSettingsPaperSizeStandardLegal): @"Legal",
             @(BRLMPJPrintSettingsPaperSizeStandardLetter): @"Letter",
             @(BRLMPJPrintSettingsPaperSizeStandardA5): @"A5",
             @(BRLMPJPrintSettingsPaperSizeStandardA5_Landscape): @"A5_Landscape",
             @(BRLMPJPrintSettingsPaperSizeStandardCustom): @"Custom",
             };
}

- (NSArray*)defaultPaperSizeTitleArray {
    return @[BRLMPaperSizePJTableViewController_PaperSize,BRLMPaperSizePJTableViewController_CustomPaperSize];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    NSString* title = [self defaultPaperSizeTitleArray][indexPath.row];
    NSString* cellIdentifier = @"BRLMPaperSizePJTableViewController_textFieldCell";
    if ([title isEqualToString:BRLMPaperSizePJTableViewController_PaperSize]) {
        cellIdentifier = @"BRLMPaperSizePJTableViewController_enumCell";
    }
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = title;
    if ([title isEqualToString:BRLMPaperSizePJTableViewController_CustomPaperSize]) {
        if (self.customPaper) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"(%@,%@)",
                                         @(self.customPaper.widthDots).stringValue,
                                         @(self.customPaper.lengthDots).stringValue];
            cell.detailTextLabel.textColor = [UIColor systemGrayColor];
        }
        else {
            cell.detailTextLabel.text = @"nil";
            cell.detailTextLabel.textColor = [UIColor systemRedColor];
        }
        
        if (self.paperSizeStandard != BRLMPJPrintSettingsPaperSizeStandardCustom) {
            cell.hidden = YES;
        }
    }
    else if ([title isEqualToString:BRLMPaperSizePJTableViewController_PaperSize]) {
        cell.detailTextLabel.text = self.defaultPaperSizePJKeyMap[@(self.paperSizeStandard)];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* title = [self defaultPaperSizeTitleArray][indexPath.row];
    __weak BRLMPaperSizePJTableViewController* wself = self;
    
    
    if ([title isEqualToString:BRLMPaperSizePJTableViewController_PaperSize]) {
        [self showInputEnumViewWithTitle:title
                                  labels:self.defaultPaperSizePJKeyMap.allValues
                                  values:self.defaultPaperSizePJKeyMap.allKeys
                         decisionHandler:^(NSString* label, NSNumber* value) {
                             wself.paperSizeStandard = (BRLMPJPrintSettingsPaperSizeStandard)[value integerValue];
                             [wself refreshPaperSize];
                         }];
    }
    if ([title isEqualToString:BRLMPaperSizePJTableViewController_CustomPaperSize]) {
        self.segueAction = ^(UIStoryboardSegue* segue) {
            BRLMInputNumbersViewController *viewController = [segue destinationViewController];
            viewController.labels = @[@"widthDots", @"lengthDots"];
            if( wself.customPaper ) {
                viewController.values = @[@(wself.defaultPaperSizePJ.customPaper.widthDots),
                                          @(wself.defaultPaperSizePJ.customPaper.lengthDots)].mutableCopy;
            }
            else {
                viewController.values = @[@(2400),
                                          @(3300)].mutableCopy;
            }
            viewController.title = title;
            viewController.decisionHandler = ^(BRLMInputNumbersViewController* sender) {
                BRLMPJPrintSettingsCustomPaperSize* customPaper = [[BRLMPJPrintSettingsCustomPaperSize alloc] initWithWidthDots:sender.values[0].integerValue lengthDots:sender.values[1].integerValue];
                wself.customPaper = customPaper;
                [wself refreshPaperSize];
            };
        };
        [self performSegueWithIdentifier:@"BRLMInputNumbersViewController" sender:self];
    }
    
}

-(void)refreshPaperSize {
    switch (self.paperSizeStandard) {
        case BRLMPJPrintSettingsPaperSizeStandardCustom:
            if(self.customPaper) {
                self.defaultPaperSizePJ = [[BRLMPJPrintSettingsPaperSize alloc] initWithCustomPaper:self.customPaper];
            }
            break;
        default:
            self.defaultPaperSizePJ = [[BRLMPJPrintSettingsPaperSize alloc] initWithPaperSizeStandard:self.paperSizeStandard];
            break;
    }
    [self.tableView reloadData];
}

- (void)showInputEnumViewWithTitle:(NSString*)title labels:(NSArray<NSString*>*)labels values:(NSArray<NSNumber*>*)values decisionHandler:(void(^)(NSString* label, NSNumber* value)) handler {
    __weak BRLMPaperSizePJTableViewController* wself = self;
    self.segueAction = ^(UIStoryboardSegue* segue) {
        BRLMSelectNumberViewController *viewController = [segue destinationViewController];
        viewController.labels = labels;
        viewController.values = values;
        viewController.title = title;
        viewController.decisionHandler = ^(NSString* label, NSNumber* value) {
            handler(label, value);
            [wself.navigationController popViewControllerAnimated:YES];
            [wself.tableView reloadData];
        };
    };
    [self performSegueWithIdentifier:@"BRLMSelectNumberViewController" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.segueAction(segue);
}

@end
