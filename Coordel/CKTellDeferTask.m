//
//  CKTellDeferTask.m
//  Coordel iPhone
//
//  Created by Jeffry Gorder on 8/21/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#import "CKTellDeferTask.h"

@implementation CKTellDeferTask


- (id)initWithTaskAction:(CKTaskAction *)taskAction{
    self = [super initWithTaskAction:taskAction];
    if (self){
        //do some stuff
    }
    return self;
}


- (NSString *)getSubject{
    
    NSString *subject;
    
    //we know if this is a new task or if it's an edit based on whether the task has an objectid yet
    if (!self.task.objectId){
        subject = [NSString stringWithFormat:@"%@ : %@", @"Task Added", self.task.name];
    } else {
        subject = [NSString stringWithFormat:@"%@ : %@", @"Task Deferred", self.task.name];
    }
    
    return subject;
}


- (NSString *)getBody{
    
    NSMutableString *body = [[NSMutableString alloc]init];
    
    //if this is a new deferral it means that the task was just created
    if (!self.task.objectId){
        //the task was added so need to recap what was done
        //tell what you did
        [body appendString:@"I created a new Task for myself based on the e-mail you sent on "];
        
        //append email send date of email
        [body appendString:[CKUtility formattedDate:self.email.header.receivedDate]];
        [body appendString:@".\n\n"];
        
        //append the task purpose...if there is one
        if (self.task.purpose && self.task.purpose.length){
            [body appendString:@"Task purpose:\n"];
            [body appendString:self.task.purpose];
            [body appendString:@"\n\n"];
        };
        
        //append when it will start
        [body appendString:@"The new Task is scheduled to start on "];
        
        //append the task start date
        [body appendString:self.task.startsView];
        
        //append when it will start
        [body appendString:@". \n\nIt will be done by "];
        
        //append the task's deadline
        [body appendString:self.task.deadlineView];
        [body appendString:@".\n\n"];
        
    } else {
        
        [body appendString:@"I have reschedule this Task.\n\n"];
        
        //append when it will start
        [body appendString:@"The Task is now scheduled to start on "];
        
        //append the task start date
        [body appendString:self.task.startsView];
        
        //append when it will start
        [body appendString:@", and it will be completed by "];
        
        //append the task's deadline
        [body appendString:self.task.deadlineView];
        [body appendString:@".\n\n"];
        
        [body appendString:@"Please don't hesitate to contact me if this change causes unintended problems "];
    }
    
    return [NSString stringWithString:body];
}




@end
