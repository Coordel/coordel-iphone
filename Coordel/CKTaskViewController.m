//
//  CKTaskViewController.m
//  Coordel iPhone
//
//  Created by Jeffry Gorder on 8/7/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#import "CKTaskViewController.h"
#import "CKTask.h"
#import "CKTaskAction.h"
#import "CKEditNameCell.h"
#import "CKEditPurposeCell.h"
#import "CKTaskInformViewController.h"

static NSString *kNameCell = @"nameCell";
static NSString *kPurposeCell = @"purposeCell";


@implementation CKTaskViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self.tableView registerClass:[CKEditNameCell class] forCellReuseIdentifier:kNameCell];
    
    [self.tableView registerClass:[CKEditPurposeCell class] forCellReuseIdentifier:kPurposeCell];

    
    [self.tableView setDataSource:self];
  

    [self.navigationItem setTitle:_action.actionTemplate.actionTitle];
   
    [self.navigationController setToolbarHidden:NO];
    
    UIBarButtonItem *tell = [[UIBarButtonItem alloc]initWithTitle:kLocalizedTell style:UIBarButtonItemStyleBordered target:self action:@selector(tell)];
    
    self.navigationItem.rightBarButtonItem = tell;
    
    UIBarButtonItem *interruptBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"quick"] landscapeImagePhone:[UIImage imageNamed:@"quick"] style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    [interruptBarButton setTintColor:kCKColorInbox];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [self setToolbarItems:@[interruptBarButton,space] animated:YES];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if(section == 0)
    {
        return 0.0;
    }
    return UITableViewAutomaticDimension;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    if (indexPath.section == 0 && indexPath.row == 1){
        /*
        CGSize size = [_action.task.purpose sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14] constrainedToSize:CGSizeMake(280, 999) lineBreakMode:UILineBreakModeWordWrap];
        
        */
        
        NSAttributedString *purpose = [[NSAttributedString alloc]initWithString:_action.task.purpose];
        
        CGRect rect =  [purpose boundingRectWithSize:CGSizeMake(280.0f, CGFLOAT_MAX)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                     context:nil];
        
        return rect.size.height + 20;
    
    }
    
    return UITableViewAutomaticDimension;

}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = 1;
    if (section == 0){
        count = 2;
    } else if (section == 1){
        count = 3;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *kOtherCell = @"otherCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOtherCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kOtherCell];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    
    
    if (indexPath.section == 0){
        //name and purpose cells
        
        if (indexPath.row == 0){
            CKEditNameCell *nameCell = [tableView dequeueReusableCellWithIdentifier:kNameCell];
            
            nameCell.textField.text = _action.task.name;
            return nameCell;

        } else if (indexPath.row == 1){
            CKEditPurposeCell *purposeCell = [tableView dequeueReusableCellWithIdentifier:kPurposeCell];
            
            purposeCell.textView.text = _action.task.purpose;
            [purposeCell.textView sizeThatFits:purposeCell.textView.bounds.size];
    
            return purposeCell;

        }
        
    } else if (indexPath.section == 1){
        //schedule
        if (indexPath.row == 0){
            //starts
            cell.textLabel.text = kLocalizedStarts;
            cell.detailTextLabel.text = _action.task.startsView;
            //cell.imageView.image = [UIImage imageNamed:@"start"];
            
        } else if (indexPath.row == 1){
            //deadline
            cell.textLabel.text = kLocalizedDeadline;
            cell.detailTextLabel.text = _action.task.deadlineView;
            //cell.imageView.image = [UIImage imageNamed:@"deadline"];

        } else if (indexPath.row == 2){
            //timezone
            cell.textLabel.text = kLocalizedTimezone;
            cell.detailTextLabel.text = _action.task.timeZoneView;
        }
        
    } else if (indexPath.section == 2) {
        cell.textLabel.text = kLocalizedOwner;
        cell.detailTextLabel.text = _action.task.ownerView;
    } else {
        if (indexPath.section ==3){
            cell.textLabel.text = kLocalizedList;
            cell.detailTextLabel.text =   @"Quick List";
        } else if (indexPath.section == 4){
            cell.textLabel.text = kLocalizedDeliverables;
            cell.detailTextLabel.text = @"0";
        } else if (indexPath.section == 5){
            cell.textLabel.text = kLocalizedBlockers;
            cell.detailTextLabel.text = @"0";
        } else if (indexPath.section == 6){
            cell.textLabel.text = kLocalizedSupportingDocuments;
            cell.detailTextLabel.text = @"0";
        }
    }
    
    return cell;
}

- (void)tell {
    
    CKTaskInformViewController *taskInform = [[CKTaskInformViewController alloc] initWithAction:_action];
    [self.navigationController pushViewController:taskInform animated:YES];
    
}




/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    NSInteger sections = [[self sectionKeys] count];
    
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [[self sectionKeys] objectAtIndex:section];
    NSArray *contents = [[self sectionContents] objectForKey:key];
    NSInteger rows = [contents count];
    
    return rows;}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [[self sectionKeys] objectAtIndex:[indexPath section]];
    NSArray *contents = [[self sectionContents] objectForKey:key];
    NSString *contentForThisRow = [contents objectAtIndex:[indexPath row]];
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [[cell textLabel] setText:contentForThisRow];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    NSString *key = [[self sectionKeys] objectAtIndex:section];
    
    return key;
}


*/

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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (IBAction)cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound){
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        [self.navigationController setToolbarHidden:YES];
    }
    [super viewWillDisappear:animated];
}
@end
