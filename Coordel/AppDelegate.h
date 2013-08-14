//
//  AppDelegate.h
//  Coordel
//
//  Created by Jeffry Gorder on 7/26/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#import "CKInbox.h"



@interface AppDelegate : UIResponder < UIApplicationDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UINavigationController *navController;
@property int segmentIndex;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) CKInbox *inbox;
@property int inboxPlayBatchSize;
@property int inboxPlayCount;



- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


//application
- (void)presentWelcomeViewController;
- (void)presentLoginViewController;
- (void)presentLoginViewControllerAnimated:(BOOL)animated;
- (void)presentSignupViewController;
- (void)presentAppViewController;
- (void)presentAppSegment;
- (void)presentInboxPlayViewController;

//inbox play
- (void)inboxPlayStarted;
- (void)inboxPlayCancelled;
- (void)inboxPlayCompleted;
- (id)inboxPlayGetNextMessage;



@end

