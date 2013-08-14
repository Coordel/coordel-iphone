//
//  CKTasksViewController.m
//  Coordel
//
//  Created by Jeffry Gorder on 7/27/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#import "AppDelegate.h"

#import "CKTasksSegmentViewController.h"
#import "SWRevealViewController.h"
#import "CKUser.h"

@interface CKTasksSegmentViewController ()

@property AppDelegate *app;

@end

@implementation CKTasksSegmentViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        
        // The className to query on
        self.parseClassName = @"Task";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"name";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 5;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showPrimaryNavBar];
    _app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
	// Do any additional setup after loading the view.
    SWRevealViewController *revealController = [self revealViewController];
    
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    self.navigationController.navigationBar.tintColor = kCKColorTasks;
    self.segmentIndex = 1;
    
    NSLog(@"segment indes for tasks %d",self.segmentIndex);

}

- (void)showPrimaryNavBar{
    
    NSArray *segmentTextContent = [NSArray arrayWithObjects:[UIImage imageNamed:@"lists-icon.png"], [UIImage imageNamed:@"tasks-icon.png"],[UIImage imageNamed:@"inbox-icon.png"],nil];
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
    NSLog(@"segmentedIndex baseSegmentedController %d", self.segmentIndex);
	segmentedControl.selectedSegmentIndex = self.segmentIndex;
	segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	segmentedControl.frame = CGRectMake(0, 0, 150, 30);
	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	
	//defaultTintColor = [segmentedControl.tintColor retain];	// keep track of this for later
    
	self.navigationItem.titleView = segmentedControl;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Override to customize what kind of query to perform on the class.
- (PFQuery *)queryForTable {
    NSLog(@"current user in task %@ %@", [CKUser currentUser], [CKUser.currentUser objectId]);
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:@"owner" equalTo:[CKUser.currentUser objectId]];
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByDescending:@"deadline"];

    return query;
}

- (IBAction)segmentAction:(id)sender
{
    
    
	// The segmented control was clicked, handle it here
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    
    _app.segmentIndex = segmentedControl.selectedSegmentIndex;
    [_app presentAppSegment];
    
    /*
     if (index == 0){
     CKListsViewController *listsController = [[CKListsViewController alloc] init];
     listsController.segmentIndex=0;
     [self.navigationController setViewControllers: [NSArray arrayWithObject: listsController]
     animated: NO];
     
     
     } else if (index == 1){
     CKTasksSegmentViewController *tasksController = [[CKTasksSegmentViewController alloc] init];
     tasksController.segmentIndex=1;
     //[self.navigationController pushViewController:tasksController animated:NO];
     [self.navigationController setViewControllers: [NSArray arrayWithObject: tasksController]
     animated: NO];
     
     } else if (index == 2){
     CKInboxViewController *inboxController = [[CKInboxViewController alloc] init];
     inboxController.segmentIndex=2;
     [self.navigationController setViewControllers: [NSArray arrayWithObject: inboxController]
     animated: NO];
     
     }
     */
	//NSLog(@"Segment clicked: %d", segmentedControl.selectedSegmentIndex);
    
}



@end
