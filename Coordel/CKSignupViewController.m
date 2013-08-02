//
//  CKSignupViewController.m
//  Coordel iPhone
//
//  Created by Jeffry Gorder on 8/1/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#import "CKSignupViewController.h"

@interface CKSignupViewController ()

@end

@implementation CKSignupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.signUpView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coordel-logo.png"]]];
    
    [self.signUpView.signUpButton setBackgroundImage:[UIImage imageNamed:@"button-signup.png"] forState:UIControlStateNormal];
    [self.signUpView.signUpButton setBackgroundImage:[UIImage imageNamed:@"button-signup-down.png"] forState:UIControlStateHighlighted];
    [self.signUpView.signUpButton setTitle:@"Sign up" forState:UIControlStateNormal];
    [self.signUpView.signUpButton setTitle:@"Sign up" forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
