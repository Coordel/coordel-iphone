//
//  CKRevealViewController.m
//  Coordel
//
//  Created by Jeffry Gorder on 7/27/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//


#import "SWRevealViewController.h"
#import "CKRevealViewController.h"
#import "CKListsSegmentViewController.h"
#import "CKTasksSegmentViewController.h"
#import "CKInboxViewController.h"
#import "CKSettingsViewController.h"



@interface CKRevealViewController ()

@end

@implementation CKRevealViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self navigationController] setNavigationBarHidden:YES];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSInteger row = indexPath.row;
	
	
	if (nil == cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:cellIdentifier];
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	}
	
    //we leave row 0 blank to leave a space at the top of the reveal page
    //it might perhaps hold the Coordel logo or another header of some kind
	if (row == 0)
	{
		cell.textLabel.text = @"";
	}
	else if (row == 1)
	{
		cell.textLabel.text = kLocalizedLists;
        cell.imageView.image = [UIImage imageNamed:@"lists-icon-green.png"];
        
	}
	else if (row == 2)
	{
		cell.textLabel.text = kLocalizedTasks;
        cell.imageView.image = [UIImage imageNamed:@"tasks-icon-blue.png"];
        
       
	}
	else if (row == 3)
	{
		cell.textLabel.text = kLocalizedInbox;
        cell.imageView.image = [UIImage imageNamed:@"inbox-icon-red.png"];
       
        
	}
    else if (row == 4)
	{
		cell.textLabel.text = kLocalizedSettings;
        cell.imageView.image = [UIImage imageNamed:@"settings-icon-black.png"];
	}
	return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Grab a handle to the reveal controller, as if you'd do with a navigtion controller via self.navigationController.
    SWRevealViewController *revealController = self.revealViewController;
    
    // We know the frontViewController is a NavigationController
    UINavigationController *frontNavigationController = (id)revealController.frontViewController;  // <-- we know it is a NavigationController
    NSInteger row = indexPath.row;
    
    
    
	// Here you'd implement some of your own logic... I simply take for granted that the first row (=1) corresponds to the "FrontViewController".
	if (row == 1)
	{
		// Now let's see if we're not attempting to swap the current listsViewController for a new instance of ITSELF, which'd be highly redundant.
        if ( ![frontNavigationController.topViewController isKindOfClass:[CKListsSegmentViewController class]] )
        {
			CKListsSegmentViewController *listsViewController = [[CKListsSegmentViewController alloc] init];
            
            listsViewController.segmentIndex = 0;
            
            
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:listsViewController];
        
            
			[revealController setFrontViewController:navigationController animated:YES];
        }
		// Seems the user attempts to 'switch' to exactly the same controller he came from!
		else
		{
			[revealController revealToggle:self];
		}
	}
    
	// ... and the second row (=2) corresponds to the "Tasks".
	else if (row == 2)
	{
		// Now let's see if we're not attempting to swap the current frontViewController for a new instance of ITSELF, which'd be highly redundant.
        if ( ![frontNavigationController.topViewController isKindOfClass:[CKTasksSegmentViewController class]] )
        {
			CKTasksSegmentViewController *tasksViewController = [[CKTasksSegmentViewController alloc] init];
            
            tasksViewController.segmentIndex = 1;

			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tasksViewController];
            
            
            
            
			[revealController setFrontViewController:navigationController animated:YES];
		}
        
		// Seems the user attempts to 'switch' to exactly the same controller he came from!
		else
		{
			[revealController revealToggle:self];
		}
	}
	else if (row == 3) //inbox
	{
        // Now let's see if we're not attempting to swap the current inboxViewController for a new instance of ITSELF, which'd be highly redundant.
        if ( ![frontNavigationController.topViewController isKindOfClass:[CKInboxViewController class]] )
        {
			CKInboxViewController *inboxViewController = [[CKInboxViewController alloc] init];
            
            inboxViewController.segmentIndex = 2;
            
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:inboxViewController];
            
			[revealController setFrontViewController:navigationController animated:YES];
		}
        
		// Seems the user attempts to 'switch' to exactly the same controller he came from!
		else
		{
			[revealController revealToggle:self];
		}

	}
	else if (row == 4) //settings
	{
        if ( ![frontNavigationController.topViewController isKindOfClass:[CKSettingsViewController class]] )
        {
			CKSettingsViewController *settingsViewController = [[CKSettingsViewController alloc] init];

            
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
            
			[revealController setFrontViewController:navigationController animated:YES];
		}
        
		// Seems the user attempts to 'switch' to exactly the same controller he came from!
		else
		{
			[revealController revealToggle:self];
		}
	}
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


@end
