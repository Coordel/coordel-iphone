//
//  CKInboxViewController.m
//  Coordel
//
//  Created by Jeffry Gorder on 7/27/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#import "AppDelegate.h"

#import "SWRevealViewController.h"
#import "CKInboxViewController.h"
#import "CKListsSegmentViewController.h"
#import "CKTasksSegmentViewController.h"
#import "CKInboxPlayViewController.h"
#import "MailCore/MailCore.h"
#import "CKInbox.h"


@interface CKInboxViewController ()

@property NSArray *fetchedHeaders;
@property NSDate *earliestMessageReceivedDate;
@property NSDate *sliderDate;
@property CKInbox *inbox;

@property AppDelegate *app;
    
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

- (void)viewWillAppear:(BOOL)animated{
    [self setInboxCountLabel];
}


- (void)viewDidLoad
{
   

    
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    
    _app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    _inbox = [_app inbox];
    
    _earliestMessageReceivedDate = [_inbox fetchEarliestMessageReceivedDate];
    
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *savedDate = [_inbox fetchInboxSliderDate];
    
    
    //set up the slider
    _slider.continuous = YES; // Make the slider 'stick' as it is moved.
    [_slider setMinimumValue:0];
    [_slider setMaximumValue:100];
    NSLog(@"slider is:%@",_slider);
    
    
    if (savedDate){
        int sliderInterval = [self getSliderInterval];
        //diff saved date and earliest/interval gives index
        NSTimeInterval interval = [savedDate timeIntervalSinceDate:_earliestMessageReceivedDate];
        int sliderIndex = interval/sliderInterval;
        _slider.value = sliderIndex;
        [self setInboxCountLabel];
    } else {
        [self setInboxCountLabel];
    }
    
    SWRevealViewController *revealController = [self revealViewController];
    
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;

    
    self.navigationController.navigationBar.tintColor = kCKColorInbox;
    self.segmentIndex = 2;
    [self showPrimaryNavBar];
    

    
}

//for the slider, we'll get the earliest date of inbox messages and then divide
//the total seconds between then and now by 100 to get the slider steps.


- (int)getSliderInterval
{
    NSDate *currentDate = [NSDate date];
    //NSLog(@"received date %@", _earliestMessageReceivedDate);
    NSTimeInterval sliderInterval = [currentDate timeIntervalSinceDate:_earliestMessageReceivedDate]/100;

    return sliderInterval;
}

- (void)setSliderIndex:(NSDate *)byDate
{
    //we know the time interval
    //we know there are 100 slots
    
    //diff saved date and earliest/interval gives index
    NSTimeInterval sliderIndex = [byDate timeIntervalSinceDate:_earliestMessageReceivedDate]/[self getSliderInterval];
    _slider.value = sliderIndex;
}

- (NSString *)getSliderLabel:(NSDate *)fromSliderDate
{
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDoesRelativeDateFormatting:YES];
    [formatter setDateStyle: NSDateFormatterLongStyle];
    [formatter setTimeStyle: NSDateFormatterShortStyle];
    
 
    NSString *formattedDateTime = [formatter stringFromDate:fromSliderDate];
    
    
    
    
    return formattedDateTime;
}


- (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate
{
    // Use the user's current calendar and time zone
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    
    // Selectively convert the date components (year, month, day) of the input date
    NSDateComponents *dateComps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:inputDate];
    
    // Set the time components manually
    [dateComps setHour:0];
    [dateComps setMinute:0];
    [dateComps setSecond:0];
    
    // Convert back
    NSDate *beginningOfDay = [calendar dateFromComponents:dateComps];
    return beginningOfDay;
}
 

/*
 the inbox count is a function of the interval selected by the slider. when the user moves the slider, the earliestDate + (slider position * the interval)  is used to calculate the startdate to search.
 
 use a predicate to search the headers for the messages received since that startdate and return the count of messages found
 */

- (int)getInboxCount:(int)sliderIndex
{

    NSDate *currentDate = [NSDate date];
    //NSArray *headers = [_inbox fetchHeadersFromStartDate:date];
    //get all, no need to calculate if 0
    
    NSDate *startDate = currentDate;
    
    if (sliderIndex == 0){
        startDate = _earliestMessageReceivedDate;
    } else {
        
        startDate = [[NSDate alloc] initWithTimeInterval:(sliderIndex * [self getSliderInterval]) sinceDate:_earliestMessageReceivedDate];
        
        _sliderDate = startDate;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:startDate forKey:@"inboxSliderDate"];
        [defaults synchronize];

        
        
    }
    
    NSArray *headers = [_inbox fetchHeadersFromStartDate:startDate];
    
    _sliderLabel.text = [self getSliderLabel:startDate];
    
    
    return headers.count;

}

- (void)setInboxCountLabel
{
        
    NSUInteger index = (NSUInteger)(_slider.value);
    [_slider setValue:index animated:YES];
    //NSLog(@"index: %i", index);
    _inboxCount.text = [NSString stringWithFormat:@"%d",[self getInboxCount:index]];
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
    
    _app.segmentIndex = segmentedControl.selectedSegmentIndex;
    [_app presentAppSegment];
    
    /*
    
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
     */
    
	//NSLog(@"Segment clicked: %d", segmentedControl.selectedSegmentIndex);
    
}

- (void)showPrimaryNavBar{
    
    NSArray *segmentTextContent = [NSArray arrayWithObjects:[UIImage imageNamed:@"lists-icon.png"], [UIImage imageNamed:@"tasks-icon.png"],[UIImage imageNamed:@"inbox-icon.png"],nil];
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
    segmentedControl.selectedSegmentIndex = self.segmentIndex;
	segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	segmentedControl.frame = CGRectMake(0, 0, 150, 30);
	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	
	//defaultTintColor = [segmentedControl.tintColor retain];	// keep track of this for later
    
	self.navigationItem.titleView = segmentedControl;
    
    NSLog(@"segmentedIndex inboxViewController %d", self.segmentIndex);
    
    
}

- (IBAction)startPlay:(id)sender {
    //show the play controller modally
    [_app inboxPlayStarted];
    //[_app presentInboxPlayViewController];
    //create the controller
    
    CKInboxPlayViewController *play = [[CKInboxPlayViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:play];
    nav.navigationBar.tintColor = kCKColorInbox;
    
    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:nav  animated:YES completion: nil];
    //[self.navigationController pushViewController:play animated:YES];
}
@end
