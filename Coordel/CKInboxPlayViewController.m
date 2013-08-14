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

#import "CKInboxMessageView.h"
#import <MailCore/MailCore.h>
#import "RNGridMenu.h"
#import "CKTaskViewController.h"
#import "CKTaskAction.h"



@interface CKInboxPlayViewController () //<MCOMessageViewDelegate>

@property CKInboxMessageView *messageView;
@property CKInbox *inbox;


@property AppDelegate *app;
@property int playBatchSize;

@property MCOMessageParser *msg;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

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
  

    //[self.navigationItem setHidesBackButton:YES];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPlay:)];
    [self.navigationItem setLeftBarButtonItem:leftBarButton];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"deadline-calendar.png"] landscapeImagePhone:[UIImage imageNamed:@"deadline-calendar.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(showCalendar:)];
    [self.navigationItem setRightBarButtonItems:@[rightBarButton] animated:YES];
    
    [self setNavigationBarTitle];
    /*
    NSString *barTitle =[NSString stringWithFormat:@"Message %d of %d", _app.inboxPlayCount + 1, _app.inboxPlayBatchSize];
    
    
    [self.navigationItem setTitle:barTitle];

     */
    
        // Do any additional setup after loading the view from its nib.
    _messageView = [[CKInboxMessageView alloc] initWithFrame:_messageContainer.bounds];
    _messageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_messageContainer addSubview:_messageView];
    
    
    [self showNextMessage];
    
    //[self showActionBar];

}

- (void) setNavigationBarTitle{
    NSString *barTitle =[NSString stringWithFormat:@"E-mail %d of %d", _app.inboxPlayCount, _app.inboxPlayBatchSize];
    
    [self.navigationItem setTitle:barTitle];
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
            
            _msg = [MCOMessageParser messageParserWithData:data];
            
            NSLog(@"message %@", _msg);
            _messageView.message = _msg;
            [_messageView refresh];
            
            
        }];
        [self setNavigationBarTitle];
    } else {
        NSLog(@"we're done");
    }
    
}

- (void)showList {
    NSInteger numberOfOptions = 6;
    NSArray *options = @[
                         @"Do now",
                         @"Defer",
                         @"Delegate",
                         @"Attach",
                         @"Archive",
                         @"Delete"                         ];
    RNGridMenu *av = [[RNGridMenu alloc] initWithTitles:[options subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    av.highlightColor = kCKColorInbox;
    //    av.itemTextAlignment = NSTextAlignmentLeft;
    av.itemFont = [UIFont boldSystemFontOfSize:18];
    av.itemSize = CGSizeMake(150, 55);
    [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
}

- (void)showGrid {
    NSInteger numberOfOptions = 6;
    NSArray *items = @[
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"do-it-menu"] title:@"Do Now"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"defer-menu"] title:@"Defer"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"delegate-menu"] title:@"Delegate"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"attach-menu"] title:@"Attach"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"archive-menu"] title:@"Archive"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"delete-menu"] title:@"Delete"]
                       ];
    
    RNGridMenu *av = [[RNGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    av.highlightColor = kCKColorInbox;
    //    av.bounces = NO;
    [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
}

- (void)gridMenu:(RNGridMenu *)gridMenu willDismissWithSelectedItem:(RNGridMenuItem *)item atIndex:(NSInteger)itemIndex {
    NSLog(@"Dismissed with item %d: %@", itemIndex, item.title);
    [self doAction:itemIndex];
}

- (NSInteger)actionTypeFromIndex:(NSInteger)index
{
    NSInteger type;
    
    switch (index) {
        case 0:
            type = CKTaskActionTypeDoNow;
            break;
            
        case 1:
            type = CKTaskActionTypeDefer;
            break;
            
        case 2:
            type = CKTaskActionTypeDelegate;
            break;
        case 3:
            type = CKTaskActionTypeAttachEmail;
            break;
        case 4:
            type = CKTaskActionTypeArchive;
            break;
        case 5:
            type = CKTaskActionTypeDelete;
            break;

    }

    return type;
}

- (void)doAction: (NSInteger)actionIndex {
    
    NSLog(@"sender %@", _msg.header);
    
        
    CKTaskAction *act = [[CKTaskAction alloc]initWithEmail:_msg forAction:[self actionTypeFromIndex:actionIndex]];
    CKTaskViewController *taskView = [[CKTaskViewController alloc] initWithAction:act];
    
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @"E-mail"
                                   style: UIBarButtonItemStyleBordered
                                   target: nil action: nil];
    
    [self.navigationItem setBackBarButtonItem: backButton];

    [self.navigationController pushViewController:taskView animated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelPlay:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showCalendar:(id)sender {
  
}

- (IBAction)showActions:(id)sender {
    [self showGrid];
}

- (IBAction)skipMessage:(id)sender {
    [self showNextMessage];
}
@end
