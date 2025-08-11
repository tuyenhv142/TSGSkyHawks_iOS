//
//  EGBaseViewController.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/1/21.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGBaseViewController.h"

@interface EGBaseViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation EGBaseViewController


- (UITableView *)tableView
{
    if (_tableView == nil) {
        
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
//        tableView.backgroundColor = rgba(245, 245, 245, 1);
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.estimatedRowHeight = 100;
        self.tableView = tableView;
        [self.view addSubview:self.tableView];
        
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    UIView *statue = [UIView new];
//    if (@available(iOS 15.0, *)) {
//        statue.frame = [[[UIApplication sharedApplication] windows] firstObject].windowScene.statusBarManager.statusBarFrame;
//    } else {
//        // Fallback on earlier versions
//        statue.frame = [UIApplication sharedApplication].statusBarFrame;
//    }
//    statue.backgroundColor = rgba(0, 71, 56, 1);
//    [self.view addSubview:statue];
    

    if (@available(iOS 13.0, *)) {
//        UINavigationBarAppearance *Appearance = [UINavigationBarAppearance new];
//        Appearance.backgroundColor = rgba(0, 71, 56, 1);
//        self.navigationController.navigationBar.standardAppearance = Appearance;
//        self.navigationController.navigationBar.scrollEdgeAppearance = Appearance;
    }
    
    
    
    
//    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//    gradientLayer.startPoint = CGPointMake(0, 0);
//    gradientLayer.endPoint = CGPointMake(0, 1);
//    gradientLayer.frame = statue.bounds;
//    gradientLayer.colors = @[(id)rgba(0, 71, 56, 1).CGColor,(id)rgba(0, 122, 96, 1).CGColor];
//    [statue.layer insertSublayer:gradientLayer atIndex:0];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark --TableViewDeleagte
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
@end
