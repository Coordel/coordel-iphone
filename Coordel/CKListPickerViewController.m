//
//  CKListPickerViewController.m
//  Coordel iPhone
//
//  Created by Jeffry Gorder on 8/22/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#import "CKListPickerViewController.h"
#import "CKUser.h"

@interface CKListPickerViewController ()

@property BOOL isAdded;

@end

@implementation CKListPickerViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"List";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"name";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = NO;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 5;
        
    }
    return self;
}

- (PFQuery *)queryForTable {
    NSLog(@"current user in task %@ %@", [CKUser currentUser], [CKUser.currentUser objectId]);
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:@"organizer" equalTo:[CKUser.currentUser objectId]];
    
    
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByAscending:@"name"];
    
    
    return query;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.isAdded = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate listPickerDidSelectList:[self.objects objectAtIndex:indexPath.row] added:self.isAdded];
    
}

@end
