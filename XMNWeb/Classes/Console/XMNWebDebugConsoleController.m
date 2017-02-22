//
//  XMNWebDebugConsoleController.m
//  Pods
//
//  Created by XMFraker on 17/2/20.
//
//

#import "XMNWebDebugConsoleController.h"

#import "XMNWebViewConsole.h"

#import "XMNWebViewConsoleInputView.h"
#import "XMNWebViewConsoleMessageCell.h"

@interface XMNWebDebugConsoleController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) XMNWebViewConsole *console;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet XMNWebViewConsoleInputView *consoleInputView;



@end

@implementation XMNWebDebugConsoleController

#pragma mark - Life Cycle

- (instancetype)initWithConsole:(XMNWebViewConsole *)console {
    
    if (self = [super initWithNibName:@"XMNWebDebugConsoleController" bundle:XMNWebConsoleBundle()]) {
        
        self.console = console;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

#pragma mark - Override Method

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
    
    self.consoleInputView.console = self.console;
    
    
    __weak typeof(*&self) wSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:XMNWebViewConsoleDidAddMessageNotification
                                                      object:self.console
                                                       queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
                                                           
                                                           __strong typeof(*&wSelf) self = wSelf;
                                                           [self. tableView  reloadData];
                                                       }];

    [[NSNotificationCenter defaultCenter] addObserverForName:XMNWebViewConsoleDidClearMessagesNotification
                                                      object:self.console
                                                       queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
                                                           
                                                           __strong typeof(*&wSelf) self = wSelf;
                                                           [self. tableView  reloadData];
                                                       }];
}

#pragma mark - Private Method

- (void)setupUI {
    
    self.navigationItem.title = NSLocalizedString(@"Debug Console", @"Debug Console");
    
    if (!self.tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:self.tableView];
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60.f;
    [self.tableView registerNib:[UINib nibWithNibName:@"XMNWebViewConsoleMessageCell" bundle:XMNWebConsoleBundle()] forCellReuseIdentifier:@"XMNWebViewConsoleMessageCell"];
}

#pragma mark - UITableViewDelegate & UITableViewSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.console.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XMNWebViewConsoleMessageCell *messageCell = [tableView dequeueReusableCellWithIdentifier:@"XMNWebViewConsoleMessageCell"];
    [messageCell configCellWithMessage:self.console.messages[indexPath.row]];
    return messageCell;
}

/// ========================================
/// @name   Support Cell Menu
/// ========================================

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

-(BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    
    return (action == @selector(copy:));
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    if (action == @selector(copy:)) {
        
        XMNWebViewConsoleMessage * message = self.console.messages[indexPath.row];
        if (message) {
            [UIPasteboard generalPasteboard].string = message.message;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
