//
//  CKEmailAccount.h
//  Coordel iPhone
//
//  Created by Jeffry Gorder on 7/31/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

/** 
 The CKEmailAccount model object is used to manage a user's IMAP mail account.
 
 It uses the keychain to store credentials so that the user doesn't have to login over and over again...for ios7 it will be kept in the cloud keychain so it can be synced across devices.
 
 */


#import "MailCore/MailCore.h"

@interface CKEmailAccount : NSObject

@property MCOIMAPSession *session;

- (id)initWithCredentials:(NSDictionary *)credentials;

//accounts
/*
- (void)createAccount;
- (void)updateAccount;
- (void)deleteAccount;
*/

//headers
- (void)loadHeaders;
- (void)saveHeadersLocally:(NSArray *)headers;
- (void)clearLocalHeaders;
- (NSArray *)fetchHeadersFromStartDate:(NSDate *)startDate;
- (NSDate *)fetchEarliestMessageReceivedDate;

//messages

- (void)sendMessage:(MCOMessageBuilder *)builder;
- (void)archiveMessage:(NSInteger)uid toFolderName:(NSString *)folder;
- (void)deleteMessage:(NSInteger)uid;
//- (void)loadMessagesFromHeaders:(NSArray *)headers;


@end
