//
//  CKTellTemplate.m
//  Coordel iPhone
//
//  Created by Jeffry Gorder on 8/20/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#import "CKTellTemplate.h"
#import <MailCore/MailCore.h>
#import "CKTaskAction.h"



@implementation CKTellTemplate

@synthesize subject = _subject;
@synthesize body = _body;


- (id)initWithTaskAction:(CKTaskAction *)taskAction {
    self = [super init];
    if (self){
        _email = taskAction.email;
        _task = taskAction.task;
    }
    return self;
}

- (NSString *)subject{
    
    return @"";
}


- (NSString *)body{
    
    return @"";
}



@end
