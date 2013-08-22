//
//  CKTaskAction.h
//  Coordel iPhone
//
//  Created by Jeffry Gorder on 8/10/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//


#import <MailCore/MailCore.h>
#import "CKTask.h"
#import "CKTaskActionTemplate.h"



@interface CKTaskAction : NSObject


@property NSInteger actionType;
@property CKTask *task;
@property MCOMessageParser *email;
@property NSInteger emailUID;
@property CKTaskActionTemplate *actionTemplate;




//if there is an existing task for this action, init with that task
- (id)initWithTask: (CKTask *)task forAction:(NSInteger)actionType;

//if this is an email action, init with the email
- (id)initWithEmail: (MCOMessageParser *)email forAction:(NSInteger)actionType withUID:(NSInteger)uid;



@end
