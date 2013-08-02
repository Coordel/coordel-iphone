//
//  CKAccessViewController.m
//  Coordel iPhone
//
//  Created by Jeffry Gorder on 8/1/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#import "CKAccessViewController.h"
#import "AppDelegate.h"
#import "CKWelcomeViewController.h"

@interface CKAccessViewController ()

@end

@implementation CKAccessViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    /*(
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL afterFirst = [defaults boolForKey:kCKUserDefaultsAfterFirstLaunch];
     
    */
    
    BOOL afterFirst;
    afterFirst = NO;
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] presentAppViewController];
    
    /*

    if (!afterFirst){
        //if haven't launched before, then need to show the welcome controller
        //[defaults setObject:YES forKey:kCKUserDefaultsAfterFirstLaunch];
        [(AppDelegate*)[[UIApplication sharedApplication]delegate] presentWelcomeViewController];
        
    } else {
        //see if this is an existing user or present the login
        // If not logged in, present login view controller
        if (![PFUser currentUser]) {
            [(AppDelegate*)[[UIApplication sharedApplication] delegate] presentLoginViewControllerAnimated:NO];
            return;
        }
        // Present Coordel UI
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] presentAppViewController];
        
    }
     */
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
