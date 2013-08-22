//
//  CKInbox.h
//  Coordel iPhone
//
//  Created by Jeffry Gorder on 8/2/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#import "MailCore/MailCore.h"



@interface CKInbox : NSObject

@property (readonly) NSDate *inboxSliderDate;


- (void)loadHeaders;
- (NSArray *)fetchHeadersFromStartDate:(NSDate *)startDate;
- (void)clearLocalHeaders;
- (NSDate *)fetchEarliestMessageReceivedDate;
- (NSDate *)fetchInboxSliderDate;
- (NSArray *)fetchNextInboxMessages: (int)count;
- (MCOIMAPSession *)IMAPSessionForAccount:(NSString *)accountUsername;


//messages
- (void)sendMessage:(MCOMessageBuilder *)builder;
- (void)archiveMessage:(NSInteger)uid toFolderName:(NSString *)folder;
- (void)deleteMessage:(NSInteger)uid;

@end
