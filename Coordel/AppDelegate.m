//
//  AppDelegate.m
//  Coordel
//
//  Created by Jeffry Gorder on 7/26/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#import "AppDelegate.h"

//welcome,login,signup
#import "CKAccessViewController.h"
#import "CKLoginViewController.h"
#import "CKSignupViewController.h"
#import "CKWelcomeViewController.h"

//application controllers
#import "SWRevealViewController.h"
#import "CKRevealViewController.h"
#import "CKListsSegmentViewController.h"
#import "CKTasksSegmentViewController.h"
#import "CKInboxViewController.h"
#import "CKSettingsViewController.h"
#import "CKInboxPlayViewController.h"

//application model
#import "CKInbox.h"
#import "CKTask.h"
#import "CKList.h"
#import "CKUser.h"

@interface AppDelegate() <SWRevealViewControllerDelegate>

@property (nonatomic, strong) CKAccessViewController *accessViewController;
@property (nonatomic, strong) CKWelcomeViewController *welcomeViewController;
@property (nonatomic, strong) CKLoginViewController *loginViewController;
@property (nonatomic, strong) CKSignupViewController *signupViewController;
@property (nonatomic, strong) SWRevealViewController *revealController;


@property (nonatomic, strong) CKInboxPlayViewController *inboxPlayViewController;


//properties for inbox batch play
@property NSArray *inboxPlayBatch;

@end

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //Parse subclasses
    
    [CKTask registerSubclass];
    [CKList registerSubclass];
    [CKUser registerSubclass];
    /*********************************************************************************************/
    //Parse credentials
    [Parse setApplicationId:@"cWkn0La7kkYw980gL1AdUo4Pwljnttgoy4MeWAIq"
                  clientKey:@"2JaNT7bnrVoQ1ZLrvfRWh7BSSF8RKCC0yHnwk046"];
    
    // ****************************************************************************
    // Create or Login a user
    // ****************************************************************************
    /*
     Feel free to modify this section or extend the application to include a login and register screen.
     This little piece of code will create a new user called Matt. If this user already exists, it will simply
     log Matt into the app. This is not the typical behaviour you would want, but it will allow you to play
     with object relationships without having to worry too much about user management. To learn more about
     the PFUser class take a look at the documentation here https://www.parse.com/docs/ios_guide#users
     */
    
    CKUser *user = [CKUser object];
    user.username = @"jeffgorder";
    user.password = @"password";
    user.email = @"jeffgorder@gmail.com";
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
        } else {
            //add a default private list
            
            [PFUser logInWithUsername:@"jeffgorder" password:@"password"];
        }
    }];
    
    //Parse analytics
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    /*********************************************************************************************/
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    
    //load the inbox
    [self initializeModel];
    [self initializeRevealController];
   
    _accessViewController = [[CKAccessViewController alloc] init];
    
    _navController = [[UINavigationController alloc] initWithRootViewController:self.accessViewController];
    
    _navController.navigationBarHidden = YES;
    
    [self presentAppSegment];
    self.window.rootViewController = _revealController;
    
    [self.window makeKeyAndVisible];

	return YES;

}

/*
- (void)updateFrontNavigationController: (int)segmentIndex
{
    
    
    //choose the navigation controller based on the segment index
    switch (segmentIndex) {
        case 0:
            _frontNavigationController = [[UINavigationController alloc] initWithRootViewController:_listsViewController];
            break;
        case 1:
            _frontNavigationController = [[UINavigationController alloc] initWithRootViewController:_tasksViewController];
            break;
            
        case 2:
            _frontNavigationController = [[UINavigationController alloc] initWithRootViewController:_inboxViewController];
            break;
            
        default:
            break;
    }
    
    
}
 */

- (void)initializeRevealController
{
    _segmentIndex = 1;
        
    CKTasksSegmentViewController *frontViewController = [[CKTasksSegmentViewController alloc] init];
	CKRevealViewController *rearViewController = [[CKRevealViewController alloc] init];
	
	UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
    
	_revealController = [[SWRevealViewController alloc] initWithRearViewController:rearViewController frontViewController:frontNavigationController];
    
    _revealController.delegate = self;

}

- (void)initializeModel
{

    _inbox = [[CKInbox alloc]init];
    
    //set up the batch size
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userBatchSize = [defaults objectForKey:kCKUserDefaultsInboxPlayBatchSize];
    _inboxPlayBatchSize = 10;
    if (userBatchSize){
        _inboxPlayBatchSize = [userBatchSize intValue];
    }
    NSLog(@"batch size %d ", _inboxPlayBatchSize);

    //[_inbox clearLocalHeaders];

    //[_inbox loadHeaders];
        
}

- (void)presentWelcomeViewController
{
    _welcomeViewController = [[CKWelcomeViewController alloc]init];
    [_navController pushViewController:_welcomeViewController animated:YES];
}


- (void)presentLoginViewControllerAnimated:(BOOL)animated {
    
    //create the controller
    _loginViewController = [[CKLoginViewController alloc] init];
    _signupViewController  = [[CKSignupViewController alloc]init];
    [_loginViewController setSignUpController:_signupViewController];
    _loginViewController.delegate = self;
    _loginViewController.modalTransitionStyle = UIModalPresentationFullScreen;
    [self.window.rootViewController presentViewController:_loginViewController animated:YES completion: nil];
}

- (void)presentLoginViewController {
    [self presentLoginViewControllerAnimated:YES];
}

- (void)presentSignupViewControllerAnimated:(BOOL)animated {
    
    //create the controller
    _signupViewController = [[CKSignupViewController alloc] init];
    _signupViewController.delegate = self;
    _signupViewController.modalTransitionStyle = UIModalPresentationFullScreen;
    [self.window.rootViewController presentViewController:_signupViewController animated:YES completion: nil];
}

- (void)presentSignupViewController
{

   [self presentSignupViewControllerAnimated:YES];
}



-(void)presentAppViewController
{
    
    [self presentAppSegment];
    self.window.rootViewController = _revealController;


}


- (void)presentAppSegment
{
    UINavigationController *navigationController;
    
    if (_segmentIndex == 0){
        CKListsSegmentViewController *listControl = [[CKListsSegmentViewController alloc]init];
        listControl.segmentIndex = 0;
        navigationController = [[UINavigationController alloc] initWithRootViewController:listControl];
    } else if (_segmentIndex == 1){
        CKTasksSegmentViewController *taskControl = [[CKTasksSegmentViewController alloc]init];
        taskControl.segmentIndex = 1;
        navigationController = [[UINavigationController alloc] initWithRootViewController:taskControl];
        
    } else if (_segmentIndex == 2){
        CKInboxViewController *inboxControl = [[CKInboxViewController alloc]init];
        inboxControl.segmentIndex = 2;
        navigationController = [[UINavigationController alloc] initWithRootViewController:inboxControl];
    }

    [_revealController setFrontViewController:navigationController animated:NO];

}

- (void)presentInboxPlayViewController
{
    //create the controller
    _inboxPlayViewController = [[CKInboxPlayViewController alloc] init];
    _inboxPlayViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.window.rootViewController presentViewController:_inboxPlayViewController animated:YES completion: nil];

}

#pragma Inbox Play
/*
 This sets up a dictionary of play options used by the controller
 */
- (void)inboxPlayStarted
{
    _inboxPlayCount = 0;
    //log that play started
    
        
    //fetch a batch from the inbox
    _inboxPlayBatch = [_inbox fetchNextInboxMessages:_inboxPlayBatchSize];
}

- (id)inboxPlayGetNextMessage
{
    id next = [_inboxPlayBatch objectAtIndex:_inboxPlayCount];
    _inboxPlayCount += 1;
    return next;
}

- (void)inboxPlayCancelled
{
    _inboxPlayCount = 0;
    //log that the user cancelled play
    //subtract points
    _inboxPlayBatch = nil;
    
}

- (void)inboxPlayCompleted
{
    _inboxPlayCount = 0;
    //log that the user completed a batch
    //increase points
    _inboxPlayBatch = nil;
    
}


- (void)logout
{
  
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"InboxData" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"InboxData.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
