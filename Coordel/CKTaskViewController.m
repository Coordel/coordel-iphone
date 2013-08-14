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
#import <AVFoundation/AVAudioPlayer.h>
#import "CKTaskNameCell.h"


@interface CKTaskViewController ()

@property NSTimer *theTimer;
@property NSDateComponents *components;
@property NSDate *targetDate;
@property NSCalendar *cal;
@property NSInteger counter;
@property (nonatomic, strong) AVAudioPlayer *buzzer;
@property (nonatomic, strong) AVAudioPlayer *onTime;
@property BOOL beatTimer;
@property BOOL timerExpired;

@end

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
    
    
    //put the cells here for testing purposes
    [self.tableView registerNib:[UINib nibWithNibName:@"CKTaskNameCell"
                                                   bundle:[NSBundle mainBundle]]
             forCellReuseIdentifier:@"TaskNameCellReuseID"];

    
    [self.tableView setDataSource:_action];
  
    if (_action.actionType == CKTaskActionTypeDoNow){
        [self showTimer:YES];
    } else {
        [self.navigationItem setTitle:_action.navigationTitle];
    }
    
    
    [self.navigationController setToolbarHidden:NO];
    [self.navigationController.toolbar setTintColor:kCKColorLightGray];
    
    UIBarButtonItem *informBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"next.png"] landscapeImagePhone:[UIImage imageNamed:@"next.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(inform)];
    
    [informBarButton setTintColor:kCKColorInbox];
    
    UIBarButtonItem *interruptBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Interrupt" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [interruptBarButton setTintColor:kCKColorInbox];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
   
    [self setToolbarItems:@[interruptBarButton,space, informBarButton] animated:YES];
    
    NSString *soundPath =[[NSBundle mainBundle] pathForResource:@"timer-buzzer" ofType:@"caf"];
    
    NSString *onTimePath =[[NSBundle mainBundle] pathForResource:@"timer-success" ofType:@"caf"];
    NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
    NSURL *successURL = [NSURL fileURLWithPath:onTimePath];

    
    NSError *error = nil;
    _buzzer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
    _onTime = [[AVAudioPlayer alloc] initWithContentsOfURL:successURL error:&error];

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

/*
#pragma mark - Table view data source


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

#pragma Timer

- (void)tick {
    if (_counter == 0) {
        //Checks if the countdown completed
        if (!_beatTimer){
            _timerExpired = YES;
            [self.navigationItem setTitle:@"00:00"];
            [self.buzzer play];
            [self reset];
            
        }
        return;
    }
    
    long seconds = lroundf(_counter); // Modulo (%) operator below needs int or long
    
    int min = seconds / 60;
    int sec = seconds % 60;
    
    //make sure the seconds are padded correctly
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPaddingCharacter:@"0"];
    [numberFormatter setMinimumIntegerDigits:2];
    
    NSString *minOut = [numberFormatter stringFromNumber:[NSNumber numberWithInteger:min]];
    
    NSString *secOut = [numberFormatter stringFromNumber:[NSNumber numberWithInteger:sec]];
    
    NSString *output = [NSString stringWithFormat:@"%@:%@", minOut, secOut];
    NSLog(@"output %@", output);
    [self.navigationItem setTitle:output];
    _counter -= 1;
}

- (void)showTimer:(BOOL)on {
    
    _beatTimer = NO;
    _timerExpired = NO;
    
    [self.navigationItem setTitle:@"02:00"];
    
    if (!_counter) {
        _counter = 3;
    }
    
    
    if (_counter > 0) {
        _theTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    }
    else {
        _counter = 0;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot countdown because time is before now" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}


- (void)reset {
    [_theTimer invalidate];
    _theTimer = nil;
    _targetDate = nil;
    
    self.navigationController.title = @"";
}

- (void)inform {
    if (!_timerExpired) {
        _beatTimer = YES;
        [self.onTime play];
        [_theTimer invalidate];
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
