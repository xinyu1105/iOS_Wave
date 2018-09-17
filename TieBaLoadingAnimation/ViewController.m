//
//  ViewController.m
//  TieBaLoadingAnimation
//
//  Created by pengjiaxin on 2018/9/13.
//  Copyright © 2018年 pengjiaxin. All rights reserved.
//

#import "ViewController.h"
#import "TieBarLoadingView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [TieBarLoadingView showInView:self.view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
