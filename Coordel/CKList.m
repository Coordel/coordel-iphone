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

@implementation CKList

@dynamic name;
@dynamic purpose;
@dynamic organizer;
@dynamic deadline;
@dynamic assignments;
@dynamic status;
@dynamic type;
@dynamic madePublic;
@dynamic templated;

+ (NSString *)parseClassName {
    return @"List";
}

- (void)addPrivateUserList: (CKUser *)user {
    /*
    CKList *list = [CKList object];
    list.name = kLocalizedQuickList;
    [list setObject:user forKey:@"responsible"];
    
    //set the list status to active by default
    list.status = CKListStatusActive;
    
    //create an accepted responsible assigment for this user
    CKListAssignment *assign = [[CKListAssignment alloc]init];
    assign.listRole = CKListRoleResponsible;
    assign.listRoleStatus = CKListRoleStatusAccepted;
    assign.listRoleName = kLocalizedResponsible;
    
    [list.assignments setObject:assign forKey:user.objectId];
    
    [list saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error){
            
            
            NSLog(@"error");
            
        } else {
            
        }
        
        
    }];
    */
}


@end
