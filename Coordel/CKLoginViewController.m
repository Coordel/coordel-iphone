//
//  CKLoginViewController.m
//  Coordel iPhone
//
//  Created by Jeffry Gorder on 8/1/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#import "CKLoginViewController.h"

@interface CKLoginViewController ()

@property (nonatomic, strong) UIImageView *fieldsBackground;

@end

@implementation CKLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coordel-logo.png"]]];
    
    [self.logInView.signUpButton setBackgroundImage:[UIImage imageNamed:@"button-signup.png"] forState:UIControlStateNormal];
    [self.logInView.signUpButton setBackgroundImage:[UIImage imageNamed:@"button-signup-down.png"] forState:UIControlStateHighlighted];
    [self.logInView.signUpButton setTitle:@"Sign up" forState:UIControlStateNormal];
    [self.logInView.signUpButton setTitle:@"Sign up" forState:UIControlStateHighlighted];
 

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
