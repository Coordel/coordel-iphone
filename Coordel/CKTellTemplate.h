//
//  CKTellTemplate.h
//  Coordel iPhone
//
//  Created by Jeffry Gorder on 8/20/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#import <MailCore/MailCore.h>
#import "CKTask.h"
#import "CKTaskAction.h"

@interface CKTellTemplate : NSObject

@property MCOMessageParser *email;
@property CKTask *task;
@property (readonly, getter = getSubject) NSString *subject;
@property (readonly, getter = getBody) NSString *body;

- (id)initWithTaskAction:(CKTaskAction *)taskAction;

@end
