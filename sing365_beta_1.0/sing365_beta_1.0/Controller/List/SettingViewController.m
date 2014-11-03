//
//  SettingViewController.m
//  sing365_beta_1.0
//
//  Created by 张 磊 on 14-5-5.
//  Copyright (c) 2014年 Stone_Zl. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"forthMenu", @"");
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
        [button setTitle:@"什么情况" forState:UIControlStateNormal];
        [button setTitle:@"就是这样" forState:UIControlStateHighlighted];
        button.backgroundColor = [UIColor blueColor];
        [button addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:button];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)onAction:(id)sender
{

}

@end
