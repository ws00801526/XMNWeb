//
//  XMNTextController.m
//  XMNWeb
//
//  Created by XMFraker on 17/2/21.
//  Copyright © 2017年 ws00801526. All rights reserved.
//

#import "XMNTextController.h"
#import <XMNWeb/XMNTextView.h>

@interface XMNTextController ()

@property (weak, nonatomic)   IBOutlet XMNTextView *textView;

@end

@implementation XMNTextController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.textView.placeHolder = @"测试下";
//    self.textView.placeHolderColor = [UIColor redColor];
    
    self.textView.maxHeight = 200.f;
    self.textView.minHeight = 44.f;
    self.textView.contentInset = UIEdgeInsetsMake(4, 0, 4, 0);
    self.textView.animateHeightChange = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
