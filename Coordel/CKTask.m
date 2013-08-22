//
//  CKTask.m
//  Coordel iPhone
//
//  Created by Jeffry Gorder on 8/7/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#import "CKTask.h"
#import <Parse/PFObject+Subclass.h>

@implementation CKTask

@dynamic name;
@dynamic purpose;
@dynamic owner;
@dynamic delegator;
@dynamic starts;
@dynamic deadline;
@dynamic timeZone;
@dynamic list;
@dynamic status;
@dynamic templated;


+ (NSString *)parseClassName {
    return @"Task";
}

+(CKTask *) defaultObject{
    CKTask  *task = [CKTask object];
    if(task){
        CKUser *user = [CKUser currentUser];
        task.name = @"";
        task.purpose = @"";
        task.owner = user.objectId;
        task.delegator = nil;
        task.starts = [NSDate date];
        task.deadline = nil;
        task.timeZone = [NSTimeZone localTimeZone].abbreviation;
        task.list = user.defaultList;
        task.status = CKTaskStatusAccepted;
        task.templated = NO;
    }
    return task;
}

- (NSDate *)derivedDeadline {
    
    CKUser *user = [CKUser currentUser];
    NSDate *deadline = [NSDate date];
    
    int dayInterval = 7;
    
    if (self.list == user.defaultList){
        //if we are in the default user list, then default to a week from now
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSUInteger flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
        
        deadline = [self.starts dateByAddingTimeInterval:(60 * 60 * 24 * dayInterval)];
        
        NSDateComponents *components = [calendar components:flags fromDate:deadline];
        
        deadline = [calendar dateFromComponents:components];

    } else {
        //need to load the list's deadline and set it to it's deadline
    }
    
  
    return deadline;
}

- (NSString *)startsView {
    return [CKUtility formattedDate:self.starts];
}

- (NSString *)deadlineView {
    NSDate *deadline;
    if (self.deadline){
        
        deadline = self.deadline;
        
    } else {
        deadline = [self derivedDeadline];
    }
    
    return [CKUtility formattedDate:deadline];

}

- (NSString *)timeZoneView {
    NSString *zone = [[NSTimeZone timeZoneWithAbbreviation:self.timeZone] localizedName:NSTimeZoneNameStyleGeneric locale:[NSLocale currentLocale]];
    return zone;
}

- (NSString *)ownerView {
    CKUser *user = [CKUser currentUser];
    if (self.owner == user.objectId){
        return user.fullName;
    } else {
       return @"Not done yet";
    }
}


@end
