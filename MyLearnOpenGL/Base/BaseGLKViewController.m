//
//  BaseGLKViewController.m
//  MyLearnOpenGL
//
//  Created by 萧锐杰 on 2020/8/1.
//  Copyright © 2020 Jeremy. All rights reserved.
//

#import "BaseGLKViewController.h"

@interface BaseGLKViewController ()

@property (nonatomic, strong) UIButton *closeBtn;


@end

@implementation BaseGLKViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.closeBtn = [[UIButton alloc] init];
    [self.closeBtn setTitle:@"Close" forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside
     ];
    
    self.closeBtn.frame = CGRectMake(40, 40, 50, 30);
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.view addSubview:self.closeBtn];
}

- (void)close{
    [self dismissViewControllerAnimated:YES completion:nil];
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
