//
//  CKInboxPlayViewController.m
//  Coordel iPhone
//
//  Created by Jeffry Gorder on 8/3/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#import "AppDelegate.h"

#import "CKInbox.h"
#import "CKInboxPlayViewController.h"
#import <CoreGraphics/CoreGraphics.h>
#import <ImageIO/ImageIO.h>
#import "CKInboxMessageView.h"
#import <MailCore/MailCore.h>
#import "CKInboxActionBar.h"


@interface CKInboxPlayViewController () //<MCOMessageViewDelegate>

@property CKInboxMessageView *messageView;
@property CKInbox *inbox;
@property CKInboxActionBar *actions;

@property AppDelegate *app;
@property int playBatchSize;

@end

@implementation CKInboxPlayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    _inbox = [_app inbox];
    
        // Do any additional setup after loading the view from its nib.
    _messageView = [[CKInboxMessageView alloc] initWithFrame:_messageContainer.bounds];
    _messageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_messageContainer addSubview:_messageView];
    
    
    [self showNextMessage];
    
    //[self showActionBar];

}


- (void) showNextMessage
{
    NSLog(@"inbox play count %d, inbox batch size %d", _app.inboxPlayCount, _app.inboxPlayBatchSize);
    if (_app.inboxPlayCount < _app.inboxPlayBatchSize) {
        
        NSDictionary *next = [_app inboxPlayGetNextMessage];
        
        int uid = [[next valueForKey:kCKInboxDataMessagesEntityUIDKey] intValue];
        
        NSLog(@"next message %@", next);
        MCOIMAPFetchContentOperation * op = [[_inbox IMAPSessionForAccount:@""] fetchMessageByUIDOperationWithFolder:@"INBOX" uid:uid];
        
        [op start:^(NSError * error, NSData * data) {
            if ([error code] != MCOErrorNone) {
                return;
            }
            
            NSAssert(data != nil, @"data != nil");
            
            MCOMessageParser * msg = [MCOMessageParser messageParserWithData:data];
            
            NSLog(@"message %@", msg);
            _messageView.message = msg;
            [_messageView refresh];
            
        }];
    } else {
        NSLog(@"we're done");
    }
    
}

/*
- (void) showActionBar
{
    // To get the vertical location we start at the top of the tab bar (0), go up by the height of the notification view, then go up another 2 pixels so our view is slightly above the tab bar
     _actions = [[CKInboxActionBar alloc]init];
    
    UIView *bar = [[UIView alloc]initWithFrame:CGRectMake(0, - _actions.view.frame.size.height, self.view.frame.size.width, _actions.view.frame.size.height)];
    
    [bar addSubview:_actions.view];

    self.toolBar.contentMode = UIViewContentModeRedraw;
    
    if (!bar.superview)
        [self.toolBar addSubview:bar];
    
    
   
}
 */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelPlay:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)skip:(id)sender {
    
    [self showNextMessage];
    
}

@end
