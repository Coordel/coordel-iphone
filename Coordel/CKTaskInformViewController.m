//
//  CKTaskInformViewController.m
//  Coordel iPhone
//
//  Created by Jeffry Gorder on 8/9/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#import "AppDelegate.h"

#import "CKTaskInformViewController.h"
#import "CKUtility.h"
#import "CKEmailAccount.h"
#import "CKUser.h"
#import "CKTellTemplate.h"
#import "CKTellDoNow.h"
#import "CKTellDeleteEmail.h"
#import "CKTellArchiveEmail.h"
#import "CKTellDeferTask.h"


@interface CKTaskInformViewController ()

@property AppDelegate *app;
@property CKTellTemplate *tellTemplate;

@end

@implementation CKTaskInformViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithAction:(CKTaskAction *)action
{
    self = [super init];
    if (self){
        _action = action;
        switch (action.actionType) {
            case (CKTaskActionTypeDoNow):
                _tellTemplate = [[CKTellDoNow alloc] initWithTaskAction:_action];
                break;
            case CKTaskActionTypeDelete:
                _tellTemplate = [[CKTellDeleteEmail alloc] initWithTaskAction:_action];
                break;
            case CKTaskActionTypeArchive:
                _tellTemplate = [[CKTellArchiveEmail alloc] initWithTaskAction:_action];
                break;
            case (CKTaskActionTypeDefer):
                _tellTemplate = [[CKTellDeferTask alloc] initWithTaskAction:_action];
                break;
        }

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    _app = (AppDelegate*)[[UIApplication sharedApplication] delegate];

    [self.navigationController setToolbarHidden:YES];
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finishAction)];
    
    self.navigationItem.rightBarButtonItem = done;
    
    _toLabel.text = _action.email.header.from.displayName;
    if (!_toLabel.text.length){
        _toLabel.text = _action.email.header.from.mailbox;
    }
    _subjectLabel.text = _tellTemplate.subject;
    
    _personalMessage.placeholder = kLocalizedPersonalMessage;
    _personalMessage.placeholderTextColor = kCKColorPlaceholderGray;
    
    _templateMessage.text = _tellTemplate.body;
    

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)finishAction {
    _app.actionCompleted = YES;
    [_action.task saveInBackground];
    [self.navigationController popToRootViewControllerAnimated:YES];

}

- (void)sendMessage {
    
    
    MCOMessageBuilder * builder = [[MCOMessageBuilder alloc] init];
    CKUser *user = [CKUser currentUser];

    //custom headers as required
    [[builder header] addHeaderValue:@"headerValue" forName:@"headerName"];
    
    //from
    [[builder header] setFrom:[MCOAddress addressWithDisplayName:user.fullName mailbox:user.email]];
    
    //to
    [[builder header] setTo:@[[MCOAddress addressWithDisplayName:_action.email.header.from.displayName mailbox:_action.email.header.from.mailbox]]];
    
    //cc
    NSMutableArray *cc = [[NSMutableArray alloc] init];
    for(MCOAddress *ccAddress in _action.email.header.cc) {
        [cc addObject:ccAddress];
    }
    [[builder header] setCc:cc];
    
    //subject
    [[builder header] setSubject:_subjectLabel.text];
    
    //body
    [builder setHTMLBody:[NSString stringWithFormat:@"%@ \n\n %@", _personalMessage.text, _templateMessage.text]];
    
    [_app.inbox sendMessage:builder];
}

@end
