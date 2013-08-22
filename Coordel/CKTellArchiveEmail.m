//
//  CKTellArchiveEmail.m
//  Coordel iPhone
//
//  Created by Jeffry Gorder on 8/20/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#import "CKTellArchiveEmail.h"

@implementation CKTellArchiveEmail

- (NSString *)getSubject{
    
    NSString *subject = [NSString stringWithFormat:@"%@ : %@", @"E-mail Archived", self.email.header.subject];
    
    return subject;
}


- (NSString *)getBody{
    
    NSString *body = @"I read and archived your e-mail.";
    
    
    return [NSString stringWithFormat:@"%@ \n\n >>%@ \n\n %@", body,kLocalizedOriginalMessage, self.email.plainTextBodyRendering];
}


@end
