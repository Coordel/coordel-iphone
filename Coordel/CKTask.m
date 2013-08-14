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
@dynamic deadline;
@dynamic list;
@dynamic status;
@dynamic templated;


+ (NSString *)parseClassName {
    return @"Task";
}


@end
