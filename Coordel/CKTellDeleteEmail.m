//
//  CKTellDeleteEmail.m
//  Coordel iPhone
//
//  Created by Jeffry Gorder on 8/20/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#import "CKTellDeleteEmail.h"

@implementation CKTellDeleteEmail

- (NSString *)getSubject{
    
    NSString *subject = [NSString stringWithFormat:@"%@ : %@", @"E-mail Deleted", self.email.header.subject];
    
    return subject;
}


- (NSString *)getBody{
    
    NSString *body = @"I deleted your e-mail without action.";
    
    //if there is only the sender and no other recipients than me then just do a delete message
    //if there are several recipients, then do a remove from conversation message
    
    NSUInteger recipients = self.email.header.to.count + self.email.header.cc.count;
    
    if (recipients > 1){
        body = @"I deleted your e-mail without action. Please remove me from further copies or replies related to this subject.";
    }
    
    return [NSString stringWithFormat:@"%@ \n\n >>%@ \n\n %@", body,kLocalizedOriginalMessage, self.email.plainTextBodyRendering];
}

@end
