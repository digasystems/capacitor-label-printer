//
//  ViewController.m
//  SDK_Sample_Ver2
//
//  Copyright © 2015 Brother Industries, Ltd. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This class maid in ARC.
#endif

#import "UserDefaults.h"

#import "BRMainViewController.h"
#import "BRMainTableViewCell.h"
#import "BRMainTableViewItem.h"
#import "BRMainTableViewItemCreator.h"
#import "BRImagePrintViewController.h"
#import "BRSendDataViewController.h"
#import "BRTemplatePrintViewController.h"
#import "BRManageTemplateViewController.h"
#import "BRUtilityViewController.h"
#import "BRDisplayTextViewController.h"

@interface UIViewController (dismissControl)
-(void)didDismiss;
@end

@interface BRMainViewController ()
{
}
@property (nonatomic, weak) IBOutlet UILabel        *mainViewTitle;
@property (nonatomic, weak) IBOutlet UITableView    *mainTableView;
@property (nonatomic, weak) IBOutlet UIButton *aboutButton;

@property (nonatomic, strong) NSMutableArray *mainTableViewItemArray;
@property (nonatomic, strong) BRMainTableViewItemCreator *mainTableViewItemCreator;

@property (nonatomic, strong) UIViewController *lastViewController;

@end

@implementation BRMainViewController

#pragma mark - Common Class Method

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mainTableViewItemArray     = [[NSMutableArray alloc] init];
    self.mainTableViewItemCreator   = [[BRMainTableViewItemCreator alloc] init];
    
    UINib * nibForTable = [UINib nibWithNibName:@"BRMainTableViewCell" bundle:nil];
    [self.mainTableView registerNib:nibForTable forCellReuseIdentifier:@"mainTableViewCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIColor *customBlueColor = [UIColor systemBlueColor];
    self.mainViewTitle.text = @"iOS SDK Sample Ver.2";
    self.mainViewTitle.font = [UIFont systemFontOfSize:22.0];
    self.mainViewTitle.textColor = customBlueColor;
    self.aboutButton.tintColor = customBlueColor;
    if (self.mainTableViewItemArray){
        [self loadToMainTableView];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Class Method

- (IBAction)showAboutView:(id)sender {
    NSString *sdkVersion = [NSString stringWithFormat:@"SDK Version: %@", [self sdkVersion]];
    BRDisplayTextViewController *vc = [[BRDisplayTextViewController alloc] initWithText:sdkVersion];
    vc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissModalView)];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (NSString *)sdkVersion {
    NSBundle *bundle = [NSBundle bundleWithIdentifier:@"com.brother.BRLMPrinterKit"];
    if (bundle == nil) {
        return @"Unknown";
    }
    NSDictionary *dict = bundle.infoDictionary;
    return [NSString stringWithFormat:@"%@ (%@)", [dict objectForKey:@"CFBundleShortVersionString"], [dict objectForKey:@"CFBundleVersion"]];
}

- (void)loadToMainTableView {
    [self.mainTableViewItemArray removeAllObjects];
    
    if (self.mainTableViewItemCreator){
        NSMutableArray *creatorArray = [self.mainTableViewItemCreator createMainTableViewItems];
        for (BRMainTableViewItem *item in [creatorArray objectEnumerator]){
            [self.mainTableViewItemArray addObject:item];
        }
    }
    [self.mainTableView reloadData];
}

#pragma mark - TableView <Delegate Method>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    
    if (self.mainTableViewItemArray){
        count = [self.mainTableViewItemArray count];
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BRMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainTableViewCell"
                                                                forIndexPath:indexPath];
    
    if (cell){
        BRMainTableViewItem *item = [self.mainTableViewItemArray objectAtIndex:indexPath.row];
        cell.cellID = item.itemID;
        cell.image.image = item.image;
        cell.image.highlightedImage = item.highlightedImage;
        cell.label.text  = item.labelName;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BRMainTableViewCell *cell = (BRMainTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    switch ([cell.cellID integerValue])
    {
        case ImagePrint:
            [self imagePrintViewWillLoad];
        break;
            
        case SendData:
            [self sendDataViewWillLoad];
        break;
            
        case TemplatePrint:
            [self templatePrintViewWillLoad];
            break;
            
        case ManageTemplate:
            [self manageTemplateViewWillLoad];
            break;
            
        case Utility:
            [self utilityViewWillLoad];
        break;
            
        case Info:
            NSLog(@"Pushed [Info]");
        break;
            
        default:
        break;
    }
    
    NSIndexPath *selectedRow = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selectedRow animated:YES];
}

- (void)dismissModalView {
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (void)dismissModalViewWithViewController {
    [self dismissModalView];
    if(self.lastViewController && [self.lastViewController respondsToSelector:@selector(didDismiss)] ){
        [self.lastViewController didDismiss];
    }
}


- (void)imagePrintViewWillLoad {
    UIStoryboard *imagePrintViewStoryboard = [UIStoryboard storyboardWithName: @"BRImagePrintViewController" bundle: nil];
    UIViewController *imagePrintViewController = [imagePrintViewStoryboard instantiateViewControllerWithIdentifier: @"imagePrintViewController"];
    
    UIBarButtonItem *cancelButton;
    
    cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                 target:self
                                                                 action:@selector(dismissModalView)];
    
    imagePrintViewController.navigationItem.leftBarButtonItem = cancelButton;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:imagePrintViewController];
    nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:nav
                       animated:YES
                     completion:nil];
}

- (void)sendDataViewWillLoad {
    UIStoryboard *sendDataViewStoryboard = [UIStoryboard storyboardWithName: @"BRSendDataViewController" bundle: nil];
    UIViewController *sendDataViewController = [sendDataViewStoryboard instantiateViewControllerWithIdentifier: @"sendDataViewController"];
    
    UIBarButtonItem *cancelButton;
    
    cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                 target:self
                                                                 action:@selector(dismissModalViewWithViewController)];
    self.lastViewController = sendDataViewController;
    
    sendDataViewController.navigationItem.leftBarButtonItem = cancelButton;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:sendDataViewController];
    [self presentViewController:nav
                       animated:YES
                     completion:nil];
}

- (void)templatePrintViewWillLoad {
    BRTemplatePrintViewController *viewController = [BRTemplatePrintViewController makeInstance];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)manageTemplateViewWillLoad {
    BRManageTemplateViewController *viewController = [BRManageTemplateViewController makeInstance];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                  target:self
                                                                                  action:@selector(dismissModalView)];
    viewController.navigationItem.leftBarButtonItem = cancelButton;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)utilityViewWillLoad {
    UIStoryboard *utilityViewStoryboard = [UIStoryboard storyboardWithName:@"BRUtilityViewController" bundle:nil];
    UIViewController *utilityViewController = [utilityViewStoryboard instantiateViewControllerWithIdentifier:@"utilityViewController"];
    
    UIBarButtonItem *cancelButton;
    
    cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                 target:self
                                                                 action:@selector(dismissModalView)];
    
    utilityViewController.navigationItem.leftBarButtonItem = cancelButton;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:utilityViewController];
    [self presentViewController:nav
                       animated:YES
                     completion:nil];
}

- (void)infoViewWillLoad {
}

@end
