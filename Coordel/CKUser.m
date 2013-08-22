//
//  CKUser.m
//  Coordel iPhone
//
//  Created by Jeffry Gorder on 8/13/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#import "CKUser.h"
#import <Parse/PFObject+Subclass.h>

@implementation CKUser

@dynamic defaultList;
@dynamic fullName;

+ (CKUser *)currentUser {
    return (CKUser *)[PFUser currentUser];
}

@end
