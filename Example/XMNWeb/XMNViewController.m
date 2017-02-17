//
//  XMNViewController.m
//  XMNWeb
//
//  Created by ws00801526 on 02/15/2017.
//  Copyright (c) 2017 ws00801526. All rights reserved.
//

#import "XMNViewController.h"

#import "XMNWebController.h"

@interface XMNViewController ()
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;

@end

@implementation XMNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
#ifdef XMNBRIDGE_ENABLED
    NSLog(@"this framework contains jsbridge");
#endif
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)openWebAction:(UIButton *)sender {
    
    XMNWebController *webC = [[XMNWebController alloc] initWithURL:[NSURL URLWithString:self.urlTextField.text]];
    
    if (webC) {
        [self.navigationController pushViewController:webC animated:YES];
    }
}
- (IBAction)openLocalFile:(UIButton *)sender {
    
    
    XMNWebController *webC = [[XMNWebController alloc] initWithURL:[[NSBundle mainBundle] URLForResource:@"test.html" withExtension:nil]];
    
    if (webC) {
        [self.navigationController pushViewController:webC animated:YES];
    }
}

@end
