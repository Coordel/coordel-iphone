//
//  CKTaskViewController.h
//  Coordel iPhone
//
//  Created by Jeffry Gorder on 8/7/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#import "CKTaskAction.h"

@interface CKTaskViewController : UITableViewController

/*
@property (nonatomic, retain) IBOutlet UITableView *mainTableView;

 @property (nonatomic, retain) NSMutableArray *sectionKeys;
@property (nonatomic, retain) NSMutableDictionary *sectionContents;
*/

@property CKTaskAction *action;

@property NSString *taskName;
@property NSString *taskPurpose;

- (IBAction)cancel:(id)sender;

- (id)initWithAction: (CKTaskAction *)action;
@end
