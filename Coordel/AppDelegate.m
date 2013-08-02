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

//application
#import "SWRevealViewController.h"
#import "CKRevealViewController.h"
#import "CKListsViewController.h"
#import "CKTasksViewController.h"
#import "CKInboxViewController.h"
#import "CKSettingsViewController.h"

@interface AppDelegate() <SWRevealViewControllerDelegate>

@property (nonatomic, strong) CKAccessViewController *accessViewController;
@property (nonatomic, strong) CKWelcomeViewController *welcomeViewController;
@property (nonatomic, strong) CKLoginViewController *loginViewController;
@property (nonatomic, strong) CKSignupViewController *signupViewController;

@property (nonatomic, strong) CKListsViewController *listsViewController;
@property (nonatomic, strong) CKTasksViewController *tasksViewController;
@property (nonatomic, strong) CKInboxViewController *inboxViewController;
@property (nonatomic, strong) CKSettingsViewController *settingsViewController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /*********************************************************************************************/
    //Parse credentials
    [Parse setApplicationId:@"cWkn0La7kkYw980gL1AdUo4Pwljnttgoy4MeWAIq"
                  clientKey:@"2JaNT7bnrVoQ1ZLrvfRWh7BSSF8RKCC0yHnwk046"];
    
    //Parse analytics
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    /*********************************************************************************************/
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
   
    self.accessViewController = [[CKAccessViewController alloc] init];
    
    self.navController = [[UINavigationController alloc] initWithRootViewController:self.accessViewController];
    
    self.navController.navigationBarHidden = YES;
    
    self.window.rootViewController = self.navController;
    
    [self.window makeKeyAndVisible];

	return YES;

}

- (void)presentWelcomeViewController
{
    self.welcomeViewController = [[CKWelcomeViewController alloc]init];
    [self.navController pushViewController:self.welcomeViewController animated:YES];
}


- (void)presentLoginViewControllerAnimated:(BOOL)animated {
    
    //create the controller
    self.loginViewController = [[CKLoginViewController alloc] init];
    self.signupViewController  = [[CKSignupViewController alloc]init];
    [self.loginViewController setSignUpController:self.signupViewController];
    self.loginViewController.delegate = self;
    self.loginViewController.modalTransitionStyle = UIModalPresentationFullScreen;
    [self.window.rootViewController presentViewController:self.loginViewController animated:YES completion: nil];
}

- (void)presentLoginViewController {
    [self presentLoginViewControllerAnimated:YES];
}

- (void)presentSignupViewControllerAnimated:(BOOL)animated {
    
    //create the controller
    self.signupViewController = [[CKSignupViewController alloc] init];
    self.signupViewController.delegate = self;
    self.signupViewController.modalTransitionStyle = UIModalPresentationFullScreen;
    [self.window.rootViewController presentViewController:self.signupViewController animated:YES completion: nil];
}

    

- (void)presentSignupViewController
{

   [self presentSignupViewControllerAnimated:YES];
}


-(void)presentAppViewController
{
    
    CKTasksViewController *frontViewController = [[CKTasksViewController alloc] init];
    frontViewController.segmentIndex=1;
    
	CKRevealViewController *rearViewController = [[CKRevealViewController alloc] init];
	
	UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
    
    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
	
	SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
    
    revealController.delegate = self;
    
    self.window.rootViewController = revealController;

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

@end
