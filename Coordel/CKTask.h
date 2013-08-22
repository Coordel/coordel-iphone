//
//  CKTask.h
//  Coordel iPhone
//
//  Created by Jeffry Gorder on 8/7/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#import "CKUser.h"
#import "CKTask.h"
#import "CKList.h"


@interface CKTask : PFObject<PFSubclassing>

//name of the task. defaults to "No name"
@property (nonatomic) NSString *name;

//purpose of the task
@property (nonatomic) NSString *purpose;

//owner is the person who made the promise to do the task. defaults to the person creating the task
@property (nonatomic) NSString *owner;

//delegator is the person who created the task for someone else. could be the responsible of the list or could be another participant in the list
@property (nonatomic) NSString *delegator;

//starts defaults to now, but can be set to any time in the future
@property (nonatomic) NSDate *starts;

//deadline can be left out, but will always exist based on the deadline of the list
@property (nonatomic) NSDate *deadline;

//timezone defaults to the timezone of the list if in a discussion or to the user's timezone if in a personal list
@property (nonatomic) NSString *timeZone;

//the list this task is part of
@property (nonatomic) NSString *list;

//the status of the task i.e. delegated, accepted, in the enum CKTaskStatus
@property (nonatomic) NSInteger status;

//templated is true if the task has been blueprinted. the default is false;
@property (assign, nonatomic, getter=isTemplated) BOOL templated;


+ (NSString *)parseClassName;
+ (CKTask *)defaultObject;
- (NSDate *)derivedDeadline;
- (NSString *)startsView;
- (NSString *)deadlineView;
- (NSString *)timeZoneView;
- (NSString *)ownerView;

@end

