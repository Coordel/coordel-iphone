//
//  AppDelegate.m
//  Coordel
//
//  Created by Jeffry Gorder on 7/26/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#import "AppDelegate.h"

#import "SWRevealViewController.h"

#import "CKRevealViewController.h"
#import "CKListsViewController.h"
#import "CKTasksViewController.h"
#import "CKInboxViewController.h"
#import "CKSettingsViewController.h"

@interface AppDelegate()<SWRevealViewControllerDelegate>
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
    
    CKTasksViewController *frontViewController = [[CKTasksViewController alloc] init];
    frontViewController.segmentIndex=1;
	CKRevealViewController *rearViewController = [[CKRevealViewController alloc] init];
	
	UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
	
	SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
    
    revealController.delegate = self;
    
    self.viewController = revealController;
	
	self.window.rootViewController = self.viewController;
    
	[self.window makeKeyAndVisible];
	return YES;

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
