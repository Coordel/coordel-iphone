//
//  CKList.h
//  Coordel iPhone
//
//  Created by Jeffry Gorder on 8/13/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#import "CKUser.h"
#import "CKList.h"
#import "CKListAssignment.h"

@interface CKList : PFObject<PFSubclassing>

+ (NSString *)parseClassName;
+ (CKList *)defaultObject;
- (void)addDefaultUserList: (CKUser *)user;
- (NSString *)timeZoneView;

//name of the list
@property (nonatomic) NSString *name;

//purpose of the list
@property (nonatomic) NSString *purpose;

//the organizer is the person who makes the decisions about the list and defaults to the list creator
@property (nonatomic) NSString *organizer;

//start date of the list. defaults to now.
@property (nonatomic) NSDate *starts;

//deadline of the list. defaults to seven days from now. user should be able to change the default in settings
@property (nonatomic) NSDate *deadline;

//time zone of the user who created the list. all deadlines will be contrained to the time zone of the list.
@property (nonatomic) NSString *timeZone;

//assignments hold the people and their individual statuses in the list the key to the dictionary will be the username, and the value will contain a dictionary with two keys role, and status
@property (nonatomic) NSMutableDictionary *assignments;

//the status tells the overall status of the list like active, cancelled, paused, etc (see CKListStatus enum)
@property (nonatomic) NSInteger status;

//the type tells whether this is a discussion, a personal list, or the private list (see CKListType enum)
@property (nonatomic) NSInteger type;

//supporting documents for the list
@property (nonatomic) NSMutableArray *attachments;

//madePublic is true if the list shows for anyone. the default is false;
@property (assign, nonatomic, getter=isMadePublic) BOOL madePublic;

//templated is true if the list has been blueprinted. the default is false;
@property (assign, nonatomic, getter=isTemplated) BOOL templated;

@end
