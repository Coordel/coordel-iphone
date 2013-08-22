//
//  CKList.m
//  Coordel iPhone
//
//  Created by Jeffry Gorder on 8/13/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#import "CKList.h"
#import "CKUser.h"
#import <Parse/PFObject+Subclass.h>
#import "CKListAssignment.h"

@implementation CKList

@dynamic name;
@dynamic purpose;
@dynamic organizer;
@dynamic starts;
@dynamic deadline;
@dynamic timeZone;
@dynamic assignments;
@dynamic status;
@dynamic type;
@dynamic attachments;
@dynamic madePublic;
@dynamic templated;

+ (NSString *)parseClassName {
    return @"List";
}

+(CKList *) defaultObject{
    CKList* list = [CKList object];
    if(list){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        CKUser *user = [CKUser currentUser];
        
        list.name = @"";
        list.purpose = @"";
        list.organizer = user.objectId;
        list.assignments = [[NSMutableDictionary alloc]init];
        
        //create a default assigment for the the organizer of the list
        CKListAssignment *assign = [[CKListAssignment alloc]init];
        assign.listRole = CKListRoleOrganizer;
        assign.listRoleStatus = CKListRoleStatusAccepted;
        assign.listRoleName = kLocalizedOrganizer;
        [list.assignments setObject:assign forKey:user.objectId];
        
        
        //set up the starts, deadline and timezone
        NSInteger dayInterval = [[defaults objectForKey:kCKUserDefaultsListDefaultDeadlineDayInterval] integerValue];
        
        if (!dayInterval) {
            [defaults setValue:@"7" forKey:kCKUserDefaultsListDefaultDeadlineDayInterval];
            [defaults synchronize];
            dayInterval = 7;
        }
        
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSUInteger flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
        NSDate *starts = [NSDate date];
        NSDate *deadline = [starts dateByAddingTimeInterval:(60 * 60 * 24 * dayInterval)];
        NSDateComponents *components = [calendar components:flags fromDate:deadline];
        
        list.starts = starts;
        list.deadline = [calendar dateFromComponents:components];
        list.timeZone = [NSTimeZone localTimeZone].abbreviation;
        
        //set the default status
        list.status = CKListStatusActive;
        list.type = CKListTypeDefault;
        list.attachments = [[NSMutableArray alloc]init];
        list.madePublic = NO;
        list.templated = NO;
        
    }
    return list;
}

- (NSString *)timeZoneView {
    NSString *zone = [[NSTimeZone timeZoneWithAbbreviation:self.timeZone] localizedName:NSTimeZoneNameStyleGeneric locale:[NSLocale currentLocale]];
    return zone;
}


- (void)addDefaultUserList: (CKUser *)user {
    
    CKList *list = [CKList object];
    list.name = kLocalizedQuickList;
    list.organizer = user.objectId;
    
    //set the list status to active by default
    list.status = CKListStatusActive;
    
    list.type = CKListTypeDefault;
    
    //create an accepted responsible assigment for this user
    CKListAssignment *assign = [[CKListAssignment alloc]init];
    assign.listRole = CKListRoleOrganizer;
    assign.listRoleStatus = CKListRoleStatusAccepted;
    assign.listRoleName = kLocalizedOrganizer;
    
    [list.assignments setObject:assign forKey:user.objectId];
    
    [list saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error){
            
            
            NSLog(@"error");
            
        } else {
            
        }
        
    }];

}


@end
