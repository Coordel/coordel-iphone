//
//  CKInbox.m
//  Coordel iPhone
//
//  Created by Jeffry Gorder on 8/2/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#import "AppDelegate.h"

#import "CKInbox.h"
#import "CKEmailAccount.h"
#import "MailCore/MailCore.h"

@interface CKInbox()

@property CKEmailAccount *account;
@property NSDictionary *credentials;

@end


@implementation CKInbox

- (id) init
{
    self = [super init];
    if (self){
        /*
         _credentials = [[NSDictionary alloc] initWithObjectsAndKeys:
         @"coordel.demo1@yahoo.com", @"username", @"Coordel1129", @"password", @"imap.mail.yahoo.com",  @"hostName", @"993", @"port", nil];
         */
        
        _credentials = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     @"jeffgorder@gmail.com", @"username", @"Secure1129", @"password", @"imap.gmail.com",  @"hostName", @"993", @"port", nil];
        
        _account = [[CKEmailAccount alloc]initWithCredentials:_credentials];
        
    }
    return self;
}

- (NSDate *)fetchInboxSliderDate
{
    NSDate *sliderDate = [NSDate date];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *savedDate = [defaults objectForKey:kCKUserDefaultsInboxSliderDate];
    if (savedDate){
        sliderDate = savedDate;
    }
    return sliderDate;
}


- (void)loadHeaders
{
    
    [_account loadHeaders];
    
}

- (MCOIMAPSession *)IMAPSessionForAccount:(NSString *)accountUsername
{
    return _account.session;
}

- (NSArray *)fetchHeadersFromStartDate: (NSDate *)startDate
{
    
    NSArray *headers = [_account fetchHeadersFromStartDate:startDate];
    
    return headers;
}

- (NSDate *)fetchEarliestMessageReceivedDate {
    
    NSDate *early = [_account fetchEarliestMessageReceivedDate];
    
    NSLog(@"earliest date %@", early);
    
    return early;
    
}

- (NSArray *)fetchNextInboxMessages: (int)count
{
    //NSLog(@"inboxSliderDate %@", [self fetchInboxSliderDate]);
    
    NSManagedObjectContext *moc = [(AppDelegate*)[[UIApplication sharedApplication] delegate]managedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:kCKInboxDataMessagesEntity inManagedObjectContext:moc];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:kCKInboxDataMessagesEntityReceivedDateKey ascending:YES];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(receivedDate >= %@)", [self fetchInboxSliderDate]];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    [request setSortDescriptors:@[sortDescriptor]];
    [request setFetchLimit:count];
    [request setPredicate:predicate];
    
    
    NSError *error;
    NSArray *records = [moc executeFetchRequest:request error:&error];
    if (records == nil)
    {
        // Deal with error...
        NSLog(@"error getting filtered array");
    }
    
    /*
    NSString *messageID = [[records objectAtIndex:0] valueForKey:kCKInboxDataMessagesEntityMessageIDKey];
    
    NSDate *receivedDate = [[records objectAtIndex:0] valueForKey:kCKInboxDataMessagesEntityReceivedDateKey];
    
    NSString *username = [[records objectAtIndex:0] valueForKey:kCKInboxDataMessagesEntityUsernameKey];
    
    NSString *type = [[records objectAtIndex:0] valueForKey:kCKInboxDataMessagesEntityTypeKey];
    
    NSNumber *uid = [[records objectAtIndex:0] valueForKey:kCKInboxDataMessagesEntityUIDKey];
    
    NSDictionary *record = [[NSDictionary alloc] initWithObjectsAndKeys:messageID, kCKInboxDataMessagesEntityMessageIDKey, receivedDate, kCKInboxDataMessagesEntityReceivedDateKey, username, kCKInboxDataMessagesEntityUsernameKey, type, kCKInboxDataMessagesEntityTypeKey, uid, kCKInboxDataMessagesEntityUIDKey, nil];
    
    
    NSLog(@"Records %@", record);
     */
    return records;
}

- (void)clearLocalHeaders
{

    [_account clearLocalHeaders];
}

@end
