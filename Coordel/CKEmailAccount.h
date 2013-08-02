//
//  CKEmailAccount.h
//  Coordel iPhone
//
//  Created by Jeffry Gorder on 7/31/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

/** 
 The CKEmailAccount model object is used to manage the users IMAP mail accounts.
 
 It uses the keychain to store credentials so that the user doesn't have to login
 over and over again across devices...for ios7 it will be kept in the cloud.
 
 */

#import <Foundation/Foundation.h>

@interface CKEmailAccount : NSObject

@property NSString *username;
@property NSString *password;
@property NSString *host;
@property int port;

-(void)credentialsDidPass;
-(void)create;
-(void)update;

-(void)headersDidLoad;



@end
