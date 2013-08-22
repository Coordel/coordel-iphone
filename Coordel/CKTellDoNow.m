//
//  CKTellDoNow.m
//  Coordel iPhone
//
//  Created by Jeffry Gorder on 8/20/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#import "CKTellDoNow.h"

@implementation CKTellDoNow


- (NSString *)getSubject{
    
    NSString *subject = [NSString stringWithFormat:@"%@ : %@", @"Task Done", self.email.header.subject];
    
    return subject;
}


- (NSString *)getBody{
    
    
    NSMutableString *body = [[NSMutableString alloc]init];
    
    //tell what you did
    [body appendString:@"I completed what you requested in the e-mail you sent on "];
    
    //append email send date of email
    [body appendString:[CKUtility formattedDate:self.email.header.receivedDate]];
    
    //append line space
    [body appendString:@"\n\n"];
    
    //append original message line
    [body appendString:kLocalizedOriginalMessage];
    
    //append line space
    [body appendString:@"\n\n"];
    
    //append original message
    [body appendString:self.email.plainTextBodyRendering];
    
    return [NSString stringWithString:body];
}

@end
