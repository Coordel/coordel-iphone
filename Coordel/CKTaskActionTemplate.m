//
//  CKTaskActionTemplate.m
//  Coordel iPhone
//
//  Created by Jeffry Gorder on 8/21/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#import "CKTaskActionTemplate.h"

@implementation CKTaskActionTemplate


@synthesize actionTitle = _actionTitle;
@synthesize name = _name;
@synthesize purpose = _purpose;


- (id)initWithEmail: (MCOMessageParser *)email {
    self = [super init];
    if (self){
        _email = email;
    }
    return self;
}

- (NSString *)name{
    if (self.email.header.from.displayName){
        return [NSString stringWithFormat:@"Handle e-mail request from %@", self.email.header.from.displayName];
    } else {
        return [NSString stringWithFormat:@"Handle e-mail request from %@", self.email.header.from.mailbox];
    }
}

- (NSString *)purpose{
    if (self.email.header.from.displayName){
        return [NSString stringWithFormat:@"Do work requested in attached email from %@ on %@. Original e-mail subject: %@", self.email.header.from.displayName, [CKUtility formattedDate:self.email.header.receivedDate], self.email.header.subject];
    } else {
        return [NSString stringWithFormat:@"Do work requested in attached email from %@ on %@. Original e-mail subject: %@", self.email.header.from.mailbox, [CKUtility formattedDate:self.email.header.receivedDate], self.email.header.subject];
    }
    
    
}


@end
