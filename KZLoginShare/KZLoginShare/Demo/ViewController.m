//
//  ViewController.m
//  MamaShare
//
//  Created by huang kaizhan on 2018/12/23.
//  Copyright © 2018年 Shengcheng. All rights reserved.
//

#import "ViewController.h"
#import "TableViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
/** 列表*/
@property (nonatomic, strong) UITableView *tableView;
/** 数据源*/
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewController *vc = [[TableViewController alloc] init];
    NSString *text = self.dataArray[indexPath.row];
    if ([text isEqualToString:@"微信"]) {
        vc.type = SDKTypeWeiChat;
    } else if ([text isEqualToString:@"QQ"]) {
        vc.type = SDKTypeQQ;
    } else {
        vc.type = SDKTypeSina;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = @[@"微信", @"QQ", @"新浪微博"];
    }
    return _dataArray;
}

@end
