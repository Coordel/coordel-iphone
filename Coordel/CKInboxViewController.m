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

@interface CKInboxViewController ()

@end

@implementation CKInboxViewController

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
	// Do any additional setup after loading the view.
    
    [self showPrimaryNavBar:self.segmentIndex];
    
    SWRevealViewController *revealController = [self revealViewController];
    
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    
    self.navigationController.navigationBar.tintColor = kCKColorInbox;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSLog(@"segmentedIndex %d", self.segmentIndex);
	segmentedControl.selectedSegmentIndex = self.segmentIndex;
	segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.frame = CGRectMake(0, 0, 150, 30);
	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	
	//defaultTintColor = [segmentedControl.tintColor retain];	// keep track of this for later
    
	self.navigationItem.titleView = segmentedControl;
}


@end
