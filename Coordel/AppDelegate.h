//
//  AppDelegate.h
//  Coordel
//
//  Created by Jeffry Gorder on 7/26/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//


@interface AppDelegate : UIResponder < UIApplicationDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) UINavigationController *navController;



- (void)presentWelcomeViewController;
- (void)presentLoginViewController;
- (void)presentLoginViewControllerAnimated:(BOOL)animated;
- (void)presentSignupViewController;
- (void)presentAppViewController;

@end

