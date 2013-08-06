//
//  CKEmailAccount.m
//  Coordel iPhone
//
//  Created by Jeffry Gorder on 7/31/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#import "AppDelegate.h"



#import "CKEmailAccount.h"
#import "MailCore/MailCore.h"


@interface CKEmailAccount() <MCOHTMLRendererIMAPDelegate>

@property NSString *folder;
//@property MCOIMAPSession *session; //need to open the session on initialization
@property MCOIMAPFolderInfo *inboxFolderInfo;
@property NSMutableArray *headersStore; //holds all the headers
@property NSDictionary *credentials;

@property NSString *username;

@end


@implementation CKEmailAccount

-(id)initWithCredentials: (NSDictionary *)credentials{
    self = [super init];
    if (self){
        self.folder = @"INBOX";
        self.credentials = credentials;
        
        
        NSLog(@"Loading INBOX with credentials %@", credentials);

        //overriding init so that the email session can be started and headers loaded with the credentials
    
        self.session = [[MCOIMAPSession alloc]init];
        
        MCOIMAPFolderInfo *latestInfo = [[MCOIMAPFolderInfo alloc]init];//get from NSUserDefaults
        
        [self.session setHostname:[credentials valueForKey:@"hostName"]];
        [self.session setPort: [[credentials valueForKey:@"port"]intValue]];
        [self.session setUsername:[credentials valueForKey:@"username"]];
        [self.session setPassword:[credentials valueForKey:@"password"]];
        [self.session setConnectionType:MCOConnectionTypeTLS];
        
        self.username = [credentials valueForKey:@"username"];

        
        //open session for the account and store in the accountSession. load the headers 
        MCOIMAPFolderInfoOperation *info = [self.session folderInfoOperation:self.folder];
        
        [info start:^(NSError *error, MCOIMAPFolderInfo *info){
            NSLog(@"Loaded INBOX Info %@", info);
            
            if (latestInfo.uidNext != info.uidNext){
                NSLog(@"Different UID Next latest:%u new:%u", latestInfo.uidNext, info.uidNext);
                //reload
            } else if (latestInfo.uidValidity != info.uidValidity){
                NSLog(@"Different UID Validity latest:%u new:%u", latestInfo.uidValidity, info.uidValidity);
                //reload
            } else if (latestInfo.messageCount != info.messageCount){
                NSLog(@"Different UID Next latest:%d new:%d", latestInfo.messageCount, info.messageCount);
                //reload
            }
            
            self.inboxFolderInfo = info;
         
        }];
        
    }
    return self;
}


/*
//this function takes the account credentials, tests to make sure they are good, then calls the did create account
- (void)createAccount:(NSString *)username password:(NSString *)password  hostName:(NSString *)host port:(NSInteger *)port
{
    //test that the credentials actually work
    
    
    //if they worked, then save the account to an email accounts dictionary in NSUserDefaults
    
    //load the headers
 
    // make sure the user doesn't already have this account set up
        
}

- (void)updateAccount:(NSString *)email password:(NSString *)password  host:(NSString *)host port:(NSInteger *)port
{
    
}

- (void)deleteAccount:(NSString *)email
{
    
}
 */

/*
#pragma email actions
- (void) sendEmailMessage
{
    
}

- (void) archiveMessage: (MCOIMAPMessage *)msg toFolderName:(NSString *)folder
{
    //after every inbox action, the original message should be moved out of the inbox into an archive folder
}
*/

#pragma email headers management
- (void)loadHeaders
{
    //loads headers for this account and saves them locally
    MCOIMAPSession *session = self.session;
    
       
    MCOIMAPMessagesRequestKind requestKind = (MCOIMAPMessagesRequestKind)
    (MCOIMAPMessagesRequestKindHeaders);
    
    
    MCOIndexSet *uids = [MCOIndexSet indexSetWithRange:MCORangeMake(1, UINT64_MAX)];
    
    
    MCOIMAPFetchMessagesOperation *fetchOperation = [session fetchMessagesByUIDOperationWithFolder:self.folder requestKind:requestKind uids:uids];
    
    [fetchOperation start:^(NSError * error, NSArray * fetchedMessages, MCOIndexSet * vanishedMessages) {
        //We've finished downloading the messages!
        
        //Let's check if there was an error:
        if(error) {
            NSLog(@"Error downloading message headers:%@", error);
        }
        
        
        [self saveHeadersLocally:fetchedMessages];
        
    }];
    
}

- (NSDate *)fetchEarliestMessageReceivedDate
{
    NSManagedObjectContext *moc = [(AppDelegate*)[[UIApplication sharedApplication] delegate]managedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:kCKInboxDataMessagesEntity inManagedObjectContext:moc];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:kCKInboxDataMessagesEntityReceivedDateKey ascending:YES];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    [request setSortDescriptors:@[sortDescriptor]];

    
    
    NSError *error;
    NSArray *records = [moc executeFetchRequest:request error:&error];
    if (records == nil)
    {
        // Deal with error...
        NSLog(@"error getting filtered array");
    }
    
    NSDate *earliest = [NSDate date];
    
    if ([records count]>0){
        //NSLog(@"records %@", [records objectAtIndex:0]);
        earliest = [[records objectAtIndex:0] valueForKey:kCKInboxDataMessagesEntityReceivedDateKey];
    }
    
    NSLog(@"earliest date %@", earliest);
    
    return earliest;    
}

//use this function to get the headers that arrived on or after a given start date
- (NSArray *)fetchHeadersFromStartDate: (NSDate *)startDate
{
    //checks to see if the headers for this account are available locally
    //if they aren't available locally, loads them and saves them locally
    NSManagedObjectContext *moc = [(AppDelegate*)[[UIApplication sharedApplication] delegate]managedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:kCKInboxDataMessagesEntity inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    // Set example predicate and sort orderings...
   
     NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(receivedDate >= %@)", startDate];
    
    [request setPredicate:predicate];
    
    
    NSError *error;
    NSArray *filteredArray = [moc executeFetchRequest:request error:&error];
    if (filteredArray == nil)
    {
        // Deal with error...
        NSLog(@"error getting filtered array");
    }
    
    //NSLog(@"returning array with %d records", filteredArray.count);
    return filteredArray;   
}

- (void)addHeader:(MCOMessageHeader *)header withUID:(NSNumber *)uid{
    
    //NSLog(@"header to add %@", header);
    
    
    NSManagedObjectContext *context = [(AppDelegate*)[[UIApplication sharedApplication] delegate]managedObjectContext];
    NSManagedObject *newHeader;
    newHeader = [NSEntityDescription
                 insertNewObjectForEntityForName:kCKInboxDataMessagesEntity
                 inManagedObjectContext:context];
    [newHeader setValue: header.receivedDate forKey:kCKInboxDataMessagesEntityReceivedDateKey];
    [newHeader setValue: header.messageID forKey:kCKInboxDataMessagesEntityMessageIDKey];
    [newHeader setValue: uid  forKey:kCKInboxDataMessagesEntityUIDKey];
    [newHeader setValue: self.username forKey:kCKInboxDataMessagesEntityUsernameKey];
    
    NSError *error;
    [context save:&error];

}

- (void)saveHeadersLocally: (NSArray *)messages
{
    
     NSManagedObjectContext *context = [(AppDelegate*)[[UIApplication sharedApplication] delegate]managedObjectContext];
    
    for (MCOIMAPMessage *message in messages){
        //[self addHeader:h];
        NSLog(@"messageid %@", message.header);
       
        NSManagedObject *newHeader;
        newHeader = [NSEntityDescription
                     insertNewObjectForEntityForName:kCKInboxDataMessagesEntity
                     inManagedObjectContext:context];
        [newHeader setValue: message.header.receivedDate forKey:kCKInboxDataMessagesEntityReceivedDateKey];
        [newHeader setValue: message.header.messageID forKey:kCKInboxDataMessagesEntityMessageIDKey];
        [newHeader setValue: [NSNumber numberWithInt:message.uid] forKey:kCKInboxDataMessagesEntityUIDKey];
        [newHeader setValue: self.username forKey:kCKInboxDataMessagesEntityUsernameKey];

    }
    
    NSError *error;
    [context save:&error];
            
}

- (void)clearLocalHeaders
{
    NSManagedObjectContext *context = [(AppDelegate*)[[UIApplication sharedApplication] delegate]managedObjectContext];
    
    NSFetchRequest * allHeaders = [[NSFetchRequest alloc] init];
    
    [allHeaders setEntity:[NSEntityDescription entityForName:kCKInboxDataMessagesEntity inManagedObjectContext:context]];
    
    [allHeaders setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * headers = [context executeFetchRequest:allHeaders error:&error];

    //error handling goes here
    for (NSManagedObject * header in headers) {
        [context deleteObject:header];
    }
    NSError *saveError = nil;
    [context save:&saveError];
    //more error handling here
}


@end
