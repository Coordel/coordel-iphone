//
//  CKInboxViewController.m
//  Coordel
//
//  Created by Jeffry Gorder on 7/27/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#import "SWRevealViewController.h"
#import "CKInboxViewController.h"
#import "CKListsViewController.h"
#import "CKTasksViewController.h"
#import "MailCore/MailCore.h"


@interface CKInboxViewController ()
@property NSArray *fetchedHeaders;
@property NSDate *earliestMessageReceivedDate;
@property NSDate *sliderDate;
    
@end

@implementation CKInboxViewController

@synthesize slider;
@synthesize sliderLabel;
@synthesize inboxCount;
@synthesize fetchedHeaders;
@synthesize earliestMessageReceivedDate;
@synthesize sliderDate;


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
    [self loadInboxHeaders];

    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self showPrimaryNavBar:self.segmentIndex];
    
    SWRevealViewController *revealController = [self revealViewController];
    
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    
    self.navigationController.navigationBar.tintColor = kCKColorInbox;
    

    //set up the slider
    slider.continuous = YES; // Make the slider 'stick' as it is moved.
    [slider setMinimumValue:0];
    [slider setMaximumValue:100];

    
}

//for the slider, we'll get the earliest date of inbox messages and then divide
//the total seconds between then and now by 100 to get the slider steps.


- (int)getSliderInterval
{
    NSDate *currentDate = [NSDate date];
    NSLog(@"received date %@", self.earliestMessageReceivedDate);
    NSTimeInterval sliderInterval = [currentDate timeIntervalSinceDate:self.earliestMessageReceivedDate]/100;
    
    

    return sliderInterval;
}

- (NSString *)getSliderLabel:(NSDate *)fromSliderDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd, YYYY, hh:mm a"];
    
    
    NSString *stringFromDate = [formatter stringFromDate:fromSliderDate];
    
    return stringFromDate;
}
 

/*
 the inbox count is a function of the interval selected by the slider. when the user moves the slider, the earliestDate + (slider position * the interval)  is used to calculate the startdate to search.
 
 use a predicate to search the headers for the messages received since that startdate and return the count of messages found
 */

- (int)getInboxCount:(int)sliderIndex
{
    
    //NSDate *currentDate = [NSDate date];
    
    //get all, no need to calculate if 0
    if (sliderIndex == 0){
        sliderLabel.text = [self getSliderLabel:earliestMessageReceivedDate];
        return fetchedHeaders.count;
    } else {
        
        NSDate *startDate = [[NSDate alloc] initWithTimeInterval:(sliderIndex * [self getSliderInterval]) sinceDate:earliestMessageReceivedDate];
        
        sliderDate = startDate;
        
        sliderLabel.text = [self getSliderLabel:startDate];
        
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(header.receivedDate >= %@)", startDate];
        
        NSArray *filteredArray = [fetchedHeaders filteredArrayUsingPredicate:predicate];
        
        return filteredArray.count;
    }
   
}

- (void)setInboxCountLabel
{
    NSUInteger index = (NSUInteger)(slider.value);
    [slider setValue:index animated:YES];
    NSLog(@"index: %i", index);
    inboxCount.text = [NSString stringWithFormat:@"%d",[self getInboxCount:index]];
}



- (void)loadInboxHeaders
{
    MCOIMAPSession *session = [[MCOIMAPSession alloc] init];
    
    /*
     [session setHostname:@"imap.mail.yahoo.com"];
     [session setPort:993];
     [session setUsername:@"coordel.demo1@yahoo.com"];
     [session setPassword:@"Coordel1129"];
     [session setConnectionType:MCOConnectionTypeTLS];
     */
    
   
    
    [session setHostname:@"imap.gmail.com"];
    [session setPort: 993];
    [session setUsername:@"jeffgorder@gmail.com"];
    [session setPassword:@"Secure1129"];
    [session setConnectionType:MCOConnectionTypeTLS];
    
    
    NSString *folder = @"INBOX";
    
    MCOIMAPFetchFoldersOperation * allFolders = [session fetchAllFoldersOperation];
    [allFolders start:^(NSError * error, NSArray *folders) {
        for (MCOIMAPFolder *f in folders){
            NSLog(@"folder flags %@ %u",f.path, f.flags);
        };
    }];

    
    
    MCOIMAPFolderInfoOperation *info = [session folderInfoOperation:folder];
    
    [info start:^(NSError *error, MCOIMAPFolderInfo *info){
        NSLog(@"message count %d", info.messageCount);
        
        
        inboxCount.text = [NSString stringWithFormat:@"%d",info.messageCount];
    }];
    
    MCOIMAPCapabilityOperation *cap = [session capabilityOperation];
    
    [cap start:^(NSError *error, MCOIndexSet *capabilities) {
        NSLog(@"capabilities %@", capabilities);
    }];
    
    MCOIMAPFolderStatusOperation * op = [session folderStatusOperation:@"INBOX"];
    [op start:^(NSError *error, MCOIMAPFolderStatus * status) {
        NSLog(@"UIDNEXT: %lu", (unsigned long) [status uidNext]);
        NSLog(@"UIDVALIDITY: %lu", (unsigned long) [status uidValidity]);
        NSLog(@"folder status message count: %d", [status messageCount]);
        
        
    }];
    
    
       
    //MCOIMAPMessagesRequestKind requestKind = MCOIMAPMessagesRequestKindHeaders;
    
    
    
    MCOIMAPMessagesRequestKind requestKind = (MCOIMAPMessagesRequestKind)
    (MCOIMAPMessagesRequestKindHeaders);
    
    
   
    MCOIndexSet *uids = [MCOIndexSet indexSetWithRange:MCORangeMake(1, UINT64_MAX)];
    
    /*
     MCOIMAPFetchFoldersOperation *fetchFolderOperation = [session fetchAllFoldersOperation];
     [fetchFolderOperation start:^(NSError *error, NSArray *folders) {
     
     for (MCOIMAPFolder *item in folders){
     NSLog(@"Path %@, Delimeter %hhd, Flags %u", item.path, item.delimiter, item.flags);
     }
     
     }];
     */
    
    
    MCOIMAPFetchMessagesOperation *fetchOperation = [session fetchMessagesByUIDOperationWithFolder:folder requestKind:requestKind uids:uids];
    
    [fetchOperation start:^(NSError * error, NSArray * fetchedMessages, MCOIndexSet * vanishedMessages) {
        //We've finished downloading the messages!
        
        //Let's check if there was an error:
        if(error) {
            NSLog(@"Error downloading message headers:%@", error);
        }
        
        NSLog(@"messages count:%d", fetchedMessages.count);
        
        fetchedHeaders = fetchedMessages;
        MCOIMAPMessage *first = fetchedMessages[0];
        
        self.earliestMessageReceivedDate = first.header.receivedDate;
        NSLog(@"earliest receive date %@ %@", first.header.receivedDate, self.earliestMessageReceivedDate);

        [self setInboxCountLabel];
        
        
        
            }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)valueChanged:(id)sender
{
    [self setInboxCountLabel];
}


- (IBAction)segmentAction:(id)sender
{
	// The segmented control was clicked, handle it here
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    
    int index = segmentedControl.selectedSegmentIndex;
    
    if (index == 0){
        CKListsViewController *listsController = [[CKListsViewController alloc] init];
        listsController.segmentIndex=0;
        [self.navigationController pushViewController:listsController animated:NO];
        
        
    } else if (index == 1){
        CKTasksViewController *tasksController = [[CKTasksViewController alloc] init];
        tasksController.segmentIndex=1;
        [self.navigationController pushViewController:tasksController animated:NO];
        
    } else if (index == 2){
        CKInboxViewController *inboxController = [[CKInboxViewController alloc] init];
        inboxController.segmentIndex=2;
        [self.navigationController pushViewController:inboxController animated:NO];
        
    }
    
	//NSLog(@"Segment clicked: %d", segmentedControl.selectedSegmentIndex);
    
}

- (void)showPrimaryNavBar:(int)primaryNavSegmentedIndex{
    
    NSArray *segmentTextContent = [NSArray arrayWithObjects:[UIImage imageNamed:@"lists-icon.png"], [UIImage imageNamed:@"tasks-icon.png"],[UIImage imageNamed:@"inbox-icon.png"],nil];
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
    segmentedControl.selectedSegmentIndex = self.segmentIndex;
	segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.frame = CGRectMake(0, 0, 150, 30);
	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	
	//defaultTintColor = [segmentedControl.tintColor retain];	// keep track of this for later
    
	self.navigationItem.titleView = segmentedControl;
    
    NSLog(@"segmentedIndex %d", self.segmentIndex);

    
}

@end
