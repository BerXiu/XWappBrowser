//
//  ViewController.m
//  XWappBrowser
//
//  Created by Xiu on 16/8/26.
//  Copyright © 2016年 Xiu. All rights reserved.
//

#import "ViewController.h"
#import "WebViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)sender:(UIButton *)sender {
    [self.navigationController pushViewController:[WebViewController getWebViewControllerWithTitle:@"a" url:@"http://localhost:3003/Wapp/test.html?_ijt=f5248cu8g849e507bsmhecujph"  params:nil type:BrowseTypeWebApp] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
