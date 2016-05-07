//
//  HHMainTableViewController.m
//  VolumeControl
//
//  Created by 蔡万鸿 on 16/5/7.
//  Copyright © 2016年 黄花菜. All rights reserved.
//

#import "HHMainTableViewController.h"
#import "HHVolumeKeyViewController.h"
#import "HHEarphoneViewController.h"
#import "HHCombinedViewController.h"

@interface HHMainTableViewController ()

@end

@implementation HHMainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"音量控制Demo";
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID" forIndexPath:indexPath];

    if (indexPath.row == 0) {
        cell.textLabel.text = @"手机实体音量按键";
    }
    else if (indexPath.row == 1) {
        cell.textLabel.text = @"耳机中间键";
    }
    else {
        cell.textLabel.text = @"耳机手机同时控制";
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        HHVolumeKeyViewController *VolumeKeyVc = [[HHVolumeKeyViewController alloc] init];
        [self.navigationController pushViewController:VolumeKeyVc animated:YES];
    }
    else if (indexPath.row == 1) {
        HHEarphoneViewController *earphoneVc = [[HHEarphoneViewController alloc] init];
        [self.navigationController pushViewController:earphoneVc animated:YES];
    }
    else {
        HHCombinedViewController *combinedVc = [[HHCombinedViewController alloc] init];
        [self.navigationController pushViewController:combinedVc animated:YES];
    }
}

@end
