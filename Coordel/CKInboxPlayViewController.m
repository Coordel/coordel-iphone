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
#import "CKInboxDoNowViewController.h"
#import "CKTaskAction.h"
#import "CKTaskInformViewController.h"



@interface CKInboxPlayViewController () <UIActionSheetDelegate> //<MCOMessageViewDelegate>

@property CKInboxMessageView *messageView;
@property CKInbox *inbox;
@property AppDelegate *app;
@property NSInteger playBatchSize;
@property MCOMessageParser *msg;
@property NSInteger msgUID;
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


- (void)viewWillAppear:(BOOL)animated {
    if (_app.actionCompleted){
        [self showNextMessage];
        _app.actionCompleted = NO;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    _app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    _inbox = [_app inbox];

    //[self.navigationItem setHidesBackButton:YES];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPlay:)];
    [self.navigationItem setLeftBarButtonItem:leftBarButton];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"action"] landscapeImagePhone:[UIImage imageNamed:@"action"] style:UIBarButtonItemStyleBordered target:self action:@selector(showActions:)];
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
    NSString *barTitle =[NSString stringWithFormat:@"E-mail %d of %d", _app.inboxPlayCount, _app.inboxPlayBatch.count];
    
    [self.navigationItem setTitle:barTitle];
}


- (void) showNextMessage
{
    NSLog(@"inbox play count %d, inbox batch size %d", _app.inboxPlayCount, _app.inboxPlayBatch.count);
    if (_app.inboxPlayCount < _app.inboxPlayBatch.count) {
        
        NSDictionary *next = [_app inboxPlayGetNextMessage];
        
        _msgUID = [[next valueForKey:kCKInboxDataMessagesEntityUIDKey] intValue];
        
        NSLog(@"next message %@", next);
        MCOIMAPFetchContentOperation * op = [[_inbox IMAPSessionForAccount:@""] fetchMessageByUIDOperationWithFolder:@"INBOX" uid:_msgUID];
        
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
        [self dismissViewControllerAnimated:YES completion:nil];
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
    
    NSLog(@"sender %@ ACTION %ld", _msg.header, (long)actionIndex);
    
        
    CKTaskAction *act;
   
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @"E-mail"
                                   style: UIBarButtonItemStyleBordered
                                   target: nil action: nil];
    
    [self.navigationItem setBackBarButtonItem: backButton];
    
    switch (actionIndex) {
        case 0:
             act = [[CKTaskAction alloc]initWithEmail:_msg forAction:[self actionTypeFromIndex:actionIndex] withUID:_msgUID];
            [self doNow:act];
            break;
        case 3:
            [self attachMessage:act];
            break;

        case 4:
            [self archiveMessage:act];
            break;
            
        case 5:
            [self deleteMessage:act];
            break;
            
        default:
            act = [[CKTaskAction alloc]initWithEmail:_msg forAction:[self actionTypeFromIndex:actionIndex] withUID:_msgUID];
            [self addTask:act];
            break;

            
    }
    
}

- (void)doNow:(CKTaskAction *)act {
    CKInboxDoNowViewController *doNowView = [[CKInboxDoNowViewController alloc] initWithAction:act];
    [self.navigationController pushViewController:doNowView animated:YES];
}

- (void)addTask:(CKTaskAction *)act {
    CKTaskViewController *deferTask = [[CKTaskViewController alloc] initWithAction:act];
    [self.navigationController pushViewController:deferTask animated:YES];
}

- (void)attachMessage:(CKTaskAction *)act{
    
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: nil
                                                             delegate: self
                                                    cancelButtonTitle: nil
                                               destructiveButtonTitle: nil
                                                    otherButtonTitles: nil];
    
 
    [actionSheet addButtonWithTitle: @"Attach to List"];
    [actionSheet addButtonWithTitle: @"Attach to Task"];

    
    [actionSheet addButtonWithTitle: @"Cancel"];
    [actionSheet setCancelButtonIndex: 2];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
}

- (void)archiveMessage:(CKTaskAction *)act {
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:nil
                                                            delegate:self cancelButtonTitle:@"Cancel"
                                              destructiveButtonTitle:@"Archive Message"
                                                   otherButtonTitles:@"Archive and Tell", nil];
    
    popupQuery.actionSheetStyle = UIActionSheetStyleDefault;
    [popupQuery showInView:self.view];
}

- (void)deleteMessage:(CKTaskAction *)act {
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:nil
                                                            delegate:self cancelButtonTitle:@"Cancel"
                                              destructiveButtonTitle:@"Delete Message"
                                                   otherButtonTitles:@"Delete and Tell", nil];
    
    popupQuery.actionSheetStyle = UIActionSheetStyleDefault;
    [popupQuery showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if  ([buttonTitle isEqualToString:@"Delete Message"]) {
        NSLog(@"Delete pressed --> Delete Message");
        [_app.inbox deleteMessage:_msgUID];
        [self showNextMessage];
    }
    if  ([buttonTitle isEqualToString:@"Archive Message"]) {
        NSLog(@"Archive pressed --> Archive Message");
        [_app.inbox archiveMessage:_msgUID toFolderName:@"[Coordel]/Archive"];
        [self showNextMessage];
    }
    if ([buttonTitle isEqualToString:@"Delete and Tell"]) {
        NSLog(@"Delete and Tell pressed");
        
        CKTaskAction *act = [[CKTaskAction alloc]initWithEmail:_msg forAction:CKTaskActionTypeDelete withUID:_msgUID];
        
        CKTaskInformViewController *taskInform = [[CKTaskInformViewController alloc] initWithAction:act];
        [self.navigationController pushViewController:taskInform animated:YES];
        
    }
    if ([buttonTitle isEqualToString:@"Archive and Tell"]) {
        NSLog(@"Archive and Tell pressed");
        CKTaskAction *act = [[CKTaskAction alloc]initWithEmail:_msg forAction:CKTaskActionTypeArchive withUID:_msgUID];
        
        CKTaskInformViewController *taskInform = [[CKTaskInformViewController alloc] initWithAction:act];
        [self.navigationController pushViewController:taskInform animated:YES];
    }
    if  ([buttonTitle isEqualToString:@"Attach to List"]) {
        NSLog(@"Attach to List pressed --> Show List Picker");
    }
    if  ([buttonTitle isEqualToString:@"Attach to Task"]) {
        NSLog(@"Attach to Task pressed --> Show Task Picker");
    }
    if ([buttonTitle isEqualToString:@"Cancel"]) {
        NSLog(@"Cancel pressed --> Cancel ActionSheet");
    }
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
    [_app.failSound play];
    [self showNextMessage];
}
@end
