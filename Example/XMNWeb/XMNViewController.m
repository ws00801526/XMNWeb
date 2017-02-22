//
//  XMNViewController.m
//  XMNWeb
//
//  Created by ws00801526 on 02/15/2017.
//  Copyright (c) 2017 ws00801526. All rights reserved.
//

#import "XMNViewController.h"

#import <XMNWeb/XMNWebController.h>
#import <XMNWeb/XMNWebDebugConsoleController.h>
#import <XMNWeb/XMNWebController+Console.h>
#import <XMNWeb/XMNWebController+JSBridge.h>

@interface XMNViewController ()

@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic)   XMNWebController *webC;

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

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    NSLog(@"%@ viewWillAppear",NSStringFromClass([self class]));
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)showConsole {
    
    XMNWebDebugConsoleController *webConsoleC = [[XMNWebDebugConsoleController alloc] initWithConsole:self.webC.console];
    [self.navigationController  pushViewController:webConsoleC animated:YES];
}

- (IBAction)openWebAction:(UIButton *)sender {
    
    XMNWebController *webC = [[XMNWebController alloc] initWithURL:[NSURL URLWithString:self.urlTextField.text]];
    [self.navigationController pushViewController:self.webC = webC animated:YES];
    
    __weak typeof(*&self) wSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        __strong typeof(*&wSelf) self = wSelf;
        self.webC.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Console" style:UIBarButtonItemStylePlain target:self action:@selector(showConsole)];
        
    });
    
    [[NSNotificationCenter defaultCenter] addObserverForName:XMNWebViewConsoleDidAddMessageNotification
                                                      object:self.webC.console
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      
                                                      NSLog(@"this is console :%@",note.object);
                                                      NSLog(@"this is current messages :%@",[note.object messages]);
                                                  }];
}
- (IBAction)openLocalFile:(UIButton *)sender {
    
    XMNWebController *webC = [[XMNWebController alloc] initWithURL:[[NSBundle mainBundle] URLForResource:@"XMNJSBridgeTest.html" withExtension:nil]];
    [self.navigationController pushViewController:webC animated:YES];
}

@end
