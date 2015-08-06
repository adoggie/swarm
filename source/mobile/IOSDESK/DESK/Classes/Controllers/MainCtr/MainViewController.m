//
//  MainViewController.m
//  DESK
//
//  Created by 51desk on 15/6/8.
//  Copyright (c) 2015年 FX. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [self initLeftBaritem:@"menuicon"];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)leftBarButtonItemClick:(id)btn
{
    DDMenuController *ddm=(DDMenuController *)[AppDelegate getDDMCTR];
    [ddm showLeftController:YES];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
