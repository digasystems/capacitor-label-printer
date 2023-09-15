//
//  BRPDFPickerViewController.m
//  SDK_Sample_Ver2
//
//  Copyright © 2015 Brother Industries, Ltd. All rights reserved.
//

#import "UserDefaults.h"
#import "BRPDFPickerViewController.h"

@interface BRPDFPickerViewController ()
{
}
@property(nonatomic, strong) NSArray *sharedPDFArray;
@end

@implementation BRPDFPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *sharedDocumentsPath = [paths objectAtIndex:0];
    self.sharedPDFArray = [[NSArray alloc] initWithArray:[self contentsPathArrayFromDirectory:sharedDocumentsPath]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sharedPDFArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PDFPickerCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PDFPickerCell"];
    }
    cell.textLabel.text = [[self.sharedPDFArray objectAtIndex:indexPath.row] lastPathComponent];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *pdfPath = [self.sharedPDFArray objectAtIndex:indexPath.row];
    [userDefaults setObject:pdfPath forKey:kSelectedPDFFilePath];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (NSArray *)contentsPathArrayFromDirectory:(NSString *)directoryPath
{
    NSError *error = nil;
    NSMutableArray *contentsArray = [[NSMutableArray alloc] initWithCapacity:1];
    NSArray *contents = [NSArray arrayWithArray:[[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:&error]];
    NSMutableArray *fileArray = [[NSMutableArray alloc] initWithCapacity:1];
    
    if (contents.count > 0) {
        for (NSString *fileName in contents) {
            BOOL isDir;
            NSString *aPath = [directoryPath stringByAppendingPathComponent:fileName];
            [[NSFileManager defaultManager] fileExistsAtPath:aPath isDirectory:&isDir];
            
            if (!isDir) {
                if ([[aPath pathExtension].lowercaseString isEqualToString:@"pdf"])
                {
                    [fileArray addObject:aPath];
                }
            }
        }
    }
    if (fileArray.count > 0) {
        [contentsArray addObjectsFromArray:fileArray];
    }
    
    return contentsArray;
}

@end
