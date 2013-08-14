//
//  CKTaskAction.h
//  Coordel iPhone
//
//  Created by Jeffry Gorder on 8/10/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MailCore/MailCore.h>
#import "CKTask.h"



@interface CKTaskAction : NSObject <UITableViewDataSource>


@property NSInteger actionType;
@property CKTask *task;
@property MCOMessageParser *email;

/*
 properties for the "Do" part of the action. This will usually require
 the user to edit a task. tasks will be edited in a grouped table so the action implements the UITableViewDataSource protocol
 */
@property (nonatomic, retain) IBOutlet UITableView *mainTableView;
@property (nonatomic, retain) NSMutableArray *sectionKeys;
@property (nonatomic, retain) NSMutableDictionary *sectionContents;
@property (nonatomic, retain) NSMutableDictionary *sectionFooters;
@property (readonly) NSString *navigationTitle;


//if there is an existing task for this action, init with that task
- (id)initWithTask: (CKTask *)task forAction:(NSInteger)actionType;

//if this is an email action, init with the email
- (id)initWithEmail: (MCOMessageParser *)email forAction:(NSInteger)actionType;



@end
