//
//  XMNViewController.m
//  XMNWeb
//
//  Created by ws00801526 on 02/15/2017.
//  Copyright (c) 2017 ws00801526. All rights reserved.
//

#import "XMNViewController.h"

#import <XMNWeb/XMNWebController.h>
#import <XMNWeb/XMNWebController+JSBridge.h>

@interface XMNViewController ()
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;

@end

@implementation XMNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openWebAction:(UIButton *)sender {
    
    XMNWebController *webC = [[XMNWebController alloc] initWithURL:[NSURL URLWithString:self.urlTextField.text]];
    [self.navigationController pushViewController:webC animated:YES];

}
- (IBAction)openLocalFile:(UIButton *)sender {
    
    XMNWebController *webC = [[XMNWebController alloc] initWithURL:[[NSBundle mainBundle] URLForResource:@"XMNJSBridgeTest.html" withExtension:nil]];
    [self.navigationController pushViewController:webC animated:YES];
}

@end
