//
//  CKListViewController.m
//  Coordel iPhone
//
//  Created by Jeffry Gorder on 8/14/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#import "CKListViewController.h"
#import "SZTextView.h"
#import "CKList.h"
#import "CKTaskNameCell.h"

enum {
	ListSectionName,
    ListSectionSchedule,
    ListSectionPeople,
    ListSectionAttachments
} ListSections;




#define kPickerAnimationDuration    0.40   // duration for the animation to slide the date picker into view
#define kDatePickerTag              99     // view tag identifiying the date picker view

#define kTitleKey       @"title"   // key for obtaining the data source item's title
#define kDateKey        @"date"    // key for obtaining the data source item's date value
#define kTextKey        @"text"    // key for obtaining the data source item's text value

// keep track of which rows have date cells
#define kDateStartRow   2
#define kDateEndRow     3

static NSString *kDateCellID = @"dateCell";     // the cells with the start or end date
static NSString *kDatePickerID = @"datePicker"; // the cell containing the date picker
static NSString *kFieldCellID = @"fieldCell";     // the cells with field (name)

static NSString *kTextCellID = @"textCell";     // the cells with textview (purpose)
static NSString *kValueCellID = @"valueCell";   // the cells that show a value for the title (timeZone, people count, etc)
static NSString *kTypePickerCellID = @"typePicker"; //cell that lets the user pick the type of list (personal, discussion)
static NSString *kOtherCell = @"otherCell";     // the remaining cells at the end


@interface CKListViewController () <UITextViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

// keep track which indexPath points to the cell with UIDatePicker
@property (nonatomic, strong) NSIndexPath *datePickerIndexPath;

@property (assign) NSInteger pickerCellRowHeight;

@property (nonatomic, strong) IBOutlet UIDatePicker *pickerView;

@property (nonatomic, strong) IBOutlet SZTextView *textView;

@property (nonatomic, strong) IBOutlet UITextField *fieldView;

@end

@implementation CKListViewController

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
    if (!self.list){
        self.list =[CKList defaultObject];
    }
   
    // setup our data source
    NSMutableDictionary *itemName = [@{ kTitleKey : kLocalizedName, kTextKey: self.list.name} mutableCopy];
    NSMutableDictionary *itemPurpose = [@{ kTitleKey : kLocalizedPurpose, kTextKey: self.list.purpose } mutableCopy];
    NSMutableDictionary *itemStarts = [@{ kTitleKey : kLocalizedStarts,
                                       kDateKey : self.list.starts } mutableCopy];
    NSMutableDictionary *itemDeadline = [@{ kTitleKey : kLocalizedDeadline,
                                         kDateKey : self.list.deadline } mutableCopy];
    NSMutableDictionary *itemTimezone = [@{ kTitleKey : kLocalizedTimezone, kTextKey:self.list.timeZoneView} mutableCopy];
    NSMutableDictionary *itemPeople = [@{ kTitleKey : kLocalizedPeople, kTextKey:[NSString stringWithFormat:@"%d",self.list.assignments.count]} mutableCopy];
    NSMutableDictionary *itemAttachments = [@{ kTitleKey : kLocalizedSupportingDocuments, kTextKey:[NSString stringWithFormat:@"%d",self.list.attachments.count] } mutableCopy];
    self.dataArray = @[itemName, itemPurpose, itemStarts, itemDeadline, itemTimezone, itemPeople, itemAttachments];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];    // show short-style date format
    [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    // obtain the picker view cell's height
    
    self.pickerCellRowHeight = 216;

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

#pragma mark - Utilities

/*! Returns the major version of iOS, for iOS 6.1.3 it returns 6.
 */
NSUInteger DeviceSystemMajorVersion()
{
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    
    return _deviceSystemMajorVersion;
}

#define EMBEDDED_DATE_PICKER (DeviceSystemMajorVersion() >= 7)

/*! Determines if the given indexPath has a cell below it with a UIDatePicker.
 
 @param indexPath The indexPath to check if its cell has a UIDatePicker below it.
 */
- (BOOL)hasPickerForIndexPath:(NSIndexPath *)indexPath
{
    BOOL hasDatePicker = NO;
    
    NSInteger targetedRow = indexPath.row;
    targetedRow++;
    
    UITableViewCell *checkDatePickerCell =
    [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:targetedRow inSection:0]];
    
    UIDatePicker *checkDatePicker = (UIDatePicker *)[checkDatePickerCell viewWithTag:kDatePickerTag];
    
    hasDatePicker = (checkDatePicker != nil);;
    return hasDatePicker;
}

/*! Updates the UIDatePicker's value to match with the date of the cell above it.
 */
- (void)updateDatePicker
{
    if (self.datePickerIndexPath != nil)
    {
        UITableViewCell *associatedDatePickerCell = [self.tableView cellForRowAtIndexPath:self.datePickerIndexPath];
        
        UIDatePicker *targetedDatePicker = (UIDatePicker *)[associatedDatePickerCell viewWithTag:kDatePickerTag];
        if (targetedDatePicker != nil)
        {
            // we found a UIDatePicker in this cell, so update it's date value
            //
            NSDictionary *itemData = self.dataArray[self.datePickerIndexPath.row - 1];
            [targetedDatePicker setDate:[itemData valueForKey:kDateKey] animated:NO];
        }
    }
}

/*! Determines if the UITableViewController has a UIDatePicker in any of its cells.
 */
- (BOOL)hasInlineDatePicker
{
    return (self.datePickerIndexPath != nil);
}

/*! Determines if the given indexPath points to a cell that contains the UIDatePicker.
 
 @param indexPath The indexPath to check if it represents a cell with the UIDatePicker.
 */
- (BOOL)indexPathHasPicker:(NSIndexPath *)indexPath
{
    return ([self hasInlineDatePicker] && self.datePickerIndexPath.row == indexPath.row);
}

/*! Determines if the given indexPath points to a cell that contains the start/end dates.
 
 @param indexPath The indexPath to check if it represents start/end date cell.
 */
- (BOOL)indexPathHasDate:(NSIndexPath *)indexPath
{
    BOOL hasDate = NO;
    
    if ((indexPath.row == kDateStartRow) ||
        (indexPath.row == kDateEndRow || ([self hasInlineDatePicker] && (indexPath.row == kDateEndRow + 1))))
    {
        hasDate = YES;
    }
    
    return hasDate;
}


#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ([self indexPathHasPicker:indexPath] ? self.pickerCellRowHeight : self.tableView.rowHeight);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self hasInlineDatePicker])
    {
        // we have a date picker, so allow for it in the number of rows in this section
        NSInteger numRows = self.dataArray.count;
        return ++numRows;
    }
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    NSString *cellID = kOtherCell;
    
    if ([self indexPathHasPicker:indexPath])
    {
        // the indexPath is the one containing the inline date picker
        cellID = kDatePickerID;     // the current/opened date picker cell
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kDatePickerID  ];
            
            _pickerView = [[UIDatePicker alloc] init];
            _pickerView.datePickerMode = UIDatePickerModeDateAndTime;
            _pickerView.tag = kDatePickerTag;
            
            [_pickerView addTarget:self action:@selector(dateAction:) forControlEvents:UIControlEventValueChanged];
            
            [cell.contentView addSubview:_pickerView];
        }
        

    }
    else if ([self indexPathHasDate:indexPath])
    {
        // the indexPath is one that contains the date information
        cellID = kDateCellID;       // the start/end date cells
    }
    //cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    
    if (indexPath.row == 0)
    {
        cellID = kFieldCellID;
        
        // this is a name cell so should be a text type
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else if (indexPath.row == 1){
        cellID = kTextCellID;
    }
    
    // if we have a date picker open whose cell is above the cell we want to update,
    // then we have one more cell than the model allows
    //
    NSInteger modelRow = indexPath.row;
    if (self.datePickerIndexPath != nil && self.datePickerIndexPath.row < indexPath.row)
    {
        modelRow--;
    }
    
    NSDictionary *itemData = self.dataArray[modelRow];
    
    // proceed to configure our cell
    if ([cellID isEqualToString:kDateCellID])
    {
        // we have either start or end date cells, populate their date field
        //
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kDateCellID];
            cell.textLabel.text = [itemData valueForKey:kTitleKey];
            cell.detailTextLabel.text = [self.dateFormatter stringFromDate:[itemData valueForKey:kDateKey]];
        }
    }
    else if ([cellID isEqualToString:kOtherCell])
    {
        // this cell is a non-date cell, just assign it's text label
        //
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kOtherCell];
            cell.textLabel.text = [itemData valueForKey:kTitleKey];
        }
       
    } else if ([cellID isEqualToString:kFieldCellID]) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil){
           
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kFieldCellID  ];
            
            
            
            
            
            _fieldView = [[UITextField alloc] initWithFrame:CGRectMake(15,0,280,44)];
            
            [_fieldView setReturnKeyType:UIReturnKeyDone];
            
            _fieldView.delegate = self;
            
            _fieldView.placeholder = kLocalizedName;
            
            
            [_fieldView targetForAction:@selector(textChange) withSender:self];
            
            [cell.contentView addSubview:_fieldView];
            
        }
 
    } else if ([cellID isEqualToString:kTextCellID]){
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTextCellID  ];
            
            
            
    
            
            self.textView = [[SZTextView alloc] initWithFrame:CGRectMake(15,0,280,44)];
           
            [_textView setReturnKeyType:UIReturnKeyDone];

            _textView.textColor = [UIColor lightGrayColor];
            _textView.delegate = self;
            _textView.placeholder = kLocalizedPurpose;
            _textView.placeholderTextColor = kCKColorPlaceholderGray;
     
       
            [_textView targetForAction:@selector(purposeChange:) withSender:self];
            
            [cell.contentView addSubview:self.textView];
            
            
        }
    }
    
	return cell;
}

/*! Adds or removes a UIDatePicker cell below the given indexPath.
 
 @param indexPath The indexPath to reveal the UIDatePicker.
 */
- (void)revealDatePickerForSelectedIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView beginUpdates];
    
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
    
    // check if 'indexPath' has an attached date picker below it
    if ([self hasPickerForIndexPath:indexPath])
    {
        // found a picker below it, so remove it
        [self.tableView deleteRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        // didn't find a picker below it, so we should insert it
        [self.tableView insertRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [self.tableView endUpdates];
}

/*! Reveals the date picker inline for the given indexPath, called by "didSelectRowAtIndexPath".
 
 @param indexPath The indexPath to reveal the UIDatePicker.
 */
- (void)displayInlineDatePickerForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // display the date picker inline with the table content
    [self.tableView beginUpdates];
    
    BOOL before = NO;   // indicates if the date picker is below "indexPath", help us determine which row to reveal
    if ([self hasInlineDatePicker])
    {
        before = self.datePickerIndexPath.row < indexPath.row;
    }
    
    BOOL sameCellClicked = (self.datePickerIndexPath.row - 1 == indexPath.row);
    
    // remove any date picker cell if it exists
    if ([self hasInlineDatePicker])
    {
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.datePickerIndexPath.row inSection:0]]
                              withRowAnimation:UITableViewRowAnimationFade];
        self.datePickerIndexPath = nil;
    }
    
    if (!sameCellClicked)
    {
        // hide the old date picker and display the new one
        NSInteger rowToReveal = (before ? indexPath.row - 1 : indexPath.row);
        NSIndexPath *indexPathToReveal = [NSIndexPath indexPathForRow:rowToReveal inSection:0];
        
        [self revealDatePickerForSelectedIndexPath:indexPathToReveal];
        self.datePickerIndexPath = [NSIndexPath indexPathForRow:indexPathToReveal.row + 1 inSection:0];
    }
    
    // always deselect the row containing the start or end date
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.tableView endUpdates];
    
    // inform our date picker of the current date to match the current cell
    [self updateDatePicker];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.reuseIdentifier == kDateCellID)
    {
        
        [self displayInlineDatePickerForRowAtIndexPath:indexPath];
       
    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


#pragma mark - Actions

/*! User chose to change the date by changing the values inside the UIDatePicker.
 
 @param sender The sender for this action: UIDatePicker.
 */
- (IBAction)dateAction:(id)sender
{
    NSIndexPath *targetedCellIndexPath = nil;
    
    if ([self hasInlineDatePicker])
    {
        // inline date picker: update the cell's date "above" the date picker cell
        //
        targetedCellIndexPath = [NSIndexPath indexPathForRow:self.datePickerIndexPath.row - 1 inSection:0];
    }
    else
    {
        // external date picker: update the current "selected" cell's date
        targetedCellIndexPath = [self.tableView indexPathForSelectedRow];
    }
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:targetedCellIndexPath];
    UIDatePicker *targetedDatePicker = sender;
    
    // update our data model
    NSMutableDictionary *itemData = self.dataArray[targetedCellIndexPath.row];
    [itemData setValue:targetedDatePicker.date forKey:kDateKey];
    
    // update the cell's date string
    cell.detailTextLabel.text = [self.dateFormatter stringFromDate:targetedDatePicker.date];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    //    [textView resignFirstResponder];
    NSLog(@"textviewchange %@", textView.text);
}


- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }else{
        return YES;
    }
}



@end
