//
//  BRLMInputCustomPaperSizeViewController.m
//  SDK_Sample_Ver2
//
//  Copyright © 2015 Brother Industries, Ltd. All rights reserved.
//

#import "BRLMInputCustomPaperSizeViewController.h"
#import "BRLMSelectNumberViewController.h"
#import "BRLMInputNumbersViewController.h"

@interface BRLMInputCustomPaperSizeViewController ()
@property (nonatomic) void(^segueAction)(UIStoryboardSegue* segue);

@property (nonatomic) BRLMCustomPaperSizePaperKind paperKind;
@property (nonatomic, nullable) NSURL *paperBinFilePath;
@property (nonatomic) CGFloat tapeWidth;
@property (nonatomic) CGFloat tapeLength;
@property (nonatomic) BRLMCustomPaperSizeMargins margins;
@property (nonatomic) CGFloat gapLength;
@property (nonatomic) CGFloat markVerticalOffset;
@property (nonatomic) CGFloat markLength;
@property (nonatomic) BRLMCustomPaperSizeLengthUnit unit;

@property (weak, nonatomic) IBOutlet UITableView *paperKindSelectView;
@property (weak, nonatomic) IBOutlet UITableView *paperPropertyInputView;
@property (nonatomic) BRLMSelectNumberViewController* paperKindSelectViewController;
@end


@implementation BRLMInputCustomPaperSizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak BRLMInputCustomPaperSizeViewController* wself = self;
    self.paperKindSelectViewController = [[BRLMSelectNumberViewController alloc] initWithStyle:UITableViewStylePlain];
    self.paperKindSelectViewController.tableView = self.paperKindSelectView;
    self.paperKindSelectViewController.tableView.delegate = self.paperKindSelectViewController;
    self.paperKindSelectViewController.tableView.dataSource = self.paperKindSelectViewController;
    self.paperPropertyInputView.delegate = self;
    self.paperPropertyInputView.dataSource = self;
    if (self.defaultSize == nil) {
        self.defaultSize = [[BRLMCustomPaperSize alloc] initRollWithTapeWidth:2 margins:BRLMCustomPaperSizeMarginsMake(0, 0, 0, 0) unitOfLength:BRLMCustomPaperSizeLengthUnitInch];
    }
    self.paperKindSelectViewController.labels = @[@"Roll",
                                                  @"DieCut",
                                                  @"MarkRoll",
                                                  @"ByFile"];
    self.paperKindSelectViewController.values = @[@(BRLMCustomPaperSizePaperKindRoll),
                                                  @(BRLMCustomPaperSizePaperKindDieCut),
                                                  @(BRLMCustomPaperSizePaperKindMarkRoll),
                                                  @(BRLMCustomPaperSizePaperKindByFile)];
    self.paperKindSelectViewController.decisionHandler = ^(NSString* label, NSNumber* value) {
        [wself refreshPaperTypeSelectionWithPaperType:value.integerValue];
        wself.paperKind = (BRLMCustomPaperSizePaperKind)[value integerValue];
        [wself refreshCustomPaperSize];
    };
    
    self.paperKind = self.defaultSize.paperKind;
    self.paperBinFilePath = self.defaultSize.paperBinFilePath;
    self.tapeWidth = self.defaultSize.tapeWidth;
    self.tapeLength = self.defaultSize.tapeLength;
    self.margins = self.defaultSize.margins;
    self.gapLength = self.defaultSize.gapLength;
    self.markVerticalOffset = self.defaultSize.markVerticalOffset;
    self.markLength = self.defaultSize.markLength;
    self.unit = self.defaultSize.unit;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if ( self.tapeLength <= 0) {
        self.tapeLength = 2;
    }
    if ( self.gapLength <= 0) {
        self.gapLength = 0.28;
    }
    if ( self.markLength <= 0) {
        self.markLength = 0.4;
    }
}

- (void)viewDidLayoutSubviews {
    [self refreshPaperTypeSelectionWithPaperType:self.defaultSize.paperKind];
}

- (void) refreshPaperTypeSelectionWithPaperType:(BRLMCustomPaperSizePaperKind)paperKind {
    UITableView* tableView = self.paperKindSelectViewController.tableView;
    for(NSInteger row = 0; row < self.paperKindSelectViewController.values.count; row++) {
        NSIndexPath* indexPathOfRow = [NSIndexPath indexPathForRow:row inSection:0];
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPathOfRow];
        if(paperKind == self.paperKindSelectViewController.values[row].integerValue) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    [self.paperPropertyInputView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.decisionHandler(self.defaultSize);
    [super viewWillDisappear:animated];
}

static NSString* _Nonnull BRLMInputCustomPaperSizeViewController_TapeWidth = @"TapeWidth";
static NSString* _Nonnull BRLMInputCustomPaperSizeViewController_Margins = @"Margins";
static NSString* _Nonnull BRLMInputCustomPaperSizeViewController_Unit = @"Unit";
static NSString* _Nonnull BRLMInputCustomPaperSizeViewController_TapeLength = @"TapeLength";
static NSString* _Nonnull BRLMInputCustomPaperSizeViewController_GapLength = @"GapLength";
static NSString* _Nonnull BRLMInputCustomPaperSizeViewController_MarkVerticalOffset = @"MarkVerticalOffset";
static NSString* _Nonnull BRLMInputCustomPaperSizeViewController_MarkLength = @"MarkLength";
static NSString* _Nonnull BRLMInputCustomPaperSizeViewController_FilePath = @"FilePath";

- (NSArray<NSString*>*)propertyArrayOfPaperKind:(BRLMCustomPaperSizePaperKind)paperKind {
    switch (paperKind) {
        case BRLMCustomPaperSizePaperKindRoll:
            return @[BRLMInputCustomPaperSizeViewController_TapeWidth,
                     BRLMInputCustomPaperSizeViewController_Margins,
                     BRLMInputCustomPaperSizeViewController_Unit];
        case BRLMCustomPaperSizePaperKindDieCut:
            return @[BRLMInputCustomPaperSizeViewController_TapeWidth,
                     BRLMInputCustomPaperSizeViewController_TapeLength,
                     BRLMInputCustomPaperSizeViewController_Margins,
                     BRLMInputCustomPaperSizeViewController_GapLength,
                     BRLMInputCustomPaperSizeViewController_Unit];
        case BRLMCustomPaperSizePaperKindMarkRoll:
            return @[BRLMInputCustomPaperSizeViewController_TapeWidth,
                     BRLMInputCustomPaperSizeViewController_TapeLength,
                     BRLMInputCustomPaperSizeViewController_Margins,
                     BRLMInputCustomPaperSizeViewController_MarkVerticalOffset,
                     BRLMInputCustomPaperSizeViewController_MarkLength,
                     BRLMInputCustomPaperSizeViewController_Unit];
        case BRLMCustomPaperSizePaperKindByFile:
            return @[BRLMInputCustomPaperSizeViewController_FilePath];
    }
}

-(void)refreshCustomPaperSize {
    switch (self.paperKind) {
        case BRLMCustomPaperSizePaperKindRoll:
            self.defaultSize = [[BRLMCustomPaperSize alloc] initRollWithTapeWidth:self.tapeWidth
                                                                          margins:self.margins
                                                                     unitOfLength:self.unit];
            break;
        case BRLMCustomPaperSizePaperKindDieCut:
            self.defaultSize = [[BRLMCustomPaperSize alloc] initDieCutWithTapeWidth:self.tapeWidth
                                                                         tapeLength:self.tapeLength
                                                                            margins:self.margins
                                                                          gapLength:self.gapLength
                                                                       unitOfLength:self.unit];
            break;
        case BRLMCustomPaperSizePaperKindMarkRoll:
            self.defaultSize = [[BRLMCustomPaperSize alloc] initMarkRollWithTapeWidth:self.tapeWidth
                                                                           tapeLength:self.tapeLength
                                                                              margins:self.margins
                                                                         markPosition:self.markVerticalOffset
                                                                           markHeight:self.markLength
                                                                         unitOfLength:self.unit];
            break;
        case BRLMCustomPaperSizePaperKindByFile:
            self.defaultSize = [[BRLMCustomPaperSize alloc] initWithFile:self.paperBinFilePath];
            break;
    }
    [self.paperPropertyInputView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self propertyArrayOfPaperKind:self.defaultSize.paperKind].count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;

    NSString* title = [self propertyArrayOfPaperKind:self.defaultSize.paperKind][indexPath.row];
    NSString* cellIdentifier = @"BRLMInputCustomPaperSizeViewController_textFieldCell";
    if ([title isEqualToString:BRLMInputCustomPaperSizeViewController_Unit]) {
        cellIdentifier = @"BRLMInputCustomPaperSizeViewController_enumCell";
    }
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = title;
    if ([title isEqualToString:BRLMInputCustomPaperSizeViewController_TapeWidth]) {
        cell.detailTextLabel.text = @(self.defaultSize.tapeWidth).stringValue;
    }
    else if ([title isEqualToString:BRLMInputCustomPaperSizeViewController_Margins]) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"(%@,%@,%@,%@)",
                                     @(self.defaultSize.margins.top).stringValue,
                                     @(self.defaultSize.margins.bottom).stringValue,
                                     @(self.defaultSize.margins.left).stringValue,
                                     @(self.defaultSize.margins.right).stringValue];
    }
    else if ([title isEqualToString:BRLMInputCustomPaperSizeViewController_Unit]) {
        if (self.defaultSize.unit == BRLMCustomPaperSizeLengthUnitMm) {
            cell.detailTextLabel.text = @"mm";
        }
        if (self.defaultSize.unit == BRLMCustomPaperSizeLengthUnitInch) {
            cell.detailTextLabel.text = @"inch";
        }
    }
    else if ([title isEqualToString:BRLMInputCustomPaperSizeViewController_TapeLength]) {
        cell.detailTextLabel.text = @(self.defaultSize.tapeLength).stringValue;
    }
    else if ([title isEqualToString:BRLMInputCustomPaperSizeViewController_GapLength]) {
        cell.detailTextLabel.text = @(self.defaultSize.gapLength).stringValue;
    }
    else if ([title isEqualToString:BRLMInputCustomPaperSizeViewController_MarkVerticalOffset]) {
        cell.detailTextLabel.text = @(self.defaultSize.markVerticalOffset).stringValue;
    }
    else if ([title isEqualToString:BRLMInputCustomPaperSizeViewController_MarkLength]) {
        cell.detailTextLabel.text = @(self.defaultSize.markLength).stringValue;
    }
    else if ([title isEqualToString:BRLMInputCustomPaperSizeViewController_TapeWidth]) {
        cell.detailTextLabel.text = @(self.defaultSize.tapeWidth).stringValue;
    }
    else if ([title isEqualToString:BRLMInputCustomPaperSizeViewController_FilePath]) {
        cell.detailTextLabel.text = [self.defaultSize.paperBinFilePath.path componentsSeparatedByString:@"/"].lastObject;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* title = [self propertyArrayOfPaperKind:self.defaultSize.paperKind][indexPath.row];
    __weak BRLMInputCustomPaperSizeViewController* wself = self;
    if ([title isEqualToString:BRLMInputCustomPaperSizeViewController_TapeWidth]) {
        [self showInputStringViewWithTitle:title message:@(self.defaultSize.tapeWidth).stringValue placeHolder:@"" decisionHandler:^(NSString * input) {
            self.tapeWidth = [input floatValue];
            [self refreshCustomPaperSize];
        }];
    }
    else if ([title isEqualToString:BRLMInputCustomPaperSizeViewController_Margins]) {
        self.segueAction = ^(UIStoryboardSegue* segue) {
            BRLMInputNumbersViewController *viewController = [segue destinationViewController];
            viewController.labels = @[@"top", @"left", @"bottom", @"right"];
            viewController.values = @[@(wself.defaultSize.margins.top),
                                      @(wself.defaultSize.margins.left),
                                      @(wself.defaultSize.margins.bottom),
                                      @(wself.defaultSize.margins.right),].mutableCopy;
            viewController.title = title;
            viewController.decisionHandler = ^(BRLMInputNumbersViewController* sender) {
                BRLMCustomPaperSizeMargins margins;
                margins.top = sender.values[0].floatValue;
                margins.left = sender.values[1].floatValue;
                margins.bottom = sender.values[2].floatValue;
                margins.right = sender.values[3].floatValue;
                wself.margins = margins;
                [wself refreshCustomPaperSize];
            };
        };
        [self performSegueWithIdentifier:@"BRLMInputNumbersViewController" sender:self];
    }
    else if ([title isEqualToString:BRLMInputCustomPaperSizeViewController_Unit]) {
        [self showInputEnumViewWithTitle:title
                                  labels:@[@"mm", @"inch", ]
                                  values:@[@(BRLMCustomPaperSizeLengthUnitMm), @(BRLMCustomPaperSizeLengthUnitInch), ]
                         decisionHandler:^(NSString* label, NSNumber* value) {
                             self.unit = [value integerValue];
                             [self refreshCustomPaperSize];
                         }];
    }
    else if ([title isEqualToString:BRLMInputCustomPaperSizeViewController_TapeLength]) {
        [self showInputStringViewWithTitle:title message:@(self.defaultSize.tapeLength).stringValue placeHolder:@"" decisionHandler:^(NSString * input) {
            self.tapeLength = [input floatValue];
            [self refreshCustomPaperSize];
        }];
    }
    else if ([title isEqualToString:BRLMInputCustomPaperSizeViewController_GapLength]) {
        [self showInputStringViewWithTitle:title message:@(self.defaultSize.gapLength).stringValue placeHolder:@"" decisionHandler:^(NSString * input) {
            self.gapLength = [input floatValue];
            [self refreshCustomPaperSize];
        }];
    }
    else if ([title isEqualToString:BRLMInputCustomPaperSizeViewController_MarkVerticalOffset]) {
        [self showInputStringViewWithTitle:title message:@(self.defaultSize.markVerticalOffset).stringValue placeHolder:@"" decisionHandler:^(NSString * input) {
            self.markVerticalOffset = [input floatValue];
            [self refreshCustomPaperSize];
        }];
    }
    else if ([title isEqualToString:BRLMInputCustomPaperSizeViewController_MarkLength]) {
        [self showInputStringViewWithTitle:title message:@(self.defaultSize.markLength).stringValue placeHolder:@"" decisionHandler:^(NSString * input) {
            self.markLength = [input floatValue];
            [self refreshCustomPaperSize];
        }];
    }
    else if ([title isEqualToString:BRLMInputCustomPaperSizeViewController_TapeWidth]) {
        [self showInputStringViewWithTitle:title message:@(self.defaultSize.tapeWidth).stringValue placeHolder:@"" decisionHandler:^(NSString * input) {
            self.tapeWidth = [input floatValue];
            [self refreshCustomPaperSize];
        }];
    }
    else if ([title isEqualToString:BRLMInputCustomPaperSizeViewController_FilePath]) {
        NSMutableArray *itemsArray      = [[NSMutableArray alloc] init];
        NSMutableArray *itemNumberArray = [[NSMutableArray alloc] init];
        [itemsArray         addObject:@"No Custom Page"];
        [itemNumberArray    addObject:@(NO)];
        
        NSArray *documentDirectries = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [documentDirectries lastObject];
        NSError *error = nil;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSMutableArray *dataArray = [[fileManager contentsOfDirectoryAtPath:documentDirectory error:&error] mutableCopy];
        if (dataArray) {
            for (NSString *dataStr in dataArray) {
                BOOL isBinFile =[dataStr hasSuffix:@".bin"];
                if (isBinFile) {
                    [itemsArray         addObject:dataStr];
                    [itemNumberArray    addObject:@(YES)];
                }
            }
        }
        [self showInputEnumViewWithTitle:title
                                  labels:itemsArray
                                  values:itemNumberArray
                         decisionHandler:^(NSString* label, NSNumber* value) {
                             if(value.boolValue) {
                                 self.paperBinFilePath = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", documentDirectory, label]];
                                 [self refreshCustomPaperSize];
                             }
                         }];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.segueAction(segue);
}

- (void)showInputStringViewWithTitle:(NSString*)title message:(NSString *)message placeHolder:(NSString *)placeHolder decisionHandler:(void(^)(NSString*)) handler {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = placeHolder;
        textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        handler(alert.textFields.firstObject.text);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {}]];
    [self presentViewController:alert animated:YES completion:^{}];
}

- (void)showInputEnumViewWithTitle:(NSString*)title labels:(NSArray<NSString*>*)labels values:(NSArray<NSNumber*>*)values decisionHandler:(void(^)(NSString* label, NSNumber* value)) handler {
    __weak BRLMInputCustomPaperSizeViewController* wself = self;
    self.segueAction = ^(UIStoryboardSegue* segue) {
        BRLMSelectNumberViewController *viewController = [segue destinationViewController];
        viewController.labels = labels;
        viewController.values = values;
        viewController.title = title;
        viewController.decisionHandler = ^(NSString* label, NSNumber* value) {
            handler(label, value);
            [wself.navigationController popViewControllerAnimated:YES];
        };
    };
    [self performSegueWithIdentifier:@"BRLMSelectNumberViewController" sender:self];
}
@end
