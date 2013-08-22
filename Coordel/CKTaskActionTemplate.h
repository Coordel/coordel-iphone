//
//  CKTaskActionTemplate.h
//  Coordel iPhone
//
//  Created by Jeffry Gorder on 8/21/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#import <MailCore/MailCore.h>

@interface CKTaskActionTemplate : NSObject

@property MCOMessageParser *email;

@property (readonly) NSString *actionTitle;
@property (readonly) NSString *name;
@property (readonly) NSString *purpose;


- (id)initWithEmail: (MCOMessageParser *)email;

@end
