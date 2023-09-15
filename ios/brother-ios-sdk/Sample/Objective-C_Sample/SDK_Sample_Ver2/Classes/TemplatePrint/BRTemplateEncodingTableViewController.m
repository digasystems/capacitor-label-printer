//
//  BRTemplateEncodingTableViewController.m
//  SDK_Sample_Ver2
//
//  Copyright (c) 2018 Brother Industries, Ltd. All rights reserved.
//

#import "BRTemplateEncodingTableViewController.h"

@implementation BRTemplateEncodingTableViewController

+ (instancetype)makeInstance {
    BRTemplateEncodingTableViewController *viewController = [BRTemplateEncodingTableViewController new];
    return viewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SelectTemplateTableViewCell"];
    
    cell.textLabel.text = [BRTemplateEncodingUtil stringFromTemplateEncoding:indexPath.row];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate templateEncodingTableView:self didSelectTemplateEncoding:indexPath.row];
}

@end


@implementation BRTemplateEncodingUtil

+ (NSString *)stringFromTemplateEncoding:(TemplateEncoding)encoding {
    switch (encoding) {
        case EnglishEncoding:   return @"ENG"; break;
        case JapaneseEncoding:  return @"JPN"; break;
        case ChineseEncoding:   return @"CHN"; break;
        default:                return @"";    break;
    }
}

@end
