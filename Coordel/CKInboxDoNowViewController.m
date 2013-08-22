//
//  CKInboxDoNowViewController.m
//  Coordel iPhone
//
//  Created by Jeffry Gorder on 8/17/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#import "AppDelegate.h"

#import "CKInboxDoNowViewController.h"
#import "CKEditNameCell.h"
#import "CKEditPurposeCell.h"
#import "CKTaskAction.h"
#import <AVFoundation/AVAudioPlayer.h>
#import "CKTaskInformViewController.h"

static NSString *kNameCell = @"nameCell";
static NSString *kPurposeCell = @"purposeCell";

@interface CKInboxDoNowViewController ()

@property AppDelegate *app;

@property NSTimer *theTimer;
@property NSDateComponents *components;
@property NSDate *targetDate;
@property NSCalendar *cal;
@property NSInteger counter;
//@property (nonatomic, strong) AVAudioPlayer *buzzer;
//@property (nonatomic, strong) AVAudioPlayer *onTime;
@property BOOL beatTimer;
@property BOOL timerExpired;

@end

@implementation CKInboxDoNowViewController

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
    
     _app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [self showTimer];
    
    [self.tableView registerClass:[CKEditNameCell class] forCellReuseIdentifier:kNameCell];
    
    [self.tableView registerClass:[CKEditPurposeCell class] forCellReuseIdentifier:kPurposeCell];

    [self.navigationController setToolbarHidden:NO];
    
    UIBarButtonItem *tell = [[UIBarButtonItem alloc]initWithTitle:kLocalizedTell style:UIBarButtonItemStyleBordered target:self action:@selector(tell)];
    
    self.navigationItem.rightBarButtonItem = tell;
    
    [self.progressBar setTintColor:kCKColorInbox];
    [self.progressBar setProgress:1.0];
    
    
    /*
    UIBarButtonItem *informBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"next.png"] landscapeImagePhone:[UIImage imageNamed:@"next.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(inform)];
    
    [informBarButton setTintColor:kCKColorInbox];
     */
    
    
    UIBarButtonItem *interruptBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"quick"] landscapeImagePhone:[UIImage imageNamed:@"quick"] style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    [interruptBarButton setTintColor:kCKColorInbox];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    [self setToolbarItems:@[interruptBarButton, space] animated:YES];
    
    
    
    

    /*
    NSString *soundPath =[[NSBundle mainBundle] pathForResource:@"timer-buzzer" ofType:@"caf"];
    
    NSString *onTimePath =[[NSBundle mainBundle] pathForResource:@"timer-success" ofType:@"caf"];
    NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
    NSURL *successURL = [NSURL fileURLWithPath:onTimePath];
    
    
    NSError *error = nil;
    _buzzer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
    [_buzzer prepareToPlay];
    _onTime = [[AVAudioPlayer alloc] initWithContentsOfURL:successURL error:&error];
    [_onTime prepareToPlay];
    */

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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
        /*
        if (indexPath.row == 0){
            return [tableView dequeueReusableCellWithIdentifier:kNameCell];
        } else if (indexPath.row == 1){
            return [tableView dequeueReusableCellWithIdentifier:kPurposeCell];
        }
         */
        CKEditNameCell *nameCell = [tableView dequeueReusableCellWithIdentifier:kNameCell];
        
        nameCell.textField.text = _action.task.name;
        return nameCell;

    } else {
        if (indexPath.section ==1){
            cell.textLabel.text = kLocalizedList;
            cell.detailTextLabel.text =   @"Quick list";
        } else if (indexPath.section == 2){
            cell.textLabel.text = kLocalizedDeliverables;
            cell.detailTextLabel.text = @"0";
        }
    }
    
    return cell;
}

- (void)tick {
    if (_counter == 0) {
        //Checks if the countdown completed
        if (!_beatTimer){
            _timerExpired = YES;
            NSString *title;
            title = [NSString stringWithFormat:@"%@ - %@", kLocalizedDoNow, @"00:00"];
            _progressBar.progress = 0;
            [self.navigationItem setTitle:title];
            [_app.failSound play];
            [self reset];
            
        }
        return;
    }
    
    long seconds = lroundf(_counter); // Modulo (%) operator below needs int or long
    
    
    //calculate the progress bar
    double progress = (double)1/120 * _counter;
    NSLog(@"progress %f %d %f", progress, _counter, (double)1/120);
    _progressBar.progress = progress;

    
    
    int min = seconds / 60;
    int sec = seconds % 60;
    
    //make sure the seconds are padded correctly
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPaddingCharacter:@"0"];
    [numberFormatter setMinimumIntegerDigits:2];
    
    NSString *minOut = [numberFormatter stringFromNumber:[NSNumber numberWithInteger:min]];
    
    NSString *secOut = [numberFormatter stringFromNumber:[NSNumber numberWithInteger:sec]];
    
    NSString *output = [NSString stringWithFormat:@"%@ - %@:%@", kLocalizedDoNow, minOut, secOut];
    NSLog(@"output %@", output);
    [self.navigationItem setTitle:output];
    _counter -= 1;
}

- (void)showTimer {
    
    _beatTimer = NO;
    _timerExpired = NO;
    
    NSString *title;
    
    title = [NSString stringWithFormat:@"%@ - %@", kLocalizedDoNow, @"02:00"];
    [self.navigationItem setTitle:title];
    
    if (!_counter) {
        //set the number of seconds for the timer
        _counter = 120;
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

- (void)tell {
    
    if (!_timerExpired) {
        _beatTimer = YES;
        [_app.successSound play];
        [_theTimer invalidate];
    }
    
     
    
    CKTaskInformViewController *taskInform = [[CKTaskInformViewController alloc] initWithAction:_action];
    [self.navigationController pushViewController:taskInform animated:YES];
    
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound){
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        [_theTimer invalidate];
        [self.navigationController setToolbarHidden:YES];
    }
    [super viewWillDisappear:animated];
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

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];

    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
 
 */

@end
