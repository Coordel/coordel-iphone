//
//  CKTaskAction.m
//  Coordel iPhone
//
//  Created by Jeffry Gorder on 8/10/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#import "CKTaskAction.h"
#import "CKTaskActionTemplate.h"
#import "CKTaskActionDoNow.h"
#import "CKTaskActionDefer.h"
#import "CKTaskActionDelegate.h"




@implementation CKTaskAction

- (id)initWithEmail: (MCOMessageParser *)email forAction:(NSInteger)actionType withUID:(NSInteger)uid
{
    self = [super init];
    if (self) {
        
        //since this is from an email, we know there isn't a task yet
        //so make a new one
        _actionType = actionType;
        _email = email;
        _emailUID = uid;
        
        [self initializeActionTemplate:actionType];
        

        _task = [CKTask defaultObject];
        _task.name = self.actionTemplate.name;
        _task.purpose = self.actionTemplate.purpose;
        
        
    }
    return self;
}

- (id)initWithTask:(CKTask *)task forAction:(NSInteger)actionType
{
    self = [super init];
    if (self) {
        _task = task;
        _actionType = actionType;
        
        [self initializeActionTemplate:actionType];
    }
    return self;
}

- (void)initializeActionTemplate:(NSInteger)actionType{
    //get the template for this action
    switch (actionType) {
        case (CKTaskActionTypeDoNow):
            _actionTemplate = [[CKTaskActionDoNow alloc]initWithEmail:_email];
            break;
        case (CKTaskActionTypeDefer):
            _actionTemplate = [[CKTaskActionDefer alloc]initWithEmail:_email];
            break;
        case (CKTaskActionTypeDelegate):
            _actionTemplate = [[CKTaskActionDelegate alloc]initWithEmail:_email];
            break;
    }
    
}


@end
